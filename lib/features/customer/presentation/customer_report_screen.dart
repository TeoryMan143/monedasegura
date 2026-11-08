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
import 'widgets/report_summary_tab.dart';

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
/// This card builds «Resumen» and «Cuentas». «Línea de tiempo» (HU-10) and «Mapa»
/// (HU-11) stay empty for integrante 5. [onTab] changes the tab in the URL, [onBack]
/// returns to the customer view and [onOpenList] to the transaction list.
class CustomerReportScreen extends ConsumerWidget {
  const CustomerReportScreen({
    required this.customerId,
    required this.tab,
    required this.onTab,
    required this.onBack,
    required this.onOpenList,
    super.key,
  });

  final String customerId;
  final CustomerReportTab tab;
  final ValueChanged<CustomerReportTab> onTab;
  final VoidCallback onBack;
  final VoidCallback onOpenList;

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
              CustomerReportTab.timeline => const _LaterTab(
                title: 'Línea de tiempo',
                story: 'HU-10',
                icon: AppIcons.timeline,
              ),
              CustomerReportTab.map => const _LaterTab(
                title: 'Mapa de transacciones',
                story: 'HU-11',
                icon: AppIcons.location,
              ),
            },
          ),
        ],
      ),
    );
  }
}

/// A tab another card fills (integrante 5).
class _LaterTab extends StatelessWidget {
  const _LaterTab({
    required this.title,
    required this.story,
    required this.icon,
  });

  final String title;
  final String story;
  final AppIcons icon;

  @override
  Widget build(BuildContext context) => ScreenState<Object?>(
    value: const AsyncData(null),
    isEmpty: (_) => true,
    empty: EmptyState(
      title: title,
      message: 'Esta pestaña llega con $story.',
      icon: icon,
    ),
    builder: (context, _) => const SizedBox.shrink(),
  );
}
