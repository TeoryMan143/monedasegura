// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerAccount {

 String get id; String get last4;@JsonKey(fromJson: AccountType.fromDb) AccountType get type;@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) Currency get currency;
/// Create a copy of CustomerAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerAccountCopyWith<CustomerAccount> get copyWith => _$CustomerAccountCopyWithImpl<CustomerAccount>(this as CustomerAccount, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerAccount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerAccount&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.last4, _this.last4) || other.last4 == _this.last4)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.currency, _this.currency) || other.currency == _this.currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CustomerAccount;
  return Object.hash(runtimeType,_this.id,_this.last4,_this.type,_this.currency);
}

@override
String toString() {
  final _this = this as CustomerAccount;
  return 'CustomerAccount(id: ${_this.id}, last4: ${_this.last4}, type: ${_this.type}, currency: ${_this.currency})';
}


}

/// @nodoc
abstract mixin class $CustomerAccountCopyWith<$Res>  {
  factory $CustomerAccountCopyWith(CustomerAccount value, $Res Function(CustomerAccount) _then) = _$CustomerAccountCopyWithImpl;
@useResult
$Res call({
 String id, String last4,@JsonKey(fromJson: AccountType.fromDb) AccountType type,@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) Currency currency
});




}
/// @nodoc
class _$CustomerAccountCopyWithImpl<$Res>
    implements $CustomerAccountCopyWith<$Res> {
  _$CustomerAccountCopyWithImpl(this._self, this._then);

  final CustomerAccount _self;
  final $Res Function(CustomerAccount) _then;

/// Create a copy of CustomerAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? last4 = null,Object? type = null,Object? currency = null,}) {
  return _then(CustomerAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,last4: null == last4 ? _self.last4 : last4 // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerAccount].
extension CustomerAccountPatterns on CustomerAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerAccount value)  $default,){
final _that = this;
switch (_that) {
case _CustomerAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerAccount value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String last4, @JsonKey(fromJson: AccountType.fromDb)  AccountType type, @JsonKey(name: 'currency_code', fromJson: Currency.fromDb)  Currency currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerAccount() when $default != null:
return $default(_that.id,_that.last4,_that.type,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String last4, @JsonKey(fromJson: AccountType.fromDb)  AccountType type, @JsonKey(name: 'currency_code', fromJson: Currency.fromDb)  Currency currency)  $default,) {final _that = this;
switch (_that) {
case _CustomerAccount():
return $default(_that.id,_that.last4,_that.type,_that.currency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String last4, @JsonKey(fromJson: AccountType.fromDb)  AccountType type, @JsonKey(name: 'currency_code', fromJson: Currency.fromDb)  Currency currency)?  $default,) {final _that = this;
switch (_that) {
case _CustomerAccount() when $default != null:
return $default(_that.id,_that.last4,_that.type,_that.currency);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _CustomerAccount implements CustomerAccount {
  const _CustomerAccount({required this.id, required this.last4, @JsonKey(fromJson: AccountType.fromDb) required this.type, @JsonKey(name: 'currency_code', fromJson: Currency.fromDb) required this.currency});
  factory _CustomerAccount.fromJson(Map<String, dynamic> json) => _$CustomerAccountFromJson(json);

@override final  String id;
@override final  String last4;
@override@JsonKey(fromJson: AccountType.fromDb) final  AccountType type;
@override@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) final  Currency currency;

/// Create a copy of CustomerAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerAccountCopyWith<_CustomerAccount> get copyWith => __$CustomerAccountCopyWithImpl<_CustomerAccount>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.last4, last4) || other.last4 == last4)&&(identical(other.type, type) || other.type == type)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,last4,type,currency);
}

@override
String toString() {
    return 'CustomerAccount(id: $id, last4: $last4, type: $type, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$CustomerAccountCopyWith<$Res> implements $CustomerAccountCopyWith<$Res> {
  factory _$CustomerAccountCopyWith(_CustomerAccount value, $Res Function(_CustomerAccount) _then) = __$CustomerAccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String last4,@JsonKey(fromJson: AccountType.fromDb) AccountType type,@JsonKey(name: 'currency_code', fromJson: Currency.fromDb) Currency currency
});




}
/// @nodoc
class __$CustomerAccountCopyWithImpl<$Res>
    implements _$CustomerAccountCopyWith<$Res> {
  __$CustomerAccountCopyWithImpl(this._self, this._then);

  final _CustomerAccount _self;
  final $Res Function(_CustomerAccount) _then;

/// Create a copy of CustomerAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? last4 = null,Object? type = null,Object? currency = null,}) {
  return _then(_CustomerAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,last4: null == last4 ? _self.last4 : last4 // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,
  ));
}


}

/// @nodoc
mixin _$CustomerView {

 String get id; String get fullName; List<CustomerAccount> get accounts;/// AI alerts of the customer still waiting for an analyst.
 int get pendingAlerts;
/// Create a copy of CustomerView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerViewCopyWith<CustomerView> get copyWith => _$CustomerViewCopyWithImpl<CustomerView>(this as CustomerView, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerView;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerView&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&const DeepCollectionEquality().equals(other.accounts, _this.accounts)&&(identical(other.pendingAlerts, _this.pendingAlerts) || other.pendingAlerts == _this.pendingAlerts));
}


@override
int get hashCode {
  final _this = this as CustomerView;
  return Object.hash(runtimeType,_this.id,_this.fullName,const DeepCollectionEquality().hash(_this.accounts),_this.pendingAlerts);
}

@override
String toString() {
  final _this = this as CustomerView;
  return 'CustomerView(id: ${_this.id}, fullName: ${_this.fullName}, accounts: ${_this.accounts}, pendingAlerts: ${_this.pendingAlerts})';
}


}

/// @nodoc
abstract mixin class $CustomerViewCopyWith<$Res>  {
  factory $CustomerViewCopyWith(CustomerView value, $Res Function(CustomerView) _then) = _$CustomerViewCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, List<CustomerAccount> accounts, int pendingAlerts
});




}
/// @nodoc
class _$CustomerViewCopyWithImpl<$Res>
    implements $CustomerViewCopyWith<$Res> {
  _$CustomerViewCopyWithImpl(this._self, this._then);

  final CustomerView _self;
  final $Res Function(CustomerView) _then;

/// Create a copy of CustomerView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? accounts = null,Object? pendingAlerts = null,}) {
  return _then(CustomerView(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<CustomerAccount>,pendingAlerts: null == pendingAlerts ? _self.pendingAlerts : pendingAlerts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerView].
extension CustomerViewPatterns on CustomerView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerView value)  $default,){
final _that = this;
switch (_that) {
case _CustomerView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerView value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  List<CustomerAccount> accounts,  int pendingAlerts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerView() when $default != null:
return $default(_that.id,_that.fullName,_that.accounts,_that.pendingAlerts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  List<CustomerAccount> accounts,  int pendingAlerts)  $default,) {final _that = this;
switch (_that) {
case _CustomerView():
return $default(_that.id,_that.fullName,_that.accounts,_that.pendingAlerts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  List<CustomerAccount> accounts,  int pendingAlerts)?  $default,) {final _that = this;
switch (_that) {
case _CustomerView() when $default != null:
return $default(_that.id,_that.fullName,_that.accounts,_that.pendingAlerts);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerView extends CustomerView {
  const _CustomerView({required this.id, required this.fullName, required  List<CustomerAccount> accounts, required this.pendingAlerts}): _accounts = accounts,super._();
  

@override final  String id;
@override final  String fullName;
 final  List<CustomerAccount> _accounts;
@override List<CustomerAccount> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

/// AI alerts of the customer still waiting for an analyst.
@override final  int pendingAlerts;

/// Create a copy of CustomerView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerViewCopyWith<_CustomerView> get copyWith => __$CustomerViewCopyWithImpl<_CustomerView>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerView&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&const DeepCollectionEquality().equals(other.accounts, _accounts)&&(identical(other.pendingAlerts, pendingAlerts) || other.pendingAlerts == pendingAlerts));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,fullName,const DeepCollectionEquality().hash(_accounts),pendingAlerts);
}

@override
String toString() {
    return 'CustomerView(id: $id, fullName: $fullName, accounts: $accounts, pendingAlerts: $pendingAlerts)';
}


}

/// @nodoc
abstract mixin class _$CustomerViewCopyWith<$Res> implements $CustomerViewCopyWith<$Res> {
  factory _$CustomerViewCopyWith(_CustomerView value, $Res Function(_CustomerView) _then) = __$CustomerViewCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, List<CustomerAccount> accounts, int pendingAlerts
});




}
/// @nodoc
class __$CustomerViewCopyWithImpl<$Res>
    implements _$CustomerViewCopyWith<$Res> {
  __$CustomerViewCopyWithImpl(this._self, this._then);

  final _CustomerView _self;
  final $Res Function(_CustomerView) _then;

/// Create a copy of CustomerView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? accounts = null,Object? pendingAlerts = null,}) {
  return _then(_CustomerView(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<CustomerAccount>,pendingAlerts: null == pendingAlerts ? _self.pendingAlerts : pendingAlerts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$LabelProgress {

 int get labeled; int get total;
/// Create a copy of LabelProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LabelProgressCopyWith<LabelProgress> get copyWith => _$LabelProgressCopyWithImpl<LabelProgress>(this as LabelProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LabelProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LabelProgress&&(identical(other.labeled, _this.labeled) || other.labeled == _this.labeled)&&(identical(other.total, _this.total) || other.total == _this.total));
}


@override
int get hashCode {
  final _this = this as LabelProgress;
  return Object.hash(runtimeType,_this.labeled,_this.total);
}

@override
String toString() {
  final _this = this as LabelProgress;
  return 'LabelProgress(labeled: ${_this.labeled}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $LabelProgressCopyWith<$Res>  {
  factory $LabelProgressCopyWith(LabelProgress value, $Res Function(LabelProgress) _then) = _$LabelProgressCopyWithImpl;
@useResult
$Res call({
 int labeled, int total
});




}
/// @nodoc
class _$LabelProgressCopyWithImpl<$Res>
    implements $LabelProgressCopyWith<$Res> {
  _$LabelProgressCopyWithImpl(this._self, this._then);

  final LabelProgress _self;
  final $Res Function(LabelProgress) _then;

/// Create a copy of LabelProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? labeled = null,Object? total = null,}) {
  return _then(LabelProgress(
labeled: null == labeled ? _self.labeled : labeled // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LabelProgress].
extension LabelProgressPatterns on LabelProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LabelProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LabelProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LabelProgress value)  $default,){
final _that = this;
switch (_that) {
case _LabelProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LabelProgress value)?  $default,){
final _that = this;
switch (_that) {
case _LabelProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int labeled,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LabelProgress() when $default != null:
return $default(_that.labeled,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int labeled,  int total)  $default,) {final _that = this;
switch (_that) {
case _LabelProgress():
return $default(_that.labeled,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int labeled,  int total)?  $default,) {final _that = this;
switch (_that) {
case _LabelProgress() when $default != null:
return $default(_that.labeled,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _LabelProgress implements LabelProgress {
  const _LabelProgress({required this.labeled, required this.total});
  

@override final  int labeled;
@override final  int total;

/// Create a copy of LabelProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LabelProgressCopyWith<_LabelProgress> get copyWith => __$LabelProgressCopyWithImpl<_LabelProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LabelProgress&&(identical(other.labeled, labeled) || other.labeled == labeled)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode {
    return Object.hash(runtimeType,labeled,total);
}

@override
String toString() {
    return 'LabelProgress(labeled: $labeled, total: $total)';
}


}

/// @nodoc
abstract mixin class _$LabelProgressCopyWith<$Res> implements $LabelProgressCopyWith<$Res> {
  factory _$LabelProgressCopyWith(_LabelProgress value, $Res Function(_LabelProgress) _then) = __$LabelProgressCopyWithImpl;
@override @useResult
$Res call({
 int labeled, int total
});




}
/// @nodoc
class __$LabelProgressCopyWithImpl<$Res>
    implements _$LabelProgressCopyWith<$Res> {
  __$LabelProgressCopyWithImpl(this._self, this._then);

  final _LabelProgress _self;
  final $Res Function(_LabelProgress) _then;

/// Create a copy of LabelProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? labeled = null,Object? total = null,}) {
  return _then(_LabelProgress(
labeled: null == labeled ? _self.labeled : labeled // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
