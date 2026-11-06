import '../theme/app_icons.dart';
import '../theme/status_tone.dart';
import 'domain_enum.dart';

/// Confidence of a label (`confidence_levels.level` 1–4), used by HU-04 and HU-08.
///
/// DESIGN.md gives confidence no status colour: it is not a risk, so every level uses the
/// `brand` tone.
enum ConfidenceLevel implements DomainEnum {
  low(
    1,
    'Baja',
    'Un solo indicio aislado con posible explicación legítima. '
        'Justificación obligatoria.',
    requiresJustification: true,
  ),
  medium(
    2,
    'Media',
    'Dos o más indicios coinciden, sin evidencia concluyente.',
  ),
  high(3, 'Alta', 'Patrón claro de un tipo de fraude conocido.'),
  veryHigh(
    4,
    'Muy alta',
    'Evidencia concluyente (reclamo, contracargo o patrón idéntico a un tipo '
        'conocido).',
  );

  const ConfidenceLevel(
    this.dbValue,
    this.label,
    this.criteria, {
    this.requiresJustification = false,
  });

  /// Reads the database value.
  factory ConfidenceLevel.fromDb(int value) => domainEnumFromDb(values, value);

  @override
  final int dbValue;
  @override
  final String label;

  /// Shown under the selector once a level is chosen (HU-04).
  final String criteria;

  /// Mirrors `confidence_levels.requires_justification`.
  final bool requiresJustification;

  @override
  StatusTone get tone => StatusTone.brand;
  @override
  AppIcons get icon => AppIcons.info;
}
