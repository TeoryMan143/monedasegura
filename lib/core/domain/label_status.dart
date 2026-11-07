import '../theme/app_icons.dart';
import '../theme/status_tone.dart';
import 'domain_enum.dart';

/// Labeling status of a transaction (`transactions.is_labeled`), used by HU-02 and HU-03.
enum LabelStatus implements DomainEnum {
  unlabeled(false, 'Sin etiquetar', StatusTone.neutral, AppIcons.clock),
  labeled(true, 'Etiquetada', StatusTone.brand, AppIcons.check);

  const LabelStatus(this.dbValue, this.label, this.tone, this.icon);

  /// Reads the database value.
  factory LabelStatus.fromDb(bool value) => domainEnumFromDb(values, value);

  /// The value of `is_labeled`.
  @override
  final bool dbValue;
  @override
  final String label;
  @override
  final StatusTone tone;
  @override
  final AppIcons icon;
}
