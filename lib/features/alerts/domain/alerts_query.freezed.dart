// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alerts_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlertsQuery {

 int? get minScore; FraudType? get suggestedType; AlertStatus get status; int get page; int get pageSize;
/// Create a copy of AlertsQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertsQueryCopyWith<AlertsQuery> get copyWith => _$AlertsQueryCopyWithImpl<AlertsQuery>(this as AlertsQuery, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AlertsQuery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertsQuery&&(identical(other.minScore, _this.minScore) || other.minScore == _this.minScore)&&(identical(other.suggestedType, _this.suggestedType) || other.suggestedType == _this.suggestedType)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.pageSize, _this.pageSize) || other.pageSize == _this.pageSize));
}


@override
int get hashCode {
  final _this = this as AlertsQuery;
  return Object.hash(runtimeType,_this.minScore,_this.suggestedType,_this.status,_this.page,_this.pageSize);
}

@override
String toString() {
  final _this = this as AlertsQuery;
  return 'AlertsQuery(minScore: ${_this.minScore}, suggestedType: ${_this.suggestedType}, status: ${_this.status}, page: ${_this.page}, pageSize: ${_this.pageSize})';
}


}

/// @nodoc
abstract mixin class $AlertsQueryCopyWith<$Res>  {
  factory $AlertsQueryCopyWith(AlertsQuery value, $Res Function(AlertsQuery) _then) = _$AlertsQueryCopyWithImpl;
@useResult
$Res call({
 int? minScore, FraudType? suggestedType, AlertStatus status, int page, int pageSize
});




}
/// @nodoc
class _$AlertsQueryCopyWithImpl<$Res>
    implements $AlertsQueryCopyWith<$Res> {
  _$AlertsQueryCopyWithImpl(this._self, this._then);

  final AlertsQuery _self;
  final $Res Function(AlertsQuery) _then;

/// Create a copy of AlertsQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minScore = freezed,Object? suggestedType = freezed,Object? status = null,Object? page = null,Object? pageSize = null,}) {
  return _then(AlertsQuery(
minScore: freezed == minScore ? _self.minScore : minScore // ignore: cast_nullable_to_non_nullable
as int?,suggestedType: freezed == suggestedType ? _self.suggestedType : suggestedType // ignore: cast_nullable_to_non_nullable
as FraudType?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlertStatus,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertsQuery].
extension AlertsQueryPatterns on AlertsQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertsQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertsQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertsQuery value)  $default,){
final _that = this;
switch (_that) {
case _AlertsQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertsQuery value)?  $default,){
final _that = this;
switch (_that) {
case _AlertsQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? minScore,  FraudType? suggestedType,  AlertStatus status,  int page,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertsQuery() when $default != null:
return $default(_that.minScore,_that.suggestedType,_that.status,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? minScore,  FraudType? suggestedType,  AlertStatus status,  int page,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _AlertsQuery():
return $default(_that.minScore,_that.suggestedType,_that.status,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? minScore,  FraudType? suggestedType,  AlertStatus status,  int page,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _AlertsQuery() when $default != null:
return $default(_that.minScore,_that.suggestedType,_that.status,_that.page,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc


class _AlertsQuery extends AlertsQuery {
  const _AlertsQuery({this.minScore, this.suggestedType, this.status = AlertStatus.pending, this.page = 1, this.pageSize = 25}): super._();
  

@override final  int? minScore;
@override final  FraudType? suggestedType;
@override@JsonKey() final  AlertStatus status;
@override@JsonKey() final  int page;
@override@JsonKey() final  int pageSize;

/// Create a copy of AlertsQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertsQueryCopyWith<_AlertsQuery> get copyWith => __$AlertsQueryCopyWithImpl<_AlertsQuery>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertsQuery&&(identical(other.minScore, minScore) || other.minScore == minScore)&&(identical(other.suggestedType, suggestedType) || other.suggestedType == suggestedType)&&(identical(other.status, status) || other.status == status)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode {
    return Object.hash(runtimeType,minScore,suggestedType,status,page,pageSize);
}

@override
String toString() {
    return 'AlertsQuery(minScore: $minScore, suggestedType: $suggestedType, status: $status, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$AlertsQueryCopyWith<$Res> implements $AlertsQueryCopyWith<$Res> {
  factory _$AlertsQueryCopyWith(_AlertsQuery value, $Res Function(_AlertsQuery) _then) = __$AlertsQueryCopyWithImpl;
@override @useResult
$Res call({
 int? minScore, FraudType? suggestedType, AlertStatus status, int page, int pageSize
});




}
/// @nodoc
class __$AlertsQueryCopyWithImpl<$Res>
    implements _$AlertsQueryCopyWith<$Res> {
  __$AlertsQueryCopyWithImpl(this._self, this._then);

  final _AlertsQuery _self;
  final $Res Function(_AlertsQuery) _then;

/// Create a copy of AlertsQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minScore = freezed,Object? suggestedType = freezed,Object? status = null,Object? page = null,Object? pageSize = null,}) {
  return _then(_AlertsQuery(
minScore: freezed == minScore ? _self.minScore : minScore // ignore: cast_nullable_to_non_nullable
as int?,suggestedType: freezed == suggestedType ? _self.suggestedType : suggestedType // ignore: cast_nullable_to_non_nullable
as FraudType?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlertStatus,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
