// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'label_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LabelHistory {

 List<AuditEntry> get entries; List<HistoryAlert> get alerts;
/// Create a copy of LabelHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LabelHistoryCopyWith<LabelHistory> get copyWith => _$LabelHistoryCopyWithImpl<LabelHistory>(this as LabelHistory, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LabelHistory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LabelHistory&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&const DeepCollectionEquality().equals(other.alerts, _this.alerts));
}


@override
int get hashCode {
  final _this = this as LabelHistory;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries),const DeepCollectionEquality().hash(_this.alerts));
}

@override
String toString() {
  final _this = this as LabelHistory;
  return 'LabelHistory(entries: ${_this.entries}, alerts: ${_this.alerts})';
}


}

/// @nodoc
abstract mixin class $LabelHistoryCopyWith<$Res>  {
  factory $LabelHistoryCopyWith(LabelHistory value, $Res Function(LabelHistory) _then) = _$LabelHistoryCopyWithImpl;
@useResult
$Res call({
 List<AuditEntry> entries, List<HistoryAlert> alerts
});




}
/// @nodoc
class _$LabelHistoryCopyWithImpl<$Res>
    implements $LabelHistoryCopyWith<$Res> {
  _$LabelHistoryCopyWithImpl(this._self, this._then);

  final LabelHistory _self;
  final $Res Function(LabelHistory) _then;

/// Create a copy of LabelHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? alerts = null,}) {
  return _then(LabelHistory(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<AuditEntry>,alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<HistoryAlert>,
  ));
}

}


/// Adds pattern-matching-related methods to [LabelHistory].
extension LabelHistoryPatterns on LabelHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LabelHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LabelHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LabelHistory value)  $default,){
final _that = this;
switch (_that) {
case _LabelHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LabelHistory value)?  $default,){
final _that = this;
switch (_that) {
case _LabelHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AuditEntry> entries,  List<HistoryAlert> alerts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LabelHistory() when $default != null:
return $default(_that.entries,_that.alerts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AuditEntry> entries,  List<HistoryAlert> alerts)  $default,) {final _that = this;
switch (_that) {
case _LabelHistory():
return $default(_that.entries,_that.alerts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AuditEntry> entries,  List<HistoryAlert> alerts)?  $default,) {final _that = this;
switch (_that) {
case _LabelHistory() when $default != null:
return $default(_that.entries,_that.alerts);case _:
  return null;

}
}

}

/// @nodoc


class _LabelHistory implements LabelHistory {
  const _LabelHistory({required  List<AuditEntry> entries,  List<HistoryAlert> alerts = const <HistoryAlert>[]}): _entries = entries,_alerts = alerts;
  

 final  List<AuditEntry> _entries;
@override List<AuditEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

 final  List<HistoryAlert> _alerts;
@override@JsonKey() List<HistoryAlert> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}


/// Create a copy of LabelHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LabelHistoryCopyWith<_LabelHistory> get copyWith => __$LabelHistoryCopyWithImpl<_LabelHistory>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LabelHistory&&const DeepCollectionEquality().equals(other.entries, _entries)&&const DeepCollectionEquality().equals(other.alerts, _alerts));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),const DeepCollectionEquality().hash(_alerts));
}

@override
String toString() {
    return 'LabelHistory(entries: $entries, alerts: $alerts)';
}


}

/// @nodoc
abstract mixin class _$LabelHistoryCopyWith<$Res> implements $LabelHistoryCopyWith<$Res> {
  factory _$LabelHistoryCopyWith(_LabelHistory value, $Res Function(_LabelHistory) _then) = __$LabelHistoryCopyWithImpl;
@override @useResult
$Res call({
 List<AuditEntry> entries, List<HistoryAlert> alerts
});




}
/// @nodoc
class __$LabelHistoryCopyWithImpl<$Res>
    implements _$LabelHistoryCopyWith<$Res> {
  __$LabelHistoryCopyWithImpl(this._self, this._then);

  final _LabelHistory _self;
  final $Res Function(_LabelHistory) _then;

/// Create a copy of LabelHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? alerts = null,}) {
  return _then(_LabelHistory(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<AuditEntry>,alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<HistoryAlert>,
  ));
}


}

/// @nodoc
mixin _$HistoryAlert {

 String get code; int get score; DateTime get generatedAt;
/// Create a copy of HistoryAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryAlertCopyWith<HistoryAlert> get copyWith => _$HistoryAlertCopyWithImpl<HistoryAlert>(this as HistoryAlert, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HistoryAlert;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryAlert&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt));
}


@override
int get hashCode {
  final _this = this as HistoryAlert;
  return Object.hash(runtimeType,_this.code,_this.score,_this.generatedAt);
}

@override
String toString() {
  final _this = this as HistoryAlert;
  return 'HistoryAlert(code: ${_this.code}, score: ${_this.score}, generatedAt: ${_this.generatedAt})';
}


}

/// @nodoc
abstract mixin class $HistoryAlertCopyWith<$Res>  {
  factory $HistoryAlertCopyWith(HistoryAlert value, $Res Function(HistoryAlert) _then) = _$HistoryAlertCopyWithImpl;
@useResult
$Res call({
 String code, int score, DateTime generatedAt
});




}
/// @nodoc
class _$HistoryAlertCopyWithImpl<$Res>
    implements $HistoryAlertCopyWith<$Res> {
  _$HistoryAlertCopyWithImpl(this._self, this._then);

  final HistoryAlert _self;
  final $Res Function(HistoryAlert) _then;

/// Create a copy of HistoryAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? score = null,Object? generatedAt = null,}) {
  return _then(HistoryAlert(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryAlert].
extension HistoryAlertPatterns on HistoryAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryAlert value)  $default,){
final _that = this;
switch (_that) {
case _HistoryAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryAlert value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  int score,  DateTime generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryAlert() when $default != null:
return $default(_that.code,_that.score,_that.generatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  int score,  DateTime generatedAt)  $default,) {final _that = this;
switch (_that) {
case _HistoryAlert():
return $default(_that.code,_that.score,_that.generatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  int score,  DateTime generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _HistoryAlert() when $default != null:
return $default(_that.code,_that.score,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _HistoryAlert implements HistoryAlert {
  const _HistoryAlert({required this.code, required this.score, required this.generatedAt});
  

@override final  String code;
@override final  int score;
@override final  DateTime generatedAt;

/// Create a copy of HistoryAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryAlertCopyWith<_HistoryAlert> get copyWith => __$HistoryAlertCopyWithImpl<_HistoryAlert>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryAlert&&(identical(other.code, code) || other.code == code)&&(identical(other.score, score) || other.score == score)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,score,generatedAt);
}

@override
String toString() {
    return 'HistoryAlert(code: $code, score: $score, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$HistoryAlertCopyWith<$Res> implements $HistoryAlertCopyWith<$Res> {
  factory _$HistoryAlertCopyWith(_HistoryAlert value, $Res Function(_HistoryAlert) _then) = __$HistoryAlertCopyWithImpl;
@override @useResult
$Res call({
 String code, int score, DateTime generatedAt
});




}
/// @nodoc
class __$HistoryAlertCopyWithImpl<$Res>
    implements _$HistoryAlertCopyWith<$Res> {
  __$HistoryAlertCopyWithImpl(this._self, this._then);

  final _HistoryAlert _self;
  final $Res Function(_HistoryAlert) _then;

/// Create a copy of HistoryAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? score = null,Object? generatedAt = null,}) {
  return _then(_HistoryAlert(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
