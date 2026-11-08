import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/transaction_type.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/features/customer/domain/customer_transaction.dart';
import 'package:monedasegura/features/customer/domain/map_point.dart';
import 'package:monedasegura/features/customer/presentation/widgets/customer_map.dart';

List<MapPoint> _points(int count, List<(double, double)> places) =>
    mapPointsOf([
      for (var i = 0; i < count; i++)
        CustomerTransaction(
          id: i,
          code: 'TX-$i',
          occurredAt: DateTime(2026, 10).add(Duration(hours: i)),
          type: TransactionType.purchase,
          channel: Channel.pos,
          amount: 1000,
          currency: Currency.cop,
          sourceAccountId: 'a1',
          isLabeled: false,
          latitude: places[i % places.length].$1,
          longitude: places[i % places.length].$2,
        ),
    ]);

void main() {
  Future<void> pumpMap(WidgetTester tester, List<MapPoint> points) async {
    tester.view
      ..physicalSize = const Size(800, 600)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: CustomerMap(
            points: points,
            trips: const [],
            selectedId: null,
            onSelect: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();
  }

  const medellin = (6.2442, -75.5812);
  const bogota = (4.7110, -74.0721);

  testWidgets('a small map shows one pin per transaction', (tester) async {
    await pumpMap(tester, _points(6, [medellin, bogota]));

    expect(find.byTooltip(RegExp('^TX-')), findsNWidgets(6));
  });

  testWidgets('a big map groups nearby transactions with their count', (
    tester,
  ) async {
    await pumpMap(tester, _points(400, [medellin, bogota]));

    expect(find.text('200'), findsNWidgets(2));
    expect(find.byTooltip(RegExp('^TX-')), findsNothing);
  });
}
