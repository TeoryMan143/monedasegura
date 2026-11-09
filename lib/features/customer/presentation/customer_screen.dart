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
/// [transactionId] (`?tx=`) is the transaction open in the classification panel (N-02):
/// the range moves to show it if needed. The screen does not keep it: a click on a row,
/// «Siguiente» and closing the panel call [onSelectTransaction], and the router writes
/// the new `?tx=` (null closes the panel). So the open transaction survives going to the
/// report and back.
///
/// [onBack] goes back to the list, and [onOpenReport] opens the customer report, or is
/// null while that route does not exist. The router passes them, so this feature does
/// not depend on the app's routes.
class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({
    required this.customerId,
    required this.onBack,
    required this.onSelectTransaction,
    this.transactionId,
    this.at,
    this.onOpenReport,
    super.key,
  });

  final String customerId;
  final String? transactionId;
  final String? at;
  final VoidCallback onBack;
  final ValueChanged<int?> onSelectTransaction;
  final OpenCustomerReport? onOpenReport;

  @override
  ConsumerState<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {
  ProviderSubscription<AsyncValue<DateTime?>>? _dateSubscription;

  /// Always shown: [build] decides whether the overlay holds the panel.
  final _panelOverlay = OverlayPortalController()..show();

  int? get _selected => int.tryParse(widget.transactionId ?? '');

  @override
  void initState() {
    super.initState();
    final transactionId = int.tryParse(widget.transactionId ?? '');
    if (DateTime.tryParse(widget.at ?? '') case final day?
        when transactionId == null) {
      // After this build: a provider cannot change while the tree is building.
      Future.microtask(() {
        if (!mounted) return;
        ref
            .read(customerDateRangeProvider(widget.customerId).notifier)
            .show(day);
      });
    }
    _showInRange(_selected);
  }

  @override
  void didUpdateWidget(CustomerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final selected = _selected;
    if (oldWidget.transactionId == widget.transactionId || selected == null) {
      return;
    }
    // A row of the table is already in the range. Only a `?tx=` from elsewhere, e.g. the
    // global search while this customer is open, may need to move it.
    final rows =
        ref
            .read(customerTransactionsPageProvider(widget.customerId))
            .value
            ?.items ??
        const [];
    if (!rows.any((row) => row.id == selected)) _showInRange(selected);
  }

  /// Moves the range so that it shows [transactionId], once its date arrives.
  void _showInRange(int? transactionId) {
    _dateSubscription?.close();
    _dateSubscription = null;
    if (transactionId == null) return;
    _dateSubscription = ref.listenManual(
      customerTransactionDateProvider(transactionId),
      (_, next) {
        final date = next.value;
        if (date == null) return;
        ref
            .read(customerDateRangeProvider(widget.customerId).notifier)
            .show(date);
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.customerId;
    // The screen owns the range while it is open: it must survive the moment before the
    // table is built, e.g. when `?tx=` moves it while the customer still loads.
    ref.listen(customerDateRangeProvider(id), (_, _) {});
    final selected = _selected;
    // N-02 opens on the selected row (HU-04). It goes to the root overlay, so it dims the
    // whole window (side menu and top bar too), like a dialog. It only shows while this
    // page is the visible one: not under the report pushed on top, nor in another tab.
    final visible =
        selected != null &&
        (ModalRoute.isCurrentOf(context) ?? true) &&
        TickerMode.valuesOf(context).enabled;
    return OverlayPortal(
      overlayLocation: OverlayChildLocation.rootOverlay,
      controller: _panelOverlay,
      overlayChildBuilder: (context) =>
          visible ? _panel(id, selected) : const SizedBox.shrink(),
      child: _content(id),
    );
  }

  Widget _panel(String id, int selected) => SizedBox.expand(
    child: Stack(
      children: [
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
    ),
  );

  void _closePanel() => widget.onSelectTransaction(null);

  /// «Siguiente»: the next row of the current page, or closes after the last one.
  void _openNext(int current) {
    final rows =
        ref
            .read(customerTransactionsPageProvider(widget.customerId))
            .value
            ?.items ??
        const [];
    final index = rows.indexWhere((row) => row.id == current);
    widget.onSelectTransaction(
      index >= 0 && index + 1 < rows.length ? rows[index + 1].id : null,
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
                  onSelect: widget.onSelectTransaction,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
