// AppFormField and AppFieldBox: the label / control / message layout and the
// bordered control box shared by AppTextField, AppTextarea, AppSelect and
// AppDatePicker. Same look as React FormField + controlStyles.module.css.
import 'package:flutter/material.dart';

import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';

/// 32 / 40 / 48 px. Same names as React `FieldSize`.
enum AppFieldSize { small, medium, large }

extension AppFieldSizeMetrics on AppFieldSize {
  double get height => switch (this) {
        AppFieldSize.small => 32,
        AppFieldSize.medium => 40,
        AppFieldSize.large => 48,
      };

  double get horizontalPadding => switch (this) {
        AppFieldSize.small => 10,
        AppFieldSize.medium => 12,
        AppFieldSize.large => 14,
      };

  double get fontSize => switch (this) {
        AppFieldSize.small => AppType.sm,
        AppFieldSize.medium => AppType.md,
        AppFieldSize.large => AppType.lg,
      };

  double get radius => this == AppFieldSize.small ? AppRadius.sm : AppRadius.md;
}

/// Label + control + helper or error text. Wrap any custom control with it.
class AppFormField extends StatelessWidget {
  const AppFormField({
    super.key,
    required this.child,
    this.label,
    this.isRequired = false,
    this.description,
    this.errorText,
    this.labelAside,
  });

  final Widget child;

  /// Field label, e.g. "Account name".
  final String? label;

  /// Shows a red asterisk after the label.
  final bool isRequired;

  /// Helper text under the control.
  final String? description;

  /// Error message under the control. Replaces the description.
  final String? errorText;

  /// Right side of the label row, e.g. a character counter.
  final Widget? labelAside;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final message = errorText ?? description;
    final hasLabelRow = label != null || labelAside != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasLabelRow) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (label case final text?)
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: text,
                      children: [
                        if (isRequired)
                          TextSpan(text: ' *', style: TextStyle(color: t.dangerAccent)),
                      ],
                    ),
                    style: AppType.style(AppType.md, weight: FontWeight.w500, color: t.textStrong),
                  ),
                )
              else
                const Spacer(),
              if (labelAside case final aside?)
                DefaultTextStyle.merge(
                  style: AppType.style(AppType.sm, color: t.textMuted),
                  child: aside,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
        ],
        child,
        if (message != null) ...[
          const SizedBox(height: AppSpacing.s2),
          Semantics(
            liveRegion: errorText != null,
            child: Text(
              message,
              style: AppType.style(
                AppType.sm,
                color: errorText != null ? t.dangerText : t.textMuted,
                height: 1.4,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// The bordered box around a text-like control, with hover, focus, error and
/// disabled styles. [focused] and [hovered] come from the control.
class AppFieldBox extends StatelessWidget {
  const AppFieldBox({
    super.key,
    required this.child,
    this.size = AppFieldSize.medium,
    this.focused = false,
    this.hovered = false,
    this.hasError = false,
    this.isDisabled = false,
    this.multiline = false,
  });

  final Widget child;
  final AppFieldSize size;
  final bool focused;
  final bool hovered;
  final bool hasError;
  final bool isDisabled;

  /// Grows with its content and pads vertically (text areas).
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);

    Color border = t.borderInput;
    List<BoxShadow> shadow = AppShadows.xs;
    if (isDisabled) {
      shadow = AppShadows.none;
    } else if (hasError) {
      border = t.dangerAccent;
      if (focused) shadow = [BoxShadow(color: t.dangerSubtle, spreadRadius: 3)];
    } else if (focused) {
      border = t.primaryBorder;
      shadow = [BoxShadow(color: t.focusRing, spreadRadius: 3)];
    } else if (hovered) {
      border = t.borderStrong;
    }

    return AnimatedContainer(
      duration: AppDurations.fast,
      constraints: BoxConstraints(minHeight: size.height),
      padding: EdgeInsets.symmetric(
        horizontal: size.horizontalPadding,
        vertical: multiline ? 10 : 0,
      ),
      decoration: BoxDecoration(
        color: isDisabled ? t.surfaceMuted : t.surface,
        borderRadius: AppRadius.all(size.radius),
        border: Border.all(color: border),
        boxShadow: shadow,
      ),
      child: DefaultTextStyle.merge(
        style: AppType.style(size.fontSize, color: isDisabled ? t.textDisabled : t.textStrong),
        child: IconTheme.merge(
          data: IconThemeData(color: t.textSubtle, size: 16),
          child: child,
        ),
      ),
    );
  }
}
