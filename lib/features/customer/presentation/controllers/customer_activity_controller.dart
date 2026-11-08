import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/customer_repository.dart';
import '../../domain/activity_analysis.dart';
import 'customer_range_controller.dart';
import 'customer_view_controller.dart';

/// From this many transactions the analysis runs in another isolate, so a long range
/// does not freeze the UI (ARCHITECTURAL_SPINE · Data flow, rule 6). Below it, the cost
/// of copying the data to the isolate is larger than the work.
const _isolateThreshold = 500;

/// The timeline and the map of a customer in the shared range of the report (HU-10,
/// HU-11): their transactions and security events, with the anomalies and the impossible
/// trips already worked out.
final customerActivityProvider = FutureProvider.autoDispose
    .family<ActivityAnalysis, String>(
      (ref, customerId) async {
        final range = ref.watch(customerDateRangeProvider(customerId));
        final repository = ref.watch(customerRepositoryProvider);
        final customer = await ref.watch(
          customerViewProvider(customerId).future,
        );
        final activity = await repository.fetchActivity(customer, range);
        final accounts = customer.accountIds;
        if (activity.transactions.length < _isolateThreshold) {
          return analyzeActivity(activity, customerAccounts: accounts);
        }
        return Isolate.run(
          () => analyzeActivity(activity, customerAccounts: accounts),
        );
      },
      retry: (_, _) => null,
      name: 'customerActivityProvider',
    );
