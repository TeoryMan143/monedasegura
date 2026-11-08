import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/features/customer/data/fake_customer_repository.dart';
import 'package:monedasegura/features/customer/domain/activity_anomalies.dart';
import 'package:monedasegura/features/customer/domain/date_range.dart';
import 'package:monedasegura/features/customer/domain/impossible_travel.dart';
import 'package:monedasegura/features/customer/domain/map_point.dart';

void main() {
  final now = DateTime(2026, 3, 31, 12);
  final repository = FakeCustomerRepository(LocalWritesStore(), now: now);
  final range = DateRange.lastDays(30, until: now);

  test(
    'the offline activity has events and an impossible travel to show',
    () async {
      final customer = await repository.fetchCustomer(
        FakeCustomerRepository.customerId,
      );

      final activity = await repository.fetchActivity(customer, range);

      expect(activity.transactions, hasLength(8));
      expect(activity.securityEvents, isNotEmpty);
      final trip = detectImpossibleTravel(mapPointsOf(activity.transactions))
          .single;
      expect(trip.from.transaction.code, 'TX-48219');
      expect(trip.to.transaction.code, 'TX-48301');
      expect(
        buildTimeline(activity, customerAccounts: customer.accountIds),
        hasLength(
          activity.transactions.length + activity.securityEvents.length,
        ),
      );
    },
  );
}
