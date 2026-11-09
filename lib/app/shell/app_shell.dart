import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/realtime/connection_status.dart';
import '../../core/realtime/realtime_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/ui/kit.dart';
import '../../features/auth/presentation/widgets/user_menu.dart';
import '../../features/notifications/presentation/widgets/notification_bell.dart';
import '../../features/search/presentation/global_search_dialog.dart';
import '../../features/search/presentation/widgets/global_search_button.dart';
import '../router.dart';
import 'side_menu.dart';

/// C-04 · App shell: side menu + top bar + content (HU-16).
///
/// Holds the Ctrl/Cmd+K shortcut of the global search (HU-14) with `Shortcuts` /
/// `Actions`, as ARCHITECTURAL_SPINE.md · Desktop asks.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    void openCustomer(String customerId, {String? transactionId}) => context.go(
      AppRoutes.customer(customerId, transactionId: transactionId),
    );

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.keyK, control: true):
            _OpenSearchIntent(),
        SingleActivator(LogicalKeyboardKey.keyK, meta: true):
            _OpenSearchIntent(),
      },
      child: Actions(
        actions: {
          _OpenSearchIntent: CallbackAction<_OpenSearchIntent>(
            onInvoke: (_) {
              showGlobalSearch(context, onOpen: openCustomer);
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SideMenu(
                  selectedIndex: navigationShell.currentIndex,
                  onSelect: (index) => navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TopBar(onOpenCustomer: openCustomer),
                      Expanded(child: navigationShell),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OpenSearchIntent extends Intent {
  const _OpenSearchIntent();
}

/// Top bar: global search (HU-14), connection indicator and bell (HU-16), user menu
/// (HU-01, C-15).
class _TopBar extends StatelessWidget {
  const _TopBar({required this.onOpenCustomer});

  final OpenSearchResult onOpenCustomer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppLayout.topBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.xxl),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      // The search sits in the middle of the bar. If the right side grows (e.g.
      // «Reconectando…» on a narrow window) the toolbar moves it left instead of
      // letting the two overlap.
      child: NavigationToolbar(
        middleSpacing: AppSpace.lg,
        middle: GlobalSearchButton(onOpen: onOpenCustomer),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _ConnectionStatus(),
            const SizedBox(width: AppSpace.sm),
            NotificationBell(
              onOpenAlert: (alertId) => context.go(AppRoutes.alert(alertId)),
            ),
            const SizedBox(width: AppSpace.sm),
            const UserMenu(),
          ],
        ),
      ),
    );
  }
}

/// «Reconectando…» / «Sin conexión», only while the connection is failing.
class _ConnectionStatus extends ConsumerWidget {
  const _ConnectionStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectionStatusProvider);
    return ConnectionIndicator(
      status: status.hasValue
          ? status.requireValue
          : ConnectionStatus.connected,
    );
  }
}
