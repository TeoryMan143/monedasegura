import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import '../../pdf_export/presentation/widgets/export_pdf_button.dart';
import 'controllers/customer_range_controller.dart';
import 'controllers/customer_report_controller.dart';
import 'widgets/customer_header.dart';
import 'widgets/customer_range_button.dart';
import 'widgets/report_accounts_tab.dart';
import 'widgets/report_map_tab.dart';
import 'widgets/report_summary_tab.dart';
import 'widgets/report_timeline_tab.dart';

/// Spanish names of the report tabs, in [CustomerReportTab] order.
extension CustomerReportTabLabel on CustomerReportTab {
  String get label => switch (this) {
    CustomerReportTab.summary => 'Resumen',
    CustomerReportTab.accounts => 'Cuentas',
    CustomerReportTab.timeline => 'Línea de tiempo',
    CustomerReportTab.map => 'Mapa',
  };
}

/// C-08…C-12 · Customer report (HU-09): one screen with four tabs and the date range
/// of A-02, shared by all of them.
///
/// «Línea de tiempo» (HU-10) and «Mapa» (HU-11) are the proof of concept of
/// `poc/timeline-map`. [onTab] changes the tab in the URL, [onBack] returns to the
/// customer view, [onOpenList] to the transaction list and [onOpenTransaction] opens a
/// transaction of the timeline or the map in the customer view.
class CustomerReportScreen extends ConsumerWidget {
  const CustomerReportScreen({
    required this.customerId,
    required this.tab,
    required this.onTab,
    required this.onBack,
    required this.onOpenList,
    required this.onOpenTransaction,
    super.key,
  });

  final String customerId;
  final CustomerReportTab tab;
  final ValueChanged<CustomerReportTab> onTab;
  final VoidCallback onBack;
  final VoidCallback onOpenList;
  final ValueChanged<int> onOpenTransaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(customerReportProvider(customerId)).value;
    final range = ref.watch(customerDateRangeProvider(customerId));
    final name = profile?.fullName ?? 'Cliente';

    return Padding(
      padding: const EdgeInsets.all(AppLayout.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Breadcrumbs(
            items: [
              Breadcrumb('Transacciones', onTap: onOpenList),
              Breadcrumb(name, onTap: onBack),
              const Breadcrumb('Reporte'),
            ],
          ),
          const SizedBox(height: AppSpace.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppText.h1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CustomerRangeButton(customerId: customerId),
              if (profile != null) ...[
                const SizedBox(width: AppSpace.sm),
                ExportPdfButton(
                  customerId: customerId,
                  customerName: profile.fullName,
                  customerCode: profile.documentNumber,
                  range: DateTimeRange(start: range.from, end: range.to),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          AppTabs(
            tabs: [
              for (final tab in CustomerReportTab.values)
                AppTab(label: tab.label),
            ],
            selectedIndex: tab.index,
            onChanged: (index) => onTab(CustomerReportTab.values[index]),
          ),
          const SizedBox(height: AppSpace.lg),
          Expanded(
            child: switch (tab) {
              CustomerReportTab.summary => ReportSummaryTab(
                customerId: customerId,
              ),
              CustomerReportTab.accounts => ReportAccountsTab(
                customerId: customerId,
              ),
              CustomerReportTab.timeline => ReportTimelineTab(
                customerId: customerId,
                onOpenTransaction: onOpenTransaction,
              ),
              CustomerReportTab.map => ReportMapTab(
                customerId: customerId,
                onOpenTransaction: onOpenTransaction,
              ),
            },
          ),
        ],
      ),
    );
  }
}
