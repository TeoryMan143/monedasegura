import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_client_provider.dart';
import '../../data/statistics_repository.dart';
import '../../domain/ai_performance.dart';
import '../../domain/confusion_matrix.dart';
import '../../domain/fraud_kpis.dart';
import '../../domain/grouped_count.dart';
import '../../domain/statistics_filter.dart';
import '../../domain/stats_group_by.dart';
import '../../domain/time_series_point.dart';

export 'statistics_filter_controller.dart';

/// A failed statistic shows «Reintentar» at once instead of retrying in silence.
Duration? _noAutoRetry(int retryCount, Object error) => null;

final statisticsRepositoryProvider = Provider<StatisticsRepository>(
  (ref) => StatisticsRepository(ref.watch(supabaseClientProvider)),
  name: 'statisticsRepositoryProvider',
);

// The statistics below are families by filter: [StatisticsFilter] is a value class, so
// two equal filters share one request, and changing the filter asks for new data.

/// The three cards of the «Fraude» tab.
final fraudKpisProvider = FutureProvider.autoDispose
    .family<FraudKpis, StatisticsFilter>(
      (ref, filter) =>
          ref.watch(statisticsRepositoryProvider).fraudKpis(filter),
      retry: _noAutoRetry,
      name: 'fraudKpisProvider',
    );

/// «Fraudes en el tiempo».
final fraudOverTimeProvider = FutureProvider.autoDispose
    .family<List<TimeSeriesPoint>, StatisticsFilter>(
      (ref, filter) =>
          ref.watch(statisticsRepositoryProvider).fraudOverTime(filter),
      retry: _noAutoRetry,
      name: 'fraudOverTimeProvider',
    );

/// What [fraudGroupedProvider] is asked for.
typedef FraudGroupedArgs = ({StatisticsFilter filter, StatsGroupBy by});

/// The bars of «Agrupar por».
final fraudGroupedProvider = FutureProvider.autoDispose
    .family<List<GroupedCount>, FraudGroupedArgs>(
      (ref, args) => ref
          .watch(statisticsRepositoryProvider)
          .fraudGrouped(args.filter, args.by),
      retry: _noAutoRetry,
      name: 'fraudGroupedProvider',
    );

/// The «Desempeño de la IA» tab.
final aiStatsProvider = FutureProvider.autoDispose
    .family<AiPerformance, StatisticsFilter>(
      (ref, filter) =>
          ref.watch(statisticsRepositoryProvider).aiPerformance(filter),
      retry: _noAutoRetry,
      name: 'aiStatsProvider',
    );

/// The confusion matrix dialog (N-04).
final confusionMatrixProvider = FutureProvider.autoDispose
    .family<ConfusionMatrix, StatisticsFilter>(
      (ref, filter) =>
          ref.watch(statisticsRepositoryProvider).confusionMatrix(filter),
      retry: _noAutoRetry,
      name: 'confusionMatrixProvider',
    );
