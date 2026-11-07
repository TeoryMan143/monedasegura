import '../theme/app_icons.dart';
import '../theme/status_tone.dart';
import 'currency.dart';
import 'domain_enum.dart';

/// Country of operation (`countries.code`), used by HU-02, HU-03 and HU-13.
enum Country implements DomainEnum {
  colombia('CO', 'Colombia', Currency.cop),
  mexico('MX', 'México', Currency.mxn),
  peru('PE', 'Perú', Currency.pen),
  chile('CL', 'Chile', Currency.clp),
  argentina('AR', 'Argentina', Currency.ars),
  brazil('BR', 'Brasil', Currency.brl);

  const Country(this.dbValue, this.label, this.currency);

  /// Reads the database value.
  factory Country.fromDb(String value) => domainEnumFromDb(values, value);

  /// The ISO 3166-1 code: CO, MX…
  @override
  final String dbValue;
  @override
  final String label;

  /// Mirrors `countries.currency_code`.
  final Currency currency;

  String get code => dbValue;

  @override
  StatusTone get tone => StatusTone.neutral;
  @override
  AppIcons get icon => AppIcons.location;
}
