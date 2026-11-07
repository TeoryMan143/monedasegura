import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import '../../auth/presentation/controllers/session_controller.dart';
import '../domain/customer_report.dart';
import 'controllers/pdf_export_controller.dart';

/// Opens C-14 · «Exportar reporte a PDF» (HU-12) for one customer and date range.
///
/// [customerCode] goes in the default file name
/// `reporte-cliente-<code>-<yyyyMMdd>.pdf` (e.g. the document number).
Future<void> showExportPdfDialog(
  BuildContext context, {
  required String customerId,
  required String customerName,
  required String customerCode,
  required DateTimeRange range,
}) {
  return showAppDialog<void>(
    context: context,
    builder: (context) => ExportPdfDialog(
      customerId: customerId,
      customerName: customerName,
      customerCode: customerCode,
      range: range,
    ),
  );
}

/// C-14 · choose the report tabs, then the native save dialog picks the location.
class ExportPdfDialog extends ConsumerStatefulWidget {
  const ExportPdfDialog({
    required this.customerId,
    required this.customerName,
    required this.customerCode,
    required this.range,
    super.key,
  });

  final String customerId;
  final String customerName;
  final String customerCode;
  final DateTimeRange range;

  @override
  ConsumerState<ExportPdfDialog> createState() => _ExportPdfDialogState();
}

class _ExportPdfDialogState extends ConsumerState<ExportPdfDialog> {
  // Which tabs go into the PDF: local form state of the dialog.
  final _sections = {...ReportSection.values};

  Future<void> _export() async {
    if (_sections.isEmpty || ref.read(pdfExportControllerProvider).isLoading) {
      return;
    }
    final today = DateFormat('yyyyMMdd').format(DateTime.now());
    final location = await getSaveLocation(
      suggestedName: 'reporte-cliente-${widget.customerCode}-$today.pdf',
      acceptedTypeGroups: const [
        XTypeGroup(label: 'PDF', extensions: ['pdf']),
      ],
    );
    if (location == null || !mounted) return;
    final path = location.path.toLowerCase().endsWith('.pdf')
        ? location.path
        : '${location.path}.pdf';
    await ref
        .read(pdfExportControllerProvider.notifier)
        .export(
          customerId: widget.customerId,
          from: widget.range.start,
          to: widget.range.end,
          sections: {..._sections},
          analystName: ref.read(sessionProvider)?.fullName ?? 'Analista',
          path: path,
        );
  }

  void _toggle(ReportSection section, bool selected) {
    setState(() {
      selected ? _sections.add(section) : _sections.remove(section);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(pdfExportControllerProvider, (previous, next) {
      if (next case AsyncData(value: final String path)) {
        showAppToast(
          context,
          type: AppToastType.success,
          title: 'Reporte exportado',
          message: path,
        );
        Navigator.of(context).pop();
      }
    });
    final export = ref.watch(pdfExportControllerProvider);
    final analystName = ref.watch(sessionProvider)?.fullName ?? 'Analista';
    final day = DateFormat('dd MMM yyyy', 'es');
    final range =
        '${day.format(widget.range.start)} – ${day.format(widget.range.end)}';

    return AppDialog(
      title: 'Exportar reporte a PDF',
      subtitle: widget.customerName,
      size: AppDialogSize.l,
      onSubmit: _export,
      actions: [
        AppButton(
          label: 'Cancelar',
          variant: AppButtonVariant.secondary,
          onPressed: export.isLoading
              ? null
              : () => Navigator.of(context).pop(),
        ),
        AppButton(
          label: 'Exportar PDF',
          icon: AppIcons.download,
          loading: export.isLoading,
          onPressed: _sections.isEmpty ? null : _export,
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (export.hasError && !export.isLoading) ...[
            InlineBanner(
              tone: StatusTone.danger,
              title: failureMessage(export.error!).title,
              message:
                  'No se pudo exportar el reporte. '
                  '${failureMessage(export.error!).message}',
            ),
            const SizedBox(height: AppSpace.lg),
          ],
          _InfoRow(label: 'Cliente', value: widget.customerName),
          _InfoRow(label: 'Rango', value: range),
          _InfoRow(label: 'Analista', value: analystName),
          const SizedBox(height: AppSpace.xl),
          const FieldLabel('Pestañas a incluir', required: true),
          const SizedBox(height: AppSpace.sm),
          for (final section in ReportSection.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.sm),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppCheckbox(
                  value: _sections.contains(section),
                  label: section.label,
                  onChanged: export.isLoading
                      ? null
                      : (selected) => _toggle(section, selected),
                ),
              ),
            ),
          if (_sections.isEmpty)
            const FieldMessage('Elige al menos una pestaña.', isError: true),
          const SizedBox(height: AppSpace.md),
          const InlineBanner(
            tone: StatusTone.info,
            icon: AppIcons.info,
            title: 'PDF de muestra del prototipo',
            message:
                'Incluye los datos reales del cliente en tablas. Las gráficas y el '
                'mapa como imagen llegan en la versión funcional.',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.xs),
      child: Row(
        children: [
          SizedBox(
            width: AppSizes.menuMinWidth / 2,
            child: Text(
              label,
              style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(child: Text(value, style: AppText.bodyMMedium)),
        ],
      ),
    );
  }
}
