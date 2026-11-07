// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_metric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlertMetric {

/// What the transaction did, e.g. the amount.
 double get observed;/// What is usual for the customer, e.g. the 90-day average.
 double get baseline;/// Currency code, `x`, `min`… Null when the number has no unit.
 String? get unit;
/// Create a copy of AlertMetric
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertMetricCopyWith<AlertMetric> get copyWith => _$AlertMetricCopyWithImpl<AlertMetric>(this as AlertMetric, _$identity);

  /// Serializes this AlertMetric to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlertMetric;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertMetric&&(identical(other.observed, _this.observed) || other.observed == _this.observed)&&(identical(other.baseline, _this.baseline) || other.baseline == _this.baseline)&&(identical(other.unit, _this.unit) || other.unit == _this.unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlertMetric;
  return Object.hash(runtimeType,_this.observed,_this.baseline,_this.unit);
}

@override
String toString() {
  final _this = this as AlertMetric;
  return 'AlertMetric(observed: ${_this.observed}, baseline: ${_this.baseline}, unit: ${_this.unit})';
}


}

/// @nodoc
abstract mixin class $AlertMetricCopyWith<$Res>  {
  factory $AlertMetricCopyWith(AlertMetric value, $Res Function(AlertMetric) _then) = _$AlertMetricCopyWithImpl;
@useResult
$Res call({
 double observed, double baseline, String? unit
});




}
/// @nodoc
class _$AlertMetricCopyWithImpl<$Res>
    implements $AlertMetricCopyWith<$Res> {
  _$AlertMetricCopyWithImpl(this._self, this._then);

  final AlertMetric _self;
  final $Res Function(AlertMetric) _then;

/// Create a copy of AlertMetric
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? observed = null,Object? baseline = null,Object? unit = freezed,}) {
  return _then(AlertMetric(
observed: null == observed ? _self.observed : observed // ignore: cast_nullable_to_non_nullable
as double,baseline: null == baseline ? _self.baseline : baseline // ignore: cast_nullable_to_non_nullable
as double,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertMetric].
extension AlertMetricPatterns on AlertMetric {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertMetric value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertMetric() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertMetric value)  $default,){
final _that = this;
switch (_that) {
case _AlertMetric():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertMetric value)?  $default,){
final _that = this;
switch (_that) {
case _AlertMetric() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double observed,  double baseline,  String? unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertMetric() when $default != null:
return $default(_that.observed,_that.baseline,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double observed,  double baseline,  String? unit)  $default,) {final _that = this;
switch (_that) {
case _AlertMetric():
return $default(_that.observed,_that.baseline,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double observed,  double baseline,  String? unit)?  $default,) {final _that = this;
switch (_that) {
case _AlertMetric() when $default != null:
return $default(_that.observed,_that.baseline,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlertMetric extends AlertMetric {
  const _AlertMetric({required this.observed, required this.baseline, this.unit}): super._();
  factory _AlertMetric.fromJson(Map<String, dynamic> json) => _$AlertMetricFromJson(json);

/// What the transaction did, e.g. the amount.
@override final  double observed;
/// What is usual for the customer, e.g. the 90-day average.
@override final  double baseline;
/// Currency code, `x`, `min`… Null when the number has no unit.
@override final  String? unit;

/// Create a copy of AlertMetric
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertMetricCopyWith<_AlertMetric> get copyWith => __$AlertMetricCopyWithImpl<_AlertMetric>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertMetricToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertMetric&&(identical(other.observed, observed) || other.observed == observed)&&(identical(other.baseline, baseline) || other.baseline == baseline)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,observed,baseline,unit);
}

@override
String toString() {
    return 'AlertMetric(observed: $observed, baseline: $baseline, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$AlertMetricCopyWith<$Res> implements $AlertMetricCopyWith<$Res> {
  factory _$AlertMetricCopyWith(_AlertMetric value, $Res Function(_AlertMetric) _then) = __$AlertMetricCopyWithImpl;
@override @useResult
$Res call({
 double observed, double baseline, String? unit
});




}
/// @nodoc
class __$AlertMetricCopyWithImpl<$Res>
    implements _$AlertMetricCopyWith<$Res> {
  __$AlertMetricCopyWithImpl(this._self, this._then);

  final _AlertMetric _self;
  final $Res Function(_AlertMetric) _then;

/// Create a copy of AlertMetric
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? observed = null,Object? baseline = null,Object? unit = freezed,}) {
  return _then(_AlertMetric(
observed: null == observed ? _self.observed : observed // ignore: cast_nullable_to_non_nullable
as double,baseline: null == baseline ? _self.baseline : baseline // ignore: cast_nullable_to_non_nullable
as double,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
