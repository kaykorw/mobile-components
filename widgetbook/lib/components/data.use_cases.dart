// Use cases for Table, Pagination and BarChart (with ChartCard).
// Names MUST match the React story names. Never rename them once embedded in zeroheight.
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'preview_surface.dart';

const _data = '[Components]/data display';
const _navigation = '[Components]/navigation';

// ---------------------------------------------------------------- Table

class _Account {
  const _Account({
    required this.id,
    required this.name,
    required this.type,
    required this.opened,
    this.isParent = false,
    this.status = 'ACTIVE',
  });

  final String id;
  final String name;
  final String type;
  final String opened;
  final bool isParent;
  final String status;

  String field(String key) => switch (key) {
        'id' => id,
        'name' => name,
        'status' => status,
        _ => opened,
      };
}

const _ordinals = ['First', 'Second', 'Third', 'Fourth', 'Fifth', 'Sixth', 'Seventh', 'Eighth', 'Nineth'];

final List<_Account> _accounts = [
  for (var i = _ordinals.length - 1; i >= 0; i--)
    _Account(
      id: '${26019381231 + i}',
      name: '${_ordinals[i]} sub-account',
      type: 'INDIVIDUAL',
      opened: '2026-11-16, 16:${(43 + i ~/ 2).toString().padLeft(2, '0')}',
    ),
  const _Account(
    id: '26019381230',
    name: 'Business Account',
    type: 'BUSINESS',
    isParent: true,
    opened: '2026-11-10, 12:47',
  ),
];

final List<AppTableColumn<_Account>> _columns = [
  AppTableColumn(key: 'id', header: 'Account ID', flex: 18, isSortable: true, text: (row) => row.id),
  AppTableColumn(
    key: 'name',
    header: 'Name',
    flex: 48,
    isSortable: true,
    cellBuilder: (context, row, _) => AppAvatarLabel(
      title: row.name,
      description: row.type,
      extra: row.isParent ? const AppStatusBadge(label: 'Parent', tone: AppBadgeTone.warning) : null,
    ),
  ),
  AppTableColumn(
    key: 'status',
    header: 'Status',
    flex: 16,
    cellBuilder: (context, row, _) => AppStatusBadge(
      label: row.status,
      tone: row.status == 'ACTIVE' ? AppBadgeTone.success : AppBadgeTone.danger,
      hasDot: true,
    ),
  ),
  AppTableColumn(key: 'opened', header: 'Opened', flex: 18, isSortable: true, isMuted: true, text: (row) => row.opened),
];

/// Holds selection and sort state so the knobs-driven preview behaves like the app.
class _TableDemo extends StatefulWidget {
  const _TableDemo({
    required this.rows,
    this.isSelectable = true,
    this.isSortable = false,
    this.isClickable = false,
    this.isLoading = false,
    this.density = AppTableDensity.comfortable,
    this.emptyState,
  });

  final List<_Account> rows;
  final bool isSelectable;
  final bool isSortable;
  final bool isClickable;
  final bool isLoading;
  final AppTableDensity density;
  final Widget? emptyState;

  @override
  State<_TableDemo> createState() => _TableDemoState();
}

class _TableDemoState extends State<_TableDemo> {
  Set<String> _selected = {};
  AppTableSort _sort = const AppTableSort(key: 'opened', direction: AppSortDirection.desc);

  @override
  Widget build(BuildContext context) {
    final rows = [...widget.rows];
    if (widget.isSortable) {
      rows.sort((a, b) {
        final order = a.field(_sort.key).compareTo(b.field(_sort.key));
        return _sort.direction == AppSortDirection.asc ? order : -order;
      });
    }
    return AppTable<_Account>(
      caption: 'Accounts',
      columns: _columns,
      rows: rows,
      rowId: (row) => row.id,
      isSelectable: widget.isSelectable,
      selectedIds: _selected,
      onSelectionChanged: (next) => setState(() => _selected = next),
      sort: widget.isSortable ? _sort : null,
      onSortChanged: widget.isSortable ? (next) => setState(() => _sort = next) : null,
      onRowTap: widget.isClickable
          ? (row) => ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text('Open ${row.name}')))
          : null,
      isLoading: widget.isLoading,
      density: widget.density,
      emptyState: widget.emptyState,
      footer: AppPagination(page: 1, pageCount: 1, onPageChanged: (_) {}),
    );
  }
}

Widget _table(
  BuildContext context, {
  List<_Account>? rows,
  bool isSelectable = true,
  bool isSortable = false,
  bool isClickable = false,
  bool isLoading = false,
  AppTableDensity density = AppTableDensity.comfortable,
  Widget? emptyState,
}) {
  return previewSurface(
    context,
    _TableDemo(
      rows: rows ?? _accounts,
      isSelectable: context.knobs.boolean(label: 'selectable', initialValue: isSelectable),
      isSortable: isSortable,
      isClickable: isClickable,
      isLoading: context.knobs.boolean(label: 'loading', initialValue: isLoading),
      density: context.knobs.object.dropdown(
        label: 'density',
        options: AppTableDensity.values,
        initialOption: density,
        labelBuilder: (value) => value.name,
      ),
      emptyState: emptyState,
    ),
  );
}

/// The Accounts table.
@widgetbook.UseCase(name: 'Default', type: AppTable, path: _data)
Widget buildTableDefault(BuildContext context) => _table(context);

@widgetbook.UseCase(name: 'Sortable', type: AppTable, path: _data)
Widget buildTableSortable(BuildContext context) => _table(context, isSortable: true);

@widgetbook.UseCase(name: 'Clickable', type: AppTable, path: _data)
Widget buildTableClickable(BuildContext context) => _table(context, isSelectable: false, isClickable: true);

@widgetbook.UseCase(name: 'Compact', type: AppTable, path: _data)
Widget buildTableCompact(BuildContext context) =>
    _table(context, isSelectable: false, density: AppTableDensity.compact);

@widgetbook.UseCase(name: 'Loading', type: AppTable, path: _data)
Widget buildTableLoading(BuildContext context) => _table(context, isLoading: true);

@widgetbook.UseCase(name: 'Empty', type: AppTable, path: _data)
Widget buildTableEmpty(BuildContext context) => _table(
      context,
      rows: const [],
      emptyState: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('No accounts match these filters.'),
          const SizedBox(height: 12),
          AppButton(
            label: 'Reset filters',
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.small,
            leadingIcon: const AppIcon(AppIcons.refresh),
            onPressed: () {},
          ),
        ],
      ),
    );

// ---------------------------------------------------------------- Pagination

class _PaginationDemo extends StatefulWidget {
  const _PaginationDemo({
    required this.initialPage,
    required this.pageCount,
    required this.isCompact,
    required this.showLabel,
    required this.siblingCount,
  });

  final int initialPage;
  final int pageCount;
  final bool isCompact;
  final bool showLabel;
  final int siblingCount;

  @override
  State<_PaginationDemo> createState() => _PaginationDemoState();
}

class _PaginationDemoState extends State<_PaginationDemo> {
  late int _page = widget.initialPage;

  @override
  void didUpdateWidget(_PaginationDemo old) {
    super.didUpdateWidget(old);
    if (old.initialPage != widget.initialPage) _page = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) => AppPagination(
        page: _page,
        pageCount: widget.pageCount,
        onPageChanged: (page) => setState(() => _page = page),
        isCompact: widget.isCompact,
        showLabel: widget.showLabel,
        siblingCount: widget.siblingCount,
      );
}

Widget _pagination(BuildContext context, {int page = 1, int pageCount = 1, bool isCompact = false}) {
  return previewSurface(
    context,
    _PaginationDemo(
      initialPage: context.knobs.int.input(label: 'page', initialValue: page),
      pageCount: context.knobs.int.input(label: 'pageCount', initialValue: pageCount),
      isCompact: context.knobs.boolean(label: 'compact', initialValue: isCompact),
      showLabel: context.knobs.boolean(label: 'showLabel', initialValue: true),
      siblingCount: context.knobs.int.slider(label: 'siblingCount', initialValue: 1, min: 0, max: 3),
    ),
  );
}

/// As in the Accounts table: one page.
@widgetbook.UseCase(name: 'Default', type: AppPagination, path: _navigation)
Widget buildPaginationDefault(BuildContext context) => _pagination(context);

@widgetbook.UseCase(name: 'ManyPages', type: AppPagination, path: _navigation)
Widget buildPaginationManyPages(BuildContext context) => _pagination(context, page: 5, pageCount: 20);

@widgetbook.UseCase(name: 'Compact', type: AppPagination, path: _navigation)
Widget buildPaginationCompact(BuildContext context) =>
    _pagination(context, page: 2, pageCount: 8, isCompact: true);

// ---------------------------------------------------------------- BarChart

const List<AppChartDatum> _volume = [
  AppChartDatum(category: '10 Nov', values: {'in': 500, 'out': 300}),
  AppChartDatum(category: '11 Nov', values: {'in': 0, 'out': 175}),
  AppChartDatum(category: '16 Nov', values: {'in': 500, 'out': 272}),
  AppChartDatum(category: '17 Nov', values: {'in': 200, 'out': 125}),
  AppChartDatum(category: '18 Nov', values: {'in': 315, 'out': 0}),
  AppChartDatum(category: '19 Nov', values: {'in': 100, 'out': 0}),
];

String _rwf(double value) {
  final digits = value.round().toString();
  final grouped = digits.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  return 'RWF $grouped';
}

List<AppChartSeries> _series(BuildContext context) {
  final t = AppTokens.of(context);
  return [
    AppChartSeries(key: 'in', label: 'Money in', color: t.successStrong),
    AppChartSeries(key: 'out', label: 'Money out', color: t.danger),
  ];
}

Widget _chart(
  BuildContext context, {
  List<AppChartDatum> data = _volume,
  List<AppChartSeries>? series,
  bool isStacked = false,
}) {
  return AppBarChart(
    data: data,
    series: series ?? _series(context),
    semanticLabel: 'Money in and out per day, 10 to 19 November',
    isStacked: context.knobs.boolean(label: 'stacked', initialValue: isStacked),
    height: context.knobs.double.slider(label: 'height', initialValue: 240, min: 120, max: 400),
    showLegend: context.knobs.boolean(label: 'showLegend', initialValue: true),
    showGrid: context.knobs.boolean(label: 'showGrid', initialValue: true),
    formatValue: _rwf,
  );
}

@widgetbook.UseCase(name: 'Grouped', type: AppBarChart, path: _data)
Widget buildBarChartGrouped(BuildContext context) => previewSurface(context, _chart(context));

@widgetbook.UseCase(name: 'Stacked', type: AppBarChart, path: _data)
Widget buildBarChartStacked(BuildContext context) => previewSurface(context, _chart(context, isStacked: true));

@widgetbook.UseCase(name: 'SingleSeries', type: AppBarChart, path: _data)
Widget buildBarChartSingleSeries(BuildContext context) => previewSurface(
      context,
      _chart(context, series: const [AppChartSeries(key: 'in', label: 'Money in')]),
    );

@widgetbook.UseCase(name: 'Empty', type: AppBarChart, path: _data)
Widget buildBarChartEmpty(BuildContext context) => previewSurface(context, _chart(context, data: const []));

/// The Transaction volume card from the dashboard.
@widgetbook.UseCase(name: 'InCard', type: AppBarChart, path: _data)
Widget buildBarChartInCard(BuildContext context) => previewSurface(
      context,
      AppChartCard(
        title: 'Transaction volume',
        description: 'Money in is everything received, money out is everything sent, and net is the difference.\n'
            'Hover a day to see its totals.',
        stats: const [
          AppChartStat(label: 'Money in', value: 'RWF 1.6K', tone: AppChartStatTone.positive),
          AppChartStat(label: 'Money out', value: 'RWF 872', tone: AppChartStatTone.negative),
        ],
        chart: _chart(context),
      ),
    );
