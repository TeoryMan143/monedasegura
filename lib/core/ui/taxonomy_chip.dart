import 'package:flutter/widgets.dart';

import '../domain/catalog_models.dart';
import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'pressable.dart';

/// Chip taxonomía (Figma Componentes `4:3`) · a fraud type: colour square + bold code +
/// name, e.g. «■ **ATO** · Robo de cuenta».
///
/// 24 px, radius `sm`, `borderDefault`. [color] comes from `fraud_types.color` and is used
/// only for the square. Variants: removable ([onRemove] shows ×) and selectable
/// ([onTap] + [selected], brand border and `bgSelected`) for picking types in a form.
class TaxonomyChip extends StatelessWidget {
  const TaxonomyChip({
    required this.code,
    required this.name,
    required this.color,
    this.selected = false,
    this.onTap,
    this.onRemove,
    super.key,
  });

  /// The chip of a `fraud_types` row, from `fraudTypesProvider`.
  TaxonomyChip.fromCatalog(
    CatalogFraudType type, {
    this.selected = false,
    this.onTap,
    this.onRemove,
    super.key,
  }) : code = type.code,
       name = type.name,
       color = type.color;

  /// Taxonomy code: ATO, PHI, CLO, MUL, LAV, SIN, SIM, CNR.
  final String code;
  final String name;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    Widget chip(PressableState? state) => Container(
      height: AppSizes.taxonomyChip,
      padding: EdgeInsets.only(
        left: AppSpace.sm,
        right: onRemove == null ? AppSpace.sm : AppSpace.xs,
      ),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.bgSelected
            : (state?.hovered ?? false)
            ? AppColors.bgRowHover
            : AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: selected ? AppColors.borderBrand : AppColors.borderDefault,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSpace.sm,
            height: AppSpace.sm,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSpace.xxs),
            ),
          ),
          const SizedBox(width: AppSpace.xs + AppSpace.xxs),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: code, style: AppText.bodySSemiBold),
                  TextSpan(
                    text: ' · $name',
                    style: AppText.bodyS.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (selected && onRemove == null) ...[
            const SizedBox(width: AppSpace.xs),
            const AppIcon(
              AppIcons.check,
              size: AppIconSize.xs,
              color: AppColors.iconBrand,
            ),
          ],
          if (onRemove != null) ...[
            const SizedBox(width: AppSpace.xxs),
            Pressable(
              onPressed: onRemove,
              tooltip: 'Quitar $code',
              semanticLabel: 'Quitar $code · $name',
              borderRadius: AppRadius.sm,
              builder: (context, s) => SizedBox.square(
                dimension: AppIconSize.sm,
                child: Center(
                  child: AppIcon(
                    AppIcons.close,
                    size: AppIconSize.xs,
                    color: s.hovered
                        ? AppColors.iconPrimary
                        : AppColors.iconSecondary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    final onTap = this.onTap;
    if (onTap == null) {
      return Semantics(label: '$code · $name', child: chip(null));
    }
    return Pressable(
      onPressed: onTap,
      selected: selected,
      semanticLabel: '$code · $name',
      borderRadius: AppRadius.sm,
      builder: (context, state) => chip(state),
    );
  }
}
