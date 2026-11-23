// AppCheckbox: Flutter counterpart of React <Checkbox>. Drawn by hand (not
// Material's Checkbox) so the box, border and states match React exactly.
//
// API mapping (React -> Flutter):
//   checked -> value, indeterminate -> isIndeterminate, disabled -> isDisabled,
//   error -> errorText, label/description: same, onChange(event) -> onChanged(bool)
// Clicking an indeterminate checkbox checks it, on both platforms.
import 'package:flutter/material.dart';

import '../foundation/app_pressable.dart';
import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.errorText,
    this.isIndeterminate = false,
    this.isDisabled = false,
    this.semanticLabel,
  });

  /// Checked or not. Shown as a dash while [isIndeterminate] is true.
  final bool value;

  /// Called with the new value. Tapping the label also toggles it.
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? description;

  /// Turns the box red and shows the message under the label.
  final String? errorText;

  /// Some, but not all, children are selected.
  final bool isIndeterminate;
  final bool isDisabled;

  /// Accessible name when there is no [label] (e.g. "Select all rows").
  final String? semanticLabel;

  bool get _isEnabled => !isDisabled && onChanged != null;

  void _toggle() => onChanged?.call(isIndeterminate ? true : !value);

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final hasError = errorText != null;
    final isOn = value || isIndeterminate;

    return AppPressable(
      onTap: _isEnabled ? _toggle : null,
      enabled: !isDisabled,
      isButton: false,
      checked: isIndeterminate ? null : value,
      mixed: isIndeterminate ? true : null,
      semanticLabel: label ?? semanticLabel,
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        final focused = states.contains(WidgetState.focused);

        Color fill = t.surface;
        Color border = t.borderStrong;
        if (isDisabled) {
          fill = isOn ? t.primaryDisabled : t.surfaceMuted;
          border = isOn ? t.primaryDisabled : t.borderInput;
        } else if (isOn) {
          fill = hasError ? t.danger : t.primary;
          border = fill;
        } else if (hasError) {
          border = t.dangerAccent;
        } else if (hovered || focused) {
          border = t.primaryBorder;
        }

        final box = SizedBox.square(
          dimension: 24,
          child: Center(
            child: AnimatedContainer(
              duration: AppDurations.fast,
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: AppRadius.all(AppRadius.xs),
                border: Border.all(color: border, width: 1.5),
                boxShadow: focused ? [BoxShadow(color: t.focusRing, spreadRadius: 3)] : null,
              ),
              child: isOn
                  ? AppIcon(
                      isIndeterminate ? AppIcons.minus : AppIcons.check,
                      size: 14,
                      strokeWidth: 3,
                      color: t.onPrimary,
                    )
                  : null,
            ),
          ),
        );

        final hasText = label != null || description != null || hasError;
        if (!hasText) return box;

        final textColor = isDisabled ? t.textDisabled : t.textStrong;
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            box,
            const SizedBox(width: AppSpacing.s2),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label case final text?)
                    Text(text, style: AppType.style(AppType.md, color: textColor, height: 24 / 14)),
                  if (description case final text?)
                    Text(
                      text,
                      style: AppType.style(
                        AppType.sm,
                        color: isDisabled ? t.textDisabled : t.textMuted,
                        height: 18 / 13,
                      ),
                    ),
                  if (errorText case final text?)
                    Text(text, style: AppType.style(AppType.sm, color: t.dangerText, height: 18 / 13)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
