import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/catalogs/catalog_providers.dart';
import '../../../../core/domain/fraud_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../../domain/resolve_alert_input.dart';

class ResolveTypeField extends ConsumerWidget {
  const ResolveTypeField({
    required this.action,
    required this.suggested,
    required this.selected,
    required this.onChanged,
    this.error,
    this.enabled = true,
    super.key,
  });

  final ResolveAlertAction action;
  final FraudType suggested;

  final FraudType? selected;
  final ValueChanged<FraudType> onChanged;
  final String? error;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (action == ResolveAlertAction.reject) return const SizedBox.shrink();
    final types = ref.watch(fraudTypesProvider).value ?? const [];
    final isConfirm = action == ResolveAlertAction.confirm;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel('Tipo de fraude', required: !isConfirm),
        const SizedBox(height: AppSpace.xs),
        if (isConfirm)
          _SuggestedType(
            chip: [
              for (final type in types)
                if (type.code == suggested.dbValue)
                  TaxonomyChip.fromCatalog(type, selected: true),
            ],
          )
        else
          Wrap(
            spacing: AppSpace.xs,
            runSpacing: AppSpace.xs,
            children: [
              for (final type in types)
                if (FraudType.fromDb(type.code) case final fraudType
                    when fraudType != suggested)
                  TaxonomyChip.fromCatalog(
                    type,
                    selected: fraudType == selected,
                    onTap: enabled ? () => onChanged(fraudType) : null,
                  ),
            ],
          ),
        if (error != null) FieldMessage(error!, isError: true),
      ],
    );
  }
}

class _SuggestedType extends StatelessWidget {
  const _SuggestedType({required this.chip});

  final List<Widget> chip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...chip,
        const SizedBox(width: AppSpace.md),
        const AppIcon(
          AppIcons.lock,
          size: AppIconSize.sm,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: AppSpace.xs),
        Flexible(
          child: Text(
            'Sugerido por la IA · no editable al confirmar',
            style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
