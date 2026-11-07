import 'dart:isolate';

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/theme/app_theme.dart';
import '../domain/customer_report.dart';
import 'customer_report_document.dart';

/// Plus Jakarta Sans for the PDF (DESIGN.md · PDF: the font is embedded).
class PdfFonts {
  const PdfFonts({required this.regular, required this.bold});

  final ByteData regular;
  final ByteData bold;

  /// Loads the bundled font files. Call it on the UI isolate.
  static Future<PdfFonts> load() async => PdfFonts(
    regular: await rootBundle.load('assets/fonts/PlusJakartaSans-Regular.ttf'),
    bold: await rootBundle.load('assets/fonts/PlusJakartaSans-Bold.ttf'),
  );
}

/// Builds the PDF off the UI thread (ARCHITECTURAL_SPINE.md · Data flow, rule 6).
///
/// Top level on purpose: the isolate closure only captures [document] and [fonts].
Future<Uint8List> buildCustomerReportPdfInIsolate(
  CustomerReportDocument document,
  PdfFonts? fonts,
) {
  return Isolate.run(() => buildCustomerReportPdf(document, fonts));
}

/// C-14 · sample customer report: header with the Moneda Segura mark, customer, date,
/// analyst and range; one block per chosen tab; Icesi footer with page numbers.
///
/// Without [fonts] it falls back to the PDF standard font (used by the tests).
Future<Uint8List> buildCustomerReportPdf(
  CustomerReportDocument document,
  PdfFonts? fonts,
) {
  final theme = fonts == null
      ? pw.ThemeData.base()
      : pw.ThemeData.withFont(
          base: pw.Font.ttf(fonts.regular),
          bold: pw.Font.ttf(fonts.bold),
        );
  final pdf = pw.Document(
    title: 'Reporte de cliente · ${document.customerName}',
    author: 'Moneda Segura',
  );
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: theme,
      margin: const pw.EdgeInsets.all(AppSpace.x4l),
      header: (context) => _header(document),
      footer: _footer,
      build: (context) => [
        for (final section in document.sections) ..._section(section, document),
      ],
    ),
  );
  return pdf.save();
}

PdfColor _pdf(Color color) => PdfColor.fromInt(color.toARGB32());

pw.TextStyle _style(TextStyle style, {Color? color, bool bold = false}) =>
    pw.TextStyle(
      fontSize: style.fontSize,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      color: _pdf(color ?? AppColors.textPrimary),
    );

pw.Widget _header(CustomerReportDocument document) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: AppSpace.xxl),
    padding: const pw.EdgeInsets.only(bottom: AppSpace.md),
    decoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: _pdf(AppColors.borderDefault)),
      ),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            pw.Container(
              width: AppLayout.brandMarkSize / 2,
              height: AppLayout.brandMarkSize / 2,
              decoration: pw.BoxDecoration(
                color: _pdf(AppColors.bgBrand),
                borderRadius: pw.BorderRadius.circular(AppRadius.sm),
              ),
            ),
            pw.SizedBox(width: AppSpace.sm),
            pw.Text('Moneda Segura', style: _style(AppText.h3, bold: true)),
            pw.Spacer(),
            pw.Text(
              'Reporte de cliente',
              style: _style(AppText.bodyS, color: AppColors.textSecondary),
            ),
          ],
        ),
        pw.SizedBox(height: AppSpace.md),
        pw.Text(document.customerName, style: _style(AppText.h1, bold: true)),
        pw.SizedBox(height: AppSpace.xs),
        pw.Text(
          'Generado el ${document.generatedAt} · Analista: ${document.analystName} · '
          'Rango: ${document.rangeLabel}',
          style: _style(AppText.bodyS, color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}

pw.Widget _footer(pw.Context context) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(top: AppSpace.lg),
    child: pw.Row(
      children: [
        pw.Text(
          'Proyecto académico · Universidad Icesi',
          style: _style(AppText.bodyS, color: AppColors.textTertiary),
        ),
        pw.Spacer(),
        pw.Text(
          'Página ${context.pageNumber} de ${context.pagesCount}',
          style: _style(AppText.bodyS, color: AppColors.textTertiary),
        ),
      ],
    ),
  );
}

List<pw.Widget> _section(
  ReportSection section,
  CustomerReportDocument document,
) {
  final title = pw.Padding(
    padding: const pw.EdgeInsets.only(top: AppSpace.lg, bottom: AppSpace.sm),
    child: pw.Text(section.label, style: _style(AppText.h2, bold: true)),
  );
  return switch (section) {
    ReportSection.summary => [
      title,
      pw.Table(
        columnWidths: const {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(2),
        },
        children: [
          for (final (label, value) in document.summaryRows)
            pw.TableRow(
              children: [
                _cell(label, color: AppColors.textSecondary),
                _cell(value),
              ],
            ),
        ],
      ),
    ],
    ReportSection.accounts => [
      title,
      _table(
        headers: const ['Cuenta', 'Tipo', 'Banco', 'Saldo', 'Estado'],
        rows: document.accountRows,
        numericColumn: 3,
        empty: 'El cliente no tiene cuentas propias.',
      ),
    ],
    ReportSection.timeline => [
      title,
      _note('Transacciones del rango en orden cronológico inverso.'),
      _table(
        headers: const [
          'Fecha',
          'Transacción',
          'Tipo · canal',
          'Monto',
          'Etiqueta',
        ],
        rows: document.transactionRows,
        numericColumn: 3,
        empty: 'No hay transacciones en el rango.',
      ),
    ],
    ReportSection.map => [
      title,
      _note('Ubicación de las transacciones del rango.'),
      _table(
        headers: const ['Fecha', 'Transacción', 'Ciudad', 'Coordenadas'],
        rows: document.locationRows,
        empty: 'No hay transacciones con ubicación en el rango.',
      ),
    ],
  };
}

pw.Widget _note(String text) => pw.Padding(
  padding: const pw.EdgeInsets.only(bottom: AppSpace.sm),
  child: pw.Text(
    text,
    style: _style(AppText.bodyS, color: AppColors.textSecondary),
  ),
);

pw.Widget _cell(String text, {Color? color}) => pw.Padding(
  padding: const pw.EdgeInsets.symmetric(vertical: AppSpace.xs),
  child: pw.Text(text, style: _style(AppText.bodyS, color: color)),
);

pw.Widget _table({
  required List<String> headers,
  required List<List<String>> rows,
  required String empty,
  int? numericColumn,
}) {
  if (rows.isEmpty) return _note(empty);
  return pw.TableHelper.fromTextArray(
    headers: headers,
    data: rows,
    border: null,
    headerStyle: _style(AppText.bodyS, bold: true),
    cellStyle: _style(AppText.bodyS),
    headerDecoration: pw.BoxDecoration(color: _pdf(AppColors.bgSurfaceSubtle)),
    rowDecoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: _pdf(AppColors.borderSubtle)),
      ),
    ),
    cellAlignments: {?numericColumn: pw.Alignment.centerRight},
    cellPadding: const pw.EdgeInsets.symmetric(
      horizontal: AppSpace.xs,
      vertical: AppSpace.xs,
    ),
  );
}
