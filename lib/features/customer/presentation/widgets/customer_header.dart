import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/customer_view.dart';
import '../controllers/customer_view_controller.dart';
import 'customer_range_button.dart';

/// Tabs of the customer report (HU-09) that A-02 opens.
enum CustomerReportTab { summary, accounts, timeline, map }

/// Opens the customer report on a tab. Null while the report route does not exist.
typedef OpenCustomerReport = void Function(CustomerReportTab tab);

/// Compact header of A-02 (HU-03): breadcrumbs, name, the range, the labeling progress,
/// pending AI alerts and the way to the customer report.
class CustomerHeader extends ConsumerWidget {
  const CustomerHeader({
    required this.customer,
    required this.onBack,
    required this.onOpenReport,
    super.key,
  });

  final CustomerView customer;
  final VoidCallback onBack;
  final OpenCustomerReport? onOpenReport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(customerLabelProgressProvider(customer.id));
    final total = progress.value?.total;
    final numbers = NumberFormat.decimalPattern('es');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Breadcrumbs(
                    items: [
                      Breadcrumb('Transacciones', onTap: onBack),
                      Breadcrumb(customer.fullName),
                    ],
                  ),
                  const SizedBox(height: AppSpace.xs),
                  Text(customer.fullName, style: AppText.h1),
                  const SizedBox(height: AppSpace.xs),
                  Text(
                    'Transacciones de todas sus cuentas en el rango seleccionado'
                    '${total == null ? '' : ' · ${numbers.format(total)} '
                              '${total == 1 ? 'transacción' : 'transacciones'}'}',
                    style: AppText.bodyS.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.lg),
            CustomerRangeButton(customerId: customer.id),
          ],
        ),
        const SizedBox(height: AppSpace.md),
        Wrap(
          spacing: AppSpace.lg,
          runSpacing: AppSpace.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            switch (progress) {
              AsyncValue(:final value?) => ProgressBar(
                done: value.labeled,
                total: value.total,
              ),
              AsyncValue(hasError: true) => Text(
                'No se pudo cargar el avance del etiquetado',
                style: AppText.bodyS.copyWith(color: AppColors.textTertiary),
              ),
              _ => const SkeletonBox(
                width: AppSizes.progressBar,
                height: AppSpace.x4l,
              ),
            },
            if (customer.pendingAlerts > 0)
              StatusBadge(
                label: customer.pendingAlerts == 1
                    ? '1 alerta IA pendiente'
                    : '${customer.pendingAlerts} alertas IA pendientes',
                tone: StatusTone.info,
                icon: AppIcons.ai,
              ),
            _ProfileButton(onOpenReport: onOpenReport),
          ],
        ),
      ],
    );
  }
}

/// «Ver perfil»: opens the report on «Resumen», whose tabs lead to the rest. Disabled,
/// with the reason, until the report exists.
class _ProfileButton extends StatelessWidget {
  const _ProfileButton({required this.onOpenReport});

  final OpenCustomerReport? onOpenReport;

  @override
  Widget build(BuildContext context) {
    final open = onOpenReport;
    final button = AppButton(
      label: 'Ver perfil',
      icon: AppIcons.user,
      variant: AppButtonVariant.secondary,
      size: AppButtonSize.s,
      onPressed: open == null ? null : () => open(CustomerReportTab.summary),
    );
    if (open != null) return button;
    return AppTooltip(
      message: 'Disponible cuando exista el reporte del cliente',
      child: button,
    );
  }
}
