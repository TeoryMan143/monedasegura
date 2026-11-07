import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/alerts/domain/alert_transaction.dart';

void main() {
  test('flattens the embedded transaction', () {
    final transaction = AlertTransaction.fromJson({
      'is_primary': true,
      'transactions': {
        'id': 12,
        'code': 'TX-12',
        'amount': 125500.5,
        'currency_code': 'MXN',
      },
    });

    expect(transaction.transactionId, 12);
    expect(transaction.code, 'TX-12');
    expect(transaction.isPrimary, isTrue);
    expect(transaction.amount, 125500.5);
    expect(transaction.currencyCode, 'MXN');
  });

  test('reads an integer amount as a double', () {
    final transaction = AlertTransaction.fromJson({
      'is_primary': false,
      'transactions': {
        'id': 11,
        'code': 'TX-11',
        'amount': 100,
        'currency_code': 'COP',
      },
    });

    expect(transaction.amount, 100.0);
  });
}
