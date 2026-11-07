import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/alert_status.dart';
import '../../../../core/domain/fraud_type.dart';
import '../../domain/alerts_query.dart';

final alertsQueryProvider = NotifierProvider<AlertsQueryNotifier, AlertsQuery>(
  AlertsQueryNotifier.new,
  name: 'alertsQueryProvider',
);

class AlertsQueryNotifier extends Notifier<AlertsQuery> {
  @override
  AlertsQuery build() => const AlertsQuery();

  void setMinScore(int? minScore) =>
      state = state.copyWith(minScore: minScore, page: 1);

  void setSuggestedType(FraudType? type) =>
      state = state.copyWith(suggestedType: type, page: 1);

  void setStatus(AlertStatus status) =>
      state = state.copyWith(status: status, page: 1);

  void setPageSize(int pageSize) {
    assert(AlertsQuery.pageSizes.contains(pageSize), 'Unsupported $pageSize');
    state = state.copyWith(pageSize: pageSize, page: 1);
  }

  void setPage(int page) {
    if (page < 1) return;
    state = state.copyWith(page: page);
  }

  void reset() => state = const AlertsQuery();
}
