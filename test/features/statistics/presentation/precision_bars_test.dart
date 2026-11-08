import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/features/statistics/domain/type_precision.dart';
import 'package:monedasegura/features/statistics/presentation/precision_bars.dart';

void main() {
  test('sorts by precision, highest first, and breaks ties by sample size', () {
    final bars = precisionBars(const [
      TypePrecision(typeCode: 'PHI', precision: 0.5, alerts: 10),
      TypePrecision(typeCode: 'ATO', precision: 0.7, alerts: 120),
      TypePrecision(typeCode: 'CLO', precision: 0.5, alerts: 30),
    ]);

    expect(bars.take(3).map((b) => b.label), [
      FraudType.accountTakeover.label,
      FraudType.clonedCard.label,
      FraudType.phishing.label,
    ]);
    expect(bars.first.valueText, '70 %');
    expect(bars.first.detail, 'n = 120 alertas resueltas');
  });

  test('a type without resolved alerts goes last as «Sin datos», not 0 %', () {
    final bars = precisionBars(const [
      TypePrecision(typeCode: 'ATO', precision: 0.7, alerts: 1),
    ]);

    expect(bars, hasLength(FraudType.values.length));
    expect(bars.first.detail, 'n = 1 alerta resuelta');
    final withoutData = bars.skip(1);
    expect(withoutData.map((b) => b.valueText), everyElement('Sin datos'));
    expect(withoutData.map((b) => b.value), everyElement(isNull));
  });

  test('with no precisions every type is «Sin datos»', () {
    expect(
      precisionBars(const []).map((b) => b.valueText),
      everyElement('Sin datos'),
    );
  });
}
