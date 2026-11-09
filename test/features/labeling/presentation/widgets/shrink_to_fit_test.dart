import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/features/labeling/presentation/widgets/shrink_to_fit.dart';

void main() {
  /// [ShrinkToFit] in a 200 × [height] box, around a column of [rows] 50 px rows, each
  /// a [GestureDetector] that records its index when tapped.
  Future<List<int>> pump(
    WidgetTester tester, {
    required double height,
    int rows = 4,
    double minScale = 0.4,
  }) async {
    final taps = <int>[];
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 200,
            height: height,
            child: Align(
              alignment: Alignment.topCenter,
              child: ShrinkToFit(
                minScale: minScale,
                child: Column(
                  children: [
                    for (var i = 0; i < rows; i++)
                      GestureDetector(
                        onTap: () => taps.add(i),
                        child: SizedBox(
                          height: 50,
                          child: Center(child: Text('row $i')),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return taps;
  }

  RenderShrinkToFit render(WidgetTester tester) =>
      tester.renderObject(find.byType(ShrinkToFit));

  testWidgets('a child that fits keeps its full size', (tester) async {
    await pump(tester, height: 400);

    expect(render(tester).scale, 1);
    expect(tester.getSize(find.byType(ShrinkToFit)), const Size(200, 200));
  });

  testWidgets('a taller child scales down to the height, never past it', (
    tester,
  ) async {
    await pump(tester, height: 100);

    expect(render(tester).scale, closeTo(0.5, 0.01));
    expect(
      tester.getSize(find.byType(ShrinkToFit)).height,
      lessThanOrEqualTo(100),
    );
    expect(tester.getBottomLeft(find.text('row 3')).dy, lessThanOrEqualTo(100));
  });

  testWidgets('taps land on the scaled rows', (tester) async {
    final taps = await pump(tester, height: 100);

    await tester.tap(find.text('row 2'));
    await tester.tap(find.text('row 0'));

    expect(taps, [2, 0]);
  });

  testWidgets('below the minimum scale it clips instead of overflowing', (
    tester,
  ) async {
    await pump(tester, height: 40, minScale: 0.5);

    expect(render(tester).scale, 0.5);
    expect(tester.getSize(find.byType(ShrinkToFit)).height, 40);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a zero height does not break the layout', (tester) async {
    await pump(tester, height: 0);

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(ShrinkToFit)).height, 0);
  });

  testWidgets('it grows back to full size when there is room again', (
    tester,
  ) async {
    await pump(tester, height: 100);
    expect(render(tester).scale, lessThan(1));

    await pump(tester, height: 400);
    expect(render(tester).scale, 1);
  });
}
