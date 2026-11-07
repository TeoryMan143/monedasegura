// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transactions_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionsQuery {

/// Customer, account or transaction ID.
 String get search;/// First day of the range, inclusive.
 DateTime? get dateFrom;/// Last day of the range, inclusive.
 DateTime? get dateTo;/// A `countries.code`.
 String? get countryCode;/// `channels.code` values: a transaction matches any of them. Empty means all.
 Set<String> get channelCodes; LabelStatus? get labelStatus;/// True shows only the transactions with an AI alert.
 bool get withAiAlert; TransactionsSort get sort; bool get ascending; int get page; int get pageSize;
/// Create a copy of TransactionsQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionsQueryCopyWith<TransactionsQuery> get copyWith => _$TransactionsQueryCopyWithImpl<TransactionsQuery>(this as TransactionsQuery, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionsQuery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionsQuery&&(identical(other.search, _this.search) || other.search == _this.search)&&(identical(other.dateFrom, _this.dateFrom) || other.dateFrom == _this.dateFrom)&&(identical(other.dateTo, _this.dateTo) || other.dateTo == _this.dateTo)&&(identical(other.countryCode, _this.countryCode) || other.countryCode == _this.countryCode)&&const DeepCollectionEquality().equals(other.channelCodes, _this.channelCodes)&&(identical(other.labelStatus, _this.labelStatus) || other.labelStatus == _this.labelStatus)&&(identical(other.withAiAlert, _this.withAiAlert) || other.withAiAlert == _this.withAiAlert)&&(identical(other.sort, _this.sort) || other.sort == _this.sort)&&(identical(other.ascending, _this.ascending) || other.ascending == _this.ascending)&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.pageSize, _this.pageSize) || other.pageSize == _this.pageSize));
}


@override
int get hashCode {
  final _this = this as TransactionsQuery;
  return Object.hash(runtimeType,_this.search,_this.dateFrom,_this.dateTo,_this.countryCode,const DeepCollectionEquality().hash(_this.channelCodes),_this.labelStatus,_this.withAiAlert,_this.sort,_this.ascending,_this.page,_this.pageSize);
}

@override
String toString() {
  final _this = this as TransactionsQuery;
  return 'TransactionsQuery(search: ${_this.search}, dateFrom: ${_this.dateFrom}, dateTo: ${_this.dateTo}, countryCode: ${_this.countryCode}, channelCodes: ${_this.channelCodes}, labelStatus: ${_this.labelStatus}, withAiAlert: ${_this.withAiAlert}, sort: ${_this.sort}, ascending: ${_this.ascending}, page: ${_this.page}, pageSize: ${_this.pageSize})';
}


}

/// @nodoc
abstract mixin class $TransactionsQueryCopyWith<$Res>  {
  factory $TransactionsQueryCopyWith(TransactionsQuery value, $Res Function(TransactionsQuery) _then) = _$TransactionsQueryCopyWithImpl;
@useResult
$Res call({
 String search, DateTime? dateFrom, DateTime? dateTo, String? countryCode, Set<String> channelCodes, LabelStatus? labelStatus, bool withAiAlert, TransactionsSort sort, bool ascending, int page, int pageSize
});




}
/// @nodoc
class _$TransactionsQueryCopyWithImpl<$Res>
    implements $TransactionsQueryCopyWith<$Res> {
  _$TransactionsQueryCopyWithImpl(this._self, this._then);

  final TransactionsQuery _self;
  final $Res Function(TransactionsQuery) _then;

/// Create a copy of TransactionsQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? search = null,Object? dateFrom = freezed,Object? dateTo = freezed,Object? countryCode = freezed,Object? channelCodes = null,Object? labelStatus = freezed,Object? withAiAlert = null,Object? sort = null,Object? ascending = null,Object? page = null,Object? pageSize = null,}) {
  return _then(TransactionsQuery(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,channelCodes: null == channelCodes ? _self.channelCodes : channelCodes // ignore: cast_nullable_to_non_nullable
as Set<String>,labelStatus: freezed == labelStatus ? _self.labelStatus : labelStatus // ignore: cast_nullable_to_non_nullable
as LabelStatus?,withAiAlert: null == withAiAlert ? _self.withAiAlert : withAiAlert // ignore: cast_nullable_to_non_nullable
as bool,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as TransactionsSort,ascending: null == ascending ? _self.ascending : ascending // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionsQuery].
extension TransactionsQueryPatterns on TransactionsQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionsQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionsQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionsQuery value)  $default,){
final _that = this;
switch (_that) {
case _TransactionsQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionsQuery value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionsQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String search,  DateTime? dateFrom,  DateTime? dateTo,  String? countryCode,  Set<String> channelCodes,  LabelStatus? labelStatus,  bool withAiAlert,  TransactionsSort sort,  bool ascending,  int page,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionsQuery() when $default != null:
return $default(_that.search,_that.dateFrom,_that.dateTo,_that.countryCode,_that.channelCodes,_that.labelStatus,_that.withAiAlert,_that.sort,_that.ascending,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String search,  DateTime? dateFrom,  DateTime? dateTo,  String? countryCode,  Set<String> channelCodes,  LabelStatus? labelStatus,  bool withAiAlert,  TransactionsSort sort,  bool ascending,  int page,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _TransactionsQuery():
return $default(_that.search,_that.dateFrom,_that.dateTo,_that.countryCode,_that.channelCodes,_that.labelStatus,_that.withAiAlert,_that.sort,_that.ascending,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String search,  DateTime? dateFrom,  DateTime? dateTo,  String? countryCode,  Set<String> channelCodes,  LabelStatus? labelStatus,  bool withAiAlert,  TransactionsSort sort,  bool ascending,  int page,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _TransactionsQuery() when $default != null:
return $default(_that.search,_that.dateFrom,_that.dateTo,_that.countryCode,_that.channelCodes,_that.labelStatus,_that.withAiAlert,_that.sort,_that.ascending,_that.page,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionsQuery extends TransactionsQuery {
  const _TransactionsQuery({this.search = '', this.dateFrom, this.dateTo, this.countryCode,  Set<String> channelCodes = const <String>{}, this.labelStatus, this.withAiAlert = false, this.sort = TransactionsSort.date, this.ascending = false, this.page = 1, this.pageSize = 25}): _channelCodes = channelCodes,super._();
  

/// Customer, account or transaction ID.
@override@JsonKey() final  String search;
/// First day of the range, inclusive.
@override final  DateTime? dateFrom;
/// Last day of the range, inclusive.
@override final  DateTime? dateTo;
/// A `countries.code`.
@override final  String? countryCode;
/// `channels.code` values: a transaction matches any of them. Empty means all.
 final  Set<String> _channelCodes;
/// `channels.code` values: a transaction matches any of them. Empty means all.
@override@JsonKey() Set<String> get channelCodes {
  if (_channelCodes is EqualUnmodifiableSetView) return _channelCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_channelCodes);
}

@override final  LabelStatus? labelStatus;
/// True shows only the transactions with an AI alert.
@override@JsonKey() final  bool withAiAlert;
@override@JsonKey() final  TransactionsSort sort;
@override@JsonKey() final  bool ascending;
@override@JsonKey() final  int page;
@override@JsonKey() final  int pageSize;

/// Create a copy of TransactionsQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionsQueryCopyWith<_TransactionsQuery> get copyWith => __$TransactionsQueryCopyWithImpl<_TransactionsQuery>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionsQuery&&(identical(other.search, search) || other.search == search)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&const DeepCollectionEquality().equals(other.channelCodes, _channelCodes)&&(identical(other.labelStatus, labelStatus) || other.labelStatus == labelStatus)&&(identical(other.withAiAlert, withAiAlert) || other.withAiAlert == withAiAlert)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.ascending, ascending) || other.ascending == ascending)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode {
    return Object.hash(runtimeType,search,dateFrom,dateTo,countryCode,const DeepCollectionEquality().hash(_channelCodes),labelStatus,withAiAlert,sort,ascending,page,pageSize);
}

@override
String toString() {
    return 'TransactionsQuery(search: $search, dateFrom: $dateFrom, dateTo: $dateTo, countryCode: $countryCode, channelCodes: $channelCodes, labelStatus: $labelStatus, withAiAlert: $withAiAlert, sort: $sort, ascending: $ascending, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$TransactionsQueryCopyWith<$Res> implements $TransactionsQueryCopyWith<$Res> {
  factory _$TransactionsQueryCopyWith(_TransactionsQuery value, $Res Function(_TransactionsQuery) _then) = __$TransactionsQueryCopyWithImpl;
@override @useResult
$Res call({
 String search, DateTime? dateFrom, DateTime? dateTo, String? countryCode, Set<String> channelCodes, LabelStatus? labelStatus, bool withAiAlert, TransactionsSort sort, bool ascending, int page, int pageSize
});




}
/// @nodoc
class __$TransactionsQueryCopyWithImpl<$Res>
    implements _$TransactionsQueryCopyWith<$Res> {
  __$TransactionsQueryCopyWithImpl(this._self, this._then);

  final _TransactionsQuery _self;
  final $Res Function(_TransactionsQuery) _then;

/// Create a copy of TransactionsQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? search = null,Object? dateFrom = freezed,Object? dateTo = freezed,Object? countryCode = freezed,Object? channelCodes = null,Object? labelStatus = freezed,Object? withAiAlert = null,Object? sort = null,Object? ascending = null,Object? page = null,Object? pageSize = null,}) {
  return _then(_TransactionsQuery(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,channelCodes: null == channelCodes ? _self._channelCodes : channelCodes // ignore: cast_nullable_to_non_nullable
as Set<String>,labelStatus: freezed == labelStatus ? _self.labelStatus : labelStatus // ignore: cast_nullable_to_non_nullable
as LabelStatus?,withAiAlert: null == withAiAlert ? _self.withAiAlert : withAiAlert // ignore: cast_nullable_to_non_nullable
as bool,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as TransactionsSort,ascending: null == ascending ? _self.ascending : ascending // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
