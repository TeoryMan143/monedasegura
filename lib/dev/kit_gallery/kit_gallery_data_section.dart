import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/failure.dart';
import '../../core/theme/app_theme.dart';
import '../../core/ui/kit.dart';

typedef _DemoRow = ({
  String id,
  String customer,
  String account,
  String type,
  int amount,
  int? score,
});

final _demoRows = <_DemoRow>[
  for (var i = 0; i < 57; i++)
    (
      id: 'TX-${77100 + i}',
      customer: const [
        'Juan Pérez',
        'Ana Ruiz',
        'Luis Mora',
        'Sofía Díaz',
      ][i % 4],
      account: '•••• ${4417 + i}',
      type: const ['Transferencia', 'Compra', 'Retiro'][i % 3],
      amount: 150000 + i * 37500,
      score: i % 5 == 0 ? 95 - i : null,
    ),
];

/// Gallery panels for KpiCard, AppDataTable + Pagination and the ScreenState variants.
class KitGalleryDataSection extends StatefulWidget {
  const KitGalleryDataSection({super.key});

  @override
  State<KitGalleryDataSection> createState() => _KitGalleryDataSectionState();
}

class _KitGalleryDataSectionState extends State<KitGalleryDataSection> {
  Set<Object> _selected = {};
  AppTableSort _sort = const AppTableSort(
    columnId: 'amount',
    direction: SortDirection.descending,
  );
  int _page = 1;
  int _pageSize = 25;
  bool _loading = false;
  Object? _activeKey;

  List<_DemoRow> get _pageRows {
    final sorted = [..._demoRows]
      ..sort((a, b) {
        final compare = switch (_sort.columnId) {
          'score' => (a.score ?? -1).compareTo(b.score ?? -1),
          _ => a.amount.compareTo(b.amount),
        };
        return _sort.direction == SortDirection.ascending ? compare : -compare;
      });
    final start = (_page - 1) * _pageSize;
    return sorted.skip(start).take(_pageSize).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          children: [
            Expanded(
              child: KpiCard(
                title: 'Transacciones etiquetadas',
                value: '3.906',
                icon: AppIcons.check,
                trend: KpiTrend(text: '+12 % vs. semana anterior', up: true),
              ),
            ),
            SizedBox(width: AppSpace.lg),
            Expanded(
              child: KpiCard(
                title: 'Fraudes confirmados',
                value: '284',
                icon: AppIcons.shield,
                trend: KpiTrend(
                  text: '+8 % vs. semana anterior',
                  up: true,
                  tone: StatusTone.danger,
                ),
              ),
            ),
            SizedBox(width: AppSpace.lg),
            Expanded(
              child: KpiCard(
                title: 'Precisión de la IA',
                value: '87 %',
                icon: AppIcons.ai,
                detail: 'Alertas confirmadas sobre resueltas',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppLayout.blockGap),
        SizedBox(
          height: 520,
          child: AppPanel(
            title: 'Tabla',
            subtitle: 'AppDataTable · AppTableCell · Pagination · SkeletonRow',
            padding: EdgeInsets.zero,
            expand: true,
            action: AppButton(
              label: _loading ? 'Ver datos' : 'Ver cargando',
              size: AppButtonSize.s,
              variant: AppButtonVariant.secondary,
              onPressed: () => setState(() => _loading = !_loading),
            ),
            child: Column(
              children: [
                Expanded(child: _table()),
                Pagination(
                  page: _page,
                  pageSize: _pageSize,
                  totalCount: _demoRows.length,
                  itemLabel: 'transacciones',
                  onPageChanged: (page) => setState(() => _page = page),
                  onPageSizeChanged: (size) => setState(() {
                    _pageSize = size;
                    _page = 1;
                  }),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppLayout.blockGap),
        AppPanel(
          title: 'Estados de pantalla',
          subtitle: 'ScreenState · EmptyState · ErrorState',
          child: SizedBox(
            height: 240,
            child: Row(
              children: [
                Expanded(
                  child: ScreenState<int>(
                    value: const AsyncLoading(),
                    builder: (context, value) => Text('$value'),
                  ),
                ),
                const Expanded(
                  child: EmptyState(
                    title: 'No hay alertas pendientes',
                    message: 'Las alertas nuevas aparecerán aquí.',
                  ),
                ),
                Expanded(
                  child: ScreenState<int>(
                    value: const AsyncError(
                      Failure.network(),
                      StackTrace.empty,
                    ),
                    onRetry: () {},
                    builder: (context, value) => Text('$value'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _table() {
    return AppDataTable<_DemoRow>(
      rows: _pageRows,
      rowKey: (row) => row.id,
      loading: _loading,
      sort: _sort,
      onSort: (id) => setState(() => _sort = _sort.toggle(id)),
      selectedKeys: _selected,
      onSelectionChanged: (keys) => setState(() => _selected = keys),
      activeKey: _activeKey,
      onRowTap: (row) => setState(() => _activeKey = row.id),
      isFlagged: (row) => row.score != null,
      rowSemanticLabel: (row) => 'Abrir ${row.id} de ${row.customer}',
      empty: const EmptyState.noResults(),
      columns: [
        AppTableColumn(
          id: 'id',
          label: 'Transacción',
          width: 140,
          cellBuilder: (context, row) =>
              AppTableCell(value: row.id, meta: '19 mar · 22:41'),
        ),
        AppTableColumn(
          id: 'customer',
          label: 'Cliente / cuenta',
          flex: 2,
          cellBuilder: (context, row) =>
              AppTableCell(value: row.customer, meta: '${row.account} · CO'),
        ),
        AppTableColumn(
          id: 'type',
          label: 'Tipo · canal',
          cellBuilder: (context, row) => AppTableCell(
            value: row.type,
            meta: 'App móvil',
            leadingIcon: row.score == null ? null : AppIcons.ai,
          ),
        ),
        AppTableColumn(
          id: 'amount',
          label: 'Monto',
          numeric: true,
          sortable: true,
          cellBuilder: (context, row) => AppTableCell(
            value: '\$ ${row.amount}',
            meta: 'COP',
            numeric: true,
          ),
        ),
        AppTableColumn(
          id: 'score',
          label: 'Alerta IA',
          width: 110,
          sortable: true,
          cellBuilder: (context, row) => row.score == null
              ? const Text('—')
              : ScoreBadge(score: row.score!),
        ),
      ],
    );
  }
}
