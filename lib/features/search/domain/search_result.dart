import '../../../core/theme/app_icons.dart';

/// Group of a global search result, in display order.
enum SearchResultKind {
  customer('Clientes', AppIcons.user),
  account('Cuentas', AppIcons.bank),
  transaction('Transacciones', AppIcons.transfer);

  const SearchResultKind(this.groupLabel, this.icon);

  /// Group header in the results list.
  final String groupLabel;
  final AppIcons icon;
}

/// One row of the global search (C-05). Every result leads to a customer view.
class SearchResult {
  const SearchResult({
    required this.kind,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.customerId,
    this.transactionId,
    this.occurredAt,
  });

  final SearchResultKind kind;
  final String id;

  /// Customer name, «•••• 4417» or «TX-48219».
  final String title;
  final String subtitle;

  /// Customer to open. Null for accounts without a customer (never returned).
  final String customerId;

  /// Transaction to select in the customer view (`?tx=`), for transaction results.
  final String? transactionId;

  /// When the transaction happened, for transaction results.
  final DateTime? occurredAt;
}
