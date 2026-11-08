// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'security_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SecurityEvent {

 String get id;@JsonKey(fromJson: SecurityEventType.fromDb) SecurityEventType get type; DateTime get occurredAt;@JsonKey(name: 'channel_code', fromJson: _channelOrNull) Channel? get channel;/// False for a failed attempt.
 bool get succeeded; double? get latitude; double? get longitude;/// Read from the embedded `city:cities(name)`.
@JsonKey(name: 'city', fromJson: _nameOrNull) String? get cityName;
/// Create a copy of SecurityEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecurityEventCopyWith<SecurityEvent> get copyWith => _$SecurityEventCopyWithImpl<SecurityEvent>(this as SecurityEvent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SecurityEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecurityEvent&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.occurredAt, _this.occurredAt) || other.occurredAt == _this.occurredAt)&&(identical(other.channel, _this.channel) || other.channel == _this.channel)&&(identical(other.succeeded, _this.succeeded) || other.succeeded == _this.succeeded)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.cityName, _this.cityName) || other.cityName == _this.cityName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SecurityEvent;
  return Object.hash(runtimeType,_this.id,_this.type,_this.occurredAt,_this.channel,_this.succeeded,_this.latitude,_this.longitude,_this.cityName);
}

@override
String toString() {
  final _this = this as SecurityEvent;
  return 'SecurityEvent(id: ${_this.id}, type: ${_this.type}, occurredAt: ${_this.occurredAt}, channel: ${_this.channel}, succeeded: ${_this.succeeded}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, cityName: ${_this.cityName})';
}


}

/// @nodoc
abstract mixin class $SecurityEventCopyWith<$Res>  {
  factory $SecurityEventCopyWith(SecurityEvent value, $Res Function(SecurityEvent) _then) = _$SecurityEventCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(fromJson: SecurityEventType.fromDb) SecurityEventType type, DateTime occurredAt,@JsonKey(name: 'channel_code', fromJson: _channelOrNull) Channel? channel, bool succeeded, double? latitude, double? longitude,@JsonKey(name: 'city', fromJson: _nameOrNull) String? cityName
});




}
/// @nodoc
class _$SecurityEventCopyWithImpl<$Res>
    implements $SecurityEventCopyWith<$Res> {
  _$SecurityEventCopyWithImpl(this._self, this._then);

  final SecurityEvent _self;
  final $Res Function(SecurityEvent) _then;

/// Create a copy of SecurityEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? occurredAt = null,Object? channel = freezed,Object? succeeded = null,Object? latitude = freezed,Object? longitude = freezed,Object? cityName = freezed,}) {
  return _then(SecurityEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SecurityEventType,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel?,succeeded: null == succeeded ? _self.succeeded : succeeded // ignore: cast_nullable_to_non_nullable
as bool,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SecurityEvent].
extension SecurityEventPatterns on SecurityEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecurityEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecurityEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecurityEvent value)  $default,){
final _that = this;
switch (_that) {
case _SecurityEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecurityEvent value)?  $default,){
final _that = this;
switch (_that) {
case _SecurityEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: SecurityEventType.fromDb)  SecurityEventType type,  DateTime occurredAt, @JsonKey(name: 'channel_code', fromJson: _channelOrNull)  Channel? channel,  bool succeeded,  double? latitude,  double? longitude, @JsonKey(name: 'city', fromJson: _nameOrNull)  String? cityName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SecurityEvent() when $default != null:
return $default(_that.id,_that.type,_that.occurredAt,_that.channel,_that.succeeded,_that.latitude,_that.longitude,_that.cityName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: SecurityEventType.fromDb)  SecurityEventType type,  DateTime occurredAt, @JsonKey(name: 'channel_code', fromJson: _channelOrNull)  Channel? channel,  bool succeeded,  double? latitude,  double? longitude, @JsonKey(name: 'city', fromJson: _nameOrNull)  String? cityName)  $default,) {final _that = this;
switch (_that) {
case _SecurityEvent():
return $default(_that.id,_that.type,_that.occurredAt,_that.channel,_that.succeeded,_that.latitude,_that.longitude,_that.cityName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(fromJson: SecurityEventType.fromDb)  SecurityEventType type,  DateTime occurredAt, @JsonKey(name: 'channel_code', fromJson: _channelOrNull)  Channel? channel,  bool succeeded,  double? latitude,  double? longitude, @JsonKey(name: 'city', fromJson: _nameOrNull)  String? cityName)?  $default,) {final _that = this;
switch (_that) {
case _SecurityEvent() when $default != null:
return $default(_that.id,_that.type,_that.occurredAt,_that.channel,_that.succeeded,_that.latitude,_that.longitude,_that.cityName);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _SecurityEvent implements SecurityEvent {
  const _SecurityEvent({required this.id, @JsonKey(fromJson: SecurityEventType.fromDb) required this.type, required this.occurredAt, @JsonKey(name: 'channel_code', fromJson: _channelOrNull) this.channel, required this.succeeded, this.latitude, this.longitude, @JsonKey(name: 'city', fromJson: _nameOrNull) this.cityName});
  factory _SecurityEvent.fromJson(Map<String, dynamic> json) => _$SecurityEventFromJson(json);

@override final  String id;
@override@JsonKey(fromJson: SecurityEventType.fromDb) final  SecurityEventType type;
@override final  DateTime occurredAt;
@override@JsonKey(name: 'channel_code', fromJson: _channelOrNull) final  Channel? channel;
/// False for a failed attempt.
@override final  bool succeeded;
@override final  double? latitude;
@override final  double? longitude;
/// Read from the embedded `city:cities(name)`.
@override@JsonKey(name: 'city', fromJson: _nameOrNull) final  String? cityName;

/// Create a copy of SecurityEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecurityEventCopyWith<_SecurityEvent> get copyWith => __$SecurityEventCopyWithImpl<_SecurityEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecurityEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.succeeded, succeeded) || other.succeeded == succeeded)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.cityName, cityName) || other.cityName == cityName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,occurredAt,channel,succeeded,latitude,longitude,cityName);
}

@override
String toString() {
    return 'SecurityEvent(id: $id, type: $type, occurredAt: $occurredAt, channel: $channel, succeeded: $succeeded, latitude: $latitude, longitude: $longitude, cityName: $cityName)';
}


}

/// @nodoc
abstract mixin class _$SecurityEventCopyWith<$Res> implements $SecurityEventCopyWith<$Res> {
  factory _$SecurityEventCopyWith(_SecurityEvent value, $Res Function(_SecurityEvent) _then) = __$SecurityEventCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(fromJson: SecurityEventType.fromDb) SecurityEventType type, DateTime occurredAt,@JsonKey(name: 'channel_code', fromJson: _channelOrNull) Channel? channel, bool succeeded, double? latitude, double? longitude,@JsonKey(name: 'city', fromJson: _nameOrNull) String? cityName
});




}
/// @nodoc
class __$SecurityEventCopyWithImpl<$Res>
    implements _$SecurityEventCopyWith<$Res> {
  __$SecurityEventCopyWithImpl(this._self, this._then);

  final _SecurityEvent _self;
  final $Res Function(_SecurityEvent) _then;

/// Create a copy of SecurityEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? occurredAt = null,Object? channel = freezed,Object? succeeded = null,Object? latitude = freezed,Object? longitude = freezed,Object? cityName = freezed,}) {
  return _then(_SecurityEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SecurityEventType,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel?,succeeded: null == succeeded ? _self.succeeded : succeeded // ignore: cast_nullable_to_non_nullable
as bool,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
