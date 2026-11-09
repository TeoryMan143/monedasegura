import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import '../../auth/presentation/controllers/session_controller.dart';
import '../domain/alert_detail.dart';
import 'controllers/alerts_providers.dart';
import 'widgets/alert_customer_card.dart';
import 'widgets/alert_detail_header.dart';
import 'widgets/alert_detail_skeleton.dart';
import 'widgets/alert_reasons_panel.dart';
import 'widgets/alert_resolution_banner.dart';
import 'widgets/alert_score_card.dart';
import 'widgets/alert_transactions_panel.dart';

/// A-05 · Alert detail (HU-07): why the AI raised the alert, so the analyst can decide
/// whether it was right.
///
/// [onBack] goes back to the inbox, [onOpenTransaction] and [onOpenCustomer] open the
/// customer view and [onResolve] opens the resolve window. The router passes them, so
/// this feature does not depend on the app's routes. Everything comes from `alertDetailProvider` and goes
/// through [ScreenState].
class AlertDetailScreen extends ConsumerWidget {
  const AlertDetailScreen({
    required this.alertId,
    required this.onBack,
    required this.onOpenTransaction,
    required this.onOpenCustomer,
    this.onResolve,
    super.key,
  });

  final String alertId;
  final VoidCallback onBack;

  /// Opens a transaction of the alert in the customer view: receives the customer and
  /// the transaction.
  final void Function(String customerId, int transactionId) onOpenTransaction;

  /// Opens the customer view, from «Ver cliente»: receives the customer and when the
  /// alert was generated, so the view's date range can show the alert's activity.
  final void Function(String customerId, DateTime at) onOpenCustomer;

  /// Opens the resolve window (A-06, HU-08). Null while that window does not exist:
  /// «Resolver alerta» stays disabled.
  final VoidCallback? onResolve;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(alertDetailProvider(alertId));

    // A missing alert is not an error to retry: it will not appear by asking again.
    if (detail.hasError &&
        !detail.isLoading &&
        detail.error is NotFoundFailure) {
      return EmptyState(
        title: 'No encontramos esta alerta',
        message: 'Puede que se haya eliminado o que el enlace no sea correcto.',
        icon: AppIcons.search,
        actionLabel: 'Volver a la bandeja',
        onAction: onBack,
      );
    }

    return ScreenState<AlertDetail>(
      value: detail,
      onRetry: () => ref.invalidate(alertDetailProvider(alertId)),
      loading: const AlertDetailSkeleton(),
      builder: (context, detail) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppLayout.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AlertDetailHeader(
              alert: detail.alert,
              onBack: onBack,
              onResolve: onResolve,
            ),
            if (detail.alert.isResolved) ...[
              const SizedBox(height: AppSpace.lg),
              AlertResolutionBanner(
                alert: detail.alert,
                resolvedByMe:
                    detail.alert.resolvedBy != null &&
                    detail.alert.resolvedBy == ref.watch(sessionProvider)?.id,
              ),
            ],
            const SizedBox(height: AppLayout.blockGap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AlertScoreCard(
                        score: detail.alert.score,
                        suggestedType: detail.alert.suggestedType,
                      ),
                      const SizedBox(height: AppLayout.blockGap),
                      AlertReasonsPanel(reasons: detail.reasons),
                      const SizedBox(height: AppLayout.blockGap),
                      AlertTransactionsPanel(
                        transactions: detail.transactions,
                        onOpen: (transactionId) => onOpenTransaction(
                          detail.alert.customerId,
                          transactionId,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppLayout.blockGap),
                SizedBox(
                  width: AppLayout.detailAsideWidth,
                  child: AlertCustomerCard(
                    customerName: detail.alert.customerName,
                    onOpen: () => onOpenCustomer(
                      detail.alert.customerId,
                      detail.alert.generatedAt,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
