import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../export_pdf_dialog.dart';

/// «Exportar PDF» (secondary) for the customer report header (C-08…C-12), opening C-14.
class ExportPdfButton extends StatelessWidget {
  const ExportPdfButton({
    required this.customerId,
    required this.customerName,
    required this.customerCode,
    required this.range,
    super.key,
  });

  final String customerId;
  final String customerName;

  /// Goes in the file name, e.g. the document number.
  final String customerCode;

  /// The report's shared date range.
  final DateTimeRange range;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'Exportar PDF',
      icon: AppIcons.download,
      variant: AppButtonVariant.secondary,
      onPressed: () => showExportPdfDialog(
        context,
        customerId: customerId,
        customerName: customerName,
        customerCode: customerCode,
        range: range,
      ),
    );
  }
}
