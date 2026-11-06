import '../theme/app_icons.dart';
import '../theme/status_tone.dart';
import 'domain_enum.dart';

/// Severity of a fraud (`severity` in the database), used by HU-04 and HU-08.
///
/// DESIGN.md lets the text carry it, so the icons only reinforce the tone in badges.
enum Severity implements DomainEnum {
  low(
    'low',
    'Baja',
    'Monto bajo, sin afectación a otros productos.',
    StatusTone.neutral,
    AppIcons.info,
  ),
  medium(
    'medium',
    'Media',
    'Monto relevante para el perfil del cliente.',
    StatusTone.warning,
    AppIcons.warning,
  ),
  high(
    'high',
    'Alta',
    'Pérdida significativa o afectación de varias cuentas/productos.',
    StatusTone.high,
    AppIcons.warning,
  ),
  critical(
    'critical',
    'Crítica',
    'Vaciado de cuenta, red de cuentas involucradas o lavado de activos.',
    StatusTone.danger,
    AppIcons.error,
  );

  const Severity(
    this.dbValue,
    this.label,
    this.description,
    this.tone,
    this.icon,
  );

  /// Reads the database value.
  factory Severity.fromDb(String value) => domainEnumFromDb(values, value);

  @override
  final String dbValue;
  @override
  final String label;

  /// Shown under the selector once a level is chosen (HU-04).
  final String description;
  @override
  final StatusTone tone;
  @override
  final AppIcons icon;
}
