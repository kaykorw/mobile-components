// AppCalendar: Flutter counterpart of React <Calendar>.
//
// API mapping (React -> Flutter):
//   <Calendar mode="single" ...>   -> AppCalendar.single(...)
//   <Calendar mode="range" ...>    -> AppCalendar.range(...)
//   value / defaultValue           -> selectedDate / selectedRange
//   onChange                       -> onChanged
//   minDate, maxDate, isDateDisabled, weekStartsOn: same names and values
//   defaultMonth                   -> initialMonth
//   locale                         -> from the app's Localizations
//
// Same behaviour as React: 6-week grid (height never jumps), range = first
// click sets the start, second sets the end (swapped if earlier), next click
// starts a new range; hover/keyboard focus previews the range; 304 px wide.
//
// Keyboard (once the grid has focus via Tab): arrows move by day/week,
// Home/End jump to the start/end of the week, Page Up/Down change month
// (with Shift: year), Enter or Space selects.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Same values as the React `mode` prop.
enum AppCalendarMode { single, range }

/// First column of the grid. Same values as the React `weekStartsOn` prop.
enum AppCalendarWeekStart { monday, sunday }

/// A range whose [end] is null while only the first day has been picked.
/// Same shape as the React `DateRange`.
@immutable
class AppDateRange {
  const AppDateRange({this.start, this.end});

  final DateTime? start;
  final DateTime? end;

  bool get isComplete => start != null && end != null;

  @override
  bool operator ==(Object other) =>
      other is AppDateRange &&
      DateUtils.isSameDay(other.start, start) &&
      DateUtils.isSameDay(other.end, end);

  @override
  int get hashCode => Object.hash(_dayOrNull(start), _dayOrNull(end));

  @override
  String toString() => 'AppDateRange($start - $end)';
}

DateTime? _dayOrNull(DateTime? date) => date == null ? null : DateUtils.dateOnly(date);

class AppCalendar extends StatefulWidget {
  /// Pick one day.
  const AppCalendar.single({
    super.key,
    this.selectedDate,
    ValueChanged<DateTime>? onChanged,
    this.minDate,
    this.maxDate,
    this.isDateDisabled,
    this.weekStartsOn = AppCalendarWeekStart.monday,
    this.initialMonth,
  })  : mode = AppCalendarMode.single,
        onDateChanged = onChanged,
        selectedRange = null,
        onRangeChanged = null;

  /// Pick a start and an end day. [onChanged] is called after every tap:
  /// first with `end == null`, then with the complete range.
  const AppCalendar.range({
    super.key,
    this.selectedRange,
    ValueChanged<AppDateRange>? onChanged,
    this.minDate,
    this.maxDate,
    this.isDateDisabled,
    this.weekStartsOn = AppCalendarWeekStart.monday,
    this.initialMonth,
  })  : mode = AppCalendarMode.range,
        onRangeChanged = onChanged,
        selectedDate = null,
        onDateChanged = null;

  final AppCalendarMode mode;

  /// Selected day in single mode. When the parent passes a different day,
  /// the calendar follows it.
  final DateTime? selectedDate;

  /// Selected range in range mode. When the parent passes a different range,
  /// the calendar follows it.
  final AppDateRange? selectedRange;

  final ValueChanged<DateTime>? onDateChanged;
  final ValueChanged<AppDateRange>? onRangeChanged;

  /// Earliest day that can be picked.
  final DateTime? minDate;

  /// Latest day that can be picked.
  final DateTime? maxDate;

  /// Return true to block a day, e.g. weekends or public holidays.
  final bool Function(DateTime date)? isDateDisabled;

  final AppCalendarWeekStart weekStartsOn;

  /// Month shown first. Defaults to the selected day's month, or today.
  final DateTime? initialMonth;

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  static const double _cellSize = 40;
  static const double _daySize = 36;
  static const double _padding = 12;

  /// Both modes are stored as a range; single mode uses start == end.
  late AppDateRange _selection;

  /// First day of the visible month.
  late DateTime _month;

  /// Day that keyboard navigation starts from.
  late DateTime _focusedDay;

  /// Day under the mouse, for the range preview.
  DateTime? _hoveredDay;

  final FocusNode _gridFocusNode = FocusNode(debugLabel: 'AppCalendar grid');
  bool _gridHasFocus = false;

  DateTime get _today => DateUtils.dateOnly(DateTime.now());
  DateTime? get _min => _dayOrNull(widget.minDate);
  DateTime? get _max => _dayOrNull(widget.maxDate);
  bool get _isRange => widget.mode == AppCalendarMode.range;

  @override
  void initState() {
    super.initState();
    _selection = _selectionFromWidget();
    final anchor = widget.initialMonth ?? _selection.start ?? _clamp(_today);
    _month = DateTime(anchor.year, anchor.month);
    _focusedDay = _firstFocusIn(_month);
  }

  /// Where keyboard focus starts in [month]: the selected day, else today,
  /// else the first day of the month (kept inside min/max).
  DateTime _firstFocusIn(DateTime month) {
    bool inMonth(DateTime day) => day.year == month.year && day.month == month.month;
    final start = _selection.start;
    if (start != null && inMonth(start)) return start;
    if (inMonth(_today)) return _clamp(_today);
    return _clamp(month);
  }

  @override
  void didUpdateWidget(AppCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed = oldWidget.mode != widget.mode ||
        !DateUtils.isSameDay(oldWidget.selectedDate, widget.selectedDate) ||
        oldWidget.selectedRange != widget.selectedRange;
    if (changed) _selection = _selectionFromWidget();
  }

  @override
  void dispose() {
    _gridFocusNode.dispose();
    super.dispose();
  }

  AppDateRange _selectionFromWidget() => switch (widget.mode) {
        AppCalendarMode.single => AppDateRange(
            start: _dayOrNull(widget.selectedDate),
            end: _dayOrNull(widget.selectedDate),
          ),
        AppCalendarMode.range => AppDateRange(
            start: _dayOrNull(widget.selectedRange?.start),
            end: _dayOrNull(widget.selectedRange?.end),
          ),
      };

  // ---------------------------------------------------------------- dates

  static DateTime _addDays(DateTime day, int days) => DateTime(day.year, day.month, day.day + days);

  /// Same day number in another month, clamped (31 Jan + 1 month = 28/29 Feb).
  static DateTime _addMonthsClamped(DateTime day, int months) {
    final target = DateTime(day.year, day.month + months);
    final lastDay = DateUtils.getDaysInMonth(target.year, target.month);
    return DateTime(target.year, target.month, math.min(day.day, lastDay));
  }

  int _column(DateTime day) => switch (widget.weekStartsOn) {
        AppCalendarWeekStart.monday => day.weekday - 1, // weekday: Mon = 1 ... Sun = 7
        AppCalendarWeekStart.sunday => day.weekday % 7,
      };

  bool _isDisabled(DateTime day) {
    final min = _min;
    final max = _max;
    if (min != null && day.isBefore(min)) return true;
    if (max != null && day.isAfter(max)) return true;
    return widget.isDateDisabled?.call(day) ?? false;
  }

  DateTime _clamp(DateTime day) {
    final min = _min;
    final max = _max;
    if (min != null && day.isBefore(min)) return min;
    if (max != null && day.isAfter(max)) return max;
    return day;
  }

  static AppDateRange _ordered(DateTime a, DateTime b) =>
      b.isBefore(a) ? AppDateRange(start: b, end: a) : AppDateRange(start: a, end: b);

  static AppDateRange _nextRange(AppDateRange current, DateTime day) {
    final start = current.start;
    if (start == null || current.end != null) return AppDateRange(start: day);
    return _ordered(start, day);
  }

  /// 42 cells (6 weeks); null outside the month.
  List<DateTime?> _gridDays() {
    final offset = _column(_month);
    final total = DateUtils.getDaysInMonth(_month.year, _month.month);
    return List<DateTime?>.generate(42, (i) {
      final day = i - offset + 1;
      return (day < 1 || day > total) ? null : DateTime(_month.year, _month.month, day);
    });
  }

  bool get _isPending => _isRange && _selection.start != null && _selection.end == null;

  /// Selection plus the hover/keyboard preview while a range waits for its end.
  AppDateRange get _shownRange {
    final start = _selection.start;
    final preview = _hoveredDay ?? (_gridHasFocus ? _focusedDay : null);
    if (_isPending && start != null && preview != null) return _ordered(start, preview);
    return _selection;
  }

  // -------------------------------------------------------------- actions

  void _select(DateTime day) {
    if (_isDisabled(day)) return;
    final next = _isRange ? _nextRange(_selection, day) : AppDateRange(start: day, end: day);
    setState(() {
      _focusedDay = day;
      _selection = next;
      _hoveredDay = null;
    });
    if (_isRange) {
      widget.onRangeChanged?.call(next);
    } else {
      widget.onDateChanged?.call(day);
    }
  }

  void _changeMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
      _focusedDay = _clamp(_addMonthsClamped(_focusedDay, delta));
    });
  }

  void _moveFocusTo(DateTime day) {
    final target = _clamp(day);
    setState(() {
      _focusedDay = target;
      _month = DateTime(target.year, target.month);
    });
  }

  /// Keyboard map for the grid. Uses CallbackShortcuts rather than
  /// Focus.onKeyEvent, which packages on a Dart language version below 3.12
  /// can't pass (it's a private named parameter in the SDK).
  Map<ShortcutActivator, VoidCallback> _keyBindings() {
    void move(DateTime Function(DateTime from) to) => _moveFocusTo(to(_focusedDay));
    void select() => _select(_focusedDay);
    return <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.arrowLeft): () => move((d) => _addDays(d, -1)),
      const SingleActivator(LogicalKeyboardKey.arrowRight): () => move((d) => _addDays(d, 1)),
      const SingleActivator(LogicalKeyboardKey.arrowUp): () => move((d) => _addDays(d, -7)),
      const SingleActivator(LogicalKeyboardKey.arrowDown): () => move((d) => _addDays(d, 7)),
      const SingleActivator(LogicalKeyboardKey.home): () => move((d) => _addDays(d, -_column(d))),
      const SingleActivator(LogicalKeyboardKey.end): () => move((d) => _addDays(d, 6 - _column(d))),
      const SingleActivator(LogicalKeyboardKey.pageUp): () => move((d) => _addMonthsClamped(d, -1)),
      const SingleActivator(LogicalKeyboardKey.pageDown): () => move((d) => _addMonthsClamped(d, 1)),
      const SingleActivator(LogicalKeyboardKey.pageUp, shift: true): () =>
          move((d) => _addMonthsClamped(d, -12)),
      const SingleActivator(LogicalKeyboardKey.pageDown, shift: true): () =>
          move((d) => _addMonthsClamped(d, 12)),
      const SingleActivator(LogicalKeyboardKey.enter): select,
      const SingleActivator(LogicalKeyboardKey.numpadEnter): select,
      const SingleActivator(LogicalKeyboardKey.space): select,
    };
  }

  // ---------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final localizations = MaterialLocalizations.of(context);

    final min = _min;
    final max = _max;
    final canGoBack = min == null || !DateTime(_month.year, _month.month, 0).isBefore(min);
    final canGoForward = max == null || !DateTime(_month.year, _month.month + 1).isAfter(max);

    // narrowWeekdays always starts on Sunday.
    final firstColumn = widget.weekStartsOn == AppCalendarWeekStart.monday ? 1 : 0;
    final weekdayLabels = List<String>.generate(
      7,
      (i) => localizations.narrowWeekdays[(firstColumn + i) % 7],
    );

    final monthTitle = localizations.formatMonthYear(_month);
    final days = _gridDays();
    final shown = _shownRange;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: _cellSize * 7 + _padding * 2,
        padding: const EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: month title + previous/next.
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        monthTitle.isEmpty
                            ? monthTitle
                            : monthTitle[0].toUpperCase() + monthTitle.substring(1),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                  _NavButton(
                    icon: Icons.chevron_left,
                    tooltip: localizations.previousMonthTooltip,
                    onPressed: canGoBack ? () => _changeMonth(-1) : null,
                  ),
                  const SizedBox(width: 4),
                  _NavButton(
                    icon: Icons.chevron_right,
                    tooltip: localizations.nextMonthTooltip,
                    onPressed: canGoForward ? () => _changeMonth(1) : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Weekday labels.
            ExcludeSemantics(
              child: Row(
                children: [
                  for (final label in weekdayLabels)
                    SizedBox(
                      width: _cellSize,
                      height: 32,
                      child: Center(
                        child: Text(
                          label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Day grid.
            CallbackShortcuts(
              bindings: _keyBindings(),
              child: Focus(
                focusNode: _gridFocusNode,
                onFocusChange: (hasFocus) => setState(() => _gridHasFocus = hasFocus),
                child: MouseRegion(
                  onExit: (_) => setState(() => _hoveredDay = null),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var week = 0; week < 6; week++)
                        Row(
                          children: [
                            for (var col = 0; col < 7; col++)
                              _buildDay(context, days[week * 7 + col], shown),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDay(BuildContext context, DateTime? day, AppDateRange shown) {
    if (day == null) return const SizedBox.square(dimension: _cellSize);

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final localizations = MaterialLocalizations.of(context);

    final start = shown.start;
    final end = shown.end;
    final isPreview = !identical(shown, _selection);
    final hasSpan = start != null && end != null && !DateUtils.isSameDay(start, end);
    final isBandStart = hasSpan && DateUtils.isSameDay(day, start);
    final isBandEnd = hasSpan && DateUtils.isSameDay(day, end);
    final isBandMiddle = start != null &&
        end != null &&
        hasSpan &&
        day.isAfter(start) &&
        day.isBefore(end);

    final isSelected =
        DateUtils.isSameDay(day, _selection.start) || DateUtils.isSameDay(day, _selection.end);
    final isDisabled = _isDisabled(day);
    final isToday = DateUtils.isSameDay(day, _today);
    final isFocused = _gridHasFocus && DateUtils.isSameDay(day, _focusedDay);

    final Color textColor;
    if (isSelected) {
      textColor = colors.onPrimary;
    } else if (isDisabled) {
      textColor = colors.onSurface.withValues(alpha: 0.38);
    } else if (isBandMiddle) {
      textColor = colors.onPrimaryContainer;
    } else if (isToday) {
      textColor = colors.primary;
    } else {
      textColor = colors.onSurface;
    }

    final bandColor = colors.primaryContainer.withValues(alpha: isPreview ? 0.5 : 1);
    const half = _cellSize / 2;
    const bandInset = (_cellSize - _daySize) / 2;

    final cell = Stack(
      alignment: Alignment.center,
      children: [
        if (isBandMiddle || isBandStart || isBandEnd)
          Positioned(
            top: bandInset,
            bottom: bandInset,
            left: isBandStart ? half : 0.0,
            right: isBandEnd ? half : 0.0,
            child: ColoredBox(color: bandColor),
          ),
        Container(
          width: _daySize,
          height: _daySize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? colors.primary : null,
            border: (isToday && !isSelected && !isDisabled)
                ? Border.all(color: colors.primary)
                : null,
          ),
          child: Text(
            localizations.formatDecimal(day.day),
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14, color: textColor),
          ),
        ),
        if (isFocused)
          IgnorePointer(
            child: Container(
              width: _cellSize,
              height: _cellSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colors.onSurface, width: 2),
              ),
            ),
          ),
      ],
    );

    return SizedBox.square(
      dimension: _cellSize,
      child: InkResponse(
        onTap: isDisabled ? null : () => _select(day),
        onHover: _isPending
            ? (hovering) => setState(() {
                  if (hovering) {
                    _hoveredDay = day;
                  } else if (DateUtils.isSameDay(_hoveredDay, day)) {
                    _hoveredDay = null;
                  }
                })
            : null,
        canRequestFocus: false, // the grid handles keyboard focus
        radius: _daySize / 2,
        containedInkWell: true,
        customBorder: const CircleBorder(),
        child: Semantics(
          button: true,
          enabled: !isDisabled,
          selected: isSelected || (!isPreview && isBandMiddle),
          label: localizations.formatFullDate(day),
          excludeSemantics: true,
          child: cell,
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.tooltip, required this.onPressed});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      constraints: const BoxConstraints.tightFor(width: 32, height: 32),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.standard,
      ),
    );
  }
}