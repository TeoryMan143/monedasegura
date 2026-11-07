import '../theme/app_icons.dart';
import '../theme/status_tone.dart';
import 'domain_enum.dart';

/// Type of a transaction (`transaction_type` in the database), used by HU-02 and HU-03.
enum TransactionType implements DomainEnum {
  debit('debit', 'Débito', AppIcons.currency),
  credit('credit', 'Crédito', AppIcons.currency),
  transfer('transfer', 'Transferencia', AppIcons.transfer),
  withdrawal('withdrawal', 'Retiro', AppIcons.bank),
  payment('payment', 'Pago', AppIcons.document),
  purchase('purchase', 'Compra', AppIcons.card);

  const TransactionType(this.dbValue, this.label, this.icon);

  /// Reads the database value.
  factory TransactionType.fromDb(String value) =>
      domainEnumFromDb(values, value);

  @override
  final String dbValue;
  @override
  final String label;
  @override
  final AppIcons icon;

  @override
  StatusTone get tone => StatusTone.neutral;
}
