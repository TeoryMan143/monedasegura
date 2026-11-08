import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';

/// «Cliente» of A-05 (HU-07): who the alert is about, with «Ver cliente» to open them.
///
/// [onOpen] goes to the customer view. The screen passes it, so this widget does not
/// depend on the app's routes.
class AlertCustomerCard extends StatelessWidget {
  const AlertCustomerCard({
    required this.customerName,
    required this.onOpen,
    super.key,
  });

  final String customerName;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      title: 'Cliente',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customerName, style: AppText.bodyMSemiBold),
          const SizedBox(height: AppSpace.lg),
          AppButton(
            label: 'Ver cliente',
            icon: AppIcons.user,
            variant: AppButtonVariant.secondary,
            onPressed: onOpen,
          ),
        ],
      ),
    );
  }
}
