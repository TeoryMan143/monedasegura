import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/catalogs/catalog_providers.dart';
import '../../../../core/domain/fraud_type.dart';
import '../../../../core/domain/page_result.dart';
import '../../../../core/formatting/date_time.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/ai_alert.dart';
import '../../domain/alerts_query.dart';
import '../controllers/alerts_providers.dart';
import '../controllers/alerts_query_controller.dart';

const _scoreWidth = 96.0;
const _dateWidth = 112.0;
const _statusWidth = 160.0;

/// Opens an alert: the detail screen (HU-07).
typedef OpenAlert = void Function(String alertId);

/// The table of A-04 (HU-06), first version: pending alerts, highest score first.
///
/// It only watches the providers and draws what they return. The order, the filters and
/// the page come from the database through `alertsPageProvider`. The screen states
/// (loading, empty, error) go through [ScreenState] and [AppDataTable].
///
/// A click on a row calls [onOpen]. The router passes it, so this feature does not
/// depend on the app's routes.
class AlertsInboxTable extends ConsumerWidget {
  const AlertsInboxTable({required this.onOpen, super.key});

  final OpenAlert onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(alertsQueryProvider);
    final page = ref.watch(alertsPageProvider(query));

    Widget table({List<AiAlert> rows = const [], bool loading = false}) {
      return AppDataTable<AiAlert>(
        columns: _columns,
        rows: rows,
        rowKey: (alert) => alert.id,
        onRowTap: (alert) => onOpen(alert.id),
        loading: loading,
        empty: _EmptyAlerts(query: query),
        rowSemanticLabel: (alert) => '${alert.code} de ${alert.customerName}',
      );
    }

    final notifier = ref.read(alertsQueryProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ScreenState<PageResult<AiAlert>>(
            value: page,
            onRetry: () => ref.invalidate(alertsPageProvider(query)),
            loading: table(loading: true),
            builder: (context, result) => table(rows: result.items),
          ),
        ),
        if (page case AsyncValue(:final value?))
          Pagination(
            page: query.page,
            pageSize: query.pageSize,
            totalCount: value.total,
            itemLabel: 'alertas',
            pageSizes: AlertsQuery.pageSizes,
            onPageChanged: notifier.setPage,
            onPageSizeChanged: notifier.setPageSize,
          )
        else
          const _PaginationPlaceholder(),
      ],
    );
  }
}

final List<AppTableColumn<AiAlert>> _columns = [
  AppTableColumn(
    id: 'score',
    label: 'Score',
    width: _scoreWidth,
    cellBuilder: (context, alert) => Align(
      alignment: Alignment.centerLeft,
      child: ScoreBadge(score: alert.score),
    ),
  ),
  AppTableColumn(
    id: 'type',
    label: 'Tipo sugerido',
    minWidth: 160,
    cellBuilder: (context, alert) =>
        _SuggestedTypeCell(type: alert.suggestedType),
  ),
  AppTableColumn(
    id: 'customer',
    label: 'Cliente',
    flex: 2,
    minWidth: 200,
    cellBuilder: (context, alert) =>
        AppTableCell(value: alert.customerName, meta: alert.code),
  ),
  AppTableColumn(
    id: 'summary',
    label: 'Razón principal',
    flex: 3,
    minWidth: 240,
    cellBuilder: (context, alert) => AppTableCell(value: alert.summary),
  ),
  AppTableColumn(
    id: 'date',
    label: 'Fecha',
    width: _dateWidth,
    cellBuilder: (context, alert) => AppTableCell(
      value: formatShortDate(alert.generatedAt),
      meta: formatTime(alert.generatedAt),
    ),
  ),
  AppTableColumn(
    id: 'status',
    label: 'Estado',
    width: _statusWidth,
    cellBuilder: (context, alert) => Align(
      alignment: Alignment.centerLeft,
      child: StatusBadge(
        label: alert.status.label,
        tone: alert.status.tone,
        icon: alert.status.icon,
        small: true,
      ),
    ),
  ),
];

/// The suggested fraud type as a `TaxonomyChip` (code, name and the colour of the catalog).
///
/// While the catalog loads, or if it fails, the cell shows the type as text instead, so
/// the row never depends on the catalog to be readable.
class _SuggestedTypeCell extends ConsumerWidget {
  const _SuggestedTypeCell({required this.type});

  final FraudType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(fraudTypesProvider).value;
    final entry = catalog?.where((item) => item.code == type.code).firstOrNull;
    if (entry == null) {
      return AppTableCell(value: type.label, meta: type.code);
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: TaxonomyChip.fromCatalog(entry),
    );
  }
}

/// E-02: what the empty table says depends on why it is empty.
class _EmptyAlerts extends ConsumerWidget {
  const _EmptyAlerts({required this.query});

  final AlertsQuery query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.hasFilters) {
      return EmptyState.noResults(
        onClearFilters: ref.read(alertsQueryProvider.notifier).reset,
      );
    }
    return const EmptyState(
      title: 'No hay alertas pendientes',
      message:
          'Cuando la IA detecte una transacción sospechosa, la alerta '
          'aparecerá aquí.',
    );
  }
}

/// The pagination bar while the page loads or fails: same height, so nothing jumps.
class _PaginationPlaceholder extends StatelessWidget {
  const _PaginationPlaceholder();

  @override
  Widget build(BuildContext context) => Container(
    height: AppSizes.paginationBar,
    padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
    alignment: Alignment.centerLeft,
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: AppColors.borderSubtle)),
    ),
    child: Text(
      '—',
      style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
    ),
  );
}
