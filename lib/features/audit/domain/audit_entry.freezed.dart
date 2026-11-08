// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditEntry {

@JsonKey(fromJson: AuditAction.fromDb) AuditAction get action; String get analystId;/// From the embedded `analyst:analysts(full_name)`.
@JsonKey(readValue: _readAnalystName) String get analystName; DateTime get createdAt;/// Null when the label was created.
 Map<String, dynamic>? get oldValue; Map<String, dynamic>? get newValue;/// True for a change made in this session that the database does not have yet.
@JsonKey(includeFromJson: false) bool get fromSession;
/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditEntryCopyWith<AuditEntry> get copyWith => _$AuditEntryCopyWithImpl<AuditEntry>(this as AuditEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AuditEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditEntry&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.analystId, _this.analystId) || other.analystId == _this.analystId)&&(identical(other.analystName, _this.analystName) || other.analystName == _this.analystName)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.oldValue, _this.oldValue)&&const DeepCollectionEquality().equals(other.newValue, _this.newValue)&&(identical(other.fromSession, _this.fromSession) || other.fromSession == _this.fromSession));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuditEntry;
  return Object.hash(runtimeType,_this.action,_this.analystId,_this.analystName,_this.createdAt,const DeepCollectionEquality().hash(_this.oldValue),const DeepCollectionEquality().hash(_this.newValue),_this.fromSession);
}

@override
String toString() {
  final _this = this as AuditEntry;
  return 'AuditEntry(action: ${_this.action}, analystId: ${_this.analystId}, analystName: ${_this.analystName}, createdAt: ${_this.createdAt}, oldValue: ${_this.oldValue}, newValue: ${_this.newValue}, fromSession: ${_this.fromSession})';
}


}

/// @nodoc
abstract mixin class $AuditEntryCopyWith<$Res>  {
  factory $AuditEntryCopyWith(AuditEntry value, $Res Function(AuditEntry) _then) = _$AuditEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: AuditAction.fromDb) AuditAction action, String analystId,@JsonKey(readValue: _readAnalystName) String analystName, DateTime createdAt, Map<String, dynamic>? oldValue, Map<String, dynamic>? newValue,@JsonKey(includeFromJson: false) bool fromSession
});




}
/// @nodoc
class _$AuditEntryCopyWithImpl<$Res>
    implements $AuditEntryCopyWith<$Res> {
  _$AuditEntryCopyWithImpl(this._self, this._then);

  final AuditEntry _self;
  final $Res Function(AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? analystId = null,Object? analystName = null,Object? createdAt = null,Object? oldValue = freezed,Object? newValue = freezed,Object? fromSession = null,}) {
  return _then(AuditEntry(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AuditAction,analystId: null == analystId ? _self.analystId : analystId // ignore: cast_nullable_to_non_nullable
as String,analystName: null == analystName ? _self.analystName : analystName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,oldValue: freezed == oldValue ? _self.oldValue : oldValue // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,newValue: freezed == newValue ? _self.newValue : newValue // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,fromSession: null == fromSession ? _self.fromSession : fromSession // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditEntry].
extension AuditEntryPatterns on AuditEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditEntry value)  $default,){
final _that = this;
switch (_that) {
case _AuditEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: AuditAction.fromDb)  AuditAction action,  String analystId, @JsonKey(readValue: _readAnalystName)  String analystName,  DateTime createdAt,  Map<String, dynamic>? oldValue,  Map<String, dynamic>? newValue, @JsonKey(includeFromJson: false)  bool fromSession)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.action,_that.analystId,_that.analystName,_that.createdAt,_that.oldValue,_that.newValue,_that.fromSession);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: AuditAction.fromDb)  AuditAction action,  String analystId, @JsonKey(readValue: _readAnalystName)  String analystName,  DateTime createdAt,  Map<String, dynamic>? oldValue,  Map<String, dynamic>? newValue, @JsonKey(includeFromJson: false)  bool fromSession)  $default,) {final _that = this;
switch (_that) {
case _AuditEntry():
return $default(_that.action,_that.analystId,_that.analystName,_that.createdAt,_that.oldValue,_that.newValue,_that.fromSession);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: AuditAction.fromDb)  AuditAction action,  String analystId, @JsonKey(readValue: _readAnalystName)  String analystName,  DateTime createdAt,  Map<String, dynamic>? oldValue,  Map<String, dynamic>? newValue, @JsonKey(includeFromJson: false)  bool fromSession)?  $default,) {final _that = this;
switch (_that) {
case _AuditEntry() when $default != null:
return $default(_that.action,_that.analystId,_that.analystName,_that.createdAt,_that.oldValue,_that.newValue,_that.fromSession);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _AuditEntry extends AuditEntry {
  const _AuditEntry({@JsonKey(fromJson: AuditAction.fromDb) required this.action, required this.analystId, @JsonKey(readValue: _readAnalystName) required this.analystName, required this.createdAt,  Map<String, dynamic>? oldValue,  Map<String, dynamic>? newValue, @JsonKey(includeFromJson: false) this.fromSession = false}): _oldValue = oldValue,_newValue = newValue,super._();
  factory _AuditEntry.fromJson(Map<String, dynamic> json) => _$AuditEntryFromJson(json);

@override@JsonKey(fromJson: AuditAction.fromDb) final  AuditAction action;
@override final  String analystId;
/// From the embedded `analyst:analysts(full_name)`.
@override@JsonKey(readValue: _readAnalystName) final  String analystName;
@override final  DateTime createdAt;
/// Null when the label was created.
 final  Map<String, dynamic>? _oldValue;
/// Null when the label was created.
@override Map<String, dynamic>? get oldValue {
  final value = _oldValue;
  if (value == null) return null;
  if (_oldValue is EqualUnmodifiableMapView) return _oldValue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _newValue;
@override Map<String, dynamic>? get newValue {
  final value = _newValue;
  if (value == null) return null;
  if (_newValue is EqualUnmodifiableMapView) return _newValue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// True for a change made in this session that the database does not have yet.
@override@JsonKey(includeFromJson: false) final  bool fromSession;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditEntryCopyWith<_AuditEntry> get copyWith => __$AuditEntryCopyWithImpl<_AuditEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditEntry&&(identical(other.action, action) || other.action == action)&&(identical(other.analystId, analystId) || other.analystId == analystId)&&(identical(other.analystName, analystName) || other.analystName == analystName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.oldValue, _oldValue)&&const DeepCollectionEquality().equals(other.newValue, _newValue)&&(identical(other.fromSession, fromSession) || other.fromSession == fromSession));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,action,analystId,analystName,createdAt,const DeepCollectionEquality().hash(_oldValue),const DeepCollectionEquality().hash(_newValue),fromSession);
}

@override
String toString() {
    return 'AuditEntry(action: $action, analystId: $analystId, analystName: $analystName, createdAt: $createdAt, oldValue: $oldValue, newValue: $newValue, fromSession: $fromSession)';
}


}

/// @nodoc
abstract mixin class _$AuditEntryCopyWith<$Res> implements $AuditEntryCopyWith<$Res> {
  factory _$AuditEntryCopyWith(_AuditEntry value, $Res Function(_AuditEntry) _then) = __$AuditEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: AuditAction.fromDb) AuditAction action, String analystId,@JsonKey(readValue: _readAnalystName) String analystName, DateTime createdAt, Map<String, dynamic>? oldValue, Map<String, dynamic>? newValue,@JsonKey(includeFromJson: false) bool fromSession
});




}
/// @nodoc
class __$AuditEntryCopyWithImpl<$Res>
    implements _$AuditEntryCopyWith<$Res> {
  __$AuditEntryCopyWithImpl(this._self, this._then);

  final _AuditEntry _self;
  final $Res Function(_AuditEntry) _then;

/// Create a copy of AuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? analystId = null,Object? analystName = null,Object? createdAt = null,Object? oldValue = freezed,Object? newValue = freezed,Object? fromSession = null,}) {
  return _then(_AuditEntry(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AuditAction,analystId: null == analystId ? _self.analystId : analystId // ignore: cast_nullable_to_non_nullable
as String,analystName: null == analystName ? _self.analystName : analystName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,oldValue: freezed == oldValue ? _self._oldValue : oldValue // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,newValue: freezed == newValue ? _self._newValue : newValue // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,fromSession: null == fromSession ? _self.fromSession : fromSession // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
