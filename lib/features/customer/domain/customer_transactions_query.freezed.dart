// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_transactions_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerTransactionsQuery {

/// One account of the customer. Null means all of them.
 String? get accountId; CustomerTransactionsSort get sort; bool get ascending; int get page; int get pageSize;
/// Create a copy of CustomerTransactionsQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerTransactionsQueryCopyWith<CustomerTransactionsQuery> get copyWith => _$CustomerTransactionsQueryCopyWithImpl<CustomerTransactionsQuery>(this as CustomerTransactionsQuery, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerTransactionsQuery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerTransactionsQuery&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.sort, _this.sort) || other.sort == _this.sort)&&(identical(other.ascending, _this.ascending) || other.ascending == _this.ascending)&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.pageSize, _this.pageSize) || other.pageSize == _this.pageSize));
}


@override
int get hashCode {
  final _this = this as CustomerTransactionsQuery;
  return Object.hash(runtimeType,_this.accountId,_this.sort,_this.ascending,_this.page,_this.pageSize);
}

@override
String toString() {
  final _this = this as CustomerTransactionsQuery;
  return 'CustomerTransactionsQuery(accountId: ${_this.accountId}, sort: ${_this.sort}, ascending: ${_this.ascending}, page: ${_this.page}, pageSize: ${_this.pageSize})';
}


}

/// @nodoc
abstract mixin class $CustomerTransactionsQueryCopyWith<$Res>  {
  factory $CustomerTransactionsQueryCopyWith(CustomerTransactionsQuery value, $Res Function(CustomerTransactionsQuery) _then) = _$CustomerTransactionsQueryCopyWithImpl;
@useResult
$Res call({
 String? accountId, CustomerTransactionsSort sort, bool ascending, int page, int pageSize
});




}
/// @nodoc
class _$CustomerTransactionsQueryCopyWithImpl<$Res>
    implements $CustomerTransactionsQueryCopyWith<$Res> {
  _$CustomerTransactionsQueryCopyWithImpl(this._self, this._then);

  final CustomerTransactionsQuery _self;
  final $Res Function(CustomerTransactionsQuery) _then;

/// Create a copy of CustomerTransactionsQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = freezed,Object? sort = null,Object? ascending = null,Object? page = null,Object? pageSize = null,}) {
  return _then(CustomerTransactionsQuery(
accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as CustomerTransactionsSort,ascending: null == ascending ? _self.ascending : ascending // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerTransactionsQuery].
extension CustomerTransactionsQueryPatterns on CustomerTransactionsQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerTransactionsQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerTransactionsQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerTransactionsQuery value)  $default,){
final _that = this;
switch (_that) {
case _CustomerTransactionsQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerTransactionsQuery value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerTransactionsQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? accountId,  CustomerTransactionsSort sort,  bool ascending,  int page,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerTransactionsQuery() when $default != null:
return $default(_that.accountId,_that.sort,_that.ascending,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? accountId,  CustomerTransactionsSort sort,  bool ascending,  int page,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _CustomerTransactionsQuery():
return $default(_that.accountId,_that.sort,_that.ascending,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? accountId,  CustomerTransactionsSort sort,  bool ascending,  int page,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _CustomerTransactionsQuery() when $default != null:
return $default(_that.accountId,_that.sort,_that.ascending,_that.page,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerTransactionsQuery extends CustomerTransactionsQuery {
  const _CustomerTransactionsQuery({this.accountId, this.sort = CustomerTransactionsSort.date, this.ascending = false, this.page = 1, this.pageSize = 25}): super._();
  

/// One account of the customer. Null means all of them.
@override final  String? accountId;
@override@JsonKey() final  CustomerTransactionsSort sort;
@override@JsonKey() final  bool ascending;
@override@JsonKey() final  int page;
@override@JsonKey() final  int pageSize;

/// Create a copy of CustomerTransactionsQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerTransactionsQueryCopyWith<_CustomerTransactionsQuery> get copyWith => __$CustomerTransactionsQueryCopyWithImpl<_CustomerTransactionsQuery>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerTransactionsQuery&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.ascending, ascending) || other.ascending == ascending)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode {
    return Object.hash(runtimeType,accountId,sort,ascending,page,pageSize);
}

@override
String toString() {
    return 'CustomerTransactionsQuery(accountId: $accountId, sort: $sort, ascending: $ascending, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$CustomerTransactionsQueryCopyWith<$Res> implements $CustomerTransactionsQueryCopyWith<$Res> {
  factory _$CustomerTransactionsQueryCopyWith(_CustomerTransactionsQuery value, $Res Function(_CustomerTransactionsQuery) _then) = __$CustomerTransactionsQueryCopyWithImpl;
@override @useResult
$Res call({
 String? accountId, CustomerTransactionsSort sort, bool ascending, int page, int pageSize
});




}
/// @nodoc
class __$CustomerTransactionsQueryCopyWithImpl<$Res>
    implements _$CustomerTransactionsQueryCopyWith<$Res> {
  __$CustomerTransactionsQueryCopyWithImpl(this._self, this._then);

  final _CustomerTransactionsQuery _self;
  final $Res Function(_CustomerTransactionsQuery) _then;

/// Create a copy of CustomerTransactionsQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = freezed,Object? sort = null,Object? ascending = null,Object? page = null,Object? pageSize = null,}) {
  return _then(_CustomerTransactionsQuery(
accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as CustomerTransactionsSort,ascending: null == ascending ? _self.ascending : ascending // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
