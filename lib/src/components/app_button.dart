// Minimal AppButton that matches the Widgetbook use-case template.
// Put this file at: app_ui/lib/src/components/app_button.dart
// and export it from app_ui/lib/app_ui.dart:
//   export 'src/components/app_button.dart';
//
// Uses package:flutter/material.dart (not material_ui) so it matches Widgetbook 3.x.
import 'package:flutter/material.dart';

/// Visual style. Keep these names identical to the React `variant` options.
enum AppButtonVariant { primary, secondary, danger }

/// Height and padding. Keep these names identical to the React `size` options.
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

  final String label;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isDisabled;
  final bool isLoading;
  final VoidCallback? onPressed;

  double get _height => switch (size) {
        AppButtonSize.small => 32,
        AppButtonSize.medium => 40,
        AppButtonSize.large => 48,
      };

  EdgeInsetsGeometry get _padding => switch (size) {
        AppButtonSize.small => const EdgeInsets.symmetric(horizontal: 12),
        AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: 16),
        AppButtonSize.large => const EdgeInsets.symmetric(horizontal: 24),
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final callback = (isDisabled || isLoading) ? null : onPressed;
    final minimumSize = Size(64, _height);

    final Widget child = isLoading
        ? SizedBox.square(
            dimension: _height / 2,
            child: const CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label);

    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: callback,
          style: FilledButton.styleFrom(
            minimumSize: minimumSize,
            padding: _padding,
          ),
          child: child,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: callback,
          style: OutlinedButton.styleFrom(
            minimumSize: minimumSize,
            padding: _padding,
          ),
          child: child,
        ),
      AppButtonVariant.danger => FilledButton(
          onPressed: callback,
          style: FilledButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.onError,
            minimumSize: minimumSize,
            padding: _padding,
          ),
          child: child,
        ),
    };
  }
}
