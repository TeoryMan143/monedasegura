// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlertTransaction {

 int get transactionId; String get code; bool get isPrimary; double get amount; String get currencyCode;
/// Create a copy of AlertTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertTransactionCopyWith<AlertTransaction> get copyWith => _$AlertTransactionCopyWithImpl<AlertTransaction>(this as AlertTransaction, _$identity);

  /// Serializes this AlertTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlertTransaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertTransaction&&(identical(other.transactionId, _this.transactionId) || other.transactionId == _this.transactionId)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.isPrimary, _this.isPrimary) || other.isPrimary == _this.isPrimary)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlertTransaction;
  return Object.hash(runtimeType,_this.transactionId,_this.code,_this.isPrimary,_this.amount,_this.currencyCode);
}

@override
String toString() {
  final _this = this as AlertTransaction;
  return 'AlertTransaction(transactionId: ${_this.transactionId}, code: ${_this.code}, isPrimary: ${_this.isPrimary}, amount: ${_this.amount}, currencyCode: ${_this.currencyCode})';
}


}

/// @nodoc
abstract mixin class $AlertTransactionCopyWith<$Res>  {
  factory $AlertTransactionCopyWith(AlertTransaction value, $Res Function(AlertTransaction) _then) = _$AlertTransactionCopyWithImpl;
@useResult
$Res call({
 int transactionId, String code, bool isPrimary, double amount, String currencyCode
});




}
/// @nodoc
class _$AlertTransactionCopyWithImpl<$Res>
    implements $AlertTransactionCopyWith<$Res> {
  _$AlertTransactionCopyWithImpl(this._self, this._then);

  final AlertTransaction _self;
  final $Res Function(AlertTransaction) _then;

/// Create a copy of AlertTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactionId = null,Object? code = null,Object? isPrimary = null,Object? amount = null,Object? currencyCode = null,}) {
  return _then(AlertTransaction(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertTransaction].
extension AlertTransactionPatterns on AlertTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertTransaction value)  $default,){
final _that = this;
switch (_that) {
case _AlertTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _AlertTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int transactionId,  String code,  bool isPrimary,  double amount,  String currencyCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertTransaction() when $default != null:
return $default(_that.transactionId,_that.code,_that.isPrimary,_that.amount,_that.currencyCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int transactionId,  String code,  bool isPrimary,  double amount,  String currencyCode)  $default,) {final _that = this;
switch (_that) {
case _AlertTransaction():
return $default(_that.transactionId,_that.code,_that.isPrimary,_that.amount,_that.currencyCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int transactionId,  String code,  bool isPrimary,  double amount,  String currencyCode)?  $default,) {final _that = this;
switch (_that) {
case _AlertTransaction() when $default != null:
return $default(_that.transactionId,_that.code,_that.isPrimary,_that.amount,_that.currencyCode);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _AlertTransaction implements AlertTransaction {
  const _AlertTransaction({required this.transactionId, required this.code, required this.isPrimary, required this.amount, required this.currencyCode});
  factory _AlertTransaction.fromJson(Map<String, dynamic> json) => _$AlertTransactionFromJson(json);

@override final  int transactionId;
@override final  String code;
@override final  bool isPrimary;
@override final  double amount;
@override final  String currencyCode;

/// Create a copy of AlertTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertTransactionCopyWith<_AlertTransaction> get copyWith => __$AlertTransactionCopyWithImpl<_AlertTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertTransaction&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.code, code) || other.code == code)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,transactionId,code,isPrimary,amount,currencyCode);
}

@override
String toString() {
    return 'AlertTransaction(transactionId: $transactionId, code: $code, isPrimary: $isPrimary, amount: $amount, currencyCode: $currencyCode)';
}


}

/// @nodoc
abstract mixin class _$AlertTransactionCopyWith<$Res> implements $AlertTransactionCopyWith<$Res> {
  factory _$AlertTransactionCopyWith(_AlertTransaction value, $Res Function(_AlertTransaction) _then) = __$AlertTransactionCopyWithImpl;
@override @useResult
$Res call({
 int transactionId, String code, bool isPrimary, double amount, String currencyCode
});




}
/// @nodoc
class __$AlertTransactionCopyWithImpl<$Res>
    implements _$AlertTransactionCopyWith<$Res> {
  __$AlertTransactionCopyWithImpl(this._self, this._then);

  final _AlertTransaction _self;
  final $Res Function(_AlertTransaction) _then;

/// Create a copy of AlertTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactionId = null,Object? code = null,Object? isPrimary = null,Object? amount = null,Object? currencyCode = null,}) {
  return _then(_AlertTransaction(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
