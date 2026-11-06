import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/pdf_export_repository.dart';
import '../../domain/customer_report.dart';
import '../customer_report_document.dart';
import '../customer_report_pdf.dart';

/// State of the C-14 export: idle (`AsyncData(null)`), exporting (`AsyncLoading`), the
/// saved path (`AsyncData(path)`) or the `Failure` (`AsyncError`).
final pdfExportControllerProvider =
    AsyncNotifierProvider.autoDispose<PdfExportController, String?>(
      PdfExportController.new,
      name: 'pdfExportControllerProvider',
    );

/// Exports the customer report to PDF (HU-12): reads the customer from the database,
/// formats it, builds the PDF in an isolate and saves it at [export]'s `path`.
class PdfExportController extends AsyncNotifier<String?> {
  @override
  String? build() => null;

  Future<void> export({
    required String customerId,
    required DateTime from,
    required DateTime to,
    required Set<ReportSection> sections,
    required String analystName,
    required String path,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(pdfExportRepositoryProvider);
    final result = await AsyncValue.guard(() async {
      final report = await repository.fetchCustomerReport(
        customerId: customerId,
        from: from,
        to: to,
      );
      final document = CustomerReportDocument.from(
        report,
        sections: sections,
        analystName: analystName,
        from: from,
        to: to,
        generatedAt: DateTime.now(),
      );
      final fonts = await PdfFonts.load();
      final bytes = await buildCustomerReportPdfInIsolate(document, fonts);
      await repository.saveFile(path, bytes);
      return path;
    });
    if (!ref.mounted) return;
    state = result;
  }
}
