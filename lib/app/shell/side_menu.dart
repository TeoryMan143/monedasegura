import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Side menu with the three destinations, in shell branch order.
class SideMenu extends StatelessWidget {
  const SideMenu({
    required this.selectedIndex,
    required this.onSelect,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const _destinations = ['Transacciones', 'Alertas IA', 'Estadísticas'];

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
          SizedBox(
            height: AppLayout.brandMarkSize,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Moneda Segura', style: AppText.h3),
            ),
          ),
          const SizedBox(height: AppSpace.xxl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
            child: Text(
              'ANÁLISIS',
              style: AppText.label.copyWith(color: AppColors.textTertiary),
            ),
          ),
          const SizedBox(height: AppSpace.sm),
          for (final (index, label) in _destinations.indexed)
            _NavItem(
              label: label,
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
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.xs),
      child: Material(
        color: selected ? AppColors.bgSelected : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: onTap,
          child: Container(
            height: AppLayout.navItemHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: (selected ? AppText.bodyMSemiBold : AppText.bodyM)
                  .copyWith(
                    color: selected
                        ? AppColors.textBrand
                        : AppColors.textPrimary,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
