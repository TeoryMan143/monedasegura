import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/statistics/domain/time_series_point.dart';

void main() {
  test('reads a week from a row of the database', () {
    final point = TimeSeriesPoint.fromJson({
      'period_start': '2026-03-03',
      'fraud_count': 41,
    });

    expect(point.periodStart, DateTime(2026, 3, 3));
    expect(point.fraudCount, 41);
  });

  test('two points with the same values are equal', () {
    final a = TimeSeriesPoint(periodStart: DateTime(2026, 3, 3), fraudCount: 5);
    final b = TimeSeriesPoint(periodStart: DateTime(2026, 3, 3), fraudCount: 5);

    expect(a, b);
  });
}
