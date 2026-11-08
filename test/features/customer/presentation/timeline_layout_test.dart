import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/transaction_type.dart';
import 'package:monedasegura/core/domain/verdict.dart';
import 'package:monedasegura/core/theme/status_tone.dart';
import 'package:monedasegura/features/customer/domain/activity_analysis.dart';
import 'package:monedasegura/features/customer/domain/customer_activity.dart';
import 'package:monedasegura/features/customer/domain/customer_transaction.dart';
import 'package:monedasegura/features/customer/presentation/widgets/timeline/timeline_layout.dart';

CustomerTransaction _tx(int id, DateTime at, {Verdict? verdict}) =>
    CustomerTransaction(
      id: id,
      code: 'TX-$id',
      occurredAt: at,
      type: TransactionType.purchase,
      channel: Channel.pos,
      amount: 1000 + id,
      currency: Currency.cop,
      sourceAccountId: 'a1',
      isLabeled: verdict != null,
      verdict: verdict,
    );

TimelineAnalysis _analysis(List<CustomerTransaction> transactions) =>
    analyzeTimeline(
      CustomerActivity(transactions: transactions, securityEvents: const []),
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
}
