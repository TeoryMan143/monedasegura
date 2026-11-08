// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerActivity {

 List<CustomerTransaction> get transactions; List<SecurityEvent> get securityEvents;/// True when the range had more than [CustomerActivity.limit] transactions or events,
/// so only the most recent ones came. The screen says so and suggests a shorter range.
 bool get truncated;
/// Create a copy of CustomerActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerActivityCopyWith<CustomerActivity> get copyWith => _$CustomerActivityCopyWithImpl<CustomerActivity>(this as CustomerActivity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerActivity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerActivity&&const DeepCollectionEquality().equals(other.transactions, _this.transactions)&&const DeepCollectionEquality().equals(other.securityEvents, _this.securityEvents)&&(identical(other.truncated, _this.truncated) || other.truncated == _this.truncated));
}


@override
int get hashCode {
  final _this = this as CustomerActivity;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.transactions),const DeepCollectionEquality().hash(_this.securityEvents),_this.truncated);
}

@override
String toString() {
  final _this = this as CustomerActivity;
  return 'CustomerActivity(transactions: ${_this.transactions}, securityEvents: ${_this.securityEvents}, truncated: ${_this.truncated})';
}


}

/// @nodoc
abstract mixin class $CustomerActivityCopyWith<$Res>  {
  factory $CustomerActivityCopyWith(CustomerActivity value, $Res Function(CustomerActivity) _then) = _$CustomerActivityCopyWithImpl;
@useResult
$Res call({
 List<CustomerTransaction> transactions, List<SecurityEvent> securityEvents, bool truncated
});




}
/// @nodoc
class _$CustomerActivityCopyWithImpl<$Res>
    implements $CustomerActivityCopyWith<$Res> {
  _$CustomerActivityCopyWithImpl(this._self, this._then);

  final CustomerActivity _self;
  final $Res Function(CustomerActivity) _then;

/// Create a copy of CustomerActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactions = null,Object? securityEvents = null,Object? truncated = null,}) {
  return _then(CustomerActivity(
transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<CustomerTransaction>,securityEvents: null == securityEvents ? _self.securityEvents : securityEvents // ignore: cast_nullable_to_non_nullable
as List<SecurityEvent>,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerActivity].
extension CustomerActivityPatterns on CustomerActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerActivity value)  $default,){
final _that = this;
switch (_that) {
case _CustomerActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerActivity value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CustomerTransaction> transactions,  List<SecurityEvent> securityEvents,  bool truncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerActivity() when $default != null:
return $default(_that.transactions,_that.securityEvents,_that.truncated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CustomerTransaction> transactions,  List<SecurityEvent> securityEvents,  bool truncated)  $default,) {final _that = this;
switch (_that) {
case _CustomerActivity():
return $default(_that.transactions,_that.securityEvents,_that.truncated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CustomerTransaction> transactions,  List<SecurityEvent> securityEvents,  bool truncated)?  $default,) {final _that = this;
switch (_that) {
case _CustomerActivity() when $default != null:
return $default(_that.transactions,_that.securityEvents,_that.truncated);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerActivity implements CustomerActivity {
  const _CustomerActivity({required  List<CustomerTransaction> transactions, required  List<SecurityEvent> securityEvents, this.truncated = false}): _transactions = transactions,_securityEvents = securityEvents;
  

 final  List<CustomerTransaction> _transactions;
@override List<CustomerTransaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

 final  List<SecurityEvent> _securityEvents;
@override List<SecurityEvent> get securityEvents {
  if (_securityEvents is EqualUnmodifiableListView) return _securityEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_securityEvents);
}

/// True when the range had more than [CustomerActivity.limit] transactions or events,
/// so only the most recent ones came. The screen says so and suggests a shorter range.
@override@JsonKey() final  bool truncated;

/// Create a copy of CustomerActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerActivityCopyWith<_CustomerActivity> get copyWith => __$CustomerActivityCopyWithImpl<_CustomerActivity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerActivity&&const DeepCollectionEquality().equals(other.transactions, _transactions)&&const DeepCollectionEquality().equals(other.securityEvents, _securityEvents)&&(identical(other.truncated, truncated) || other.truncated == truncated));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions),const DeepCollectionEquality().hash(_securityEvents),truncated);
}

@override
String toString() {
    return 'CustomerActivity(transactions: $transactions, securityEvents: $securityEvents, truncated: $truncated)';
}


}

/// @nodoc
abstract mixin class _$CustomerActivityCopyWith<$Res> implements $CustomerActivityCopyWith<$Res> {
  factory _$CustomerActivityCopyWith(_CustomerActivity value, $Res Function(_CustomerActivity) _then) = __$CustomerActivityCopyWithImpl;
@override @useResult
$Res call({
 List<CustomerTransaction> transactions, List<SecurityEvent> securityEvents, bool truncated
});




}
/// @nodoc
class __$CustomerActivityCopyWithImpl<$Res>
    implements _$CustomerActivityCopyWith<$Res> {
  __$CustomerActivityCopyWithImpl(this._self, this._then);

  final _CustomerActivity _self;
  final $Res Function(_CustomerActivity) _then;

/// Create a copy of CustomerActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactions = null,Object? securityEvents = null,Object? truncated = null,}) {
  return _then(_CustomerActivity(
transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<CustomerTransaction>,securityEvents: null == securityEvents ? _self._securityEvents : securityEvents // ignore: cast_nullable_to_non_nullable
as List<SecurityEvent>,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
