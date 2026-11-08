import 'package:intl/intl.dart';

import '../../../../core/domain/label_status.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/status_tone.dart';
import '../../domain/customer_transaction.dart';
import '../../domain/timeline_point.dart';

/// How the timeline and the map show a transaction's label: Fraude danger, No fraude
/// success, Incierto warning, Sin etiquetar neutral (DESIGN.md · Timeline, Map).
extension TransactionLabelStyle on CustomerTransaction {
  StatusTone get labelTone => verdict?.tone ?? LabelStatus.unlabeled.tone;
  String get labelText => verdict?.label ?? LabelStatus.unlabeled.label;
  AppIcons get labelIcon => verdict?.icon ?? LabelStatus.unlabeled.icon;
}

/// Spanish name, tone and icon of each anomaly of the timeline (HU-10).
extension ActivityAnomalyStyle on ActivityAnomaly {
  String get label => switch (this) {
    ActivityAnomaly.amountSpike => 'Pico de monto',
    ActivityAnomaly.unusualHour => 'Horario inusual',
    ActivityAnomaly.burst => 'Ráfaga',
  };

  StatusTone get tone => switch (this) {
    ActivityAnomaly.amountSpike => StatusTone.high,
    ActivityAnomaly.unusualHour => StatusTone.warning,
    ActivityAnomaly.burst => StatusTone.danger,
  };

  AppIcons get icon => switch (this) {
    ActivityAnomaly.amountSpike => AppIcons.trendUp,
    ActivityAnomaly.unusualHour => AppIcons.clock,
    ActivityAnomaly.burst => AppIcons.warning,
  };
}

/// «4.907 km», «3.099 km/h»: whole numbers with Spanish thousands separators.
String formatWhole(num value) =>
    NumberFormat.decimalPattern('es').format(value.round());

/// Time between two transactions: `6 min`, `1 h 35 min`, `2 d 3 h`.
String formatElapsed(Duration elapsed) {
  final minutes = elapsed.inMinutes.abs();
  if (minutes < 60) return '$minutes min';
  final hours = minutes ~/ 60;
  if (hours < 24) {
    final rest = minutes % 60;
    return rest == 0 ? '$hours h' : '$hours h $rest min';
  }
  final rest = hours % 24;
  return rest == 0 ? '${hours ~/ 24} d' : '${hours ~/ 24} d $rest h';
}
