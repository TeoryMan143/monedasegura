import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/alerts/domain/alert_detail.dart';

void main() {
  test('reads reasons sorted and the primary transaction first', () {
    final detail = AlertDetail.fromRow({
      'id': 'a1',
      'code': 'AL-1042',
      'customer_id': 'c1',
      'score': 92,
      'summary': 'Resumen',
      'status': 'pending',
      'generated_at': '2026-11-05T14:30:00+00:00',
      'customers': {'first_names': 'Juan', 'last_names': 'Pérez'},
      'suggested_type': {'code': 'ATO'},
      'model_version': 'v2.1',
      'account_id': null,
      'ai_alert_reasons': [
        {
          'id': 'r2',
          'position': 2,
          'weight': 0.3,
          'title': 'B',
          'evidence': 'e2',
        },
        {
          'id': 'r1',
          'position': 1,
          'weight': 0.6,
          'title': 'A',
          'evidence': 'e1',
        },
      ],
      'ai_alert_transactions': [
        {
          'is_primary': false,
          'transactions': {
            'id': 11,
            'code': 'TX-11',
            'amount': 100,
            'currency_code': 'COP',
          },
        },
        {
          'is_primary': true,
          'transactions': {
            'id': 12,
            'code': 'TX-12',
            'amount': 125500.5,
            'currency_code': 'MXN',
          },
        },
      ],
    });

    expect(detail.alert.code, 'AL-1042');
    expect(detail.modelVersion, 'v2.1');
    expect(detail.accountId, isNull);
    expect([for (final r in detail.reasons) r.title], ['A', 'B']);
    expect(detail.transactions.first.transactionId, 12);
    expect(detail.transactions.first.amount, 125500.5);
    expect(detail.transactions.last.isPrimary, isFalse);
  });
}
