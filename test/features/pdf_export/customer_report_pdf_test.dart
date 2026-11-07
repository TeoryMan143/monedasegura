import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monedasegura/features/pdf_export/domain/customer_report.dart';
import 'package:monedasegura/features/pdf_export/presentation/customer_report_document.dart';
import 'package:monedasegura/features/pdf_export/presentation/customer_report_pdf.dart';

const _clp = ReportCurrency(
  code: 'CLP',
  symbol: r'$',
  decimals: 0,
  locale: 'es-CL',
);

final _report = CustomerReport(
  customer: ReportCustomer(
    id: 'c1',
    fullName: 'Juan Pérez',
    documentType: 'RUT',
    documentNumber: '12345678-9',
    countryName: 'Chile',
    segment: 'premium',
    riskLevel: 'high',
    customerSince: DateTime(2020, 5, 2),
  ),
  accounts: const [
    ReportAccount(
      last4: '4417',
      type: 'savings',
      bankName: 'Banco Andino',
      status: 'active',
      currency: _clp,
      balance: 1250000,
    ),
  ],
  transactions: [
    ReportTransaction(
      code: 'TX-48219',
      occurredAt: DateTime(2026, 3, 3, 22, 41),
      type: 'transfer',
      channelCode: 'app',
      amount: 1900000,
      currency: _clp,
      isLabeled: false,
      cityName: 'Santiago',
      latitude: -33.4489,
      longitude: -70.6693,
    ),
  ],
);

CustomerReportDocument _document(Set<ReportSection> sections) =>
    CustomerReportDocument.from(
      _report,
      sections: sections,
      analystName: 'Laura Gómez',
      from: DateTime(2026, 3),
      to: DateTime(2026, 3, 31),
      generatedAt: DateTime(2026, 11, 8, 10, 30),
    );

void main() {
  setUpAll(() => initializeDateFormatting('es'));

  test('formats the chosen sections in report order', () {
    final document = _document({ReportSection.map, ReportSection.summary});

    expect(document.sections, [ReportSection.summary, ReportSection.map]);
    expect(document.rangeLabel, contains('2026'));
    expect(document.summaryRows, contains(('Segmento', 'Premium')));
    expect(document.accountRows.single.first, '•••• 4417');
  });

  test('CLP amounts have no decimals', () {
    final amount = _document({ReportSection.timeline})
        .transactionRows
        .single[3];

    expect(amount, endsWith('CLP'));
    expect(amount, isNot(contains(',00')));
  });

  test('builds a PDF document', () async {
    final bytes = await buildCustomerReportPdf(
      _document(ReportSection.values.toSet()),
      null,
    );

    expect(ascii.decode(bytes.sublist(0, 4)), '%PDF');
  });
}
