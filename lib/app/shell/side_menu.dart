import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/ui/kit.dart';

/// Side menu with the three destinations, in shell branch order (DESIGN.md · Layout).
class SideMenu extends StatelessWidget {
  const SideMenu({
    required this.selectedIndex,
    required this.onSelect,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const _destinations = [
    ('Transacciones', AppIcons.list),
    ('Alertas IA', AppIcons.ai),
    ('Estadísticas', AppIcons.statistics),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppLayout.sideMenuWidth,
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(right: BorderSide(color: AppColors.borderSubtle)),
      ),
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(alignment: Alignment.centerLeft, child: BrandMark()),
          const SizedBox(height: AppSpace.xxl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
            child: Text(
              'ANÁLISIS',
              style: AppText.label.copyWith(color: AppColors.textTertiary),
            ),
          ),
          const SizedBox(height: AppSpace.sm),
          for (final (index, (label, icon)) in _destinations.indexed)
            _NavItem(
              label: label,
              icon: icon,
              selected: index == selectedIndex,
              onTap: () => onSelect(index),
            ),
          const Spacer(),
          Text(
            'Proyecto académico · Universidad Icesi',
            style: AppText.bodyS.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final AppIcons icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.xs),
      child: Pressable(
        onPressed: onTap,
        selected: selected,
        semanticLabel: label,
        builder: (context, state) => AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: AppLayout.navItemHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.bgSelected
                : state.hovered
                ? AppColors.bgRowHover
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              AppIcon(
                icon,
                color: selected ? AppColors.iconBrand : AppColors.iconPrimary,
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: (selected ? AppText.bodyMSemiBold : AppText.bodyM)
                      .copyWith(
                        color: selected
                            ? AppColors.textBrand
                            : AppColors.textPrimary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
