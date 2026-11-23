// AppBarChart and AppChartCard: Flutter counterparts of React <BarChart> and
// <ChartCard>. Same scale rule, bar sizes, hover column, tooltip and legend
// as the Transaction volume chart.
//
// TextPainter's textDirection is set with the setter: in Flutter 3.50 the
// constructor parameter is private named, which older language versions can't pass.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';
import 'app_card.dart';
import 'app_title.dart';

/// One series. Same shape as React `ChartSeries`.
@immutable
class AppChartSeries {
  const AppChartSeries({required this.key, required this.label, this.color});

  /// Key into each datum's [AppChartDatum.values].
  final String key;

  /// Legend and tooltip name, e.g. "Money in".
  final String label;

  /// Defaults to the chart palette (AppTokens.chartSeries).
  final Color? color;
}

/// One category on the x axis, e.g. a day, with a value per series.
@immutable
class AppChartDatum {
  const AppChartDatum({required this.category, required this.values});

  /// x-axis label, e.g. "10 Nov".
  final String category;
  final Map<String, double> values;

  double valueOf(String key) => values[key] ?? 0;
}

/// Axis ticks: 20 % headroom, rounded up to a nice number, split into equal steps
/// (500 -> 0,150,300,450,600). Same rule as React chartTicks().
List<double> appChartTicks(double maxValue, {int tickCount = 4}) {
  if (!(maxValue > 0)) return [for (var i = 0; i <= tickCount; i++) i.toDouble()];
  final target = maxValue * 1.2;
  final magnitude = math.pow(10, (math.log(target) / math.ln10).floor()).toDouble();
  const steps = [1.0, 1.2, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0];
  final nice = steps.firstWhere((step) => step * magnitude >= target) * magnitude;
  return [for (var i = 0; i <= tickCount; i++) nice / tickCount * i];
}

/// 1615 -> "1.6K", 872 -> "872". Same as React compactNumber().
String appCompactNumber(double value) {
  String trim(double v) => v.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
  final abs = value.abs();
  if (abs >= 1e9) return '${trim(value / 1e9)}B';
  if (abs >= 1e6) return '${trim(value / 1e6)}M';
  if (abs >= 1e3) return '${trim(value / 1e3)}K';
  return value == value.roundToDouble() ? value.toInt().toString() : value.toStringAsFixed(2);
}

/// Bars per category, grouped or stacked, with hover/keyboard tooltip and a legend.
class AppBarChart extends StatefulWidget {
  const AppBarChart({
    super.key,
    required this.data,
    required this.series,
    required this.semanticLabel,
    this.isStacked = false,
    this.height = 240,
    this.formatValue,
    this.formatTick,
    this.formatCategory,
    this.showLegend = true,
    this.showGrid = true,
    this.maxBarWidth = 24,
    this.emptyState,
  });

  final List<AppChartDatum> data;
  final List<AppChartSeries> series;

  /// Accessible summary, e.g. "Money in and out per day, 10 to 19 November".
  final String semanticLabel;

  /// Stack the series in one bar instead of side by side.
  final bool isStacked;

  /// Plot height (without legend).
  final double height;

  /// Tooltip values, e.g. (v) => 'RWF ${v.toStringAsFixed(0)}'.
  final String Function(double value)? formatValue;

  /// y-axis ticks. Default: compact numbers (1.6K).
  final String Function(double value)? formatTick;
  final String Function(String category)? formatCategory;
  final bool showLegend;
  final bool showGrid;
  final double maxBarWidth;
  final Widget? emptyState;

  @override
  State<AppBarChart> createState() => _AppBarChartState();
}

class _AppBarChartState extends State<AppBarChart> {
  static const double _axisWidth = 48;
  static const double _xLabelHeight = 28;
  int? _active;

  String _value(double v) => widget.formatValue?.call(v) ?? appCompactNumber(v);

  void _move(int delta) {
    if (widget.data.isEmpty) return;
    setState(() {
      final current = _active;
      _active = current == null ? 0 : (current + delta + widget.data.length) % widget.data.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final palette = t.chartSeries;
    final colors = [
      for (var i = 0; i < widget.series.length; i++) widget.series[i].color ?? palette[i % palette.length],
    ];

    final summary = [
      for (final d in widget.data)
        '${d.category}: ${[for (final s in widget.series) '${s.label} ${_value(d.valueOf(s.key))}'].join(', ')}',
    ].join('; ');

    final active = _active;
    final activeDatum = active != null && active < widget.data.length ? widget.data[active] : null;

    Widget plot;
    if (widget.data.isEmpty) {
      plot = SizedBox(
        height: widget.height + _xLabelHeight,
        child: Center(
          child: DefaultTextStyle.merge(
            style: AppType.style(AppType.md, color: t.textMuted),
            child: widget.emptyState ?? const Text('No data for this period'),
          ),
        ),
      );
    } else {
      plot = LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final band = (width - _axisWidth) / widget.data.length;
          final tooltipX = active == null ? 0.0 : _axisWidth + band * active + band / 2;
          final tooltipOnLeft = tooltipX > width - 220;

          return MouseRegion(
            onHover: (event) {
              final index = ((event.localPosition.dx - _axisWidth) / band).floor();
              final next = (index >= 0 && index < widget.data.length && event.localPosition.dy <= widget.height) ? index : null;
              if (next != _active) setState(() => _active = next);
            },
            onExit: (_) => setState(() => _active = null),
            child: SizedBox(
              height: widget.height + _xLabelHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _BarChartPainter(
                        data: widget.data,
                        series: widget.series,
                        colors: colors,
                        isStacked: widget.isStacked,
                        plotHeight: widget.height,
                        axisWidth: _axisWidth,
                        maxBarWidth: widget.maxBarWidth,
                        showGrid: widget.showGrid,
                        active: active,
                        formatTick: widget.formatTick ?? appCompactNumber,
                        gridColor: t.border,
                        labelColor: t.textSubtle,
                        hoverColor: t.surfaceSunken,
                      ),
                    ),
                  ),
                  if (activeDatum != null)
                    Positioned(
                      left: tooltipOnLeft ? null : tooltipX + 16,
                      right: tooltipOnLeft ? width - tooltipX + 16 : null,
                      top: math.max(0, widget.height / 2 - 40),
                      child: IgnorePointer(
                        child: _Tooltip(
                          title: widget.formatCategory?.call(activeDatum.category) ?? activeDatum.category,
                          rows: [
                            for (var i = 0; i < widget.series.length; i++)
                              (colors[i], widget.series[i].label, _value(activeDatum.valueOf(widget.series[i].key))),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Semantics(
      container: true,
      label: '${widget.semanticLabel}. $summary',
      value: activeDatum == null
          ? null
          : '${activeDatum.category}: ${[for (final s in widget.series) '${s.label} ${_value(activeDatum.valueOf(s.key))}'].join(', ')}',
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowRight): () => _move(1),
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _move(-1),
          const SingleActivator(LogicalKeyboardKey.escape): () => setState(() => _active = null),
        },
        child: FocusableActionDetector(
          onFocusChange: (focused) {
            if (!focused) setState(() => _active = null);
          },
          child: ExcludeSemantics(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                plot,
                if (widget.showLegend && widget.series.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < widget.series.length; i++)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(color: colors[i], borderRadius: AppRadius.all(3)),
                            ),
                            const SizedBox(width: 8),
                            Text(widget.series[i].label, style: AppType.style(AppType.md, color: t.textMuted)),
                          ],
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tooltip extends StatelessWidget {
  const _Tooltip({required this.title, required this.rows});

  final String title;
  final List<(Color, String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 180),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: AppRadius.all(AppRadius.lg),
        border: Border.all(color: t.border),
        boxShadow: AppShadows.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppType.style(AppType.sm, color: t.textMuted)),
          const SizedBox(height: 8),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: rows[i].$1, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(rows[i].$2, style: AppType.style(AppType.md, color: t.textMuted)),
                const SizedBox(width: 24),
                Text(
                  rows[i].$3,
                  style: AppType.style(AppType.md, weight: FontWeight.w600, color: t.textHeading),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter({
    required this.data,
    required this.series,
    required this.colors,
    required this.isStacked,
    required this.plotHeight,
    required this.axisWidth,
    required this.maxBarWidth,
    required this.showGrid,
    required this.active,
    required this.formatTick,
    required this.gridColor,
    required this.labelColor,
    required this.hoverColor,
  });

  final List<AppChartDatum> data;
  final List<AppChartSeries> series;
  final List<Color> colors;
  final bool isStacked;
  final double plotHeight;
  final double axisWidth;
  final double maxBarWidth;
  final bool showGrid;
  final int? active;
  final String Function(double value) formatTick;
  final Color gridColor;
  final Color labelColor;
  final Color hoverColor;

  TextPainter _label(String text) {
    final painter = TextPainter(text: TextSpan(text: text, style: AppType.style(AppType.xs, color: labelColor)));
    painter.textDirection = TextDirection.ltr;
    painter.layout();
    return painter;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final totals = [
      for (final d in data)
        isStacked
            ? series.fold<double>(0, (sum, s) => sum + math.max(0, d.valueOf(s.key)))
            : series.fold<double>(0, (m, s) => math.max(m, d.valueOf(s.key))),
    ];
    final ticks = appChartTicks(totals.fold<double>(0, math.max));
    final top = ticks.last;
    double y(double v) => plotHeight - v / top * plotHeight;

    final plotWidth = size.width - axisWidth;
    final band = plotWidth / data.length;
    final groupWidth = math.min(
      band * 0.6,
      isStacked ? maxBarWidth * 1.5 : (maxBarWidth + 2) * series.length,
    );
    final barWidth = isStacked ? groupWidth : math.max(2.0, (groupWidth - 2 * (series.length - 1)) / series.length);

    // Hover column
    final activeIndex = active;
    if (activeIndex != null) {
      canvas.drawRect(Rect.fromLTWH(axisWidth + band * activeIndex, 0, band, plotHeight), Paint()..color = hoverColor);
    }

    // Grid and y labels
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (final tick in ticks) {
      final ty = y(tick).roundToDouble() + 0.5;
      if (showGrid) canvas.drawLine(Offset(axisWidth, ty), Offset(size.width, ty), gridPaint);
      final label = _label(formatTick(tick));
      label.paint(canvas, Offset(axisWidth - 12 - label.width, ty - label.height / 2));
    }

    // Bars and x labels
    for (var i = 0; i < data.length; i++) {
      final datum = data[i];
      final groupLeft = axisWidth + band * i + (band - groupWidth) / 2;
      var stackBase = 0.0;
      for (var s = 0; s < series.length; s++) {
        final v = datum.valueOf(series[s].key);
        if (v <= 0) continue;
        final barHeight = v / top * plotHeight;
        final x = isStacked ? groupLeft : groupLeft + s * (barWidth + 2);
        final barTop = isStacked ? y(stackBase + v) : y(v);
        final isTop = !isStacked || series.skip(s + 1).every((next) => datum.valueOf(next.key) <= 0);
        if (isStacked) stackBase += v;
        final r = isTop ? math.min(3.0, math.min(barWidth / 2, barHeight)) : 0.0;
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(x, barTop, barWidth, barHeight),
            topLeft: Radius.circular(r),
            topRight: Radius.circular(r),
          ),
          Paint()..color = colors[s],
        );
      }
      final label = _label(datum.category);
      label.paint(canvas, Offset(axisWidth + band * i + band / 2 - label.width / 2, plotHeight + 20 - label.height + 2));
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) =>
      old.data != data ||
      old.series != series ||
      old.active != active ||
      old.isStacked != isStacked ||
      old.plotHeight != plotHeight ||
      old.showGrid != showGrid ||
      old.gridColor != gridColor;
}

/// One headline number in an [AppChartCard]. Same shape as React `ChartStat`.
@immutable
class AppChartStat {
  const AppChartStat({required this.label, required this.value, this.tone = AppChartStatTone.neutral});

  final String label;

  /// Already formatted, e.g. "RWF 1.6K".
  final String value;
  final AppChartStatTone tone;
}

/// positive = green (money in), negative = red (money out). Same names as React.
enum AppChartStatTone { positive, negative, neutral }

/// Card for a chart: section title, headline numbers, the chart. As in "Transaction volume".
class AppChartCard extends StatelessWidget {
  const AppChartCard({
    super.key,
    required this.title,
    required this.chart,
    this.description,
    this.actions = const [],
    this.stats = const [],
  });

  final String title;
  final String? description;

  /// Controls on the right of the title, e.g. an AppDateRangePicker.
  final List<Widget> actions;
  final List<AppChartStat> stats;

  /// The chart (AppBarChart or any other).
  final Widget chart;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Semantics(
      container: true,
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTitle(size: AppTitleSize.section, title: title, description: description, actions: actions),
            if (stats.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s6),
              Wrap(
                spacing: AppSpacing.s8,
                runSpacing: AppSpacing.s4,
                children: [
                  for (final stat in stats)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stat.label, style: AppType.style(AppType.md, color: t.textMuted)),
                        const SizedBox(height: 4),
                        Text(
                          stat.value,
                          style: AppType.style(
                            AppType.x2l,
                            weight: FontWeight.w700,
                            height: 1.2,
                            color: switch (stat.tone) {
                              AppChartStatTone.positive => t.successText,
                              AppChartStatTone.negative => t.dangerText,
                              AppChartStatTone.neutral => t.textStrong,
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.s6),
            chart,
          ],
        ),
      ),
    );
  }
}
