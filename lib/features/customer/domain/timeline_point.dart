import 'package:freezed_annotation/freezed_annotation.dart';

import 'customer_transaction.dart';
import 'security_event.dart';

part 'timeline_point.freezed.dart';

/// Why a transaction stands out on the timeline (HU-10).
enum ActivityAnomaly {
  /// Far above the customer's usual amount ([detectAmountSpikes]).
  amountSpike,

  /// At night or at an hour the customer does not use ([detectUnusualHours]).
  unusualHour,

  /// Part of many operations in a few minutes ([detectBursts]).
  burst,
}

/// One mark on the C-11 timeline (HU-10): a transaction, sized by amount and highlighted
/// by its [ActivityAnomaly]s, or a security event.
@freezed
sealed class TimelinePoint with _$TimelinePoint {
  const factory TimelinePoint.transaction(
    CustomerTransaction transaction, {
    @Default(<ActivityAnomaly>{}) Set<ActivityAnomaly> anomalies,
  }) = TransactionPoint;

  const factory TimelinePoint.securityEvent(SecurityEvent event) =
      SecurityEventPoint;

  const TimelinePoint._();

  /// Position on the time axis.
  DateTime get occurredAt => switch (this) {
    TransactionPoint(:final transaction) => transaction.occurredAt,
    SecurityEventPoint(:final event) => event.occurredAt,
  };
}
