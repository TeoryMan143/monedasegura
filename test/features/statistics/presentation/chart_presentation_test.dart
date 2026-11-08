import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monedasegura/core/theme/app_theme.dart';
import 'package:monedasegura/features/statistics/domain/time_series_point.dart';
import 'package:monedasegura/features/statistics/presentation/chart_presentation.dart';

void main() {
  setUpAll(() => initializeDateFormatting('es'));

  group('toSpots', () {
    test('uses the week index as X and the fraud count as Y', () {
      final spots = toSpots([
        TimeSeriesPoint(periodStart: DateTime(2026, 3, 2), fraudCount: 12),
        TimeSeriesPoint(periodStart: DateTime(2026, 3, 9), fraudCount: 0),
        TimeSeriesPoint(periodStart: DateTime(2026, 3, 16), fraudCount: 7),
      ]);

      expect([for (final s in spots) (s.x, s.y)], [(0, 12), (1, 0), (2, 7)]);
    });

    test('an empty series has no spots', () => expect(toSpots([]), isEmpty));
  });

  group('X axis labels', () {
    test('few weeks are all labelled', () {
      expect(xAxisLabelStep(5), 1);
      expect([
        for (var i = 0; i < 5; i++) showXAxisLabel(i, 5),
      ], everyElement(isTrue));
    });

    test('many weeks skip some and never exceed the maximum', () {
      const weeks = 26;
      final shown = [
        for (var i = 0; i < weeks; i++)
          if (showXAxisLabel(i, weeks)) i,
      ];

      expect(shown.first, 0);
      expect(shown.length, lessThanOrEqualTo(maxXAxisLabels));
      expect(xAxisLabelStep(weeks), 4);
    });

    test('a week is labelled as «3 mar»', () {
      expect(weekAxisLabel(DateTime(2026, 3, 3)), '3 mar');
    });
  });

  group('fraudTooltipText', () {
    final week = DateTime(2026, 3, 3);

    test('with a previous week shows the rise', () {
      expect(
        fraudTooltipText(weekStart: week, count: 41, previousCount: 38),
        'Semana del 3 mar · 41 fraudes · +8 % vs. semana anterior',
      );
    });

    test('a drop keeps its minus sign', () {
      expect(
        fraudTooltipText(weekStart: week, count: 30, previousCount: 40),
        'Semana del 3 mar · 30 fraudes · -25 % vs. semana anterior',
      );
    });

    test('leaves the change out when the previous week had none', () {
      expect(
        fraudTooltipText(weekStart: week, count: 5, previousCount: 0),
        'Semana del 3 mar · 5 fraudes',
      );
    });

    test('leaves the change out for the first week and writes «1 fraude»', () {
      expect(
        fraudTooltipText(weekStart: week, count: 1),
        'Semana del 3 mar · 1 fraude',
      );
    });
  });

  group('matrix cell colours', () {
    test('an empty cell takes dark text and a full one white text', () {
      expect(matrixCellTextColor(0), AppColors.textPrimary);
      expect(matrixCellTextColor(1), AppColors.textOnBrand);
    });

    test('the text switches to white once, going up the scale', () {
      final colors = [
        for (var i = 0; i <= 20; i++) matrixCellTextColor(i / 20),
      ];
      final switches = [
        for (var i = 1; i < colors.length; i++)
          if (colors[i] != colors[i - 1]) i,
      ];

      expect(switches, hasLength(1));
    });

    test('the intensity is clamped to the ramp', () {
      expect(matrixCellColor(-1), matrixCellColor(0));
      expect(matrixCellColor(2), matrixCellColor(1));
    });
  });

  group('Y axis', () {
    test('picks a round step that gives about four lines', () {
      expect(yAxisInterval(0), 1);
      expect(yAxisInterval(3), 1);
      expect(yAxisInterval(47), 20);
      expect(yAxisInterval(120), 50);
      expect(yAxisInterval(1284), 500);
    });

    test('the top is a whole number of steps and never under the data', () {
      expect(yAxisMax(47, 20), 60);
      expect(yAxisMax(40, 10), 40);
      expect(yAxisMax(0, 1), 1);
    });
  });
}
