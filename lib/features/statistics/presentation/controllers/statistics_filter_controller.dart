import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/statistics_filter.dart';

/// Date range and country of the page, shared by the two tabs (A-07, A-08).
///
/// Kept alive: the analyst keeps the filters when switching tabs or screens.
final statisticsFilterProvider =
    NotifierProvider<StatisticsFilterNotifier, StatisticsFilter>(
      StatisticsFilterNotifier.new,
      name: 'statisticsFilterProvider',
    );

class StatisticsFilterNotifier extends Notifier<StatisticsFilter> {
  @override
  StatisticsFilter build() => const StatisticsFilter();

  /// Stores the range as plain days (no time) so the filter, which is the
  /// `family` key of the stats providers, only changes when the day changes.
  /// A reversed range is swapped.
  void setRange(DateTime? from, DateTime? to) {
    var start = _dayOnly(from);
    var end = _dayOnly(to);
    if (start != null && end != null && start.isAfter(end)) {
      (start, end) = (end, start);
    }
    state = state.copyWith(fromDate: start, toDate: end);
  }

  void setCountry(String? countryCode) =>
      state = state.copyWith(countryCode: countryCode);

  void reset() => state = const StatisticsFilter();

  static DateTime? _dayOnly(DateTime? date) =>
      date == null ? null : DateTime(date.year, date.month, date.day);
}
