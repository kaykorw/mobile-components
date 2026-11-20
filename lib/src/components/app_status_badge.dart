// AppStatusBadge: Flutter counterpart of React <StatusBadge>.
import 'package:flutter/material.dart';

import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';

/// Same names as the React `tone` options.
enum AppBadgeTone { success, warning, danger, info, neutral }

/// small = 18 px, medium = 20 px high. Same names as React.
enum AppBadgeSize { small, medium }

class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    super.key,
    required this.label,
    this.tone = AppBadgeTone.neutral,
    this.hasDot = false,
    this.icon,
    this.size = AppBadgeSize.medium,
  });

  /// Badge text. Casing is up to you ("ACTIVE", "Parent").
  final String label;
  final AppBadgeTone tone;

  /// Coloured dot before the label, for live states such as "ACTIVE".
  final bool hasDot;

  /// Optional icon before the label (instead of a dot).
  final Widget? icon;
  final AppBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final (Color background, Color foreground) = switch (tone) {
      AppBadgeTone.success => (t.successSubtle, t.success),
      AppBadgeTone.warning => (t.warningSubtle, t.warning),
      AppBadgeTone.danger => (t.dangerSubtle, t.dangerText),
      AppBadgeTone.info => (t.primarySubtle, t.primaryText),
      AppBadgeTone.neutral => (t.surfaceSunken, t.textMuted),
    };
    final isSmall = size == AppBadgeSize.small;

    return Container(
      height: isSmall ? 18 : 20,
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 6 : 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.all(AppRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: foreground, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ] else if (icon case final badgeIcon?) ...[
            IconTheme.merge(data: IconThemeData(color: foreground, size: 12), child: badgeIcon),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            maxLines: 1,
            style: AppType.style(isSmall ? 11 : AppType.xs, weight: FontWeight.w500, color: foreground, height: 1),
          ),
        ],
      ),
    );
  }
}
