import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/features/customer/domain/range_totals.dart';

void main() {
  group('compactMoney', () {
    test('a million or more is written in millions with one decimal', () {
      expect(compactMoney(12400000, Currency.cop), r'$ 12,4 M');
      expect(compactMoney(1000000, Currency.cop), r'$ 1,0 M');
      expect(compactMoney(2600000, Currency.mxn), r'$ 2.6 M');
    });

    test('smaller amounts keep the decimals of their currency', () {
      expect(compactMoney(6381.48, Currency.pen), 'S/ 6.381,48');
      expect(compactMoney(250000, Currency.clp), r'$ 250.000');
    });

    test('a signed amount shows its sign', () {
      expect(compactMoney(2600000, Currency.cop, signed: true), r'+$ 2,6 M');
      expect(compactMoney(-2600000, Currency.cop, signed: true), r'-$ 2,6 M');
      expect(compactMoney(-1500, Currency.clp, signed: true), r'-$ 1.500');
      expect(compactMoney(0, Currency.clp, signed: true), r'$ 0');
    });
  });

  group('rangeTotalsText', () {
    test('writes money in, money out and the net with its currency', () {
      const totals = RangeTotals(
        currency: Currency.cop,
        totalIn: 12400000,
        totalOut: 9800000,
        net: 2600000,
        transactionCount: 60,
      );

      expect(
        rangeTotalsText(totals),
        r'Entradas $ 12,4 M · Salidas $ 9,8 M · Neto +$ 2,6 M COP',
      );
    });

    test('CLP has no decimals and a negative net keeps its minus', () {
      const totals = RangeTotals(
        currency: Currency.clp,
        totalIn: 85990,
        totalOut: 249900,
        net: -163910,
        transactionCount: 2,
      );

      expect(
        rangeTotalsText(totals),
        r'Entradas $ 85.990 · Salidas $ 249.900 · Neto -$ 163.910 CLP',
      );
    });
  });

  test('reads a row of the customer_range_totals RPC', () {
    final totals = RangeTotals.fromJson(const {
      'currency_code': 'PEN',
      'total_in': 17415.81,
      'total_out': 8898.23,
      'net': 8517.58,
      'transaction_count': 50,
    });

    expect(totals.currency, Currency.pen);
    expect(totals.totalIn, 17415.81);
    expect(totals.net, 8517.58);
    expect(totals.transactionCount, 50);
  });
}
