// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fraud_kpis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FraudKpis {

 int get labeledCount; int get totalCount; int get fraudCount; double get committedAmountCop;
/// Create a copy of FraudKpis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FraudKpisCopyWith<FraudKpis> get copyWith => _$FraudKpisCopyWithImpl<FraudKpis>(this as FraudKpis, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FraudKpis;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FraudKpis&&(identical(other.labeledCount, _this.labeledCount) || other.labeledCount == _this.labeledCount)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&(identical(other.fraudCount, _this.fraudCount) || other.fraudCount == _this.fraudCount)&&(identical(other.committedAmountCop, _this.committedAmountCop) || other.committedAmountCop == _this.committedAmountCop));
}


@override
int get hashCode {
  final _this = this as FraudKpis;
  return Object.hash(runtimeType,_this.labeledCount,_this.totalCount,_this.fraudCount,_this.committedAmountCop);
}

@override
String toString() {
  final _this = this as FraudKpis;
  return 'FraudKpis(labeledCount: ${_this.labeledCount}, totalCount: ${_this.totalCount}, fraudCount: ${_this.fraudCount}, committedAmountCop: ${_this.committedAmountCop})';
}


}

/// @nodoc
abstract mixin class $FraudKpisCopyWith<$Res>  {
  factory $FraudKpisCopyWith(FraudKpis value, $Res Function(FraudKpis) _then) = _$FraudKpisCopyWithImpl;
@useResult
$Res call({
 int labeledCount, int totalCount, int fraudCount, double committedAmountCop
});




}
/// @nodoc
class _$FraudKpisCopyWithImpl<$Res>
    implements $FraudKpisCopyWith<$Res> {
  _$FraudKpisCopyWithImpl(this._self, this._then);

  final FraudKpis _self;
  final $Res Function(FraudKpis) _then;

/// Create a copy of FraudKpis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? labeledCount = null,Object? totalCount = null,Object? fraudCount = null,Object? committedAmountCop = null,}) {
  return _then(FraudKpis(
labeledCount: null == labeledCount ? _self.labeledCount : labeledCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,fraudCount: null == fraudCount ? _self.fraudCount : fraudCount // ignore: cast_nullable_to_non_nullable
as int,committedAmountCop: null == committedAmountCop ? _self.committedAmountCop : committedAmountCop // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FraudKpis].
extension FraudKpisPatterns on FraudKpis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FraudKpis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FraudKpis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FraudKpis value)  $default,){
final _that = this;
switch (_that) {
case _FraudKpis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FraudKpis value)?  $default,){
final _that = this;
switch (_that) {
case _FraudKpis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int labeledCount,  int totalCount,  int fraudCount,  double committedAmountCop)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FraudKpis() when $default != null:
return $default(_that.labeledCount,_that.totalCount,_that.fraudCount,_that.committedAmountCop);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int labeledCount,  int totalCount,  int fraudCount,  double committedAmountCop)  $default,) {final _that = this;
switch (_that) {
case _FraudKpis():
return $default(_that.labeledCount,_that.totalCount,_that.fraudCount,_that.committedAmountCop);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int labeledCount,  int totalCount,  int fraudCount,  double committedAmountCop)?  $default,) {final _that = this;
switch (_that) {
case _FraudKpis() when $default != null:
return $default(_that.labeledCount,_that.totalCount,_that.fraudCount,_that.committedAmountCop);case _:
  return null;

}
}

}

/// @nodoc


class _FraudKpis extends FraudKpis {
  const _FraudKpis({required this.labeledCount, required this.totalCount, required this.fraudCount, required this.committedAmountCop}): super._();
  

@override final  int labeledCount;
@override final  int totalCount;
@override final  int fraudCount;
@override final  double committedAmountCop;

/// Create a copy of FraudKpis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FraudKpisCopyWith<_FraudKpis> get copyWith => __$FraudKpisCopyWithImpl<_FraudKpis>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FraudKpis&&(identical(other.labeledCount, labeledCount) || other.labeledCount == labeledCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.fraudCount, fraudCount) || other.fraudCount == fraudCount)&&(identical(other.committedAmountCop, committedAmountCop) || other.committedAmountCop == committedAmountCop));
}


@override
int get hashCode {
    return Object.hash(runtimeType,labeledCount,totalCount,fraudCount,committedAmountCop);
}

@override
String toString() {
    return 'FraudKpis(labeledCount: $labeledCount, totalCount: $totalCount, fraudCount: $fraudCount, committedAmountCop: $committedAmountCop)';
}


}

/// @nodoc
abstract mixin class _$FraudKpisCopyWith<$Res> implements $FraudKpisCopyWith<$Res> {
  factory _$FraudKpisCopyWith(_FraudKpis value, $Res Function(_FraudKpis) _then) = __$FraudKpisCopyWithImpl;
@override @useResult
$Res call({
 int labeledCount, int totalCount, int fraudCount, double committedAmountCop
});




}
/// @nodoc
class __$FraudKpisCopyWithImpl<$Res>
    implements _$FraudKpisCopyWith<$Res> {
  __$FraudKpisCopyWithImpl(this._self, this._then);

  final _FraudKpis _self;
  final $Res Function(_FraudKpis) _then;

/// Create a copy of FraudKpis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? labeledCount = null,Object? totalCount = null,Object? fraudCount = null,Object? committedAmountCop = null,}) {
  return _then(_FraudKpis(
labeledCount: null == labeledCount ? _self.labeledCount : labeledCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,fraudCount: null == fraudCount ? _self.fraudCount : fraudCount // ignore: cast_nullable_to_non_nullable
as int,committedAmountCop: null == committedAmountCop ? _self.committedAmountCop : committedAmountCop // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
