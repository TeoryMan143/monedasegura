import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import 'widgets/alerts_inbox_table.dart';

/// A-04 · AI alert inbox (HU-06), first version: header and the table of pending alerts.
///
/// The table watches its own providers, so this screen stays stateless.
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppLayout.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Bandeja de alertas IA', style: AppText.h1),
          const SizedBox(height: AppSpace.xs),
          Text(
            'Alertas generadas por la IA, compartidas por todos los analistas, '
            'ordenadas por score.',
            style: AppText.bodyM.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppLayout.blockGap),
          const Expanded(
            child: AppPanel(
              expand: true,
              padding: EdgeInsets.zero,
              child: AlertsInboxTable(),
            ),
          ),
        ],
      ),
    );
  }
}
