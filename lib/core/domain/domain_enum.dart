import '../theme/app_icons.dart';
import '../theme/status_tone.dart';

/// What every domain enum defines once, so widgets never retype it (AGENTS.md, rule 8).
abstract interface class DomainEnum {
  /// The value stored in the database: an enum value, a catalog code or a level.
  Object get dbValue;

  /// Spanish label for the UI.
  String get label;
  StatusTone get tone;
  AppIcons get icon;
}

/// Finds the value of [values] stored as [dbValue] in the database.
///
/// Throws an [ArgumentError] for an unknown value: the app and the database disagree on
/// the contract in `docs/mer.puml`, and that must not go unnoticed.
T domainEnumFromDb<T extends DomainEnum>(List<T> values, Object dbValue) {
  return values.firstWhere(
    (value) => value.dbValue == dbValue,
    orElse: () =>
        throw ArgumentError.value(dbValue, 'dbValue', 'Unknown $T value'),
  );
}
