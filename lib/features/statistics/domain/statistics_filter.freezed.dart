// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StatisticsFilter {

 DateTime? get fromDate; DateTime? get toDate; String? get countryCode;
/// Create a copy of StatisticsFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatisticsFilterCopyWith<StatisticsFilter> get copyWith => _$StatisticsFilterCopyWithImpl<StatisticsFilter>(this as StatisticsFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StatisticsFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatisticsFilter&&(identical(other.fromDate, _this.fromDate) || other.fromDate == _this.fromDate)&&(identical(other.toDate, _this.toDate) || other.toDate == _this.toDate)&&(identical(other.countryCode, _this.countryCode) || other.countryCode == _this.countryCode));
}


@override
int get hashCode {
  final _this = this as StatisticsFilter;
  return Object.hash(runtimeType,_this.fromDate,_this.toDate,_this.countryCode);
}

@override
String toString() {
  final _this = this as StatisticsFilter;
  return 'StatisticsFilter(fromDate: ${_this.fromDate}, toDate: ${_this.toDate}, countryCode: ${_this.countryCode})';
}


}

/// @nodoc
abstract mixin class $StatisticsFilterCopyWith<$Res>  {
  factory $StatisticsFilterCopyWith(StatisticsFilter value, $Res Function(StatisticsFilter) _then) = _$StatisticsFilterCopyWithImpl;
@useResult
$Res call({
 DateTime? fromDate, DateTime? toDate, String? countryCode
});




}
/// @nodoc
class _$StatisticsFilterCopyWithImpl<$Res>
    implements $StatisticsFilterCopyWith<$Res> {
  _$StatisticsFilterCopyWithImpl(this._self, this._then);

  final StatisticsFilter _self;
  final $Res Function(StatisticsFilter) _then;

/// Create a copy of StatisticsFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromDate = freezed,Object? toDate = freezed,Object? countryCode = freezed,}) {
  return _then(StatisticsFilter(
fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StatisticsFilter].
extension StatisticsFilterPatterns on StatisticsFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatisticsFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatisticsFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatisticsFilter value)  $default,){
final _that = this;
switch (_that) {
case _StatisticsFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatisticsFilter value)?  $default,){
final _that = this;
switch (_that) {
case _StatisticsFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? fromDate,  DateTime? toDate,  String? countryCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatisticsFilter() when $default != null:
return $default(_that.fromDate,_that.toDate,_that.countryCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? fromDate,  DateTime? toDate,  String? countryCode)  $default,) {final _that = this;
switch (_that) {
case _StatisticsFilter():
return $default(_that.fromDate,_that.toDate,_that.countryCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? fromDate,  DateTime? toDate,  String? countryCode)?  $default,) {final _that = this;
switch (_that) {
case _StatisticsFilter() when $default != null:
return $default(_that.fromDate,_that.toDate,_that.countryCode);case _:
  return null;

}
}

}

/// @nodoc


class _StatisticsFilter extends StatisticsFilter {
  const _StatisticsFilter({this.fromDate, this.toDate, this.countryCode}): super._();
  

@override final  DateTime? fromDate;
@override final  DateTime? toDate;
@override final  String? countryCode;

/// Create a copy of StatisticsFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatisticsFilterCopyWith<_StatisticsFilter> get copyWith => __$StatisticsFilterCopyWithImpl<_StatisticsFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatisticsFilter&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,fromDate,toDate,countryCode);
}

@override
String toString() {
    return 'StatisticsFilter(fromDate: $fromDate, toDate: $toDate, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class _$StatisticsFilterCopyWith<$Res> implements $StatisticsFilterCopyWith<$Res> {
  factory _$StatisticsFilterCopyWith(_StatisticsFilter value, $Res Function(_StatisticsFilter) _then) = __$StatisticsFilterCopyWithImpl;
@override @useResult
$Res call({
 DateTime? fromDate, DateTime? toDate, String? countryCode
});




}
/// @nodoc
class __$StatisticsFilterCopyWithImpl<$Res>
    implements _$StatisticsFilterCopyWith<$Res> {
  __$StatisticsFilterCopyWithImpl(this._self, this._then);

  final _StatisticsFilter _self;
  final $Res Function(_StatisticsFilter) _then;

/// Create a copy of StatisticsFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromDate = freezed,Object? toDate = freezed,Object? countryCode = freezed,}) {
  return _then(_StatisticsFilter(
fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
