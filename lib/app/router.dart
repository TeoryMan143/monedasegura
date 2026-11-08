import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/alerts/presentation/alert_detail_screen.dart';
import '../features/alerts/presentation/alerts_screen.dart';
import '../features/auth/presentation/controllers/session_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/customer/presentation/customer_report_screen.dart';
import '../features/customer/presentation/customer_screen.dart';
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

  /// Route pattern of [customer], in the Transacciones branch.
  static const customerPattern = '/customers/:customerId';

  /// A-02 customer view; [transactionId] opens the N-02 panel on that transaction, and
  /// [at] makes the date range show that day (an alert's day).
  static String customer(
    String customerId, {
    String? transactionId,
    DateTime? at,
  }) {
    final query = [
      if (transactionId != null) 'tx=$transactionId',
      if (at != null) 'at=${_day(at)}',
    ];
    return query.isEmpty
        ? '/customers/$customerId'
        : '/customers/$customerId?${query.join('&')}';
  }

  static String _day(DateTime at) {
    final local = at.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)}';
  }

  /// C-08…C-12 customer report on [tab] (HU-09), a child of the customer view.
  static String customerReport(String customerId, CustomerReportTab tab) =>
      '/customers/$customerId/report/${tab.name}';

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
                builder: (context, state) => TransactionsScreen(
                  // push, not go: the list stays below the customer view, so going
                  // back keeps its filters and page.
                  onOpen: (customerId, transactionId) => context.push(
                    AppRoutes.customer(
                      customerId,
                      transactionId: '$transactionId',
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: AppRoutes.customerPattern,
                builder: (context, state) => CustomerScreen(
                  customerId: state.pathParameters['customerId']!,
                  transactionId: state.uri.queryParameters['tx'],
                  at: state.uri.queryParameters['at'],
                  // Back to the list it came from, keeping its filters and page.
                  onBack: () => context.canPop()
                      ? context.pop()
                      : context.go(AppRoutes.transactions),
                  // «Ver perfil» → summary, «Reportes» → timeline. push: A-02 stays
                  // below with its range and page.
                  onOpenReport: (tab) => context.push(
                    AppRoutes.customerReport(
                      state.pathParameters['customerId']!,
                      tab,
                    ),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'report/:tab',
                    builder: (context, state) {
                      final customerId = state.pathParameters['customerId']!;
                      return CustomerReportScreen(
                        customerId: customerId,
                        tab:
                            CustomerReportTab.values
                                .asNameMap()[state.pathParameters['tab']] ??
                            CustomerReportTab.summary,
                        // replace: changing tabs does not stack history.
                        onTab: (tab) => context.replace(
                          AppRoutes.customerReport(customerId, tab),
                        ),
                        onBack: () => context.canPop()
                            ? context.pop()
                            : context.go(AppRoutes.customer(customerId)),
                        onOpenList: () => context.go(AppRoutes.transactions),
                        onOpenTransaction: (transactionId) => context.push(
                          AppRoutes.customer(
                            customerId,
                            transactionId: '$transactionId',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.alerts,
                builder: (context, state) => AlertsScreen(
                  // push, not go: the inbox stays below the detail, so going back
                  // keeps its filters and page.
                  onOpen: (alertId) => context.push(AppRoutes.alert(alertId)),
                ),
                routes: [
                  GoRoute(
                    path: ':alertId',
                    builder: (context, state) => AlertDetailScreen(
                      alertId: state.pathParameters['alertId']!,
                      // Back to the inbox it came from, keeping its filters and page.
                      onBack: () => context.canPop()
                          ? context.pop()
                          : context.go(AppRoutes.alerts),
                      // TODO(HU-08): onResolve opens the resolve window (A-06). Until then
                      // «Resolver alerta» stays disabled.
                      // The range ends on the alert's day, so its activity shows.
                      onOpenCustomer: (customerId, at) =>
                          context.push(AppRoutes.customer(customerId, at: at)),
                      onOpenTransaction: (customerId, transactionId) =>
                          context.push(
                            AppRoutes.customer(
                              customerId,
                              transactionId: '$transactionId',
                            ),
                          ),
                    ),
                  ),
                ],
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
