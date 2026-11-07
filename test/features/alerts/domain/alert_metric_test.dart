import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/alerts/domain/alert_metric.dart';

void main() {
  test('reads the jsonb of a reason, with integers or decimals', () {
    final metric = AlertMetric.fromJson({
      'observed': 125500,
      'baseline': 15300.5,
      'unit': 'MXN',
    });

    expect(metric.observed, 125500);
    expect(metric.baseline, 15300.5);
    expect(metric.unit, 'MXN');
    expect(metric.ratio, closeTo(8.2, 0.01));
  });

  test('unit is optional and a zero baseline has no ratio', () {
    final metric = AlertMetric.fromJson({'observed': 3, 'baseline': 0});

    expect(metric.unit, isNull);
    expect(metric.ratio, isNull);
  });
}
