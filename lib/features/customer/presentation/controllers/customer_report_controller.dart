import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/customer_report_repository.dart';
import '../../domain/customer_report.dart';
import 'customer_range_controller.dart';

/// A failed read shows «Reintentar» at once instead of a long skeleton.
Duration? _noAutoRetry(int retryCount, Object error) => null;

/// The customer of the report: personal data, segment and risk (HU-09).
final customerReportProvider = FutureProvider.autoDispose
    .family<CustomerProfile, String>(
      (ref, customerId) =>
          ref.watch(customerReportRepositoryProvider).fetchProfile(customerId),
      retry: _noAutoRetry,
      name: 'customerReportProvider',
    );

/// Accounts, cards and devices of the «Cuentas» tab (HU-09).
final customerProductsProvider = FutureProvider.autoDispose
    .family<CustomerProducts, String>(
      (ref, customerId) =>
          ref.watch(customerReportRepositoryProvider).fetchProducts(customerId),
      retry: _noAutoRetry,
      name: 'customerProductsProvider',
    );

/// Transactions and amount per month in the shared range, added up in the database.
final customerMonthlyActivityProvider = FutureProvider.autoDispose
    .family<List<MonthlyActivity>, String>(
      (ref, customerId) {
        final range = ref.watch(customerDateRangeProvider(customerId));
        return ref
            .watch(customerReportRepositoryProvider)
            .fetchMonthlyActivity(customerId, range);
      },
      retry: _noAutoRetry,
      name: 'customerMonthlyActivityProvider',
    );

/// Labels and alerts of the customer in the shared range of A-02 and the report.
final customerHistoryProvider = FutureProvider.autoDispose
    .family<CustomerHistory, String>(
      (ref, customerId) {
        final range = ref.watch(customerDateRangeProvider(customerId));
        return ref
            .watch(customerReportRepositoryProvider)
            .fetchHistory(customerId, range);
      },
      retry: _noAutoRetry,
      name: 'customerHistoryProvider',
    );
