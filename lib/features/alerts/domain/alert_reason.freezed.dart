// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_reason.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlertReason {

 String get id; String get alertId; int get position; double get weight; String get title; String get evidence; AlertMetric? get metric;
/// Create a copy of AlertReason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertReasonCopyWith<AlertReason> get copyWith => _$AlertReasonCopyWithImpl<AlertReason>(this as AlertReason, _$identity);

  /// Serializes this AlertReason to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlertReason;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertReason&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.alertId, _this.alertId) || other.alertId == _this.alertId)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.weight, _this.weight) || other.weight == _this.weight)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.evidence, _this.evidence) || other.evidence == _this.evidence)&&(identical(other.metric, _this.metric) || other.metric == _this.metric));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlertReason;
  return Object.hash(runtimeType,_this.id,_this.alertId,_this.position,_this.weight,_this.title,_this.evidence,_this.metric);
}

@override
String toString() {
  final _this = this as AlertReason;
  return 'AlertReason(id: ${_this.id}, alertId: ${_this.alertId}, position: ${_this.position}, weight: ${_this.weight}, title: ${_this.title}, evidence: ${_this.evidence}, metric: ${_this.metric})';
}


}

/// @nodoc
abstract mixin class $AlertReasonCopyWith<$Res>  {
  factory $AlertReasonCopyWith(AlertReason value, $Res Function(AlertReason) _then) = _$AlertReasonCopyWithImpl;
@useResult
$Res call({
 String id, String alertId, int position, double weight, String title, String evidence, AlertMetric? metric
});


$AlertMetricCopyWith<$Res>? get metric;

}
/// @nodoc
class _$AlertReasonCopyWithImpl<$Res>
    implements $AlertReasonCopyWith<$Res> {
  _$AlertReasonCopyWithImpl(this._self, this._then);

  final AlertReason _self;
  final $Res Function(AlertReason) _then;

/// Create a copy of AlertReason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? alertId = null,Object? position = null,Object? weight = null,Object? title = null,Object? evidence = null,Object? metric = freezed,}) {
  return _then(AlertReason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as String,metric: freezed == metric ? _self.metric : metric // ignore: cast_nullable_to_non_nullable
as AlertMetric?,
  ));
}
/// Create a copy of AlertReason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlertMetricCopyWith<$Res>? get metric {
    if (_self.metric == null) {
    return null;
  }

  return $AlertMetricCopyWith<$Res>(_self.metric!, (value) {
    return _then(_self.copyWith(metric: value));
  });
}
}


/// Adds pattern-matching-related methods to [AlertReason].
extension AlertReasonPatterns on AlertReason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertReason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertReason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertReason value)  $default,){
final _that = this;
switch (_that) {
case _AlertReason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertReason value)?  $default,){
final _that = this;
switch (_that) {
case _AlertReason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String alertId,  int position,  double weight,  String title,  String evidence,  AlertMetric? metric)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertReason() when $default != null:
return $default(_that.id,_that.alertId,_that.position,_that.weight,_that.title,_that.evidence,_that.metric);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String alertId,  int position,  double weight,  String title,  String evidence,  AlertMetric? metric)  $default,) {final _that = this;
switch (_that) {
case _AlertReason():
return $default(_that.id,_that.alertId,_that.position,_that.weight,_that.title,_that.evidence,_that.metric);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String alertId,  int position,  double weight,  String title,  String evidence,  AlertMetric? metric)?  $default,) {final _that = this;
switch (_that) {
case _AlertReason() when $default != null:
return $default(_that.id,_that.alertId,_that.position,_that.weight,_that.title,_that.evidence,_that.metric);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _AlertReason implements AlertReason {
  const _AlertReason({required this.id, required this.alertId, required this.position, required this.weight, required this.title, required this.evidence, this.metric});
  factory _AlertReason.fromJson(Map<String, dynamic> json) => _$AlertReasonFromJson(json);

@override final  String id;
@override final  String alertId;
@override final  int position;
@override final  double weight;
@override final  String title;
@override final  String evidence;
@override final  AlertMetric? metric;

/// Create a copy of AlertReason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertReasonCopyWith<_AlertReason> get copyWith => __$AlertReasonCopyWithImpl<_AlertReason>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertReasonToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertReason&&(identical(other.id, id) || other.id == id)&&(identical(other.alertId, alertId) || other.alertId == alertId)&&(identical(other.position, position) || other.position == position)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.title, title) || other.title == title)&&(identical(other.evidence, evidence) || other.evidence == evidence)&&(identical(other.metric, metric) || other.metric == metric));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,alertId,position,weight,title,evidence,metric);
}

@override
String toString() {
    return 'AlertReason(id: $id, alertId: $alertId, position: $position, weight: $weight, title: $title, evidence: $evidence, metric: $metric)';
}


}

/// @nodoc
abstract mixin class _$AlertReasonCopyWith<$Res> implements $AlertReasonCopyWith<$Res> {
  factory _$AlertReasonCopyWith(_AlertReason value, $Res Function(_AlertReason) _then) = __$AlertReasonCopyWithImpl;
@override @useResult
$Res call({
 String id, String alertId, int position, double weight, String title, String evidence, AlertMetric? metric
});


@override $AlertMetricCopyWith<$Res>? get metric;

}
/// @nodoc
class __$AlertReasonCopyWithImpl<$Res>
    implements _$AlertReasonCopyWith<$Res> {
  __$AlertReasonCopyWithImpl(this._self, this._then);

  final _AlertReason _self;
  final $Res Function(_AlertReason) _then;

/// Create a copy of AlertReason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? alertId = null,Object? position = null,Object? weight = null,Object? title = null,Object? evidence = null,Object? metric = freezed,}) {
  return _then(_AlertReason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as String,metric: freezed == metric ? _self.metric : metric // ignore: cast_nullable_to_non_nullable
as AlertMetric?,
  ));
}

/// Create a copy of AlertReason
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlertMetricCopyWith<$Res>? get metric {
    if (_self.metric == null) {
    return null;
  }

  return $AlertMetricCopyWith<$Res>(_self.metric!, (value) {
    return _then(_self.copyWith(metric: value));
  });
}
}

// dart format on
