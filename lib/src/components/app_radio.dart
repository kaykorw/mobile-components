// AppRadioGroup: Flutter counterpart of React <RadioGroup>. Drawn by hand so
// it matches React (and avoids Material Radio's changing groupValue API).
import 'package:flutter/material.dart';

import '../foundation/app_pressable.dart';
import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';

/// One option of an [AppRadioGroup]. Same shape as React `RadioOption`.
@immutable
class AppRadioOption<T> {
  const AppRadioOption({required this.value, required this.label, this.description, this.isDisabled = false});

  final T value;
  final String label;
  final String? description;
  final bool isDisabled;
}

/// Same names as React `orientation`.
enum AppRadioOrientation { vertical, horizontal }

/// A set of mutually exclusive options, e.g. the Status filter (ACTIVE / INACTIVE).
class AppRadioGroup<T> extends StatelessWidget {
  const AppRadioGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.label,
    this.semanticLabel,
    this.orientation = AppRadioOrientation.vertical,
    this.isDisabled = false,
    this.errorText,
  });

  final List<AppRadioOption<T>> options;

  /// Selected value, or null for none.
  final T? value;
  final ValueChanged<T>? onChanged;

  /// Visible group label above the options.
  final String? label;

  /// Accessible group name when there's no visible [label].
  final String? semanticLabel;
  final AppRadioOrientation orientation;
  final bool isDisabled;

  /// Error message under the options.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final hasError = errorText != null;

    final items = [
      for (final option in options)
        _RadioItem<T>(
          option: option,
          selected: option.value == value,
          enabled: !isDisabled && !option.isDisabled,
          hasError: hasError,
          onSelect: onChanged == null ? null : () => onChanged!(option.value),
        ),
    ];

    return Semantics(
      container: true,
      label: label ?? semanticLabel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label case final text?) ...[
            ExcludeSemantics(
              child: Text(text, style: AppType.style(AppType.md, weight: FontWeight.w500, color: t.textStrong)),
            ),
            const SizedBox(height: AppSpacing.s3),
          ],
          if (orientation == AppRadioOrientation.vertical)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.s4),
                  items[i],
                ],
              ],
            )
          else
            Wrap(spacing: AppSpacing.s6, runSpacing: AppSpacing.s3, children: items),
          if (errorText case final text?) ...[
            const SizedBox(height: AppSpacing.s2),
            Text(text, style: AppType.style(AppType.sm, color: t.dangerText)),
          ],
        ],
      ),
    );
  }
}

class _RadioItem<T> extends StatelessWidget {
  const _RadioItem({
    required this.option,
    required this.selected,
    required this.enabled,
    required this.hasError,
    required this.onSelect,
  });

  final AppRadioOption<T> option;
  final bool selected;
  final bool enabled;
  final bool hasError;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return AppPressable(
      onTap: enabled ? onSelect : null,
      enabled: enabled,
      isButton: false,
      checked: selected,
      inMutuallyExclusiveGroup: true,
      semanticLabel: option.label,
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        final focused = states.contains(WidgetState.focused);

        Color ring = t.textMuted;
        double ringWidth = 1.5;
        Color fill = t.surface;
        if (!enabled) {
          ring = selected ? t.primaryDisabled : t.borderInput;
          fill = selected ? t.surface : t.surfaceMuted;
          ringWidth = selected ? 5 : 1.5;
        } else if (selected) {
          ring = t.primary;
          ringWidth = 5;
        } else if (hasError) {
          ring = t.dangerAccent;
        } else if (hovered) {
          ring = t.primary;
        }

        final circle = SizedBox.square(
          dimension: 24,
          child: Center(
            child: AnimatedContainer(
              duration: AppDurations.fast,
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
                border: Border.all(color: ring, width: ringWidth),
                boxShadow: focused ? [BoxShadow(color: t.focusRing, spreadRadius: 3)] : null,
              ),
            ),
          ),
        );

        final textColor = enabled ? t.textStrong : t.textDisabled;
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            circle,
            const SizedBox(width: AppSpacing.s3),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.label, style: AppType.style(AppType.md, color: textColor, height: 24 / 14)),
                  if (option.description case final text?)
                    Text(
                      text,
                      style: AppType.style(AppType.sm, color: enabled ? t.textMuted : t.textDisabled, height: 18 / 13),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
