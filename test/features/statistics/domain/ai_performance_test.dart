import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/statistics/domain/ai_performance.dart';
import 'package:monedasegura/features/statistics/domain/type_precision.dart';

void main() {
  test('resolvedCount adds the three results', () {
    const performance = AiPerformance(
      confirmed: 60,
      rejected: 25,
      reclassified: 15,
    );

    expect(performance.resolvedCount, 100);
    expect(performance.precisionByType, isEmpty);
  });

  test('keeps the precision of each type', () {
    const performance = AiPerformance(
      confirmed: 8,
      rejected: 1,
      reclassified: 1,
      precisionByType: [
        TypePrecision(typeCode: 'ATO', precision: 0.8, alerts: 10),
      ],
    );

    expect(performance.precisionByType.single.typeCode, 'ATO');
    expect(performance.precisionByType.single.precision, 0.8);
  });
}
