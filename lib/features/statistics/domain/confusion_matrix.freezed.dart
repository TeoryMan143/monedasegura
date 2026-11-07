// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'confusion_matrix.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConfusionMatrix {

/// Codes of the suggested types, one per row.
 List<String> get rows;/// Codes of the final types, with [noFraudKey] last.
 List<String> get columns;/// `cells[row][column]` is how many alerts fall there.
 List<List<int>> get cells;
/// Create a copy of ConfusionMatrix
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfusionMatrixCopyWith<ConfusionMatrix> get copyWith => _$ConfusionMatrixCopyWithImpl<ConfusionMatrix>(this as ConfusionMatrix, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ConfusionMatrix;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfusionMatrix&&const DeepCollectionEquality().equals(other.rows, _this.rows)&&const DeepCollectionEquality().equals(other.columns, _this.columns)&&const DeepCollectionEquality().equals(other.cells, _this.cells));
}


@override
int get hashCode {
  final _this = this as ConfusionMatrix;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.rows),const DeepCollectionEquality().hash(_this.columns),const DeepCollectionEquality().hash(_this.cells));
}

@override
String toString() {
  final _this = this as ConfusionMatrix;
  return 'ConfusionMatrix(rows: ${_this.rows}, columns: ${_this.columns}, cells: ${_this.cells})';
}


}

/// @nodoc
abstract mixin class $ConfusionMatrixCopyWith<$Res>  {
  factory $ConfusionMatrixCopyWith(ConfusionMatrix value, $Res Function(ConfusionMatrix) _then) = _$ConfusionMatrixCopyWithImpl;
@useResult
$Res call({
 List<String> rows, List<String> columns, List<List<int>> cells
});




}
/// @nodoc
class _$ConfusionMatrixCopyWithImpl<$Res>
    implements $ConfusionMatrixCopyWith<$Res> {
  _$ConfusionMatrixCopyWithImpl(this._self, this._then);

  final ConfusionMatrix _self;
  final $Res Function(ConfusionMatrix) _then;

/// Create a copy of ConfusionMatrix
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rows = null,Object? columns = null,Object? cells = null,}) {
  return _then(ConfusionMatrix(
rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<String>,columns: null == columns ? _self.columns : columns // ignore: cast_nullable_to_non_nullable
as List<String>,cells: null == cells ? _self.cells : cells // ignore: cast_nullable_to_non_nullable
as List<List<int>>,
  ));
}

}


/// Adds pattern-matching-related methods to [ConfusionMatrix].
extension ConfusionMatrixPatterns on ConfusionMatrix {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConfusionMatrix value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConfusionMatrix() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConfusionMatrix value)  $default,){
final _that = this;
switch (_that) {
case _ConfusionMatrix():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConfusionMatrix value)?  $default,){
final _that = this;
switch (_that) {
case _ConfusionMatrix() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> rows,  List<String> columns,  List<List<int>> cells)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConfusionMatrix() when $default != null:
return $default(_that.rows,_that.columns,_that.cells);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> rows,  List<String> columns,  List<List<int>> cells)  $default,) {final _that = this;
switch (_that) {
case _ConfusionMatrix():
return $default(_that.rows,_that.columns,_that.cells);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> rows,  List<String> columns,  List<List<int>> cells)?  $default,) {final _that = this;
switch (_that) {
case _ConfusionMatrix() when $default != null:
return $default(_that.rows,_that.columns,_that.cells);case _:
  return null;

}
}

}

/// @nodoc


class _ConfusionMatrix extends ConfusionMatrix {
  const _ConfusionMatrix({required  List<String> rows, required  List<String> columns, required  List<List<int>> cells}): _rows = rows,_columns = columns,_cells = cells,super._();
  

/// Codes of the suggested types, one per row.
 final  List<String> _rows;
/// Codes of the suggested types, one per row.
@override List<String> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

/// Codes of the final types, with [noFraudKey] last.
 final  List<String> _columns;
/// Codes of the final types, with [noFraudKey] last.
@override List<String> get columns {
  if (_columns is EqualUnmodifiableListView) return _columns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_columns);
}

/// `cells[row][column]` is how many alerts fall there.
 final  List<List<int>> _cells;
/// `cells[row][column]` is how many alerts fall there.
@override List<List<int>> get cells {
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cells);
}


/// Create a copy of ConfusionMatrix
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfusionMatrixCopyWith<_ConfusionMatrix> get copyWith => __$ConfusionMatrixCopyWithImpl<_ConfusionMatrix>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfusionMatrix&&const DeepCollectionEquality().equals(other.rows, _rows)&&const DeepCollectionEquality().equals(other.columns, _columns)&&const DeepCollectionEquality().equals(other.cells, _cells));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_rows),const DeepCollectionEquality().hash(_columns),const DeepCollectionEquality().hash(_cells));
}

@override
String toString() {
    return 'ConfusionMatrix(rows: $rows, columns: $columns, cells: $cells)';
}


}

/// @nodoc
abstract mixin class _$ConfusionMatrixCopyWith<$Res> implements $ConfusionMatrixCopyWith<$Res> {
  factory _$ConfusionMatrixCopyWith(_ConfusionMatrix value, $Res Function(_ConfusionMatrix) _then) = __$ConfusionMatrixCopyWithImpl;
@override @useResult
$Res call({
 List<String> rows, List<String> columns, List<List<int>> cells
});




}
/// @nodoc
class __$ConfusionMatrixCopyWithImpl<$Res>
    implements _$ConfusionMatrixCopyWith<$Res> {
  __$ConfusionMatrixCopyWithImpl(this._self, this._then);

  final _ConfusionMatrix _self;
  final $Res Function(_ConfusionMatrix) _then;

/// Create a copy of ConfusionMatrix
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rows = null,Object? columns = null,Object? cells = null,}) {
  return _then(_ConfusionMatrix(
rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<String>,columns: null == columns ? _self._columns : columns // ignore: cast_nullable_to_non_nullable
as List<String>,cells: null == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<List<int>>,
  ));
}


}

// dart format on
