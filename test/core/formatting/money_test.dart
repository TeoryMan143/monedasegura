import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/formatting/money.dart';

void main() {
  group('formatMoney', () {
    test('COP has 2 decimals and dot thousands', () {
      expect(formatMoney(1900000, Currency.cop), r'$ 1.900.000,00 COP');
    });

    test('CLP has no decimals', () {
      expect(formatMoney(1500, Currency.clp), r'$ 1.500 CLP');
      expect(formatMoney(1500.6, Currency.clp), r'$ 1.501 CLP');
    });

    test('BRL has a decimal comma', () {
      expect(formatMoney(12400.5, Currency.brl), r'R$ 12.400,50 BRL');
    });

    test('MXN uses the separators of its own locale', () {
      expect(formatMoney(125500.75, Currency.mxn), r'$ 125,500.75 MXN');
    });

    test('PEN keeps its symbol first', () {
      expect(formatMoney(1500, Currency.pen), 'S/ 1.500,00 PEN');
    });

    test('every currency formats zero and small amounts', () {
      for (final currency in Currency.values) {
        expect(formatMoney(0, currency), contains(currency.code));
        expect(formatMoney(0.5, currency), startsWith(currency.symbol));
      }
    });
  });

  group('formatSignedMoney', () {
    test('credits show a plus', () {
      expect(formatSignedMoney(1500, Currency.pen), '+S/ 1.500,00 PEN');
    });

    test('negative totals show a minus and zero shows no sign', () {
      expect(formatSignedMoney(-1500, Currency.clp), r'-$ 1.500 CLP');
      expect(formatSignedMoney(0, Currency.clp), r'$ 0 CLP');
    });
  });
}
