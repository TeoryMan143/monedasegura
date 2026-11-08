import '../theme/app_icons.dart';
import '../theme/status_tone.dart';

/// How much one reason weighs in an AI alert: «Peso alto», «Peso medio», «Peso bajo».
///
/// `ai_alert_reasons.weight` is a share between 0 and 1, and the weights of an alert add up
/// to about 1. With two to five reasons per alert, a reason that carries at least 30 % of
/// the decision is «alto» and one under 15 % is «bajo». The text keeps it readable without
/// colour.
enum ReasonWeight {
  high('Peso alto', StatusTone.danger, AppIcons.error, 0.30),
  medium('Peso medio', StatusTone.high, AppIcons.warning, 0.15),
  low('Peso bajo', StatusTone.warning, AppIcons.info, 0);

  const ReasonWeight(this.label, this.tone, this.icon, this.min);

  /// Spanish label: «Peso alto», «Peso medio», «Peso bajo».
  final String label;
  final StatusTone tone;
  final AppIcons icon;

  /// Lowest weight in the group, inclusive.
  final double min;

  /// The group a [weight] falls in.
  static ReasonWeight of(double weight) =>
      values.firstWhere((group) => weight >= group.min);
}
