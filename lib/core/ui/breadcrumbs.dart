import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'pressable.dart';

/// One step of [Breadcrumbs]. The last one is the current page and has no [onTap].
@immutable
class Breadcrumb {
  const Breadcrumb(this.label, {this.onTap});

  final String label;
  final VoidCallback? onTap;
}

/// Migas de pan (Figma Componentes `4:3`) · `bodyS` links in `textLink`, chevron
/// separators, the current page in `textPrimary` (detail pages: A-02, A-05, C-08).
///
/// ```dart
/// Breadcrumbs(items: [
///   Breadcrumb('Alertas IA', onTap: () => context.go(AppRoutes.alerts)),
///   const Breadcrumb('AL-1042'),
/// ])
/// ```
class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({required this.items, super.key});

  final List<Breadcrumb> items;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Ruta de navegación',
      container: true,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpace.xs,
        children: [
          for (final (index, item) in items.indexed) ...[
            if (index > 0)
              const AppIcon(
                AppIcons.chevronRight,
                size: AppIconSize.sm,
                color: AppColors.iconSecondary,
              ),
            if (index == items.length - 1 || item.onTap == null)
              Text(
                item.label,
                style: AppText.bodyS.copyWith(
                  color: index == items.length - 1
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              )
            else
              Pressable(
                onPressed: item.onTap,
                semanticLabel: item.label,
                borderRadius: AppRadius.sm,
                builder: (context, state) => Text(
                  item.label,
                  style: AppText.bodyS.copyWith(
                    color: AppColors.textLink,
                    decoration: state.hovered ? TextDecoration.underline : null,
                    decorationColor: AppColors.textLink,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
