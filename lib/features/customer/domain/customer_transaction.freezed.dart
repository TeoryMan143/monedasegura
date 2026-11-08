// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerTransaction {

 int get id;/// The readable code, e.g. `TX-48219`.
 String get code; DateTime get occurredAt;@JsonKey(fromJson: TransactionType.fromDb) TransactionType get type;@JsonKey(name: 'channel_code', fromJson: Channel.fromDb) Channel get channel; num get amount;@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) Currency get currency; String? get sourceAccountId; String? get destinationAccountId;/// The merchant of a purchase or a payment.
 String? get merchantName;/// Where it happened, for the timeline and the map (HU-10, HU-11). Null for
/// operations without a place, such as most online credits.
 double? get latitude; double? get longitude; String? get cityName;/// Score of its AI alert, 0 to 100. Null without an alert.
 int? get alertScore; bool get isLabeled;@JsonKey(fromJson: _verdictOrNull) Verdict? get verdict;
/// Create a copy of CustomerTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerTransactionCopyWith<CustomerTransaction> get copyWith => _$CustomerTransactionCopyWithImpl<CustomerTransaction>(this as CustomerTransaction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerTransaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerTransaction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.occurredAt, _this.occurredAt) || other.occurredAt == _this.occurredAt)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.channel, _this.channel) || other.channel == _this.channel)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.sourceAccountId, _this.sourceAccountId) || other.sourceAccountId == _this.sourceAccountId)&&(identical(other.destinationAccountId, _this.destinationAccountId) || other.destinationAccountId == _this.destinationAccountId)&&(identical(other.merchantName, _this.merchantName) || other.merchantName == _this.merchantName)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.cityName, _this.cityName) || other.cityName == _this.cityName)&&(identical(other.alertScore, _this.alertScore) || other.alertScore == _this.alertScore)&&(identical(other.isLabeled, _this.isLabeled) || other.isLabeled == _this.isLabeled)&&(identical(other.verdict, _this.verdict) || other.verdict == _this.verdict));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CustomerTransaction;
  return Object.hash(runtimeType,_this.id,_this.code,_this.occurredAt,_this.type,_this.channel,_this.amount,_this.currency,_this.sourceAccountId,_this.destinationAccountId,_this.merchantName,_this.latitude,_this.longitude,_this.cityName,_this.alertScore,_this.isLabeled,_this.verdict);
}

@override
String toString() {
  final _this = this as CustomerTransaction;
  return 'CustomerTransaction(id: ${_this.id}, code: ${_this.code}, occurredAt: ${_this.occurredAt}, type: ${_this.type}, channel: ${_this.channel}, amount: ${_this.amount}, currency: ${_this.currency}, sourceAccountId: ${_this.sourceAccountId}, destinationAccountId: ${_this.destinationAccountId}, merchantName: ${_this.merchantName}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, cityName: ${_this.cityName}, alertScore: ${_this.alertScore}, isLabeled: ${_this.isLabeled}, verdict: ${_this.verdict})';
}


}

/// @nodoc
abstract mixin class $CustomerTransactionCopyWith<$Res>  {
  factory $CustomerTransactionCopyWith(CustomerTransaction value, $Res Function(CustomerTransaction) _then) = _$CustomerTransactionCopyWithImpl;
@useResult
$Res call({
 int id, String code, DateTime occurredAt,@JsonKey(fromJson: TransactionType.fromDb) TransactionType type,@JsonKey(name: 'channel_code', fromJson: Channel.fromDb) Channel channel, num amount,@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) Currency currency, String? sourceAccountId, String? destinationAccountId, String? merchantName, double? latitude, double? longitude, String? cityName, int? alertScore, bool isLabeled,@JsonKey(fromJson: _verdictOrNull) Verdict? verdict
});




}
/// @nodoc
class _$CustomerTransactionCopyWithImpl<$Res>
    implements $CustomerTransactionCopyWith<$Res> {
  _$CustomerTransactionCopyWithImpl(this._self, this._then);

  final CustomerTransaction _self;
  final $Res Function(CustomerTransaction) _then;

/// Create a copy of CustomerTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? occurredAt = null,Object? type = null,Object? channel = null,Object? amount = null,Object? currency = null,Object? sourceAccountId = freezed,Object? destinationAccountId = freezed,Object? merchantName = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? cityName = freezed,Object? alertScore = freezed,Object? isLabeled = null,Object? verdict = freezed,}) {
  return _then(CustomerTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,sourceAccountId: freezed == sourceAccountId ? _self.sourceAccountId : sourceAccountId // ignore: cast_nullable_to_non_nullable
as String?,destinationAccountId: freezed == destinationAccountId ? _self.destinationAccountId : destinationAccountId // ignore: cast_nullable_to_non_nullable
as String?,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,alertScore: freezed == alertScore ? _self.alertScore : alertScore // ignore: cast_nullable_to_non_nullable
as int?,isLabeled: null == isLabeled ? _self.isLabeled : isLabeled // ignore: cast_nullable_to_non_nullable
as bool,verdict: freezed == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerTransaction].
extension CustomerTransactionPatterns on CustomerTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerTransaction value)  $default,){
final _that = this;
switch (_that) {
case _CustomerTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  DateTime occurredAt, @JsonKey(fromJson: TransactionType.fromDb)  TransactionType type, @JsonKey(name: 'channel_code', fromJson: Channel.fromDb)  Channel channel,  num amount, @JsonKey(name: 'currency_code', fromJson: Currency.fromDb)  Currency currency,  String? sourceAccountId,  String? destinationAccountId,  String? merchantName,  double? latitude,  double? longitude,  String? cityName,  int? alertScore,  bool isLabeled, @JsonKey(fromJson: _verdictOrNull)  Verdict? verdict)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerTransaction() when $default != null:
return $default(_that.id,_that.code,_that.occurredAt,_that.type,_that.channel,_that.amount,_that.currency,_that.sourceAccountId,_that.destinationAccountId,_that.merchantName,_that.latitude,_that.longitude,_that.cityName,_that.alertScore,_that.isLabeled,_that.verdict);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  DateTime occurredAt, @JsonKey(fromJson: TransactionType.fromDb)  TransactionType type, @JsonKey(name: 'channel_code', fromJson: Channel.fromDb)  Channel channel,  num amount, @JsonKey(name: 'currency_code', fromJson: Currency.fromDb)  Currency currency,  String? sourceAccountId,  String? destinationAccountId,  String? merchantName,  double? latitude,  double? longitude,  String? cityName,  int? alertScore,  bool isLabeled, @JsonKey(fromJson: _verdictOrNull)  Verdict? verdict)  $default,) {final _that = this;
switch (_that) {
case _CustomerTransaction():
return $default(_that.id,_that.code,_that.occurredAt,_that.type,_that.channel,_that.amount,_that.currency,_that.sourceAccountId,_that.destinationAccountId,_that.merchantName,_that.latitude,_that.longitude,_that.cityName,_that.alertScore,_that.isLabeled,_that.verdict);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  DateTime occurredAt, @JsonKey(fromJson: TransactionType.fromDb)  TransactionType type, @JsonKey(name: 'channel_code', fromJson: Channel.fromDb)  Channel channel,  num amount, @JsonKey(name: 'currency_code', fromJson: Currency.fromDb)  Currency currency,  String? sourceAccountId,  String? destinationAccountId,  String? merchantName,  double? latitude,  double? longitude,  String? cityName,  int? alertScore,  bool isLabeled, @JsonKey(fromJson: _verdictOrNull)  Verdict? verdict)?  $default,) {final _that = this;
switch (_that) {
case _CustomerTransaction() when $default != null:
return $default(_that.id,_that.code,_that.occurredAt,_that.type,_that.channel,_that.amount,_that.currency,_that.sourceAccountId,_that.destinationAccountId,_that.merchantName,_that.latitude,_that.longitude,_that.cityName,_that.alertScore,_that.isLabeled,_that.verdict);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _CustomerTransaction extends CustomerTransaction {
  const _CustomerTransaction({required this.id, required this.code, required this.occurredAt, @JsonKey(fromJson: TransactionType.fromDb) required this.type, @JsonKey(name: 'channel_code', fromJson: Channel.fromDb) required this.channel, required this.amount, @JsonKey(name: 'currency_code', fromJson: Currency.fromDb) required this.currency, this.sourceAccountId, this.destinationAccountId, this.merchantName, this.latitude, this.longitude, this.cityName, this.alertScore, required this.isLabeled, @JsonKey(fromJson: _verdictOrNull) this.verdict}): super._();
  factory _CustomerTransaction.fromJson(Map<String, dynamic> json) => _$CustomerTransactionFromJson(json);

@override final  int id;
/// The readable code, e.g. `TX-48219`.
@override final  String code;
@override final  DateTime occurredAt;
@override@JsonKey(fromJson: TransactionType.fromDb) final  TransactionType type;
@override@JsonKey(name: 'channel_code', fromJson: Channel.fromDb) final  Channel channel;
@override final  num amount;
@override@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) final  Currency currency;
@override final  String? sourceAccountId;
@override final  String? destinationAccountId;
/// The merchant of a purchase or a payment.
@override final  String? merchantName;
/// Where it happened, for the timeline and the map (HU-10, HU-11). Null for
/// operations without a place, such as most online credits.
@override final  double? latitude;
@override final  double? longitude;
@override final  String? cityName;
/// Score of its AI alert, 0 to 100. Null without an alert.
@override final  int? alertScore;
@override final  bool isLabeled;
@override@JsonKey(fromJson: _verdictOrNull) final  Verdict? verdict;

/// Create a copy of CustomerTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerTransactionCopyWith<_CustomerTransaction> get copyWith => __$CustomerTransactionCopyWithImpl<_CustomerTransaction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.type, type) || other.type == type)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.sourceAccountId, sourceAccountId) || other.sourceAccountId == sourceAccountId)&&(identical(other.destinationAccountId, destinationAccountId) || other.destinationAccountId == destinationAccountId)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.alertScore, alertScore) || other.alertScore == alertScore)&&(identical(other.isLabeled, isLabeled) || other.isLabeled == isLabeled)&&(identical(other.verdict, verdict) || other.verdict == verdict));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,occurredAt,type,channel,amount,currency,sourceAccountId,destinationAccountId,merchantName,latitude,longitude,cityName,alertScore,isLabeled,verdict);
}

@override
String toString() {
    return 'CustomerTransaction(id: $id, code: $code, occurredAt: $occurredAt, type: $type, channel: $channel, amount: $amount, currency: $currency, sourceAccountId: $sourceAccountId, destinationAccountId: $destinationAccountId, merchantName: $merchantName, latitude: $latitude, longitude: $longitude, cityName: $cityName, alertScore: $alertScore, isLabeled: $isLabeled, verdict: $verdict)';
}


}

/// @nodoc
abstract mixin class _$CustomerTransactionCopyWith<$Res> implements $CustomerTransactionCopyWith<$Res> {
  factory _$CustomerTransactionCopyWith(_CustomerTransaction value, $Res Function(_CustomerTransaction) _then) = __$CustomerTransactionCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, DateTime occurredAt,@JsonKey(fromJson: TransactionType.fromDb) TransactionType type,@JsonKey(name: 'channel_code', fromJson: Channel.fromDb) Channel channel, num amount,@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) Currency currency, String? sourceAccountId, String? destinationAccountId, String? merchantName, double? latitude, double? longitude, String? cityName, int? alertScore, bool isLabeled,@JsonKey(fromJson: _verdictOrNull) Verdict? verdict
});




}
/// @nodoc
class __$CustomerTransactionCopyWithImpl<$Res>
    implements _$CustomerTransactionCopyWith<$Res> {
  __$CustomerTransactionCopyWithImpl(this._self, this._then);

  final _CustomerTransaction _self;
  final $Res Function(_CustomerTransaction) _then;

/// Create a copy of CustomerTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? occurredAt = null,Object? type = null,Object? channel = null,Object? amount = null,Object? currency = null,Object? sourceAccountId = freezed,Object? destinationAccountId = freezed,Object? merchantName = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? cityName = freezed,Object? alertScore = freezed,Object? isLabeled = null,Object? verdict = freezed,}) {
  return _then(_CustomerTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,sourceAccountId: freezed == sourceAccountId ? _self.sourceAccountId : sourceAccountId // ignore: cast_nullable_to_non_nullable
as String?,destinationAccountId: freezed == destinationAccountId ? _self.destinationAccountId : destinationAccountId // ignore: cast_nullable_to_non_nullable
as String?,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,alertScore: freezed == alertScore ? _self.alertScore : alertScore // ignore: cast_nullable_to_non_nullable
as int?,isLabeled: null == isLabeled ? _self.isLabeled : isLabeled // ignore: cast_nullable_to_non_nullable
as bool,verdict: freezed == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict?,
  ));
}


}

// dart format on
