import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import 'app_button.dart';
import 'app_icon.dart';

/// E-02 · Estados de pantalla: empty and «no results» (DESIGN.md · ScreenState).
///
/// Centred icon tile, `h3` title, `bodyL` explanation and an optional next action.
/// [EmptyState.noResults] is the variant for filters that match nothing and offers
/// «Limpiar filtros».
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    this.message,
    this.icon = AppIcons.inbox,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  /// Filters or a search returned nothing.
  const EmptyState.noResults({
    VoidCallback? onClearFilters,
    String title = 'Sin resultados',
    String message =
        'Ningún registro coincide con los filtros. Prueba con otros criterios.',
    Key? key,
  }) : this(
         title: title,
         message: message,
         icon: AppIcons.search,
         actionLabel: onClearFilters == null ? null : 'Limpiar filtros',
         onAction: onClearFilters,
         key: key,
       );

  final String title;
  final String? message;
  final AppIcons icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.dialogM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSpace.x5l,
              height: AppSpace.x5l,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.bgBrandSubtle,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: AppIcon(icon, color: AppColors.iconBrand),
            ),
            const SizedBox(height: AppSpace.lg),
            Text(title, style: AppText.h3, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: AppSpace.xs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppText.bodyL.copyWith(color: AppColors.textSecondary),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpace.lg),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: AppButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
