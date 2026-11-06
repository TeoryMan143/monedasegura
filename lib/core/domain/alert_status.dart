import '../theme/app_icons.dart';
import '../theme/status_tone.dart';
import 'domain_enum.dart';

/// Status of an AI alert (`alert_status`), used by HU-06, HU-07 and HU-08.
enum AlertStatus implements DomainEnum {
  pending('pending', 'Pendiente', StatusTone.warning, AppIcons.clock),
  confirmed('confirmed', 'Confirmada', StatusTone.danger, AppIcons.check),
  rejected('rejected', 'Rechazada', StatusTone.success, AppIcons.close),
  reclassified('reclassified', 'Reclasificada', StatusTone.info, AppIcons.edit);

  const AlertStatus(this.dbValue, this.label, this.tone, this.icon);

  /// Reads the database value.
  factory AlertStatus.fromDb(String value) => domainEnumFromDb(values, value);

  @override
  final String dbValue;
  @override
  final String label;
  @override
  final StatusTone tone;
  @override
  final AppIcons icon;

  /// An alert leaves the pending inbox once it stops being [pending].
  bool get isResolved => this != pending;
}
