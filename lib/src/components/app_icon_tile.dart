// AppIconTile: Flutter counterpart of React <IconTile>.
import 'package:flutter/material.dart';

import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';

/// Same names as React.
enum AppIconTileTone { primary, success, warning, danger, neutral }

/// 32, 40, 64 px. Same names as React.
enum AppIconTileSize { small, medium, large }

/// Icon on a tinted rounded square, as on the stat cards and the "Verify your email" card.
class AppIconTile extends StatelessWidget {
  const AppIconTile({
    super.key,
    required this.icon,
    this.tone = AppIconTileTone.primary,
    this.size = AppIconTileSize.small,
  });

  /// The icon, e.g. `AppIcon(AppIcons.mail)`. Sized to half the tile.
  final Widget icon;
  final AppIconTileTone tone;
  final AppIconTileSize size;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final (Color background, Color foreground) = switch (tone) {
      AppIconTileTone.primary => (t.primarySubtle, t.primaryText),
      AppIconTileTone.success => (t.successSubtle, t.success),
      AppIconTileTone.warning => (t.warningSubtle, t.warning),
      AppIconTileTone.danger => (t.dangerSubtle, t.danger),
      AppIconTileTone.neutral => (t.surfaceSunken, t.textMuted),
    };
    final (double dimension, double radius) = switch (size) {
      AppIconTileSize.small => (32.0, AppRadius.md),
      AppIconTileSize.medium => (40.0, 10.0),
      AppIconTileSize.large => (64.0, AppRadius.xl),
    };
    return ExcludeSemantics(
      child: Container(
        width: dimension,
        height: dimension,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: background, borderRadius: AppRadius.all(radius)),
        child: IconTheme.merge(
          data: IconThemeData(color: foreground, size: dimension / 2),
          child: icon,
        ),
      ),
    );
  }
}
