import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/alert_status.dart';
import '../../../../core/formatting/numbers.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/chart_transforms.dart';
import '../controllers/statistics_providers.dart';
import 'kpi_row.dart';

/// A-08 · The three cards of the «Desempeño de la IA» tab: confirmed, rejected and
/// reclassified alerts as a share of the resolved ones (HU-13).
///
/// The percentages come from `toPercentages`, so they add up to exactly 100 %. With no
/// resolved alerts they read «—», not 0 %.
class AiKpiRow extends ConsumerWidget {
  const AiKpiRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(statisticsFilterProvider);
    return KpiRow(
      value: ref.watch(aiStatsProvider(filter)),
      onRetry: () => ref.invalidate(aiStatsProvider(filter)),
      cards: (stats) {
        final counts = [stats.confirmed, stats.rejected, stats.reclassified];
        final percentages = toPercentages(counts);
        const statuses = [
          (AlertStatus.confirmed, 'tipo correcto'),
          (AlertStatus.rejected, 'falsos positivos'),
          (AlertStatus.reclassified, 'fraude con otro tipo'),
        ];
        return [
          for (final (index, (status, meaning)) in statuses.indexed)
            KpiCard(
              // «Confirmada» → «Confirmadas»: the label comes from the enum.
              title: '${status.label}s',
              value: stats.resolvedCount == 0
                  ? '—'
                  : formatPercent(percentages[index]),
              icon: status.icon,
              detail:
                  '${formatCount(counts[index])} '
                  '${counts[index] == 1 ? 'alerta' : 'alertas'} · $meaning',
            ),
        ];
      },
    );
  }
}
