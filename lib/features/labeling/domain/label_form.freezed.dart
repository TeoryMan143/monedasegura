// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'label_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LabelForm {

 Verdict? get verdict; List<FraudType> get fraudTypes; ConfidenceLevel? get confidence; Severity? get severity; String get justification;
/// Create a copy of LabelForm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LabelFormCopyWith<LabelForm> get copyWith => _$LabelFormCopyWithImpl<LabelForm>(this as LabelForm, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LabelForm;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LabelForm&&(identical(other.verdict, _this.verdict) || other.verdict == _this.verdict)&&const DeepCollectionEquality().equals(other.fraudTypes, _this.fraudTypes)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence)&&(identical(other.severity, _this.severity) || other.severity == _this.severity)&&(identical(other.justification, _this.justification) || other.justification == _this.justification));
}


@override
int get hashCode {
  final _this = this as LabelForm;
  return Object.hash(runtimeType,_this.verdict,const DeepCollectionEquality().hash(_this.fraudTypes),_this.confidence,_this.severity,_this.justification);
}

@override
String toString() {
  final _this = this as LabelForm;
  return 'LabelForm(verdict: ${_this.verdict}, fraudTypes: ${_this.fraudTypes}, confidence: ${_this.confidence}, severity: ${_this.severity}, justification: ${_this.justification})';
}


}

/// @nodoc
abstract mixin class $LabelFormCopyWith<$Res>  {
  factory $LabelFormCopyWith(LabelForm value, $Res Function(LabelForm) _then) = _$LabelFormCopyWithImpl;
@useResult
$Res call({
 Verdict? verdict, List<FraudType> fraudTypes, ConfidenceLevel? confidence, Severity? severity, String justification
});




}
/// @nodoc
class _$LabelFormCopyWithImpl<$Res>
    implements $LabelFormCopyWith<$Res> {
  _$LabelFormCopyWithImpl(this._self, this._then);

  final LabelForm _self;
  final $Res Function(LabelForm) _then;

/// Create a copy of LabelForm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? verdict = freezed,Object? fraudTypes = null,Object? confidence = freezed,Object? severity = freezed,Object? justification = null,}) {
  return _then(LabelForm(
verdict: freezed == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict?,fraudTypes: null == fraudTypes ? _self.fraudTypes : fraudTypes // ignore: cast_nullable_to_non_nullable
as List<FraudType>,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel?,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as Severity?,justification: null == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LabelForm].
extension LabelFormPatterns on LabelForm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LabelForm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LabelForm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LabelForm value)  $default,){
final _that = this;
switch (_that) {
case _LabelForm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LabelForm value)?  $default,){
final _that = this;
switch (_that) {
case _LabelForm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Verdict? verdict,  List<FraudType> fraudTypes,  ConfidenceLevel? confidence,  Severity? severity,  String justification)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LabelForm() when $default != null:
return $default(_that.verdict,_that.fraudTypes,_that.confidence,_that.severity,_that.justification);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Verdict? verdict,  List<FraudType> fraudTypes,  ConfidenceLevel? confidence,  Severity? severity,  String justification)  $default,) {final _that = this;
switch (_that) {
case _LabelForm():
return $default(_that.verdict,_that.fraudTypes,_that.confidence,_that.severity,_that.justification);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Verdict? verdict,  List<FraudType> fraudTypes,  ConfidenceLevel? confidence,  Severity? severity,  String justification)?  $default,) {final _that = this;
switch (_that) {
case _LabelForm() when $default != null:
return $default(_that.verdict,_that.fraudTypes,_that.confidence,_that.severity,_that.justification);case _:
  return null;

}
}

}

/// @nodoc


class _LabelForm implements LabelForm {
  const _LabelForm({this.verdict,  List<FraudType> fraudTypes = const <FraudType>[], this.confidence, this.severity, this.justification = ''}): _fraudTypes = fraudTypes;
  

@override final  Verdict? verdict;
 final  List<FraudType> _fraudTypes;
@override@JsonKey() List<FraudType> get fraudTypes {
  if (_fraudTypes is EqualUnmodifiableListView) return _fraudTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fraudTypes);
}

@override final  ConfidenceLevel? confidence;
@override final  Severity? severity;
@override@JsonKey() final  String justification;

/// Create a copy of LabelForm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LabelFormCopyWith<_LabelForm> get copyWith => __$LabelFormCopyWithImpl<_LabelForm>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LabelForm&&(identical(other.verdict, verdict) || other.verdict == verdict)&&const DeepCollectionEquality().equals(other.fraudTypes, _fraudTypes)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.justification, justification) || other.justification == justification));
}


@override
int get hashCode {
    return Object.hash(runtimeType,verdict,const DeepCollectionEquality().hash(_fraudTypes),confidence,severity,justification);
}

@override
String toString() {
    return 'LabelForm(verdict: $verdict, fraudTypes: $fraudTypes, confidence: $confidence, severity: $severity, justification: $justification)';
}


}

/// @nodoc
abstract mixin class _$LabelFormCopyWith<$Res> implements $LabelFormCopyWith<$Res> {
  factory _$LabelFormCopyWith(_LabelForm value, $Res Function(_LabelForm) _then) = __$LabelFormCopyWithImpl;
@override @useResult
$Res call({
 Verdict? verdict, List<FraudType> fraudTypes, ConfidenceLevel? confidence, Severity? severity, String justification
});




}
/// @nodoc
class __$LabelFormCopyWithImpl<$Res>
    implements _$LabelFormCopyWith<$Res> {
  __$LabelFormCopyWithImpl(this._self, this._then);

  final _LabelForm _self;
  final $Res Function(_LabelForm) _then;

/// Create a copy of LabelForm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? verdict = freezed,Object? fraudTypes = null,Object? confidence = freezed,Object? severity = freezed,Object? justification = null,}) {
  return _then(_LabelForm(
verdict: freezed == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict?,fraudTypes: null == fraudTypes ? _self._fraudTypes : fraudTypes // ignore: cast_nullable_to_non_nullable
as List<FraudType>,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel?,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as Severity?,justification: null == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
