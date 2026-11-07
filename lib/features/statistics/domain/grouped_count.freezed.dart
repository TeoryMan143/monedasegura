// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grouped_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupedCount {

 String get key; int get count;
/// Create a copy of GroupedCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupedCountCopyWith<GroupedCount> get copyWith => _$GroupedCountCopyWithImpl<GroupedCount>(this as GroupedCount, _$identity);

  /// Serializes this GroupedCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GroupedCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupedCount&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GroupedCount;
  return Object.hash(runtimeType,_this.key,_this.count);
}

@override
String toString() {
  final _this = this as GroupedCount;
  return 'GroupedCount(key: ${_this.key}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $GroupedCountCopyWith<$Res>  {
  factory $GroupedCountCopyWith(GroupedCount value, $Res Function(GroupedCount) _then) = _$GroupedCountCopyWithImpl;
@useResult
$Res call({
 String key, int count
});




}
/// @nodoc
class _$GroupedCountCopyWithImpl<$Res>
    implements $GroupedCountCopyWith<$Res> {
  _$GroupedCountCopyWithImpl(this._self, this._then);

  final GroupedCount _self;
  final $Res Function(GroupedCount) _then;

/// Create a copy of GroupedCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? count = null,}) {
  return _then(GroupedCount(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupedCount].
extension GroupedCountPatterns on GroupedCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupedCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupedCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupedCount value)  $default,){
final _that = this;
switch (_that) {
case _GroupedCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupedCount value)?  $default,){
final _that = this;
switch (_that) {
case _GroupedCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupedCount() when $default != null:
return $default(_that.key,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  int count)  $default,) {final _that = this;
switch (_that) {
case _GroupedCount():
return $default(_that.key,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  int count)?  $default,) {final _that = this;
switch (_that) {
case _GroupedCount() when $default != null:
return $default(_that.key,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupedCount implements GroupedCount {
  const _GroupedCount({required this.key, required this.count});
  factory _GroupedCount.fromJson(Map<String, dynamic> json) => _$GroupedCountFromJson(json);

@override final  String key;
@override final  int count;

/// Create a copy of GroupedCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupedCountCopyWith<_GroupedCount> get copyWith => __$GroupedCountCopyWithImpl<_GroupedCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupedCountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupedCount&&(identical(other.key, key) || other.key == key)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,count);
}

@override
String toString() {
    return 'GroupedCount(key: $key, count: $count)';
}


}

/// @nodoc
abstract mixin class _$GroupedCountCopyWith<$Res> implements $GroupedCountCopyWith<$Res> {
  factory _$GroupedCountCopyWith(_GroupedCount value, $Res Function(_GroupedCount) _then) = __$GroupedCountCopyWithImpl;
@override @useResult
$Res call({
 String key, int count
});




}
/// @nodoc
class __$GroupedCountCopyWithImpl<$Res>
    implements _$GroupedCountCopyWith<$Res> {
  __$GroupedCountCopyWithImpl(this._self, this._then);

  final _GroupedCount _self;
  final $Res Function(_GroupedCount) _then;

/// Create a copy of GroupedCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? count = null,}) {
  return _then(_GroupedCount(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
