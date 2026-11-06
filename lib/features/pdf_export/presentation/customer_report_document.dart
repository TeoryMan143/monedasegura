import 'package:intl/intl.dart';

import '../domain/customer_report.dart';

/// The PDF of a customer report as ready-to-print text (HU-12).
///
/// Built on the UI isolate, where `intl` has the Spanish locale loaded, so the PDF
/// builder in `Isolate.run` only lays out strings.
class CustomerReportDocument {
  const CustomerReportDocument({
    required this.customerName,
    required this.generatedAt,
    required this.analystName,
    required this.rangeLabel,
    required this.sections,
    required this.summaryRows,
    required this.accountRows,
    required this.transactionRows,
    required this.locationRows,
  });

  /// Formats [report] for the chosen [sections].
  factory CustomerReportDocument.from(
    CustomerReport report, {
    required Set<ReportSection> sections,
    required String analystName,
    required DateTime from,
    required DateTime to,
    required DateTime generatedAt,
  }) {
    final day = DateFormat('dd MMM yyyy', 'es');
    final dateTime = DateFormat('dd MMM yyyy HH:mm', 'es');
    final customer = report.customer;
    return CustomerReportDocument(
      customerName: customer.fullName,
      generatedAt: dateTime.format(generatedAt),
      analystName: analystName,
      rangeLabel: '${day.format(from)} – ${day.format(to)}',
      sections: [
        for (final section in ReportSection.values)
          if (sections.contains(section)) section,
      ],
      summaryRows: [
        ('Documento', '${customer.documentType} ${customer.documentNumber}'),
        ('País', customer.countryName),
        ('Segmento', _segments[customer.segment] ?? customer.segment),
        ('Nivel de riesgo', _risks[customer.riskLevel] ?? customer.riskLevel),
        ('Cliente desde', day.format(customer.customerSince)),
        if (customer.email != null) ('Correo', customer.email!),
        if (customer.phone != null) ('Teléfono', customer.phone!),
        ('Cuentas', '${report.accounts.length}'),
        ('Transacciones en el rango', _transactionCount(report)),
        (
          'Etiquetadas en el rango',
          '${report.transactions.where((t) => t.isLabeled).length}',
        ),
      ],
      accountRows: [
        for (final account in report.accounts)
          [
            '•••• ${account.last4}',
            _accountTypes[account.type] ?? account.type,
            account.bankName,
            account.balance == null
                ? '—'
                : _money(account.balance!, account.currency),
            _statuses[account.status] ?? account.status,
          ],
      ],
      transactionRows: [
        for (final transaction in report.transactions)
          [
            dateTime.format(transaction.occurredAt),
            transaction.code,
            '${_transactionTypes[transaction.type] ?? transaction.type} · '
                '${transaction.channelCode}',
            _money(transaction.amount, transaction.currency),
            transaction.isLabeled ? 'Etiquetada' : 'Sin etiquetar',
          ],
      ],
      locationRows: [
        for (final transaction in report.transactions)
          if (transaction.latitude != null && transaction.longitude != null)
            [
              dateTime.format(transaction.occurredAt),
              transaction.code,
              transaction.cityName ?? '—',
              '${transaction.latitude!.toStringAsFixed(4)}, '
                  '${transaction.longitude!.toStringAsFixed(4)}',
            ],
      ],
    );
  }

  final String customerName;
  final String generatedAt;
  final String analystName;
  final String rangeLabel;

  /// Chosen sections, in report order.
  final List<ReportSection> sections;
  final List<(String, String)> summaryRows;
  final List<List<String>> accountRows;
  final List<List<String>> transactionRows;
  final List<List<String>> locationRows;

  static String _transactionCount(CustomerReport report) {
    final count = report.transactions.length;
    return count < reportTransactionLimit ? '$count' : '$count o más';
  }

  /// Amount in its currency: locale and decimals from the `currencies` catalog
  /// (CLP without decimals). Swap for `formatMoney` of `core/formatting` once merged.
  static String _money(double amount, ReportCurrency currency) {
    final format = NumberFormat.currency(
      locale: currency.locale.replaceAll('-', '_'),
      symbol: currency.symbol,
      decimalDigits: currency.decimals,
    );
    return '${format.format(amount)} ${currency.code}';
  }

  // Spanish labels of the raw enum values. Swap for the `core/domain` extensions once
  // they are merged.
  static const _segments = {
    'retail': 'Personas',
    'retail_mid_income': 'Personas ingreso medio',
    'premium': 'Premium',
    'small_business': 'Pyme',
    'corporate': 'Empresarial',
  };
  static const _risks = {'low': 'Bajo', 'medium': 'Medio', 'high': 'Alto'};
  static const _accountTypes = {
    'savings': 'Ahorros',
    'checking': 'Corriente',
    'wallet': 'Billetera',
    'credit': 'Crédito',
  };
  static const _statuses = {
    'active': 'Activa',
    'blocked': 'Bloqueada',
    'inactive': 'Inactiva',
    'closed': 'Cerrada',
  };
  static const _transactionTypes = {
    'debit': 'Débito',
    'credit': 'Crédito',
    'transfer': 'Transferencia',
    'withdrawal': 'Retiro',
    'payment': 'Pago',
    'purchase': 'Compra',
  };
}
