// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classification_target.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClassificationTarget {

 int get id;/// The readable code, e.g. `TX-48219`.
 String get code; DateTime get occurredAt; TransactionType get type; Channel get channel; double get amount; Currency get currency; String? get merchantName; String? get accountLast4; AccountType? get accountType;/// The strongest AI alert on the transaction, if any.
 TargetAlert? get alert;/// The current label, from the database or saved in this session.
 SavedLabel? get label;
/// Create a copy of ClassificationTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassificationTargetCopyWith<ClassificationTarget> get copyWith => _$ClassificationTargetCopyWithImpl<ClassificationTarget>(this as ClassificationTarget, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ClassificationTarget;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassificationTarget&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.occurredAt, _this.occurredAt) || other.occurredAt == _this.occurredAt)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.channel, _this.channel) || other.channel == _this.channel)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.merchantName, _this.merchantName) || other.merchantName == _this.merchantName)&&(identical(other.accountLast4, _this.accountLast4) || other.accountLast4 == _this.accountLast4)&&(identical(other.accountType, _this.accountType) || other.accountType == _this.accountType)&&(identical(other.alert, _this.alert) || other.alert == _this.alert)&&(identical(other.label, _this.label) || other.label == _this.label));
}


@override
int get hashCode {
  final _this = this as ClassificationTarget;
  return Object.hash(runtimeType,_this.id,_this.code,_this.occurredAt,_this.type,_this.channel,_this.amount,_this.currency,_this.merchantName,_this.accountLast4,_this.accountType,_this.alert,_this.label);
}

@override
String toString() {
  final _this = this as ClassificationTarget;
  return 'ClassificationTarget(id: ${_this.id}, code: ${_this.code}, occurredAt: ${_this.occurredAt}, type: ${_this.type}, channel: ${_this.channel}, amount: ${_this.amount}, currency: ${_this.currency}, merchantName: ${_this.merchantName}, accountLast4: ${_this.accountLast4}, accountType: ${_this.accountType}, alert: ${_this.alert}, label: ${_this.label})';
}


}

/// @nodoc
abstract mixin class $ClassificationTargetCopyWith<$Res>  {
  factory $ClassificationTargetCopyWith(ClassificationTarget value, $Res Function(ClassificationTarget) _then) = _$ClassificationTargetCopyWithImpl;
@useResult
$Res call({
 int id, String code, DateTime occurredAt, TransactionType type, Channel channel, double amount, Currency currency, String? merchantName, String? accountLast4, AccountType? accountType, TargetAlert? alert, SavedLabel? label
});


$TargetAlertCopyWith<$Res>? get alert;$SavedLabelCopyWith<$Res>? get label;

}
/// @nodoc
class _$ClassificationTargetCopyWithImpl<$Res>
    implements $ClassificationTargetCopyWith<$Res> {
  _$ClassificationTargetCopyWithImpl(this._self, this._then);

  final ClassificationTarget _self;
  final $Res Function(ClassificationTarget) _then;

/// Create a copy of ClassificationTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? occurredAt = null,Object? type = null,Object? channel = null,Object? amount = null,Object? currency = null,Object? merchantName = freezed,Object? accountLast4 = freezed,Object? accountType = freezed,Object? alert = freezed,Object? label = freezed,}) {
  return _then(ClassificationTarget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,accountLast4: freezed == accountLast4 ? _self.accountLast4 : accountLast4 // ignore: cast_nullable_to_non_nullable
as String?,accountType: freezed == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as AccountType?,alert: freezed == alert ? _self.alert : alert // ignore: cast_nullable_to_non_nullable
as TargetAlert?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as SavedLabel?,
  ));
}
/// Create a copy of ClassificationTarget
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TargetAlertCopyWith<$Res>? get alert {
    if (_self.alert == null) {
    return null;
  }

  return $TargetAlertCopyWith<$Res>(_self.alert!, (value) {
    return _then(_self.copyWith(alert: value));
  });
}/// Create a copy of ClassificationTarget
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SavedLabelCopyWith<$Res>? get label {
    if (_self.label == null) {
    return null;
  }

  return $SavedLabelCopyWith<$Res>(_self.label!, (value) {
    return _then(_self.copyWith(label: value));
  });
}
}


/// Adds pattern-matching-related methods to [ClassificationTarget].
extension ClassificationTargetPatterns on ClassificationTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassificationTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassificationTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassificationTarget value)  $default,){
final _that = this;
switch (_that) {
case _ClassificationTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassificationTarget value)?  $default,){
final _that = this;
switch (_that) {
case _ClassificationTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  DateTime occurredAt,  TransactionType type,  Channel channel,  double amount,  Currency currency,  String? merchantName,  String? accountLast4,  AccountType? accountType,  TargetAlert? alert,  SavedLabel? label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassificationTarget() when $default != null:
return $default(_that.id,_that.code,_that.occurredAt,_that.type,_that.channel,_that.amount,_that.currency,_that.merchantName,_that.accountLast4,_that.accountType,_that.alert,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  DateTime occurredAt,  TransactionType type,  Channel channel,  double amount,  Currency currency,  String? merchantName,  String? accountLast4,  AccountType? accountType,  TargetAlert? alert,  SavedLabel? label)  $default,) {final _that = this;
switch (_that) {
case _ClassificationTarget():
return $default(_that.id,_that.code,_that.occurredAt,_that.type,_that.channel,_that.amount,_that.currency,_that.merchantName,_that.accountLast4,_that.accountType,_that.alert,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  DateTime occurredAt,  TransactionType type,  Channel channel,  double amount,  Currency currency,  String? merchantName,  String? accountLast4,  AccountType? accountType,  TargetAlert? alert,  SavedLabel? label)?  $default,) {final _that = this;
switch (_that) {
case _ClassificationTarget() when $default != null:
return $default(_that.id,_that.code,_that.occurredAt,_that.type,_that.channel,_that.amount,_that.currency,_that.merchantName,_that.accountLast4,_that.accountType,_that.alert,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _ClassificationTarget implements ClassificationTarget {
  const _ClassificationTarget({required this.id, required this.code, required this.occurredAt, required this.type, required this.channel, required this.amount, required this.currency, this.merchantName, this.accountLast4, this.accountType, this.alert, this.label});
  

@override final  int id;
/// The readable code, e.g. `TX-48219`.
@override final  String code;
@override final  DateTime occurredAt;
@override final  TransactionType type;
@override final  Channel channel;
@override final  double amount;
@override final  Currency currency;
@override final  String? merchantName;
@override final  String? accountLast4;
@override final  AccountType? accountType;
/// The strongest AI alert on the transaction, if any.
@override final  TargetAlert? alert;
/// The current label, from the database or saved in this session.
@override final  SavedLabel? label;

/// Create a copy of ClassificationTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassificationTargetCopyWith<_ClassificationTarget> get copyWith => __$ClassificationTargetCopyWithImpl<_ClassificationTarget>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassificationTarget&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.type, type) || other.type == type)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.accountLast4, accountLast4) || other.accountLast4 == accountLast4)&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.alert, alert) || other.alert == alert)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,code,occurredAt,type,channel,amount,currency,merchantName,accountLast4,accountType,alert,label);
}

@override
String toString() {
    return 'ClassificationTarget(id: $id, code: $code, occurredAt: $occurredAt, type: $type, channel: $channel, amount: $amount, currency: $currency, merchantName: $merchantName, accountLast4: $accountLast4, accountType: $accountType, alert: $alert, label: $label)';
}


}

/// @nodoc
abstract mixin class _$ClassificationTargetCopyWith<$Res> implements $ClassificationTargetCopyWith<$Res> {
  factory _$ClassificationTargetCopyWith(_ClassificationTarget value, $Res Function(_ClassificationTarget) _then) = __$ClassificationTargetCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, DateTime occurredAt, TransactionType type, Channel channel, double amount, Currency currency, String? merchantName, String? accountLast4, AccountType? accountType, TargetAlert? alert, SavedLabel? label
});


@override $TargetAlertCopyWith<$Res>? get alert;@override $SavedLabelCopyWith<$Res>? get label;

}
/// @nodoc
class __$ClassificationTargetCopyWithImpl<$Res>
    implements _$ClassificationTargetCopyWith<$Res> {
  __$ClassificationTargetCopyWithImpl(this._self, this._then);

  final _ClassificationTarget _self;
  final $Res Function(_ClassificationTarget) _then;

/// Create a copy of ClassificationTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? occurredAt = null,Object? type = null,Object? channel = null,Object? amount = null,Object? currency = null,Object? merchantName = freezed,Object? accountLast4 = freezed,Object? accountType = freezed,Object? alert = freezed,Object? label = freezed,}) {
  return _then(_ClassificationTarget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,accountLast4: freezed == accountLast4 ? _self.accountLast4 : accountLast4 // ignore: cast_nullable_to_non_nullable
as String?,accountType: freezed == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as AccountType?,alert: freezed == alert ? _self.alert : alert // ignore: cast_nullable_to_non_nullable
as TargetAlert?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as SavedLabel?,
  ));
}

/// Create a copy of ClassificationTarget
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TargetAlertCopyWith<$Res>? get alert {
    if (_self.alert == null) {
    return null;
  }

  return $TargetAlertCopyWith<$Res>(_self.alert!, (value) {
    return _then(_self.copyWith(alert: value));
  });
}/// Create a copy of ClassificationTarget
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SavedLabelCopyWith<$Res>? get label {
    if (_self.label == null) {
    return null;
  }

  return $SavedLabelCopyWith<$Res>(_self.label!, (value) {
    return _then(_self.copyWith(label: value));
  });
}
}

/// @nodoc
mixin _$TargetAlert {

 String get code; int get score; String get summary; FraudType get suggestedType;
/// Create a copy of TargetAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TargetAlertCopyWith<TargetAlert> get copyWith => _$TargetAlertCopyWithImpl<TargetAlert>(this as TargetAlert, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TargetAlert;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TargetAlert&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.suggestedType, _this.suggestedType) || other.suggestedType == _this.suggestedType));
}


@override
int get hashCode {
  final _this = this as TargetAlert;
  return Object.hash(runtimeType,_this.code,_this.score,_this.summary,_this.suggestedType);
}

@override
String toString() {
  final _this = this as TargetAlert;
  return 'TargetAlert(code: ${_this.code}, score: ${_this.score}, summary: ${_this.summary}, suggestedType: ${_this.suggestedType})';
}


}

/// @nodoc
abstract mixin class $TargetAlertCopyWith<$Res>  {
  factory $TargetAlertCopyWith(TargetAlert value, $Res Function(TargetAlert) _then) = _$TargetAlertCopyWithImpl;
@useResult
$Res call({
 String code, int score, String summary, FraudType suggestedType
});




}
/// @nodoc
class _$TargetAlertCopyWithImpl<$Res>
    implements $TargetAlertCopyWith<$Res> {
  _$TargetAlertCopyWithImpl(this._self, this._then);

  final TargetAlert _self;
  final $Res Function(TargetAlert) _then;

/// Create a copy of TargetAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? score = null,Object? summary = null,Object? suggestedType = null,}) {
  return _then(TargetAlert(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,suggestedType: null == suggestedType ? _self.suggestedType : suggestedType // ignore: cast_nullable_to_non_nullable
as FraudType,
  ));
}

}


/// Adds pattern-matching-related methods to [TargetAlert].
extension TargetAlertPatterns on TargetAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TargetAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TargetAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TargetAlert value)  $default,){
final _that = this;
switch (_that) {
case _TargetAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TargetAlert value)?  $default,){
final _that = this;
switch (_that) {
case _TargetAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  int score,  String summary,  FraudType suggestedType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TargetAlert() when $default != null:
return $default(_that.code,_that.score,_that.summary,_that.suggestedType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  int score,  String summary,  FraudType suggestedType)  $default,) {final _that = this;
switch (_that) {
case _TargetAlert():
return $default(_that.code,_that.score,_that.summary,_that.suggestedType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  int score,  String summary,  FraudType suggestedType)?  $default,) {final _that = this;
switch (_that) {
case _TargetAlert() when $default != null:
return $default(_that.code,_that.score,_that.summary,_that.suggestedType);case _:
  return null;

}
}

}

/// @nodoc


class _TargetAlert implements TargetAlert {
  const _TargetAlert({required this.code, required this.score, required this.summary, required this.suggestedType});
  

@override final  String code;
@override final  int score;
@override final  String summary;
@override final  FraudType suggestedType;

/// Create a copy of TargetAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TargetAlertCopyWith<_TargetAlert> get copyWith => __$TargetAlertCopyWithImpl<_TargetAlert>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TargetAlert&&(identical(other.code, code) || other.code == code)&&(identical(other.score, score) || other.score == score)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.suggestedType, suggestedType) || other.suggestedType == suggestedType));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,score,summary,suggestedType);
}

@override
String toString() {
    return 'TargetAlert(code: $code, score: $score, summary: $summary, suggestedType: $suggestedType)';
}


}

/// @nodoc
abstract mixin class _$TargetAlertCopyWith<$Res> implements $TargetAlertCopyWith<$Res> {
  factory _$TargetAlertCopyWith(_TargetAlert value, $Res Function(_TargetAlert) _then) = __$TargetAlertCopyWithImpl;
@override @useResult
$Res call({
 String code, int score, String summary, FraudType suggestedType
});




}
/// @nodoc
class __$TargetAlertCopyWithImpl<$Res>
    implements _$TargetAlertCopyWith<$Res> {
  __$TargetAlertCopyWithImpl(this._self, this._then);

  final _TargetAlert _self;
  final $Res Function(_TargetAlert) _then;

/// Create a copy of TargetAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? score = null,Object? summary = null,Object? suggestedType = null,}) {
  return _then(_TargetAlert(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,suggestedType: null == suggestedType ? _self.suggestedType : suggestedType // ignore: cast_nullable_to_non_nullable
as FraudType,
  ));
}


}

/// @nodoc
mixin _$SavedLabel {

 Verdict get verdict; ConfidenceLevel get confidence; Severity? get severity; String? get justification; List<FraudType> get fraudTypes; String get analystName; DateTime get updatedAt;
/// Create a copy of SavedLabel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedLabelCopyWith<SavedLabel> get copyWith => _$SavedLabelCopyWithImpl<SavedLabel>(this as SavedLabel, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SavedLabel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedLabel&&(identical(other.verdict, _this.verdict) || other.verdict == _this.verdict)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence)&&(identical(other.severity, _this.severity) || other.severity == _this.severity)&&(identical(other.justification, _this.justification) || other.justification == _this.justification)&&const DeepCollectionEquality().equals(other.fraudTypes, _this.fraudTypes)&&(identical(other.analystName, _this.analystName) || other.analystName == _this.analystName)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as SavedLabel;
  return Object.hash(runtimeType,_this.verdict,_this.confidence,_this.severity,_this.justification,const DeepCollectionEquality().hash(_this.fraudTypes),_this.analystName,_this.updatedAt);
}

@override
String toString() {
  final _this = this as SavedLabel;
  return 'SavedLabel(verdict: ${_this.verdict}, confidence: ${_this.confidence}, severity: ${_this.severity}, justification: ${_this.justification}, fraudTypes: ${_this.fraudTypes}, analystName: ${_this.analystName}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $SavedLabelCopyWith<$Res>  {
  factory $SavedLabelCopyWith(SavedLabel value, $Res Function(SavedLabel) _then) = _$SavedLabelCopyWithImpl;
@useResult
$Res call({
 Verdict verdict, ConfidenceLevel confidence, Severity? severity, String? justification, List<FraudType> fraudTypes, String analystName, DateTime updatedAt
});




}
/// @nodoc
class _$SavedLabelCopyWithImpl<$Res>
    implements $SavedLabelCopyWith<$Res> {
  _$SavedLabelCopyWithImpl(this._self, this._then);

  final SavedLabel _self;
  final $Res Function(SavedLabel) _then;

/// Create a copy of SavedLabel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? verdict = null,Object? confidence = null,Object? severity = freezed,Object? justification = freezed,Object? fraudTypes = null,Object? analystName = null,Object? updatedAt = null,}) {
  return _then(SavedLabel(
verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as Severity?,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,fraudTypes: null == fraudTypes ? _self.fraudTypes : fraudTypes // ignore: cast_nullable_to_non_nullable
as List<FraudType>,analystName: null == analystName ? _self.analystName : analystName // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedLabel].
extension SavedLabelPatterns on SavedLabel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedLabel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedLabel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedLabel value)  $default,){
final _that = this;
switch (_that) {
case _SavedLabel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedLabel value)?  $default,){
final _that = this;
switch (_that) {
case _SavedLabel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Verdict verdict,  ConfidenceLevel confidence,  Severity? severity,  String? justification,  List<FraudType> fraudTypes,  String analystName,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedLabel() when $default != null:
return $default(_that.verdict,_that.confidence,_that.severity,_that.justification,_that.fraudTypes,_that.analystName,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Verdict verdict,  ConfidenceLevel confidence,  Severity? severity,  String? justification,  List<FraudType> fraudTypes,  String analystName,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SavedLabel():
return $default(_that.verdict,_that.confidence,_that.severity,_that.justification,_that.fraudTypes,_that.analystName,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Verdict verdict,  ConfidenceLevel confidence,  Severity? severity,  String? justification,  List<FraudType> fraudTypes,  String analystName,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SavedLabel() when $default != null:
return $default(_that.verdict,_that.confidence,_that.severity,_that.justification,_that.fraudTypes,_that.analystName,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SavedLabel extends SavedLabel {
  const _SavedLabel({required this.verdict, required this.confidence, this.severity, this.justification,  List<FraudType> fraudTypes = const <FraudType>[], required this.analystName, required this.updatedAt}): _fraudTypes = fraudTypes,super._();
  

@override final  Verdict verdict;
@override final  ConfidenceLevel confidence;
@override final  Severity? severity;
@override final  String? justification;
 final  List<FraudType> _fraudTypes;
@override@JsonKey() List<FraudType> get fraudTypes {
  if (_fraudTypes is EqualUnmodifiableListView) return _fraudTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fraudTypes);
}

@override final  String analystName;
@override final  DateTime updatedAt;

/// Create a copy of SavedLabel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedLabelCopyWith<_SavedLabel> get copyWith => __$SavedLabelCopyWithImpl<_SavedLabel>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedLabel&&(identical(other.verdict, verdict) || other.verdict == verdict)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.justification, justification) || other.justification == justification)&&const DeepCollectionEquality().equals(other.fraudTypes, _fraudTypes)&&(identical(other.analystName, analystName) || other.analystName == analystName)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,verdict,confidence,severity,justification,const DeepCollectionEquality().hash(_fraudTypes),analystName,updatedAt);
}

@override
String toString() {
    return 'SavedLabel(verdict: $verdict, confidence: $confidence, severity: $severity, justification: $justification, fraudTypes: $fraudTypes, analystName: $analystName, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SavedLabelCopyWith<$Res> implements $SavedLabelCopyWith<$Res> {
  factory _$SavedLabelCopyWith(_SavedLabel value, $Res Function(_SavedLabel) _then) = __$SavedLabelCopyWithImpl;
@override @useResult
$Res call({
 Verdict verdict, ConfidenceLevel confidence, Severity? severity, String? justification, List<FraudType> fraudTypes, String analystName, DateTime updatedAt
});




}
/// @nodoc
class __$SavedLabelCopyWithImpl<$Res>
    implements _$SavedLabelCopyWith<$Res> {
  __$SavedLabelCopyWithImpl(this._self, this._then);

  final _SavedLabel _self;
  final $Res Function(_SavedLabel) _then;

/// Create a copy of SavedLabel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? verdict = null,Object? confidence = null,Object? severity = freezed,Object? justification = freezed,Object? fraudTypes = null,Object? analystName = null,Object? updatedAt = null,}) {
  return _then(_SavedLabel(
verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as ConfidenceLevel,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as Severity?,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,fraudTypes: null == fraudTypes ? _self._fraudTypes : fraudTypes // ignore: cast_nullable_to_non_nullable
as List<FraudType>,analystName: null == analystName ? _self.analystName : analystName // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
