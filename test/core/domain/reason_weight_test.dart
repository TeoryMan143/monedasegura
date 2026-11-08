import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/reason_weight.dart';

void main() {
  test('groups a weight as alto, medio or bajo', () {
    expect(ReasonWeight.of(0.45), ReasonWeight.high);
    expect(ReasonWeight.of(0.30), ReasonWeight.high);
    expect(ReasonWeight.of(0.29), ReasonWeight.medium);
    expect(ReasonWeight.of(0.15), ReasonWeight.medium);
    expect(ReasonWeight.of(0.14), ReasonWeight.low);
    expect(ReasonWeight.of(0), ReasonWeight.low);
  });

  test('every group has its Spanish label', () {
    expect(ReasonWeight.high.label, 'Peso alto');
    expect(ReasonWeight.medium.label, 'Peso medio');
    expect(ReasonWeight.low.label, 'Peso bajo');
  });
}
