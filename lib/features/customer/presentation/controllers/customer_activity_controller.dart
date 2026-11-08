import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/customer_repository.dart';
import '../../domain/activity_analysis.dart';
import '../../domain/customer_activity.dart';
import 'customer_range_controller.dart';
import 'customer_view_controller.dart';

/// From this many transactions the analysis runs in another isolate, so a long range
/// does not freeze the UI (ARCHITECTURAL_SPINE · Data flow, rule 6). Below it, the cost
/// of copying the data to the isolate is larger than the work.
const _isolateThreshold = 500;

/// A failed read shows «Reintentar» at once instead of a long skeleton.
Duration? _noAutoRetry(int retryCount, Object error) => null;

/// The transactions and security events of a customer in the shared range of the
/// report: the one query behind the timeline and the map (HU-10, HU-11).
final customerActivityProvider = FutureProvider.autoDispose
    .family<CustomerActivity, String>(
      (ref, customerId) async {
        final range = ref.watch(customerDateRangeProvider(customerId));
        final repository = ref.watch(customerRepositoryProvider);
        final customer = await ref.watch(
          customerViewProvider(customerId).future,
        );
        return repository.fetchActivity(customer, range);
      },
      retry: _noAutoRetry,
      name: 'customerActivityProvider',
    );

/// C-11 · The timeline of a customer in the shared range (HU-10): transactions sized by
/// amount and security events on one axis, with spikes, unusual hours and bursts.
final customerTimelineProvider = FutureProvider.autoDispose
    .family<TimelineAnalysis, String>(
      (ref, customerId) async {
        final activity = await ref.watch(
          customerActivityProvider(customerId).future,
        );
        final customer = await ref.watch(
          customerViewProvider(customerId).future,
        );
        return _timelineOf(activity, customer.accountIds);
      },
      retry: _noAutoRetry,
      name: 'customerTimelineProvider',
    );

/// C-12 · The map of a customer in the shared range (HU-11): markers, the line between
/// consecutive transactions and the impossible trips.
final customerMapProvider = FutureProvider.autoDispose
    .family<MapAnalysis, String>(
      (ref, customerId) async {
        final activity = await ref.watch(
          customerActivityProvider(customerId).future,
        );
        final customer = await ref.watch(
          customerViewProvider(customerId).future,
        );
        return _mapOf(activity, customer.accountIds);
      },
      retry: _noAutoRetry,
      name: 'customerMapProvider',
    );

// Top-level so the closure sent to `Isolate.run` captures only the activity and the
// accounts, never `ref`.

Future<TimelineAnalysis> _timelineOf(
  CustomerActivity activity,
  Set<String> accounts,
) async {
  if (activity.transactions.length < _isolateThreshold) {
    return analyzeTimeline(activity, customerAccounts: accounts);
  }
  return Isolate.run(
    () => analyzeTimeline(activity, customerAccounts: accounts),
  );
}

Future<MapAnalysis> _mapOf(
  CustomerActivity activity,
  Set<String> accounts,
) async {
  if (activity.transactions.length < _isolateThreshold) {
    return analyzeMap(activity, customerAccounts: accounts);
  }
  return Isolate.run(() => analyzeMap(activity, customerAccounts: accounts));
}
