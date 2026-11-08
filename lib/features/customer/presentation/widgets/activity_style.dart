import 'package:intl/intl.dart';

import '../../../../core/domain/label_status.dart';
import '../../../../core/formatting/date_time.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/status_tone.dart';
import '../../domain/customer_transaction.dart';
import '../../domain/timeline_point.dart';

/// How the timeline and the map show a transaction's status: its label (Fraude danger,
/// No fraude success, Incierto warning), else its AI alert (info, IA icon), else Sin
/// etiquetar neutral (DESIGN.md · Timeline, Map). Labels saved in this session are
/// already in the transaction (`withLocalLabels`).
extension TransactionStatusStyle on CustomerTransaction {
  StatusTone get statusTone =>
      verdict?.tone ??
      (hasAiAlert ? StatusTone.info : LabelStatus.unlabeled.tone);

  String get statusText =>
      verdict?.label ??
      (hasAiAlert ? 'Alerta IA · $alertScore' : LabelStatus.unlabeled.label);

  AppIcons get statusIcon =>
      verdict?.icon ?? (hasAiAlert ? AppIcons.ai : LabelStatus.unlabeled.icon);

  /// The customer's clock when it is not the analyst's: «16:53», or the full date when
  /// the day changes too. Null when both clocks agree or it is unknown.
  String? get customerClock {
    final theirs = customerLocalAt;
    if (theirs == null) return null;
    final mine = occurredAt.toLocal();
    if (theirs.hour == mine.hour && theirs.minute == mine.minute) return null;
    return theirs.day == mine.day ? formatTime(theirs) : formatDateTime(theirs);
  }
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
