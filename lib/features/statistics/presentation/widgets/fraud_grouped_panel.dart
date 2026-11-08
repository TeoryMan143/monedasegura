import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatting/numbers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/chart_transforms.dart';
import '../../domain/grouped_count.dart';
import '../../domain/stats_group_by.dart';
import '../controllers/statistics_providers.dart';
import '../controllers/stats_group_by_controller.dart';
import '../stats_labels.dart';
import 'horizontal_bars.dart';
import 'stats_async.dart';

/// A-07 · «Fraudes agrupados»: horizontal bars with «Agrupar por» Tipo · Canal · País
/// (HU-13). Changing the grouping asks again only for these bars, not for the cards.
class FraudGroupedPanel extends ConsumerWidget {
  const FraudGroupedPanel({super.key});

  static const _segments = [
    AppSegment(value: StatsGroupBy.type, label: 'Tipo'),
    AppSegment(value: StatsGroupBy.channel, label: 'Canal'),
    AppSegment(value: StatsGroupBy.country, label: 'País'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(statisticsFilterProvider);
    final by = ref.watch(statsGroupByProvider);
    final args = (filter: filter, by: by);
    final totalFrauds = ref.watch(fraudKpisProvider(filter)).value?.fraudCount;

    return AppPanel(
      title: 'Fraudes agrupados',
      subtitle: 'Fraudes por ${groupByNoun(by)}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSegmented<StatsGroupBy>(
            segments: _segments,
            value: by,
            small: true,
            onChanged: ref.read(statsGroupByProvider.notifier).select,
          ),
          const SizedBox(height: AppSpace.lg),
          StatsAsync<List<GroupedCount>>(
            value: ref.watch(fraudGroupedProvider(args)),
            onRetry: () => ref.invalidate(fraudGroupedProvider(args)),
            isEmpty: (groups) => groups.isEmpty,
            loading: const HorizontalBarsSkeleton(),
            builder: (context, groups) {
              final sorted = sortedDescending(groups);
              final sum = sorted.fold(0, (sum, group) => sum + group.count);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HorizontalBars(
                    items: [
                      for (final group in sorted)
                        BarItem(
                          label: groupLabel(by, group.key),
                          value: group.count,
                          valueText: formatCount(group.count),
                        ),
                    ],
                  ),
                  if (by == StatsGroupBy.type &&
                      totalFrauds != null &&
                      sum > totalFrauds) ...[
                    const SizedBox(height: AppSpace.md),
                    Text(
                      'Una transacción con varios tipos cuenta en cada uno, '
                      'por eso la suma supera el total de fraudes.',
                      style: AppText.bodyS.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
