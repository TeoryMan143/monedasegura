import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/score_range.dart';
import 'package:monedasegura/core/theme/status_tone.dart';

void main() {
  group('ScoreRange.of', () {
    test('maps the limits of every range', () {
      expect(ScoreRange.of(0), ScoreRange.low);
      expect(ScoreRange.of(39), ScoreRange.low);
      expect(ScoreRange.of(40), ScoreRange.medium);
      expect(ScoreRange.of(69), ScoreRange.medium);
      expect(ScoreRange.of(70), ScoreRange.high);
      expect(ScoreRange.of(84), ScoreRange.high);
      expect(ScoreRange.of(85), ScoreRange.critical);
      expect(ScoreRange.of(100), ScoreRange.critical);
    });

    test('clamps scores outside 0–100', () {
      expect(ScoreRange.of(-5), ScoreRange.low);
      expect(ScoreRange.of(140), ScoreRange.critical);
    });
  });

  test('each range has the tone of DESIGN.md', () {
    expect(ScoreRange.low.tone, StatusTone.success);
    expect(ScoreRange.medium.tone, StatusTone.warning);
    expect(ScoreRange.high.tone, StatusTone.high);
    expect(ScoreRange.critical.tone, StatusTone.danger);
  });

  test('riskLabel writes the range text of the score meter', () {
    expect(ScoreRange.critical.riskLabel, 'Riesgo crítico (85–100)');
    expect(ScoreRange.low.riskLabel, 'Riesgo bajo (0–39)');
  });
}
