import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/channel.dart';
import 'package:monedasegura/core/domain/currency.dart';
import 'package:monedasegura/core/domain/transaction_type.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/core/ui/kit.dart';
import 'package:monedasegura/features/customer/domain/customer_transaction.dart';
import 'package:monedasegura/features/customer/domain/map_point.dart';
import 'package:monedasegura/features/customer/presentation/widgets/customer_map.dart';
import 'package:monedasegura/features/customer/presentation/widgets/world_camera_constraint.dart';

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

  testWidgets('zooming out stops when the world fills the map', (tester) async {
    // Almost the whole globe wide: no zoom above the limit holds the three.
    const honolulu = (21.3069, -157.8583);
    const auckland = (-36.8485, 174.7633);
    await pumpMap(tester, _points(3, [honolulu, medellin, auckland]));
    MapCamera camera() =>
        MapCamera.of(tester.element(find.byType(MarkerLayer)));
    AppIconButton zoomOut() => tester.widget<AppIconButton>(
      find.byWidgetPredicate(
        (widget) => widget is AppIconButton && widget.tooltip == 'Alejar',
      ),
    );

    // The fit itself stops on the limit.
    expect(zoomOut().onPressed, isNull);
    final limit = WorldCameraConstraint.minZoomFor(camera());
    expect(camera().zoom, closeTo(limit, 0.01));

    await tester.tap(find.byTooltip('Acercar'));
    await tester.pump();
    expect(zoomOut().onPressed, isNotNull);

    await tester.tap(find.byTooltip('Alejar'));
    await tester.pump();
    expect(camera().zoom, closeTo(limit, 0.01));
    expect(zoomOut().onPressed, isNull);
  });
}
