import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/alerts/domain/alert_reason.dart';

void main() {
  Map<String, dynamic> row() => {
    'id': 'r1',
    'alert_id': 'a1',
    'position': 1,
    'weight': 0.45,
    'title': 'Monto 8,2× el promedio de 90 días',
    'evidence': r'$ 125.500 MXN vs. promedio $ 15.300',
    'metric': {'observed': 125500, 'baseline': 15300, 'unit': 'MXN'},
  };

  test('reads a reason with its nested metric', () {
    final reason = AlertReason.fromJson(row());

    expect(reason.alertId, 'a1');
    expect(reason.weight, 0.45);
    expect(reason.metric?.observed, 125500);
    expect(reason.metric?.unit, 'MXN');
  });

  test('metric is null when the column is null', () {
    final reason = AlertReason.fromJson({...row(), 'metric': null});

    expect(reason.metric, isNull);
  });
}
