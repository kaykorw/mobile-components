// AppDatePicker and AppDateRangePicker: Flutter counterparts of React
// <DatePicker> and <DateRangePicker>. Trigger with calendar icon + chevron;
// the range picker opens presets + a two-month calendar with Cancel/Apply.
import 'package:flutter/material.dart';

import '../foundation/app_form_field.dart';
import '../foundation/app_pressable.dart';
import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';
import 'app_button.dart';
import 'app_calendar.dart';
import 'app_icon.dart';
import 'app_menu.dart';
import 'app_popover.dart';

/// A quick choice in the range picker. [range] is called when it's shown or picked,
/// so it's always relative to now. Same shape as React `DateRangePreset`.
@immutable
class AppDateRangePreset {
  const AppDateRangePreset({required this.label, required this.range});

  final String label;
  final AppDateRange Function() range;
}

/// The presets from the screenshot: Today, Last 7 days, Last 30 days, This month.
List<AppDateRangePreset> appDefaultDateRangePresets() {
  DateTime today() => DateUtils.dateOnly(DateTime.now());
  return [
    AppDateRangePreset(label: 'Today', range: () => AppDateRange(start: today(), end: today())),
    AppDateRangePreset(
      label: 'Last 7 days',
      range: () => AppDateRange(start: today().subtract(const Duration(days: 6)), end: today()),
    ),
    AppDateRangePreset(
      label: 'Last 30 days',
      range: () => AppDateRange(start: DateUtils.addDaysToDate(today(), -29), end: today()),
    ),
    AppDateRangePreset(
      label: 'This month',
      range: () => AppDateRange(start: DateTime(today().year, today().month), end: today()),
    ),
  ];
}

/// The field-like trigger: calendar icon, value or placeholder, chevron.
class _PickerTrigger extends StatelessWidget {
  const _PickerTrigger({
    required this.text,
    required this.isPlaceholder,
    required this.isOpen,
    required this.hasError,
    required this.isDisabled,
    required this.size,
    required this.isFullWidth,
    required this.onTap,
    required this.semanticLabel,
  });

  final String text;
  final bool isPlaceholder;
  final bool isOpen;
  final bool hasError;
  final bool isDisabled;
  final AppFieldSize size;
  final bool isFullWidth;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return AppPressable(
      onTap: onTap,
      enabled: !isDisabled,
      semanticLabel: '$semanticLabel, $text',
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        final active = isOpen || states.contains(WidgetState.focused);
        Color border = t.borderStrong;
        if (hasError) {
          border = t.dangerAccent;
        } else if (active) {
          border = t.primaryBorder;
        }
        final foreground = isDisabled ? t.textDisabled : t.textEmphasis;
        return AnimatedContainer(
          duration: AppDurations.fast,
          height: size.height,
          width: isFullWidth ? double.infinity : null,
          padding: EdgeInsets.symmetric(horizontal: size.horizontalPadding),
          decoration: BoxDecoration(
            color: isDisabled ? t.surfaceMuted : (hovered ? t.surfaceMuted : t.surface),
            borderRadius: AppRadius.all(size.radius),
            border: Border.all(color: border),
            boxShadow: active && !hasError ? [BoxShadow(color: t.focusRing, spreadRadius: 3)] : null,
          ),
          child: Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            children: [
              AppIcon(AppIcons.calendar, size: 18, color: t.textMuted),
              const SizedBox(width: AppSpacing.s2),
              Flexible(
                fit: isFullWidth ? FlexFit.tight : FlexFit.loose,
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.style(size.fontSize, weight: FontWeight.w500, color: foreground),
                ),
              ),
              const SizedBox(width: AppSpacing.s2),
              AnimatedRotation(
                turns: isOpen ? 0.5 : 0,
                duration: AppDurations.fast,
                child: AppIcon(AppIcons.chevronDown, size: 16, color: t.textSubtle),
              ),
            ],
          ),
        );
      },
    );
  }
}

String _formatDay(MaterialLocalizations l, DateTime day) => l.formatMediumDate(day);

// --------------------------------------------------------------- DatePicker

/// Field that opens a calendar to pick one day. Picking applies it and closes.
class AppDatePicker extends StatefulWidget {
  const AppDatePicker({
    super.key,
    this.value,
    this.onChanged,
    this.placeholder = 'Select date',
    this.formatDate,
    this.label,
    this.semanticLabel = 'Date',
    this.description,
    this.errorText,
    this.isRequired = false,
    this.isDisabled = false,
    this.size = AppFieldSize.medium,
    this.isFullWidth = false,
    this.minDate,
    this.maxDate,
    this.isDateDisabled,
    this.weekStartsOn = AppCalendarWeekStart.sunday,
    this.placement = AppPopoverPlacement.bottomStart,
    this.calendarSize = AppCalendarSize.medium,
  });

  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final String placeholder;

  /// Formats the trigger text. Default: the locale's medium date ("Nov 20, 2026").
  final String Function(DateTime date)? formatDate;
  final String? label;

  /// Accessible name when there's no visible [label].
  final String semanticLabel;
  final String? description;
  final String? errorText;
  final bool isRequired;
  final bool isDisabled;
  final AppFieldSize size;
  final bool isFullWidth;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool Function(DateTime date)? isDateDisabled;
  final AppCalendarWeekStart weekStartsOn;
  final AppPopoverPlacement placement;
  final AppCalendarSize calendarSize;

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  late DateTime? _value = widget.value;

  @override
  void didUpdateWidget(AppDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!DateUtils.isSameDay(oldWidget.value, widget.value)) _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final l = MaterialLocalizations.of(context);
    final value = _value;
    final text = value == null ? widget.placeholder : (widget.formatDate?.call(value) ?? _formatDay(l, value));
    return AppFormField(
      label: widget.label,
      isRequired: widget.isRequired,
      description: widget.description,
      errorText: widget.errorText,
      child: Align(
        alignment: Alignment.centerLeft,
        child: AppPopover(
          placement: widget.placement,
          semanticLabel: widget.label ?? widget.semanticLabel,
          triggerBuilder: (context, isOpen, toggle) => _PickerTrigger(
            text: text,
            isPlaceholder: value == null,
            isOpen: isOpen,
            hasError: widget.errorText != null,
            isDisabled: widget.isDisabled,
            size: widget.size,
            isFullWidth: widget.isFullWidth,
            onTap: toggle,
            semanticLabel: widget.label ?? widget.semanticLabel,
          ),
          contentBuilder: (context, close) => AppCalendar.single(
            selectedDate: value,
            minDate: widget.minDate,
            maxDate: widget.maxDate,
            isDateDisabled: widget.isDateDisabled,
            weekStartsOn: widget.weekStartsOn,
            size: widget.calendarSize,
            onChanged: (date) {
              setState(() => _value = date);
              widget.onChanged?.call(date);
              close();
            },
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------- DateRangePicker

/// Field that opens presets + a two-month calendar to pick a date range, with
/// Cancel/Apply. Nothing changes until Apply.
class AppDateRangePicker extends StatefulWidget {
  const AppDateRangePicker({
    super.key,
    this.value,
    this.onChanged,
    this.presets,
    this.placeholder = 'Select date range',
    this.hideClearOption = false,
    this.customRangeLabel = 'Custom range',
    this.numberOfMonths = 2,
    this.applyLabel = 'Apply',
    this.cancelLabel = 'Cancel',
    this.formatRange,
    this.label,
    this.semanticLabel = 'Date range',
    this.description,
    this.errorText,
    this.isRequired = false,
    this.isDisabled = false,
    this.size = AppFieldSize.medium,
    this.isFullWidth = false,
    this.minDate,
    this.maxDate,
    this.isDateDisabled,
    this.weekStartsOn = AppCalendarWeekStart.sunday,
    this.placement = AppPopoverPlacement.bottomStart,
    this.calendarSize = AppCalendarSize.small,
    this.initiallyOpen = false,
  });

  final AppDateRange? value;

  /// Called on Apply (with an empty range when cleared).
  final ValueChanged<AppDateRange>? onChanged;

  /// Quick choices on the left. Pass `const []` to hide the list. Default: [appDefaultDateRangePresets].
  final List<AppDateRangePreset>? presets;

  /// Trigger text while nothing is selected; also the first list item, which clears the range.
  final String placeholder;
  final bool hideClearOption;
  final String customRangeLabel;
  final int numberOfMonths;
  final String applyLabel;
  final String cancelLabel;

  /// Formats the trigger text. Default: the preset's name when it matches one, else "start – end".
  final String Function(DateTime start, DateTime end)? formatRange;
  final String? label;
  final String semanticLabel;
  final String? description;
  final String? errorText;
  final bool isRequired;
  final bool isDisabled;
  final AppFieldSize size;
  final bool isFullWidth;
  final DateTime? minDate;

  /// Latest pickable day, e.g. today for "no future dates" (as in the screenshot).
  final DateTime? maxDate;
  final bool Function(DateTime date)? isDateDisabled;
  final AppCalendarWeekStart weekStartsOn;
  final AppPopoverPlacement placement;
  final AppCalendarSize calendarSize;

  /// Opens after the first frame (for previews).
  final bool initiallyOpen;

  @override
  State<AppDateRangePicker> createState() => _AppDateRangePickerState();
}

class _AppDateRangePickerState extends State<AppDateRangePicker> {
  static const _empty = AppDateRange();

  late AppDateRange _committed = widget.value ?? _empty;
  AppDateRange _draft = _empty;
  bool _customMode = false;
  late DateTime _month = _monthFor(_committed);

  List<AppDateRangePreset> get _presets => widget.presets ?? appDefaultDateRangePresets();

  @override
  void didUpdateWidget(AppDateRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _committed = widget.value ?? _empty;
  }

  /// First visible month: the range's start month, else the current month (as in the screenshot).
  DateTime _monthFor(AppDateRange range) {
    final anchor = range.start ?? DateTime.now();
    return DateTime(anchor.year, anchor.month);
  }

  AppDateRangePreset? _matching(AppDateRange range) {
    if (!range.isComplete) return null;
    for (final preset in _presets) {
      if (preset.range() == range) return preset;
    }
    return null;
  }

  void _onOpenChanged(bool open) {
    if (!open) return;
    setState(() {
      _draft = _committed;
      _customMode = _committed.isComplete && _matching(_committed) == null;
      _month = _monthFor(_committed);
    });
  }

  String _triggerText(MaterialLocalizations l) {
    final start = _committed.start;
    final end = _committed.end;
    if (start == null || end == null) return widget.placeholder;
    final custom = widget.formatRange;
    if (custom != null) return custom(start, end);
    final preset = _matching(_committed);
    if (preset != null) return preset.label;
    if (DateUtils.isSameDay(start, end)) return _formatDay(l, start);
    return '${_formatDay(l, start)} – ${_formatDay(l, end)}';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l = MaterialLocalizations.of(context);
    final draftPreset = _matching(_draft);
    final canApply = (_draft.isComplete || _draft.isEmpty) && _draft != _committed;

    return AppFormField(
      label: widget.label,
      isRequired: widget.isRequired,
      description: widget.description,
      errorText: widget.errorText,
      child: Align(
        alignment: Alignment.centerLeft,
        child: AppPopover(
          placement: widget.placement,
          isFlush: true,
          initiallyOpen: widget.initiallyOpen,
          onOpenChanged: _onOpenChanged,
          semanticLabel: widget.label ?? widget.semanticLabel,
          triggerBuilder: (context, isOpen, toggle) => _PickerTrigger(
            text: _triggerText(l),
            isPlaceholder: !_committed.isComplete,
            isOpen: isOpen,
            hasError: widget.errorText != null,
            isDisabled: widget.isDisabled,
            size: widget.size,
            isFullWidth: widget.isFullWidth,
            onTap: toggle,
            semanticLabel: widget.label ?? widget.semanticLabel,
          ),
          contentBuilder: (context, close) => IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_presets.isNotEmpty)
                  Container(
                    width: 200,
                    decoration: BoxDecoration(border: Border(right: BorderSide(color: t.borderSubtle))),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: AppMenu(
                        semanticLabel: 'Quick ranges',
                        children: [
                          if (!widget.hideClearOption)
                            AppMenuItem(
                              label: widget.placeholder,
                              trailing: AppMenuItemTrailing.check,
                              isSelected: _draft.isEmpty && !_customMode,
                              onTap: () => setState(() {
                                _draft = _empty;
                                _customMode = false;
                              }),
                            ),
                          for (final preset in _presets)
                            AppMenuItem(
                              label: preset.label,
                              trailing: AppMenuItemTrailing.check,
                              isSelected: !_customMode && draftPreset?.label == preset.label,
                              onTap: () => setState(() {
                                _draft = preset.range();
                                _customMode = false;
                                _month = _monthFor(_draft);
                              }),
                            ),
                          AppMenuItem(
                            label: widget.customRangeLabel,
                            trailing: AppMenuItemTrailing.check,
                            isSelected: _customMode ||
                                (_draft.isComplete && draftPreset == null) ||
                                (_draft.start != null && _draft.end == null),
                            onTap: () => setState(() {
                              _customMode = true;
                              _draft = _empty;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.s5, AppSpacing.s4, AppSpacing.s5, AppSpacing.s4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppCalendar.range(
                        selectedRange: _draft,
                        month: _month,
                        onMonthChanged: (month) => setState(() => _month = month),
                        numberOfMonths: widget.numberOfMonths,
                        minDate: widget.minDate,
                        maxDate: widget.maxDate,
                        isDateDisabled: widget.isDateDisabled,
                        weekStartsOn: widget.weekStartsOn,
                        size: widget.calendarSize,
                        onChanged: (range) => setState(() {
                          _draft = range;
                          _customMode = _matching(range) == null;
                        }),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppButton(label: widget.cancelLabel, variant: AppButtonVariant.ghost, onPressed: close),
                          const SizedBox(width: AppSpacing.s2),
                          AppButton(
                            label: widget.applyLabel,
                            isDisabled: !canApply,
                            onPressed: () {
                              setState(() => _committed = _draft);
                              widget.onChanged?.call(_draft);
                              close();
                            },
                          ),
                        ],
                      ),
                    ],
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
