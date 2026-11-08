// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_label_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BulkLabelState implements DiagnosticableTreeMixin {

 LabelForm get form;/// Fields the analyst changed: only those show their error before applying.
 Set<LabelField> get touched;/// True after the first «Aplicar»: from then on every error shows.
 bool get submitted; SaveState get saveState;/// Why the last save failed. The form keeps its data for the retry.
 Failure? get failure;
/// Create a copy of BulkLabelState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkLabelStateCopyWith<BulkLabelState> get copyWith => _$BulkLabelStateCopyWithImpl<BulkLabelState>(this as BulkLabelState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as BulkLabelState;
  properties
    ..add(DiagnosticsProperty('type', 'BulkLabelState'))
    ..add(DiagnosticsProperty('form', _this.form))..add(DiagnosticsProperty('touched', _this.touched))..add(DiagnosticsProperty('submitted', _this.submitted))..add(DiagnosticsProperty('saveState', _this.saveState))..add(DiagnosticsProperty('failure', _this.failure));
}

@override
bool operator ==(Object other) {
  final _this = this as BulkLabelState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkLabelState&&(identical(other.form, _this.form) || other.form == _this.form)&&const DeepCollectionEquality().equals(other.touched, _this.touched)&&(identical(other.submitted, _this.submitted) || other.submitted == _this.submitted)&&(identical(other.saveState, _this.saveState) || other.saveState == _this.saveState)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as BulkLabelState;
  return Object.hash(runtimeType,_this.form,const DeepCollectionEquality().hash(_this.touched),_this.submitted,_this.saveState,_this.failure);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as BulkLabelState;
  return 'BulkLabelState(form: ${_this.form}, touched: ${_this.touched}, submitted: ${_this.submitted}, saveState: ${_this.saveState}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $BulkLabelStateCopyWith<$Res>  {
  factory $BulkLabelStateCopyWith(BulkLabelState value, $Res Function(BulkLabelState) _then) = _$BulkLabelStateCopyWithImpl;
@useResult
$Res call({
 LabelForm form, Set<LabelField> touched, bool submitted, SaveState saveState, Failure? failure
});


$LabelFormCopyWith<$Res> get form;$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$BulkLabelStateCopyWithImpl<$Res>
    implements $BulkLabelStateCopyWith<$Res> {
  _$BulkLabelStateCopyWithImpl(this._self, this._then);

  final BulkLabelState _self;
  final $Res Function(BulkLabelState) _then;

/// Create a copy of BulkLabelState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? form = null,Object? touched = null,Object? submitted = null,Object? saveState = null,Object? failure = freezed,}) {
  return _then(BulkLabelState(
form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as LabelForm,touched: null == touched ? _self.touched : touched // ignore: cast_nullable_to_non_nullable
as Set<LabelField>,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,saveState: null == saveState ? _self.saveState : saveState // ignore: cast_nullable_to_non_nullable
as SaveState,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of BulkLabelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LabelFormCopyWith<$Res> get form {
  
  return $LabelFormCopyWith<$Res>(_self.form, (value) {
    return _then(_self.copyWith(form: value));
  });
}/// Create a copy of BulkLabelState
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


/// Adds pattern-matching-related methods to [BulkLabelState].
extension BulkLabelStatePatterns on BulkLabelState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkLabelState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkLabelState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkLabelState value)  $default,){
final _that = this;
switch (_that) {
case _BulkLabelState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkLabelState value)?  $default,){
final _that = this;
switch (_that) {
case _BulkLabelState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LabelForm form,  Set<LabelField> touched,  bool submitted,  SaveState saveState,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkLabelState() when $default != null:
return $default(_that.form,_that.touched,_that.submitted,_that.saveState,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LabelForm form,  Set<LabelField> touched,  bool submitted,  SaveState saveState,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _BulkLabelState():
return $default(_that.form,_that.touched,_that.submitted,_that.saveState,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LabelForm form,  Set<LabelField> touched,  bool submitted,  SaveState saveState,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _BulkLabelState() when $default != null:
return $default(_that.form,_that.touched,_that.submitted,_that.saveState,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _BulkLabelState extends BulkLabelState with DiagnosticableTreeMixin {
  const _BulkLabelState({this.form = const LabelForm(),  Set<LabelField> touched = const <LabelField>{}, this.submitted = false, this.saveState = SaveState.idle, this.failure}): _touched = touched,super._();
  

@override@JsonKey() final  LabelForm form;
/// Fields the analyst changed: only those show their error before applying.
 final  Set<LabelField> _touched;
/// Fields the analyst changed: only those show their error before applying.
@override@JsonKey() Set<LabelField> get touched {
  if (_touched is EqualUnmodifiableSetView) return _touched;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_touched);
}

/// True after the first «Aplicar»: from then on every error shows.
@override@JsonKey() final  bool submitted;
@override@JsonKey() final  SaveState saveState;
/// Why the last save failed. The form keeps its data for the retry.
@override final  Failure? failure;

/// Create a copy of BulkLabelState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkLabelStateCopyWith<_BulkLabelState> get copyWith => __$BulkLabelStateCopyWithImpl<_BulkLabelState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'BulkLabelState'))
    ..add(DiagnosticsProperty('form', form))..add(DiagnosticsProperty('touched', touched))..add(DiagnosticsProperty('submitted', submitted))..add(DiagnosticsProperty('saveState', saveState))..add(DiagnosticsProperty('failure', failure));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkLabelState&&(identical(other.form, form) || other.form == form)&&const DeepCollectionEquality().equals(other.touched, _touched)&&(identical(other.submitted, submitted) || other.submitted == submitted)&&(identical(other.saveState, saveState) || other.saveState == saveState)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,form,const DeepCollectionEquality().hash(_touched),submitted,saveState,failure);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'BulkLabelState(form: $form, touched: $touched, submitted: $submitted, saveState: $saveState, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$BulkLabelStateCopyWith<$Res> implements $BulkLabelStateCopyWith<$Res> {
  factory _$BulkLabelStateCopyWith(_BulkLabelState value, $Res Function(_BulkLabelState) _then) = __$BulkLabelStateCopyWithImpl;
@override @useResult
$Res call({
 LabelForm form, Set<LabelField> touched, bool submitted, SaveState saveState, Failure? failure
});


@override $LabelFormCopyWith<$Res> get form;@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$BulkLabelStateCopyWithImpl<$Res>
    implements _$BulkLabelStateCopyWith<$Res> {
  __$BulkLabelStateCopyWithImpl(this._self, this._then);

  final _BulkLabelState _self;
  final $Res Function(_BulkLabelState) _then;

/// Create a copy of BulkLabelState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? form = null,Object? touched = null,Object? submitted = null,Object? saveState = null,Object? failure = freezed,}) {
  return _then(_BulkLabelState(
form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as LabelForm,touched: null == touched ? _self._touched : touched // ignore: cast_nullable_to_non_nullable
as Set<LabelField>,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,saveState: null == saveState ? _self.saveState : saveState // ignore: cast_nullable_to_non_nullable
as SaveState,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of BulkLabelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LabelFormCopyWith<$Res> get form {
  
  return $LabelFormCopyWith<$Res>(_self.form, (value) {
    return _then(_self.copyWith(form: value));
  });
}/// Create a copy of BulkLabelState
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
