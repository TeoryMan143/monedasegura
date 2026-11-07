// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionRow {

 int get id;/// The readable code, e.g. `TX-48219`.
 String get code; DateTime get occurredAt;/// The customer to open on a click. Null when no account of the bank takes part.
 String? get customerId;/// The account the money leaves. Null for a deposit.
 String? get sourceAccountId;/// The account the money reaches. Null for a withdrawal or a purchase.
 String? get destinationAccountId;@JsonKey(fromJson: TransactionType.fromDb) TransactionType get type;@JsonKey(name: 'channel_code', fromJson: Channel.fromDb) Channel get channel; num get amount;@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) Currency get currency;/// Not in the view: the repository reads it from the `countries` catalog, through
/// the currency (see `transaction_country.dart`).
@JsonKey(includeFromJson: false, includeToJson: false) Country? get country;/// Score of its AI alert, 0 to 100. Null without an alert.
 int? get alertScore; bool get isLabeled;/// Verdict of the current label. Null while it is not labeled.
@JsonKey(fromJson: _verdictOrNull) Verdict? get verdict;
/// Create a copy of TransactionRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionRowCopyWith<TransactionRow> get copyWith => _$TransactionRowCopyWithImpl<TransactionRow>(this as TransactionRow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionRow&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.occurredAt, _this.occurredAt) || other.occurredAt == _this.occurredAt)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.sourceAccountId, _this.sourceAccountId) || other.sourceAccountId == _this.sourceAccountId)&&(identical(other.destinationAccountId, _this.destinationAccountId) || other.destinationAccountId == _this.destinationAccountId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.channel, _this.channel) || other.channel == _this.channel)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.country, _this.country) || other.country == _this.country)&&(identical(other.alertScore, _this.alertScore) || other.alertScore == _this.alertScore)&&(identical(other.isLabeled, _this.isLabeled) || other.isLabeled == _this.isLabeled)&&(identical(other.verdict, _this.verdict) || other.verdict == _this.verdict));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransactionRow;
  return Object.hash(runtimeType,_this.id,_this.code,_this.occurredAt,_this.customerId,_this.sourceAccountId,_this.destinationAccountId,_this.type,_this.channel,_this.amount,_this.currency,_this.country,_this.alertScore,_this.isLabeled,_this.verdict);
}

@override
String toString() {
  final _this = this as TransactionRow;
  return 'TransactionRow(id: ${_this.id}, code: ${_this.code}, occurredAt: ${_this.occurredAt}, customerId: ${_this.customerId}, sourceAccountId: ${_this.sourceAccountId}, destinationAccountId: ${_this.destinationAccountId}, type: ${_this.type}, channel: ${_this.channel}, amount: ${_this.amount}, currency: ${_this.currency}, country: ${_this.country}, alertScore: ${_this.alertScore}, isLabeled: ${_this.isLabeled}, verdict: ${_this.verdict})';
}


}

/// @nodoc
abstract mixin class $TransactionRowCopyWith<$Res>  {
  factory $TransactionRowCopyWith(TransactionRow value, $Res Function(TransactionRow) _then) = _$TransactionRowCopyWithImpl;
@useResult
$Res call({
 int id, String code, DateTime occurredAt, String? customerId, String? sourceAccountId, String? destinationAccountId,@JsonKey(fromJson: TransactionType.fromDb) TransactionType type,@JsonKey(name: 'channel_code', fromJson: Channel.fromDb) Channel channel, num amount,@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) Currency currency,@JsonKey(includeFromJson: false, includeToJson: false) Country? country, int? alertScore, bool isLabeled,@JsonKey(fromJson: _verdictOrNull) Verdict? verdict
});




}
/// @nodoc
class _$TransactionRowCopyWithImpl<$Res>
    implements $TransactionRowCopyWith<$Res> {
  _$TransactionRowCopyWithImpl(this._self, this._then);

  final TransactionRow _self;
  final $Res Function(TransactionRow) _then;

/// Create a copy of TransactionRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? occurredAt = null,Object? customerId = freezed,Object? sourceAccountId = freezed,Object? destinationAccountId = freezed,Object? type = null,Object? channel = null,Object? amount = null,Object? currency = null,Object? country = freezed,Object? alertScore = freezed,Object? isLabeled = null,Object? verdict = freezed,}) {
  return _then(TransactionRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,sourceAccountId: freezed == sourceAccountId ? _self.sourceAccountId : sourceAccountId // ignore: cast_nullable_to_non_nullable
as String?,destinationAccountId: freezed == destinationAccountId ? _self.destinationAccountId : destinationAccountId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as Country?,alertScore: freezed == alertScore ? _self.alertScore : alertScore // ignore: cast_nullable_to_non_nullable
as int?,isLabeled: null == isLabeled ? _self.isLabeled : isLabeled // ignore: cast_nullable_to_non_nullable
as bool,verdict: freezed == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionRow].
extension TransactionRowPatterns on TransactionRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionRow value)  $default,){
final _that = this;
switch (_that) {
case _TransactionRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionRow value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  DateTime occurredAt,  String? customerId,  String? sourceAccountId,  String? destinationAccountId, @JsonKey(fromJson: TransactionType.fromDb)  TransactionType type, @JsonKey(name: 'channel_code', fromJson: Channel.fromDb)  Channel channel,  num amount, @JsonKey(name: 'currency_code', fromJson: Currency.fromDb)  Currency currency, @JsonKey(includeFromJson: false, includeToJson: false)  Country? country,  int? alertScore,  bool isLabeled, @JsonKey(fromJson: _verdictOrNull)  Verdict? verdict)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionRow() when $default != null:
return $default(_that.id,_that.code,_that.occurredAt,_that.customerId,_that.sourceAccountId,_that.destinationAccountId,_that.type,_that.channel,_that.amount,_that.currency,_that.country,_that.alertScore,_that.isLabeled,_that.verdict);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  DateTime occurredAt,  String? customerId,  String? sourceAccountId,  String? destinationAccountId, @JsonKey(fromJson: TransactionType.fromDb)  TransactionType type, @JsonKey(name: 'channel_code', fromJson: Channel.fromDb)  Channel channel,  num amount, @JsonKey(name: 'currency_code', fromJson: Currency.fromDb)  Currency currency, @JsonKey(includeFromJson: false, includeToJson: false)  Country? country,  int? alertScore,  bool isLabeled, @JsonKey(fromJson: _verdictOrNull)  Verdict? verdict)  $default,) {final _that = this;
switch (_that) {
case _TransactionRow():
return $default(_that.id,_that.code,_that.occurredAt,_that.customerId,_that.sourceAccountId,_that.destinationAccountId,_that.type,_that.channel,_that.amount,_that.currency,_that.country,_that.alertScore,_that.isLabeled,_that.verdict);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  DateTime occurredAt,  String? customerId,  String? sourceAccountId,  String? destinationAccountId, @JsonKey(fromJson: TransactionType.fromDb)  TransactionType type, @JsonKey(name: 'channel_code', fromJson: Channel.fromDb)  Channel channel,  num amount, @JsonKey(name: 'currency_code', fromJson: Currency.fromDb)  Currency currency, @JsonKey(includeFromJson: false, includeToJson: false)  Country? country,  int? alertScore,  bool isLabeled, @JsonKey(fromJson: _verdictOrNull)  Verdict? verdict)?  $default,) {final _that = this;
switch (_that) {
case _TransactionRow() when $default != null:
return $default(_that.id,_that.code,_that.occurredAt,_that.customerId,_that.sourceAccountId,_that.destinationAccountId,_that.type,_that.channel,_that.amount,_that.currency,_that.country,_that.alertScore,_that.isLabeled,_that.verdict);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _TransactionRow extends TransactionRow {
  const _TransactionRow({required this.id, required this.code, required this.occurredAt, this.customerId, this.sourceAccountId, this.destinationAccountId, @JsonKey(fromJson: TransactionType.fromDb) required this.type, @JsonKey(name: 'channel_code', fromJson: Channel.fromDb) required this.channel, required this.amount, @JsonKey(name: 'currency_code', fromJson: Currency.fromDb) required this.currency, @JsonKey(includeFromJson: false, includeToJson: false) this.country, this.alertScore, required this.isLabeled, @JsonKey(fromJson: _verdictOrNull) this.verdict}): super._();
  factory _TransactionRow.fromJson(Map<String, dynamic> json) => _$TransactionRowFromJson(json);

@override final  int id;
/// The readable code, e.g. `TX-48219`.
@override final  String code;
@override final  DateTime occurredAt;
/// The customer to open on a click. Null when no account of the bank takes part.
@override final  String? customerId;
/// The account the money leaves. Null for a deposit.
@override final  String? sourceAccountId;
/// The account the money reaches. Null for a withdrawal or a purchase.
@override final  String? destinationAccountId;
@override@JsonKey(fromJson: TransactionType.fromDb) final  TransactionType type;
@override@JsonKey(name: 'channel_code', fromJson: Channel.fromDb) final  Channel channel;
@override final  num amount;
@override@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) final  Currency currency;
/// Not in the view: the repository reads it from the `countries` catalog, through
/// the currency (see `transaction_country.dart`).
@override@JsonKey(includeFromJson: false, includeToJson: false) final  Country? country;
/// Score of its AI alert, 0 to 100. Null without an alert.
@override final  int? alertScore;
@override final  bool isLabeled;
/// Verdict of the current label. Null while it is not labeled.
@override@JsonKey(fromJson: _verdictOrNull) final  Verdict? verdict;

/// Create a copy of TransactionRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionRowCopyWith<_TransactionRow> get copyWith => __$TransactionRowCopyWithImpl<_TransactionRow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionRow&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.sourceAccountId, sourceAccountId) || other.sourceAccountId == sourceAccountId)&&(identical(other.destinationAccountId, destinationAccountId) || other.destinationAccountId == destinationAccountId)&&(identical(other.type, type) || other.type == type)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.country, country) || other.country == country)&&(identical(other.alertScore, alertScore) || other.alertScore == alertScore)&&(identical(other.isLabeled, isLabeled) || other.isLabeled == isLabeled)&&(identical(other.verdict, verdict) || other.verdict == verdict));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,occurredAt,customerId,sourceAccountId,destinationAccountId,type,channel,amount,currency,country,alertScore,isLabeled,verdict);
}

@override
String toString() {
    return 'TransactionRow(id: $id, code: $code, occurredAt: $occurredAt, customerId: $customerId, sourceAccountId: $sourceAccountId, destinationAccountId: $destinationAccountId, type: $type, channel: $channel, amount: $amount, currency: $currency, country: $country, alertScore: $alertScore, isLabeled: $isLabeled, verdict: $verdict)';
}


}

/// @nodoc
abstract mixin class _$TransactionRowCopyWith<$Res> implements $TransactionRowCopyWith<$Res> {
  factory _$TransactionRowCopyWith(_TransactionRow value, $Res Function(_TransactionRow) _then) = __$TransactionRowCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, DateTime occurredAt, String? customerId, String? sourceAccountId, String? destinationAccountId,@JsonKey(fromJson: TransactionType.fromDb) TransactionType type,@JsonKey(name: 'channel_code', fromJson: Channel.fromDb) Channel channel, num amount,@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) Currency currency,@JsonKey(includeFromJson: false, includeToJson: false) Country? country, int? alertScore, bool isLabeled,@JsonKey(fromJson: _verdictOrNull) Verdict? verdict
});




}
/// @nodoc
class __$TransactionRowCopyWithImpl<$Res>
    implements _$TransactionRowCopyWith<$Res> {
  __$TransactionRowCopyWithImpl(this._self, this._then);

  final _TransactionRow _self;
  final $Res Function(_TransactionRow) _then;

/// Create a copy of TransactionRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? occurredAt = null,Object? customerId = freezed,Object? sourceAccountId = freezed,Object? destinationAccountId = freezed,Object? type = null,Object? channel = null,Object? amount = null,Object? currency = null,Object? country = freezed,Object? alertScore = freezed,Object? isLabeled = null,Object? verdict = freezed,}) {
  return _then(_TransactionRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,sourceAccountId: freezed == sourceAccountId ? _self.sourceAccountId : sourceAccountId // ignore: cast_nullable_to_non_nullable
as String?,destinationAccountId: freezed == destinationAccountId ? _self.destinationAccountId : destinationAccountId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as Country?,alertScore: freezed == alertScore ? _self.alertScore : alertScore // ignore: cast_nullable_to_non_nullable
as int?,isLabeled: null == isLabeled ? _self.isLabeled : isLabeled // ignore: cast_nullable_to_non_nullable
as bool,verdict: freezed == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict?,
  ));
}


}

// dart format on
