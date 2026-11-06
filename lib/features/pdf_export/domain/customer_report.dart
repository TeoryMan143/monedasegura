/// The sample PDF lists the latest transactions of the range, not all of them.
const reportTransactionLimit = 50;

/// Tabs of the customer report that can go into the PDF (C-14), in report order.
enum ReportSection {
  summary('Resumen'),
  accounts('Cuentas'),
  timeline('Línea de tiempo'),
  map('Mapa');

  const ReportSection(this.label);

  final String label;
}

/// Currency of an amount, from the `currencies` catalog (locale and decimals).
class ReportCurrency {
  const ReportCurrency({
    required this.code,
    required this.symbol,
    required this.decimals,
    required this.locale,
  });

  final String code;
  final String symbol;
  final int decimals;

  /// BCP 47, e.g. `es-CO`, `pt-BR`.
  final String locale;
}

class ReportCustomer {
  const ReportCustomer({
    required this.id,
    required this.fullName,
    required this.documentType,
    required this.documentNumber,
    required this.countryName,
    required this.segment,
    required this.riskLevel,
    required this.customerSince,
    this.email,
    this.phone,
  });

  final String id;
  final String fullName;
  final String documentType;
  final String documentNumber;
  final String countryName;

  /// Raw `customer_segment` value.
  final String segment;

  /// Raw `risk_level` value.
  final String riskLevel;
  final DateTime customerSince;
  final String? email;
  final String? phone;
}

class ReportAccount {
  const ReportAccount({
    required this.last4,
    required this.type,
    required this.bankName,
    required this.status,
    required this.currency,
    this.balance,
  });

  final String last4;

  /// Raw `account_type` value.
  final String type;
  final String bankName;

  /// Raw `product_status` value.
  final String status;
  final ReportCurrency currency;
  final double? balance;
}

class ReportTransaction {
  const ReportTransaction({
    required this.code,
    required this.occurredAt,
    required this.type,
    required this.channelCode,
    required this.amount,
    required this.currency,
    required this.isLabeled,
    this.cityName,
    this.latitude,
    this.longitude,
  });

  final String code;
  final DateTime occurredAt;

  /// Raw `transaction_type` value.
  final String type;
  final String channelCode;
  final double amount;
  final ReportCurrency currency;
  final bool isLabeled;
  final String? cityName;
  final double? latitude;
  final double? longitude;
}

/// Everything the PDF of one customer needs, read from the database (HU-12).
class CustomerReport {
  const CustomerReport({
    required this.customer,
    required this.accounts,
    required this.transactions,
  });

  final ReportCustomer customer;
  final List<ReportAccount> accounts;

  /// Latest transactions of the range, newest first (at most
  /// [reportTransactionLimit]).
  final List<ReportTransaction> transactions;
}
