import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'pressable.dart';

/// One tab of [AppTabs].
@immutable
class AppTab {
  const AppTab({required this.label, this.count});

  final String label;

  /// Optional counter pill after the label.
  final int? count;
}

/// Pestañas (Figma Componentes `4:3`) · 42 px tabs in `bodyMMedium`; the active one has
/// brand text and a 2 px azul underline. A bottom border spans the whole row.
///
/// Controlled: the screen keeps the tab in the route (`/statistics/:tab`,
/// `/customers/:id/report/:tab`) and passes [selectedIndex].
class AppTabs extends StatelessWidget {
  const AppTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  final List<AppTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.tabs,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, tab) in tabs.indexed) ...[
            if (index > 0) const SizedBox(width: AppSpace.xxl),
            _TabItem(
              tab: tab,
              active: index == selectedIndex,
              onTap: () => onChanged(index),
            ),
          ],
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final AppTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final count = tab.count;
    return Pressable(
      onPressed: onTap,
      selected: active,
      semanticLabel: count == null ? tab.label : '${tab.label}, $count',
      borderRadius: AppRadius.sm,
      builder: (context, state) {
        final color = active
            ? AppColors.textBrand
            : state.hovered
            ? AppColors.textPrimary
            : AppColors.textSecondary;
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? AppColors.borderBrand : Colors.transparent,
                width: AppSizes.tabIndicator,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tab.label,
                style: AppText.bodyMMedium.copyWith(color: color),
              ),
              if (count != null) ...[
                const SizedBox(width: AppSpace.xs + AppSpace.xxs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.xs + AppSpace.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? StatusTone.brand.background
                        : AppColors.bgSurfaceSubtle,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    '$count',
                    style: AppText.bodySSemiBold.copyWith(
                      color: active
                          ? StatusTone.brand.text
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
