// AppSelect: Flutter counterpart of React <Select>. Same closed look (field
// with chevron). Opens a Kayko menu (React uses the browser's native list).
import 'package:flutter/material.dart';

import '../foundation/app_form_field.dart';
import '../foundation/app_pressable.dart';
import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';
import 'app_menu.dart';
import 'app_popover.dart';

/// One choice. Same shape as React `SelectOption`.
@immutable
class AppSelectOption<T> {
  const AppSelectOption({required this.value, required this.label, this.isDisabled = false});

  final T value;
  final String label;
  final bool isDisabled;
}

/// Pick one value from a list, e.g. "Account type".
class AppSelect<T> extends StatelessWidget {
  const AppSelect({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.label,
    this.semanticLabel,
    this.placeholder,
    this.description,
    this.errorText,
    this.isRequired = false,
    this.isDisabled = false,
    this.size = AppFieldSize.medium,
    this.leading,
    this.width,
  });

  final List<AppSelectOption<T>> options;

  /// Selected value, or null to show the [placeholder].
  final T? value;
  final ValueChanged<T>? onChanged;
  final String? label;

  /// Accessible name when there's no visible [label].
  final String? semanticLabel;

  /// Text shown while nothing is selected, e.g. "Choose a type".
  final String? placeholder;
  final String? description;
  final String? errorText;
  final bool isRequired;
  final bool isDisabled;
  final AppFieldSize size;

  /// Icon at the start.
  final Widget? leading;

  /// Fixed width. By default it fills its parent.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    AppSelectOption<T>? selected;
    for (final option in options) {
      if (option.value == value) selected = option;
    }
    final text = selected?.label ?? placeholder ?? '';

    final field = AppFormField(
      label: label,
      isRequired: isRequired,
      description: description,
      errorText: errorText,
      child: AppPopover(
        matchTriggerWidth: true,
        isFlush: true,
        semanticLabel: label ?? semanticLabel,
        triggerBuilder: (context, isOpen, toggle) => AppPressable(
          onTap: toggle,
          enabled: !isDisabled,
          semanticLabel: '${label ?? semanticLabel ?? ''}, $text',
          builder: (context, states) => AppFieldBox(
            size: size,
            focused: isOpen || states.contains(WidgetState.focused),
            hovered: states.contains(WidgetState.hovered),
            hasError: errorText != null,
            isDisabled: isDisabled,
            child: SizedBox(
              height: size.height - 2,
              child: Row(
                children: [
                  if (leading case final lead?) ...[lead, const SizedBox(width: AppSpacing.s2)],
                  Expanded(
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.style(
                        size.fontSize,
                        color: isDisabled ? t.textDisabled : (selected == null ? t.textSubtle : t.textStrong),
                      ),
                    ),
                  ),
                  AppIcon(AppIcons.chevronDown, size: 16, color: isDisabled ? t.textDisabled : t.textStrong),
                ],
              ),
            ),
          ),
        ),
        contentBuilder: (context, close) => AppMenu(
          semanticLabel: label ?? semanticLabel,
          children: [
            for (final option in options)
              AppMenuItem(
                label: option.label,
                trailing: AppMenuItemTrailing.check,
                isSelected: option.value == value,
                isDisabled: option.isDisabled,
                autofocus: option.value == value,
                onTap: () {
                  onChanged?.call(option.value);
                  close();
                },
              ),
          ],
        ),
      ),
    );
    return width == null ? field : SizedBox(width: width, child: field);
  }
}
