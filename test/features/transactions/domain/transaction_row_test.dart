import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/label_status.dart';
import 'package:monedasegura/core/domain/transaction_type.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/features/transactions/domain/transaction_row.dart';

void main() {
  Map<String, dynamic> json({Map<String, dynamic> overrides = const {}}) => {
    'id': 48219,
    'code': 'TX-48219',
    'occurred_at': '2026-03-19T22:41:00Z',
    'customer_id': '00000000-0000-4000-8000-000000000001',
    'customer_name': 'Ana María Rojas',
    'account_last4': '4417',
    'source_account_id': '00000000-0000-4000-9000-000000000001',
    'destination_account_id': '00000000-0000-4000-9000-000000000101',
    'type': 'transfer',
    'channel_code': 'PSE',
    'amount': 1900000.5,
    'currency_code': 'COP',
    'alert_score': 92,
    'is_labeled': true,
    'verdict': 'fraud',
    ...overrides,
  };

  test('reads a row of the view', () {
    final row = TransactionRow.fromJson(json());

    expect(row.id, 48219);
    expect(row.code, 'TX-48219');
    expect(row.occurredAt, DateTime.utc(2026, 3, 19, 22, 41));
    expect(row.customerId, '00000000-0000-4000-8000-000000000001');
    expect(row.customerName, 'Ana María Rojas');
    expect(row.accountLast4, '4417');
    expect(row.sourceAccountId, '00000000-0000-4000-9000-000000000001');
    expect(row.destinationAccountId, '00000000-0000-4000-9000-000000000101');
    expect(row.type, TransactionType.transfer);
    expect(row.channel, Channel.pse);
    expect(row.amount, 1900000.5);
    expect(row.currency, Currency.cop);
    expect(row.alertScore, 92);
    expect(row.hasAiAlert, isTrue);
    expect(row.labelStatus, LabelStatus.labeled);
    expect(row.verdict, Verdict.fraud);
  });

  test('the country does not come from the view', () {
    expect(TransactionRow.fromJson(json()).country, isNull);
  });

  test('a row without customer, accounts, alert or label reads as nulls', () {
    final row = TransactionRow.fromJson(
      json(
        overrides: {
          'customer_id': null,
          'customer_name': null,
          'account_last4': null,
          'source_account_id': null,
          'destination_account_id': null,
          'alert_score': null,
          'is_labeled': false,
          'verdict': null,
        },
      ),
    );

    expect(row.customerId, isNull);
    expect(row.customerName, isNull);
    expect(row.accountLast4, isNull);
    expect(row.sourceAccountId, isNull);
    expect(row.destinationAccountId, isNull);
    expect(row.hasAiAlert, isFalse);
    expect(row.labelStatus, LabelStatus.unlabeled);
    expect(row.verdict, isNull);
  });

  test('an unknown value of the database is not hidden', () {
    expect(
      () => TransactionRow.fromJson(json(overrides: {'type': 'barter'})),
      throwsArgumentError,
    );
  });
}
