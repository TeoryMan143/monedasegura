import '../theme/app_icons.dart';
import '../theme/status_tone.dart';
import 'domain_enum.dart';

/// Currency of an amount (`currencies.code`), used by HU-02, HU-03 and HU-13.
///
/// [symbol], [decimals] and [locale] mirror the `currencies` catalog. `formatMoney` in
/// `core/formatting` reads them.
enum Currency implements DomainEnum {
  cop('COP', 'Peso colombiano', r'$', 2, 'es-CO'),
  mxn('MXN', 'Peso mexicano', r'$', 2, 'es-MX'),
  pen('PEN', 'Sol peruano', 'S/', 2, 'es-PE'),
  clp('CLP', 'Peso chileno', r'$', 0, 'es-CL'),
  ars('ARS', 'Peso argentino', r'$', 2, 'es-AR'),
  brl('BRL', 'Real brasileño', r'R$', 2, 'pt-BR');

  const Currency(
    this.dbValue,
    this.label,
    this.symbol,
    this.decimals,
    this.locale,
  );

  /// Reads the database value.
  factory Currency.fromDb(String value) => domainEnumFromDb(values, value);

  /// The ISO 4217 code: COP, MXN…
  @override
  final String dbValue;
  @override
  final String label;
  final String symbol;
  final int decimals;

  /// BCP 47, e.g. `es-CO`, `pt-BR`.
  final String locale;

  String get code => dbValue;

  @override
  StatusTone get tone => StatusTone.neutral;
  @override
  AppIcons get icon => AppIcons.currency;
}
