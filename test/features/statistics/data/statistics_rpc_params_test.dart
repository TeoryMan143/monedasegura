import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/statistics/data/statistics_repository.dart';
import 'package:monedasegura/features/statistics/domain/statistics_filter.dart';

void main() {
  test('a filter without values sends no parameters', () {
    expect(statisticsRpcParams(const StatisticsFilter()), isEmpty);
  });

  test('sends the dates as plain days and the country as is', () {
    final params = statisticsRpcParams(
      StatisticsFilter(
        fromDate: DateTime(2026, 4, 9),
        toDate: DateTime(2026, 11, 7, 18, 30),
        countryCode: 'CO',
      ),
    );

    expect(params, {
      'p_from': '2026-04-09',
      'p_to': '2026-11-07',
      'p_country': 'CO',
    });
  });

  test('leaves out only what is not set', () {
    final params = statisticsRpcParams(
      StatisticsFilter(fromDate: DateTime(2026, 1, 5)),
    );

    expect(params, {'p_from': '2026-01-05'});
  });
}
