// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_selection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SelectedTransaction {

 int get id;/// Whether it already had a label when it was checked.
 bool get isLabeled;
/// Create a copy of SelectedTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedTransactionCopyWith<SelectedTransaction> get copyWith => _$SelectedTransactionCopyWithImpl<SelectedTransaction>(this as SelectedTransaction, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SelectedTransaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedTransaction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.isLabeled, _this.isLabeled) || other.isLabeled == _this.isLabeled));
}


@override
int get hashCode {
  final _this = this as SelectedTransaction;
  return Object.hash(runtimeType,_this.id,_this.isLabeled);
}

@override
String toString() {
  final _this = this as SelectedTransaction;
  return 'SelectedTransaction(id: ${_this.id}, isLabeled: ${_this.isLabeled})';
}


}

/// @nodoc
abstract mixin class $SelectedTransactionCopyWith<$Res>  {
  factory $SelectedTransactionCopyWith(SelectedTransaction value, $Res Function(SelectedTransaction) _then) = _$SelectedTransactionCopyWithImpl;
@useResult
$Res call({
 int id, bool isLabeled
});




}
/// @nodoc
class _$SelectedTransactionCopyWithImpl<$Res>
    implements $SelectedTransactionCopyWith<$Res> {
  _$SelectedTransactionCopyWithImpl(this._self, this._then);

  final SelectedTransaction _self;
  final $Res Function(SelectedTransaction) _then;

/// Create a copy of SelectedTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? isLabeled = null,}) {
  return _then(SelectedTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,isLabeled: null == isLabeled ? _self.isLabeled : isLabeled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectedTransaction].
extension SelectedTransactionPatterns on SelectedTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectedTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectedTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectedTransaction value)  $default,){
final _that = this;
switch (_that) {
case _SelectedTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectedTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _SelectedTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  bool isLabeled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectedTransaction() when $default != null:
return $default(_that.id,_that.isLabeled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  bool isLabeled)  $default,) {final _that = this;
switch (_that) {
case _SelectedTransaction():
return $default(_that.id,_that.isLabeled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  bool isLabeled)?  $default,) {final _that = this;
switch (_that) {
case _SelectedTransaction() when $default != null:
return $default(_that.id,_that.isLabeled);case _:
  return null;

}
}

}

/// @nodoc


class _SelectedTransaction implements SelectedTransaction {
  const _SelectedTransaction({required this.id, required this.isLabeled});
  

@override final  int id;
/// Whether it already had a label when it was checked.
@override final  bool isLabeled;

/// Create a copy of SelectedTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedTransactionCopyWith<_SelectedTransaction> get copyWith => __$SelectedTransactionCopyWithImpl<_SelectedTransaction>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.isLabeled, isLabeled) || other.isLabeled == isLabeled));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,isLabeled);
}

@override
String toString() {
    return 'SelectedTransaction(id: $id, isLabeled: $isLabeled)';
}


}

/// @nodoc
abstract mixin class _$SelectedTransactionCopyWith<$Res> implements $SelectedTransactionCopyWith<$Res> {
  factory _$SelectedTransactionCopyWith(_SelectedTransaction value, $Res Function(_SelectedTransaction) _then) = __$SelectedTransactionCopyWithImpl;
@override @useResult
$Res call({
 int id, bool isLabeled
});




}
/// @nodoc
class __$SelectedTransactionCopyWithImpl<$Res>
    implements _$SelectedTransactionCopyWith<$Res> {
  __$SelectedTransactionCopyWithImpl(this._self, this._then);

  final _SelectedTransaction _self;
  final $Res Function(_SelectedTransaction) _then;

/// Create a copy of SelectedTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isLabeled = null,}) {
  return _then(_SelectedTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,isLabeled: null == isLabeled ? _self.isLabeled : isLabeled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$TransactionSelection {

/// Whether each selected transaction is labeled, by id.
 Map<int, bool> get labeledById;
/// Create a copy of TransactionSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionSelectionCopyWith<TransactionSelection> get copyWith => _$TransactionSelectionCopyWithImpl<TransactionSelection>(this as TransactionSelection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionSelection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionSelection&&const DeepCollectionEquality().equals(other.labeledById, _this.labeledById));
}


@override
int get hashCode {
  final _this = this as TransactionSelection;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.labeledById));
}

@override
String toString() {
  final _this = this as TransactionSelection;
  return 'TransactionSelection(labeledById: ${_this.labeledById})';
}


}

/// @nodoc
abstract mixin class $TransactionSelectionCopyWith<$Res>  {
  factory $TransactionSelectionCopyWith(TransactionSelection value, $Res Function(TransactionSelection) _then) = _$TransactionSelectionCopyWithImpl;
@useResult
$Res call({
 Map<int, bool> labeledById
});




}
/// @nodoc
class _$TransactionSelectionCopyWithImpl<$Res>
    implements $TransactionSelectionCopyWith<$Res> {
  _$TransactionSelectionCopyWithImpl(this._self, this._then);

  final TransactionSelection _self;
  final $Res Function(TransactionSelection) _then;

/// Create a copy of TransactionSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? labeledById = null,}) {
  return _then(TransactionSelection(
labeledById: null == labeledById ? _self.labeledById : labeledById // ignore: cast_nullable_to_non_nullable
as Map<int, bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionSelection].
extension TransactionSelectionPatterns on TransactionSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionSelection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionSelection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionSelection value)  $default,){
final _that = this;
switch (_that) {
case _TransactionSelection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionSelection value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionSelection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<int, bool> labeledById)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionSelection() when $default != null:
return $default(_that.labeledById);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<int, bool> labeledById)  $default,) {final _that = this;
switch (_that) {
case _TransactionSelection():
return $default(_that.labeledById);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<int, bool> labeledById)?  $default,) {final _that = this;
switch (_that) {
case _TransactionSelection() when $default != null:
return $default(_that.labeledById);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionSelection extends TransactionSelection {
  const _TransactionSelection({ Map<int, bool> labeledById = const <int, bool>{}}): _labeledById = labeledById,super._();
  

/// Whether each selected transaction is labeled, by id.
 final  Map<int, bool> _labeledById;
/// Whether each selected transaction is labeled, by id.
@override@JsonKey() Map<int, bool> get labeledById {
  if (_labeledById is EqualUnmodifiableMapView) return _labeledById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_labeledById);
}


/// Create a copy of TransactionSelection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionSelectionCopyWith<_TransactionSelection> get copyWith => __$TransactionSelectionCopyWithImpl<_TransactionSelection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionSelection&&const DeepCollectionEquality().equals(other.labeledById, _labeledById));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_labeledById));
}

@override
String toString() {
    return 'TransactionSelection(labeledById: $labeledById)';
}


}

/// @nodoc
abstract mixin class _$TransactionSelectionCopyWith<$Res> implements $TransactionSelectionCopyWith<$Res> {
  factory _$TransactionSelectionCopyWith(_TransactionSelection value, $Res Function(_TransactionSelection) _then) = __$TransactionSelectionCopyWithImpl;
@override @useResult
$Res call({
 Map<int, bool> labeledById
});




}
/// @nodoc
class __$TransactionSelectionCopyWithImpl<$Res>
    implements _$TransactionSelectionCopyWith<$Res> {
  __$TransactionSelectionCopyWithImpl(this._self, this._then);

  final _TransactionSelection _self;
  final $Res Function(_TransactionSelection) _then;

/// Create a copy of TransactionSelection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? labeledById = null,}) {
  return _then(_TransactionSelection(
labeledById: null == labeledById ? _self._labeledById : labeledById // ignore: cast_nullable_to_non_nullable
as Map<int, bool>,
  ));
}


}

// dart format on
