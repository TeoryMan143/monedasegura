// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_series_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeSeriesPoint {

 DateTime get periodStart; int get fraudCount;
/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeSeriesPointCopyWith<TimeSeriesPoint> get copyWith => _$TimeSeriesPointCopyWithImpl<TimeSeriesPoint>(this as TimeSeriesPoint, _$identity);

  /// Serializes this TimeSeriesPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TimeSeriesPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeSeriesPoint&&(identical(other.periodStart, _this.periodStart) || other.periodStart == _this.periodStart)&&(identical(other.fraudCount, _this.fraudCount) || other.fraudCount == _this.fraudCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TimeSeriesPoint;
  return Object.hash(runtimeType,_this.periodStart,_this.fraudCount);
}

@override
String toString() {
  final _this = this as TimeSeriesPoint;
  return 'TimeSeriesPoint(periodStart: ${_this.periodStart}, fraudCount: ${_this.fraudCount})';
}


}

/// @nodoc
abstract mixin class $TimeSeriesPointCopyWith<$Res>  {
  factory $TimeSeriesPointCopyWith(TimeSeriesPoint value, $Res Function(TimeSeriesPoint) _then) = _$TimeSeriesPointCopyWithImpl;
@useResult
$Res call({
 DateTime periodStart, int fraudCount
});




}
/// @nodoc
class _$TimeSeriesPointCopyWithImpl<$Res>
    implements $TimeSeriesPointCopyWith<$Res> {
  _$TimeSeriesPointCopyWithImpl(this._self, this._then);

  final TimeSeriesPoint _self;
  final $Res Function(TimeSeriesPoint) _then;

/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? periodStart = null,Object? fraudCount = null,}) {
  return _then(TimeSeriesPoint(
periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,fraudCount: null == fraudCount ? _self.fraudCount : fraudCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeSeriesPoint].
extension TimeSeriesPointPatterns on TimeSeriesPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeSeriesPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeSeriesPoint value)  $default,){
final _that = this;
switch (_that) {
case _TimeSeriesPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeSeriesPoint value)?  $default,){
final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime periodStart,  int fraudCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
return $default(_that.periodStart,_that.fraudCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime periodStart,  int fraudCount)  $default,) {final _that = this;
switch (_that) {
case _TimeSeriesPoint():
return $default(_that.periodStart,_that.fraudCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime periodStart,  int fraudCount)?  $default,) {final _that = this;
switch (_that) {
case _TimeSeriesPoint() when $default != null:
return $default(_that.periodStart,_that.fraudCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TimeSeriesPoint implements TimeSeriesPoint {
  const _TimeSeriesPoint({required this.periodStart, required this.fraudCount});
  factory _TimeSeriesPoint.fromJson(Map<String, dynamic> json) => _$TimeSeriesPointFromJson(json);

@override final  DateTime periodStart;
@override final  int fraudCount;

/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeSeriesPointCopyWith<_TimeSeriesPoint> get copyWith => __$TimeSeriesPointCopyWithImpl<_TimeSeriesPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeSeriesPointToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeSeriesPoint&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.fraudCount, fraudCount) || other.fraudCount == fraudCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,periodStart,fraudCount);
}

@override
String toString() {
    return 'TimeSeriesPoint(periodStart: $periodStart, fraudCount: $fraudCount)';
}


}

/// @nodoc
abstract mixin class _$TimeSeriesPointCopyWith<$Res> implements $TimeSeriesPointCopyWith<$Res> {
  factory _$TimeSeriesPointCopyWith(_TimeSeriesPoint value, $Res Function(_TimeSeriesPoint) _then) = __$TimeSeriesPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime periodStart, int fraudCount
});




}
/// @nodoc
class __$TimeSeriesPointCopyWithImpl<$Res>
    implements _$TimeSeriesPointCopyWith<$Res> {
  __$TimeSeriesPointCopyWithImpl(this._self, this._then);

  final _TimeSeriesPoint _self;
  final $Res Function(_TimeSeriesPoint) _then;

/// Create a copy of TimeSeriesPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? periodStart = null,Object? fraudCount = null,}) {
  return _then(_TimeSeriesPoint(
periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,fraudCount: null == fraudCount ? _self.fraudCount : fraudCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
