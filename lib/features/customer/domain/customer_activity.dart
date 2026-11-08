import 'package:freezed_annotation/freezed_annotation.dart';

import 'customer_transaction.dart';
import 'security_event.dart';

part 'customer_activity.freezed.dart';

/// Everything the customer did in a date range, oldest first: the source of the timeline
/// and the map of the customer report (HU-10, HU-11).
@freezed
abstract class CustomerActivity with _$CustomerActivity {
  const factory CustomerActivity({
    required List<CustomerTransaction> transactions,
    required List<SecurityEvent> securityEvents,

    /// True when the range had more than [CustomerActivity.limit] transactions or events,
    /// so only the most recent ones came. The screen says so and suggests a shorter range.
    @Default(false) bool truncated,
  }) = _CustomerActivity;

  /// Most transactions, and most security events, read for one range.
  static const limit = 2000;
}
