// AppButton: Flutter counterpart of React <Button>. Same variants, sizes,
// colours (AppTokens) and states as react/src/components/Button.
import 'package:flutter/material.dart';

import '../foundation/app_pressable.dart';
import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';

/// Same names as the React `variant` options.
enum AppButtonVariant { primary, secondary, ghost, link, danger }

/// 32 / 40 / 48 px. Same names as the React `size` options.
enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required String this.label,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.leadingIcon,
    this.trailingIcon,
    this.isFullWidth = false,
    this.isSelected = false,
    this.isDisabled = false,
    this.isLoading = false,
    this.onPressed,
    this.focusNode,
  })  : icon = null,
        semanticLabel = null;

  /// Square button showing only [icon]. [semanticLabel] is read by screen readers.
  const AppButton.icon({
    super.key,
    required Widget this.icon,
    required String this.semanticLabel,
    this.variant = AppButtonVariant.secondary,
    this.size = AppButtonSize.medium,
    this.isSelected = false,
    this.isDisabled = false,
    this.isLoading = false,
    this.onPressed,
    this.focusNode,
  })  : label = null,
        leadingIcon = null,
        trailingIcon = null,
        isFullWidth = false;

  /// Button text. Keep it short: a verb, sentence case.
  final String? label;

  /// The icon of an icon-only button.
  final Widget? icon;
  final String? semanticLabel;

  /// primary: main action. secondary: white with a border ("Filters", "Cancel").
  /// ghost: no border ("Reset"). link: text only ("Back to login"). danger: destructive.
  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Icon before the label, e.g. `AppIcon(AppIcons.plus)`.
  final Widget? leadingIcon;

  /// Icon after the label, e.g. `AppIcon(AppIcons.chevronDown)`.
  final Widget? trailingIcon;

  /// Stretch to the width of the parent.
  final bool isFullWidth;

  /// Toggle state, e.g. a "Filters" button while its popover is open.
  final bool isSelected;

  /// Blocks interaction. Primary buttons turn light blue, others grey.
  final bool isDisabled;

  /// Shows a spinner, keeps the width and colours, ignores taps. Stays focusable.
  final bool isLoading;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;

  double get _height => switch (size) {
        AppButtonSize.small => 32,
        AppButtonSize.medium => 40,
        AppButtonSize.large => 48,
      };

  double get _padding => switch (size) {
        AppButtonSize.small => 12,
        AppButtonSize.medium => 16,
        AppButtonSize.large => 20,
      };

  double get _fontSize => switch (size) {
        AppButtonSize.small => AppType.sm,
        AppButtonSize.medium => AppType.md,
        AppButtonSize.large => AppType.lg,
      };

  double get _radius => size == AppButtonSize.small ? AppRadius.sm : AppRadius.md;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final isIconOnly = icon != null;
    final isLink = variant == AppButtonVariant.link;

    return AppPressable(
      onTap: isLoading ? null : onPressed,
      enabled: !isDisabled,
      selected: isSelected,
      semanticLabel: semanticLabel,
      focusNode: focusNode,
      mouseCursor: isDisabled
          ? SystemMouseCursors.basic
          : (isLoading ? SystemMouseCursors.progress : SystemMouseCursors.click),
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        final pressed = states.contains(WidgetState.pressed);
        final disabled = isDisabled;

        Color background = Colors.transparent;
        Color foreground = t.text;
        Color? border;
        List<BoxShadow> shadow = AppShadows.none;
        double opacity = 1;

        switch (variant) {
          case AppButtonVariant.primary:
            foreground = t.onPrimary;
            background = disabled
                ? t.primaryDisabled
                : pressed
                    ? t.primaryPressed
                    : hovered
                        ? t.primaryHover
                        : t.primary;
          case AppButtonVariant.secondary:
            background = (hovered || isSelected) && !disabled ? t.surfaceMuted : t.surface;
            border = isSelected && !disabled ? t.primaryBorderSubtle : t.borderInput;
            foreground = disabled ? t.textDisabled : (isSelected ? t.primaryText : t.text);
            shadow = disabled ? AppShadows.none : AppShadows.xs;
          case AppButtonVariant.ghost:
            background = (hovered || isSelected) && !disabled ? t.surfaceMuted : Colors.transparent;
            foreground = disabled ? t.textDisabled : (isSelected ? t.primaryText : t.text);
          case AppButtonVariant.link:
            foreground = disabled ? t.primaryDisabled : t.primaryText;
          case AppButtonVariant.danger:
            foreground = t.onPrimary;
            background = hovered && !disabled ? t.dangerText : t.danger;
            opacity = disabled ? 0.5 : 1;
        }

        final textStyle = AppType.style(
          _fontSize,
          weight: FontWeight.w500,
          color: foreground,
          height: 1,
        ).copyWith(
          decoration: isLink && hovered ? TextDecoration.underline : TextDecoration.none,
          decorationColor: foreground,
        );

        Widget content = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon case final leading?) ...[leading, const SizedBox(width: AppSpacing.s2)],
            if (icon case final iconOnly?) iconOnly,
            if (label case final text?) Flexible(child: Text(text, overflow: TextOverflow.ellipsis, maxLines: 1)),
            if (trailingIcon case final trailing?) ...[const SizedBox(width: AppSpacing.s2), trailing],
          ],
        );

        // While loading, the label stays in the layout and in the semantics tree.
        if (isLoading) {
          content = Stack(
            alignment: Alignment.center,
            children: [
              Opacity(opacity: 0, alwaysIncludeSemantics: true, child: content),
              SizedBox.square(
                dimension: _fontSize * 1.15,
                child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
              ),
            ],
          );
        }

        final box = Opacity(
          opacity: opacity,
          child: AnimatedContainer(
            duration: AppDurations.fast,
            height: isLink ? null : _height,
            width: isIconOnly ? _height : (isFullWidth ? double.infinity : null),
            padding: EdgeInsets.symmetric(horizontal: isLink || isIconOnly ? 0 : _padding),
            // Only align when the width is fixed: an aligned Container with a free
            // width would stretch to fill its parent.
            alignment: (isIconOnly || isFullWidth) ? Alignment.center : null,
            decoration: BoxDecoration(
              color: isLink ? null : background,
              borderRadius: AppRadius.all(_radius),
              border: Border.all(color: border ?? Colors.transparent),
              boxShadow: shadow,
            ),
            child: DefaultTextStyle.merge(
              style: textStyle,
              child: IconTheme.merge(
                data: IconThemeData(color: foreground, size: 16),
                child: content,
              ),
            ),
          ),
        );

        return AppFocusRing(
          visible: states.contains(WidgetState.focused),
          borderRadius: _radius,
          child: box,
        );
      },
    );
  }
}
