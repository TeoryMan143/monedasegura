// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SecurityEvent _$SecurityEventFromJson(Map<String, dynamic> json) =>
    _SecurityEvent(
      id: json['id'] as String,
      type: SecurityEventType.fromDb(json['type'] as String),
      occurredAt: DateTime.parse(json['occurred_at'] as String),
      channel: _channelOrNull(json['channel_code'] as String?),
      succeeded: json['succeeded'] as bool,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      cityName: _nameOrNull(json['city'] as Map<String, dynamic>?),
    );
