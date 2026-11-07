import '../theme/app_icons.dart';
import '../theme/status_tone.dart';
import 'domain_enum.dart';

/// Type of a bank account (`account_type` in the database), used by HU-02, HU-03 and
/// HU-09.
enum AccountType implements DomainEnum {
  savings('savings', 'Ahorros', 'Ah', AppIcons.bank),
  checking('checking', 'Corriente', 'Cte', AppIcons.bank),
  wallet('wallet', 'Billetera', 'Bil', AppIcons.device),
  credit('credit', 'Crédito', 'TC', AppIcons.card);

  const AccountType(this.dbValue, this.label, this.abbreviation, this.icon);

  /// Reads the database value.
  factory AccountType.fromDb(String value) => domainEnumFromDb(values, value);

  @override
  final String dbValue;
  @override
  final String label;

  /// Short form before the masked digits in tables: «Ah •••• 4417».
  final String abbreviation;
  @override
  final AppIcons icon;

  @override
  StatusTone get tone => StatusTone.neutral;
}
