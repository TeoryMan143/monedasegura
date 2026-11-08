import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/kit.dart';
import 'widgets/alerts_filter_bar.dart';
import 'widgets/alerts_filter_panel.dart';
import 'widgets/alerts_inbox_table.dart';

/// A-04 · AI alert inbox (HU-06): header, filters (N-01), table and pagination.
///
/// [onOpen] opens a row in the alert detail. The router passes it, so this feature does
/// not depend on the app's routes. The table watches its own providers, so this screen
/// stays stateless.
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({required this.onOpen, super.key});

  final OpenAlert onOpen;

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
          Expanded(
            child: AppPanel(
              expand: true,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AlertsFilterBar(
                    onOpenFilters: () => showAlertsFilterPanel(context),
                  ),
                  Expanded(child: AlertsInboxTable(onOpen: onOpen)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
