import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/alert_status.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/alerts_query.dart';
import '../controllers/alerts_providers.dart';
import '../controllers/alerts_query_controller.dart';

/// Toolbar of the A-04 table (HU-06): «Filtros», one removable chip per active filter,
/// «Limpiar filtros» when there are several, and the count.
///
/// [onOpenFilters] opens the N-01 panel. The screen passes it, so this bar does not
/// depend on the panel.
class AlertsFilterBar extends ConsumerWidget {
  const AlertsFilterBar({required this.onOpenFilters, super.key});

  final VoidCallback onOpenFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(alertsQueryProvider);
    final notifier = ref.read(alertsQueryProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(AppSpace.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppButton(
            label: 'Filtros',
            icon: AppIcons.filter,
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.s,
            onPressed: onOpenFilters,
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (query.minScore case final minScore?)
                  AppFilterChip(
                    label: 'Score',
                    value: '≥ $minScore',
                    onRemove: () => notifier.setMinScore(null),
                  ),
                if (query.suggestedType case final type?)
                  AppFilterChip(
                    label: 'Tipo',
                    value: type.code,
                    onRemove: () => notifier.setSuggestedType(null),
                  ),
                // «Pendientes» is the default, so it only shows as a chip when changed.
                if (query.status != AlertStatus.pending)
                  AppFilterChip(
                    label: 'Estado',
                    value: query.status.label,
                    onRemove: () => notifier.setStatus(AlertStatus.pending),
                  ),
                if (_activeCount(query) > 1)
                  AppButton(
                    label: 'Limpiar filtros',
                    variant: AppButtonVariant.tertiary,
                    size: AppButtonSize.s,
                    onPressed: notifier.reset,
                  ),
                SizedBox(
                  height: AppSizes.controlS,
                  child: Align(widthFactor: 1, child: _CountText(query: query)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

int _activeCount(AlertsQuery query) => [
  query.minScore != null,
  query.suggestedType != null,
  query.status != AlertStatus.pending,
].where((active) => active).length;

/// «6 alertas pendientes», or what is happening meanwhile.
class _CountText extends ConsumerWidget {
  const _CountText({required this.query});

  final AlertsQuery query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(alertsPageProvider(query));

    final String text;
    if (page.hasError) {
      text = '';
    } else if (!page.hasValue) {
      text = 'Cargando alertas…';
    } else {
      final total = page.requireValue.total;
      final pending = query.status == AlertStatus.pending;
      text = switch (total) {
        0 => '0 resultados',
        1 => pending ? '1 alerta pendiente' : '1 alerta',
        _ =>
          '${NumberFormat.decimalPattern('es').format(total)} alertas'
              '${pending ? ' pendientes' : ''}',
      };
    }
    return Text(
      text,
      style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
    );
  }
}
