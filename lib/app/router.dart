import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/alerts/presentation/alerts_screen.dart';
import '../features/auth/presentation/controllers/session_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/statistics/presentation/statistics_screen.dart';
import '../features/transactions/presentation/transactions_screen.dart';
import 'shell/app_shell.dart';

/// Route paths. Routes are English, screens are Spanish.
abstract final class AppRoutes {
  static const login = '/login';
  static const transactions = '/transactions';
  static const alerts = '/alerts';
  static const statistics = '/statistics';

  static String statisticsTab(StatisticsTab tab) => '$statistics/${tab.name}';

  /// A-02 customer view; [transactionId] opens the N-02 panel on that transaction.
  static String customer(String customerId, {String? transactionId}) =>
      transactionId == null
      ? '/customers/$customerId'
      : '/customers/$customerId?tx=$transactionId';

  /// A-05 alert detail.
  static String alert(String alertId) => '$alerts/$alertId';
}

/// The app router. Its `redirect` is the only auth guard.
///
/// Kept alive (manual providers are not auto-disposed unless declared with
/// `.autoDispose`): the router lives as long as the app.
final routerProvider = Provider<GoRouter>(_buildRouter, name: 'routerProvider');

GoRouter _buildRouter(Ref ref) {
  final signedIn = ValueNotifier<bool>(false);
  ref
    ..listen(
      isSignedInProvider,
      (_, next) => signedIn.value = next,
      fireImmediately: true,
    )
    ..onDispose(signedIn.dispose);

  final router = GoRouter(
    initialLocation: AppRoutes.transactions,
    refreshListenable: signedIn,
    redirect: (context, state) {
      final onLogin = state.matchedLocation == AppRoutes.login;
      if (!signedIn.value) return onLogin ? null : AppRoutes.login;
      if (onLogin) return AppRoutes.transactions;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                builder: (context, state) => const TransactionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.alerts,
                builder: (context, state) => const AlertsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.statistics,
                redirect: (context, state) =>
                    state.fullPath == AppRoutes.statistics
                    ? AppRoutes.statisticsTab(StatisticsTab.fraud)
                    : null,
                routes: [
                  GoRoute(
                    path: ':tab',
                    builder: (context, state) => StatisticsScreen(
                      tab: StatisticsTab.fromPath(state.pathParameters['tab']),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
