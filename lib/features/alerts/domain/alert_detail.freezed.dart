// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlertDetail {

 AiAlert get alert;/// The account the alert is about. Null when it is about the customer.
 String? get accountId; String get modelVersion;/// Ordered by `position`.
 List<AlertReason> get reasons;/// The primary transaction first, then the rest by id.
 List<AlertTransaction> get transactions;
/// Create a copy of AlertDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertDetailCopyWith<AlertDetail> get copyWith => _$AlertDetailCopyWithImpl<AlertDetail>(this as AlertDetail, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AlertDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertDetail&&(identical(other.alert, _this.alert) || other.alert == _this.alert)&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.modelVersion, _this.modelVersion) || other.modelVersion == _this.modelVersion)&&const DeepCollectionEquality().equals(other.reasons, _this.reasons)&&const DeepCollectionEquality().equals(other.transactions, _this.transactions));
}


@override
int get hashCode {
  final _this = this as AlertDetail;
  return Object.hash(runtimeType,_this.alert,_this.accountId,_this.modelVersion,const DeepCollectionEquality().hash(_this.reasons),const DeepCollectionEquality().hash(_this.transactions));
}

@override
String toString() {
  final _this = this as AlertDetail;
  return 'AlertDetail(alert: ${_this.alert}, accountId: ${_this.accountId}, modelVersion: ${_this.modelVersion}, reasons: ${_this.reasons}, transactions: ${_this.transactions})';
}


}

/// @nodoc
abstract mixin class $AlertDetailCopyWith<$Res>  {
  factory $AlertDetailCopyWith(AlertDetail value, $Res Function(AlertDetail) _then) = _$AlertDetailCopyWithImpl;
@useResult
$Res call({
 AiAlert alert, String? accountId, String modelVersion, List<AlertReason> reasons, List<AlertTransaction> transactions
});


$AiAlertCopyWith<$Res> get alert;

}
/// @nodoc
class _$AlertDetailCopyWithImpl<$Res>
    implements $AlertDetailCopyWith<$Res> {
  _$AlertDetailCopyWithImpl(this._self, this._then);

  final AlertDetail _self;
  final $Res Function(AlertDetail) _then;

/// Create a copy of AlertDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? alert = null,Object? accountId = freezed,Object? modelVersion = null,Object? reasons = null,Object? transactions = null,}) {
  return _then(AlertDetail(
alert: null == alert ? _self.alert : alert // ignore: cast_nullable_to_non_nullable
as AiAlert,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,modelVersion: null == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<AlertReason>,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<AlertTransaction>,
  ));
}
/// Create a copy of AlertDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiAlertCopyWith<$Res> get alert {
  
  return $AiAlertCopyWith<$Res>(_self.alert, (value) {
    return _then(_self.copyWith(alert: value));
  });
}
}


/// Adds pattern-matching-related methods to [AlertDetail].
extension AlertDetailPatterns on AlertDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertDetail value)  $default,){
final _that = this;
switch (_that) {
case _AlertDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertDetail value)?  $default,){
final _that = this;
switch (_that) {
case _AlertDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiAlert alert,  String? accountId,  String modelVersion,  List<AlertReason> reasons,  List<AlertTransaction> transactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertDetail() when $default != null:
return $default(_that.alert,_that.accountId,_that.modelVersion,_that.reasons,_that.transactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiAlert alert,  String? accountId,  String modelVersion,  List<AlertReason> reasons,  List<AlertTransaction> transactions)  $default,) {final _that = this;
switch (_that) {
case _AlertDetail():
return $default(_that.alert,_that.accountId,_that.modelVersion,_that.reasons,_that.transactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiAlert alert,  String? accountId,  String modelVersion,  List<AlertReason> reasons,  List<AlertTransaction> transactions)?  $default,) {final _that = this;
switch (_that) {
case _AlertDetail() when $default != null:
return $default(_that.alert,_that.accountId,_that.modelVersion,_that.reasons,_that.transactions);case _:
  return null;

}
}

}

/// @nodoc


class _AlertDetail implements AlertDetail {
  const _AlertDetail({required this.alert, this.accountId, required this.modelVersion, required  List<AlertReason> reasons, required  List<AlertTransaction> transactions}): _reasons = reasons,_transactions = transactions;
  

@override final  AiAlert alert;
/// The account the alert is about. Null when it is about the customer.
@override final  String? accountId;
@override final  String modelVersion;
/// Ordered by `position`.
 final  List<AlertReason> _reasons;
/// Ordered by `position`.
@override List<AlertReason> get reasons {
  if (_reasons is EqualUnmodifiableListView) return _reasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reasons);
}

/// The primary transaction first, then the rest by id.
 final  List<AlertTransaction> _transactions;
/// The primary transaction first, then the rest by id.
@override List<AlertTransaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}


/// Create a copy of AlertDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertDetailCopyWith<_AlertDetail> get copyWith => __$AlertDetailCopyWithImpl<_AlertDetail>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertDetail&&(identical(other.alert, alert) || other.alert == alert)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.modelVersion, modelVersion) || other.modelVersion == modelVersion)&&const DeepCollectionEquality().equals(other.reasons, _reasons)&&const DeepCollectionEquality().equals(other.transactions, _transactions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,alert,accountId,modelVersion,const DeepCollectionEquality().hash(_reasons),const DeepCollectionEquality().hash(_transactions));
}

@override
String toString() {
    return 'AlertDetail(alert: $alert, accountId: $accountId, modelVersion: $modelVersion, reasons: $reasons, transactions: $transactions)';
}


}

/// @nodoc
abstract mixin class _$AlertDetailCopyWith<$Res> implements $AlertDetailCopyWith<$Res> {
  factory _$AlertDetailCopyWith(_AlertDetail value, $Res Function(_AlertDetail) _then) = __$AlertDetailCopyWithImpl;
@override @useResult
$Res call({
 AiAlert alert, String? accountId, String modelVersion, List<AlertReason> reasons, List<AlertTransaction> transactions
});


@override $AiAlertCopyWith<$Res> get alert;

}
/// @nodoc
class __$AlertDetailCopyWithImpl<$Res>
    implements _$AlertDetailCopyWith<$Res> {
  __$AlertDetailCopyWithImpl(this._self, this._then);

  final _AlertDetail _self;
  final $Res Function(_AlertDetail) _then;

/// Create a copy of AlertDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? alert = null,Object? accountId = freezed,Object? modelVersion = null,Object? reasons = null,Object? transactions = null,}) {
  return _then(_AlertDetail(
alert: null == alert ? _self.alert : alert // ignore: cast_nullable_to_non_nullable
as AiAlert,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,modelVersion: null == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String,reasons: null == reasons ? _self._reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<AlertReason>,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<AlertTransaction>,
  ));
}

/// Create a copy of AlertDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiAlertCopyWith<$Res> get alert {
  
  return $AiAlertCopyWith<$Res>(_self.alert, (value) {
    return _then(_self.copyWith(alert: value));
  });
}
}

// dart format on
