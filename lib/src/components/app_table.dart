// AppTable: Flutter counterpart of React <Table>. 12 px rounded border,
// 42 px header, 56 px rows (comfortable) as in the Accounts screenshot.
import 'package:flutter/material.dart';

import '../foundation/app_pressable.dart';
import '../theme/app_metrics.dart';
import '../theme/app_tokens.dart';
import 'app_checkbox.dart';
import 'app_icon.dart';

enum AppTableAlign { start, center, end }

/// comfortable: 56 px rows (screenshot). compact: 44 px. Same names as React.
enum AppTableDensity { comfortable, compact }

enum AppSortDirection { asc, desc }

@immutable
class AppTableSort {
  const AppTableSort({required this.key, required this.direction});

  final String key;
  final AppSortDirection direction;
}

@immutable
class AppTableColumn<R> {
  const AppTableColumn({
    required this.key,
    required this.header,
    this.cellBuilder,
    this.text,
    this.width,
    this.flex = 1,
    this.align = AppTableAlign.start,
    this.isSortable = false,
    this.isMuted = false,
  });

  /// Unique id, also the sort key.
  final String key;

  /// Header text, e.g. "Account ID".
  final String header;

  /// Custom cell, e.g. `(context, row, i) => AppStatusBadge(...)`.
  final Widget Function(BuildContext context, R row, int index)? cellBuilder;

  /// Plain-text cell (used when there's no [cellBuilder]).
  final String Function(R row)? text;

  /// Fixed width in px. Without it the column shares the free space by [flex].
  final double? width;
  final int flex;
  final AppTableAlign align;

  /// Tapping the header calls onSortChanged. Sorting the data is up to you.
  final bool isSortable;

  /// Grey secondary text, e.g. dates (as in the Opened column).
  final bool isMuted;
}

/// Data table with optional selection, sorting, loading and empty states, and a footer.
class AppTable<R> extends StatelessWidget {
  const AppTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.rowId,
    required this.caption,
    this.isSelectable = false,
    this.selectedIds = const {},
    this.onSelectionChanged,
    this.sort,
    this.onSortChanged,
    this.onRowTap,
    this.isLoading = false,
    this.loadingRowCount = 5,
    this.emptyState,
    this.density = AppTableDensity.comfortable,
    this.footer,
    this.minWidth = 720,
  });

  final List<AppTableColumn<R>> columns;
  final List<R> rows;

  /// Stable id per row (selection).
  final String Function(R row) rowId;

  /// Accessible name, e.g. "Accounts".
  final String caption;

  /// Checkbox column with select-all.
  final bool isSelectable;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>>? onSelectionChanged;
  final AppTableSort? sort;
  final ValueChanged<AppTableSort>? onSortChanged;

  /// Makes rows tappable (and focusable: Enter opens).
  final ValueChanged<R>? onRowTap;
  final bool isLoading;
  final int loadingRowCount;

  /// Shown when there are no rows. Default: "No results".
  final Widget? emptyState;
  final AppTableDensity density;

  /// Under the rows, e.g. AppPagination.
  final Widget? footer;

  /// Below this width the table scrolls sideways instead of squashing columns.
  final double minWidth;

  static const double _padding = 18;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final ids = rows.map(rowId).toList();
    final selectedOnPage = ids.where(selectedIds.contains).length;
    final allSelected = ids.isNotEmpty && selectedOnPage == ids.length;
    final someSelected = selectedOnPage > 0 && !allSelected;
    final rowHeight = density == AppTableDensity.comfortable ? 56.0 : 44.0;
    final divider = BorderSide(color: t.borderSubtle);

    void setSelection(Set<String> next) => onSelectionChanged?.call(next);

    Widget cell(AppTableColumn<R> column, Widget child) {
      final aligned = Align(
        alignment: switch (column.align) {
          AppTableAlign.start => Alignment.centerLeft,
          AppTableAlign.center => Alignment.center,
          AppTableAlign.end => Alignment.centerRight,
        },
        child: child,
      );
      final padded = Padding(padding: const EdgeInsets.symmetric(horizontal: _padding), child: aligned);
      final width = column.width;
      return width != null ? SizedBox(width: width, child: padded) : Expanded(flex: column.flex, child: padded);
    }

    Widget selectCell(Widget? child) => Padding(
          padding: const EdgeInsets.only(left: _padding),
          child: SizedBox(width: 24, child: child),
        );

    // Header
    final header = Container(
      height: 42,
      decoration: BoxDecoration(border: Border(bottom: divider)),
      child: Row(
        children: [
          if (isSelectable)
            selectCell(
              AppCheckbox(
                value: allSelected,
                isIndeterminate: someSelected,
                isDisabled: isLoading || rows.isEmpty,
                semanticLabel: 'Select all rows',
                onChanged: (_) => setSelection(
                  allSelected ? (selectedIds.difference(ids.toSet())) : {...selectedIds, ...ids},
                ),
              ),
            ),
          for (final column in columns)
            cell(column, _HeaderLabel<R>(column: column, sort: sort, onSortChanged: onSortChanged)),
        ],
      ),
    );

    // Body
    final List<Widget> body;
    if (isLoading) {
      body = [
        for (var i = 0; i < loadingRowCount; i++)
          Container(
            height: rowHeight,
            decoration: BoxDecoration(border: i < loadingRowCount - 1 ? Border(bottom: divider) : null),
            child: Row(
              children: [
                if (isSelectable) selectCell(null),
                for (final column in columns)
                  cell(
                    column,
                    FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(color: t.surfaceSunken, borderRadius: AppRadius.all(AppRadius.sm)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ];
    } else if (rows.isEmpty) {
      body = [
        SizedBox(
          height: 120,
          child: Center(
            child: DefaultTextStyle.merge(
              style: AppType.style(AppType.md, color: t.textMuted),
              child: emptyState ?? const Text('No results'),
            ),
          ),
        ),
      ];
    } else {
      body = [
        for (var i = 0; i < rows.length; i++)
          _TableRow(
            height: rowHeight,
            isSelected: selectedIds.contains(ids[i]),
            isLast: i == rows.length - 1,
            onTap: onRowTap == null ? null : () => onRowTap!(rows[i]),
            children: [
              if (isSelectable)
                selectCell(
                  AppCheckbox(
                    value: selectedIds.contains(ids[i]),
                    semanticLabel: 'Select row ${i + 1}',
                    onChanged: (_) => setSelection(
                      selectedIds.contains(ids[i]) ? (selectedIds.difference({ids[i]})) : {...selectedIds, ids[i]},
                    ),
                  ),
                ),
              for (final column in columns)
                cell(
                  column,
                  DefaultTextStyle.merge(
                    style: AppType.style(AppType.md, color: column.isMuted ? t.textMuted : t.text),
                    child: column.cellBuilder?.call(context, rows[i], i) ??
                        Text(column.text?.call(rows[i]) ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ),
            ],
          ),
      ];
    }

    final table = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [header, ...body],
    );

    return Semantics(
      container: true,
      label: caption,
      child: Container(
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: AppRadius.all(AppRadius.lg),
          border: Border.all(color: t.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) => constraints.maxWidth >= minWidth
                  ? table
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(width: minWidth, child: table),
                    ),
            ),
            if (footer case final widget?)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: _padding, vertical: 12),
                decoration: BoxDecoration(border: Border(top: divider)),
                child: widget,
              ),
          ],
        ),
      ),
    );
  }
}

class _HeaderLabel<R> extends StatelessWidget {
  const _HeaderLabel({required this.column, required this.sort, required this.onSortChanged});

  final AppTableColumn<R> column;
  final AppTableSort? sort;
  final ValueChanged<AppTableSort>? onSortChanged;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final style = AppType.style(AppType.md, color: t.textMuted);
    final onSort = onSortChanged;
    if (!column.isSortable || onSort == null) {
      return Text(column.header, style: style, maxLines: 1, overflow: TextOverflow.ellipsis);
    }
    final current = sort;
    final isSorted = current != null && current.key == column.key;
    final descending = isSorted && current?.direction == AppSortDirection.desc;
    return AppPressable(
      onTap: () => onSort(AppTableSort(
        key: column.key,
        direction: isSorted && current?.direction == AppSortDirection.asc ? AppSortDirection.desc : AppSortDirection.asc,
      )),
      semanticLabel: '${column.header}, ${isSorted ? (descending ? 'sorted descending' : 'sorted ascending') : 'not sorted'}',
      builder: (context, states) => AppFocusRing(
        visible: states.contains(WidgetState.focused),
        borderRadius: 2,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                column.header,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: style.copyWith(color: states.contains(WidgetState.hovered) ? t.text : t.textMuted),
              ),
            ),
            const SizedBox(width: 4),
            AppIcon(descending ? AppIcons.arrowDown : AppIcons.arrowUp, size: 14, color: isSorted ? t.primaryText : t.textFaint),
          ],
        ),
      ),
    );
  }
}

class _TableRow extends StatefulWidget {
  const _TableRow({
    required this.height,
    required this.isSelected,
    required this.isLast,
    required this.onTap,
    required this.children,
  });

  final double height;
  final bool isSelected;
  final bool isLast;
  final VoidCallback? onTap;
  final List<Widget> children;

  @override
  State<_TableRow> createState() => _TableRowState();
}

class _TableRowState extends State<_TableRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);

    Widget row(bool hovered, bool focused) => AnimatedContainer(
          duration: AppDurations.fast,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.isSelected ? t.primaryFaint : (hovered ? t.surfaceMuted : t.surface),
            border: Border(
              bottom: widget.isLast ? BorderSide.none : BorderSide(color: t.borderSubtle),
              top: focused ? BorderSide(color: t.primaryBorder, width: 2) : BorderSide.none,
            ),
          ),
          child: Row(children: widget.children),
        );

    final onTap = widget.onTap;
    if (onTap == null) {
      return MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: row(_hovered, false),
      );
    }
    return AppPressable(
      onTap: onTap,
      isButton: false,
      builder: (context, states) =>
          row(states.contains(WidgetState.hovered), states.contains(WidgetState.focused)),
    );
  }
}
