// Use cases for Popover, Menu, Dialog, Select, Calendar, DatePicker and DateRangePicker.
// Names MUST match the React story names. Never rename them once embedded in zeroheight.
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'preview_surface.dart';

const _overlays = '[Components]/overlays';
const _inputs = '[Components]/inputs';

Widget _stage(BuildContext context, Widget child, {double height = 420, double width = 760}) =>
    previewSurface(context, SizedBox(width: width, height: height, child: Align(alignment: Alignment.topLeft, child: child)));

// -------------------------------------------------------------------- Popover

@widgetbook.UseCase(name: 'Default', type: AppPopover, path: _overlays)
Widget buildPopoverDefault(BuildContext context) => _stage(
      context,
      AppPopover(
        initiallyOpen: true,
        semanticLabel: 'Example',
        triggerBuilder: (context, isOpen, toggle) =>
            AppButton(label: 'Open popover', variant: AppButtonVariant.secondary, isSelected: isOpen, onPressed: toggle),
        contentBuilder: (context, close) => const SizedBox(
          width: 260,
          child: Text('Any content: text, a form, a list, a calendar.'),
        ),
      ),
    );

@widgetbook.UseCase(name: 'WithTitle', type: AppPopover, path: _overlays)
Widget buildPopoverWithTitle(BuildContext context) => _stage(
      context,
      AppPopover(
        initiallyOpen: true,
        title: 'Share report',
        triggerBuilder: (context, isOpen, toggle) =>
            AppButton(label: 'Open popover', variant: AppButtonVariant.secondary, isSelected: isOpen, onPressed: toggle),
        contentBuilder: (context, close) => const SizedBox(
          width: 260,
          child: Text('Any content: text, a form, a list, a calendar.'),
        ),
        footerBuilder: (context, close) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(label: 'Cancel', variant: AppButtonVariant.ghost, size: AppButtonSize.small, onPressed: close),
            const SizedBox(width: 8),
            AppButton(label: 'Share', size: AppButtonSize.small, onPressed: close),
          ],
        ),
      ),
    );

/// The Filters panel from the Accounts page.
@widgetbook.UseCase(name: 'Filters', type: AppPopover, path: _overlays)
Widget buildPopoverFilters(BuildContext context) =>
    _stage(context, const Align(alignment: Alignment.topRight, child: _FiltersExample()));

class _FiltersExample extends StatefulWidget {
  const _FiltersExample();

  @override
  State<_FiltersExample> createState() => _FiltersExampleState();
}

class _FiltersExampleState extends State<_FiltersExample> {
  static const _categories = ['Status', 'Type', 'Date range'];
  String _category = 'Status';
  String? _status;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return AppPopover(
      initiallyOpen: true,
      placement: AppPopoverPlacement.bottomEnd,
      width: 560,
      title: 'Filters',
      isFlush: true,
      triggerBuilder: (context, isOpen, toggle) => AppButton(
        label: 'Filters',
        variant: AppButtonVariant.secondary,
        leadingIcon: const AppIcon(AppIcons.filter),
        isSelected: isOpen,
        onPressed: toggle,
      ),
      footerBuilder: (context, close) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            label: 'Reset',
            variant: AppButtonVariant.ghost,
            leadingIcon: const AppIcon(AppIcons.refresh),
            isDisabled: _status == null,
            onPressed: () => setState(() => _status = null),
          ),
          const SizedBox(width: 8),
          AppButton(label: 'Done', onPressed: close),
        ],
      ),
      contentBuilder: (context, close) => SizedBox(
        height: 220,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 190,
              decoration: BoxDecoration(border: Border(right: BorderSide(color: t.borderSubtle))),
              child: AppMenu(
                semanticLabel: 'Filter by',
                children: [
                  for (final item in _categories)
                    AppMenuItem(
                      label: item,
                      trailing: AppMenuItemTrailing.chevron,
                      isSelected: item == _category,
                      onTap: () => setState(() => _category = item),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _category == 'Status'
                    ? AppRadioGroup<String>(
                        semanticLabel: 'Status',
                        value: _status,
                        onChanged: (value) => setState(() => _status = value),
                        options: const [
                          AppRadioOption(value: 'ACTIVE', label: 'ACTIVE'),
                          AppRadioOption(value: 'INACTIVE', label: 'INACTIVE'),
                        ],
                      )
                    : Text('$_category options go here.', style: TextStyle(color: t.textMuted)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@widgetbook.UseCase(name: 'ActionsMenu', type: AppPopover, path: _overlays)
Widget buildPopoverActionsMenu(BuildContext context) => _stage(
      context,
      Align(
        alignment: Alignment.topCenter,
        child: AppPopover(
          initiallyOpen: true,
          isFlush: true,
          placement: AppPopoverPlacement.bottomEnd,
          semanticLabel: 'Account actions',
          triggerBuilder: (context, isOpen, toggle) => AppButton.icon(
            icon: const AppIcon(AppIcons.more),
            semanticLabel: 'Account actions',
            isSelected: isOpen,
            onPressed: toggle,
          ),
          contentBuilder: (context, close) => SizedBox(
            width: 200,
            child: AppMenu(
              semanticLabel: 'Account actions',
              children: [
                AppMenuItem(label: 'View details', leading: const AppIcon(AppIcons.user), onTap: close),
                AppMenuItem(label: 'Send statement', leading: const AppIcon(AppIcons.mail), onTap: close),
                AppMenuItem(label: 'Close account', isDanger: true, leading: const AppIcon(AppIcons.close), onTap: close),
              ],
            ),
          ),
        ),
      ),
    );

// ----------------------------------------------------------------------- Menu

@widgetbook.UseCase(name: 'Default', type: AppMenuItem, path: _overlays)
Widget buildMenuDefault(BuildContext context) => previewSurface(
      context,
      SizedBox(
        width: 240,
        child: AppMenuItem(
          label: context.knobs.string(label: 'label', initialValue: 'Last 7 days'),
          isSelected: context.knobs.boolean(label: 'selected'),
          trailing: context.knobs.object.dropdown(
            label: 'trailing',
            options: AppMenuItemTrailing.values,
            labelBuilder: (value) => value.name,
          ),
          onTap: () {},
        ),
      ),
    );

@widgetbook.UseCase(name: 'Selected', type: AppMenuItem, path: _overlays)
Widget buildMenuSelected(BuildContext context) => previewSurface(
      context,
      SizedBox(
        width: 240,
        child: AppMenuItem(label: 'Last 7 days', isSelected: true, trailing: AppMenuItemTrailing.check, onTap: () {}),
      ),
    );

@widgetbook.UseCase(name: 'Presets', type: AppMenuItem, path: _overlays)
Widget buildMenuPresets(BuildContext context) => previewSurface(
      context,
      const SizedBox(width: 240, child: _ChoiceList(
        items: ['Select date range', 'Today', 'Last 7 days', 'Last 30 days', 'This month', 'Custom range'],
        trailing: AppMenuItemTrailing.check,
        label: 'Date presets',
      )),
    );

@widgetbook.UseCase(name: 'Categories', type: AppMenuItem, path: _overlays)
Widget buildMenuCategories(BuildContext context) => previewSurface(
      context,
      const SizedBox(width: 240, child: _ChoiceList(
        items: ['Status', 'Type', 'Date range'],
        trailing: AppMenuItemTrailing.chevron,
        label: 'Filter by',
      )),
    );

@widgetbook.UseCase(name: 'WithIcons', type: AppMenuItem, path: _overlays)
Widget buildMenuWithIcons(BuildContext context) => previewSurface(
      context,
      SizedBox(
        width: 240,
        child: AppMenu(
          semanticLabel: 'Account actions',
          children: [
            AppMenuItem(label: 'View details', leading: const AppIcon(AppIcons.user), onTap: () {}),
            AppMenuItem(
              label: 'Send statement',
              description: 'PDF, last 30 days',
              leading: const AppIcon(AppIcons.mail),
              onTap: () {},
            ),
            const AppMenuItem(label: 'Schedule (soon)', leading: AppIcon(AppIcons.calendar), isDisabled: true),
            AppMenuItem(label: 'Close account', isDanger: true, leading: const AppIcon(AppIcons.close), onTap: () {}),
          ],
        ),
      ),
    );

class _ChoiceList extends StatefulWidget {
  const _ChoiceList({required this.items, required this.trailing, required this.label});

  final List<String> items;
  final AppMenuItemTrailing trailing;
  final String label;

  @override
  State<_ChoiceList> createState() => _ChoiceListState();
}

class _ChoiceListState extends State<_ChoiceList> {
  late String _value = widget.items.first;

  @override
  Widget build(BuildContext context) => AppMenu(
        semanticLabel: widget.label,
        children: [
          for (final item in widget.items)
            AppMenuItem(
              label: item,
              trailing: widget.trailing,
              isSelected: item == _value,
              onTap: () => setState(() => _value = item),
            ),
        ],
      );
}

// --------------------------------------------------------------------- Dialog
// Shown inline so the preview (and the zeroheight embed) shows the open dialog.
// In an app, open them with showAppDialog(...) / showAppSheet(...).

@widgetbook.UseCase(name: 'Default', type: AppDialog, path: _overlays)
Widget buildDialogDefault(BuildContext context) => previewSurface(
      context,
      AppDialog(
        title: 'Delete this account?',
        description: 'The account will be closed and its balance moved to the parent account. You can’t undo this.',
        size: AppDialogSize.small,
        onClose: () {},
        footer: [
          AppButton(label: 'Cancel', variant: AppButtonVariant.secondary, onPressed: () {}),
          AppButton(label: 'Delete account', variant: AppButtonVariant.danger, onPressed: () {}),
        ],
      ),
    );

/// The New Account sheet.
@widgetbook.UseCase(name: 'Sheet', type: AppDialog, path: _overlays)
Widget buildDialogSheet(BuildContext context) => previewSurface(
      context,
      SizedBox(
        height: 680,
        child: AppDialog(
          title: 'New Account',
          description: 'Open a new account to hold and move funds.',
          placement: AppDialogPlacement.right,
          onClose: () {},
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppTextField(label: 'Account name', isRequired: true, placeholder: 'e.g. John Doe'),
              const SizedBox(height: 20),
              AppSelect<String>(
                label: 'Account type',
                isRequired: true,
                value: 'INDIVIDUAL',
                onChanged: (_) {},
                options: const [
                  AppSelectOption(value: 'INDIVIDUAL', label: 'Individual'),
                  AppSelectOption(value: 'BUSINESS', label: 'Business'),
                ],
              ),
              const SizedBox(height: 20),
              const AppTextField(label: 'Notes', placeholder: 'Primary personal account'),
            ],
          ),
          footer: [
            AppButton(label: 'Cancel', variant: AppButtonVariant.secondary, size: AppButtonSize.large, onPressed: () {}),
            AppButton(label: 'Create Account', size: AppButtonSize.large, isDisabled: true, onPressed: () {}),
          ],
        ),
      ),
    );

@widgetbook.UseCase(name: 'Large', type: AppDialog, path: _overlays)
Widget buildDialogLarge(BuildContext context) => previewSurface(
      context,
      AppDialog(
        title: 'Statement preview',
        description: 'November 2026',
        size: AppDialogSize.large,
        onClose: () {},
        body: const Text('Long content scrolls inside the dialog while the header and footer stay put.'),
        footer: [AppButton(label: 'Download PDF', onPressed: () {})],
      ),
    );

/// Must be finished or cancelled: no Esc, no backdrop tap.
@widgetbook.UseCase(name: 'NotDismissible', type: AppDialog, path: _overlays)
Widget buildDialogNotDismissible(BuildContext context) => previewSurface(
      context,
      Builder(
        builder: (context) => AppButton(
          label: 'Open',
          onPressed: () => showAppDialog<void>(
            context: context,
            title: 'Delete this account?',
            description: 'The account will be closed and its balance moved to the parent account.',
            isDismissible: false,
            hideCloseButton: true,
            footerBuilder: (context, close) => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(label: 'Cancel', variant: AppButtonVariant.secondary, onPressed: close),
                const SizedBox(width: 12),
                AppButton(label: 'Delete account', variant: AppButtonVariant.danger, onPressed: close),
              ],
            ),
          ),
        ),
      ),
    );

// --------------------------------------------------------------------- Select

const _accountTypes = [
  AppSelectOption(value: 'INDIVIDUAL', label: 'Individual'),
  AppSelectOption(value: 'BUSINESS', label: 'Business'),
  AppSelectOption(value: 'JOINT', label: 'Joint', isDisabled: true),
];

Widget _select(BuildContext context, {String? value, String? placeholder, String? errorText, bool disabled = false}) =>
    _stage(
      context,
      SizedBox(
        width: 360,
        child: _SelectPlayground(initial: value, placeholder: placeholder, errorText: errorText, disabled: disabled),
      ),
      height: 260,
    );

@widgetbook.UseCase(name: 'Default', type: AppSelect, path: _inputs)
Widget buildSelectDefault(BuildContext context) => _select(context, value: 'INDIVIDUAL');

@widgetbook.UseCase(name: 'Placeholder', type: AppSelect, path: _inputs)
Widget buildSelectPlaceholder(BuildContext context) => _select(context, placeholder: 'Choose a type');

@widgetbook.UseCase(name: 'Error', type: AppSelect, path: _inputs)
Widget buildSelectError(BuildContext context) =>
    _select(context, placeholder: 'Choose a type', errorText: 'Choose an account type.');

@widgetbook.UseCase(name: 'Disabled', type: AppSelect, path: _inputs)
Widget buildSelectDisabled(BuildContext context) => _select(context, value: 'BUSINESS', disabled: true);

class _SelectPlayground extends StatefulWidget {
  const _SelectPlayground({required this.initial, required this.placeholder, required this.errorText, required this.disabled});

  final String? initial;
  final String? placeholder;
  final String? errorText;
  final bool disabled;

  @override
  State<_SelectPlayground> createState() => _SelectPlaygroundState();
}

class _SelectPlaygroundState extends State<_SelectPlayground> {
  late String? _value = widget.initial;

  @override
  Widget build(BuildContext context) => AppSelect<String>(
        label: 'Account type',
        isRequired: true,
        value: _value,
        placeholder: widget.placeholder,
        errorText: widget.errorText,
        isDisabled: widget.disabled,
        options: _accountTypes,
        onChanged: (value) => setState(() => _value = value),
      );
}

// ------------------------------------------------------------------- Calendar

DateTime _inDays(int days) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + days);
}

bool _isWeekend(DateTime date) => date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

AppCalendarWeekStart _weekStartKnob(BuildContext context) => context.knobs.object.dropdown(
      label: 'weekStartsOn',
      options: AppCalendarWeekStart.values,
      initialOption: AppCalendarWeekStart.sunday,
      labelBuilder: (value) => value.name,
    );

AppCalendarSize _sizeKnob(BuildContext context, AppCalendarSize initial) => context.knobs.object.dropdown(
      label: 'size',
      options: AppCalendarSize.values,
      initialOption: initial,
      labelBuilder: (value) => value.name,
    );

@widgetbook.UseCase(name: 'Single', type: AppCalendar, path: _inputs)
Widget buildCalendarSingle(BuildContext context) => previewSurface(
      context,
      AppCalendar.single(
        selectedDate: _inDays(0),
        weekStartsOn: _weekStartKnob(context),
        size: _sizeKnob(context, AppCalendarSize.medium),
        onChanged: (_) {},
      ),
    );

@widgetbook.UseCase(name: 'Range', type: AppCalendar, path: _inputs)
Widget buildCalendarRange(BuildContext context) => previewSurface(
      context,
      AppCalendar.range(
        selectedRange: AppDateRange(start: _inDays(-6), end: _inDays(0)),
        weekStartsOn: _weekStartKnob(context),
        size: _sizeKnob(context, AppCalendarSize.medium),
        onChanged: (_) {},
      ),
    );

/// Only the next 60 days, weekdays only.
@widgetbook.UseCase(name: 'Restricted', type: AppCalendar, path: _inputs)
Widget buildCalendarRestricted(BuildContext context) => previewSurface(
      context,
      AppCalendar.single(
        minDate: _inDays(0),
        maxDate: _inDays(60),
        isDateDisabled: _isWeekend,
        weekStartsOn: _weekStartKnob(context),
        onChanged: (_) {},
      ),
    );

/// As in the date range picker: two months, small days, no future dates.
@widgetbook.UseCase(name: 'TwoMonths', type: AppCalendar, path: _inputs)
Widget buildCalendarTwoMonths(BuildContext context) => previewSurface(
      context,
      AppCalendar.range(
        numberOfMonths: 2,
        size: AppCalendarSize.small,
        maxDate: _inDays(0),
        weekStartsOn: _weekStartKnob(context),
        onChanged: (_) {},
      ),
    );

@widgetbook.UseCase(name: 'Sizes', type: AppCalendar, path: _inputs)
Widget buildCalendarSizes(BuildContext context) => previewSurface(
      context,
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final size in AppCalendarSize.values) ...[
            AppCalendar.single(size: size, weekStartsOn: _weekStartKnob(context), onChanged: (_) {}),
            const SizedBox(width: 48),
          ],
        ],
      ),
    );

// ------------------------------------------------------------ DateRangePicker

Widget _range(BuildContext context, AppDateRangePicker picker) => _stage(context, picker, height: 520);

/// As on the dashboard: no future dates.
@widgetbook.UseCase(name: 'Default', type: AppDateRangePicker, path: _inputs)
Widget buildRangeDefault(BuildContext context) =>
    _range(context, AppDateRangePicker(maxDate: _inDays(0), initiallyOpen: true));

@widgetbook.UseCase(name: 'WithValue', type: AppDateRangePicker, path: _inputs)
Widget buildRangeWithValue(BuildContext context) => _range(
      context,
      AppDateRangePicker(maxDate: _inDays(0), value: AppDateRange(start: _inDays(-6), end: _inDays(0))),
    );

@widgetbook.UseCase(name: 'CustomPresets', type: AppDateRangePicker, path: _inputs)
Widget buildRangeCustomPresets(BuildContext context) => _range(
      context,
      AppDateRangePicker(
        maxDate: _inDays(0),
        initiallyOpen: true,
        presets: [
          AppDateRangePreset(label: 'Yesterday', range: () => AppDateRange(start: _inDays(-1), end: _inDays(-1))),
          AppDateRangePreset(
            label: 'This year',
            range: () => AppDateRange(start: DateTime(DateTime.now().year), end: _inDays(0)),
          ),
        ],
      ),
    );

@widgetbook.UseCase(name: 'WithoutPresets', type: AppDateRangePicker, path: _inputs)
Widget buildRangeWithoutPresets(BuildContext context) =>
    _range(context, AppDateRangePicker(maxDate: _inDays(0), presets: const [], initiallyOpen: true));

@widgetbook.UseCase(name: 'WithLabel', type: AppDateRangePicker, path: _inputs)
Widget buildRangeWithLabel(BuildContext context) => _range(
      context,
      AppDateRangePicker(
        maxDate: _inDays(0),
        label: 'Statement period',
        isRequired: true,
        description: 'Up to 12 months.',
      ),
    );

@widgetbook.UseCase(name: 'Error', type: AppDateRangePicker, path: _inputs)
Widget buildRangeError(BuildContext context) => _range(
      context,
      AppDateRangePicker(maxDate: _inDays(0), label: 'Statement period', errorText: 'Pick a period.'),
    );

/// Single day: AppDatePicker.
@widgetbook.UseCase(name: 'SingleDate', type: AppDateRangePicker, path: _inputs)
Widget buildRangeSingleDate(BuildContext context) =>
    _stage(context, AppDatePicker(label: 'Opening date', maxDate: _inDays(0)), height: 520);
