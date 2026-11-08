// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolve_alert_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResolveAlertState {

/// «Confirmar» is the one that comes selected.
 ResolveAlertAction get action;/// Confidence, severity and justification have no default: the analyst chooses them,
/// because these labels train the model.
 LabelForm get form;/// The involved transactions the analyst unchecked. They keep the label they have.
 Set<int> get excludedTransactionIds;/// Fields the analyst changed: only those show their error before sending.
 Set<LabelField> get touched;/// True after the first send: from then on every error shows.
 bool get submitted; SaveState get saveState;/// Why the last send failed. The form keeps its data for the retry.
 Failure? get failure;
/// Create a copy of ResolveAlertState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolveAlertStateCopyWith<ResolveAlertState> get copyWith => _$ResolveAlertStateCopyWithImpl<ResolveAlertState>(this as ResolveAlertState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ResolveAlertState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolveAlertState&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.form, _this.form) || other.form == _this.form)&&const DeepCollectionEquality().equals(other.excludedTransactionIds, _this.excludedTransactionIds)&&const DeepCollectionEquality().equals(other.touched, _this.touched)&&(identical(other.submitted, _this.submitted) || other.submitted == _this.submitted)&&(identical(other.saveState, _this.saveState) || other.saveState == _this.saveState)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as ResolveAlertState;
  return Object.hash(runtimeType,_this.action,_this.form,const DeepCollectionEquality().hash(_this.excludedTransactionIds),const DeepCollectionEquality().hash(_this.touched),_this.submitted,_this.saveState,_this.failure);
}

@override
String toString() {
  final _this = this as ResolveAlertState;
  return 'ResolveAlertState(action: ${_this.action}, form: ${_this.form}, excludedTransactionIds: ${_this.excludedTransactionIds}, touched: ${_this.touched}, submitted: ${_this.submitted}, saveState: ${_this.saveState}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $ResolveAlertStateCopyWith<$Res>  {
  factory $ResolveAlertStateCopyWith(ResolveAlertState value, $Res Function(ResolveAlertState) _then) = _$ResolveAlertStateCopyWithImpl;
@useResult
$Res call({
 ResolveAlertAction action, LabelForm form, Set<int> excludedTransactionIds, Set<LabelField> touched, bool submitted, SaveState saveState, Failure? failure
});


$LabelFormCopyWith<$Res> get form;$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$ResolveAlertStateCopyWithImpl<$Res>
    implements $ResolveAlertStateCopyWith<$Res> {
  _$ResolveAlertStateCopyWithImpl(this._self, this._then);

  final ResolveAlertState _self;
  final $Res Function(ResolveAlertState) _then;

/// Create a copy of ResolveAlertState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? form = null,Object? excludedTransactionIds = null,Object? touched = null,Object? submitted = null,Object? saveState = null,Object? failure = freezed,}) {
  return _then(ResolveAlertState(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as ResolveAlertAction,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as LabelForm,excludedTransactionIds: null == excludedTransactionIds ? _self.excludedTransactionIds : excludedTransactionIds // ignore: cast_nullable_to_non_nullable
as Set<int>,touched: null == touched ? _self.touched : touched // ignore: cast_nullable_to_non_nullable
as Set<LabelField>,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,saveState: null == saveState ? _self.saveState : saveState // ignore: cast_nullable_to_non_nullable
as SaveState,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of ResolveAlertState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LabelFormCopyWith<$Res> get form {
  
  return $LabelFormCopyWith<$Res>(_self.form, (value) {
    return _then(_self.copyWith(form: value));
  });
}/// Create a copy of ResolveAlertState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}


/// Adds pattern-matching-related methods to [ResolveAlertState].
extension ResolveAlertStatePatterns on ResolveAlertState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResolveAlertState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResolveAlertState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResolveAlertState value)  $default,){
final _that = this;
switch (_that) {
case _ResolveAlertState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResolveAlertState value)?  $default,){
final _that = this;
switch (_that) {
case _ResolveAlertState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ResolveAlertAction action,  LabelForm form,  Set<int> excludedTransactionIds,  Set<LabelField> touched,  bool submitted,  SaveState saveState,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResolveAlertState() when $default != null:
return $default(_that.action,_that.form,_that.excludedTransactionIds,_that.touched,_that.submitted,_that.saveState,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ResolveAlertAction action,  LabelForm form,  Set<int> excludedTransactionIds,  Set<LabelField> touched,  bool submitted,  SaveState saveState,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ResolveAlertState():
return $default(_that.action,_that.form,_that.excludedTransactionIds,_that.touched,_that.submitted,_that.saveState,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ResolveAlertAction action,  LabelForm form,  Set<int> excludedTransactionIds,  Set<LabelField> touched,  bool submitted,  SaveState saveState,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ResolveAlertState() when $default != null:
return $default(_that.action,_that.form,_that.excludedTransactionIds,_that.touched,_that.submitted,_that.saveState,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ResolveAlertState extends ResolveAlertState {
  const _ResolveAlertState({this.action = ResolveAlertAction.confirm, this.form = const LabelForm(),  Set<int> excludedTransactionIds = const <int>{},  Set<LabelField> touched = const <LabelField>{}, this.submitted = false, this.saveState = SaveState.idle, this.failure}): _excludedTransactionIds = excludedTransactionIds,_touched = touched,super._();
  

/// «Confirmar» is the one that comes selected.
@override@JsonKey() final  ResolveAlertAction action;
/// Confidence, severity and justification have no default: the analyst chooses them,
/// because these labels train the model.
@override@JsonKey() final  LabelForm form;
/// The involved transactions the analyst unchecked. They keep the label they have.
 final  Set<int> _excludedTransactionIds;
/// The involved transactions the analyst unchecked. They keep the label they have.
@override@JsonKey() Set<int> get excludedTransactionIds {
  if (_excludedTransactionIds is EqualUnmodifiableSetView) return _excludedTransactionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_excludedTransactionIds);
}

/// Fields the analyst changed: only those show their error before sending.
 final  Set<LabelField> _touched;
/// Fields the analyst changed: only those show their error before sending.
@override@JsonKey() Set<LabelField> get touched {
  if (_touched is EqualUnmodifiableSetView) return _touched;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_touched);
}

/// True after the first send: from then on every error shows.
@override@JsonKey() final  bool submitted;
@override@JsonKey() final  SaveState saveState;
/// Why the last send failed. The form keeps its data for the retry.
@override final  Failure? failure;

/// Create a copy of ResolveAlertState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResolveAlertStateCopyWith<_ResolveAlertState> get copyWith => __$ResolveAlertStateCopyWithImpl<_ResolveAlertState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResolveAlertState&&(identical(other.action, action) || other.action == action)&&(identical(other.form, form) || other.form == form)&&const DeepCollectionEquality().equals(other.excludedTransactionIds, _excludedTransactionIds)&&const DeepCollectionEquality().equals(other.touched, _touched)&&(identical(other.submitted, submitted) || other.submitted == submitted)&&(identical(other.saveState, saveState) || other.saveState == saveState)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,action,form,const DeepCollectionEquality().hash(_excludedTransactionIds),const DeepCollectionEquality().hash(_touched),submitted,saveState,failure);
}

@override
String toString() {
    return 'ResolveAlertState(action: $action, form: $form, excludedTransactionIds: $excludedTransactionIds, touched: $touched, submitted: $submitted, saveState: $saveState, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ResolveAlertStateCopyWith<$Res> implements $ResolveAlertStateCopyWith<$Res> {
  factory _$ResolveAlertStateCopyWith(_ResolveAlertState value, $Res Function(_ResolveAlertState) _then) = __$ResolveAlertStateCopyWithImpl;
@override @useResult
$Res call({
 ResolveAlertAction action, LabelForm form, Set<int> excludedTransactionIds, Set<LabelField> touched, bool submitted, SaveState saveState, Failure? failure
});


@override $LabelFormCopyWith<$Res> get form;@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$ResolveAlertStateCopyWithImpl<$Res>
    implements _$ResolveAlertStateCopyWith<$Res> {
  __$ResolveAlertStateCopyWithImpl(this._self, this._then);

  final _ResolveAlertState _self;
  final $Res Function(_ResolveAlertState) _then;

/// Create a copy of ResolveAlertState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? form = null,Object? excludedTransactionIds = null,Object? touched = null,Object? submitted = null,Object? saveState = null,Object? failure = freezed,}) {
  return _then(_ResolveAlertState(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as ResolveAlertAction,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as LabelForm,excludedTransactionIds: null == excludedTransactionIds ? _self._excludedTransactionIds : excludedTransactionIds // ignore: cast_nullable_to_non_nullable
as Set<int>,touched: null == touched ? _self._touched : touched // ignore: cast_nullable_to_non_nullable
as Set<LabelField>,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,saveState: null == saveState ? _self.saveState : saveState // ignore: cast_nullable_to_non_nullable
as SaveState,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of ResolveAlertState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LabelFormCopyWith<$Res> get form {
  
  return $LabelFormCopyWith<$Res>(_self.form, (value) {
    return _then(_self.copyWith(form: value));
  });
}/// Create a copy of ResolveAlertState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
