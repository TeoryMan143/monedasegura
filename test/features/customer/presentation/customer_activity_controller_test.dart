import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/local_writes/local_writes_store.dart';
import 'package:monedasegura/features/customer/data/customer_repository.dart';
import 'package:monedasegura/features/customer/data/fake_customer_repository.dart';
import 'package:monedasegura/features/customer/domain/customer_activity.dart';
import 'package:monedasegura/features/customer/domain/customer_view.dart';
import 'package:monedasegura/features/customer/domain/date_range.dart';
import 'package:monedasegura/features/customer/presentation/controllers/customer_activity_controller.dart';
import 'package:monedasegura/features/customer/presentation/controllers/customer_range_controller.dart';

const _id = FakeCustomerRepository.customerId;

/// The prototype data, remembering every range the activity was read for.
class _RecordingRepository extends FakeCustomerRepository {
  _RecordingRepository() : super(LocalWritesStore());

  final ranges = <DateRange>[];

  @override
  Future<CustomerActivity> fetchActivity(
    CustomerView customer,
    DateRange range,
  ) {
    ranges.add(range);
    return super.fetchActivity(customer, range);
  }
}

void main() {
  late ProviderContainer container;
  late _RecordingRepository repository;

  setUp(() {
    repository = _RecordingRepository();
    container = ProviderContainer(
      overrides: [customerRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  /// Keeps [provider] alive, as the tab on screen would, and reads its value.
  Future<T> read<T>(ProviderListenable<Future<T>> provider) {
    final subscription = container.listen(provider, (_, _) {});
    addTearDown(subscription.close);
    return subscription.read();
  }

  test('the timeline and the map share one read of the range', () async {
    final timeline = await read(customerTimelineProvider(_id).future);
    final map = await read(customerMapProvider(_id).future);

    expect(timeline.isEmpty, isFalse);
    expect(map.isEmpty, isFalse);
    expect(map.trips, isNotEmpty);
    expect(repository.ranges, hasLength(1));
  });

  test('a new range reloads both tabs', () async {
    await read(customerTimelineProvider(_id).future);
    await read(customerMapProvider(_id).future);

    final empty = DateRange(from: DateTime(2020), to: DateTime(2020, 1, 15));
    container.read(customerDateRangeProvider(_id).notifier).setRange(empty);

    final timeline = await read(customerTimelineProvider(_id).future);
    final map = await read(customerMapProvider(_id).future);

    expect(repository.ranges.last, empty);
    expect(timeline.isEmpty, isTrue);
    expect(map.isEmpty, isTrue);
  });
}
