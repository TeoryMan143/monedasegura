// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'range_totals.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RangeTotals {

@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) Currency get currency; num get totalIn; num get totalOut; num get net; int get transactionCount;
/// Create a copy of RangeTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RangeTotalsCopyWith<RangeTotals> get copyWith => _$RangeTotalsCopyWithImpl<RangeTotals>(this as RangeTotals, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RangeTotals;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RangeTotals&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.totalIn, _this.totalIn) || other.totalIn == _this.totalIn)&&(identical(other.totalOut, _this.totalOut) || other.totalOut == _this.totalOut)&&(identical(other.net, _this.net) || other.net == _this.net)&&(identical(other.transactionCount, _this.transactionCount) || other.transactionCount == _this.transactionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RangeTotals;
  return Object.hash(runtimeType,_this.currency,_this.totalIn,_this.totalOut,_this.net,_this.transactionCount);
}

@override
String toString() {
  final _this = this as RangeTotals;
  return 'RangeTotals(currency: ${_this.currency}, totalIn: ${_this.totalIn}, totalOut: ${_this.totalOut}, net: ${_this.net}, transactionCount: ${_this.transactionCount})';
}


}

/// @nodoc
abstract mixin class $RangeTotalsCopyWith<$Res>  {
  factory $RangeTotalsCopyWith(RangeTotals value, $Res Function(RangeTotals) _then) = _$RangeTotalsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) Currency currency, num totalIn, num totalOut, num net, int transactionCount
});




}
/// @nodoc
class _$RangeTotalsCopyWithImpl<$Res>
    implements $RangeTotalsCopyWith<$Res> {
  _$RangeTotalsCopyWithImpl(this._self, this._then);

  final RangeTotals _self;
  final $Res Function(RangeTotals) _then;

/// Create a copy of RangeTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? totalIn = null,Object? totalOut = null,Object? net = null,Object? transactionCount = null,}) {
  return _then(RangeTotals(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,totalIn: null == totalIn ? _self.totalIn : totalIn // ignore: cast_nullable_to_non_nullable
as num,totalOut: null == totalOut ? _self.totalOut : totalOut // ignore: cast_nullable_to_non_nullable
as num,net: null == net ? _self.net : net // ignore: cast_nullable_to_non_nullable
as num,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RangeTotals].
extension RangeTotalsPatterns on RangeTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RangeTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RangeTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RangeTotals value)  $default,){
final _that = this;
switch (_that) {
case _RangeTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RangeTotals value)?  $default,){
final _that = this;
switch (_that) {
case _RangeTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'currency_code', fromJson: Currency.fromDb)  Currency currency,  num totalIn,  num totalOut,  num net,  int transactionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RangeTotals() when $default != null:
return $default(_that.currency,_that.totalIn,_that.totalOut,_that.net,_that.transactionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'currency_code', fromJson: Currency.fromDb)  Currency currency,  num totalIn,  num totalOut,  num net,  int transactionCount)  $default,) {final _that = this;
switch (_that) {
case _RangeTotals():
return $default(_that.currency,_that.totalIn,_that.totalOut,_that.net,_that.transactionCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'currency_code', fromJson: Currency.fromDb)  Currency currency,  num totalIn,  num totalOut,  num net,  int transactionCount)?  $default,) {final _that = this;
switch (_that) {
case _RangeTotals() when $default != null:
return $default(_that.currency,_that.totalIn,_that.totalOut,_that.net,_that.transactionCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _RangeTotals implements RangeTotals {
  const _RangeTotals({@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) required this.currency, required this.totalIn, required this.totalOut, required this.net, required this.transactionCount});
  factory _RangeTotals.fromJson(Map<String, dynamic> json) => _$RangeTotalsFromJson(json);

@override@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) final  Currency currency;
@override final  num totalIn;
@override final  num totalOut;
@override final  num net;
@override final  int transactionCount;

/// Create a copy of RangeTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RangeTotalsCopyWith<_RangeTotals> get copyWith => __$RangeTotalsCopyWithImpl<_RangeTotals>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RangeTotals&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.totalIn, totalIn) || other.totalIn == totalIn)&&(identical(other.totalOut, totalOut) || other.totalOut == totalOut)&&(identical(other.net, net) || other.net == net)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,currency,totalIn,totalOut,net,transactionCount);
}

@override
String toString() {
    return 'RangeTotals(currency: $currency, totalIn: $totalIn, totalOut: $totalOut, net: $net, transactionCount: $transactionCount)';
}


}

/// @nodoc
abstract mixin class _$RangeTotalsCopyWith<$Res> implements $RangeTotalsCopyWith<$Res> {
  factory _$RangeTotalsCopyWith(_RangeTotals value, $Res Function(_RangeTotals) _then) = __$RangeTotalsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) Currency currency, num totalIn, num totalOut, num net, int transactionCount
});




}
/// @nodoc
class __$RangeTotalsCopyWithImpl<$Res>
    implements _$RangeTotalsCopyWith<$Res> {
  __$RangeTotalsCopyWithImpl(this._self, this._then);

  final _RangeTotals _self;
  final $Res Function(_RangeTotals) _then;

/// Create a copy of RangeTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? totalIn = null,Object? totalOut = null,Object? net = null,Object? transactionCount = null,}) {
  return _then(_RangeTotals(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,totalIn: null == totalIn ? _self.totalIn : totalIn // ignore: cast_nullable_to_non_nullable
as num,totalOut: null == totalOut ? _self.totalOut : totalOut // ignore: cast_nullable_to_non_nullable
as num,net: null == net ? _self.net : net // ignore: cast_nullable_to_non_nullable
as num,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
