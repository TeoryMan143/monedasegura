import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/formatting/account_mask.dart';

void main() {
  test('keeps only the last four digits', () {
    expect(maskAccount('0012345678904417'), '•••• 4417');
  });

  test('accepts the last4 column', () {
    expect(maskAccount('4417'), '•••• 4417');
  });

  test('ignores spaces and dashes', () {
    expect(maskAccount('0012-3456 7890-4417'), '•••• 4417');
  });

  test('never fails on short numbers', () {
    expect(maskAccount('17'), '•••• 17');
  });
}
