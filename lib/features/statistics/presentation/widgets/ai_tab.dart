import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'ai_kpi_row.dart';
import 'ai_precision_panel.dart';

/// A-08 · «Desempeño de la IA» tab: three resolution cards and the precision by type
/// (HU-13).
class AiTab extends StatelessWidget {
  const AiTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AiKpiRow(),
        SizedBox(height: AppLayout.blockGap),
        AiPrecisionPanel(),
      ],
    );
  }
}
