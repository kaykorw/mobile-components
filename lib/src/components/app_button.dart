// AppButton: Flutter counterpart of React <Button>.
// Same variants, sizes, heights and colours as react/src/components/Button.
//
// Uses package:flutter/material.dart (not material_ui) to match Widgetbook 3.x.
import 'package:flutter/material.dart';

/// Visual style. Same names as the React `variant` options.
enum AppButtonVariant { primary, secondary, danger }

/// Height and padding (32 / 40 / 48 px). Same names as the React `size` options.
enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isDisabled = false,
    this.isLoading = false,
    this.onPressed,
  });

  /// Button text. Keep it short: a verb, sentence case.
  final String label;
  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Blocks interaction and greys the button out.
  final bool isDisabled;

  /// Shows a spinner, keeps the button's width and its colours, and ignores taps.
  final bool isLoading;

  final VoidCallback? onPressed;

  double get _height => switch (size) {
        AppButtonSize.small => 32,
        AppButtonSize.medium => 40,
        AppButtonSize.large => 48,
      };

  double get _horizontalPadding => switch (size) {
        AppButtonSize.small => 12,
        AppButtonSize.medium => 16,
        AppButtonSize.large => 24,
      };

  double get _fontSize => switch (size) {
        AppButtonSize.small => 13,
        AppButtonSize.medium => 14,
        AppButtonSize.large => 16,
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final (Color background, Color foreground) = switch (variant) {
      AppButtonVariant.primary => (colors.primary, colors.onPrimary),
      AppButtonVariant.secondary => (Colors.transparent, colors.primary),
      AppButtonVariant.danger => (colors.error, colors.onError),
    };
    final isSecondary = variant == AppButtonVariant.secondary;

    // Material 3 disabled colours: 12% container, 38% content.
    final disabledBackground =
        isSecondary ? Colors.transparent : colors.onSurface.withValues(alpha: 0.12);
    final disabledForeground = colors.onSurface.withValues(alpha: 0.38);

    // Loading also passes onPressed: null (so taps are ignored), but keeps the
    // enabled colours. Only a real `isDisabled` greys the button out.
    bool greyedOut(Set<WidgetState> states) =>
        states.contains(WidgetState.disabled) && !isLoading;

    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(64, _height)),
      // Desktop and web default to a compact density, which would shrink the
      // button by 8 px. Standard keeps the heights equal to React's.
      visualDensity: VisualDensity.standard,
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: _horizontalPadding),
      ),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
      textStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w600),
      ),
      elevation: const WidgetStatePropertyAll(0.0),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => greyedOut(states) ? disabledBackground : background,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => greyedOut(states) ? disabledForeground : foreground,
      ),
      // Hover 8%, press/focus 12% state layer of the text colour (Material 3).
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed) || states.contains(WidgetState.focused)) {
          return foreground.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered)) {
          return foreground.withValues(alpha: 0.08);
        }
        return null;
      }),
      side: isSecondary
          ? WidgetStateProperty.resolveWith(
              (states) => BorderSide(
                color: greyedOut(states)
                    ? colors.onSurface.withValues(alpha: 0.12)
                    : colors.outline,
              ),
            )
          : null,
    );

    // The label stays in the layout while loading, so the width doesn't jump.
    final child = Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: !isLoading,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          maintainSemantics: true,
          child: Text(label),
        ),
        if (isLoading)
          SizedBox.square(
            dimension: _fontSize * 1.15,
            child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
          ),
      ],
    );

    return TextButton(
      onPressed: (isDisabled || isLoading) ? null : onPressed,
      style: style,
      child: child,
    );
  }
}
