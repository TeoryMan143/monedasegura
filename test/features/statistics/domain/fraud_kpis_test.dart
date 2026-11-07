import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/statistics/domain/fraud_kpis.dart';

void main() {
  test('labeledRatio is the share of labeled transactions', () {
    const kpis = FraudKpis(
      labeledCount: 250,
      totalCount: 1000,
      fraudCount: 40,
      committedAmountCop: 12500000,
    );

    expect(kpis.labeledRatio, 0.25);
  });

  test('labeledRatio is 0 when there are no transactions', () {
    const kpis = FraudKpis(
      labeledCount: 0,
      totalCount: 0,
      fraudCount: 0,
      committedAmountCop: 0,
    );

    expect(kpis.labeledRatio, 0);
  });
}
