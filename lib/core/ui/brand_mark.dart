import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';

/// Moneda Segura product mark: the Escudo icon on a 32×32 square + the wordmark
/// (DESIGN.md · Brand).
///
/// On white use the default; on Azul Icesi (login hero) use [BrandMark.onBrand], which turns
/// the square white, the icon azul and the wordmark white.
class BrandMark extends StatelessWidget {
  const BrandMark({this.showWordmark = true, super.key}) : onBrand = false;

  const BrandMark.onBrand({this.showWordmark = true, super.key})
    : onBrand = true;

  /// Whether the "Moneda Segura" text follows the square.
  final bool showWordmark;
  final bool onBrand;

  @override
  Widget build(BuildContext context) {
    final square = Container(
      width: AppLayout.brandMarkSize,
      height: AppLayout.brandMarkSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: onBrand ? AppColors.bgSurface : AppColors.bgBrand,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: AppIcon(
        AppIcons.shield,
        size: AppIconSize.md,
        color: onBrand ? AppColors.iconBrand : AppColors.iconOnBrand,
      ),
    );
    if (!showWordmark) {
      return Semantics(label: 'Moneda Segura', child: square);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        square,
        const SizedBox(width: AppSpace.sm),
        Flexible(
          child: Text(
            'Moneda Segura',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.h3.copyWith(
              color: onBrand ? AppColors.textOnBrand : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
