// AppPagination: Flutter counterpart of React <Pagination>.
import 'package:flutter/material.dart';

import '../foundation/app_pressable.dart';
import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';

/// Page numbers with null for "…" gaps: (5, 20, 1) -> 1 … 4 5 6 … 20.
/// Same rule as React getPageItems().
List<int?> appPageItems(int page, int pageCount, {int siblingCount = 1}) {
  final totalShown = siblingCount * 2 + 5;
  if (pageCount <= totalShown) return [for (var i = 1; i <= pageCount; i++) i];
  final left = (page - siblingCount).clamp(1, pageCount).toInt();
  final right = (page + siblingCount).clamp(1, pageCount).toInt();
  final showLeftGap = left > 3;
  final showRightGap = right < pageCount - 2;
  final count = 3 + siblingCount * 2;
  if (!showLeftGap) return [for (var i = 1; i <= count; i++) i, null, pageCount];
  if (!showRightGap) return [1, null, for (var i = pageCount - count + 1; i <= pageCount; i++) i];
  return [1, null, for (var i = left; i <= right; i++) i, null, pageCount];
}

/// Page navigation, as in the Accounts table footer: "Page 1 of 1", arrows and page numbers.
class AppPagination extends StatelessWidget {
  const AppPagination({
    super.key,
    required this.page,
    required this.pageCount,
    required this.onPageChanged,
    this.siblingCount = 1,
    this.showLabel = true,
    this.isCompact = false,
    this.formatLabel,
    this.previousLabel = 'Previous page',
    this.nextLabel = 'Next page',
  });

  /// Current page, starting at 1.
  final int page;
  final int pageCount;
  final ValueChanged<int> onPageChanged;
  final int siblingCount;

  /// "Page 1 of 1" on the left.
  final bool showLabel;

  /// Only the arrows (phones, tight footers).
  final bool isCompact;

  /// Builds the label. Default: "Page {page} of {pageCount}".
  final String Function(int page, int pageCount)? formatLabel;
  final String previousLabel;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final total = pageCount < 1 ? 1 : pageCount;
    final current = page.clamp(1, total).toInt();

    Widget square({
      required Widget child,
      required String semanticLabel,
      VoidCallback? onTap,
      bool isCurrent = false,
    }) =>
        AppPressable(
          onTap: onTap,
          enabled: onTap != null || isCurrent,
          selected: isCurrent,
          semanticLabel: semanticLabel,
          builder: (context, states) {
            final hovered = states.contains(WidgetState.hovered);
            return AppFocusRing(
              visible: states.contains(WidgetState.focused),
              child: AnimatedContainer(
                duration: AppDurations.fast,
                constraints: const BoxConstraints(minWidth: 32),
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCurrent ? t.primaryFaint : (hovered ? t.surfaceMuted : Colors.transparent),
                  borderRadius: AppRadius.all(AppRadius.md),
                  border: Border.all(color: isCurrent ? t.primaryBorderSubtle : Colors.transparent),
                ),
                child: child,
              ),
            );
          },
        );

    final items = appPageItems(current, total, siblingCount: siblingCount);
    final controls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        square(
          semanticLabel: previousLabel,
          onTap: current > 1 ? () => onPageChanged(current - 1) : null,
          child: AppIcon(AppIcons.chevronLeft, size: 16, color: current > 1 ? t.text : t.textDisabled),
        ),
        if (!isCompact)
          for (final item in items) ...[
            const SizedBox(width: 4),
            if (item == null)
              SizedBox(width: 24, child: Center(child: Text('…', style: TextStyle(color: t.textSubtle))))
            else
              square(
                semanticLabel: 'Page $item',
                isCurrent: item == current,
                onTap: item == current ? null : () => onPageChanged(item),
                child: Text(
                  '$item',
                  style: AppType.style(
                    AppType.md,
                    weight: item == current ? FontWeight.w500 : FontWeight.w400,
                    color: item == current ? t.primaryText : t.text,
                  ),
                ),
              ),
          ],
        const SizedBox(width: 4),
        square(
          semanticLabel: nextLabel,
          onTap: current < total ? () => onPageChanged(current + 1) : null,
          child: AppIcon(AppIcons.chevronRight, size: 16, color: current < total ? t.text : t.textDisabled),
        ),
      ],
    );

    return Semantics(
      container: true,
      label: 'Pagination',
      child: Row(
        children: [
          if (showLabel)
            Semantics(
              liveRegion: true,
              child: Text(
                formatLabel?.call(current, total) ?? 'Page $current of $total',
                style: AppType.style(AppType.md, color: t.textMuted),
              ),
            ),
          const Spacer(),
          controls,
        ],
      ),
    );
  }
}
