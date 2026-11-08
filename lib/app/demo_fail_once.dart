import 'package:flutter_riverpod/misc.dart' show Override;

import '../core/config/env.dart';
import '../core/domain/catalog_models.dart';
import '../core/domain/page_result.dart';
import '../core/errors/failure.dart';
import '../core/local_writes/local_writes_provider.dart';
import '../core/supabase/supabase_client_provider.dart';
import '../features/alerts/data/alerts_repository.dart';
import '../features/alerts/domain/ai_alert.dart';
import '../features/alerts/domain/alert_detail.dart';
import '../features/alerts/domain/alerts_query.dart';
import '../features/alerts/domain/resolve_alert_input.dart';
import '../features/alerts/presentation/controllers/alerts_providers.dart';
import '../features/statistics/data/statistics_repository.dart';
import '../features/statistics/domain/ai_performance.dart';
import '../features/statistics/domain/confusion_matrix.dart';
import '../features/statistics/domain/fraud_kpis.dart';
import '../features/statistics/domain/grouped_count.dart';
import '../features/statistics/domain/statistics_filter.dart';
import '../features/statistics/domain/stats_group_by.dart';
import '../features/statistics/domain/time_series_point.dart';
import '../features/statistics/presentation/controllers/statistics_providers.dart';

/// Demo switch: with `--dart-define=DEMO_FAIL_ONCE=true`, the first read of each kind of
/// alert and statistic fails with a connection error and the next one works, so a demo can
/// show the error state and then «Reintentar» recovering, without touching the network.
///
/// It is applied only here, at the root of the app (`ProviderScope.overrides`), and
/// returns nothing unless the variable is set. Writes (resolving an alert) never fail.
List<Override> demoFailOnceOverrides() {
  if (!Env.demoFailOnce) return const [];
  return [
    alertsRepositoryProvider.overrideWith(
      (ref) => _FailOnceAlertsRepository(
        AlertsRepository(
          ref.watch(supabaseClientProvider),
          ref.watch(localWritesStoreProvider),
        ),
      ),
    ),
    statisticsRepositoryProvider.overrideWith(
      (ref) => _FailOnceStatisticsRepository(
        StatisticsRepository(ref.watch(supabaseClientProvider)),
      ),
    ),
  ];
}

/// Remembers which operations already failed once.
mixin _FailOnce {
  final _failed = <String>{};

  Future<T> failOnce<T>(String operation, Future<T> Function() run) {
    if (_failed.add(operation)) return Future.error(const Failure.network());
    return run();
  }
}

class _FailOnceAlertsRepository with _FailOnce implements AlertsRepository {
  _FailOnceAlertsRepository(this._real);

  final AlertsRepository _real;

  @override
  Future<PageResult<AiAlert>> list(AlertsQuery query) =>
      failOnce('list', () => _real.list(query));

  @override
  Future<AlertDetail> getById(String id) =>
      failOnce('getById', () => _real.getById(id));

  @override
  Future<void> resolve(
    ResolveAlertInput input, {
    required List<CatalogFraudType> fraudTypes,
    required String analystId,
    required String analystName,
  }) => _real.resolve(
    input,
    fraudTypes: fraudTypes,
    analystId: analystId,
    analystName: analystName,
  );
}

class _FailOnceStatisticsRepository
    with _FailOnce
    implements StatisticsRepository {
  _FailOnceStatisticsRepository(this._real);

  final StatisticsRepository _real;

  @override
  Future<FraudKpis> fraudKpis(StatisticsFilter filter) =>
      failOnce('fraudKpis', () => _real.fraudKpis(filter));

  @override
  Future<List<TimeSeriesPoint>> fraudOverTime(StatisticsFilter filter) =>
      failOnce('fraudOverTime', () => _real.fraudOverTime(filter));

  @override
  Future<List<GroupedCount>> fraudGrouped(
    StatisticsFilter filter,
    StatsGroupBy by,
  ) => failOnce('fraudGrouped', () => _real.fraudGrouped(filter, by));

  @override
  Future<AiPerformance> aiPerformance(StatisticsFilter filter) =>
      failOnce('aiPerformance', () => _real.aiPerformance(filter));

  @override
  Future<ConfusionMatrix> confusionMatrix(StatisticsFilter filter) =>
      failOnce('confusionMatrix', () => _real.confusionMatrix(filter));
}
