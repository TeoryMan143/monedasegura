// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimelinePoint {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelinePoint);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TimelinePoint()';
}


}

/// @nodoc
class $TimelinePointCopyWith<$Res>  {
$TimelinePointCopyWith(TimelinePoint _, $Res Function(TimelinePoint) __);
}


/// Adds pattern-matching-related methods to [TimelinePoint].
extension TimelinePointPatterns on TimelinePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TransactionPoint value)?  transaction,TResult Function( SecurityEventPoint value)?  securityEvent,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TransactionPoint() when transaction != null:
return transaction(_that);case SecurityEventPoint() when securityEvent != null:
return securityEvent(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TransactionPoint value)  transaction,required TResult Function( SecurityEventPoint value)  securityEvent,}){
final _that = this;
switch (_that) {
case TransactionPoint():
return transaction(_that);case SecurityEventPoint():
return securityEvent(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TransactionPoint value)?  transaction,TResult? Function( SecurityEventPoint value)?  securityEvent,}){
final _that = this;
switch (_that) {
case TransactionPoint() when transaction != null:
return transaction(_that);case SecurityEventPoint() when securityEvent != null:
return securityEvent(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( CustomerTransaction transaction,  Set<ActivityAnomaly> anomalies)?  transaction,TResult Function( SecurityEvent event)?  securityEvent,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TransactionPoint() when transaction != null:
return transaction(_that.transaction,_that.anomalies);case SecurityEventPoint() when securityEvent != null:
return securityEvent(_that.event);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( CustomerTransaction transaction,  Set<ActivityAnomaly> anomalies)  transaction,required TResult Function( SecurityEvent event)  securityEvent,}) {final _that = this;
switch (_that) {
case TransactionPoint():
return transaction(_that.transaction,_that.anomalies);case SecurityEventPoint():
return securityEvent(_that.event);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( CustomerTransaction transaction,  Set<ActivityAnomaly> anomalies)?  transaction,TResult? Function( SecurityEvent event)?  securityEvent,}) {final _that = this;
switch (_that) {
case TransactionPoint() when transaction != null:
return transaction(_that.transaction,_that.anomalies);case SecurityEventPoint() when securityEvent != null:
return securityEvent(_that.event);case _:
  return null;

}
}

}

/// @nodoc


class TransactionPoint extends TimelinePoint {
  const TransactionPoint(this.transaction, { Set<ActivityAnomaly> anomalies = const <ActivityAnomaly>{}}): _anomalies = anomalies,super._();
  

 final  CustomerTransaction transaction;
 final  Set<ActivityAnomaly> _anomalies;
@JsonKey() Set<ActivityAnomaly> get anomalies {
  if (_anomalies is EqualUnmodifiableSetView) return _anomalies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_anomalies);
}


/// Create a copy of TimelinePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionPointCopyWith<TransactionPoint> get copyWith => _$TransactionPointCopyWithImpl<TransactionPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionPoint&&(identical(other.transaction, transaction) || other.transaction == transaction)&&const DeepCollectionEquality().equals(other.anomalies, _anomalies));
}


@override
int get hashCode {
    return Object.hash(runtimeType,transaction,const DeepCollectionEquality().hash(_anomalies));
}

@override
String toString() {
    return 'TimelinePoint.transaction(transaction: $transaction, anomalies: $anomalies)';
}


}

/// @nodoc
abstract mixin class $TransactionPointCopyWith<$Res> implements $TimelinePointCopyWith<$Res> {
  factory $TransactionPointCopyWith(TransactionPoint value, $Res Function(TransactionPoint) _then) = _$TransactionPointCopyWithImpl;
@useResult
$Res call({
 CustomerTransaction transaction, Set<ActivityAnomaly> anomalies
});


$CustomerTransactionCopyWith<$Res> get transaction;

}
/// @nodoc
class _$TransactionPointCopyWithImpl<$Res>
    implements $TransactionPointCopyWith<$Res> {
  _$TransactionPointCopyWithImpl(this._self, this._then);

  final TransactionPoint _self;
  final $Res Function(TransactionPoint) _then;

/// Create a copy of TimelinePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transaction = null,Object? anomalies = null,}) {
  return _then(TransactionPoint(
null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as CustomerTransaction,anomalies: null == anomalies ? _self._anomalies : anomalies // ignore: cast_nullable_to_non_nullable
as Set<ActivityAnomaly>,
  ));
}

/// Create a copy of TimelinePoint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerTransactionCopyWith<$Res> get transaction {
  
  return $CustomerTransactionCopyWith<$Res>(_self.transaction, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}

/// @nodoc


class SecurityEventPoint extends TimelinePoint {
  const SecurityEventPoint(this.event): super._();
  

 final  SecurityEvent event;

/// Create a copy of TimelinePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecurityEventPointCopyWith<SecurityEventPoint> get copyWith => _$SecurityEventPointCopyWithImpl<SecurityEventPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SecurityEventPoint&&(identical(other.event, event) || other.event == event));
}


@override
int get hashCode {
    return Object.hash(runtimeType,event);
}

@override
String toString() {
    return 'TimelinePoint.securityEvent(event: $event)';
}


}

/// @nodoc
abstract mixin class $SecurityEventPointCopyWith<$Res> implements $TimelinePointCopyWith<$Res> {
  factory $SecurityEventPointCopyWith(SecurityEventPoint value, $Res Function(SecurityEventPoint) _then) = _$SecurityEventPointCopyWithImpl;
@useResult
$Res call({
 SecurityEvent event
});


$SecurityEventCopyWith<$Res> get event;

}
/// @nodoc
class _$SecurityEventPointCopyWithImpl<$Res>
    implements $SecurityEventPointCopyWith<$Res> {
  _$SecurityEventPointCopyWithImpl(this._self, this._then);

  final SecurityEventPoint _self;
  final $Res Function(SecurityEventPoint) _then;

/// Create a copy of TimelinePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? event = null,}) {
  return _then(SecurityEventPoint(
null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as SecurityEvent,
  ));
}

/// Create a copy of TimelinePoint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SecurityEventCopyWith<$Res> get event {
  
  return $SecurityEventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

// dart format on
