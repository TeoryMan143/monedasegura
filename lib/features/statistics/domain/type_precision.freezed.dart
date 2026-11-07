// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'type_precision.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TypePrecision {

/// The code of the suggested type: the key of a `FraudType`.
 String get typeCode;/// From 0 to 1.
 double get precision;/// Resolved alerts the precision is measured on. A precision over three alerts is
/// not worth the same as one over three hundred.
 int get alerts;
/// Create a copy of TypePrecision
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TypePrecisionCopyWith<TypePrecision> get copyWith => _$TypePrecisionCopyWithImpl<TypePrecision>(this as TypePrecision, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TypePrecision;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TypePrecision&&(identical(other.typeCode, _this.typeCode) || other.typeCode == _this.typeCode)&&(identical(other.precision, _this.precision) || other.precision == _this.precision)&&(identical(other.alerts, _this.alerts) || other.alerts == _this.alerts));
}


@override
int get hashCode {
  final _this = this as TypePrecision;
  return Object.hash(runtimeType,_this.typeCode,_this.precision,_this.alerts);
}

@override
String toString() {
  final _this = this as TypePrecision;
  return 'TypePrecision(typeCode: ${_this.typeCode}, precision: ${_this.precision}, alerts: ${_this.alerts})';
}


}

/// @nodoc
abstract mixin class $TypePrecisionCopyWith<$Res>  {
  factory $TypePrecisionCopyWith(TypePrecision value, $Res Function(TypePrecision) _then) = _$TypePrecisionCopyWithImpl;
@useResult
$Res call({
 String typeCode, double precision, int alerts
});




}
/// @nodoc
class _$TypePrecisionCopyWithImpl<$Res>
    implements $TypePrecisionCopyWith<$Res> {
  _$TypePrecisionCopyWithImpl(this._self, this._then);

  final TypePrecision _self;
  final $Res Function(TypePrecision) _then;

/// Create a copy of TypePrecision
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? typeCode = null,Object? precision = null,Object? alerts = null,}) {
  return _then(TypePrecision(
typeCode: null == typeCode ? _self.typeCode : typeCode // ignore: cast_nullable_to_non_nullable
as String,precision: null == precision ? _self.precision : precision // ignore: cast_nullable_to_non_nullable
as double,alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TypePrecision].
extension TypePrecisionPatterns on TypePrecision {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TypePrecision value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TypePrecision() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TypePrecision value)  $default,){
final _that = this;
switch (_that) {
case _TypePrecision():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TypePrecision value)?  $default,){
final _that = this;
switch (_that) {
case _TypePrecision() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String typeCode,  double precision,  int alerts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TypePrecision() when $default != null:
return $default(_that.typeCode,_that.precision,_that.alerts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String typeCode,  double precision,  int alerts)  $default,) {final _that = this;
switch (_that) {
case _TypePrecision():
return $default(_that.typeCode,_that.precision,_that.alerts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String typeCode,  double precision,  int alerts)?  $default,) {final _that = this;
switch (_that) {
case _TypePrecision() when $default != null:
return $default(_that.typeCode,_that.precision,_that.alerts);case _:
  return null;

}
}

}

/// @nodoc


class _TypePrecision implements TypePrecision {
  const _TypePrecision({required this.typeCode, required this.precision, required this.alerts});
  

/// The code of the suggested type: the key of a `FraudType`.
@override final  String typeCode;
/// From 0 to 1.
@override final  double precision;
/// Resolved alerts the precision is measured on. A precision over three alerts is
/// not worth the same as one over three hundred.
@override final  int alerts;

/// Create a copy of TypePrecision
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypePrecisionCopyWith<_TypePrecision> get copyWith => __$TypePrecisionCopyWithImpl<_TypePrecision>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypePrecision&&(identical(other.typeCode, typeCode) || other.typeCode == typeCode)&&(identical(other.precision, precision) || other.precision == precision)&&(identical(other.alerts, alerts) || other.alerts == alerts));
}


@override
int get hashCode {
    return Object.hash(runtimeType,typeCode,precision,alerts);
}

@override
String toString() {
    return 'TypePrecision(typeCode: $typeCode, precision: $precision, alerts: $alerts)';
}


}

/// @nodoc
abstract mixin class _$TypePrecisionCopyWith<$Res> implements $TypePrecisionCopyWith<$Res> {
  factory _$TypePrecisionCopyWith(_TypePrecision value, $Res Function(_TypePrecision) _then) = __$TypePrecisionCopyWithImpl;
@override @useResult
$Res call({
 String typeCode, double precision, int alerts
});




}
/// @nodoc
class __$TypePrecisionCopyWithImpl<$Res>
    implements _$TypePrecisionCopyWith<$Res> {
  __$TypePrecisionCopyWithImpl(this._self, this._then);

  final _TypePrecision _self;
  final $Res Function(_TypePrecision) _then;

/// Create a copy of TypePrecision
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? typeCode = null,Object? precision = null,Object? alerts = null,}) {
  return _then(_TypePrecision(
typeCode: null == typeCode ? _self.typeCode : typeCode // ignore: cast_nullable_to_non_nullable
as String,precision: null == precision ? _self.precision : precision // ignore: cast_nullable_to_non_nullable
as double,alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
