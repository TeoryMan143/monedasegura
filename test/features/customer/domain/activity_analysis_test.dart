import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/transaction_type.dart';
import 'package:monedasegura/features/customer/domain/activity_analysis.dart';
import 'package:monedasegura/features/customer/domain/customer_activity.dart';
import 'package:monedasegura/features/customer/domain/customer_transaction.dart';
import 'package:monedasegura/features/customer/domain/timeline_point.dart';

const _mine = {'a1'};

CustomerTransaction _tx(
  int id,
  DateTime at, {
  (double, double)? place,
  num amount = 100000,
}) => CustomerTransaction(
  id: id,
  code: 'TX-$id',
  occurredAt: at,
  type: TransactionType.purchase,
  channel: Channel.pos,
  amount: amount,
  currency: Currency.cop,
  sourceAccountId: 'a1',
  isLabeled: false,
  latitude: place?.$1,
  longitude: place?.$2,
);

TimelinePoint _burst(int id, DateTime at) => TimelinePoint.transaction(
  _tx(id, at),
  anomalies: const {ActivityAnomaly.burst},
);

DateTime _at(int day, int hour, int minute) =>
    DateTime(2026, 9, day, hour, minute);

void main() {
  group('burstWindowsOf', () {
    test('joins the burst transactions close in time into one band', () {
      final windows = burstWindowsOf([
        _burst(1, _at(3, 10, 0)),
        _burst(2, _at(3, 10, 8)),
        TimelinePoint.transaction(_tx(3, _at(3, 10, 9))),
        _burst(4, _at(3, 10, 15)),
        _burst(5, _at(5, 18, 0)),
        _burst(6, _at(5, 18, 4)),
      ]);

      expect(windows, [
        BurstWindow(start: _at(3, 10, 0), end: _at(3, 10, 15), count: 3),
        BurstWindow(start: _at(5, 18, 0), end: _at(5, 18, 4), count: 2),
      ]);
    });

    test('no bursts, no bands', () {
      expect(
        burstWindowsOf([TimelinePoint.transaction(_tx(1, _at(3, 10, 0)))]),
        isEmpty,
      );
    });
  });

  test('the analysis has the timeline, the map and the impossible trips', () {
    const medellin = (6.2442, -75.5812);
    const bogota = (4.7110, -74.0721);
    final analysis = analyzeActivity(
      CustomerActivity(
        transactions: [
          _tx(1, _at(3, 12, 0), place: medellin),
          _tx(2, _at(3, 12, 6), place: bogota),
          _tx(3, _at(3, 12, 10)),
          _tx(4, _at(4, 12, 0), place: bogota),
        ],
        securityEvents: const [],
        truncated: true,
      ),
      customerAccounts: _mine,
    );

    expect(analysis.timeline, hasLength(4));
    expect(analysis.mapPoints.map((p) => p.transaction.id), [1, 2, 4]);
    expect(analysis.withoutPlace, 1);
    expect(analysis.trips.single.to.transaction.id, 2);
    expect(analysis.bursts.single.count, 3);
    expect(analysis.anomaliesOf(2), contains(ActivityAnomaly.burst));
    expect(analysis.anomaliesOf(4), isEmpty);
    expect(analysis.truncated, isTrue);
  });

  test('10,000 transactions are analysed in well under a second', () {
    final start = DateTime(2026, 8);
    final activity = CustomerActivity(
      transactions: [
        for (var i = 0; i < 10000; i++)
          _tx(
            i,
            start.add(Duration(minutes: i * 7)),
            place: (4 + (i % 7) * 0.9, -75 + (i % 5) * 0.4),
            amount: 1000 + (i * 7919) % 900000,
          ),
      ],
      securityEvents: const [],
    );

    final watch = Stopwatch()..start();
    final analysis = analyzeActivity(activity, customerAccounts: _mine);

    expect(analysis.timeline, hasLength(10000));
    // Generous on purpose: it guards against a quadratic rule, not a benchmark.
    expect(watch.elapsed, lessThan(const Duration(seconds: 1)));
  });
}
