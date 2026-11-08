import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/alert_status.dart';
import '../../../../core/domain/fraud_type.dart';
import '../../../../core/domain/score_range.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/alerts_query.dart';
import '../controllers/alerts_query_controller.dart';

/// The minimum scores the panel offers: where each risk range above «Bajo» starts.
final _minScoreOptions = [
  ScoreRange.medium,
  ScoreRange.high,
  ScoreRange.critical,
];

/// Opens N-01 over A-04.
Future<void> showAlertsFilterPanel(BuildContext context) => showSidePanel<void>(
  context: context,
  builder: (context) => const AlertsFilterPanel(),
);

/// N-01 · Filter panel of the alert inbox (HU-06): minimum score, suggested type and
/// status (resolved alerts included).
///
/// Edits a draft of the filters: nothing changes in the inbox until «Aplicar filtros».
/// «Limpiar todo» empties the draft. The filters run in the database.
class AlertsFilterPanel extends ConsumerStatefulWidget {
  const AlertsFilterPanel({super.key});

  @override
  ConsumerState<AlertsFilterPanel> createState() => _AlertsFilterPanelState();
}

class _AlertsFilterPanelState extends ConsumerState<AlertsFilterPanel> {
  late AlertsQuery _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(alertsQueryProvider);
  }

  void _update(AlertsQuery draft) => setState(() => _draft = draft);

  void _clear() => _update(
    _draft.copyWith(
      minScore: null,
      suggestedType: null,
      status: AlertStatus.pending,
    ),
  );

  void _apply() {
    ref.read(alertsQueryProvider.notifier)
      ..setMinScore(_draft.minScore)
      ..setSuggestedType(_draft.suggestedType)
      ..setStatus(_draft.status);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final active = [
      _draft.minScore != null,
      _draft.suggestedType != null,
      _draft.status != AlertStatus.pending,
    ].where((isActive) => isActive).length;

    return SidePanel(
      title: 'Filtros',
      headerTrailing: active == 0
          ? null
          : Text(
              active == 1 ? '1 activo' : '$active activos',
              style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
            ),
      onClose: () => Navigator.of(context).pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppDropdown<int?>(
            label: 'Score mínimo',
            value: _draft.minScore,
            hint: 'Cualquiera',
            items: [
              const AppDropdownItem(value: null, label: 'Cualquiera'),
              for (final range in _minScoreOptions)
                AppDropdownItem(
                  value: range.min,
                  label: '${range.label} o más (≥ ${range.min})',
                ),
            ],
            onChanged: (score) => _update(_draft.copyWith(minScore: score)),
          ),
          const SizedBox(height: AppSpace.lg),
          AppDropdown<FraudType?>(
            label: 'Tipo sugerido',
            value: _draft.suggestedType,
            hint: 'Todos',
            items: [
              const AppDropdownItem(value: null, label: 'Todos'),
              for (final type in FraudType.values)
                AppDropdownItem(
                  value: type,
                  label: '${type.code} · ${type.label}',
                ),
            ],
            onChanged: (type) => _update(_draft.copyWith(suggestedType: type)),
          ),
          const SizedBox(height: AppSpace.lg),
          AppDropdown<AlertStatus>(
            label: 'Estado',
            value: _draft.status,
            items: [
              for (final status in AlertStatus.values)
                AppDropdownItem(
                  value: status,
                  label: status.label,
                  icon: status.icon,
                ),
            ],
            onChanged: (status) => _update(_draft.copyWith(status: status)),
          ),
        ],
      ),
      footer: Row(
        children: [
          AppButton(
            label: 'Limpiar todo',
            variant: AppButtonVariant.secondary,
            onPressed: active == 0 ? null : _clear,
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: AppButton(
              label: 'Aplicar filtros',
              icon: AppIcons.check,
              expand: true,
              onPressed: _apply,
            ),
          ),
        ],
      ),
    );
  }
}
