import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics_filter.freezed.dart';

@freezed
abstract class StatisticsFilter with _$StatisticsFilter {
  const factory StatisticsFilter({
    DateTime? fromDate,
    DateTime? toDate,
    String? countryCode,
  }) = _StatisticsFilter;

  const StatisticsFilter._();

  bool get hasFilters =>
      fromDate != null || toDate != null || countryCode != null;
}
