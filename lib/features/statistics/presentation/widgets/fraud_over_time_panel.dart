import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/chart_transforms.dart';
import '../../domain/time_series_point.dart';
import '../controllers/statistics_providers.dart';
import 'fraud_line_chart.dart';
import 'stats_async.dart';

/// A-07 · «Fraudes en el tiempo»: the weekly line chart (HU-13).
class FraudOverTimePanel extends ConsumerWidget {
  const FraudOverTimePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(statisticsFilterProvider);
    return AppPanel(
      title: 'Fraudes en el tiempo',
      subtitle: 'Transacciones con veredicto Fraude por semana',
      child: StatsAsync<List<TimeSeriesPoint>>(
        value: ref.watch(fraudOverTimeProvider(filter)),
        onRetry: () => ref.invalidate(fraudOverTimeProvider(filter)),
        stateHeight: AppSizes.chartHeight,
        isEmpty: (points) => points.every((point) => point.fraudCount == 0),
        loading: const SkeletonBox(height: AppSizes.chartHeight),
        builder: (context, points) {
          final from = filter.fromDate ?? points.first.periodStart;
          final to = filter.toDate ?? points.last.periodStart;
          return FraudLineChart(weeks: fillWeeklyGaps(points, from, to));
        },
      ),
    );
  }
}
