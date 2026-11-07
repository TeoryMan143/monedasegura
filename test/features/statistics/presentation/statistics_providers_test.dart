import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monedasegura/features/statistics/data/statistics_repository.dart';
import 'package:monedasegura/features/statistics/domain/fraud_kpis.dart';
import 'package:monedasegura/features/statistics/domain/grouped_count.dart';
import 'package:monedasegura/features/statistics/domain/statistics_filter.dart';
import 'package:monedasegura/features/statistics/domain/stats_group_by.dart';
import 'package:monedasegura/features/statistics/presentation/controllers/statistics_providers.dart';

class _MockRepository extends Mock implements StatisticsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const StatisticsFilter());
    registerFallbackValue(StatsGroupBy.type);
  });

  group('statisticsFilterProvider', () {
    late ProviderContainer container;
    late StatisticsFilterNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
      notifier = container.read(statisticsFilterProvider.notifier);
    });

    StatisticsFilter filter() => container.read(statisticsFilterProvider);

    test('starts without filters', () {
      expect(filter().hasFilters, isFalse);
    });

    test('setRange changes the dates and keeps the country', () {
      notifier.setCountry('CO');
      notifier.setRange(DateTime(2026, 1, 1), DateTime(2026, 6, 30));

      expect(filter().fromDate, DateTime(2026, 1, 1));
      expect(filter().toDate, DateTime(2026, 6, 30));
      expect(filter().countryCode, 'CO');
    });

    test('setCountry changes the country and keeps the range', () {
      notifier.setRange(DateTime(2026, 1, 1), DateTime(2026, 6, 30));
      notifier.setCountry('MX');

      expect(filter().countryCode, 'MX');
      expect(filter().fromDate, DateTime(2026, 1, 1));
    });

    test('a null country means every country, and reset clears all', () {
      notifier.setCountry('CO');
      notifier.setCountry(null);
      expect(filter().countryCode, isNull);

      notifier.setRange(DateTime(2026, 1, 1), DateTime(2026, 6, 30));
      notifier.reset();
      expect(filter().hasFilters, isFalse);
    });
  });

  group('the statistics providers', () {
    late _MockRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _MockRepository();
      container = ProviderContainer(
        overrides: [statisticsRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
    });

    test('ask the repository for the filter they receive', () async {
      const kpis = FraudKpis(
        labeledCount: 1,
        totalCount: 4,
        fraudCount: 1,
        committedAmountCop: 100,
      );
      const filter = StatisticsFilter(countryCode: 'CO');
      when(() => repository.fraudKpis(any())).thenAnswer((_) async => kpis);

      final result = await container.read(fraudKpisProvider(filter).future);

      expect(result, kpis);
      verify(() => repository.fraudKpis(filter)).called(1);
    });

    test('a new filter asks for new data', () async {
      when(() => repository.fraudKpis(any())).thenAnswer(
        (_) async => const FraudKpis(
          labeledCount: 0,
          totalCount: 0,
          fraudCount: 0,
          committedAmountCop: 0,
        ),
      );
      const all = StatisticsFilter();
      const colombia = StatisticsFilter(countryCode: 'CO');
      container.listen(fraudKpisProvider(all), (_, _) {});
      container.listen(fraudKpisProvider(colombia), (_, _) {});

      await container.read(fraudKpisProvider(all).future);
      await container.read(fraudKpisProvider(colombia).future);

      verify(() => repository.fraudKpis(all)).called(1);
      verify(() => repository.fraudKpis(colombia)).called(1);
    });

    test('fraudGrouped passes the grouping to the repository', () async {
      const filter = StatisticsFilter();
      when(() => repository.fraudGrouped(any(), any()))
          .thenAnswer((_) async => const [GroupedCount(key: 'ATO', count: 3)]);

      final result = await container.read(
        fraudGroupedProvider((filter: filter, by: StatsGroupBy.type)).future,
      );

      expect(result.single.key, 'ATO');
      verify(() => repository.fraudGrouped(filter, StatsGroupBy.type))
          .called(1);
    });
  });
}
