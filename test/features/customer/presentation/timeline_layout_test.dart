import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/security_event_type.dart';
import 'package:monedasegura/core/domain/transaction_type.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/theme/status_tone.dart';
import 'package:monedasegura/features/customer/domain/activity_analysis.dart';
import 'package:monedasegura/features/customer/domain/customer_activity.dart';
import 'package:monedasegura/features/customer/domain/customer_transaction.dart';
import 'package:monedasegura/features/customer/domain/security_event.dart';
import 'package:monedasegura/features/customer/presentation/widgets/activity_style.dart';
import 'package:monedasegura/features/customer/presentation/widgets/report_timeline_tab.dart';
import 'package:monedasegura/features/customer/presentation/widgets/timeline/timeline_layout.dart';

CustomerTransaction _tx(
  int id,
  DateTime at, {
  Verdict? verdict,
  int? alertScore,
}) => CustomerTransaction(
  id: id,
  code: 'TX-$id',
  occurredAt: at,
  type: TransactionType.purchase,
  channel: Channel.pos,
  amount: 1000 + id,
  currency: Currency.cop,
  sourceAccountId: 'a1',
  alertScore: alertScore,
  isLabeled: verdict != null,
  verdict: verdict,
);

SecurityEvent _event(String id, SecurityEventType type, DateTime at) =>
    SecurityEvent(id: id, type: type, occurredAt: at, succeeded: true);

TimelineAnalysis _analysis(
  List<CustomerTransaction> transactions, {
  List<SecurityEvent> events = const [],
}) => analyzeTimeline(
  CustomerActivity(transactions: transactions, securityEvents: events),
  customerAccounts: const {'a1'},
);

void main() {
  final start = DateTime(2026, 10);
  final month = DateTimeRange(start: start, end: DateTime(2026, 10, 31));

  test('a few transactions are marks sized by amount', () {
    final layout = TimelineLayout(
      analysis: _analysis([
        for (var i = 0; i < 20; i++) _tx(i, start.add(Duration(days: i))),
      ]),
      window: month,
      width: 900,
    );

    expect(layout.dense, isFalse);
    expect(layout.marks, hasLength(20));
    expect(layout.bins, isEmpty);
  });

  test('thousands of transactions become bars per slice, by label', () {
    final transactions = [
      for (var i = 0; i < 3000; i++)
        _tx(
          i,
          start.add(Duration(minutes: i * 14)),
          verdict: i.isEven ? Verdict.fraud : null,
        ),
    ];
    final layout = TimelineLayout(
      analysis: _analysis(transactions),
      window: month,
      width: 900,
    );

    expect(layout.dense, isTrue);
    expect(layout.marks, isEmpty);
    final total = layout.bins.fold(0, (sum, bin) => sum + bin.total);
    expect(total, 3000);
    final fraud = layout.bins.fold(
      0,
      (sum, bin) => sum + (bin.counts[StatusTone.danger] ?? 0),
    );
    expect(fraud, 1500);

    final bin = layout.bins.firstWhere((bin) => bin.total > 0);
    expect(layout.hit(bin.bounds.center), same(bin));
    expect(layout.barHeight(bin.total), greaterThan(0));
  });

  test('a burst minutes apart does not pile up: every mark is apart', () {
    // The demo burst: three purchases in a few minutes at 02:45.
    final night = DateTime(2026, 10, 7, 2, 45);
    final layout = TimelineLayout(
      analysis: _analysis([
        for (var i = 0; i < 3; i++) _tx(i, night.add(Duration(minutes: i * 5))),
      ]),
      window: DateTimeRange(
        start: DateTime(2026, 10, 7),
        end: DateTime(2026, 10, 8),
      ),
      width: 600,
    );

    expect(layout.marks, hasLength(3));
    for (final a in layout.marks) {
      for (final b in layout.marks) {
        if (identical(a, b)) continue;
        expect(
          (a.center - b.center).distance,
          greaterThanOrEqualTo(a.radius + b.radius),
        );
      }
    }
    for (final mark in layout.marks) {
      expect(layout.hit(mark.center), same(mark));
    }
  });

  test('with no free room left, a mark still lands apart from the rest', () {
    final night = DateTime(2026, 10, 7, 2, 45);
    final layout = TimelineLayout(
      analysis: _analysis([
        for (var i = 0; i < 5; i++) _tx(i, night.add(Duration(minutes: i))),
      ]),
      window: DateTimeRange(
        start: DateTime(2026, 10, 7),
        end: DateTime(2026, 10, 8),
      ),
      width: 600,
    );

    final centers = layout.marks.map((mark) => mark.center).toSet();
    expect(centers, hasLength(5));
  });

  test('a day shades the customer night, a month does not', () {
    final day = DateTimeRange(
      start: DateTime(2026, 10, 7),
      end: DateTime(2026, 10, 8),
    );
    final analysis = _analysis([_tx(1, DateTime(2026, 10, 7, 3))]);

    final dayLayout = TimelineLayout(
      analysis: analysis,
      window: day,
      width: 900,
    );
    final monthLayout = TimelineLayout(
      analysis: analysis,
      window: month,
      width: 900,
    );

    expect(dayLayout.nights, hasLength(1));
    final night = dayLayout.nights.single;
    expect(night.left, dayLayout.xOf(DateTime(2026, 10, 7)));
    expect(night.right, dayLayout.xOf(DateTime(2026, 10, 7, 5)));
    expect(monthLayout.nights, isEmpty);
  });

  test('security events get their name where it fits, and it is clickable', () {
    final at = DateTime(2026, 10, 7, 22);
    final layout = TimelineLayout(
      analysis: _analysis(
        [_tx(1, at)],
        events: [
          _event('e1', SecurityEventType.passwordChange, at),
          _event('e2', SecurityEventType.simChange, at),
          _event('e3', SecurityEventType.login, at),
        ],
      ),
      window: DateTimeRange(
        start: DateTime(2026, 10, 7),
        end: DateTime(2026, 10, 8),
      ),
      width: 900,
    );

    // Two rows, above and below the diamonds: the routine login is left out.
    expect(layout.eventLabels.map((label) => label.point.event.id), [
      'e1',
      'e2',
    ]);
    final label = layout.eventLabels.first;
    expect(
      layout.hit(label.bounds.centerLeft + const Offset(2, 0)),
      isA<PlacedMark>(),
    );
  });

  test('an unlabeled transaction with an AI alert shows the alert', () {
    final alerted = _tx(1, start, alertScore: 92);
    final labeled = _tx(2, start, alertScore: 92, verdict: Verdict.fraud);

    expect(alerted.statusTone, StatusTone.info);
    expect(alerted.statusText, 'Alerta IA · 92');
    expect(labeled.statusTone, StatusTone.danger);
    expect(_tx(3, start).statusTone, StatusTone.neutral);

    final layout = TimelineLayout(
      analysis: _analysis([
        for (var i = 0; i < 3000; i++)
          _tx(i, start.add(Duration(minutes: i * 14)), alertScore: 80),
      ]),
      window: month,
      width: 900,
    );
    final alerts = layout.bins.fold(
      0,
      (sum, bin) => sum + (bin.counts[StatusTone.info] ?? 0),
    );
    expect(alerts, 3000);
  });

  group('TimelineZoom', () {
    final sunday = DateTime(2026, 11, 8, 15, 30);

    test('windows follow the calendar', () {
      expect(TimelineZoom.day.startOf(sunday), DateTime(2026, 11, 8));
      expect(TimelineZoom.week.startOf(sunday), DateTime(2026, 11, 2));
      expect(TimelineZoom.month.startOf(sunday), DateTime(2026, 11));
      expect(
        TimelineZoom.month.windowFrom(DateTime(2026, 2)).end,
        DateTime(2026, 3),
      );
      expect(
        TimelineZoom.week.shift(DateTime(2026, 11, 2), -1),
        DateTime(2026, 10, 26),
      );
    });

    test('clicking a dense bar zooms one level closer', () {
      expect(
        TimelineZoom.closerThan(const Duration(days: 90)),
        TimelineZoom.month,
      );
      expect(
        TimelineZoom.closerThan(const Duration(days: 31)),
        TimelineZoom.week,
      );
      expect(
        TimelineZoom.closerThan(const Duration(days: 7)),
        TimelineZoom.day,
      );
    });
  });
}
