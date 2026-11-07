import '../theme/app_icons.dart';
import '../theme/status_tone.dart';
import 'alert_status.dart';
import 'domain_enum.dart';

/// A change recorded in the audit trail (`audit_action`), used by HU-08 and HU-15.
enum AuditAction implements DomainEnum {
  createLabel(
    'create_label',
    'Etiqueta creada',
    StatusTone.brand,
    AppIcons.plus,
  ),
  updateLabel(
    'update_label',
    'Etiqueta editada',
    StatusTone.info,
    AppIcons.edit,
  ),
  confirmAlert(
    'confirm_alert',
    'Alerta confirmada',
    StatusTone.danger,
    AppIcons.check,
  ),
  rejectAlert(
    'reject_alert',
    'Alerta rechazada',
    StatusTone.success,
    AppIcons.close,
  ),
  reclassifyAlert(
    'reclassify_alert',
    'Alerta reclasificada',
    StatusTone.info,
    AppIcons.edit,
  );

  const AuditAction(this.dbValue, this.label, this.tone, this.icon);

  /// Reads the database value.
  factory AuditAction.fromDb(String value) => domainEnumFromDb(values, value);

  /// The action that resolves an alert with [status]. A pending alert has none.
  factory AuditAction.forResolution(AlertStatus status) => switch (status) {
    AlertStatus.confirmed => confirmAlert,
    AlertStatus.rejected => rejectAlert,
    AlertStatus.reclassified => reclassifyAlert,
    AlertStatus.pending => throw ArgumentError.value(
      status,
      'status',
      'A pending alert is not resolved',
    ),
  };

  @override
  final String dbValue;
  @override
  final String label;
  @override
  final StatusTone tone;
  @override
  final AppIcons icon;
}
