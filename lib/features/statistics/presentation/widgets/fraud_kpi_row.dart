import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/currency.dart';
import '../../../../core/formatting/money.dart';
import '../../../../core/formatting/numbers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../controllers/statistics_providers.dart';
import 'kpi_row.dart';

/// A-07 · The three cards of the «Fraude» tab: labeling progress, frauds and committed
/// amount (HU-13).
class FraudKpiRow extends ConsumerWidget {
  const FraudKpiRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(statisticsFilterProvider);
    return KpiRow(
      value: ref.watch(fraudKpisProvider(filter)),
      onRetry: () => ref.invalidate(fraudKpisProvider(filter)),
      isEmpty: (kpis) => kpis.totalCount == 0,
      cards: (kpis) => [
        KpiCard(
          title: 'Avance del etiquetado',
          value: formatPercent(kpis.labeledRatio * 100),
          icon: AppIcons.check,
          detail:
              '${formatCount(kpis.labeledCount)} de ${formatCount(kpis.totalCount)} '
              'transacciones etiquetadas',
        ),
        KpiCard(
          title: 'Fraudes etiquetados',
          value: formatCount(kpis.fraudCount),
          icon: AppIcons.shield,
          detail: 'Con veredicto Fraude en el rango',
        ),
        KpiCard(
          title: 'Monto comprometido',
          value: formatMoney(kpis.committedAmountCop, Currency.cop),
          icon: AppIcons.currency,
          detail: 'Convertido a COP con la tasa fija del catálogo',
        ),
      ],
    );
  }
}
