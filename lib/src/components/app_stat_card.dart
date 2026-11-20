// AppStatCard: Flutter counterpart of React <StatCard>.
import 'package:flutter/material.dart';

import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';
import 'app_card.dart';
import 'app_icon.dart';
import 'app_icon_tile.dart';

/// Same names as React `TrendDirection`.
enum AppTrendDirection { up, down, flat }

enum AppTrendSentiment { positive, negative, neutral }

/// Change indicator under the value, e.g. "+12% vs last week".
@immutable
class AppStatTrend {
  const AppStatTrend({required this.value, required this.direction, this.sentiment, this.label});

  final String value;
  final AppTrendDirection direction;

  /// By default up = positive (green), down = negative (red). Set to flip it, e.g. for costs.
  final AppTrendSentiment? sentiment;

  /// Text after the value, e.g. "vs last week".
  final String? label;
}

/// Metric card: icon, label, big value, caption (e.g. "Money in / RWF 1,615").
class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.label,
    required this.value,
    this.caption,
    this.icon,
    this.iconTone = AppIconTileTone.primary,
    this.trend,
    this.isLoading = false,
    this.variant = AppCardVariant.elevated,
    this.onTap,
  });

  /// Name of the metric, e.g. "Money in".
  final String label;

  /// The number, already formatted, e.g. "RWF 1,615".
  final String value;

  /// Explanation under the value, e.g. "Credits posted to your accounts".
  final String? caption;

  /// Icon in the tile, e.g. `AppIcon(AppIcons.arrowDownToLine)`.
  final Widget? icon;
  final AppIconTileTone iconTone;
  final AppStatTrend? trend;

  /// Shows placeholders while the value loads.
  final bool isLoading;
  final AppCardVariant variant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);

    Widget skeleton(double widthFactor, double height) => FractionallySizedBox(
          widthFactor: widthFactor,
          alignment: Alignment.centerLeft,
          child: Container(
            height: height,
            decoration: BoxDecoration(color: t.surfaceSunken, borderRadius: AppRadius.all(AppRadius.sm)),
          ),
        );

    final trendValue = trend;
    Widget? trendRow;
    if (trendValue != null && !isLoading) {
      final sentiment = trendValue.sentiment ??
          switch (trendValue.direction) {
            AppTrendDirection.up => AppTrendSentiment.positive,
            AppTrendDirection.down => AppTrendSentiment.negative,
            AppTrendDirection.flat => AppTrendSentiment.neutral,
          };
      final color = switch (sentiment) {
        AppTrendSentiment.positive => t.success,
        AppTrendSentiment.negative => t.dangerText,
        AppTrendSentiment.neutral => t.textMuted,
      };
      trendRow = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trendValue.direction != AppTrendDirection.flat) ...[
            AppIcon(trendValue.direction == AppTrendDirection.up ? AppIcons.arrowUp : AppIcons.arrowDown, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(trendValue.value, style: AppType.style(AppType.sm, weight: FontWeight.w500, color: color)),
          if (trendValue.label case final text?) ...[
            const SizedBox(width: 4),
            Text(text, style: AppType.style(AppType.sm, color: t.textMuted)),
          ],
        ],
      );
    }

    return Semantics(
      container: true,
      label: isLoading ? '$label, loading' : null,
      child: AppCard(
        variant: variant,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon case final tileIcon?) ...[
                  AppIconTile(icon: tileIcon, tone: iconTone),
                  const SizedBox(width: AppSpacing.s3),
                ],
                Flexible(child: Text(label, style: AppType.style(AppType.md, color: t.textMuted))),
              ],
            ),
            const SizedBox(height: AppSpacing.s3 + AppSpacing.s2),
            if (isLoading)
              skeleton(0.6, 32)
            else
              Text(
                value,
                style: AppType.style(
                  AppType.x3l,
                  weight: FontWeight.w700,
                  color: t.textStrong,
                  height: 1.15,
                  letterSpacing: -0.28,
                ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
              ),
            if (trendRow != null) ...[const SizedBox(height: AppSpacing.s2), trendRow],
            if (caption case final text?) ...[
              const SizedBox(height: AppSpacing.s2),
              if (isLoading) skeleton(0.8, 14) else Text(text, style: AppType.style(AppType.md, color: t.textMuted)),
            ],
          ],
        ),
      ),
    );
  }
}
