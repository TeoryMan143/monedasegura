import '../theme/status_tone.dart';

/// Risk ranges of the AI score 0–100 (DESIGN.md · Status tones).
///
/// | Range | Score | Tone |
/// | --- | --- | --- |
/// | Bajo | 0–39 | success |
/// | Medio | 40–69 | warning |
/// | Alto | 70–84 | high |
/// | Crítico | 85–100 | danger |
enum ScoreRange {
  low('Bajo', StatusTone.success, 0, 39),
  medium('Medio', StatusTone.warning, 40, 69),
  high('Alto', StatusTone.high, 70, 84),
  critical('Crítico', StatusTone.danger, 85, 100);

  const ScoreRange(this.label, this.tone, this.min, this.max);

  /// Spanish label: «Bajo», «Medio», «Alto», «Crítico».
  final String label;
  final StatusTone tone;

  /// Lowest score in the range, inclusive.
  final int min;

  /// Highest score in the range, inclusive.
  final int max;

  /// The range a [score] falls in. Values outside 0–100 are clamped.
  static ScoreRange of(int score) {
    final clamped = score.clamp(0, 100);
    return values.firstWhere((range) => clamped <= range.max);
  }

  /// Text for the score meter badge, e.g. «Riesgo crítico (85–100)».
  String get riskLabel => 'Riesgo ${label.toLowerCase()} ($min–$max)';
}
