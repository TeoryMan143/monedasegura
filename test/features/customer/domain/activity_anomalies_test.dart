import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/security_event_type.dart';
import 'package:monedasegura/core/domain/transaction_type.dart';
import 'package:monedasegura/features/customer/domain/activity_anomalies.dart';
import 'package:monedasegura/features/customer/domain/customer_activity.dart';
import 'package:monedasegura/features/customer/domain/customer_transaction.dart';
import 'package:monedasegura/features/customer/domain/security_event.dart';
import 'package:monedasegura/features/customer/domain/timeline_point.dart';

const _mine = {'a1'};

/// Money out of the customer's account, unless [incoming].
CustomerTransaction _tx(
  int id,
  DateTime at, {
  num amount = 100000,
  bool incoming = false,
  Currency currency = Currency.cop,
}) => CustomerTransaction(
  id: id,
  code: 'TX-$id',
  occurredAt: at,
  type: incoming ? TransactionType.credit : TransactionType.purchase,
  channel: Channel.pos,
  amount: amount,
  currency: currency,
  sourceAccountId: incoming ? null : 'a1',
  destinationAccountId: incoming ? 'a1' : null,
  isLabeled: false,
);

/// Local time (the analyst's), so the hours do not depend on the machine.
DateTime _at(int day, int hour, [int minute = 0]) =>
    DateTime(2026, 3, day, hour, minute);

void main() {
  group('detectAmountSpikes', () {
    test('flags amounts at least 5 times the median', () {
      final rows = [
        _tx(1, _at(1, 10), amount: 100000),
        _tx(2, _at(2, 10), amount: 120000),
        _tx(3, _at(3, 10), amount: 80000),
        _tx(4, _at(4, 10), amount: 110000),
        // Median of the five is 110,000: the limit is 550,000.
        _tx(5, _at(5, 10), amount: 550000),
      ];

      expect(detectAmountSpikes(rows, customerAccounts: _mine), {5});
    });

    test('just under the limit is not a spike', () {
      final rows = [
        for (var i = 1; i <= 4; i++) _tx(i, _at(i, 10), amount: 100000),
        _tx(5, _at(5, 10), amount: 499999),
      ];

      expect(detectAmountSpikes(rows, customerAccounts: _mine), isEmpty);
    });

    test('the payroll is compared with money in, not with purchases', () {
      final rows = [
        for (var i = 1; i <= 5; i++) _tx(i, _at(i, 10), amount: 50000),
        for (var i = 6; i <= 9; i++)
          _tx(i, _at(i, 6), amount: 4800000, incoming: true),
      ];

      expect(detectAmountSpikes(rows, customerAccounts: _mine), isEmpty);
    });

    test('each currency has its own median', () {
      final rows = [
        for (var i = 1; i <= 4; i++) _tx(i, _at(i, 10), amount: 1000000),
        for (var i = 5; i <= 8; i++)
          _tx(i, _at(i, 10), amount: 300, currency: Currency.brl),
        _tx(9, _at(9, 10), amount: 2000, currency: Currency.brl),
      ];

      expect(detectAmountSpikes(rows, customerAccounts: _mine), {9});
    });

    test('too few transactions have no normal to compare with', () {
      final rows = [
        _tx(1, _at(1, 10), amount: 1000),
        _tx(2, _at(2, 10), amount: 1000),
        _tx(3, _at(3, 10), amount: 900000),
      ];

      expect(detectAmountSpikes(rows, customerAccounts: _mine), isEmpty);
    });
  });

  group('detectUnusualHours', () {
    test('flags transactions from 00:00 to 04:59', () {
      final rows = [
        _tx(1, _at(1, 0)),
        _tx(2, _at(1, 2, 45)),
        _tx(3, _at(1, 4, 59)),
        _tx(4, _at(1, 5)),
        _tx(5, _at(1, 23, 59)),
      ];

      expect(detectUnusualHours(rows, customerAccounts: _mine), {1, 2, 3});
    });

    test('a credit at night is not the customer\'s doing', () {
      final rows = [_tx(1, _at(1, 3), incoming: true)];

      expect(detectUnusualHours(rows, customerAccounts: _mine), isEmpty);
    });

    test('with enough history, an hour nobody else uses stands out', () {
      final rows = [
        // Ten purchases between 09:00 and 13:00 on different days.
        for (var i = 1; i <= 10; i++) _tx(i, _at(i, 9 + i % 5)),
        _tx(11, _at(11, 19, 30)),
      ];

      expect(detectUnusualHours(rows, customerAccounts: _mine), {11});
    });

    test('the clock goes round midnight', () {
      final rows = [
        for (var i = 1; i <= 10; i++) _tx(i, _at(i, 12)),
        // 23:00 and 00:20 are 80 minutes apart, inside the tolerance.
        _tx(11, _at(11, 23)),
        _tx(12, _at(12, 0, 20)),
      ];

      expect(
        detectUnusualHours(
          rows,
          customerAccounts: _mine,
          nightStartHour: 1,
          nightEndHour: 5,
        ),
        isEmpty,
      );
    });

    test("the night is the customer's night, not the analyst's", () {
      // 03:00 for the customer abroad, 13:00 on the analyst's clock: unusual.
      final abroad = _tx(
        1,
        _at(1, 13),
      ).copyWith(customerLocalAt: DateTime(2026, 3, 1, 3));
      // 03:00 on the analyst's clock, 10:00 for the customer: usual.
      final home = _tx(
        2,
        _at(2, 3),
      ).copyWith(customerLocalAt: DateTime(2026, 3, 2, 10));

      expect(detectUnusualHours([abroad, home], customerAccounts: _mine), {1});
    });

    test('without enough history, only the night counts', () {
      final rows = [_tx(1, _at(1, 10)), _tx(2, _at(2, 19, 30))];

      expect(detectUnusualHours(rows, customerAccounts: _mine), isEmpty);
    });
  });

  group('detectBursts', () {
    test('three transactions in 17 minutes are a burst (AL-1773)', () {
      final rows = [
        _tx(1, _at(1, 10)),
        _tx(2, _at(28, 2, 45)),
        _tx(3, _at(28, 2, 54)),
        _tx(4, _at(28, 3, 2)),
        _tx(5, _at(28, 9)),
      ];

      expect(detectBursts(rows), {2, 3, 4});
    });

    test('two quick transactions are not a burst', () {
      final rows = [_tx(1, _at(1, 10)), _tx(2, _at(1, 10, 1))];

      expect(detectBursts(rows), isEmpty);
    });

    test('the window is measured from the first to the last one', () {
      final rows = [
        _tx(1, _at(1, 10)),
        _tx(2, _at(1, 10, 15)),
        _tx(3, _at(1, 10, 30)),
      ];

      expect(detectBursts(rows), isEmpty);
      expect(detectBursts(rows, window: const Duration(minutes: 30)), {
        1,
        2,
        3,
      });
    });

    test('5 in 10 minutes, as in the story, with stricter settings', () {
      final rows = [
        for (var i = 0; i < 5; i++) _tx(i + 1, _at(1, 14, 2 * i)),
        _tx(6, _at(1, 14, 25)),
      ];

      expect(
        detectBursts(rows, minCount: 5, window: const Duration(minutes: 10)),
        {1, 2, 3, 4, 5},
      );
    });

    test('the input order does not matter', () {
      final rows = [
        _tx(3, _at(1, 10, 10)),
        _tx(1, _at(1, 10)),
        _tx(2, _at(1, 10, 5)),
      ];

      expect(detectBursts(rows), {1, 2, 3});
    });
  });

  test('the timeline merges transactions and events with their anomalies', () {
    final event = SecurityEvent(
      id: 'e1',
      type: SecurityEventType.passwordChange,
      occurredAt: _at(28, 2, 40),
      succeeded: true,
    );
    final activity = CustomerActivity(
      transactions: [
        for (var i = 1; i <= 4; i++) _tx(i, _at(i, 10)),
        _tx(5, _at(28, 2, 45), amount: 900000),
        _tx(6, _at(28, 2, 50)),
        _tx(7, _at(28, 2, 55)),
      ],
      securityEvents: [event],
    );

    final timeline = buildTimeline(activity, customerAccounts: _mine);

    expect(timeline, hasLength(8));
    expect(timeline[4], TimelinePoint.securityEvent(event));
    final spike = timeline[5] as TransactionPoint;
    expect(spike.transaction.id, 5);
    expect(spike.anomalies, {
      ActivityAnomaly.amountSpike,
      ActivityAnomaly.unusualHour,
      ActivityAnomaly.burst,
    });
    expect((timeline.first as TransactionPoint).anomalies, isEmpty);
    expect(
      timeline.map((point) => point.occurredAt).toList(),
      [...timeline.map((point) => point.occurredAt)]..sort(),
    );
  });
}
