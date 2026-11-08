import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/label_status.dart';
import 'package:monedasegura/core/domain/transaction_type.dart';
import 'package:monedasegura/features/customer/domain/customer_transaction.dart';
import 'package:monedasegura/features/customer/domain/date_range.dart';

void main() {
  const mine = {'a1', 'a2'};

  CustomerTransaction transaction({String? source, String? destination}) =>
      CustomerTransaction(
        id: 1,
        code: 'TX-1',
        occurredAt: DateTime(2026, 3, 3),
        type: TransactionType.transfer,
        channel: Channel.app,
        amount: 100,
        currency: Currency.cop,
        sourceAccountId: source,
        destinationAccountId: destination,
        isLabeled: false,
      );

  group('seen from the customer', () {
    test('money sent to someone else goes out', () {
      final row = transaction(source: 'a1', destination: 'other');

      expect(row.accountOf(mine), 'a1');
      expect(row.isIncomingFor(mine), isFalse);
    });

    test('money received from outside comes in', () {
      final row = transaction(source: 'other', destination: 'a2');

      expect(row.accountOf(mine), 'a2');
      expect(row.isIncomingFor(mine), isTrue);
    });

    test('a credit without a source comes in', () {
      expect(transaction(destination: 'a1').isIncomingFor(mine), isTrue);
    });

    test('a transfer between two own accounts does not come in', () {
      final row = transaction(source: 'a1', destination: 'a2');

      expect(row.accountOf(mine), 'a1');
      expect(row.isIncomingFor(mine), isFalse);
    });

    test('a transaction of other accounts has none of the customer', () {
      expect(
        transaction(source: 'x', destination: 'y').accountOf(mine),
        isNull,
      );
    });
  });

  test('reads a row of the view', () {
    final row = CustomerTransaction.fromJson(const {
      'id': 48219,
      'code': 'TX-48219',
      'occurred_at': '2026-03-03T22:41:00Z',
      'type': 'purchase',
      'channel_code': 'POS',
      'amount': 96500,
      'currency_code': 'COP',
      'source_account_id': 'a1',
      'destination_account_id': null,
      'merchant_name': 'Éxito Laureles',
      'alert_score': null,
      'is_labeled': false,
      'verdict': null,
    });

    expect(row.merchantName, 'Éxito Laureles');
    expect(row.labelStatus, LabelStatus.unlabeled);
    expect(row.hasAiAlert, isFalse);
    expect(row.latitude, isNull);
  });

  test('reads the place of a row of the view', () {
    final row = CustomerTransaction.fromJson(const {
      'id': 47326,
      'code': 'TX-47326',
      'occurred_at': '2026-09-03T21:28:11Z',
      'type': 'purchase',
      'channel_code': 'POS',
      'amount': 2963.27,
      'currency_code': 'BRL',
      'source_account_id': 'a1',
      'is_labeled': false,
      'latitude': 10.409404,
      'longitude': -75,
      'city_name': 'Cartagena',
    });

    expect(row.latitude, 10.409404);
    expect(row.longitude, -75.0);
    expect(row.cityName, 'Cartagena');
  });

  group('DateRange', () {
    test('the last days end on the given day, both included', () {
      final range = DateRange.lastDays(30, until: DateTime(2026, 3, 31, 18));

      expect(range.from, DateTime(2026, 3, 2));
      expect(range.to, DateTime(2026, 3, 31));
      expect(range.days, 30);
    });

    test('contains whole days and gives its bounds for the query', () {
      final range = DateRange(
        from: DateTime(2026, 3),
        to: DateTime(2026, 3, 15),
      );

      expect(range.contains(DateTime(2026, 3, 15, 23, 59)), isTrue);
      expect(range.contains(DateTime(2026, 3, 16)), isFalse);
      expect(range.contains(DateTime(2026, 2, 28, 23, 59)), isFalse);
      expect(range.start, DateTime(2026, 3));
      expect(range.end, DateTime(2026, 3, 16));
    });

    test('moving the range keeps its length', () {
      final range = DateRange(
        from: DateTime(2026, 3),
        to: DateTime(2026, 3, 15),
      ).endingAt(DateTime(2026, 1, 20, 10));

      expect(range.to, DateTime(2026, 1, 20));
      expect(range.days, 15);
    });
  });
}
