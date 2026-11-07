// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classification_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClassificationState {

 ClassificationTarget get target; LabelForm get form;/// Fields the analyst changed: only those show their error before saving.
 Set<LabelField> get touched;/// True after the first «Guardar»: from then on every error shows.
 bool get submitted; SaveState get saveState;/// Why the last save failed (E-03). The form keeps its data.
 Failure? get failure;
/// Create a copy of ClassificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassificationStateCopyWith<ClassificationState> get copyWith => _$ClassificationStateCopyWithImpl<ClassificationState>(this as ClassificationState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ClassificationState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassificationState&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.form, _this.form) || other.form == _this.form)&&const DeepCollectionEquality().equals(other.touched, _this.touched)&&(identical(other.submitted, _this.submitted) || other.submitted == _this.submitted)&&(identical(other.saveState, _this.saveState) || other.saveState == _this.saveState)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as ClassificationState;
  return Object.hash(runtimeType,_this.target,_this.form,const DeepCollectionEquality().hash(_this.touched),_this.submitted,_this.saveState,_this.failure);
}

@override
String toString() {
  final _this = this as ClassificationState;
  return 'ClassificationState(target: ${_this.target}, form: ${_this.form}, touched: ${_this.touched}, submitted: ${_this.submitted}, saveState: ${_this.saveState}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $ClassificationStateCopyWith<$Res>  {
  factory $ClassificationStateCopyWith(ClassificationState value, $Res Function(ClassificationState) _then) = _$ClassificationStateCopyWithImpl;
@useResult
$Res call({
 ClassificationTarget target, LabelForm form, Set<LabelField> touched, bool submitted, SaveState saveState, Failure? failure
});


$ClassificationTargetCopyWith<$Res> get target;$LabelFormCopyWith<$Res> get form;$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$ClassificationStateCopyWithImpl<$Res>
    implements $ClassificationStateCopyWith<$Res> {
  _$ClassificationStateCopyWithImpl(this._self, this._then);

  final ClassificationState _self;
  final $Res Function(ClassificationState) _then;

/// Create a copy of ClassificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? target = null,Object? form = null,Object? touched = null,Object? submitted = null,Object? saveState = null,Object? failure = freezed,}) {
  return _then(ClassificationState(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as ClassificationTarget,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as LabelForm,touched: null == touched ? _self.touched : touched // ignore: cast_nullable_to_non_nullable
as Set<LabelField>,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,saveState: null == saveState ? _self.saveState : saveState // ignore: cast_nullable_to_non_nullable
as SaveState,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of ClassificationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClassificationTargetCopyWith<$Res> get target {
  
  return $ClassificationTargetCopyWith<$Res>(_self.target, (value) {
    return _then(_self.copyWith(target: value));
  });
}/// Create a copy of ClassificationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LabelFormCopyWith<$Res> get form {
  
  return $LabelFormCopyWith<$Res>(_self.form, (value) {
    return _then(_self.copyWith(form: value));
  });
}/// Create a copy of ClassificationState
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


/// Adds pattern-matching-related methods to [ClassificationState].
extension ClassificationStatePatterns on ClassificationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassificationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassificationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassificationState value)  $default,){
final _that = this;
switch (_that) {
case _ClassificationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassificationState value)?  $default,){
final _that = this;
switch (_that) {
case _ClassificationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ClassificationTarget target,  LabelForm form,  Set<LabelField> touched,  bool submitted,  SaveState saveState,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassificationState() when $default != null:
return $default(_that.target,_that.form,_that.touched,_that.submitted,_that.saveState,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ClassificationTarget target,  LabelForm form,  Set<LabelField> touched,  bool submitted,  SaveState saveState,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ClassificationState():
return $default(_that.target,_that.form,_that.touched,_that.submitted,_that.saveState,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ClassificationTarget target,  LabelForm form,  Set<LabelField> touched,  bool submitted,  SaveState saveState,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ClassificationState() when $default != null:
return $default(_that.target,_that.form,_that.touched,_that.submitted,_that.saveState,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ClassificationState extends ClassificationState {
  const _ClassificationState({required this.target, required this.form,  Set<LabelField> touched = const <LabelField>{}, this.submitted = false, this.saveState = SaveState.idle, this.failure}): _touched = touched,super._();
  

@override final  ClassificationTarget target;
@override final  LabelForm form;
/// Fields the analyst changed: only those show their error before saving.
 final  Set<LabelField> _touched;
/// Fields the analyst changed: only those show their error before saving.
@override@JsonKey() Set<LabelField> get touched {
  if (_touched is EqualUnmodifiableSetView) return _touched;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_touched);
}

/// True after the first «Guardar»: from then on every error shows.
@override@JsonKey() final  bool submitted;
@override@JsonKey() final  SaveState saveState;
/// Why the last save failed (E-03). The form keeps its data.
@override final  Failure? failure;

/// Create a copy of ClassificationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassificationStateCopyWith<_ClassificationState> get copyWith => __$ClassificationStateCopyWithImpl<_ClassificationState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassificationState&&(identical(other.target, target) || other.target == target)&&(identical(other.form, form) || other.form == form)&&const DeepCollectionEquality().equals(other.touched, _touched)&&(identical(other.submitted, submitted) || other.submitted == submitted)&&(identical(other.saveState, saveState) || other.saveState == saveState)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,target,form,const DeepCollectionEquality().hash(_touched),submitted,saveState,failure);
}

@override
String toString() {
    return 'ClassificationState(target: $target, form: $form, touched: $touched, submitted: $submitted, saveState: $saveState, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ClassificationStateCopyWith<$Res> implements $ClassificationStateCopyWith<$Res> {
  factory _$ClassificationStateCopyWith(_ClassificationState value, $Res Function(_ClassificationState) _then) = __$ClassificationStateCopyWithImpl;
@override @useResult
$Res call({
 ClassificationTarget target, LabelForm form, Set<LabelField> touched, bool submitted, SaveState saveState, Failure? failure
});


@override $ClassificationTargetCopyWith<$Res> get target;@override $LabelFormCopyWith<$Res> get form;@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$ClassificationStateCopyWithImpl<$Res>
    implements _$ClassificationStateCopyWith<$Res> {
  __$ClassificationStateCopyWithImpl(this._self, this._then);

  final _ClassificationState _self;
  final $Res Function(_ClassificationState) _then;

/// Create a copy of ClassificationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? target = null,Object? form = null,Object? touched = null,Object? submitted = null,Object? saveState = null,Object? failure = freezed,}) {
  return _then(_ClassificationState(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as ClassificationTarget,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as LabelForm,touched: null == touched ? _self._touched : touched // ignore: cast_nullable_to_non_nullable
as Set<LabelField>,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,saveState: null == saveState ? _self.saveState : saveState // ignore: cast_nullable_to_non_nullable
as SaveState,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of ClassificationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClassificationTargetCopyWith<$Res> get target {
  
  return $ClassificationTargetCopyWith<$Res>(_self.target, (value) {
    return _then(_self.copyWith(target: value));
  });
}/// Create a copy of ClassificationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LabelFormCopyWith<$Res> get form {
  
  return $LabelFormCopyWith<$Res>(_self.form, (value) {
    return _then(_self.copyWith(form: value));
  });
}/// Create a copy of ClassificationState
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
