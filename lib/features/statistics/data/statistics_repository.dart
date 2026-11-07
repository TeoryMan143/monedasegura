import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/failure.dart';
import '../../../core/errors/failure_mapper.dart';
import '../domain/ai_aggregation.dart';
import '../domain/ai_performance.dart';
import '../domain/confusion_matrix.dart';
import '../domain/fraud_kpis.dart';
import '../domain/grouped_count.dart';
import '../domain/statistics_filter.dart';
import '../domain/stats_group_by.dart';
import '../domain/time_series_point.dart';

/// Statistics of HU-13, read already aggregated from the views of the database.
///
/// Nothing is counted here: the views return a few dozen rows, and the app only adds up
/// the groups it needs. Prototype limits, until Juan Camilo publishes the migration:
///
/// - No view has a date or a country, so the `filter` is accepted but not applied yet.
/// - [fraudOverTime] and [fraudGrouped] by channel or country have no view to read.
///
/// What an analyst labels in the session (`LocalWritesStore`) is not counted either.
class StatisticsRepository {
  StatisticsRepository(this._client);

  final SupabaseClient _client;

  /// The three cards: labeling progress, frauds and the committed amount in COP.
  ///
  /// `v_fraud_stats` groups by type and currency, so the amount is converted with the
  /// small `exchange_rates` table. A fraud with two types counts once per type there.
  Future<FraudKpis> fraudKpis(StatisticsFilter filter) async {
    try {
      final (progress, stats, rates) = await (
        _client
            .from('v_labeling_progress')
            .select('labeled, total_transactions, fraud')
            .single(),
        _client.from('v_fraud_stats').select('currency_code, total_amount'),
        _client.from('exchange_rates').select('currency_code, rate_to_cop'),
      ).wait;

      final rateToCop = {
        for (final rate in rates)
          rate['currency_code'] as String: (rate['rate_to_cop'] as num)
              .toDouble(),
      };
      var committed = 0.0;
      for (final row in stats) {
        final currency = row['currency_code'] as String;
        committed +=
            (row['total_amount'] as num).toDouble() *
            (rateToCop[currency] ?? 0);
      }

      return FraudKpis(
        labeledCount: (progress['labeled'] as num).toInt(),
        totalCount: (progress['total_transactions'] as num).toInt(),
        fraudCount: (progress['fraud'] as num).toInt(),
        committedAmountCop: committed,
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Frauds per week. Needs a view with a date column.
  Future<List<TimeSeriesPoint>> fraudOverTime(StatisticsFilter filter) async {
    throw const Failure.unknown(
      message:
          'fraudOverTime needs a view with period_start (pending migration)',
    );
  }

  /// Frauds per type, channel or country, as unordered groups.
  Future<List<GroupedCount>> fraudGrouped(
    StatisticsFilter filter,
    StatsGroupBy by,
  ) async {
    if (by != StatsGroupBy.type) {
      throw Failure.unknown(
        message:
            'fraudGrouped by ${by.name} needs a new view (pending migration)',
      );
    }
    try {
      final rows = await _client
          .from('v_fraud_stats')
          .select('fraud_type_code, labeled_transactions');
      // One row per type and currency: add the currencies of each type.
      final countByType = <String, int>{};
      for (final row in rows) {
        final code = row['fraud_type_code'] as String;
        countByType[code] =
            (countByType[code] ?? 0) +
            (row['labeled_transactions'] as num).toInt();
      }
      return [
        for (final entry in countByType.entries)
          GroupedCount(key: entry.key, count: entry.value),
      ];
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  /// Confirmed, rejected and reclassified alerts, and the precision of each type.
  Future<AiPerformance> aiPerformance(StatisticsFilter filter) async =>
      aiPerformanceFrom(await _aiOutcomes());

  /// Suggested type against final type, for N-04.
  Future<ConfusionMatrix> confusionMatrix(StatisticsFilter filter) async =>
      confusionMatrixFrom(await _aiOutcomes());

  Future<List<AiOutcomeRow>> _aiOutcomes() async {
    try {
      final rows = await _client
          .from('v_ai_performance')
          .select('suggested_type_code, status, final_type_code, alerts');
      return [
        for (final row in rows)
          (
            suggested: row['suggested_type_code'] as String,
            status: row['status'] as String,
            finalType: row['final_type_code'] as String?,
            alerts: (row['alerts'] as num).toInt(),
          ),
      ];
    } catch (error) {
      throw mapToFailure(error);
    }
  }
}
