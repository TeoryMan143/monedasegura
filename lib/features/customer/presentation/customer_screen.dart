import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import '../../labeling/presentation/classification_panel.dart';
import 'controllers/customer_range_controller.dart';
import 'controllers/customer_view_controller.dart';
import 'widgets/customer_header.dart';
import 'widgets/customer_transactions_table.dart';

export 'widgets/customer_header.dart'
    show CustomerReportTab, OpenCustomerReport;

/// A-02 · Customer view (HU-03): the transactions of all the customer's accounts in a
/// date range, to classify them with context.
///
/// [transactionId] (`?tx=`) is the selected transaction: the range moves to show it if
/// needed. [onBack] goes back to the list, and [onOpenReport] opens the customer report,
/// or is null while that route does not exist. The router passes both, so this feature
/// does not depend on the app's routes.
class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({
    required this.customerId,
    required this.onBack,
    this.transactionId,
    this.onOpenReport,
    super.key,
  });

  final String customerId;
  final String? transactionId;
  final VoidCallback onBack;
  final OpenCustomerReport? onOpenReport;

  @override
  ConsumerState<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {
  int? _selected;

  @override
  void initState() {
    super.initState();
    final transactionId = int.tryParse(widget.transactionId ?? '');
    _selected = transactionId;
    if (transactionId == null) return;
    ref.listenManual(customerTransactionDateProvider(transactionId), (_, next) {
      final date = next.value;
      if (date == null) return;
      ref
          .read(customerDateRangeProvider(widget.customerId).notifier)
          .show(date);
    }, fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.customerId;
    // The screen owns the range while it is open: it must survive the moment before the
    // table is built, e.g. when `?tx=` moves it while the customer still loads.
    ref.listen(customerDateRangeProvider(id), (_, _) {});
    final selected = _selected;
    return Stack(
      children: [
        _content(id),
        // N-02 opens over the table on the selected row (HU-04).
        if (selected != null) ...[
          Positioned.fill(
            child: GestureDetector(
              onTap: _closePanel,
              child: const ColoredBox(color: AppColors.bgOverlay),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            width: AppLayout.sidePanelWidth,
            child: ClassificationPanel(
              key: ValueKey(selected),
              transactionId: selected,
              onClose: _closePanel,
              onNext: () => _openNext(selected),
              onSaved: () => ref
                ..invalidate(customerTransactionsPageProvider(id))
                ..invalidate(customerLabelProgressProvider(id)),
            ),
          ),
        ],
      ],
    );
  }

  void _closePanel() => setState(() => _selected = null);

  /// «Siguiente»: the next row of the current page, or closes after the last one.
  void _openNext(int current) {
    final rows =
        ref
            .read(customerTransactionsPageProvider(widget.customerId))
            .value
            ?.items ??
        const [];
    final index = rows.indexWhere((row) => row.id == current);
    setState(
      () => _selected = index >= 0 && index + 1 < rows.length
          ? rows[index + 1].id
          : null,
    );
  }

  Widget _content(String id) {
    return Padding(
      padding: const EdgeInsets.all(AppLayout.contentPadding),
      child: ScreenState(
        value: ref.watch(customerViewProvider(id)),
        onRetry: () => ref.invalidate(customerViewProvider(id)),
        builder: (context, customer) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomerHeader(
              customer: customer,
              onBack: widget.onBack,
              onOpenReport: widget.onOpenReport,
            ),
            const SizedBox(height: AppSpace.lg),
            Expanded(
              child: AppPanel(
                expand: true,
                padding: EdgeInsets.zero,
                child: CustomerTransactionsTable(
                  customer: customer,
                  selectedTransactionId: _selected,
                  onSelect: (transactionId) =>
                      setState(() => _selected = transactionId),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
