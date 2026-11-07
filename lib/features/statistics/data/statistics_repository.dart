import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/failure_mapper.dart';
import '../domain/ai_aggregation.dart';
import '../domain/ai_performance.dart';
import '../domain/confusion_matrix.dart';
import '../domain/fraud_kpis.dart';
import '../domain/grouped_count.dart';
import '../domain/statistics_filter.dart';
import '../domain/stats_group_by.dart';
import '../domain/time_series_point.dart';

class StatisticsRepository {
  StatisticsRepository(this._client);

  final SupabaseClient _client;

  Future<FraudKpis> fraudKpis(StatisticsFilter filter) async {
    try {
      final row = await _client
          .rpc('fraud_stats_kpis', params: statisticsRpcParams(filter))
          .single();
      return FraudKpis(
        labeledCount: (row['labeled'] as num).toInt(),
        totalCount: (row['total_transactions'] as num).toInt(),
        fraudCount: (row['fraud'] as num).toInt(),
        committedAmountCop: (row['committed_amount_cop'] as num).toDouble(),
      );
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  Future<List<TimeSeriesPoint>> fraudOverTime(StatisticsFilter filter) async {
    try {
      final rows = await _client.rpc(
        'fraud_over_time',
        params: statisticsRpcParams(filter),
      );
      return [for (final row in _rowsOf(rows)) TimeSeriesPoint.fromJson(row)];
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  Future<List<GroupedCount>> fraudGrouped(
    StatisticsFilter filter,
    StatsGroupBy by,
  ) async {
    try {
      final rows = await _client.rpc(
        'fraud_grouped',
        params: {'p_by': by.name, ...statisticsRpcParams(filter)},
      );
      return [for (final row in _rowsOf(rows)) GroupedCount.fromJson(row)];
    } catch (error) {
      throw mapToFailure(error);
    }
  }

  Future<AiPerformance> aiPerformance(StatisticsFilter filter) async =>
      aiPerformanceFrom(await _aiOutcomes(filter));

  Future<ConfusionMatrix> confusionMatrix(StatisticsFilter filter) async =>
      confusionMatrixFrom(await _aiOutcomes(filter));

  Future<List<AiOutcomeRow>> _aiOutcomes(StatisticsFilter filter) async {
    try {
      final rows = await _client.rpc(
        'ai_performance',
        params: statisticsRpcParams(filter),
      );
      return [
        for (final row in _rowsOf(rows))
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

@visibleForTesting
Map<String, dynamic> statisticsRpcParams(StatisticsFilter filter) => {
  if (filter.fromDate != null) 'p_from': _date(filter.fromDate!),
  if (filter.toDate != null) 'p_to': _date(filter.toDate!),
  if (filter.countryCode != null) 'p_country': filter.countryCode,
};

String _date(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// The rows an RPC returns, typed: `rpc` gives back `dynamic`.
List<Map<String, dynamic>> _rowsOf(Object? data) =>
    (data! as List<dynamic>).cast<Map<String, dynamic>>();
