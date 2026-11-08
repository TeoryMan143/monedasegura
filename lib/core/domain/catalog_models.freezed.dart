// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CatalogFraudType {

 int get id; String get code; String get name; String get description;@JsonKey(name: 'color') String get colorHex;
/// Create a copy of CatalogFraudType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogFraudTypeCopyWith<CatalogFraudType> get copyWith => _$CatalogFraudTypeCopyWithImpl<CatalogFraudType>(this as CatalogFraudType, _$identity);

  /// Serializes this CatalogFraudType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CatalogFraudType;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogFraudType&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.colorHex, _this.colorHex) || other.colorHex == _this.colorHex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogFraudType;
  return Object.hash(runtimeType,_this.id,_this.code,_this.name,_this.description,_this.colorHex);
}

@override
String toString() {
  final _this = this as CatalogFraudType;
  return 'CatalogFraudType(id: ${_this.id}, code: ${_this.code}, name: ${_this.name}, description: ${_this.description}, colorHex: ${_this.colorHex})';
}


}

/// @nodoc
abstract mixin class $CatalogFraudTypeCopyWith<$Res>  {
  factory $CatalogFraudTypeCopyWith(CatalogFraudType value, $Res Function(CatalogFraudType) _then) = _$CatalogFraudTypeCopyWithImpl;
@useResult
$Res call({
 int id, String code, String name, String description,@JsonKey(name: 'color') String colorHex
});




}
/// @nodoc
class _$CatalogFraudTypeCopyWithImpl<$Res>
    implements $CatalogFraudTypeCopyWith<$Res> {
  _$CatalogFraudTypeCopyWithImpl(this._self, this._then);

  final CatalogFraudType _self;
  final $Res Function(CatalogFraudType) _then;

/// Create a copy of CatalogFraudType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? description = null,Object? colorHex = null,}) {
  return _then(CatalogFraudType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogFraudType].
extension CatalogFraudTypePatterns on CatalogFraudType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogFraudType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogFraudType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogFraudType value)  $default,){
final _that = this;
switch (_that) {
case _CatalogFraudType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogFraudType value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogFraudType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  String name,  String description, @JsonKey(name: 'color')  String colorHex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogFraudType() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.description,_that.colorHex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  String name,  String description, @JsonKey(name: 'color')  String colorHex)  $default,) {final _that = this;
switch (_that) {
case _CatalogFraudType():
return $default(_that.id,_that.code,_that.name,_that.description,_that.colorHex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  String name,  String description, @JsonKey(name: 'color')  String colorHex)?  $default,) {final _that = this;
switch (_that) {
case _CatalogFraudType() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.description,_that.colorHex);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CatalogFraudType extends CatalogFraudType {
  const _CatalogFraudType({required this.id, required this.code, required this.name, required this.description, @JsonKey(name: 'color') required this.colorHex}): super._();
  factory _CatalogFraudType.fromJson(Map<String, dynamic> json) => _$CatalogFraudTypeFromJson(json);

@override final  int id;
@override final  String code;
@override final  String name;
@override final  String description;
@override@JsonKey(name: 'color') final  String colorHex;

/// Create a copy of CatalogFraudType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogFraudTypeCopyWith<_CatalogFraudType> get copyWith => __$CatalogFraudTypeCopyWithImpl<_CatalogFraudType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogFraudTypeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogFraudType&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,name,description,colorHex);
}

@override
String toString() {
    return 'CatalogFraudType(id: $id, code: $code, name: $name, description: $description, colorHex: $colorHex)';
}


}

/// @nodoc
abstract mixin class _$CatalogFraudTypeCopyWith<$Res> implements $CatalogFraudTypeCopyWith<$Res> {
  factory _$CatalogFraudTypeCopyWith(_CatalogFraudType value, $Res Function(_CatalogFraudType) _then) = __$CatalogFraudTypeCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, String name, String description,@JsonKey(name: 'color') String colorHex
});




}
/// @nodoc
class __$CatalogFraudTypeCopyWithImpl<$Res>
    implements _$CatalogFraudTypeCopyWith<$Res> {
  __$CatalogFraudTypeCopyWithImpl(this._self, this._then);

  final _CatalogFraudType _self;
  final $Res Function(_CatalogFraudType) _then;

/// Create a copy of CatalogFraudType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? description = null,Object? colorHex = null,}) {
  return _then(_CatalogFraudType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CatalogConfidenceLevel {

 int get level; String get name; String get meaning; String get criteria; double get sampleWeight; bool get requiresJustification;
/// Create a copy of CatalogConfidenceLevel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogConfidenceLevelCopyWith<CatalogConfidenceLevel> get copyWith => _$CatalogConfidenceLevelCopyWithImpl<CatalogConfidenceLevel>(this as CatalogConfidenceLevel, _$identity);

  /// Serializes this CatalogConfidenceLevel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CatalogConfidenceLevel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogConfidenceLevel&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.meaning, _this.meaning) || other.meaning == _this.meaning)&&(identical(other.criteria, _this.criteria) || other.criteria == _this.criteria)&&(identical(other.sampleWeight, _this.sampleWeight) || other.sampleWeight == _this.sampleWeight)&&(identical(other.requiresJustification, _this.requiresJustification) || other.requiresJustification == _this.requiresJustification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogConfidenceLevel;
  return Object.hash(runtimeType,_this.level,_this.name,_this.meaning,_this.criteria,_this.sampleWeight,_this.requiresJustification);
}

@override
String toString() {
  final _this = this as CatalogConfidenceLevel;
  return 'CatalogConfidenceLevel(level: ${_this.level}, name: ${_this.name}, meaning: ${_this.meaning}, criteria: ${_this.criteria}, sampleWeight: ${_this.sampleWeight}, requiresJustification: ${_this.requiresJustification})';
}


}

/// @nodoc
abstract mixin class $CatalogConfidenceLevelCopyWith<$Res>  {
  factory $CatalogConfidenceLevelCopyWith(CatalogConfidenceLevel value, $Res Function(CatalogConfidenceLevel) _then) = _$CatalogConfidenceLevelCopyWithImpl;
@useResult
$Res call({
 int level, String name, String meaning, String criteria, double sampleWeight, bool requiresJustification
});




}
/// @nodoc
class _$CatalogConfidenceLevelCopyWithImpl<$Res>
    implements $CatalogConfidenceLevelCopyWith<$Res> {
  _$CatalogConfidenceLevelCopyWithImpl(this._self, this._then);

  final CatalogConfidenceLevel _self;
  final $Res Function(CatalogConfidenceLevel) _then;

/// Create a copy of CatalogConfidenceLevel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? name = null,Object? meaning = null,Object? criteria = null,Object? sampleWeight = null,Object? requiresJustification = null,}) {
  return _then(CatalogConfidenceLevel(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,criteria: null == criteria ? _self.criteria : criteria // ignore: cast_nullable_to_non_nullable
as String,sampleWeight: null == sampleWeight ? _self.sampleWeight : sampleWeight // ignore: cast_nullable_to_non_nullable
as double,requiresJustification: null == requiresJustification ? _self.requiresJustification : requiresJustification // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogConfidenceLevel].
extension CatalogConfidenceLevelPatterns on CatalogConfidenceLevel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogConfidenceLevel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogConfidenceLevel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogConfidenceLevel value)  $default,){
final _that = this;
switch (_that) {
case _CatalogConfidenceLevel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogConfidenceLevel value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogConfidenceLevel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int level,  String name,  String meaning,  String criteria,  double sampleWeight,  bool requiresJustification)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogConfidenceLevel() when $default != null:
return $default(_that.level,_that.name,_that.meaning,_that.criteria,_that.sampleWeight,_that.requiresJustification);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int level,  String name,  String meaning,  String criteria,  double sampleWeight,  bool requiresJustification)  $default,) {final _that = this;
switch (_that) {
case _CatalogConfidenceLevel():
return $default(_that.level,_that.name,_that.meaning,_that.criteria,_that.sampleWeight,_that.requiresJustification);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int level,  String name,  String meaning,  String criteria,  double sampleWeight,  bool requiresJustification)?  $default,) {final _that = this;
switch (_that) {
case _CatalogConfidenceLevel() when $default != null:
return $default(_that.level,_that.name,_that.meaning,_that.criteria,_that.sampleWeight,_that.requiresJustification);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CatalogConfidenceLevel implements CatalogConfidenceLevel {
  const _CatalogConfidenceLevel({required this.level, required this.name, required this.meaning, required this.criteria, required this.sampleWeight, required this.requiresJustification});
  factory _CatalogConfidenceLevel.fromJson(Map<String, dynamic> json) => _$CatalogConfidenceLevelFromJson(json);

@override final  int level;
@override final  String name;
@override final  String meaning;
@override final  String criteria;
@override final  double sampleWeight;
@override final  bool requiresJustification;

/// Create a copy of CatalogConfidenceLevel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogConfidenceLevelCopyWith<_CatalogConfidenceLevel> get copyWith => __$CatalogConfidenceLevelCopyWithImpl<_CatalogConfidenceLevel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogConfidenceLevelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogConfidenceLevel&&(identical(other.level, level) || other.level == level)&&(identical(other.name, name) || other.name == name)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.criteria, criteria) || other.criteria == criteria)&&(identical(other.sampleWeight, sampleWeight) || other.sampleWeight == sampleWeight)&&(identical(other.requiresJustification, requiresJustification) || other.requiresJustification == requiresJustification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,level,name,meaning,criteria,sampleWeight,requiresJustification);
}

@override
String toString() {
    return 'CatalogConfidenceLevel(level: $level, name: $name, meaning: $meaning, criteria: $criteria, sampleWeight: $sampleWeight, requiresJustification: $requiresJustification)';
}


}

/// @nodoc
abstract mixin class _$CatalogConfidenceLevelCopyWith<$Res> implements $CatalogConfidenceLevelCopyWith<$Res> {
  factory _$CatalogConfidenceLevelCopyWith(_CatalogConfidenceLevel value, $Res Function(_CatalogConfidenceLevel) _then) = __$CatalogConfidenceLevelCopyWithImpl;
@override @useResult
$Res call({
 int level, String name, String meaning, String criteria, double sampleWeight, bool requiresJustification
});




}
/// @nodoc
class __$CatalogConfidenceLevelCopyWithImpl<$Res>
    implements _$CatalogConfidenceLevelCopyWith<$Res> {
  __$CatalogConfidenceLevelCopyWithImpl(this._self, this._then);

  final _CatalogConfidenceLevel _self;
  final $Res Function(_CatalogConfidenceLevel) _then;

/// Create a copy of CatalogConfidenceLevel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? name = null,Object? meaning = null,Object? criteria = null,Object? sampleWeight = null,Object? requiresJustification = null,}) {
  return _then(_CatalogConfidenceLevel(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,criteria: null == criteria ? _self.criteria : criteria // ignore: cast_nullable_to_non_nullable
as String,sampleWeight: null == sampleWeight ? _self.sampleWeight : sampleWeight // ignore: cast_nullable_to_non_nullable
as double,requiresJustification: null == requiresJustification ? _self.requiresJustification : requiresJustification // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CatalogSeverityLevel {

 String get level; int get sortOrder; String get name; String get criteria;
/// Create a copy of CatalogSeverityLevel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogSeverityLevelCopyWith<CatalogSeverityLevel> get copyWith => _$CatalogSeverityLevelCopyWithImpl<CatalogSeverityLevel>(this as CatalogSeverityLevel, _$identity);

  /// Serializes this CatalogSeverityLevel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CatalogSeverityLevel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogSeverityLevel&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.criteria, _this.criteria) || other.criteria == _this.criteria));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogSeverityLevel;
  return Object.hash(runtimeType,_this.level,_this.sortOrder,_this.name,_this.criteria);
}

@override
String toString() {
  final _this = this as CatalogSeverityLevel;
  return 'CatalogSeverityLevel(level: ${_this.level}, sortOrder: ${_this.sortOrder}, name: ${_this.name}, criteria: ${_this.criteria})';
}


}

/// @nodoc
abstract mixin class $CatalogSeverityLevelCopyWith<$Res>  {
  factory $CatalogSeverityLevelCopyWith(CatalogSeverityLevel value, $Res Function(CatalogSeverityLevel) _then) = _$CatalogSeverityLevelCopyWithImpl;
@useResult
$Res call({
 String level, int sortOrder, String name, String criteria
});




}
/// @nodoc
class _$CatalogSeverityLevelCopyWithImpl<$Res>
    implements $CatalogSeverityLevelCopyWith<$Res> {
  _$CatalogSeverityLevelCopyWithImpl(this._self, this._then);

  final CatalogSeverityLevel _self;
  final $Res Function(CatalogSeverityLevel) _then;

/// Create a copy of CatalogSeverityLevel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? sortOrder = null,Object? name = null,Object? criteria = null,}) {
  return _then(CatalogSeverityLevel(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,criteria: null == criteria ? _self.criteria : criteria // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogSeverityLevel].
extension CatalogSeverityLevelPatterns on CatalogSeverityLevel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogSeverityLevel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogSeverityLevel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogSeverityLevel value)  $default,){
final _that = this;
switch (_that) {
case _CatalogSeverityLevel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogSeverityLevel value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogSeverityLevel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String level,  int sortOrder,  String name,  String criteria)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogSeverityLevel() when $default != null:
return $default(_that.level,_that.sortOrder,_that.name,_that.criteria);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String level,  int sortOrder,  String name,  String criteria)  $default,) {final _that = this;
switch (_that) {
case _CatalogSeverityLevel():
return $default(_that.level,_that.sortOrder,_that.name,_that.criteria);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String level,  int sortOrder,  String name,  String criteria)?  $default,) {final _that = this;
switch (_that) {
case _CatalogSeverityLevel() when $default != null:
return $default(_that.level,_that.sortOrder,_that.name,_that.criteria);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CatalogSeverityLevel implements CatalogSeverityLevel {
  const _CatalogSeverityLevel({required this.level, required this.sortOrder, required this.name, required this.criteria});
  factory _CatalogSeverityLevel.fromJson(Map<String, dynamic> json) => _$CatalogSeverityLevelFromJson(json);

@override final  String level;
@override final  int sortOrder;
@override final  String name;
@override final  String criteria;

/// Create a copy of CatalogSeverityLevel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogSeverityLevelCopyWith<_CatalogSeverityLevel> get copyWith => __$CatalogSeverityLevelCopyWithImpl<_CatalogSeverityLevel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogSeverityLevelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogSeverityLevel&&(identical(other.level, level) || other.level == level)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.name, name) || other.name == name)&&(identical(other.criteria, criteria) || other.criteria == criteria));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,level,sortOrder,name,criteria);
}

@override
String toString() {
    return 'CatalogSeverityLevel(level: $level, sortOrder: $sortOrder, name: $name, criteria: $criteria)';
}


}

/// @nodoc
abstract mixin class _$CatalogSeverityLevelCopyWith<$Res> implements $CatalogSeverityLevelCopyWith<$Res> {
  factory _$CatalogSeverityLevelCopyWith(_CatalogSeverityLevel value, $Res Function(_CatalogSeverityLevel) _then) = __$CatalogSeverityLevelCopyWithImpl;
@override @useResult
$Res call({
 String level, int sortOrder, String name, String criteria
});




}
/// @nodoc
class __$CatalogSeverityLevelCopyWithImpl<$Res>
    implements _$CatalogSeverityLevelCopyWith<$Res> {
  __$CatalogSeverityLevelCopyWithImpl(this._self, this._then);

  final _CatalogSeverityLevel _self;
  final $Res Function(_CatalogSeverityLevel) _then;

/// Create a copy of CatalogSeverityLevel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? sortOrder = null,Object? name = null,Object? criteria = null,}) {
  return _then(_CatalogSeverityLevel(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,criteria: null == criteria ? _self.criteria : criteria // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CatalogCurrency {

 String get code; String get name; String get symbol; int get decimals; String get locale;
/// Create a copy of CatalogCurrency
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogCurrencyCopyWith<CatalogCurrency> get copyWith => _$CatalogCurrencyCopyWithImpl<CatalogCurrency>(this as CatalogCurrency, _$identity);

  /// Serializes this CatalogCurrency to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CatalogCurrency;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogCurrency&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.symbol, _this.symbol) || other.symbol == _this.symbol)&&(identical(other.decimals, _this.decimals) || other.decimals == _this.decimals)&&(identical(other.locale, _this.locale) || other.locale == _this.locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogCurrency;
  return Object.hash(runtimeType,_this.code,_this.name,_this.symbol,_this.decimals,_this.locale);
}

@override
String toString() {
  final _this = this as CatalogCurrency;
  return 'CatalogCurrency(code: ${_this.code}, name: ${_this.name}, symbol: ${_this.symbol}, decimals: ${_this.decimals}, locale: ${_this.locale})';
}


}

/// @nodoc
abstract mixin class $CatalogCurrencyCopyWith<$Res>  {
  factory $CatalogCurrencyCopyWith(CatalogCurrency value, $Res Function(CatalogCurrency) _then) = _$CatalogCurrencyCopyWithImpl;
@useResult
$Res call({
 String code, String name, String symbol, int decimals, String locale
});




}
/// @nodoc
class _$CatalogCurrencyCopyWithImpl<$Res>
    implements $CatalogCurrencyCopyWith<$Res> {
  _$CatalogCurrencyCopyWithImpl(this._self, this._then);

  final CatalogCurrency _self;
  final $Res Function(CatalogCurrency) _then;

/// Create a copy of CatalogCurrency
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? symbol = null,Object? decimals = null,Object? locale = null,}) {
  return _then(CatalogCurrency(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogCurrency].
extension CatalogCurrencyPatterns on CatalogCurrency {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogCurrency value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogCurrency() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogCurrency value)  $default,){
final _that = this;
switch (_that) {
case _CatalogCurrency():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogCurrency value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogCurrency() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String name,  String symbol,  int decimals,  String locale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogCurrency() when $default != null:
return $default(_that.code,_that.name,_that.symbol,_that.decimals,_that.locale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String name,  String symbol,  int decimals,  String locale)  $default,) {final _that = this;
switch (_that) {
case _CatalogCurrency():
return $default(_that.code,_that.name,_that.symbol,_that.decimals,_that.locale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String name,  String symbol,  int decimals,  String locale)?  $default,) {final _that = this;
switch (_that) {
case _CatalogCurrency() when $default != null:
return $default(_that.code,_that.name,_that.symbol,_that.decimals,_that.locale);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CatalogCurrency implements CatalogCurrency {
  const _CatalogCurrency({required this.code, required this.name, required this.symbol, required this.decimals, required this.locale});
  factory _CatalogCurrency.fromJson(Map<String, dynamic> json) => _$CatalogCurrencyFromJson(json);

@override final  String code;
@override final  String name;
@override final  String symbol;
@override final  int decimals;
@override final  String locale;

/// Create a copy of CatalogCurrency
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogCurrencyCopyWith<_CatalogCurrency> get copyWith => __$CatalogCurrencyCopyWithImpl<_CatalogCurrency>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogCurrencyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogCurrency&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.decimals, decimals) || other.decimals == decimals)&&(identical(other.locale, locale) || other.locale == locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,name,symbol,decimals,locale);
}

@override
String toString() {
    return 'CatalogCurrency(code: $code, name: $name, symbol: $symbol, decimals: $decimals, locale: $locale)';
}


}

/// @nodoc
abstract mixin class _$CatalogCurrencyCopyWith<$Res> implements $CatalogCurrencyCopyWith<$Res> {
  factory _$CatalogCurrencyCopyWith(_CatalogCurrency value, $Res Function(_CatalogCurrency) _then) = __$CatalogCurrencyCopyWithImpl;
@override @useResult
$Res call({
 String code, String name, String symbol, int decimals, String locale
});




}
/// @nodoc
class __$CatalogCurrencyCopyWithImpl<$Res>
    implements _$CatalogCurrencyCopyWith<$Res> {
  __$CatalogCurrencyCopyWithImpl(this._self, this._then);

  final _CatalogCurrency _self;
  final $Res Function(_CatalogCurrency) _then;

/// Create a copy of CatalogCurrency
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? symbol = null,Object? decimals = null,Object? locale = null,}) {
  return _then(_CatalogCurrency(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CatalogCountry {

 String get code; String get name; String get currencyCode; String get primaryDocumentType; String get phonePrefix;/// IANA time zone, e.g. `America/Bogota`: the customer's clock for unusual hours.
 String get timeZone;
/// Create a copy of CatalogCountry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogCountryCopyWith<CatalogCountry> get copyWith => _$CatalogCountryCopyWithImpl<CatalogCountry>(this as CatalogCountry, _$identity);

  /// Serializes this CatalogCountry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CatalogCountry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogCountry&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.primaryDocumentType, _this.primaryDocumentType) || other.primaryDocumentType == _this.primaryDocumentType)&&(identical(other.phonePrefix, _this.phonePrefix) || other.phonePrefix == _this.phonePrefix)&&(identical(other.timeZone, _this.timeZone) || other.timeZone == _this.timeZone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogCountry;
  return Object.hash(runtimeType,_this.code,_this.name,_this.currencyCode,_this.primaryDocumentType,_this.phonePrefix,_this.timeZone);
}

@override
String toString() {
  final _this = this as CatalogCountry;
  return 'CatalogCountry(code: ${_this.code}, name: ${_this.name}, currencyCode: ${_this.currencyCode}, primaryDocumentType: ${_this.primaryDocumentType}, phonePrefix: ${_this.phonePrefix}, timeZone: ${_this.timeZone})';
}


}

/// @nodoc
abstract mixin class $CatalogCountryCopyWith<$Res>  {
  factory $CatalogCountryCopyWith(CatalogCountry value, $Res Function(CatalogCountry) _then) = _$CatalogCountryCopyWithImpl;
@useResult
$Res call({
 String code, String name, String currencyCode, String primaryDocumentType, String phonePrefix, String timeZone
});




}
/// @nodoc
class _$CatalogCountryCopyWithImpl<$Res>
    implements $CatalogCountryCopyWith<$Res> {
  _$CatalogCountryCopyWithImpl(this._self, this._then);

  final CatalogCountry _self;
  final $Res Function(CatalogCountry) _then;

/// Create a copy of CatalogCountry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? currencyCode = null,Object? primaryDocumentType = null,Object? phonePrefix = null,Object? timeZone = null,}) {
  return _then(CatalogCountry(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,primaryDocumentType: null == primaryDocumentType ? _self.primaryDocumentType : primaryDocumentType // ignore: cast_nullable_to_non_nullable
as String,phonePrefix: null == phonePrefix ? _self.phonePrefix : phonePrefix // ignore: cast_nullable_to_non_nullable
as String,timeZone: null == timeZone ? _self.timeZone : timeZone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogCountry].
extension CatalogCountryPatterns on CatalogCountry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogCountry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogCountry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogCountry value)  $default,){
final _that = this;
switch (_that) {
case _CatalogCountry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogCountry value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogCountry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String name,  String currencyCode,  String primaryDocumentType,  String phonePrefix,  String timeZone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogCountry() when $default != null:
return $default(_that.code,_that.name,_that.currencyCode,_that.primaryDocumentType,_that.phonePrefix,_that.timeZone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String name,  String currencyCode,  String primaryDocumentType,  String phonePrefix,  String timeZone)  $default,) {final _that = this;
switch (_that) {
case _CatalogCountry():
return $default(_that.code,_that.name,_that.currencyCode,_that.primaryDocumentType,_that.phonePrefix,_that.timeZone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String name,  String currencyCode,  String primaryDocumentType,  String phonePrefix,  String timeZone)?  $default,) {final _that = this;
switch (_that) {
case _CatalogCountry() when $default != null:
return $default(_that.code,_that.name,_that.currencyCode,_that.primaryDocumentType,_that.phonePrefix,_that.timeZone);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CatalogCountry implements CatalogCountry {
  const _CatalogCountry({required this.code, required this.name, required this.currencyCode, required this.primaryDocumentType, required this.phonePrefix, required this.timeZone});
  factory _CatalogCountry.fromJson(Map<String, dynamic> json) => _$CatalogCountryFromJson(json);

@override final  String code;
@override final  String name;
@override final  String currencyCode;
@override final  String primaryDocumentType;
@override final  String phonePrefix;
/// IANA time zone, e.g. `America/Bogota`: the customer's clock for unusual hours.
@override final  String timeZone;

/// Create a copy of CatalogCountry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogCountryCopyWith<_CatalogCountry> get copyWith => __$CatalogCountryCopyWithImpl<_CatalogCountry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogCountryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogCountry&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.primaryDocumentType, primaryDocumentType) || other.primaryDocumentType == primaryDocumentType)&&(identical(other.phonePrefix, phonePrefix) || other.phonePrefix == phonePrefix)&&(identical(other.timeZone, timeZone) || other.timeZone == timeZone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,name,currencyCode,primaryDocumentType,phonePrefix,timeZone);
}

@override
String toString() {
    return 'CatalogCountry(code: $code, name: $name, currencyCode: $currencyCode, primaryDocumentType: $primaryDocumentType, phonePrefix: $phonePrefix, timeZone: $timeZone)';
}


}

/// @nodoc
abstract mixin class _$CatalogCountryCopyWith<$Res> implements $CatalogCountryCopyWith<$Res> {
  factory _$CatalogCountryCopyWith(_CatalogCountry value, $Res Function(_CatalogCountry) _then) = __$CatalogCountryCopyWithImpl;
@override @useResult
$Res call({
 String code, String name, String currencyCode, String primaryDocumentType, String phonePrefix, String timeZone
});




}
/// @nodoc
class __$CatalogCountryCopyWithImpl<$Res>
    implements _$CatalogCountryCopyWith<$Res> {
  __$CatalogCountryCopyWithImpl(this._self, this._then);

  final _CatalogCountry _self;
  final $Res Function(_CatalogCountry) _then;

/// Create a copy of CatalogCountry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? currencyCode = null,Object? primaryDocumentType = null,Object? phonePrefix = null,Object? timeZone = null,}) {
  return _then(_CatalogCountry(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,primaryDocumentType: null == primaryDocumentType ? _self.primaryDocumentType : primaryDocumentType // ignore: cast_nullable_to_non_nullable
as String,phonePrefix: null == phonePrefix ? _self.phonePrefix : phonePrefix // ignore: cast_nullable_to_non_nullable
as String,timeZone: null == timeZone ? _self.timeZone : timeZone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CatalogChannel {

 String get code; String get name; bool get isDigital; String? get countryCode;
/// Create a copy of CatalogChannel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogChannelCopyWith<CatalogChannel> get copyWith => _$CatalogChannelCopyWithImpl<CatalogChannel>(this as CatalogChannel, _$identity);

  /// Serializes this CatalogChannel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CatalogChannel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogChannel&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isDigital, _this.isDigital) || other.isDigital == _this.isDigital)&&(identical(other.countryCode, _this.countryCode) || other.countryCode == _this.countryCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogChannel;
  return Object.hash(runtimeType,_this.code,_this.name,_this.isDigital,_this.countryCode);
}

@override
String toString() {
  final _this = this as CatalogChannel;
  return 'CatalogChannel(code: ${_this.code}, name: ${_this.name}, isDigital: ${_this.isDigital}, countryCode: ${_this.countryCode})';
}


}

/// @nodoc
abstract mixin class $CatalogChannelCopyWith<$Res>  {
  factory $CatalogChannelCopyWith(CatalogChannel value, $Res Function(CatalogChannel) _then) = _$CatalogChannelCopyWithImpl;
@useResult
$Res call({
 String code, String name, bool isDigital, String? countryCode
});




}
/// @nodoc
class _$CatalogChannelCopyWithImpl<$Res>
    implements $CatalogChannelCopyWith<$Res> {
  _$CatalogChannelCopyWithImpl(this._self, this._then);

  final CatalogChannel _self;
  final $Res Function(CatalogChannel) _then;

/// Create a copy of CatalogChannel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? isDigital = null,Object? countryCode = freezed,}) {
  return _then(CatalogChannel(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isDigital: null == isDigital ? _self.isDigital : isDigital // ignore: cast_nullable_to_non_nullable
as bool,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogChannel].
extension CatalogChannelPatterns on CatalogChannel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogChannel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogChannel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogChannel value)  $default,){
final _that = this;
switch (_that) {
case _CatalogChannel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogChannel value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogChannel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String name,  bool isDigital,  String? countryCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogChannel() when $default != null:
return $default(_that.code,_that.name,_that.isDigital,_that.countryCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String name,  bool isDigital,  String? countryCode)  $default,) {final _that = this;
switch (_that) {
case _CatalogChannel():
return $default(_that.code,_that.name,_that.isDigital,_that.countryCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String name,  bool isDigital,  String? countryCode)?  $default,) {final _that = this;
switch (_that) {
case _CatalogChannel() when $default != null:
return $default(_that.code,_that.name,_that.isDigital,_that.countryCode);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CatalogChannel implements CatalogChannel {
  const _CatalogChannel({required this.code, required this.name, required this.isDigital, this.countryCode});
  factory _CatalogChannel.fromJson(Map<String, dynamic> json) => _$CatalogChannelFromJson(json);

@override final  String code;
@override final  String name;
@override final  bool isDigital;
@override final  String? countryCode;

/// Create a copy of CatalogChannel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogChannelCopyWith<_CatalogChannel> get copyWith => __$CatalogChannelCopyWithImpl<_CatalogChannel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogChannelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogChannel&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.isDigital, isDigital) || other.isDigital == isDigital)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,name,isDigital,countryCode);
}

@override
String toString() {
    return 'CatalogChannel(code: $code, name: $name, isDigital: $isDigital, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class _$CatalogChannelCopyWith<$Res> implements $CatalogChannelCopyWith<$Res> {
  factory _$CatalogChannelCopyWith(_CatalogChannel value, $Res Function(_CatalogChannel) _then) = __$CatalogChannelCopyWithImpl;
@override @useResult
$Res call({
 String code, String name, bool isDigital, String? countryCode
});




}
/// @nodoc
class __$CatalogChannelCopyWithImpl<$Res>
    implements _$CatalogChannelCopyWith<$Res> {
  __$CatalogChannelCopyWithImpl(this._self, this._then);

  final _CatalogChannel _self;
  final $Res Function(_CatalogChannel) _then;

/// Create a copy of CatalogChannel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? isDigital = null,Object? countryCode = freezed,}) {
  return _then(_CatalogChannel(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isDigital: null == isDigital ? _self.isDigital : isDigital // ignore: cast_nullable_to_non_nullable
as bool,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
