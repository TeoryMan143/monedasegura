import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../global_search_dialog.dart';

/// C-04 top bar search field (about 440 px). It looks like a field but opens the C-05
/// dialog, as Ctrl/Cmd+K does.
class GlobalSearchButton extends StatelessWidget {
  const GlobalSearchButton({required this.onOpen, super.key});

  /// Opens the customer view of the chosen result.
  final OpenSearchResult onOpen;

  @override
  Widget build(BuildContext context) {
    final shortcut = defaultTargetPlatform == TargetPlatform.macOS
        ? '⌘ K'
        : 'Ctrl K';
    return Pressable(
      onPressed: () => showGlobalSearch(context, onOpen: onOpen),
      semanticLabel: 'Buscar clientes, cuentas o transacciones ($shortcut)',
      builder: (context, state) => Container(
        width: AppLayout.searchFieldWidth,
        height: AppSizes.controlM,
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
        decoration: BoxDecoration(
          color: AppColors.bgCanvas,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: state.hovered
                ? AppColors.borderStrong
                : AppColors.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            const AppIcon(
              AppIcons.search,
              size: AppIconSize.md,
              color: AppColors.iconSecondary,
            ),
            const SizedBox(width: AppSpace.sm),
            Expanded(
              child: Text(
                'Buscar clientes, cuentas o transacciones…',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyM.copyWith(color: AppColors.textTertiary),
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpace.xs + AppSpace.xxs,
                vertical: AppSpace.xxs,
              ),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Text(
                shortcut,
                style: AppText.bodySSemiBold.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
