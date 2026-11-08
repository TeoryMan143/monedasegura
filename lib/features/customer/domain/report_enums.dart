import '../../../core/domain/domain_enum.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/status_tone.dart';

/// `customer_segment`, shown in the report summary (HU-09).
enum CustomerSegment implements DomainEnum {
  retail('retail', 'Personas'),
  retailMidIncome('retail_mid_income', 'Personas ingreso medio'),
  premium('premium', 'Premium'),
  smallBusiness('small_business', 'Pyme'),
  corporate('corporate', 'Empresarial');

  const CustomerSegment(this.dbValue, this.label);

  factory CustomerSegment.fromDb(String value) =>
      domainEnumFromDb(values, value);

  @override
  final String dbValue;
  @override
  final String label;
  @override
  StatusTone get tone => StatusTone.brand;
  @override
  AppIcons get icon => AppIcons.user;
}

/// `risk_level` of a customer (HU-09).
enum RiskLevel implements DomainEnum {
  low('low', 'Riesgo bajo', StatusTone.success),
  medium('medium', 'Riesgo medio', StatusTone.warning),
  high('high', 'Riesgo alto', StatusTone.danger);

  const RiskLevel(this.dbValue, this.label, this.tone);

  factory RiskLevel.fromDb(String value) => domainEnumFromDb(values, value);

  @override
  final String dbValue;
  @override
  final String label;
  @override
  final StatusTone tone;
  @override
  AppIcons get icon => AppIcons.shield;
}

/// `product_status` of an account or a card (report «Cuentas», HU-09).
enum ProductStatus implements DomainEnum {
  active('active', 'Activa', StatusTone.success, AppIcons.check),
  blocked('blocked', 'Bloqueada', StatusTone.danger, AppIcons.lock),
  inactive('inactive', 'Inactiva', StatusTone.neutral, AppIcons.minus),
  closed('closed', 'Cerrada', StatusTone.neutral, AppIcons.close);

  const ProductStatus(this.dbValue, this.label, this.tone, this.icon);

  factory ProductStatus.fromDb(String value) => domainEnumFromDb(values, value);

  @override
  final String dbValue;
  @override
  final String label;
  @override
  final StatusTone tone;
  @override
  final AppIcons icon;
}

/// `card_type`.
enum CardType implements DomainEnum {
  debit('debit', 'Débito'),
  credit('credit', 'Crédito');

  const CardType(this.dbValue, this.label);

  factory CardType.fromDb(String value) => domainEnumFromDb(values, value);

  @override
  final String dbValue;
  @override
  final String label;
  @override
  StatusTone get tone => StatusTone.neutral;
  @override
  AppIcons get icon => AppIcons.card;
}

/// `device_type`.
enum DeviceType implements DomainEnum {
  mobile('mobile', 'Celular'),
  tablet('tablet', 'Tableta'),
  desktop('desktop', 'Computador'),
  atm('atm', 'Cajero'),
  pos('pos', 'Datáfono');

  const DeviceType(this.dbValue, this.label);

  factory DeviceType.fromDb(String value) => domainEnumFromDb(values, value);

  @override
  final String dbValue;
  @override
  final String label;
  @override
  StatusTone get tone => StatusTone.neutral;
  @override
  AppIcons get icon => AppIcons.device;
}
