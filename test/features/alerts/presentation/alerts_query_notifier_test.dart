import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monedasegura/core/domain/alert_status.dart';
import 'package:monedasegura/core/domain/fraud_type.dart';
import 'package:monedasegura/features/alerts/domain/alerts_query.dart';
import 'package:monedasegura/features/alerts/presentation/controllers/alerts_query_controller.dart';

void main() {
  late ProviderContainer container;
  late AlertsQueryNotifier notifier;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
    notifier = container.read(alertsQueryProvider.notifier);
  });

  AlertsQuery query() => container.read(alertsQueryProvider);

  test('starts on the pending inbox, page 1 of 25', () {
    expect(query().status, AlertStatus.pending);
    expect(query().page, 1);
    expect(query().pageSize, 25);
    expect(query().hasFilters, isFalse);
  });

  test('setPage moves only the page', () {
    notifier.setMinScore(80);
    notifier.setPage(3);

    expect(query().page, 3);
    expect(query().minScore, 80);
  });

  test('every filter and the page size go back to page 1', () {
    void fromPage3(void Function() change) {
      notifier.setPage(3);
      change();
      expect(query().page, 1);
    }

    fromPage3(() => notifier.setMinScore(70));
    fromPage3(() => notifier.setSuggestedType(FraudType.simSwap));
    fromPage3(() => notifier.setStatus(AlertStatus.confirmed));
    fromPage3(() => notifier.setPageSize(50));
  });

  test('a filter can be cleared with null', () {
    notifier.setMinScore(70);
    notifier.setSuggestedType(FraudType.phishing);
    expect(query().hasFilters, isTrue);

    notifier.setMinScore(null);
    notifier.setSuggestedType(null);

    expect(query().minScore, isNull);
    expect(query().suggestedType, isNull);
    expect(query().hasFilters, isFalse);
  });

  test('ignores a page below 1 and reset restores the default inbox', () {
    notifier.setPage(0);
    expect(query().page, 1);

    notifier.setStatus(AlertStatus.rejected);
    notifier.setPageSize(100);
    notifier.reset();

    expect(query(), const AlertsQuery());
  });

  test('from and to are the range of the page', () {
    notifier.setPageSize(50);
    notifier.setPage(3);

    expect(query().from, 100);
    expect(query().to, 149);
  });
}
