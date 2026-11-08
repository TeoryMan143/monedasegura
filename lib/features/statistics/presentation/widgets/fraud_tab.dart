import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'fraud_grouped_panel.dart';
import 'fraud_kpi_row.dart';
import 'fraud_over_time_panel.dart';

/// A-07 · «Fraude» tab: three KPI cards, then the weekly line (2/3) next to the grouped
/// bars (1/3) (HU-13).
class FraudTab extends StatelessWidget {
  const FraudTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FraudKpiRow(),
        SizedBox(height: AppLayout.blockGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: FraudOverTimePanel()),
            SizedBox(width: AppLayout.blockGap),
            Expanded(child: FraudGroupedPanel()),
          ],
        ),
      ],
    );
  }
}
