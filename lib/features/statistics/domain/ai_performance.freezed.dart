// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_performance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiPerformance {

/// Alerts where the analyst agreed with the AI.
 int get confirmed;/// Alerts the analyst discarded as not fraud.
 int get rejected;/// Alerts where it was fraud, but of another type than the AI said.
 int get reclassified;/// One entry per fraud type the AI suggested.
 List<TypePrecision> get precisionByType;
/// Create a copy of AiPerformance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiPerformanceCopyWith<AiPerformance> get copyWith => _$AiPerformanceCopyWithImpl<AiPerformance>(this as AiPerformance, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AiPerformance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiPerformance&&(identical(other.confirmed, _this.confirmed) || other.confirmed == _this.confirmed)&&(identical(other.rejected, _this.rejected) || other.rejected == _this.rejected)&&(identical(other.reclassified, _this.reclassified) || other.reclassified == _this.reclassified)&&const DeepCollectionEquality().equals(other.precisionByType, _this.precisionByType));
}


@override
int get hashCode {
  final _this = this as AiPerformance;
  return Object.hash(runtimeType,_this.confirmed,_this.rejected,_this.reclassified,const DeepCollectionEquality().hash(_this.precisionByType));
}

@override
String toString() {
  final _this = this as AiPerformance;
  return 'AiPerformance(confirmed: ${_this.confirmed}, rejected: ${_this.rejected}, reclassified: ${_this.reclassified}, precisionByType: ${_this.precisionByType})';
}


}

/// @nodoc
abstract mixin class $AiPerformanceCopyWith<$Res>  {
  factory $AiPerformanceCopyWith(AiPerformance value, $Res Function(AiPerformance) _then) = _$AiPerformanceCopyWithImpl;
@useResult
$Res call({
 int confirmed, int rejected, int reclassified, List<TypePrecision> precisionByType
});




}
/// @nodoc
class _$AiPerformanceCopyWithImpl<$Res>
    implements $AiPerformanceCopyWith<$Res> {
  _$AiPerformanceCopyWithImpl(this._self, this._then);

  final AiPerformance _self;
  final $Res Function(AiPerformance) _then;

/// Create a copy of AiPerformance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? confirmed = null,Object? rejected = null,Object? reclassified = null,Object? precisionByType = null,}) {
  return _then(AiPerformance(
confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,reclassified: null == reclassified ? _self.reclassified : reclassified // ignore: cast_nullable_to_non_nullable
as int,precisionByType: null == precisionByType ? _self.precisionByType : precisionByType // ignore: cast_nullable_to_non_nullable
as List<TypePrecision>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiPerformance].
extension AiPerformancePatterns on AiPerformance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiPerformance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiPerformance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiPerformance value)  $default,){
final _that = this;
switch (_that) {
case _AiPerformance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiPerformance value)?  $default,){
final _that = this;
switch (_that) {
case _AiPerformance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int confirmed,  int rejected,  int reclassified,  List<TypePrecision> precisionByType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiPerformance() when $default != null:
return $default(_that.confirmed,_that.rejected,_that.reclassified,_that.precisionByType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int confirmed,  int rejected,  int reclassified,  List<TypePrecision> precisionByType)  $default,) {final _that = this;
switch (_that) {
case _AiPerformance():
return $default(_that.confirmed,_that.rejected,_that.reclassified,_that.precisionByType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int confirmed,  int rejected,  int reclassified,  List<TypePrecision> precisionByType)?  $default,) {final _that = this;
switch (_that) {
case _AiPerformance() when $default != null:
return $default(_that.confirmed,_that.rejected,_that.reclassified,_that.precisionByType);case _:
  return null;

}
}

}

/// @nodoc


class _AiPerformance extends AiPerformance {
  const _AiPerformance({required this.confirmed, required this.rejected, required this.reclassified,  List<TypePrecision> precisionByType = const <TypePrecision>[]}): _precisionByType = precisionByType,super._();
  

/// Alerts where the analyst agreed with the AI.
@override final  int confirmed;
/// Alerts the analyst discarded as not fraud.
@override final  int rejected;
/// Alerts where it was fraud, but of another type than the AI said.
@override final  int reclassified;
/// One entry per fraud type the AI suggested.
 final  List<TypePrecision> _precisionByType;
/// One entry per fraud type the AI suggested.
@override@JsonKey() List<TypePrecision> get precisionByType {
  if (_precisionByType is EqualUnmodifiableListView) return _precisionByType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_precisionByType);
}


/// Create a copy of AiPerformance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiPerformanceCopyWith<_AiPerformance> get copyWith => __$AiPerformanceCopyWithImpl<_AiPerformance>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiPerformance&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed)&&(identical(other.rejected, rejected) || other.rejected == rejected)&&(identical(other.reclassified, reclassified) || other.reclassified == reclassified)&&const DeepCollectionEquality().equals(other.precisionByType, _precisionByType));
}


@override
int get hashCode {
    return Object.hash(runtimeType,confirmed,rejected,reclassified,const DeepCollectionEquality().hash(_precisionByType));
}

@override
String toString() {
    return 'AiPerformance(confirmed: $confirmed, rejected: $rejected, reclassified: $reclassified, precisionByType: $precisionByType)';
}


}

/// @nodoc
abstract mixin class _$AiPerformanceCopyWith<$Res> implements $AiPerformanceCopyWith<$Res> {
  factory _$AiPerformanceCopyWith(_AiPerformance value, $Res Function(_AiPerformance) _then) = __$AiPerformanceCopyWithImpl;
@override @useResult
$Res call({
 int confirmed, int rejected, int reclassified, List<TypePrecision> precisionByType
});




}
/// @nodoc
class __$AiPerformanceCopyWithImpl<$Res>
    implements _$AiPerformanceCopyWith<$Res> {
  __$AiPerformanceCopyWithImpl(this._self, this._then);

  final _AiPerformance _self;
  final $Res Function(_AiPerformance) _then;

/// Create a copy of AiPerformance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? confirmed = null,Object? rejected = null,Object? reclassified = null,Object? precisionByType = null,}) {
  return _then(_AiPerformance(
confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,reclassified: null == reclassified ? _self.reclassified : reclassified // ignore: cast_nullable_to_non_nullable
as int,precisionByType: null == precisionByType ? _self._precisionByType : precisionByType // ignore: cast_nullable_to_non_nullable
as List<TypePrecision>,
  ));
}


}

// dart format on
