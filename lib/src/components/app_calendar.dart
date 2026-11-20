// AppCalendar: Flutter counterpart of React <Calendar>.
//
// Same look as the date range picker screenshot: square-ish days, 2-letter
// weekdays, faded outside days, grey "today" tile, title centred over each
// month, previous/next arrows on the outer edges, 1 or more months.
//
// API mapping (React -> Flutter):
//   mode="single"/"range"  -> AppCalendar.single(...) / AppCalendar.range(...)
//   value / defaultValue   -> selectedDate / selectedRange (followed when they change)
//   onChange               -> onChanged
//   month / onMonthChange  -> month / onMonthChanged; defaultMonth -> initialMonth
//   minDate, maxDate, isDateDisabled, weekStartsOn, numberOfMonths, size,
//   showOutsideDays: same names and values.
//
// Keyboard (once a day has focus): arrows move by day/week, Home/End go to the
// start/end of the week, Page Up/Down change month (with Shift: year), Enter or
// Space selects. Uses CallbackShortcuts, not Focus.onKeyEvent (a private named
// parameter in Flutter 3.50).
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';

/// Same names as React `mode`.
enum AppCalendarMode { single, range }

/// Same names as React `weekStartsOn`.
enum AppCalendarWeekStart { sunday, monday }

/// Day size: 28 px (as in the range picker), 36 px or 44 px. Same names as React.
enum AppCalendarSize { small, medium, large }

/// A range whose [end] is null while only the first day has been picked. Same shape as React `DateRange`.
@immutable
class AppDateRange {
  const AppDateRange({this.start, this.end});

  final DateTime? start;
  final DateTime? end;

  bool get isComplete => start != null && end != null;
  bool get isEmpty => start == null && end == null;

  @override
  bool operator ==(Object other) =>
      other is AppDateRange && DateUtils.isSameDay(other.start, start) && DateUtils.isSameDay(other.end, end);

  @override
  int get hashCode => Object.hash(_dayOrNull(start), _dayOrNull(end));

  @override
  String toString() => 'AppDateRange($start - $end)';
}

DateTime? _dayOrNull(DateTime? date) => date == null ? null : DateUtils.dateOnly(date);

DateTime _addDays(DateTime day, int days) => DateTime(day.year, day.month, day.day + days);

/// Same day number in another month, clamped (31 Jan + 1 month = 28/29 Feb).
DateTime appAddMonths(DateTime day, int months) {
  final target = DateTime(day.year, day.month + months);
  final lastDay = DateUtils.getDaysInMonth(target.year, target.month);
  return DateTime(target.year, target.month, math.min(day.day, lastDay));
}

int _monthDiff(DateTime a, DateTime b) => (b.year - a.year) * 12 + (b.month - a.month);

class AppCalendar extends StatefulWidget {
  /// Pick one day.
  const AppCalendar.single({
    super.key,
    this.selectedDate,
    ValueChanged<DateTime>? onChanged,
    this.minDate,
    this.maxDate,
    this.isDateDisabled,
    this.weekStartsOn = AppCalendarWeekStart.sunday,
    this.numberOfMonths = 1,
    this.size = AppCalendarSize.medium,
    this.showOutsideDays = true,
    this.month,
    this.initialMonth,
    this.onMonthChanged,
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
    this.weekStartsOn = AppCalendarWeekStart.sunday,
    this.numberOfMonths = 1,
    this.size = AppCalendarSize.medium,
    this.showOutsideDays = true,
    this.month,
    this.initialMonth,
    this.onMonthChanged,
  })  : mode = AppCalendarMode.range,
        onRangeChanged = onChanged,
        selectedDate = null,
        onDateChanged = null;

  final AppCalendarMode mode;
  final DateTime? selectedDate;
  final AppDateRange? selectedRange;
  final ValueChanged<DateTime>? onDateChanged;
  final ValueChanged<AppDateRange>? onRangeChanged;

  /// Earliest day that can be picked.
  final DateTime? minDate;

  /// Latest day that can be picked (e.g. today, for "no future dates").
  final DateTime? maxDate;

  /// Return true to block a day, e.g. weekends or public holidays.
  final bool Function(DateTime date)? isDateDisabled;

  /// First column. The screenshots use Sunday.
  final AppCalendarWeekStart weekStartsOn;

  /// Months shown side by side (the range picker shows 2).
  final int numberOfMonths;
  final AppCalendarSize size;

  /// Show the neighbouring months' days, faded.
  final bool showOutsideDays;

  /// First visible month (controlled). Use with [onMonthChanged].
  final DateTime? month;

  /// First visible month at start. Defaults to the selection, or today.
  final DateTime? initialMonth;
  final ValueChanged<DateTime>? onMonthChanged;

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late AppDateRange _selection;
  late DateTime _internalMonth;
  late DateTime _focusedDay;
  DateTime? _previewDay;
  final Map<DateTime, FocusNode> _dayNodes = {};

  DateTime get _today => DateUtils.dateOnly(DateTime.now());
  DateTime? get _min => _dayOrNull(widget.minDate);
  DateTime? get _max => _dayOrNull(widget.maxDate);
  bool get _isRange => widget.mode == AppCalendarMode.range;
  DateTime get _firstMonth {
    final controlled = widget.month;
    return controlled == null ? _internalMonth : DateTime(controlled.year, controlled.month);
  }

  @override
  void initState() {
    super.initState();
    _selection = _selectionFromWidget();
    final anchor = widget.initialMonth ?? _selection.start ?? _clamp(_today);
    _internalMonth = DateTime(anchor.year, anchor.month);
    _focusedDay = _selection.start ?? _clamp(_today);
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
    for (final node in _dayNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  AppDateRange _selectionFromWidget() => switch (widget.mode) {
        AppCalendarMode.single => AppDateRange(start: _dayOrNull(widget.selectedDate), end: _dayOrNull(widget.selectedDate)),
        AppCalendarMode.range => AppDateRange(
            start: _dayOrNull(widget.selectedRange?.start),
            end: _dayOrNull(widget.selectedRange?.end),
          ),
      };

  FocusNode _nodeFor(DateTime day) => _dayNodes.putIfAbsent(day, FocusNode.new);

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

  bool _isVisible(DateTime day) {
    final diff = _monthDiff(_firstMonth, day);
    return diff >= 0 && diff < widget.numberOfMonths;
  }

  static AppDateRange _ordered(DateTime a, DateTime b) =>
      b.isBefore(a) ? AppDateRange(start: b, end: a) : AppDateRange(start: a, end: b);

  bool get _isPending => _isRange && _selection.start != null && _selection.end == null;

  AppDateRange get _shownRange {
    final start = _selection.start;
    final preview = _previewDay;
    if (_isPending && start != null && preview != null) return _ordered(start, preview);
    return _selection;
  }

  void _setFirstMonth(DateTime month) {
    final next = DateTime(month.year, month.month);
    if (widget.month == null) setState(() => _internalMonth = next);
    widget.onMonthChanged?.call(next);
  }

  void _select(DateTime day) {
    if (_isDisabled(day)) return;
    final AppDateRange next;
    if (_isRange) {
      final start = _selection.start;
      next = (start == null || _selection.end != null) ? AppDateRange(start: day) : _ordered(start, day);
    } else {
      next = AppDateRange(start: day, end: day);
    }
    setState(() {
      _focusedDay = day;
      _selection = next;
      _previewDay = null;
    });
    if (_isRange) {
      widget.onRangeChanged?.call(next);
    } else {
      widget.onDateChanged?.call(day);
    }
  }

  void _changeMonth(int delta) {
    _setFirstMonth(appAddMonths(_firstMonth, delta));
    setState(() => _focusedDay = _clamp(appAddMonths(_focusedDay, delta)));
  }

  void _moveFocus(DateTime target) {
    final day = _clamp(target);
    if (day.isBefore(_firstMonth)) {
      _setFirstMonth(day);
    } else if (_monthDiff(_firstMonth, day) >= widget.numberOfMonths) {
      _setFirstMonth(appAddMonths(DateTime(day.year, day.month), -(widget.numberOfMonths - 1)));
    }
    setState(() {
      _focusedDay = day;
      if (_isPending) _previewDay = day;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _nodeFor(day).requestFocus();
    });
  }

  Map<ShortcutActivator, VoidCallback> _keyBindings() {
    void move(DateTime Function(DateTime from) to) => _moveFocus(to(_focusedDay));
    return <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.arrowLeft): () => move((d) => _addDays(d, -1)),
      const SingleActivator(LogicalKeyboardKey.arrowRight): () => move((d) => _addDays(d, 1)),
      const SingleActivator(LogicalKeyboardKey.arrowUp): () => move((d) => _addDays(d, -7)),
      const SingleActivator(LogicalKeyboardKey.arrowDown): () => move((d) => _addDays(d, 7)),
      const SingleActivator(LogicalKeyboardKey.home): () => move((d) => _addDays(d, -_column(d))),
      const SingleActivator(LogicalKeyboardKey.end): () => move((d) => _addDays(d, 6 - _column(d))),
      const SingleActivator(LogicalKeyboardKey.pageUp): () => move((d) => appAddMonths(d, -1)),
      const SingleActivator(LogicalKeyboardKey.pageDown): () => move((d) => appAddMonths(d, 1)),
      const SingleActivator(LogicalKeyboardKey.pageUp, shift: true): () => move((d) => appAddMonths(d, -12)),
      const SingleActivator(LogicalKeyboardKey.pageDown, shift: true): () => move((d) => appAddMonths(d, 12)),
      const SingleActivator(LogicalKeyboardKey.enter): () => _select(_focusedDay),
      const SingleActivator(LogicalKeyboardKey.numpadEnter): () => _select(_focusedDay),
      const SingleActivator(LogicalKeyboardKey.space): () => _select(_focusedDay),
    };
  }

  /// "Sun, Nov 1" -> "Su"; works for any MaterialLocalizations.
  String _weekdayLabel(MaterialLocalizations localizations, DateTime date) {
    final text = localizations.formatMediumDate(date);
    final match = RegExp(r'^\p{L}+', unicode: true).firstMatch(text);
    final word = match?.group(0) ?? text;
    final short = word.substring(0, math.min(2, word.length));
    return short.isEmpty ? short : short[0].toUpperCase() + short.substring(1);
  }

  (double cell, double gap, double font) get _metrics => switch (widget.size) {
        AppCalendarSize.small => (28.0, 8.0, 13.0),
        AppCalendarSize.medium => (36.0, 4.0, 14.0),
        AppCalendarSize.large => (44.0, 4.0, 15.0),
      };

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final localizations = MaterialLocalizations.of(context);
    final (cell, gap, font) = _metrics;
    final first = _firstMonth;
    final last = appAddMonths(first, widget.numberOfMonths - 1);

    final min = _min;
    final max = _max;
    final canGoBack = min == null || !DateTime(first.year, first.month, 0).isBefore(min);
    final canGoForward = max == null || !DateTime(last.year, last.month + 1).isAfter(max);

    // The one day reachable with Tab.
    final tabbable = _isVisible(_focusedDay)
        ? _focusedDay
        : (_selection.start != null && _isVisible(_selection.start!))
            ? _selection.start!
            : _isVisible(_today)
                ? _today
                : first;

    // Seven sample dates (1 Jan 2024 was a Monday) for the weekday header.
    final firstColumnDate = widget.weekStartsOn == AppCalendarWeekStart.monday ? DateTime(2024) : DateTime(2023, 12, 31);
    final weekdayLabels = [for (var i = 0; i < 7; i++) _weekdayLabel(localizations, _addDays(firstColumnDate, i))];

    final months = <Widget>[];
    for (var m = 0; m < widget.numberOfMonths; m++) {
      final month = appAddMonths(first, m);
      if (m > 0) months.add(SizedBox(width: cell + 4));
      months.add(_buildMonth(
        context,
        t,
        localizations,
        month: month,
        cell: cell,
        gap: gap,
        font: font,
        weekdayLabels: weekdayLabels,
        tabbable: tabbable,
        showPrev: m == 0,
        showNext: m == widget.numberOfMonths - 1,
        canGoBack: canGoBack,
        canGoForward: canGoForward,
      ));
    }

    // Key events only reach CallbackShortcuts while a day inside has focus.
    return CallbackShortcuts(
      bindings: _keyBindings(),
      child: MouseRegion(
        onExit: (_) => setState(() => _previewDay = null),
        child: Semantics(
          container: true,
          label: _isRange ? 'Choose dates' : 'Choose a date',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: months,
          ),
        ),
      ),
    );
  }

  Widget _buildMonth(
    BuildContext context,
    AppTokens t,
    MaterialLocalizations localizations, {
    required DateTime month,
    required double cell,
    required double gap,
    required double font,
    required List<String> weekdayLabels,
    required DateTime tabbable,
    required bool showPrev,
    required bool showNext,
    required bool canGoBack,
    required bool canGoForward,
  }) {
    final title = localizations.formatMonthYear(month);
    final firstOfMonth = DateTime(month.year, month.month);
    final start = _addDays(firstOfMonth, -_column(firstOfMonth));
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final weekCount = ((_column(firstOfMonth) + daysInMonth) / 7).ceil();

    Widget navButton(AppIconData icon, String tooltip, VoidCallback? onTap) => Semantics(
          button: true,
          enabled: onTap != null,
          label: tooltip,
          child: GestureDetector(
            onTap: onTap,
            child: MouseRegion(
              cursor: onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
              child: SizedBox.square(
                dimension: 28,
                child: Center(child: AppIcon(icon, size: 18, color: onTap == null ? t.textFaint : t.textStrong)),
              ),
            ),
          ),
        );

    final header = SizedBox(
      width: cell * 7,
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Semantics(
            liveRegion: true,
            child: Text(
              title.isEmpty ? title : title[0].toUpperCase() + title.substring(1),
              style: AppType.style(AppType.md, weight: FontWeight.w600, color: t.textStrong),
            ),
          ),
          if (showPrev)
            Positioned(
              left: 0,
              child: navButton(AppIcons.chevronLeft, localizations.previousMonthTooltip, canGoBack ? () => _changeMonth(-1) : null),
            ),
          if (showNext)
            Positioned(
              right: 0,
              child: navButton(AppIcons.chevronRight, localizations.nextMonthTooltip, canGoForward ? () => _changeMonth(1) : null),
            ),
        ],
      ),
    );

    final weekdays = ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final label in weekdayLabels)
            SizedBox(
              width: cell,
              height: 24,
              child: Center(
                child: Text(label, style: AppType.style(font - 1, weight: FontWeight.w500, color: t.textMuted)),
              ),
            ),
        ],
      ),
    );

    final rows = <Widget>[];
    for (var w = 0; w < weekCount; w++) {
      if (w > 0) rows.add(SizedBox(height: gap));
      rows.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var d = 0; d < 7; d++)
            _buildDay(t, localizations, _addDays(start, w * 7 + d), month, cell: cell, font: font, tabbable: tabbable),
        ],
      ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        header,
        const SizedBox(height: 12),
        weekdays,
        SizedBox(height: gap),
        ...rows,
      ],
    );
  }

  Widget _buildDay(
    AppTokens t,
    MaterialLocalizations localizations,
    DateTime day,
    DateTime month, {
    required double cell,
    required double font,
    required DateTime tabbable,
  }) {
    final dayText = localizations.formatDecimal(day.day);
    if (day.month != month.month || day.year != month.year) {
      return ExcludeSemantics(
        child: SizedBox.square(
          dimension: cell,
          child: widget.showOutsideDays
              ? Center(child: Text(dayText, style: AppType.style(font, color: t.textFaint)))
              : null,
        ),
      );
    }

    final shown = _shownRange;
    final rangeStart = shown.start;
    final rangeEnd = shown.end;
    final isPreview = !identical(shown, _selection);
    final hasSpan = rangeStart != null && rangeEnd != null && !DateUtils.isSameDay(rangeStart, rangeEnd);
    final isBandStart = hasSpan && DateUtils.isSameDay(day, rangeStart);
    final isBandEnd = hasSpan && DateUtils.isSameDay(day, rangeEnd);
    final isBandMiddle = rangeStart != null && rangeEnd != null && hasSpan && day.isAfter(rangeStart) && day.isBefore(rangeEnd);
    final isSelected = DateUtils.isSameDay(day, _selection.start) || DateUtils.isSameDay(day, _selection.end);
    final disabled = _isDisabled(day);
    final isToday = DateUtils.isSameDay(day, _today);
    final focusNode = _nodeFor(day);
    final band = t.primarySubtle.withValues(alpha: isPreview ? 0.6 : 1);

    return _DayCell(
      key: ValueKey(day),
      focusNode: focusNode,
      isTabbable: DateUtils.isSameDay(day, tabbable),
      size: cell,
      label: localizations.formatFullDate(day),
      text: dayText,
      fontSize: font,
      isSelected: isSelected,
      isToday: isToday,
      isDisabled: disabled,
      isBandMiddle: isBandMiddle,
      bandStart: isBandStart,
      bandEnd: isBandEnd,
      bandColor: band,
      semanticsSelected: isSelected || (!isPreview && isBandMiddle),
      onTap: () => _select(day),
      onFocus: () => setState(() {
        _focusedDay = day;
        if (_isPending) _previewDay = day;
      }),
      onHover: _isPending ? () => setState(() => _previewDay = day) : null,
    );
  }
}

class _DayCell extends StatefulWidget {
  const _DayCell({
    super.key,
    required this.focusNode,
    required this.isTabbable,
    required this.size,
    required this.label,
    required this.text,
    required this.fontSize,
    required this.isSelected,
    required this.isToday,
    required this.isDisabled,
    required this.isBandMiddle,
    required this.bandStart,
    required this.bandEnd,
    required this.bandColor,
    required this.semanticsSelected,
    required this.onTap,
    required this.onFocus,
    required this.onHover,
  });

  final FocusNode focusNode;
  final bool isTabbable;
  final double size;
  final String label;
  final String text;
  final double fontSize;
  final bool isSelected;
  final bool isToday;
  final bool isDisabled;
  final bool isBandMiddle;
  final bool bandStart;
  final bool bandEnd;
  final Color bandColor;
  final bool semanticsSelected;
  final VoidCallback onTap;
  final VoidCallback onFocus;
  final VoidCallback? onHover;

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell> {
  bool _hovered = false;
  bool _focused = false;

  // Roving tab stop: only one day is in the Tab order. skipTraversal is set
  // through the setter because the FocusNode constructor parameter is private
  // in Flutter 3.50.
  @override
  void initState() {
    super.initState();
    widget.focusNode.skipTraversal = !widget.isTabbable;
  }

  @override
  void didUpdateWidget(_DayCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.focusNode.skipTraversal = !widget.isTabbable;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);

    Color background = Colors.transparent;
    Color foreground = t.textStrong;
    if (widget.isDisabled) {
      foreground = t.textFaint;
    } else if (widget.isSelected) {
      background = t.primary;
      foreground = t.onPrimary;
    } else if (widget.isBandMiddle) {
      foreground = t.primaryTextStrong;
    } else if (_hovered) {
      background = t.surfaceSunken;
    } else if (widget.isToday) {
      background = t.surfaceSunken;
    }
    if (widget.isToday && !widget.isSelected && !widget.isDisabled && widget.isBandMiddle) {
      background = t.surfaceSunken;
    }

    final half = widget.size / 2;
    return Semantics(
      button: true,
      enabled: !widget.isDisabled,
      selected: widget.semanticsSelected,
      label: widget.label,
      excludeSemantics: true,
      child: FocusableActionDetector(
        focusNode: widget.focusNode,
        mouseCursor: widget.isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
        onShowHoverHighlight: (value) {
          setState(() => _hovered = value);
          if (value) widget.onHover?.call();
        },
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        onFocusChange: (value) {
          if (value) widget.onFocus();
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.isDisabled ? null : widget.onTap,
          child: SizedBox.square(
            dimension: widget.size,
            child: Stack(
              children: [
                if (widget.isBandMiddle || widget.bandStart || widget.bandEnd)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: widget.bandStart ? half : 0.0,
                    right: widget.bandEnd ? half : 0.0,
                    child: ColoredBox(color: widget.bandColor),
                  ),
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: AppDurations.fast,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: AppRadius.all(AppRadius.xs),
                      border: _focused ? Border.all(color: t.primaryBorder, width: 2) : null,
                    ),
                    child: Text(
                      widget.text,
                      style: AppType.style(
                        widget.fontSize,
                        weight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: foreground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
