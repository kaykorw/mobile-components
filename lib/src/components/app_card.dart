// AppCard: Flutter counterpart of React <Card>.
import 'package:flutter/material.dart';

import '../foundation/app_pressable.dart';
import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';

/// elevated: border + soft shadow (stat cards). outlined: border only (tables).
/// flat: grey, no border. Same names as React.
enum AppCardVariant { elevated, outlined, flat }

/// 0, 16, 20, 24 px. Same names as React.
enum AppCardPadding { none, small, medium, large }

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding = AppCardPadding.large,
    this.onTap,
    this.semanticLabel,
    this.width,
  });

  final Widget child;
  final AppCardVariant variant;
  final AppCardPadding padding;

  /// Makes the whole card clickable, with hover and focus styles.
  final VoidCallback? onTap;

  /// Accessible name when the card is clickable.
  final String? semanticLabel;
  final double? width;

  double get _padding => switch (padding) {
        AppCardPadding.none => 0,
        AppCardPadding.small => AppSpacing.s4,
        AppCardPadding.medium => AppSpacing.s5,
        AppCardPadding.large => AppSpacing.s6,
      };

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);

    Widget surface({bool hovered = false}) {
      final (Color background, Color border, List<BoxShadow> shadow) = switch (variant) {
        AppCardVariant.elevated => (t.surface, hovered ? t.borderInput : t.border, hovered ? AppShadows.md : AppShadows.sm),
        AppCardVariant.outlined => (t.surface, hovered ? t.borderInput : t.border, hovered ? AppShadows.md : AppShadows.none),
        AppCardVariant.flat => (t.surfaceMuted, Colors.transparent, hovered ? AppShadows.sm : AppShadows.none),
      };
      return AnimatedContainer(
        duration: AppDurations.normal,
        width: width,
        padding: EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadius.all(AppRadius.xl),
          border: Border.all(color: border),
          boxShadow: shadow,
        ),
        child: DefaultTextStyle.merge(style: TextStyle(color: t.text), child: child),
      );
    }

    final tap = onTap;
    if (tap == null) return surface();
    return AppPressable(
      onTap: tap,
      semanticLabel: semanticLabel,
      builder: (context, states) => AppFocusRing(
        visible: states.contains(WidgetState.focused),
        borderRadius: AppRadius.xl,
        child: surface(hovered: states.contains(WidgetState.hovered)),
      ),
    );
  }
}
