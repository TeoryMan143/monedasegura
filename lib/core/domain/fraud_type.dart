import '../theme/app_icons.dart';
import '../theme/status_tone.dart';
import 'domain_enum.dart';

/// Fixed fraud taxonomy (`fraud_types.code`), used by HU-04, HU-06 and HU-13.
///
/// The row `id` and `color` belong to the `fraud_types` catalog: RPCs take the id, and the
/// colour goes only in the `TaxonomyChip` square and chart series (DESIGN.md).
enum FraudType implements DomainEnum {
  accountTakeover(
    'ATO',
    'Robo de cuenta',
    'Un tercero toma control de la cuenta del cliente.',
    AppIcons.lock,
  ),
  phishing(
    'PHI',
    'Phishing / ingeniería social',
    'El cliente es engañado para autorizar operaciones.',
    AppIcons.mail,
  ),
  clonedCard(
    'CLO',
    'Tarjeta clonada',
    'Uso de una copia física o de los datos de la tarjeta.',
    AppIcons.card,
  ),
  moneyMule(
    'MUL',
    'Cuenta mula',
    'Cuenta usada para recibir y mover dinero ilícito.',
    AppIcons.bank,
  ),
  laundering(
    'LAV',
    'Lavado / fraccionamiento',
    'Montos divididos para evadir controles.',
    AppIcons.transfer,
  ),
  syntheticIdentity(
    'SIN',
    'Identidad sintética',
    'Cliente creado con datos falsos o combinados.',
    AppIcons.user,
  ),
  simSwap(
    'SIM',
    'SIM swap',
    'Duplicado de SIM para interceptar códigos de verificación.',
    AppIcons.device,
  ),
  unrecognizedPurchase(
    'CNR',
    'Compra no reconocida',
    'Compra que el cliente niega haber hecho.',
    AppIcons.currency,
  );

  const FraudType(this.dbValue, this.label, this.description, this.icon);

  /// Reads the database value.
  factory FraudType.fromDb(String value) => domainEnumFromDb(values, value);

  /// The taxonomy code: ATO, PHI, CLO…
  @override
  final String dbValue;
  @override
  final String label;
  final String description;
  @override
  final AppIcons icon;

  /// The code shown in bold in the taxonomy chip.
  String get code => dbValue;

  @override
  StatusTone get tone => StatusTone.neutral;
}
