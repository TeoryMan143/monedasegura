import '../theme/app_icons.dart';
import '../theme/status_tone.dart';
import 'domain_enum.dart';

/// Verdict of a label (`verdict` in the database), used by HU-02, HU-04 and HU-05.
enum Verdict implements DomainEnum {
  fraud('fraud', 'Fraude', StatusTone.danger, AppIcons.error),
  notFraud('not_fraud', 'No fraude', StatusTone.success, AppIcons.check),
  uncertain('uncertain', 'Incierto', StatusTone.warning, AppIcons.info);

  const Verdict(this.dbValue, this.label, this.tone, this.icon);

  /// Reads the database value.
  factory Verdict.fromDb(String value) => domainEnumFromDb(values, value);

  @override
  final String dbValue;
  @override
  final String label;
  @override
  final StatusTone tone;
  @override
  final AppIcons icon;
}
