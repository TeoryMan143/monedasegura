// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_writes_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LabelValues {

 Verdict get verdict; ConfidenceLevel get confidence; Severity? get severity; String? get justification; List<FraudType> get fraudTypes;
/// Create a copy of LabelValues
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LabelValuesCopyWith<LabelValues> get copyWith => _$LabelValuesCopyWithImpl<LabelValues>(this as LabelValues, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LabelValues;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LabelValues&&(identical(other.verdict, _this.verdict) || other.verdict == _this.verdict)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence)&&(identical(other.severity, _this.severity) || other.severity == _this.severity)&&(identical(other.justification, _this.justification) || other.justification == _this.justification)&&const DeepCollectionEquality().equals(other.fraudTypes, _this.fraudTypes));
}


@override
int get hashCode {
  final _this = this as LabelValues;
  return Object.hash(runtimeType,_this.verdict,_this.confidence,_this.severity,_this.justification,const DeepCollectionEquality().hash(_this.fraudTypes));
}

@override
String toString() {
  final _this = this as LabelValues;
  return 'LabelValues(verdict: ${_this.verdict}, confidence: ${_this.confidence}, severity: ${_this.severity}, justification: ${_this.justification}, fraudTypes: ${_this.fraudTypes})';
}


}

/// @nodoc
abstract mixin class $LabelValuesCopyWith<$Res>  {
  factory $LabelValuesCopyWith(LabelValues value, $Res Function(LabelValues) _then) = _$LabelValuesCopyWithImpl;
@useResult
$Res call({
 Verdict verdict, ConfidenceLevel confidence, Severity? severity, String? justification, List<FraudType> fraudTypes
});




}
/// @nodoc
class _$LabelValuesCopyWithImpl<$Res>
    implements $LabelValuesCopyWith<$Res> {
  _$LabelValuesCopyWithImpl(this._self, this._then);

  final LabelValues _self;
  final $Res Function(LabelValues) _then;

/// Create a copy of LabelValues
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? verdict = null,Object? confidence = null,Object? severity = freezed,Object? justification = freezed,Object? fraudTypes = null,}) {
  return _then(LabelValues(
verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as Severity?,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,fraudTypes: null == fraudTypes ? _self.fraudTypes : fraudTypes // ignore: cast_nullable_to_non_nullable
as List<FraudType>,
  ));
}

}


/// Adds pattern-matching-related methods to [LabelValues].
extension LabelValuesPatterns on LabelValues {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LabelValues value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LabelValues() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LabelValues value)  $default,){
final _that = this;
switch (_that) {
case _LabelValues():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LabelValues value)?  $default,){
final _that = this;
switch (_that) {
case _LabelValues() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Verdict verdict,  ConfidenceLevel confidence,  Severity? severity,  String? justification,  List<FraudType> fraudTypes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LabelValues() when $default != null:
return $default(_that.verdict,_that.confidence,_that.severity,_that.justification,_that.fraudTypes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Verdict verdict,  ConfidenceLevel confidence,  Severity? severity,  String? justification,  List<FraudType> fraudTypes)  $default,) {final _that = this;
switch (_that) {
case _LabelValues():
return $default(_that.verdict,_that.confidence,_that.severity,_that.justification,_that.fraudTypes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Verdict verdict,  ConfidenceLevel confidence,  Severity? severity,  String? justification,  List<FraudType> fraudTypes)?  $default,) {final _that = this;
switch (_that) {
case _LabelValues() when $default != null:
return $default(_that.verdict,_that.confidence,_that.severity,_that.justification,_that.fraudTypes);case _:
  return null;

}
}

}

/// @nodoc


class _LabelValues implements LabelValues {
  const _LabelValues({required this.verdict, required this.confidence, this.severity, this.justification,  List<FraudType> fraudTypes = const <FraudType>[]}): _fraudTypes = fraudTypes;
  

@override final  Verdict verdict;
@override final  ConfidenceLevel confidence;
@override final  Severity? severity;
@override final  String? justification;
 final  List<FraudType> _fraudTypes;
@override@JsonKey() List<FraudType> get fraudTypes {
  if (_fraudTypes is EqualUnmodifiableListView) return _fraudTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fraudTypes);
}


/// Create a copy of LabelValues
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LabelValuesCopyWith<_LabelValues> get copyWith => __$LabelValuesCopyWithImpl<_LabelValues>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LabelValues&&(identical(other.verdict, verdict) || other.verdict == verdict)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.justification, justification) || other.justification == justification)&&const DeepCollectionEquality().equals(other.fraudTypes, _fraudTypes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,verdict,confidence,severity,justification,const DeepCollectionEquality().hash(_fraudTypes));
}

@override
String toString() {
    return 'LabelValues(verdict: $verdict, confidence: $confidence, severity: $severity, justification: $justification, fraudTypes: $fraudTypes)';
}


}

/// @nodoc
abstract mixin class _$LabelValuesCopyWith<$Res> implements $LabelValuesCopyWith<$Res> {
  factory _$LabelValuesCopyWith(_LabelValues value, $Res Function(_LabelValues) _then) = __$LabelValuesCopyWithImpl;
@override @useResult
$Res call({
 Verdict verdict, ConfidenceLevel confidence, Severity? severity, String? justification, List<FraudType> fraudTypes
});




}
/// @nodoc
class __$LabelValuesCopyWithImpl<$Res>
    implements _$LabelValuesCopyWith<$Res> {
  __$LabelValuesCopyWithImpl(this._self, this._then);

  final _LabelValues _self;
  final $Res Function(_LabelValues) _then;

/// Create a copy of LabelValues
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? verdict = null,Object? confidence = null,Object? severity = freezed,Object? justification = freezed,Object? fraudTypes = null,}) {
  return _then(_LabelValues(
verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as Severity?,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,fraudTypes: null == fraudTypes ? _self._fraudTypes : fraudTypes // ignore: cast_nullable_to_non_nullable
as List<FraudType>,
  ));
}


}

/// @nodoc
mixin _$LocalLabel {

 int get transactionId; LabelValues get values;/// The alert that produced the label. Null for a manual label.
 String? get alertId;/// The last analyst who saved it.
 String get analystId; String get analystName; DateTime get createdAt; DateTime get updatedAt;/// 1 when created, plus one per edit.
 int get version;
/// Create a copy of LocalLabel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalLabelCopyWith<LocalLabel> get copyWith => _$LocalLabelCopyWithImpl<LocalLabel>(this as LocalLabel, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LocalLabel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalLabel&&(identical(other.transactionId, _this.transactionId) || other.transactionId == _this.transactionId)&&(identical(other.values, _this.values) || other.values == _this.values)&&(identical(other.alertId, _this.alertId) || other.alertId == _this.alertId)&&(identical(other.analystId, _this.analystId) || other.analystId == _this.analystId)&&(identical(other.analystName, _this.analystName) || other.analystName == _this.analystName)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.version, _this.version) || other.version == _this.version));
}


@override
int get hashCode {
  final _this = this as LocalLabel;
  return Object.hash(runtimeType,_this.transactionId,_this.values,_this.alertId,_this.analystId,_this.analystName,_this.createdAt,_this.updatedAt,_this.version);
}

@override
String toString() {
  final _this = this as LocalLabel;
  return 'LocalLabel(transactionId: ${_this.transactionId}, values: ${_this.values}, alertId: ${_this.alertId}, analystId: ${_this.analystId}, analystName: ${_this.analystName}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, version: ${_this.version})';
}


}

/// @nodoc
abstract mixin class $LocalLabelCopyWith<$Res>  {
  factory $LocalLabelCopyWith(LocalLabel value, $Res Function(LocalLabel) _then) = _$LocalLabelCopyWithImpl;
@useResult
$Res call({
 int transactionId, LabelValues values, String? alertId, String analystId, String analystName, DateTime createdAt, DateTime updatedAt, int version
});


$LabelValuesCopyWith<$Res> get values;

}
/// @nodoc
class _$LocalLabelCopyWithImpl<$Res>
    implements $LocalLabelCopyWith<$Res> {
  _$LocalLabelCopyWithImpl(this._self, this._then);

  final LocalLabel _self;
  final $Res Function(LocalLabel) _then;

/// Create a copy of LocalLabel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactionId = null,Object? values = null,Object? alertId = freezed,Object? analystId = null,Object? analystName = null,Object? createdAt = null,Object? updatedAt = null,Object? version = null,}) {
  return _then(LocalLabel(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as int,values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as LabelValues,alertId: freezed == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String?,analystId: null == analystId ? _self.analystId : analystId // ignore: cast_nullable_to_non_nullable
as String,analystName: null == analystName ? _self.analystName : analystName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of LocalLabel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LabelValuesCopyWith<$Res> get values {
  
  return $LabelValuesCopyWith<$Res>(_self.values, (value) {
    return _then(_self.copyWith(values: value));
  });
}
}


/// Adds pattern-matching-related methods to [LocalLabel].
extension LocalLabelPatterns on LocalLabel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalLabel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalLabel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalLabel value)  $default,){
final _that = this;
switch (_that) {
case _LocalLabel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalLabel value)?  $default,){
final _that = this;
switch (_that) {
case _LocalLabel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int transactionId,  LabelValues values,  String? alertId,  String analystId,  String analystName,  DateTime createdAt,  DateTime updatedAt,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalLabel() when $default != null:
return $default(_that.transactionId,_that.values,_that.alertId,_that.analystId,_that.analystName,_that.createdAt,_that.updatedAt,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int transactionId,  LabelValues values,  String? alertId,  String analystId,  String analystName,  DateTime createdAt,  DateTime updatedAt,  int version)  $default,) {final _that = this;
switch (_that) {
case _LocalLabel():
return $default(_that.transactionId,_that.values,_that.alertId,_that.analystId,_that.analystName,_that.createdAt,_that.updatedAt,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int transactionId,  LabelValues values,  String? alertId,  String analystId,  String analystName,  DateTime createdAt,  DateTime updatedAt,  int version)?  $default,) {final _that = this;
switch (_that) {
case _LocalLabel() when $default != null:
return $default(_that.transactionId,_that.values,_that.alertId,_that.analystId,_that.analystName,_that.createdAt,_that.updatedAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _LocalLabel implements LocalLabel {
  const _LocalLabel({required this.transactionId, required this.values, this.alertId, required this.analystId, required this.analystName, required this.createdAt, required this.updatedAt, required this.version});
  

@override final  int transactionId;
@override final  LabelValues values;
/// The alert that produced the label. Null for a manual label.
@override final  String? alertId;
/// The last analyst who saved it.
@override final  String analystId;
@override final  String analystName;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// 1 when created, plus one per edit.
@override final  int version;

/// Create a copy of LocalLabel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalLabelCopyWith<_LocalLabel> get copyWith => __$LocalLabelCopyWithImpl<_LocalLabel>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalLabel&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.values, values) || other.values == values)&&(identical(other.alertId, alertId) || other.alertId == alertId)&&(identical(other.analystId, analystId) || other.analystId == analystId)&&(identical(other.analystName, analystName) || other.analystName == analystName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode {
    return Object.hash(runtimeType,transactionId,values,alertId,analystId,analystName,createdAt,updatedAt,version);
}

@override
String toString() {
    return 'LocalLabel(transactionId: $transactionId, values: $values, alertId: $alertId, analystId: $analystId, analystName: $analystName, createdAt: $createdAt, updatedAt: $updatedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$LocalLabelCopyWith<$Res> implements $LocalLabelCopyWith<$Res> {
  factory _$LocalLabelCopyWith(_LocalLabel value, $Res Function(_LocalLabel) _then) = __$LocalLabelCopyWithImpl;
@override @useResult
$Res call({
 int transactionId, LabelValues values, String? alertId, String analystId, String analystName, DateTime createdAt, DateTime updatedAt, int version
});


@override $LabelValuesCopyWith<$Res> get values;

}
/// @nodoc
class __$LocalLabelCopyWithImpl<$Res>
    implements _$LocalLabelCopyWith<$Res> {
  __$LocalLabelCopyWithImpl(this._self, this._then);

  final _LocalLabel _self;
  final $Res Function(_LocalLabel) _then;

/// Create a copy of LocalLabel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactionId = null,Object? values = null,Object? alertId = freezed,Object? analystId = null,Object? analystName = null,Object? createdAt = null,Object? updatedAt = null,Object? version = null,}) {
  return _then(_LocalLabel(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as int,values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as LabelValues,alertId: freezed == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String?,analystId: null == analystId ? _self.analystId : analystId // ignore: cast_nullable_to_non_nullable
as String,analystName: null == analystName ? _self.analystName : analystName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of LocalLabel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LabelValuesCopyWith<$Res> get values {
  
  return $LabelValuesCopyWith<$Res>(_self.values, (value) {
    return _then(_self.copyWith(values: value));
  });
}
}

/// @nodoc
mixin _$AlertResolution {

 String get alertId; AlertStatus get status; String get analystId; String get analystName; DateTime get resolvedAt;/// Null when the alert was rejected.
 FraudType? get finalType;
/// Create a copy of AlertResolution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertResolutionCopyWith<AlertResolution> get copyWith => _$AlertResolutionCopyWithImpl<AlertResolution>(this as AlertResolution, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AlertResolution;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertResolution&&(identical(other.alertId, _this.alertId) || other.alertId == _this.alertId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.analystId, _this.analystId) || other.analystId == _this.analystId)&&(identical(other.analystName, _this.analystName) || other.analystName == _this.analystName)&&(identical(other.resolvedAt, _this.resolvedAt) || other.resolvedAt == _this.resolvedAt)&&(identical(other.finalType, _this.finalType) || other.finalType == _this.finalType));
}


@override
int get hashCode {
  final _this = this as AlertResolution;
  return Object.hash(runtimeType,_this.alertId,_this.status,_this.analystId,_this.analystName,_this.resolvedAt,_this.finalType);
}

@override
String toString() {
  final _this = this as AlertResolution;
  return 'AlertResolution(alertId: ${_this.alertId}, status: ${_this.status}, analystId: ${_this.analystId}, analystName: ${_this.analystName}, resolvedAt: ${_this.resolvedAt}, finalType: ${_this.finalType})';
}


}

/// @nodoc
abstract mixin class $AlertResolutionCopyWith<$Res>  {
  factory $AlertResolutionCopyWith(AlertResolution value, $Res Function(AlertResolution) _then) = _$AlertResolutionCopyWithImpl;
@useResult
$Res call({
 String alertId, AlertStatus status, String analystId, String analystName, DateTime resolvedAt, FraudType? finalType
});




}
/// @nodoc
class _$AlertResolutionCopyWithImpl<$Res>
    implements $AlertResolutionCopyWith<$Res> {
  _$AlertResolutionCopyWithImpl(this._self, this._then);

  final AlertResolution _self;
  final $Res Function(AlertResolution) _then;

/// Create a copy of AlertResolution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? alertId = null,Object? status = null,Object? analystId = null,Object? analystName = null,Object? resolvedAt = null,Object? finalType = freezed,}) {
  return _then(AlertResolution(
alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlertStatus,analystId: null == analystId ? _self.analystId : analystId // ignore: cast_nullable_to_non_nullable
as String,analystName: null == analystName ? _self.analystName : analystName // ignore: cast_nullable_to_non_nullable
as String,resolvedAt: null == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finalType: freezed == finalType ? _self.finalType : finalType // ignore: cast_nullable_to_non_nullable
as FraudType?,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertResolution].
extension AlertResolutionPatterns on AlertResolution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertResolution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertResolution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertResolution value)  $default,){
final _that = this;
switch (_that) {
case _AlertResolution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertResolution value)?  $default,){
final _that = this;
switch (_that) {
case _AlertResolution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String alertId,  AlertStatus status,  String analystId,  String analystName,  DateTime resolvedAt,  FraudType? finalType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertResolution() when $default != null:
return $default(_that.alertId,_that.status,_that.analystId,_that.analystName,_that.resolvedAt,_that.finalType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String alertId,  AlertStatus status,  String analystId,  String analystName,  DateTime resolvedAt,  FraudType? finalType)  $default,) {final _that = this;
switch (_that) {
case _AlertResolution():
return $default(_that.alertId,_that.status,_that.analystId,_that.analystName,_that.resolvedAt,_that.finalType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String alertId,  AlertStatus status,  String analystId,  String analystName,  DateTime resolvedAt,  FraudType? finalType)?  $default,) {final _that = this;
switch (_that) {
case _AlertResolution() when $default != null:
return $default(_that.alertId,_that.status,_that.analystId,_that.analystName,_that.resolvedAt,_that.finalType);case _:
  return null;

}
}

}

/// @nodoc


class _AlertResolution implements AlertResolution {
  const _AlertResolution({required this.alertId, required this.status, required this.analystId, required this.analystName, required this.resolvedAt, this.finalType});
  

@override final  String alertId;
@override final  AlertStatus status;
@override final  String analystId;
@override final  String analystName;
@override final  DateTime resolvedAt;
/// Null when the alert was rejected.
@override final  FraudType? finalType;

/// Create a copy of AlertResolution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertResolutionCopyWith<_AlertResolution> get copyWith => __$AlertResolutionCopyWithImpl<_AlertResolution>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertResolution&&(identical(other.alertId, alertId) || other.alertId == alertId)&&(identical(other.status, status) || other.status == status)&&(identical(other.analystId, analystId) || other.analystId == analystId)&&(identical(other.analystName, analystName) || other.analystName == analystName)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.finalType, finalType) || other.finalType == finalType));
}


@override
int get hashCode {
    return Object.hash(runtimeType,alertId,status,analystId,analystName,resolvedAt,finalType);
}

@override
String toString() {
    return 'AlertResolution(alertId: $alertId, status: $status, analystId: $analystId, analystName: $analystName, resolvedAt: $resolvedAt, finalType: $finalType)';
}


}

/// @nodoc
abstract mixin class _$AlertResolutionCopyWith<$Res> implements $AlertResolutionCopyWith<$Res> {
  factory _$AlertResolutionCopyWith(_AlertResolution value, $Res Function(_AlertResolution) _then) = __$AlertResolutionCopyWithImpl;
@override @useResult
$Res call({
 String alertId, AlertStatus status, String analystId, String analystName, DateTime resolvedAt, FraudType? finalType
});




}
/// @nodoc
class __$AlertResolutionCopyWithImpl<$Res>
    implements _$AlertResolutionCopyWith<$Res> {
  __$AlertResolutionCopyWithImpl(this._self, this._then);

  final _AlertResolution _self;
  final $Res Function(_AlertResolution) _then;

/// Create a copy of AlertResolution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? alertId = null,Object? status = null,Object? analystId = null,Object? analystName = null,Object? resolvedAt = null,Object? finalType = freezed,}) {
  return _then(_AlertResolution(
alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlertStatus,analystId: null == analystId ? _self.analystId : analystId // ignore: cast_nullable_to_non_nullable
as String,analystName: null == analystName ? _self.analystName : analystName // ignore: cast_nullable_to_non_nullable
as String,resolvedAt: null == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finalType: freezed == finalType ? _self.finalType : finalType // ignore: cast_nullable_to_non_nullable
as FraudType?,
  ));
}


}

/// @nodoc
mixin _$AuditEntry {

 AuditAction get action; String get analystId; String get analystName; DateTime get createdAt;/// Null in the entry of the alert itself.
 int? get transactionId;/// Null for a manual label.
 String? get alertId;/// Null when the label is created.
 Map<String, Object?>? get oldValue; Map<String, Object?> get newValue;
/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEntryCopyWith<AuditEntry> get copyWith => _$AuditEntryCopyWithImpl<AuditEntry>(this as AuditEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AuditEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEntry&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.analystId, _this.analystId) || other.analystId == _this.analystId)&&(identical(other.analystName, _this.analystName) || other.analystName == _this.analystName)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.transactionId, _this.transactionId) || other.transactionId == _this.transactionId)&&(identical(other.alertId, _this.alertId) || other.alertId == _this.alertId)&&const DeepCollectionEquality().equals(other.oldValue, _this.oldValue)&&const DeepCollectionEquality().equals(other.newValue, _this.newValue));
}


@override
int get hashCode {
  final _this = this as AuditEntry;
  return Object.hash(runtimeType,_this.action,_this.analystId,_this.analystName,_this.createdAt,_this.transactionId,_this.alertId,const DeepCollectionEquality().hash(_this.oldValue),const DeepCollectionEquality().hash(_this.newValue));
}

@override
String toString() {
  final _this = this as AuditEntry;
  return 'AuditEntry(action: ${_this.action}, analystId: ${_this.analystId}, analystName: ${_this.analystName}, createdAt: ${_this.createdAt}, transactionId: ${_this.transactionId}, alertId: ${_this.alertId}, oldValue: ${_this.oldValue}, newValue: ${_this.newValue})';
}


}

/// @nodoc
abstract mixin class $AuditEntryCopyWith<$Res>  {
  factory $AuditEntryCopyWith(AuditEntry value, $Res Function(AuditEntry) _then) = _$AuditEntryCopyWithImpl;
@useResult
$Res call({
 AuditAction action, String analystId, String analystName, DateTime createdAt, int? transactionId, String? alertId, Map<String, Object?>? oldValue, Map<String, Object?> newValue
});




}
/// @nodoc
class _$AuditEntryCopyWithImpl<$Res>
    implements $AuditEntryCopyWith<$Res> {
  _$AuditEntryCopyWithImpl(this._self, this._then);

  final AuditEntry _self;
  final $Res Function(AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? analystId = null,Object? analystName = null,Object? createdAt = null,Object? transactionId = freezed,Object? alertId = freezed,Object? oldValue = freezed,Object? newValue = null,}) {
  return _then(AuditEntry(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AuditAction,analystId: null == analystId ? _self.analystId : analystId // ignore: cast_nullable_to_non_nullable
as String,analystName: null == analystName ? _self.analystName : analystName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as int?,alertId: freezed == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String?,oldValue: freezed == oldValue ? _self.oldValue : oldValue // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,newValue: null == newValue ? _self.newValue : newValue // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditEntry].
extension AuditEntryPatterns on AuditEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditEntry value)  $default,){
final _that = this;
switch (_that) {
case _AuditEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuditAction action,  String analystId,  String analystName,  DateTime createdAt,  int? transactionId,  String? alertId,  Map<String, Object?>? oldValue,  Map<String, Object?> newValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.action,_that.analystId,_that.analystName,_that.createdAt,_that.transactionId,_that.alertId,_that.oldValue,_that.newValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuditAction action,  String analystId,  String analystName,  DateTime createdAt,  int? transactionId,  String? alertId,  Map<String, Object?>? oldValue,  Map<String, Object?> newValue)  $default,) {final _that = this;
switch (_that) {
case _AuditEntry():
return $default(_that.action,_that.analystId,_that.analystName,_that.createdAt,_that.transactionId,_that.alertId,_that.oldValue,_that.newValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuditAction action,  String analystId,  String analystName,  DateTime createdAt,  int? transactionId,  String? alertId,  Map<String, Object?>? oldValue,  Map<String, Object?> newValue)?  $default,) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.action,_that.analystId,_that.analystName,_that.createdAt,_that.transactionId,_that.alertId,_that.oldValue,_that.newValue);case _:
  return null;

}
}

}

/// @nodoc


class _AuditEntry implements AuditEntry {
  const _AuditEntry({required this.action, required this.analystId, required this.analystName, required this.createdAt, this.transactionId, this.alertId,  Map<String, Object?>? oldValue, required  Map<String, Object?> newValue}): _oldValue = oldValue,_newValue = newValue;
  

@override final  AuditAction action;
@override final  String analystId;
@override final  String analystName;
@override final  DateTime createdAt;
/// Null in the entry of the alert itself.
@override final  int? transactionId;
/// Null for a manual label.
@override final  String? alertId;
/// Null when the label is created.
 final  Map<String, Object?>? _oldValue;
/// Null when the label is created.
@override Map<String, Object?>? get oldValue {
  final value = _oldValue;
  if (value == null) return null;
  if (_oldValue is EqualUnmodifiableMapView) return _oldValue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, Object?> _newValue;
@override Map<String, Object?> get newValue {
  if (_newValue is EqualUnmodifiableMapView) return _newValue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_newValue);
}


/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditEntryCopyWith<_AuditEntry> get copyWith => __$AuditEntryCopyWithImpl<_AuditEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditEntry&&(identical(other.action, action) || other.action == action)&&(identical(other.analystId, analystId) || other.analystId == analystId)&&(identical(other.analystName, analystName) || other.analystName == analystName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.alertId, alertId) || other.alertId == alertId)&&const DeepCollectionEquality().equals(other.oldValue, _oldValue)&&const DeepCollectionEquality().equals(other.newValue, _newValue));
}


@override
int get hashCode {
    return Object.hash(runtimeType,action,analystId,analystName,createdAt,transactionId,alertId,const DeepCollectionEquality().hash(_oldValue),const DeepCollectionEquality().hash(_newValue));
}

@override
String toString() {
    return 'AuditEntry(action: $action, analystId: $analystId, analystName: $analystName, createdAt: $createdAt, transactionId: $transactionId, alertId: $alertId, oldValue: $oldValue, newValue: $newValue)';
}


}

/// @nodoc
abstract mixin class _$AuditEntryCopyWith<$Res> implements $AuditEntryCopyWith<$Res> {
  factory _$AuditEntryCopyWith(_AuditEntry value, $Res Function(_AuditEntry) _then) = __$AuditEntryCopyWithImpl;
@override @useResult
$Res call({
 AuditAction action, String analystId, String analystName, DateTime createdAt, int? transactionId, String? alertId, Map<String, Object?>? oldValue, Map<String, Object?> newValue
});




}
/// @nodoc
class __$AuditEntryCopyWithImpl<$Res>
    implements _$AuditEntryCopyWith<$Res> {
  __$AuditEntryCopyWithImpl(this._self, this._then);

  final _AuditEntry _self;
  final $Res Function(_AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? analystId = null,Object? analystName = null,Object? createdAt = null,Object? transactionId = freezed,Object? alertId = freezed,Object? oldValue = freezed,Object? newValue = null,}) {
  return _then(_AuditEntry(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AuditAction,analystId: null == analystId ? _self.analystId : analystId // ignore: cast_nullable_to_non_nullable
as String,analystName: null == analystName ? _self.analystName : analystName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as int?,alertId: freezed == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String?,oldValue: freezed == oldValue ? _self._oldValue : oldValue // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,newValue: null == newValue ? _self._newValue : newValue // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

// dart format on
