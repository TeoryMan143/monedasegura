import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/alert_status.dart';
import '../../../core/domain/fraud_type.dart';

part 'alerts_query.freezed.dart';

@freezed
abstract class AlertsQuery with _$AlertsQuery {
  const factory AlertsQuery({

    int? minScore,

    FraudType? suggestedType,

    @Default(AlertStatus.pending) AlertStatus status,

    @Default(1) int page,
    @Default(25) int pageSize,
  }) = _AlertsQuery;

  const AlertsQuery._();

  static const pageSizes = [25, 50, 100];

  int get from => (page - 1) * pageSize;

  int get to => from + pageSize - 1;

  bool get hasFilters =>
      minScore != null ||
      suggestedType != null ||
      status != AlertStatus.pending;
}
