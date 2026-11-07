import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/page_result.dart';
import '../../../../core/formatting/date_time.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/ai_alert.dart';
import '../controllers/alerts_providers.dart';
import '../controllers/alerts_query_controller.dart';

const _scoreWidth = 96.0;
const _dateWidth = 112.0;
const _statusWidth = 144.0;

/// The table of A-04 (HU-06), first version: pending alerts, highest score first.
///
/// It only watches the providers and draws what they return. The order, the filters and
/// the page come from the database through `alertsPageProvider`. The screen states
/// (loading, empty, error) go through [ScreenState] and [AppDataTable].
///
/// There are no filters, pagination or row navigation yet (Sprint 2).
class AlertsInboxTable extends ConsumerWidget {
  const AlertsInboxTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(alertsQueryProvider);
    final page = ref.watch(alertsPageProvider(query));

    Widget table({List<AiAlert> rows = const [], bool loading = false}) {
      return AppDataTable<AiAlert>(
        columns: _columns,
        rows: rows,
        rowKey: (alert) => alert.id,
        loading: loading,
        empty: const EmptyState(
          title: 'No hay alertas pendientes',
          message:
              'Cuando la IA detecte una transacción sospechosa, la alerta '
              'aparecerá aquí.',
        ),
        rowSemanticLabel: (alert) => '${alert.code} de ${alert.customerName}',
      );
    }

    return ScreenState<PageResult<AiAlert>>(
      value: page,
      onRetry: () => ref.invalidate(alertsPageProvider(query)),
      loading: table(loading: true),
      builder: (context, result) => table(rows: result.items),
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
    cellBuilder: (context, alert) => AppTableCell(
      value: alert.suggestedType.label,
      meta: alert.suggestedType.code,
    ),
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
