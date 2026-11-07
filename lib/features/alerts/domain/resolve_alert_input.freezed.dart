// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolve_alert_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResolveAlertInput {

 String get alertId; ResolveAlertAction get action;/// Row id of `fraud_types`. Only a reclassification chooses one: confirming keeps the
/// suggested type and rejecting has none.
 int? get finalTypeId; ConfidenceLevel? get confidence;/// Only for fraud (confirm or reclassify).
 Severity? get severity; String? get justification;/// Involved transactions the analyst unchecked: they keep their current label.
 List<int> get excludedTransactionIds;
/// Create a copy of ResolveAlertInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolveAlertInputCopyWith<ResolveAlertInput> get copyWith => _$ResolveAlertInputCopyWithImpl<ResolveAlertInput>(this as ResolveAlertInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ResolveAlertInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolveAlertInput&&(identical(other.alertId, _this.alertId) || other.alertId == _this.alertId)&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.finalTypeId, _this.finalTypeId) || other.finalTypeId == _this.finalTypeId)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence)&&(identical(other.severity, _this.severity) || other.severity == _this.severity)&&(identical(other.justification, _this.justification) || other.justification == _this.justification)&&const DeepCollectionEquality().equals(other.excludedTransactionIds, _this.excludedTransactionIds));
}


@override
int get hashCode {
  final _this = this as ResolveAlertInput;
  return Object.hash(runtimeType,_this.alertId,_this.action,_this.finalTypeId,_this.confidence,_this.severity,_this.justification,const DeepCollectionEquality().hash(_this.excludedTransactionIds));
}

@override
String toString() {
  final _this = this as ResolveAlertInput;
  return 'ResolveAlertInput(alertId: ${_this.alertId}, action: ${_this.action}, finalTypeId: ${_this.finalTypeId}, confidence: ${_this.confidence}, severity: ${_this.severity}, justification: ${_this.justification}, excludedTransactionIds: ${_this.excludedTransactionIds})';
}


}

/// @nodoc
abstract mixin class $ResolveAlertInputCopyWith<$Res>  {
  factory $ResolveAlertInputCopyWith(ResolveAlertInput value, $Res Function(ResolveAlertInput) _then) = _$ResolveAlertInputCopyWithImpl;
@useResult
$Res call({
 String alertId, ResolveAlertAction action, int? finalTypeId, ConfidenceLevel? confidence, Severity? severity, String? justification, List<int> excludedTransactionIds
});




}
/// @nodoc
class _$ResolveAlertInputCopyWithImpl<$Res>
    implements $ResolveAlertInputCopyWith<$Res> {
  _$ResolveAlertInputCopyWithImpl(this._self, this._then);

  final ResolveAlertInput _self;
  final $Res Function(ResolveAlertInput) _then;

/// Create a copy of ResolveAlertInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? alertId = null,Object? action = null,Object? finalTypeId = freezed,Object? confidence = freezed,Object? severity = freezed,Object? justification = freezed,Object? excludedTransactionIds = null,}) {
  return _then(ResolveAlertInput(
alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as ResolveAlertAction,finalTypeId: freezed == finalTypeId ? _self.finalTypeId : finalTypeId // ignore: cast_nullable_to_non_nullable
as int?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel?,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as Severity?,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,excludedTransactionIds: null == excludedTransactionIds ? _self.excludedTransactionIds : excludedTransactionIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [ResolveAlertInput].
extension ResolveAlertInputPatterns on ResolveAlertInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResolveAlertInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResolveAlertInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResolveAlertInput value)  $default,){
final _that = this;
switch (_that) {
case _ResolveAlertInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResolveAlertInput value)?  $default,){
final _that = this;
switch (_that) {
case _ResolveAlertInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String alertId,  ResolveAlertAction action,  int? finalTypeId,  ConfidenceLevel? confidence,  Severity? severity,  String? justification,  List<int> excludedTransactionIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResolveAlertInput() when $default != null:
return $default(_that.alertId,_that.action,_that.finalTypeId,_that.confidence,_that.severity,_that.justification,_that.excludedTransactionIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String alertId,  ResolveAlertAction action,  int? finalTypeId,  ConfidenceLevel? confidence,  Severity? severity,  String? justification,  List<int> excludedTransactionIds)  $default,) {final _that = this;
switch (_that) {
case _ResolveAlertInput():
return $default(_that.alertId,_that.action,_that.finalTypeId,_that.confidence,_that.severity,_that.justification,_that.excludedTransactionIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String alertId,  ResolveAlertAction action,  int? finalTypeId,  ConfidenceLevel? confidence,  Severity? severity,  String? justification,  List<int> excludedTransactionIds)?  $default,) {final _that = this;
switch (_that) {
case _ResolveAlertInput() when $default != null:
return $default(_that.alertId,_that.action,_that.finalTypeId,_that.confidence,_that.severity,_that.justification,_that.excludedTransactionIds);case _:
  return null;

}
}

}

/// @nodoc


class _ResolveAlertInput implements ResolveAlertInput {
  const _ResolveAlertInput({required this.alertId, required this.action, this.finalTypeId, this.confidence, this.severity, this.justification,  List<int> excludedTransactionIds = const <int>[]}): _excludedTransactionIds = excludedTransactionIds;
  

@override final  String alertId;
@override final  ResolveAlertAction action;
/// Row id of `fraud_types`. Only a reclassification chooses one: confirming keeps the
/// suggested type and rejecting has none.
@override final  int? finalTypeId;
@override final  ConfidenceLevel? confidence;
/// Only for fraud (confirm or reclassify).
@override final  Severity? severity;
@override final  String? justification;
/// Involved transactions the analyst unchecked: they keep their current label.
 final  List<int> _excludedTransactionIds;
/// Involved transactions the analyst unchecked: they keep their current label.
@override@JsonKey() List<int> get excludedTransactionIds {
  if (_excludedTransactionIds is EqualUnmodifiableListView) return _excludedTransactionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_excludedTransactionIds);
}


/// Create a copy of ResolveAlertInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResolveAlertInputCopyWith<_ResolveAlertInput> get copyWith => __$ResolveAlertInputCopyWithImpl<_ResolveAlertInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResolveAlertInput&&(identical(other.alertId, alertId) || other.alertId == alertId)&&(identical(other.action, action) || other.action == action)&&(identical(other.finalTypeId, finalTypeId) || other.finalTypeId == finalTypeId)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.justification, justification) || other.justification == justification)&&const DeepCollectionEquality().equals(other.excludedTransactionIds, _excludedTransactionIds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,alertId,action,finalTypeId,confidence,severity,justification,const DeepCollectionEquality().hash(_excludedTransactionIds));
}

@override
String toString() {
    return 'ResolveAlertInput(alertId: $alertId, action: $action, finalTypeId: $finalTypeId, confidence: $confidence, severity: $severity, justification: $justification, excludedTransactionIds: $excludedTransactionIds)';
}


}

/// @nodoc
abstract mixin class _$ResolveAlertInputCopyWith<$Res> implements $ResolveAlertInputCopyWith<$Res> {
  factory _$ResolveAlertInputCopyWith(_ResolveAlertInput value, $Res Function(_ResolveAlertInput) _then) = __$ResolveAlertInputCopyWithImpl;
@override @useResult
$Res call({
 String alertId, ResolveAlertAction action, int? finalTypeId, ConfidenceLevel? confidence, Severity? severity, String? justification, List<int> excludedTransactionIds
});




}
/// @nodoc
class __$ResolveAlertInputCopyWithImpl<$Res>
    implements _$ResolveAlertInputCopyWith<$Res> {
  __$ResolveAlertInputCopyWithImpl(this._self, this._then);

  final _ResolveAlertInput _self;
  final $Res Function(_ResolveAlertInput) _then;

/// Create a copy of ResolveAlertInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? alertId = null,Object? action = null,Object? finalTypeId = freezed,Object? confidence = freezed,Object? severity = freezed,Object? justification = freezed,Object? excludedTransactionIds = null,}) {
  return _then(_ResolveAlertInput(
alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as ResolveAlertAction,finalTypeId: freezed == finalTypeId ? _self.finalTypeId : finalTypeId // ignore: cast_nullable_to_non_nullable
as int?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel?,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as Severity?,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,excludedTransactionIds: null == excludedTransactionIds ? _self._excludedTransactionIds : excludedTransactionIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
