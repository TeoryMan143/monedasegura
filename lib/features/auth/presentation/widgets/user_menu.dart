import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';
import '../controllers/session_controller.dart';

/// C-15 · user menu of the top bar: avatar + name + «Analista» + chevron, opening a menu
/// with the analyst's name and email and «Cerrar sesión» (HU-01).
///
/// Signing out clears the session; the router returns to the login by itself.
class UserMenu extends ConsumerWidget {
  const UserMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyst = ref.watch(sessionProvider);
    final name = analyst?.fullName ?? 'Analista';

    return AppMenu(
      minWidth: AppSizes.menuMinWidth + AppSpace.x4l,
      entries: [
        AppMenuHeader(
          Row(
            children: [
              AppAvatar(name: name),
              const SizedBox(width: AppSpace.sm),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppText.bodyMSemiBold),
                    if (analyst != null)
                      Text(
                        analyst.email,
                        style: AppText.bodyS.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const AppMenuDivider(),
        AppMenuAction(
          label: 'Cerrar sesión',
          icon: AppIcons.logout,
          onSelected: () => ref.read(sessionProvider.notifier).signOut(),
        ),
      ],
      builder: (context, controller) => Pressable(
        onPressed: controller.toggle,
        semanticLabel: 'Menú de usuario, $name',
        builder: (context, state) => AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: AppSizes.controlM,
          padding: const EdgeInsets.only(left: AppSpace.xs, right: AppSpace.sm),
          decoration: BoxDecoration(
            color: state.hovered || controller.isOpen
                ? AppColors.bgRowHover
                : null,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppAvatar(name: name),
              const SizedBox(width: AppSpace.sm),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppText.bodyMMedium),
                  Text(
                    'Analista',
                    style: AppText.bodyS.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpace.sm),
              AppIcon(
                controller.isOpen ? AppIcons.chevronUp : AppIcons.chevronDown,
                size: AppIconSize.md,
                color: AppColors.iconSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
