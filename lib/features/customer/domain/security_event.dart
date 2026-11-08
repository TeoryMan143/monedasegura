import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/domain/channel.dart';
import '../../../core/domain/security_event_type.dart';

part 'security_event.freezed.dart';
part 'security_event.g.dart';

/// A login, a password change, a new device… of the customer, read from
/// `security_events` for the timeline (HU-10).
@Freezed(toJson: false)
abstract class SecurityEvent with _$SecurityEvent {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory SecurityEvent({
    required String id,
    @JsonKey(fromJson: SecurityEventType.fromDb)
    required SecurityEventType type,
    required DateTime occurredAt,
    @JsonKey(name: 'channel_code', fromJson: _channelOrNull) Channel? channel,

    /// False for a failed attempt.
    required bool succeeded,
    double? latitude,
    double? longitude,

    /// Read from the embedded `city:cities(name)`.
    @JsonKey(name: 'city', fromJson: _nameOrNull) String? cityName,
  }) = _SecurityEvent;

  factory SecurityEvent.fromJson(Map<String, dynamic> json) =>
      _$SecurityEventFromJson(json);
}

Channel? _channelOrNull(String? value) =>
    value == null ? null : Channel.fromDb(value);

String? _nameOrNull(Map<String, dynamic>? city) => city?['name'] as String?;
