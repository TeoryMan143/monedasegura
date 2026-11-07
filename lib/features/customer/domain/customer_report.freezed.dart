// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerProfile {

 String get id; String get fullName;/// Raw `document_type`, e.g. `CC`, `DNI`: the code is how analysts say it.
 String get documentType; String get documentNumber; DateTime get birthDate; String get countryName; String get cityName; CustomerSegment get segment; RiskLevel get riskLevel; DateTime get customerSince; Currency get incomeCurrency; double? get declaredIncome; String? get occupation; String? get email; String? get phone;
/// Create a copy of CustomerProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerProfileCopyWith<CustomerProfile> get copyWith => _$CustomerProfileCopyWithImpl<CustomerProfile>(this as CustomerProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.documentType, _this.documentType) || other.documentType == _this.documentType)&&(identical(other.documentNumber, _this.documentNumber) || other.documentNumber == _this.documentNumber)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.countryName, _this.countryName) || other.countryName == _this.countryName)&&(identical(other.cityName, _this.cityName) || other.cityName == _this.cityName)&&(identical(other.segment, _this.segment) || other.segment == _this.segment)&&(identical(other.riskLevel, _this.riskLevel) || other.riskLevel == _this.riskLevel)&&(identical(other.customerSince, _this.customerSince) || other.customerSince == _this.customerSince)&&(identical(other.incomeCurrency, _this.incomeCurrency) || other.incomeCurrency == _this.incomeCurrency)&&(identical(other.declaredIncome, _this.declaredIncome) || other.declaredIncome == _this.declaredIncome)&&(identical(other.occupation, _this.occupation) || other.occupation == _this.occupation)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone));
}


@override
int get hashCode {
  final _this = this as CustomerProfile;
  return Object.hash(runtimeType,_this.id,_this.fullName,_this.documentType,_this.documentNumber,_this.birthDate,_this.countryName,_this.cityName,_this.segment,_this.riskLevel,_this.customerSince,_this.incomeCurrency,_this.declaredIncome,_this.occupation,_this.email,_this.phone);
}

@override
String toString() {
  final _this = this as CustomerProfile;
  return 'CustomerProfile(id: ${_this.id}, fullName: ${_this.fullName}, documentType: ${_this.documentType}, documentNumber: ${_this.documentNumber}, birthDate: ${_this.birthDate}, countryName: ${_this.countryName}, cityName: ${_this.cityName}, segment: ${_this.segment}, riskLevel: ${_this.riskLevel}, customerSince: ${_this.customerSince}, incomeCurrency: ${_this.incomeCurrency}, declaredIncome: ${_this.declaredIncome}, occupation: ${_this.occupation}, email: ${_this.email}, phone: ${_this.phone})';
}


}

/// @nodoc
abstract mixin class $CustomerProfileCopyWith<$Res>  {
  factory $CustomerProfileCopyWith(CustomerProfile value, $Res Function(CustomerProfile) _then) = _$CustomerProfileCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String documentType, String documentNumber, DateTime birthDate, String countryName, String cityName, CustomerSegment segment, RiskLevel riskLevel, DateTime customerSince, Currency incomeCurrency, double? declaredIncome, String? occupation, String? email, String? phone
});




}
/// @nodoc
class _$CustomerProfileCopyWithImpl<$Res>
    implements $CustomerProfileCopyWith<$Res> {
  _$CustomerProfileCopyWithImpl(this._self, this._then);

  final CustomerProfile _self;
  final $Res Function(CustomerProfile) _then;

/// Create a copy of CustomerProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? documentType = null,Object? documentNumber = null,Object? birthDate = null,Object? countryName = null,Object? cityName = null,Object? segment = null,Object? riskLevel = null,Object? customerSince = null,Object? incomeCurrency = null,Object? declaredIncome = freezed,Object? occupation = freezed,Object? email = freezed,Object? phone = freezed,}) {
  return _then(CustomerProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String,documentNumber: null == documentNumber ? _self.documentNumber : documentNumber // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,countryName: null == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String,cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,segment: null == segment ? _self.segment : segment // ignore: cast_nullable_to_non_nullable
as CustomerSegment,riskLevel: null == riskLevel ? _self.riskLevel : riskLevel // ignore: cast_nullable_to_non_nullable
as RiskLevel,customerSince: null == customerSince ? _self.customerSince : customerSince // ignore: cast_nullable_to_non_nullable
as DateTime,incomeCurrency: null == incomeCurrency ? _self.incomeCurrency : incomeCurrency // ignore: cast_nullable_to_non_nullable
as Currency,declaredIncome: freezed == declaredIncome ? _self.declaredIncome : declaredIncome // ignore: cast_nullable_to_non_nullable
as double?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerProfile].
extension CustomerProfilePatterns on CustomerProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerProfile value)  $default,){
final _that = this;
switch (_that) {
case _CustomerProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerProfile value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String documentType,  String documentNumber,  DateTime birthDate,  String countryName,  String cityName,  CustomerSegment segment,  RiskLevel riskLevel,  DateTime customerSince,  Currency incomeCurrency,  double? declaredIncome,  String? occupation,  String? email,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerProfile() when $default != null:
return $default(_that.id,_that.fullName,_that.documentType,_that.documentNumber,_that.birthDate,_that.countryName,_that.cityName,_that.segment,_that.riskLevel,_that.customerSince,_that.incomeCurrency,_that.declaredIncome,_that.occupation,_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String documentType,  String documentNumber,  DateTime birthDate,  String countryName,  String cityName,  CustomerSegment segment,  RiskLevel riskLevel,  DateTime customerSince,  Currency incomeCurrency,  double? declaredIncome,  String? occupation,  String? email,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _CustomerProfile():
return $default(_that.id,_that.fullName,_that.documentType,_that.documentNumber,_that.birthDate,_that.countryName,_that.cityName,_that.segment,_that.riskLevel,_that.customerSince,_that.incomeCurrency,_that.declaredIncome,_that.occupation,_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String documentType,  String documentNumber,  DateTime birthDate,  String countryName,  String cityName,  CustomerSegment segment,  RiskLevel riskLevel,  DateTime customerSince,  Currency incomeCurrency,  double? declaredIncome,  String? occupation,  String? email,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _CustomerProfile() when $default != null:
return $default(_that.id,_that.fullName,_that.documentType,_that.documentNumber,_that.birthDate,_that.countryName,_that.cityName,_that.segment,_that.riskLevel,_that.customerSince,_that.incomeCurrency,_that.declaredIncome,_that.occupation,_that.email,_that.phone);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerProfile implements CustomerProfile {
  const _CustomerProfile({required this.id, required this.fullName, required this.documentType, required this.documentNumber, required this.birthDate, required this.countryName, required this.cityName, required this.segment, required this.riskLevel, required this.customerSince, required this.incomeCurrency, this.declaredIncome, this.occupation, this.email, this.phone});
  

@override final  String id;
@override final  String fullName;
/// Raw `document_type`, e.g. `CC`, `DNI`: the code is how analysts say it.
@override final  String documentType;
@override final  String documentNumber;
@override final  DateTime birthDate;
@override final  String countryName;
@override final  String cityName;
@override final  CustomerSegment segment;
@override final  RiskLevel riskLevel;
@override final  DateTime customerSince;
@override final  Currency incomeCurrency;
@override final  double? declaredIncome;
@override final  String? occupation;
@override final  String? email;
@override final  String? phone;

/// Create a copy of CustomerProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerProfileCopyWith<_CustomerProfile> get copyWith => __$CustomerProfileCopyWithImpl<_CustomerProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.documentNumber, documentNumber) || other.documentNumber == documentNumber)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.segment, segment) || other.segment == segment)&&(identical(other.riskLevel, riskLevel) || other.riskLevel == riskLevel)&&(identical(other.customerSince, customerSince) || other.customerSince == customerSince)&&(identical(other.incomeCurrency, incomeCurrency) || other.incomeCurrency == incomeCurrency)&&(identical(other.declaredIncome, declaredIncome) || other.declaredIncome == declaredIncome)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,fullName,documentType,documentNumber,birthDate,countryName,cityName,segment,riskLevel,customerSince,incomeCurrency,declaredIncome,occupation,email,phone);
}

@override
String toString() {
    return 'CustomerProfile(id: $id, fullName: $fullName, documentType: $documentType, documentNumber: $documentNumber, birthDate: $birthDate, countryName: $countryName, cityName: $cityName, segment: $segment, riskLevel: $riskLevel, customerSince: $customerSince, incomeCurrency: $incomeCurrency, declaredIncome: $declaredIncome, occupation: $occupation, email: $email, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$CustomerProfileCopyWith<$Res> implements $CustomerProfileCopyWith<$Res> {
  factory _$CustomerProfileCopyWith(_CustomerProfile value, $Res Function(_CustomerProfile) _then) = __$CustomerProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String documentType, String documentNumber, DateTime birthDate, String countryName, String cityName, CustomerSegment segment, RiskLevel riskLevel, DateTime customerSince, Currency incomeCurrency, double? declaredIncome, String? occupation, String? email, String? phone
});




}
/// @nodoc
class __$CustomerProfileCopyWithImpl<$Res>
    implements _$CustomerProfileCopyWith<$Res> {
  __$CustomerProfileCopyWithImpl(this._self, this._then);

  final _CustomerProfile _self;
  final $Res Function(_CustomerProfile) _then;

/// Create a copy of CustomerProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? documentType = null,Object? documentNumber = null,Object? birthDate = null,Object? countryName = null,Object? cityName = null,Object? segment = null,Object? riskLevel = null,Object? customerSince = null,Object? incomeCurrency = null,Object? declaredIncome = freezed,Object? occupation = freezed,Object? email = freezed,Object? phone = freezed,}) {
  return _then(_CustomerProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String,documentNumber: null == documentNumber ? _self.documentNumber : documentNumber // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,countryName: null == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String,cityName: null == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String,segment: null == segment ? _self.segment : segment // ignore: cast_nullable_to_non_nullable
as CustomerSegment,riskLevel: null == riskLevel ? _self.riskLevel : riskLevel // ignore: cast_nullable_to_non_nullable
as RiskLevel,customerSince: null == customerSince ? _self.customerSince : customerSince // ignore: cast_nullable_to_non_nullable
as DateTime,incomeCurrency: null == incomeCurrency ? _self.incomeCurrency : incomeCurrency // ignore: cast_nullable_to_non_nullable
as Currency,declaredIncome: freezed == declaredIncome ? _self.declaredIncome : declaredIncome // ignore: cast_nullable_to_non_nullable
as double?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$CustomerProducts {

 List<ReportAccount> get accounts; List<ReportCard> get cards; List<ReportDevice> get devices;
/// Create a copy of CustomerProducts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerProductsCopyWith<CustomerProducts> get copyWith => _$CustomerProductsCopyWithImpl<CustomerProducts>(this as CustomerProducts, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerProducts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerProducts&&const DeepCollectionEquality().equals(other.accounts, _this.accounts)&&const DeepCollectionEquality().equals(other.cards, _this.cards)&&const DeepCollectionEquality().equals(other.devices, _this.devices));
}


@override
int get hashCode {
  final _this = this as CustomerProducts;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.accounts),const DeepCollectionEquality().hash(_this.cards),const DeepCollectionEquality().hash(_this.devices));
}

@override
String toString() {
  final _this = this as CustomerProducts;
  return 'CustomerProducts(accounts: ${_this.accounts}, cards: ${_this.cards}, devices: ${_this.devices})';
}


}

/// @nodoc
abstract mixin class $CustomerProductsCopyWith<$Res>  {
  factory $CustomerProductsCopyWith(CustomerProducts value, $Res Function(CustomerProducts) _then) = _$CustomerProductsCopyWithImpl;
@useResult
$Res call({
 List<ReportAccount> accounts, List<ReportCard> cards, List<ReportDevice> devices
});




}
/// @nodoc
class _$CustomerProductsCopyWithImpl<$Res>
    implements $CustomerProductsCopyWith<$Res> {
  _$CustomerProductsCopyWithImpl(this._self, this._then);

  final CustomerProducts _self;
  final $Res Function(CustomerProducts) _then;

/// Create a copy of CustomerProducts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accounts = null,Object? cards = null,Object? devices = null,}) {
  return _then(CustomerProducts(
accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<ReportAccount>,cards: null == cards ? _self.cards : cards // ignore: cast_nullable_to_non_nullable
as List<ReportCard>,devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<ReportDevice>,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerProducts].
extension CustomerProductsPatterns on CustomerProducts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerProducts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerProducts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerProducts value)  $default,){
final _that = this;
switch (_that) {
case _CustomerProducts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerProducts value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerProducts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ReportAccount> accounts,  List<ReportCard> cards,  List<ReportDevice> devices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerProducts() when $default != null:
return $default(_that.accounts,_that.cards,_that.devices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ReportAccount> accounts,  List<ReportCard> cards,  List<ReportDevice> devices)  $default,) {final _that = this;
switch (_that) {
case _CustomerProducts():
return $default(_that.accounts,_that.cards,_that.devices);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ReportAccount> accounts,  List<ReportCard> cards,  List<ReportDevice> devices)?  $default,) {final _that = this;
switch (_that) {
case _CustomerProducts() when $default != null:
return $default(_that.accounts,_that.cards,_that.devices);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerProducts implements CustomerProducts {
  const _CustomerProducts({required  List<ReportAccount> accounts, required  List<ReportCard> cards, required  List<ReportDevice> devices}): _accounts = accounts,_cards = cards,_devices = devices;
  

 final  List<ReportAccount> _accounts;
@override List<ReportAccount> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

 final  List<ReportCard> _cards;
@override List<ReportCard> get cards {
  if (_cards is EqualUnmodifiableListView) return _cards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cards);
}

 final  List<ReportDevice> _devices;
@override List<ReportDevice> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}


/// Create a copy of CustomerProducts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerProductsCopyWith<_CustomerProducts> get copyWith => __$CustomerProductsCopyWithImpl<_CustomerProducts>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerProducts&&const DeepCollectionEquality().equals(other.accounts, _accounts)&&const DeepCollectionEquality().equals(other.cards, _cards)&&const DeepCollectionEquality().equals(other.devices, _devices));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_accounts),const DeepCollectionEquality().hash(_cards),const DeepCollectionEquality().hash(_devices));
}

@override
String toString() {
    return 'CustomerProducts(accounts: $accounts, cards: $cards, devices: $devices)';
}


}

/// @nodoc
abstract mixin class _$CustomerProductsCopyWith<$Res> implements $CustomerProductsCopyWith<$Res> {
  factory _$CustomerProductsCopyWith(_CustomerProducts value, $Res Function(_CustomerProducts) _then) = __$CustomerProductsCopyWithImpl;
@override @useResult
$Res call({
 List<ReportAccount> accounts, List<ReportCard> cards, List<ReportDevice> devices
});




}
/// @nodoc
class __$CustomerProductsCopyWithImpl<$Res>
    implements _$CustomerProductsCopyWith<$Res> {
  __$CustomerProductsCopyWithImpl(this._self, this._then);

  final _CustomerProducts _self;
  final $Res Function(_CustomerProducts) _then;

/// Create a copy of CustomerProducts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accounts = null,Object? cards = null,Object? devices = null,}) {
  return _then(_CustomerProducts(
accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<ReportAccount>,cards: null == cards ? _self._cards : cards // ignore: cast_nullable_to_non_nullable
as List<ReportCard>,devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<ReportDevice>,
  ));
}


}

/// @nodoc
mixin _$ReportAccount {

 String get id; String get last4; AccountType get type; Currency get currency; String get bankName; ProductStatus get status; double? get balance; double? get creditLimit; DateTime? get openedOn;
/// Create a copy of ReportAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportAccountCopyWith<ReportAccount> get copyWith => _$ReportAccountCopyWithImpl<ReportAccount>(this as ReportAccount, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReportAccount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportAccount&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.last4, _this.last4) || other.last4 == _this.last4)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.bankName, _this.bankName) || other.bankName == _this.bankName)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.balance, _this.balance) || other.balance == _this.balance)&&(identical(other.creditLimit, _this.creditLimit) || other.creditLimit == _this.creditLimit)&&(identical(other.openedOn, _this.openedOn) || other.openedOn == _this.openedOn));
}


@override
int get hashCode {
  final _this = this as ReportAccount;
  return Object.hash(runtimeType,_this.id,_this.last4,_this.type,_this.currency,_this.bankName,_this.status,_this.balance,_this.creditLimit,_this.openedOn);
}

@override
String toString() {
  final _this = this as ReportAccount;
  return 'ReportAccount(id: ${_this.id}, last4: ${_this.last4}, type: ${_this.type}, currency: ${_this.currency}, bankName: ${_this.bankName}, status: ${_this.status}, balance: ${_this.balance}, creditLimit: ${_this.creditLimit}, openedOn: ${_this.openedOn})';
}


}

/// @nodoc
abstract mixin class $ReportAccountCopyWith<$Res>  {
  factory $ReportAccountCopyWith(ReportAccount value, $Res Function(ReportAccount) _then) = _$ReportAccountCopyWithImpl;
@useResult
$Res call({
 String id, String last4, AccountType type, Currency currency, String bankName, ProductStatus status, double? balance, double? creditLimit, DateTime? openedOn
});




}
/// @nodoc
class _$ReportAccountCopyWithImpl<$Res>
    implements $ReportAccountCopyWith<$Res> {
  _$ReportAccountCopyWithImpl(this._self, this._then);

  final ReportAccount _self;
  final $Res Function(ReportAccount) _then;

/// Create a copy of ReportAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? last4 = null,Object? type = null,Object? currency = null,Object? bankName = null,Object? status = null,Object? balance = freezed,Object? creditLimit = freezed,Object? openedOn = freezed,}) {
  return _then(ReportAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,last4: null == last4 ? _self.last4 : last4 // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductStatus,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double?,creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as double?,openedOn: freezed == openedOn ? _self.openedOn : openedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportAccount].
extension ReportAccountPatterns on ReportAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportAccount value)  $default,){
final _that = this;
switch (_that) {
case _ReportAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportAccount value)?  $default,){
final _that = this;
switch (_that) {
case _ReportAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String last4,  AccountType type,  Currency currency,  String bankName,  ProductStatus status,  double? balance,  double? creditLimit,  DateTime? openedOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportAccount() when $default != null:
return $default(_that.id,_that.last4,_that.type,_that.currency,_that.bankName,_that.status,_that.balance,_that.creditLimit,_that.openedOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String last4,  AccountType type,  Currency currency,  String bankName,  ProductStatus status,  double? balance,  double? creditLimit,  DateTime? openedOn)  $default,) {final _that = this;
switch (_that) {
case _ReportAccount():
return $default(_that.id,_that.last4,_that.type,_that.currency,_that.bankName,_that.status,_that.balance,_that.creditLimit,_that.openedOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String last4,  AccountType type,  Currency currency,  String bankName,  ProductStatus status,  double? balance,  double? creditLimit,  DateTime? openedOn)?  $default,) {final _that = this;
switch (_that) {
case _ReportAccount() when $default != null:
return $default(_that.id,_that.last4,_that.type,_that.currency,_that.bankName,_that.status,_that.balance,_that.creditLimit,_that.openedOn);case _:
  return null;

}
}

}

/// @nodoc


class _ReportAccount implements ReportAccount {
  const _ReportAccount({required this.id, required this.last4, required this.type, required this.currency, required this.bankName, required this.status, this.balance, this.creditLimit, this.openedOn});
  

@override final  String id;
@override final  String last4;
@override final  AccountType type;
@override final  Currency currency;
@override final  String bankName;
@override final  ProductStatus status;
@override final  double? balance;
@override final  double? creditLimit;
@override final  DateTime? openedOn;

/// Create a copy of ReportAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportAccountCopyWith<_ReportAccount> get copyWith => __$ReportAccountCopyWithImpl<_ReportAccount>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.last4, last4) || other.last4 == last4)&&(identical(other.type, type) || other.type == type)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.status, status) || other.status == status)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.creditLimit, creditLimit) || other.creditLimit == creditLimit)&&(identical(other.openedOn, openedOn) || other.openedOn == openedOn));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,last4,type,currency,bankName,status,balance,creditLimit,openedOn);
}

@override
String toString() {
    return 'ReportAccount(id: $id, last4: $last4, type: $type, currency: $currency, bankName: $bankName, status: $status, balance: $balance, creditLimit: $creditLimit, openedOn: $openedOn)';
}


}

/// @nodoc
abstract mixin class _$ReportAccountCopyWith<$Res> implements $ReportAccountCopyWith<$Res> {
  factory _$ReportAccountCopyWith(_ReportAccount value, $Res Function(_ReportAccount) _then) = __$ReportAccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String last4, AccountType type, Currency currency, String bankName, ProductStatus status, double? balance, double? creditLimit, DateTime? openedOn
});




}
/// @nodoc
class __$ReportAccountCopyWithImpl<$Res>
    implements _$ReportAccountCopyWith<$Res> {
  __$ReportAccountCopyWithImpl(this._self, this._then);

  final _ReportAccount _self;
  final $Res Function(_ReportAccount) _then;

/// Create a copy of ReportAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? last4 = null,Object? type = null,Object? currency = null,Object? bankName = null,Object? status = null,Object? balance = freezed,Object? creditLimit = freezed,Object? openedOn = freezed,}) {
  return _then(_ReportAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,last4: null == last4 ? _self.last4 : last4 // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,bankName: null == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductStatus,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double?,creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as double?,openedOn: freezed == openedOn ? _self.openedOn : openedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ReportCard {

 String get id; String get last4; String get network; CardType get type; ProductStatus get status; DateTime get expiresOn;/// The account the card draws on, as its last four digits.
 String? get accountLast4;/// The currency of that account, for the limit.
 Currency? get currency; double? get creditLimit;
/// Create a copy of ReportCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportCardCopyWith<ReportCard> get copyWith => _$ReportCardCopyWithImpl<ReportCard>(this as ReportCard, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReportCard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportCard&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.last4, _this.last4) || other.last4 == _this.last4)&&(identical(other.network, _this.network) || other.network == _this.network)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.expiresOn, _this.expiresOn) || other.expiresOn == _this.expiresOn)&&(identical(other.accountLast4, _this.accountLast4) || other.accountLast4 == _this.accountLast4)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.creditLimit, _this.creditLimit) || other.creditLimit == _this.creditLimit));
}


@override
int get hashCode {
  final _this = this as ReportCard;
  return Object.hash(runtimeType,_this.id,_this.last4,_this.network,_this.type,_this.status,_this.expiresOn,_this.accountLast4,_this.currency,_this.creditLimit);
}

@override
String toString() {
  final _this = this as ReportCard;
  return 'ReportCard(id: ${_this.id}, last4: ${_this.last4}, network: ${_this.network}, type: ${_this.type}, status: ${_this.status}, expiresOn: ${_this.expiresOn}, accountLast4: ${_this.accountLast4}, currency: ${_this.currency}, creditLimit: ${_this.creditLimit})';
}


}

/// @nodoc
abstract mixin class $ReportCardCopyWith<$Res>  {
  factory $ReportCardCopyWith(ReportCard value, $Res Function(ReportCard) _then) = _$ReportCardCopyWithImpl;
@useResult
$Res call({
 String id, String last4, String network, CardType type, ProductStatus status, DateTime expiresOn, String? accountLast4, Currency? currency, double? creditLimit
});




}
/// @nodoc
class _$ReportCardCopyWithImpl<$Res>
    implements $ReportCardCopyWith<$Res> {
  _$ReportCardCopyWithImpl(this._self, this._then);

  final ReportCard _self;
  final $Res Function(ReportCard) _then;

/// Create a copy of ReportCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? last4 = null,Object? network = null,Object? type = null,Object? status = null,Object? expiresOn = null,Object? accountLast4 = freezed,Object? currency = freezed,Object? creditLimit = freezed,}) {
  return _then(ReportCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,last4: null == last4 ? _self.last4 : last4 // ignore: cast_nullable_to_non_nullable
as String,network: null == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CardType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductStatus,expiresOn: null == expiresOn ? _self.expiresOn : expiresOn // ignore: cast_nullable_to_non_nullable
as DateTime,accountLast4: freezed == accountLast4 ? _self.accountLast4 : accountLast4 // ignore: cast_nullable_to_non_nullable
as String?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency?,creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportCard].
extension ReportCardPatterns on ReportCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportCard value)  $default,){
final _that = this;
switch (_that) {
case _ReportCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportCard value)?  $default,){
final _that = this;
switch (_that) {
case _ReportCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String last4,  String network,  CardType type,  ProductStatus status,  DateTime expiresOn,  String? accountLast4,  Currency? currency,  double? creditLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportCard() when $default != null:
return $default(_that.id,_that.last4,_that.network,_that.type,_that.status,_that.expiresOn,_that.accountLast4,_that.currency,_that.creditLimit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String last4,  String network,  CardType type,  ProductStatus status,  DateTime expiresOn,  String? accountLast4,  Currency? currency,  double? creditLimit)  $default,) {final _that = this;
switch (_that) {
case _ReportCard():
return $default(_that.id,_that.last4,_that.network,_that.type,_that.status,_that.expiresOn,_that.accountLast4,_that.currency,_that.creditLimit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String last4,  String network,  CardType type,  ProductStatus status,  DateTime expiresOn,  String? accountLast4,  Currency? currency,  double? creditLimit)?  $default,) {final _that = this;
switch (_that) {
case _ReportCard() when $default != null:
return $default(_that.id,_that.last4,_that.network,_that.type,_that.status,_that.expiresOn,_that.accountLast4,_that.currency,_that.creditLimit);case _:
  return null;

}
}

}

/// @nodoc


class _ReportCard implements ReportCard {
  const _ReportCard({required this.id, required this.last4, required this.network, required this.type, required this.status, required this.expiresOn, this.accountLast4, this.currency, this.creditLimit});
  

@override final  String id;
@override final  String last4;
@override final  String network;
@override final  CardType type;
@override final  ProductStatus status;
@override final  DateTime expiresOn;
/// The account the card draws on, as its last four digits.
@override final  String? accountLast4;
/// The currency of that account, for the limit.
@override final  Currency? currency;
@override final  double? creditLimit;

/// Create a copy of ReportCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportCardCopyWith<_ReportCard> get copyWith => __$ReportCardCopyWithImpl<_ReportCard>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportCard&&(identical(other.id, id) || other.id == id)&&(identical(other.last4, last4) || other.last4 == last4)&&(identical(other.network, network) || other.network == network)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiresOn, expiresOn) || other.expiresOn == expiresOn)&&(identical(other.accountLast4, accountLast4) || other.accountLast4 == accountLast4)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.creditLimit, creditLimit) || other.creditLimit == creditLimit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,last4,network,type,status,expiresOn,accountLast4,currency,creditLimit);
}

@override
String toString() {
    return 'ReportCard(id: $id, last4: $last4, network: $network, type: $type, status: $status, expiresOn: $expiresOn, accountLast4: $accountLast4, currency: $currency, creditLimit: $creditLimit)';
}


}

/// @nodoc
abstract mixin class _$ReportCardCopyWith<$Res> implements $ReportCardCopyWith<$Res> {
  factory _$ReportCardCopyWith(_ReportCard value, $Res Function(_ReportCard) _then) = __$ReportCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String last4, String network, CardType type, ProductStatus status, DateTime expiresOn, String? accountLast4, Currency? currency, double? creditLimit
});




}
/// @nodoc
class __$ReportCardCopyWithImpl<$Res>
    implements _$ReportCardCopyWith<$Res> {
  __$ReportCardCopyWithImpl(this._self, this._then);

  final _ReportCard _self;
  final $Res Function(_ReportCard) _then;

/// Create a copy of ReportCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? last4 = null,Object? network = null,Object? type = null,Object? status = null,Object? expiresOn = null,Object? accountLast4 = freezed,Object? currency = freezed,Object? creditLimit = freezed,}) {
  return _then(_ReportCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,last4: null == last4 ? _self.last4 : last4 // ignore: cast_nullable_to_non_nullable
as String,network: null == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CardType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductStatus,expiresOn: null == expiresOn ? _self.expiresOn : expiresOn // ignore: cast_nullable_to_non_nullable
as DateTime,accountLast4: freezed == accountLast4 ? _self.accountLast4 : accountLast4 // ignore: cast_nullable_to_non_nullable
as String?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency?,creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$ReportDevice {

 String get id; DeviceType get type;/// Brand and model, e.g. «Samsung Galaxy A54». Null when the bank does not know.
 String? get name;/// System and version, e.g. «Android 14».
 String? get system; DateTime get firstSeenAt; DateTime get lastSeenAt; bool get isTrusted;
/// Create a copy of ReportDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportDeviceCopyWith<ReportDevice> get copyWith => _$ReportDeviceCopyWithImpl<ReportDevice>(this as ReportDevice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReportDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportDevice&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.system, _this.system) || other.system == _this.system)&&(identical(other.firstSeenAt, _this.firstSeenAt) || other.firstSeenAt == _this.firstSeenAt)&&(identical(other.lastSeenAt, _this.lastSeenAt) || other.lastSeenAt == _this.lastSeenAt)&&(identical(other.isTrusted, _this.isTrusted) || other.isTrusted == _this.isTrusted));
}


@override
int get hashCode {
  final _this = this as ReportDevice;
  return Object.hash(runtimeType,_this.id,_this.type,_this.name,_this.system,_this.firstSeenAt,_this.lastSeenAt,_this.isTrusted);
}

@override
String toString() {
  final _this = this as ReportDevice;
  return 'ReportDevice(id: ${_this.id}, type: ${_this.type}, name: ${_this.name}, system: ${_this.system}, firstSeenAt: ${_this.firstSeenAt}, lastSeenAt: ${_this.lastSeenAt}, isTrusted: ${_this.isTrusted})';
}


}

/// @nodoc
abstract mixin class $ReportDeviceCopyWith<$Res>  {
  factory $ReportDeviceCopyWith(ReportDevice value, $Res Function(ReportDevice) _then) = _$ReportDeviceCopyWithImpl;
@useResult
$Res call({
 String id, DeviceType type, String? name, String? system, DateTime firstSeenAt, DateTime lastSeenAt, bool isTrusted
});




}
/// @nodoc
class _$ReportDeviceCopyWithImpl<$Res>
    implements $ReportDeviceCopyWith<$Res> {
  _$ReportDeviceCopyWithImpl(this._self, this._then);

  final ReportDevice _self;
  final $Res Function(ReportDevice) _then;

/// Create a copy of ReportDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = freezed,Object? system = freezed,Object? firstSeenAt = null,Object? lastSeenAt = null,Object? isTrusted = null,}) {
  return _then(ReportDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DeviceType,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,system: freezed == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as String?,firstSeenAt: null == firstSeenAt ? _self.firstSeenAt : firstSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,isTrusted: null == isTrusted ? _self.isTrusted : isTrusted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportDevice].
extension ReportDevicePatterns on ReportDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportDevice value)  $default,){
final _that = this;
switch (_that) {
case _ReportDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportDevice value)?  $default,){
final _that = this;
switch (_that) {
case _ReportDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DeviceType type,  String? name,  String? system,  DateTime firstSeenAt,  DateTime lastSeenAt,  bool isTrusted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportDevice() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.system,_that.firstSeenAt,_that.lastSeenAt,_that.isTrusted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DeviceType type,  String? name,  String? system,  DateTime firstSeenAt,  DateTime lastSeenAt,  bool isTrusted)  $default,) {final _that = this;
switch (_that) {
case _ReportDevice():
return $default(_that.id,_that.type,_that.name,_that.system,_that.firstSeenAt,_that.lastSeenAt,_that.isTrusted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DeviceType type,  String? name,  String? system,  DateTime firstSeenAt,  DateTime lastSeenAt,  bool isTrusted)?  $default,) {final _that = this;
switch (_that) {
case _ReportDevice() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.system,_that.firstSeenAt,_that.lastSeenAt,_that.isTrusted);case _:
  return null;

}
}

}

/// @nodoc


class _ReportDevice implements ReportDevice {
  const _ReportDevice({required this.id, required this.type, this.name, this.system, required this.firstSeenAt, required this.lastSeenAt, required this.isTrusted});
  

@override final  String id;
@override final  DeviceType type;
/// Brand and model, e.g. «Samsung Galaxy A54». Null when the bank does not know.
@override final  String? name;
/// System and version, e.g. «Android 14».
@override final  String? system;
@override final  DateTime firstSeenAt;
@override final  DateTime lastSeenAt;
@override final  bool isTrusted;

/// Create a copy of ReportDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportDeviceCopyWith<_ReportDevice> get copyWith => __$ReportDeviceCopyWithImpl<_ReportDevice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.system, system) || other.system == system)&&(identical(other.firstSeenAt, firstSeenAt) || other.firstSeenAt == firstSeenAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.isTrusted, isTrusted) || other.isTrusted == isTrusted));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,type,name,system,firstSeenAt,lastSeenAt,isTrusted);
}

@override
String toString() {
    return 'ReportDevice(id: $id, type: $type, name: $name, system: $system, firstSeenAt: $firstSeenAt, lastSeenAt: $lastSeenAt, isTrusted: $isTrusted)';
}


}

/// @nodoc
abstract mixin class _$ReportDeviceCopyWith<$Res> implements $ReportDeviceCopyWith<$Res> {
  factory _$ReportDeviceCopyWith(_ReportDevice value, $Res Function(_ReportDevice) _then) = __$ReportDeviceCopyWithImpl;
@override @useResult
$Res call({
 String id, DeviceType type, String? name, String? system, DateTime firstSeenAt, DateTime lastSeenAt, bool isTrusted
});




}
/// @nodoc
class __$ReportDeviceCopyWithImpl<$Res>
    implements _$ReportDeviceCopyWith<$Res> {
  __$ReportDeviceCopyWithImpl(this._self, this._then);

  final _ReportDevice _self;
  final $Res Function(_ReportDevice) _then;

/// Create a copy of ReportDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = freezed,Object? system = freezed,Object? firstSeenAt = null,Object? lastSeenAt = null,Object? isTrusted = null,}) {
  return _then(_ReportDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DeviceType,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,system: freezed == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as String?,firstSeenAt: null == firstSeenAt ? _self.firstSeenAt : firstSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,isTrusted: null == isTrusted ? _self.isTrusted : isTrusted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$CustomerHistory {

 List<LabelHistoryItem> get labels; List<AlertHistoryItem> get alerts;
/// Create a copy of CustomerHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerHistoryCopyWith<CustomerHistory> get copyWith => _$CustomerHistoryCopyWithImpl<CustomerHistory>(this as CustomerHistory, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerHistory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerHistory&&const DeepCollectionEquality().equals(other.labels, _this.labels)&&const DeepCollectionEquality().equals(other.alerts, _this.alerts));
}


@override
int get hashCode {
  final _this = this as CustomerHistory;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.labels),const DeepCollectionEquality().hash(_this.alerts));
}

@override
String toString() {
  final _this = this as CustomerHistory;
  return 'CustomerHistory(labels: ${_this.labels}, alerts: ${_this.alerts})';
}


}

/// @nodoc
abstract mixin class $CustomerHistoryCopyWith<$Res>  {
  factory $CustomerHistoryCopyWith(CustomerHistory value, $Res Function(CustomerHistory) _then) = _$CustomerHistoryCopyWithImpl;
@useResult
$Res call({
 List<LabelHistoryItem> labels, List<AlertHistoryItem> alerts
});




}
/// @nodoc
class _$CustomerHistoryCopyWithImpl<$Res>
    implements $CustomerHistoryCopyWith<$Res> {
  _$CustomerHistoryCopyWithImpl(this._self, this._then);

  final CustomerHistory _self;
  final $Res Function(CustomerHistory) _then;

/// Create a copy of CustomerHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? labels = null,Object? alerts = null,}) {
  return _then(CustomerHistory(
labels: null == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as List<LabelHistoryItem>,alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<AlertHistoryItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerHistory].
extension CustomerHistoryPatterns on CustomerHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerHistory value)  $default,){
final _that = this;
switch (_that) {
case _CustomerHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerHistory value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LabelHistoryItem> labels,  List<AlertHistoryItem> alerts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerHistory() when $default != null:
return $default(_that.labels,_that.alerts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LabelHistoryItem> labels,  List<AlertHistoryItem> alerts)  $default,) {final _that = this;
switch (_that) {
case _CustomerHistory():
return $default(_that.labels,_that.alerts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LabelHistoryItem> labels,  List<AlertHistoryItem> alerts)?  $default,) {final _that = this;
switch (_that) {
case _CustomerHistory() when $default != null:
return $default(_that.labels,_that.alerts);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerHistory implements CustomerHistory {
  const _CustomerHistory({required  List<LabelHistoryItem> labels, required  List<AlertHistoryItem> alerts}): _labels = labels,_alerts = alerts;
  

 final  List<LabelHistoryItem> _labels;
@override List<LabelHistoryItem> get labels {
  if (_labels is EqualUnmodifiableListView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labels);
}

 final  List<AlertHistoryItem> _alerts;
@override List<AlertHistoryItem> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}


/// Create a copy of CustomerHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerHistoryCopyWith<_CustomerHistory> get copyWith => __$CustomerHistoryCopyWithImpl<_CustomerHistory>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerHistory&&const DeepCollectionEquality().equals(other.labels, _labels)&&const DeepCollectionEquality().equals(other.alerts, _alerts));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_labels),const DeepCollectionEquality().hash(_alerts));
}

@override
String toString() {
    return 'CustomerHistory(labels: $labels, alerts: $alerts)';
}


}

/// @nodoc
abstract mixin class _$CustomerHistoryCopyWith<$Res> implements $CustomerHistoryCopyWith<$Res> {
  factory _$CustomerHistoryCopyWith(_CustomerHistory value, $Res Function(_CustomerHistory) _then) = __$CustomerHistoryCopyWithImpl;
@override @useResult
$Res call({
 List<LabelHistoryItem> labels, List<AlertHistoryItem> alerts
});




}
/// @nodoc
class __$CustomerHistoryCopyWithImpl<$Res>
    implements _$CustomerHistoryCopyWith<$Res> {
  __$CustomerHistoryCopyWithImpl(this._self, this._then);

  final _CustomerHistory _self;
  final $Res Function(_CustomerHistory) _then;

/// Create a copy of CustomerHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? labels = null,Object? alerts = null,}) {
  return _then(_CustomerHistory(
labels: null == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as List<LabelHistoryItem>,alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<AlertHistoryItem>,
  ));
}


}

/// @nodoc
mixin _$LabelHistoryItem {

 int get transactionId; String get transactionCode; DateTime get occurredAt; Verdict get verdict; String? get analystName; DateTime? get labeledAt;
/// Create a copy of LabelHistoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LabelHistoryItemCopyWith<LabelHistoryItem> get copyWith => _$LabelHistoryItemCopyWithImpl<LabelHistoryItem>(this as LabelHistoryItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LabelHistoryItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LabelHistoryItem&&(identical(other.transactionId, _this.transactionId) || other.transactionId == _this.transactionId)&&(identical(other.transactionCode, _this.transactionCode) || other.transactionCode == _this.transactionCode)&&(identical(other.occurredAt, _this.occurredAt) || other.occurredAt == _this.occurredAt)&&(identical(other.verdict, _this.verdict) || other.verdict == _this.verdict)&&(identical(other.analystName, _this.analystName) || other.analystName == _this.analystName)&&(identical(other.labeledAt, _this.labeledAt) || other.labeledAt == _this.labeledAt));
}


@override
int get hashCode {
  final _this = this as LabelHistoryItem;
  return Object.hash(runtimeType,_this.transactionId,_this.transactionCode,_this.occurredAt,_this.verdict,_this.analystName,_this.labeledAt);
}

@override
String toString() {
  final _this = this as LabelHistoryItem;
  return 'LabelHistoryItem(transactionId: ${_this.transactionId}, transactionCode: ${_this.transactionCode}, occurredAt: ${_this.occurredAt}, verdict: ${_this.verdict}, analystName: ${_this.analystName}, labeledAt: ${_this.labeledAt})';
}


}

/// @nodoc
abstract mixin class $LabelHistoryItemCopyWith<$Res>  {
  factory $LabelHistoryItemCopyWith(LabelHistoryItem value, $Res Function(LabelHistoryItem) _then) = _$LabelHistoryItemCopyWithImpl;
@useResult
$Res call({
 int transactionId, String transactionCode, DateTime occurredAt, Verdict verdict, String? analystName, DateTime? labeledAt
});




}
/// @nodoc
class _$LabelHistoryItemCopyWithImpl<$Res>
    implements $LabelHistoryItemCopyWith<$Res> {
  _$LabelHistoryItemCopyWithImpl(this._self, this._then);

  final LabelHistoryItem _self;
  final $Res Function(LabelHistoryItem) _then;

/// Create a copy of LabelHistoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactionId = null,Object? transactionCode = null,Object? occurredAt = null,Object? verdict = null,Object? analystName = freezed,Object? labeledAt = freezed,}) {
  return _then(LabelHistoryItem(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as int,transactionCode: null == transactionCode ? _self.transactionCode : transactionCode // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict,analystName: freezed == analystName ? _self.analystName : analystName // ignore: cast_nullable_to_non_nullable
as String?,labeledAt: freezed == labeledAt ? _self.labeledAt : labeledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [LabelHistoryItem].
extension LabelHistoryItemPatterns on LabelHistoryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LabelHistoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LabelHistoryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LabelHistoryItem value)  $default,){
final _that = this;
switch (_that) {
case _LabelHistoryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LabelHistoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _LabelHistoryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int transactionId,  String transactionCode,  DateTime occurredAt,  Verdict verdict,  String? analystName,  DateTime? labeledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LabelHistoryItem() when $default != null:
return $default(_that.transactionId,_that.transactionCode,_that.occurredAt,_that.verdict,_that.analystName,_that.labeledAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int transactionId,  String transactionCode,  DateTime occurredAt,  Verdict verdict,  String? analystName,  DateTime? labeledAt)  $default,) {final _that = this;
switch (_that) {
case _LabelHistoryItem():
return $default(_that.transactionId,_that.transactionCode,_that.occurredAt,_that.verdict,_that.analystName,_that.labeledAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int transactionId,  String transactionCode,  DateTime occurredAt,  Verdict verdict,  String? analystName,  DateTime? labeledAt)?  $default,) {final _that = this;
switch (_that) {
case _LabelHistoryItem() when $default != null:
return $default(_that.transactionId,_that.transactionCode,_that.occurredAt,_that.verdict,_that.analystName,_that.labeledAt);case _:
  return null;

}
}

}

/// @nodoc


class _LabelHistoryItem implements LabelHistoryItem {
  const _LabelHistoryItem({required this.transactionId, required this.transactionCode, required this.occurredAt, required this.verdict, this.analystName, this.labeledAt});
  

@override final  int transactionId;
@override final  String transactionCode;
@override final  DateTime occurredAt;
@override final  Verdict verdict;
@override final  String? analystName;
@override final  DateTime? labeledAt;

/// Create a copy of LabelHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LabelHistoryItemCopyWith<_LabelHistoryItem> get copyWith => __$LabelHistoryItemCopyWithImpl<_LabelHistoryItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LabelHistoryItem&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.transactionCode, transactionCode) || other.transactionCode == transactionCode)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.verdict, verdict) || other.verdict == verdict)&&(identical(other.analystName, analystName) || other.analystName == analystName)&&(identical(other.labeledAt, labeledAt) || other.labeledAt == labeledAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,transactionId,transactionCode,occurredAt,verdict,analystName,labeledAt);
}

@override
String toString() {
    return 'LabelHistoryItem(transactionId: $transactionId, transactionCode: $transactionCode, occurredAt: $occurredAt, verdict: $verdict, analystName: $analystName, labeledAt: $labeledAt)';
}


}

/// @nodoc
abstract mixin class _$LabelHistoryItemCopyWith<$Res> implements $LabelHistoryItemCopyWith<$Res> {
  factory _$LabelHistoryItemCopyWith(_LabelHistoryItem value, $Res Function(_LabelHistoryItem) _then) = __$LabelHistoryItemCopyWithImpl;
@override @useResult
$Res call({
 int transactionId, String transactionCode, DateTime occurredAt, Verdict verdict, String? analystName, DateTime? labeledAt
});




}
/// @nodoc
class __$LabelHistoryItemCopyWithImpl<$Res>
    implements _$LabelHistoryItemCopyWith<$Res> {
  __$LabelHistoryItemCopyWithImpl(this._self, this._then);

  final _LabelHistoryItem _self;
  final $Res Function(_LabelHistoryItem) _then;

/// Create a copy of LabelHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactionId = null,Object? transactionCode = null,Object? occurredAt = null,Object? verdict = null,Object? analystName = freezed,Object? labeledAt = freezed,}) {
  return _then(_LabelHistoryItem(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as int,transactionCode: null == transactionCode ? _self.transactionCode : transactionCode // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,verdict: null == verdict ? _self.verdict : verdict // ignore: cast_nullable_to_non_nullable
as Verdict,analystName: freezed == analystName ? _self.analystName : analystName // ignore: cast_nullable_to_non_nullable
as String?,labeledAt: freezed == labeledAt ? _self.labeledAt : labeledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$AlertHistoryItem {

 String get code; int get score; AlertStatus get status; FraudType get suggestedType; DateTime get generatedAt;
/// Create a copy of AlertHistoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertHistoryItemCopyWith<AlertHistoryItem> get copyWith => _$AlertHistoryItemCopyWithImpl<AlertHistoryItem>(this as AlertHistoryItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AlertHistoryItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertHistoryItem&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.suggestedType, _this.suggestedType) || other.suggestedType == _this.suggestedType)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt));
}


@override
int get hashCode {
  final _this = this as AlertHistoryItem;
  return Object.hash(runtimeType,_this.code,_this.score,_this.status,_this.suggestedType,_this.generatedAt);
}

@override
String toString() {
  final _this = this as AlertHistoryItem;
  return 'AlertHistoryItem(code: ${_this.code}, score: ${_this.score}, status: ${_this.status}, suggestedType: ${_this.suggestedType}, generatedAt: ${_this.generatedAt})';
}


}

/// @nodoc
abstract mixin class $AlertHistoryItemCopyWith<$Res>  {
  factory $AlertHistoryItemCopyWith(AlertHistoryItem value, $Res Function(AlertHistoryItem) _then) = _$AlertHistoryItemCopyWithImpl;
@useResult
$Res call({
 String code, int score, AlertStatus status, FraudType suggestedType, DateTime generatedAt
});




}
/// @nodoc
class _$AlertHistoryItemCopyWithImpl<$Res>
    implements $AlertHistoryItemCopyWith<$Res> {
  _$AlertHistoryItemCopyWithImpl(this._self, this._then);

  final AlertHistoryItem _self;
  final $Res Function(AlertHistoryItem) _then;

/// Create a copy of AlertHistoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? score = null,Object? status = null,Object? suggestedType = null,Object? generatedAt = null,}) {
  return _then(AlertHistoryItem(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlertStatus,suggestedType: null == suggestedType ? _self.suggestedType : suggestedType // ignore: cast_nullable_to_non_nullable
as FraudType,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertHistoryItem].
extension AlertHistoryItemPatterns on AlertHistoryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertHistoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertHistoryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertHistoryItem value)  $default,){
final _that = this;
switch (_that) {
case _AlertHistoryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertHistoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _AlertHistoryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  int score,  AlertStatus status,  FraudType suggestedType,  DateTime generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertHistoryItem() when $default != null:
return $default(_that.code,_that.score,_that.status,_that.suggestedType,_that.generatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  int score,  AlertStatus status,  FraudType suggestedType,  DateTime generatedAt)  $default,) {final _that = this;
switch (_that) {
case _AlertHistoryItem():
return $default(_that.code,_that.score,_that.status,_that.suggestedType,_that.generatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  int score,  AlertStatus status,  FraudType suggestedType,  DateTime generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AlertHistoryItem() when $default != null:
return $default(_that.code,_that.score,_that.status,_that.suggestedType,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _AlertHistoryItem implements AlertHistoryItem {
  const _AlertHistoryItem({required this.code, required this.score, required this.status, required this.suggestedType, required this.generatedAt});
  

@override final  String code;
@override final  int score;
@override final  AlertStatus status;
@override final  FraudType suggestedType;
@override final  DateTime generatedAt;

/// Create a copy of AlertHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertHistoryItemCopyWith<_AlertHistoryItem> get copyWith => __$AlertHistoryItemCopyWithImpl<_AlertHistoryItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertHistoryItem&&(identical(other.code, code) || other.code == code)&&(identical(other.score, score) || other.score == score)&&(identical(other.status, status) || other.status == status)&&(identical(other.suggestedType, suggestedType) || other.suggestedType == suggestedType)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,score,status,suggestedType,generatedAt);
}

@override
String toString() {
    return 'AlertHistoryItem(code: $code, score: $score, status: $status, suggestedType: $suggestedType, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$AlertHistoryItemCopyWith<$Res> implements $AlertHistoryItemCopyWith<$Res> {
  factory _$AlertHistoryItemCopyWith(_AlertHistoryItem value, $Res Function(_AlertHistoryItem) _then) = __$AlertHistoryItemCopyWithImpl;
@override @useResult
$Res call({
 String code, int score, AlertStatus status, FraudType suggestedType, DateTime generatedAt
});




}
/// @nodoc
class __$AlertHistoryItemCopyWithImpl<$Res>
    implements _$AlertHistoryItemCopyWith<$Res> {
  __$AlertHistoryItemCopyWithImpl(this._self, this._then);

  final _AlertHistoryItem _self;
  final $Res Function(_AlertHistoryItem) _then;

/// Create a copy of AlertHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? score = null,Object? status = null,Object? suggestedType = null,Object? generatedAt = null,}) {
  return _then(_AlertHistoryItem(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlertStatus,suggestedType: null == suggestedType ? _self.suggestedType : suggestedType // ignore: cast_nullable_to_non_nullable
as FraudType,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$MonthlyActivity {

/// The first day of the month.
 DateTime get month; Currency get currency; int get transactionCount; double get totalAmount;
/// Create a copy of MonthlyActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyActivityCopyWith<MonthlyActivity> get copyWith => _$MonthlyActivityCopyWithImpl<MonthlyActivity>(this as MonthlyActivity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MonthlyActivity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyActivity&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.transactionCount, _this.transactionCount) || other.transactionCount == _this.transactionCount)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount));
}


@override
int get hashCode {
  final _this = this as MonthlyActivity;
  return Object.hash(runtimeType,_this.month,_this.currency,_this.transactionCount,_this.totalAmount);
}

@override
String toString() {
  final _this = this as MonthlyActivity;
  return 'MonthlyActivity(month: ${_this.month}, currency: ${_this.currency}, transactionCount: ${_this.transactionCount}, totalAmount: ${_this.totalAmount})';
}


}

/// @nodoc
abstract mixin class $MonthlyActivityCopyWith<$Res>  {
  factory $MonthlyActivityCopyWith(MonthlyActivity value, $Res Function(MonthlyActivity) _then) = _$MonthlyActivityCopyWithImpl;
@useResult
$Res call({
 DateTime month, Currency currency, int transactionCount, double totalAmount
});




}
/// @nodoc
class _$MonthlyActivityCopyWithImpl<$Res>
    implements $MonthlyActivityCopyWith<$Res> {
  _$MonthlyActivityCopyWithImpl(this._self, this._then);

  final MonthlyActivity _self;
  final $Res Function(MonthlyActivity) _then;

/// Create a copy of MonthlyActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? currency = null,Object? transactionCount = null,Object? totalAmount = null,}) {
  return _then(MonthlyActivity(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyActivity].
extension MonthlyActivityPatterns on MonthlyActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyActivity value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyActivity value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  Currency currency,  int transactionCount,  double totalAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyActivity() when $default != null:
return $default(_that.month,_that.currency,_that.transactionCount,_that.totalAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  Currency currency,  int transactionCount,  double totalAmount)  $default,) {final _that = this;
switch (_that) {
case _MonthlyActivity():
return $default(_that.month,_that.currency,_that.transactionCount,_that.totalAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  Currency currency,  int transactionCount,  double totalAmount)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyActivity() when $default != null:
return $default(_that.month,_that.currency,_that.transactionCount,_that.totalAmount);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlyActivity implements MonthlyActivity {
  const _MonthlyActivity({required this.month, required this.currency, required this.transactionCount, required this.totalAmount});
  

/// The first day of the month.
@override final  DateTime month;
@override final  Currency currency;
@override final  int transactionCount;
@override final  double totalAmount;

/// Create a copy of MonthlyActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyActivityCopyWith<_MonthlyActivity> get copyWith => __$MonthlyActivityCopyWithImpl<_MonthlyActivity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyActivity&&(identical(other.month, month) || other.month == month)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,month,currency,transactionCount,totalAmount);
}

@override
String toString() {
    return 'MonthlyActivity(month: $month, currency: $currency, transactionCount: $transactionCount, totalAmount: $totalAmount)';
}


}

/// @nodoc
abstract mixin class _$MonthlyActivityCopyWith<$Res> implements $MonthlyActivityCopyWith<$Res> {
  factory _$MonthlyActivityCopyWith(_MonthlyActivity value, $Res Function(_MonthlyActivity) _then) = __$MonthlyActivityCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, Currency currency, int transactionCount, double totalAmount
});




}
/// @nodoc
class __$MonthlyActivityCopyWithImpl<$Res>
    implements _$MonthlyActivityCopyWith<$Res> {
  __$MonthlyActivityCopyWithImpl(this._self, this._then);

  final _MonthlyActivity _self;
  final $Res Function(_MonthlyActivity) _then;

/// Create a copy of MonthlyActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? currency = null,Object? transactionCount = null,Object? totalAmount = null,}) {
  return _then(_MonthlyActivity(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
