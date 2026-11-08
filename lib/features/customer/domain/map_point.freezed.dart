// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapPoint {

 CustomerTransaction get transaction; double get latitude; double get longitude;
/// Create a copy of MapPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapPointCopyWith<MapPoint> get copyWith => _$MapPointCopyWithImpl<MapPoint>(this as MapPoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MapPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapPoint&&(identical(other.transaction, _this.transaction) || other.transaction == _this.transaction)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude));
}


@override
int get hashCode {
  final _this = this as MapPoint;
  return Object.hash(runtimeType,_this.transaction,_this.latitude,_this.longitude);
}

@override
String toString() {
  final _this = this as MapPoint;
  return 'MapPoint(transaction: ${_this.transaction}, latitude: ${_this.latitude}, longitude: ${_this.longitude})';
}


}

/// @nodoc
abstract mixin class $MapPointCopyWith<$Res>  {
  factory $MapPointCopyWith(MapPoint value, $Res Function(MapPoint) _then) = _$MapPointCopyWithImpl;
@useResult
$Res call({
 CustomerTransaction transaction, double latitude, double longitude
});


$CustomerTransactionCopyWith<$Res> get transaction;

}
/// @nodoc
class _$MapPointCopyWithImpl<$Res>
    implements $MapPointCopyWith<$Res> {
  _$MapPointCopyWithImpl(this._self, this._then);

  final MapPoint _self;
  final $Res Function(MapPoint) _then;

/// Create a copy of MapPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transaction = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(MapPoint(
transaction: null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as CustomerTransaction,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of MapPoint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerTransactionCopyWith<$Res> get transaction {
  
  return $CustomerTransactionCopyWith<$Res>(_self.transaction, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}


/// Adds pattern-matching-related methods to [MapPoint].
extension MapPointPatterns on MapPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapPoint value)  $default,){
final _that = this;
switch (_that) {
case _MapPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapPoint value)?  $default,){
final _that = this;
switch (_that) {
case _MapPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CustomerTransaction transaction,  double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapPoint() when $default != null:
return $default(_that.transaction,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CustomerTransaction transaction,  double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _MapPoint():
return $default(_that.transaction,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CustomerTransaction transaction,  double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _MapPoint() when $default != null:
return $default(_that.transaction,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc


class _MapPoint extends MapPoint {
  const _MapPoint({required this.transaction, required this.latitude, required this.longitude}): super._();
  

@override final  CustomerTransaction transaction;
@override final  double latitude;
@override final  double longitude;

/// Create a copy of MapPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapPointCopyWith<_MapPoint> get copyWith => __$MapPointCopyWithImpl<_MapPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapPoint&&(identical(other.transaction, transaction) || other.transaction == transaction)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode {
    return Object.hash(runtimeType,transaction,latitude,longitude);
}

@override
String toString() {
    return 'MapPoint(transaction: $transaction, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$MapPointCopyWith<$Res> implements $MapPointCopyWith<$Res> {
  factory _$MapPointCopyWith(_MapPoint value, $Res Function(_MapPoint) _then) = __$MapPointCopyWithImpl;
@override @useResult
$Res call({
 CustomerTransaction transaction, double latitude, double longitude
});


@override $CustomerTransactionCopyWith<$Res> get transaction;

}
/// @nodoc
class __$MapPointCopyWithImpl<$Res>
    implements _$MapPointCopyWith<$Res> {
  __$MapPointCopyWithImpl(this._self, this._then);

  final _MapPoint _self;
  final $Res Function(_MapPoint) _then;

/// Create a copy of MapPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transaction = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_MapPoint(
transaction: null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as CustomerTransaction,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of MapPoint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerTransactionCopyWith<$Res> get transaction {
  
  return $CustomerTransactionCopyWith<$Res>(_self.transaction, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}

/// @nodoc
mixin _$ImpossibleTravel {

 MapPoint get from; MapPoint get to; double get distanceKm; Duration get elapsed;/// Kilometres per hour. Infinite when both happened at the same instant.
 double get speedKmh;
/// Create a copy of ImpossibleTravel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImpossibleTravelCopyWith<ImpossibleTravel> get copyWith => _$ImpossibleTravelCopyWithImpl<ImpossibleTravel>(this as ImpossibleTravel, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ImpossibleTravel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImpossibleTravel&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.distanceKm, _this.distanceKm) || other.distanceKm == _this.distanceKm)&&(identical(other.elapsed, _this.elapsed) || other.elapsed == _this.elapsed)&&(identical(other.speedKmh, _this.speedKmh) || other.speedKmh == _this.speedKmh));
}


@override
int get hashCode {
  final _this = this as ImpossibleTravel;
  return Object.hash(runtimeType,_this.from,_this.to,_this.distanceKm,_this.elapsed,_this.speedKmh);
}

@override
String toString() {
  final _this = this as ImpossibleTravel;
  return 'ImpossibleTravel(from: ${_this.from}, to: ${_this.to}, distanceKm: ${_this.distanceKm}, elapsed: ${_this.elapsed}, speedKmh: ${_this.speedKmh})';
}


}

/// @nodoc
abstract mixin class $ImpossibleTravelCopyWith<$Res>  {
  factory $ImpossibleTravelCopyWith(ImpossibleTravel value, $Res Function(ImpossibleTravel) _then) = _$ImpossibleTravelCopyWithImpl;
@useResult
$Res call({
 MapPoint from, MapPoint to, double distanceKm, Duration elapsed, double speedKmh
});


$MapPointCopyWith<$Res> get from;$MapPointCopyWith<$Res> get to;

}
/// @nodoc
class _$ImpossibleTravelCopyWithImpl<$Res>
    implements $ImpossibleTravelCopyWith<$Res> {
  _$ImpossibleTravelCopyWithImpl(this._self, this._then);

  final ImpossibleTravel _self;
  final $Res Function(ImpossibleTravel) _then;

/// Create a copy of ImpossibleTravel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? distanceKm = null,Object? elapsed = null,Object? speedKmh = null,}) {
  return _then(ImpossibleTravel(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as MapPoint,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as MapPoint,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,speedKmh: null == speedKmh ? _self.speedKmh : speedKmh // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of ImpossibleTravel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapPointCopyWith<$Res> get from {
  
  return $MapPointCopyWith<$Res>(_self.from, (value) {
    return _then(_self.copyWith(from: value));
  });
}/// Create a copy of ImpossibleTravel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapPointCopyWith<$Res> get to {
  
  return $MapPointCopyWith<$Res>(_self.to, (value) {
    return _then(_self.copyWith(to: value));
  });
}
}


/// Adds pattern-matching-related methods to [ImpossibleTravel].
extension ImpossibleTravelPatterns on ImpossibleTravel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImpossibleTravel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImpossibleTravel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImpossibleTravel value)  $default,){
final _that = this;
switch (_that) {
case _ImpossibleTravel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImpossibleTravel value)?  $default,){
final _that = this;
switch (_that) {
case _ImpossibleTravel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MapPoint from,  MapPoint to,  double distanceKm,  Duration elapsed,  double speedKmh)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImpossibleTravel() when $default != null:
return $default(_that.from,_that.to,_that.distanceKm,_that.elapsed,_that.speedKmh);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MapPoint from,  MapPoint to,  double distanceKm,  Duration elapsed,  double speedKmh)  $default,) {final _that = this;
switch (_that) {
case _ImpossibleTravel():
return $default(_that.from,_that.to,_that.distanceKm,_that.elapsed,_that.speedKmh);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MapPoint from,  MapPoint to,  double distanceKm,  Duration elapsed,  double speedKmh)?  $default,) {final _that = this;
switch (_that) {
case _ImpossibleTravel() when $default != null:
return $default(_that.from,_that.to,_that.distanceKm,_that.elapsed,_that.speedKmh);case _:
  return null;

}
}

}

/// @nodoc


class _ImpossibleTravel implements ImpossibleTravel {
  const _ImpossibleTravel({required this.from, required this.to, required this.distanceKm, required this.elapsed, required this.speedKmh});
  

@override final  MapPoint from;
@override final  MapPoint to;
@override final  double distanceKm;
@override final  Duration elapsed;
/// Kilometres per hour. Infinite when both happened at the same instant.
@override final  double speedKmh;

/// Create a copy of ImpossibleTravel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImpossibleTravelCopyWith<_ImpossibleTravel> get copyWith => __$ImpossibleTravelCopyWithImpl<_ImpossibleTravel>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImpossibleTravel&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.speedKmh, speedKmh) || other.speedKmh == speedKmh));
}


@override
int get hashCode {
    return Object.hash(runtimeType,from,to,distanceKm,elapsed,speedKmh);
}

@override
String toString() {
    return 'ImpossibleTravel(from: $from, to: $to, distanceKm: $distanceKm, elapsed: $elapsed, speedKmh: $speedKmh)';
}


}

/// @nodoc
abstract mixin class _$ImpossibleTravelCopyWith<$Res> implements $ImpossibleTravelCopyWith<$Res> {
  factory _$ImpossibleTravelCopyWith(_ImpossibleTravel value, $Res Function(_ImpossibleTravel) _then) = __$ImpossibleTravelCopyWithImpl;
@override @useResult
$Res call({
 MapPoint from, MapPoint to, double distanceKm, Duration elapsed, double speedKmh
});


@override $MapPointCopyWith<$Res> get from;@override $MapPointCopyWith<$Res> get to;

}
/// @nodoc
class __$ImpossibleTravelCopyWithImpl<$Res>
    implements _$ImpossibleTravelCopyWith<$Res> {
  __$ImpossibleTravelCopyWithImpl(this._self, this._then);

  final _ImpossibleTravel _self;
  final $Res Function(_ImpossibleTravel) _then;

/// Create a copy of ImpossibleTravel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? distanceKm = null,Object? elapsed = null,Object? speedKmh = null,}) {
  return _then(_ImpossibleTravel(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as MapPoint,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as MapPoint,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,speedKmh: null == speedKmh ? _self.speedKmh : speedKmh // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of ImpossibleTravel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapPointCopyWith<$Res> get from {
  
  return $MapPointCopyWith<$Res>(_self.from, (value) {
    return _then(_self.copyWith(from: value));
  });
}/// Create a copy of ImpossibleTravel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapPointCopyWith<$Res> get to {
  
  return $MapPointCopyWith<$Res>(_self.to, (value) {
    return _then(_self.copyWith(to: value));
  });
}
}

// dart format on
