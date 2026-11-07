// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiAlert {

 String get id;/// The readable code, e.g. `AL-1042`.
 String get code; String get customerId; String get customerName;/// 0 to 100.
 int get score;@JsonKey(fromJson: FraudType.fromDb, toJson: _fraudTypeToJson) FraudType get suggestedType; String get summary;@JsonKey(fromJson: AlertStatus.fromDb, toJson: _statusToJson) AlertStatus get status; DateTime get generatedAt;/// The analyst who resolved it. Null while the alert is pending.
 String? get resolvedBy; String? get resolvedByName; DateTime? get resolvedAt;/// The type decided on resolution. Null while pending and when it was rejected.
@JsonKey(fromJson: _fraudTypeOrNull, toJson: _fraudTypeOrNullToJson) FraudType? get finalType;
/// Create a copy of AiAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiAlertCopyWith<AiAlert> get copyWith => _$AiAlertCopyWithImpl<AiAlert>(this as AiAlert, _$identity);

  /// Serializes this AiAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AiAlert;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiAlert&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.customerName, _this.customerName) || other.customerName == _this.customerName)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.suggestedType, _this.suggestedType) || other.suggestedType == _this.suggestedType)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt)&&(identical(other.resolvedBy, _this.resolvedBy) || other.resolvedBy == _this.resolvedBy)&&(identical(other.resolvedByName, _this.resolvedByName) || other.resolvedByName == _this.resolvedByName)&&(identical(other.resolvedAt, _this.resolvedAt) || other.resolvedAt == _this.resolvedAt)&&(identical(other.finalType, _this.finalType) || other.finalType == _this.finalType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AiAlert;
  return Object.hash(runtimeType,_this.id,_this.code,_this.customerId,_this.customerName,_this.score,_this.suggestedType,_this.summary,_this.status,_this.generatedAt,_this.resolvedBy,_this.resolvedByName,_this.resolvedAt,_this.finalType);
}

@override
String toString() {
  final _this = this as AiAlert;
  return 'AiAlert(id: ${_this.id}, code: ${_this.code}, customerId: ${_this.customerId}, customerName: ${_this.customerName}, score: ${_this.score}, suggestedType: ${_this.suggestedType}, summary: ${_this.summary}, status: ${_this.status}, generatedAt: ${_this.generatedAt}, resolvedBy: ${_this.resolvedBy}, resolvedByName: ${_this.resolvedByName}, resolvedAt: ${_this.resolvedAt}, finalType: ${_this.finalType})';
}


}

/// @nodoc
abstract mixin class $AiAlertCopyWith<$Res>  {
  factory $AiAlertCopyWith(AiAlert value, $Res Function(AiAlert) _then) = _$AiAlertCopyWithImpl;
@useResult
$Res call({
 String id, String code, String customerId, String customerName, int score,@JsonKey(fromJson: FraudType.fromDb, toJson: _fraudTypeToJson) FraudType suggestedType, String summary,@JsonKey(fromJson: AlertStatus.fromDb, toJson: _statusToJson) AlertStatus status, DateTime generatedAt, String? resolvedBy, String? resolvedByName, DateTime? resolvedAt,@JsonKey(fromJson: _fraudTypeOrNull, toJson: _fraudTypeOrNullToJson) FraudType? finalType
});




}
/// @nodoc
class _$AiAlertCopyWithImpl<$Res>
    implements $AiAlertCopyWith<$Res> {
  _$AiAlertCopyWithImpl(this._self, this._then);

  final AiAlert _self;
  final $Res Function(AiAlert) _then;

/// Create a copy of AiAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? customerId = null,Object? customerName = null,Object? score = null,Object? suggestedType = null,Object? summary = null,Object? status = null,Object? generatedAt = null,Object? resolvedBy = freezed,Object? resolvedByName = freezed,Object? resolvedAt = freezed,Object? finalType = freezed,}) {
  return _then(AiAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,suggestedType: null == suggestedType ? _self.suggestedType : suggestedType // ignore: cast_nullable_to_non_nullable
as FraudType,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlertStatus,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,resolvedBy: freezed == resolvedBy ? _self.resolvedBy : resolvedBy // ignore: cast_nullable_to_non_nullable
as String?,resolvedByName: freezed == resolvedByName ? _self.resolvedByName : resolvedByName // ignore: cast_nullable_to_non_nullable
as String?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finalType: freezed == finalType ? _self.finalType : finalType // ignore: cast_nullable_to_non_nullable
as FraudType?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiAlert].
extension AiAlertPatterns on AiAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiAlert value)  $default,){
final _that = this;
switch (_that) {
case _AiAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiAlert value)?  $default,){
final _that = this;
switch (_that) {
case _AiAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String customerId,  String customerName,  int score, @JsonKey(fromJson: FraudType.fromDb, toJson: _fraudTypeToJson)  FraudType suggestedType,  String summary, @JsonKey(fromJson: AlertStatus.fromDb, toJson: _statusToJson)  AlertStatus status,  DateTime generatedAt,  String? resolvedBy,  String? resolvedByName,  DateTime? resolvedAt, @JsonKey(fromJson: _fraudTypeOrNull, toJson: _fraudTypeOrNullToJson)  FraudType? finalType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiAlert() when $default != null:
return $default(_that.id,_that.code,_that.customerId,_that.customerName,_that.score,_that.suggestedType,_that.summary,_that.status,_that.generatedAt,_that.resolvedBy,_that.resolvedByName,_that.resolvedAt,_that.finalType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String customerId,  String customerName,  int score, @JsonKey(fromJson: FraudType.fromDb, toJson: _fraudTypeToJson)  FraudType suggestedType,  String summary, @JsonKey(fromJson: AlertStatus.fromDb, toJson: _statusToJson)  AlertStatus status,  DateTime generatedAt,  String? resolvedBy,  String? resolvedByName,  DateTime? resolvedAt, @JsonKey(fromJson: _fraudTypeOrNull, toJson: _fraudTypeOrNullToJson)  FraudType? finalType)  $default,) {final _that = this;
switch (_that) {
case _AiAlert():
return $default(_that.id,_that.code,_that.customerId,_that.customerName,_that.score,_that.suggestedType,_that.summary,_that.status,_that.generatedAt,_that.resolvedBy,_that.resolvedByName,_that.resolvedAt,_that.finalType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String customerId,  String customerName,  int score, @JsonKey(fromJson: FraudType.fromDb, toJson: _fraudTypeToJson)  FraudType suggestedType,  String summary, @JsonKey(fromJson: AlertStatus.fromDb, toJson: _statusToJson)  AlertStatus status,  DateTime generatedAt,  String? resolvedBy,  String? resolvedByName,  DateTime? resolvedAt, @JsonKey(fromJson: _fraudTypeOrNull, toJson: _fraudTypeOrNullToJson)  FraudType? finalType)?  $default,) {final _that = this;
switch (_that) {
case _AiAlert() when $default != null:
return $default(_that.id,_that.code,_that.customerId,_that.customerName,_that.score,_that.suggestedType,_that.summary,_that.status,_that.generatedAt,_that.resolvedBy,_that.resolvedByName,_that.resolvedAt,_that.finalType);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _AiAlert extends AiAlert {
  const _AiAlert({required this.id, required this.code, required this.customerId, required this.customerName, required this.score, @JsonKey(fromJson: FraudType.fromDb, toJson: _fraudTypeToJson) required this.suggestedType, required this.summary, @JsonKey(fromJson: AlertStatus.fromDb, toJson: _statusToJson) required this.status, required this.generatedAt, this.resolvedBy, this.resolvedByName, this.resolvedAt, @JsonKey(fromJson: _fraudTypeOrNull, toJson: _fraudTypeOrNullToJson) this.finalType}): super._();
  factory _AiAlert.fromJson(Map<String, dynamic> json) => _$AiAlertFromJson(json);

@override final  String id;
/// The readable code, e.g. `AL-1042`.
@override final  String code;
@override final  String customerId;
@override final  String customerName;
/// 0 to 100.
@override final  int score;
@override@JsonKey(fromJson: FraudType.fromDb, toJson: _fraudTypeToJson) final  FraudType suggestedType;
@override final  String summary;
@override@JsonKey(fromJson: AlertStatus.fromDb, toJson: _statusToJson) final  AlertStatus status;
@override final  DateTime generatedAt;
/// The analyst who resolved it. Null while the alert is pending.
@override final  String? resolvedBy;
@override final  String? resolvedByName;
@override final  DateTime? resolvedAt;
/// The type decided on resolution. Null while pending and when it was rejected.
@override@JsonKey(fromJson: _fraudTypeOrNull, toJson: _fraudTypeOrNullToJson) final  FraudType? finalType;

/// Create a copy of AiAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiAlertCopyWith<_AiAlert> get copyWith => __$AiAlertCopyWithImpl<_AiAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiAlertToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.score, score) || other.score == score)&&(identical(other.suggestedType, suggestedType) || other.suggestedType == suggestedType)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.status, status) || other.status == status)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.resolvedBy, resolvedBy) || other.resolvedBy == resolvedBy)&&(identical(other.resolvedByName, resolvedByName) || other.resolvedByName == resolvedByName)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.finalType, finalType) || other.finalType == finalType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,customerId,customerName,score,suggestedType,summary,status,generatedAt,resolvedBy,resolvedByName,resolvedAt,finalType);
}

@override
String toString() {
    return 'AiAlert(id: $id, code: $code, customerId: $customerId, customerName: $customerName, score: $score, suggestedType: $suggestedType, summary: $summary, status: $status, generatedAt: $generatedAt, resolvedBy: $resolvedBy, resolvedByName: $resolvedByName, resolvedAt: $resolvedAt, finalType: $finalType)';
}


}

/// @nodoc
abstract mixin class _$AiAlertCopyWith<$Res> implements $AiAlertCopyWith<$Res> {
  factory _$AiAlertCopyWith(_AiAlert value, $Res Function(_AiAlert) _then) = __$AiAlertCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String customerId, String customerName, int score,@JsonKey(fromJson: FraudType.fromDb, toJson: _fraudTypeToJson) FraudType suggestedType, String summary,@JsonKey(fromJson: AlertStatus.fromDb, toJson: _statusToJson) AlertStatus status, DateTime generatedAt, String? resolvedBy, String? resolvedByName, DateTime? resolvedAt,@JsonKey(fromJson: _fraudTypeOrNull, toJson: _fraudTypeOrNullToJson) FraudType? finalType
});




}
/// @nodoc
class __$AiAlertCopyWithImpl<$Res>
    implements _$AiAlertCopyWith<$Res> {
  __$AiAlertCopyWithImpl(this._self, this._then);

  final _AiAlert _self;
  final $Res Function(_AiAlert) _then;

/// Create a copy of AiAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? customerId = null,Object? customerName = null,Object? score = null,Object? suggestedType = null,Object? summary = null,Object? status = null,Object? generatedAt = null,Object? resolvedBy = freezed,Object? resolvedByName = freezed,Object? resolvedAt = freezed,Object? finalType = freezed,}) {
  return _then(_AiAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,suggestedType: null == suggestedType ? _self.suggestedType : suggestedType // ignore: cast_nullable_to_non_nullable
as FraudType,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlertStatus,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,resolvedBy: freezed == resolvedBy ? _self.resolvedBy : resolvedBy // ignore: cast_nullable_to_non_nullable
as String?,resolvedByName: freezed == resolvedByName ? _self.resolvedByName : resolvedByName // ignore: cast_nullable_to_non_nullable
as String?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finalType: freezed == finalType ? _self.finalType : finalType // ignore: cast_nullable_to_non_nullable
as FraudType?,
  ));
}


}

// dart format on
