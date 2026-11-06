import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'pressable.dart';

/// Chip de filtro (Figma Componentes `4:3`) · an active filter: «Etiqueta: **Todas**» + ×.
///
/// 26 px pill in the `brand` tone, shown next to the «Filtros» button of a table. Named
/// `AppFilterChip` so it does not clash with Material's `FilterChip`.
class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    required this.label,
    required this.value,
    required this.onRemove,
    super.key,
  });

  /// Filter name, e.g. «Etiqueta».
  final String label;

  /// Active value, in bold, e.g. «Sin etiquetar».
  final String value;

  /// Removes this filter. Null hides the ×.
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    const tone = StatusTone.brand;
    return Container(
      height: AppSizes.chip,
      padding: EdgeInsets.only(
        left: AppSpace.md,
        right: onRemove == null ? AppSpace.md : AppSpace.xs,
      ),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              text: '$label: ',
              children: [
                TextSpan(
                  text: value,
                  style: AppText.bodySSemiBold.copyWith(color: tone.text),
                ),
              ],
            ),
            style: AppText.bodyS.copyWith(color: tone.text),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: AppSpace.xxs),
            Pressable(
              onPressed: onRemove,
              tooltip: 'Quitar filtro',
              semanticLabel: 'Quitar filtro $label: $value',
              borderRadius: AppRadius.full,
              builder: (context, state) => Container(
                width: AppIconSize.md,
                height: AppIconSize.md,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: state.hovered ? AppColors.azul100 : null,
                  shape: BoxShape.circle,
                ),
                child: AppIcon(
                  AppIcons.close,
                  size: AppIconSize.xs,
                  color: tone.text,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
