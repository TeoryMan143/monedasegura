// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BurstWindow {

 DateTime get start; DateTime get end; int get count;
/// Create a copy of BurstWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BurstWindowCopyWith<BurstWindow> get copyWith => _$BurstWindowCopyWithImpl<BurstWindow>(this as BurstWindow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BurstWindow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BurstWindow&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.count, _this.count) || other.count == _this.count));
}


@override
int get hashCode {
  final _this = this as BurstWindow;
  return Object.hash(runtimeType,_this.start,_this.end,_this.count);
}

@override
String toString() {
  final _this = this as BurstWindow;
  return 'BurstWindow(start: ${_this.start}, end: ${_this.end}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $BurstWindowCopyWith<$Res>  {
  factory $BurstWindowCopyWith(BurstWindow value, $Res Function(BurstWindow) _then) = _$BurstWindowCopyWithImpl;
@useResult
$Res call({
 DateTime start, DateTime end, int count
});




}
/// @nodoc
class _$BurstWindowCopyWithImpl<$Res>
    implements $BurstWindowCopyWith<$Res> {
  _$BurstWindowCopyWithImpl(this._self, this._then);

  final BurstWindow _self;
  final $Res Function(BurstWindow) _then;

/// Create a copy of BurstWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,Object? count = null,}) {
  return _then(BurstWindow(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BurstWindow].
extension BurstWindowPatterns on BurstWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BurstWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BurstWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BurstWindow value)  $default,){
final _that = this;
switch (_that) {
case _BurstWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BurstWindow value)?  $default,){
final _that = this;
switch (_that) {
case _BurstWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime start,  DateTime end,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BurstWindow() when $default != null:
return $default(_that.start,_that.end,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime start,  DateTime end,  int count)  $default,) {final _that = this;
switch (_that) {
case _BurstWindow():
return $default(_that.start,_that.end,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime start,  DateTime end,  int count)?  $default,) {final _that = this;
switch (_that) {
case _BurstWindow() when $default != null:
return $default(_that.start,_that.end,_that.count);case _:
  return null;

}
}

}

/// @nodoc


class _BurstWindow implements BurstWindow {
  const _BurstWindow({required this.start, required this.end, required this.count});
  

@override final  DateTime start;
@override final  DateTime end;
@override final  int count;

/// Create a copy of BurstWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BurstWindowCopyWith<_BurstWindow> get copyWith => __$BurstWindowCopyWithImpl<_BurstWindow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BurstWindow&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode {
    return Object.hash(runtimeType,start,end,count);
}

@override
String toString() {
    return 'BurstWindow(start: $start, end: $end, count: $count)';
}


}

/// @nodoc
abstract mixin class _$BurstWindowCopyWith<$Res> implements $BurstWindowCopyWith<$Res> {
  factory _$BurstWindowCopyWith(_BurstWindow value, $Res Function(_BurstWindow) _then) = __$BurstWindowCopyWithImpl;
@override @useResult
$Res call({
 DateTime start, DateTime end, int count
});




}
/// @nodoc
class __$BurstWindowCopyWithImpl<$Res>
    implements _$BurstWindowCopyWith<$Res> {
  __$BurstWindowCopyWithImpl(this._self, this._then);

  final _BurstWindow _self;
  final $Res Function(_BurstWindow) _then;

/// Create a copy of BurstWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,Object? count = null,}) {
  return _then(_BurstWindow(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ActivityAnalysis {

/// Oldest first.
 List<TimelinePoint> get timeline; List<BurstWindow> get bursts;/// The transactions with a place, oldest first.
 List<MapPoint> get mapPoints; List<ImpossibleTravel> get trips;/// Transactions without a place, which the map cannot show.
 int get withoutPlace; bool get truncated;
/// Create a copy of ActivityAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityAnalysisCopyWith<ActivityAnalysis> get copyWith => _$ActivityAnalysisCopyWithImpl<ActivityAnalysis>(this as ActivityAnalysis, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ActivityAnalysis;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityAnalysis&&const DeepCollectionEquality().equals(other.timeline, _this.timeline)&&const DeepCollectionEquality().equals(other.bursts, _this.bursts)&&const DeepCollectionEquality().equals(other.mapPoints, _this.mapPoints)&&const DeepCollectionEquality().equals(other.trips, _this.trips)&&(identical(other.withoutPlace, _this.withoutPlace) || other.withoutPlace == _this.withoutPlace)&&(identical(other.truncated, _this.truncated) || other.truncated == _this.truncated));
}


@override
int get hashCode {
  final _this = this as ActivityAnalysis;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.timeline),const DeepCollectionEquality().hash(_this.bursts),const DeepCollectionEquality().hash(_this.mapPoints),const DeepCollectionEquality().hash(_this.trips),_this.withoutPlace,_this.truncated);
}

@override
String toString() {
  final _this = this as ActivityAnalysis;
  return 'ActivityAnalysis(timeline: ${_this.timeline}, bursts: ${_this.bursts}, mapPoints: ${_this.mapPoints}, trips: ${_this.trips}, withoutPlace: ${_this.withoutPlace}, truncated: ${_this.truncated})';
}


}

/// @nodoc
abstract mixin class $ActivityAnalysisCopyWith<$Res>  {
  factory $ActivityAnalysisCopyWith(ActivityAnalysis value, $Res Function(ActivityAnalysis) _then) = _$ActivityAnalysisCopyWithImpl;
@useResult
$Res call({
 List<TimelinePoint> timeline, List<BurstWindow> bursts, List<MapPoint> mapPoints, List<ImpossibleTravel> trips, int withoutPlace, bool truncated
});




}
/// @nodoc
class _$ActivityAnalysisCopyWithImpl<$Res>
    implements $ActivityAnalysisCopyWith<$Res> {
  _$ActivityAnalysisCopyWithImpl(this._self, this._then);

  final ActivityAnalysis _self;
  final $Res Function(ActivityAnalysis) _then;

/// Create a copy of ActivityAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timeline = null,Object? bursts = null,Object? mapPoints = null,Object? trips = null,Object? withoutPlace = null,Object? truncated = null,}) {
  return _then(ActivityAnalysis(
timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<TimelinePoint>,bursts: null == bursts ? _self.bursts : bursts // ignore: cast_nullable_to_non_nullable
as List<BurstWindow>,mapPoints: null == mapPoints ? _self.mapPoints : mapPoints // ignore: cast_nullable_to_non_nullable
as List<MapPoint>,trips: null == trips ? _self.trips : trips // ignore: cast_nullable_to_non_nullable
as List<ImpossibleTravel>,withoutPlace: null == withoutPlace ? _self.withoutPlace : withoutPlace // ignore: cast_nullable_to_non_nullable
as int,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityAnalysis].
extension ActivityAnalysisPatterns on ActivityAnalysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityAnalysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _ActivityAnalysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityAnalysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TimelinePoint> timeline,  List<BurstWindow> bursts,  List<MapPoint> mapPoints,  List<ImpossibleTravel> trips,  int withoutPlace,  bool truncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityAnalysis() when $default != null:
return $default(_that.timeline,_that.bursts,_that.mapPoints,_that.trips,_that.withoutPlace,_that.truncated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TimelinePoint> timeline,  List<BurstWindow> bursts,  List<MapPoint> mapPoints,  List<ImpossibleTravel> trips,  int withoutPlace,  bool truncated)  $default,) {final _that = this;
switch (_that) {
case _ActivityAnalysis():
return $default(_that.timeline,_that.bursts,_that.mapPoints,_that.trips,_that.withoutPlace,_that.truncated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TimelinePoint> timeline,  List<BurstWindow> bursts,  List<MapPoint> mapPoints,  List<ImpossibleTravel> trips,  int withoutPlace,  bool truncated)?  $default,) {final _that = this;
switch (_that) {
case _ActivityAnalysis() when $default != null:
return $default(_that.timeline,_that.bursts,_that.mapPoints,_that.trips,_that.withoutPlace,_that.truncated);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityAnalysis extends ActivityAnalysis {
  const _ActivityAnalysis({required  List<TimelinePoint> timeline, required  List<BurstWindow> bursts, required  List<MapPoint> mapPoints, required  List<ImpossibleTravel> trips, required this.withoutPlace, this.truncated = false}): _timeline = timeline,_bursts = bursts,_mapPoints = mapPoints,_trips = trips,super._();
  

/// Oldest first.
 final  List<TimelinePoint> _timeline;
/// Oldest first.
@override List<TimelinePoint> get timeline {
  if (_timeline is EqualUnmodifiableListView) return _timeline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timeline);
}

 final  List<BurstWindow> _bursts;
@override List<BurstWindow> get bursts {
  if (_bursts is EqualUnmodifiableListView) return _bursts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bursts);
}

/// The transactions with a place, oldest first.
 final  List<MapPoint> _mapPoints;
/// The transactions with a place, oldest first.
@override List<MapPoint> get mapPoints {
  if (_mapPoints is EqualUnmodifiableListView) return _mapPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mapPoints);
}

 final  List<ImpossibleTravel> _trips;
@override List<ImpossibleTravel> get trips {
  if (_trips is EqualUnmodifiableListView) return _trips;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trips);
}

/// Transactions without a place, which the map cannot show.
@override final  int withoutPlace;
@override@JsonKey() final  bool truncated;

/// Create a copy of ActivityAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityAnalysisCopyWith<_ActivityAnalysis> get copyWith => __$ActivityAnalysisCopyWithImpl<_ActivityAnalysis>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityAnalysis&&const DeepCollectionEquality().equals(other.timeline, _timeline)&&const DeepCollectionEquality().equals(other.bursts, _bursts)&&const DeepCollectionEquality().equals(other.mapPoints, _mapPoints)&&const DeepCollectionEquality().equals(other.trips, _trips)&&(identical(other.withoutPlace, withoutPlace) || other.withoutPlace == withoutPlace)&&(identical(other.truncated, truncated) || other.truncated == truncated));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_timeline),const DeepCollectionEquality().hash(_bursts),const DeepCollectionEquality().hash(_mapPoints),const DeepCollectionEquality().hash(_trips),withoutPlace,truncated);
}

@override
String toString() {
    return 'ActivityAnalysis(timeline: $timeline, bursts: $bursts, mapPoints: $mapPoints, trips: $trips, withoutPlace: $withoutPlace, truncated: $truncated)';
}


}

/// @nodoc
abstract mixin class _$ActivityAnalysisCopyWith<$Res> implements $ActivityAnalysisCopyWith<$Res> {
  factory _$ActivityAnalysisCopyWith(_ActivityAnalysis value, $Res Function(_ActivityAnalysis) _then) = __$ActivityAnalysisCopyWithImpl;
@override @useResult
$Res call({
 List<TimelinePoint> timeline, List<BurstWindow> bursts, List<MapPoint> mapPoints, List<ImpossibleTravel> trips, int withoutPlace, bool truncated
});




}
/// @nodoc
class __$ActivityAnalysisCopyWithImpl<$Res>
    implements _$ActivityAnalysisCopyWith<$Res> {
  __$ActivityAnalysisCopyWithImpl(this._self, this._then);

  final _ActivityAnalysis _self;
  final $Res Function(_ActivityAnalysis) _then;

/// Create a copy of ActivityAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timeline = null,Object? bursts = null,Object? mapPoints = null,Object? trips = null,Object? withoutPlace = null,Object? truncated = null,}) {
  return _then(_ActivityAnalysis(
timeline: null == timeline ? _self._timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<TimelinePoint>,bursts: null == bursts ? _self._bursts : bursts // ignore: cast_nullable_to_non_nullable
as List<BurstWindow>,mapPoints: null == mapPoints ? _self._mapPoints : mapPoints // ignore: cast_nullable_to_non_nullable
as List<MapPoint>,trips: null == trips ? _self._trips : trips // ignore: cast_nullable_to_non_nullable
as List<ImpossibleTravel>,withoutPlace: null == withoutPlace ? _self.withoutPlace : withoutPlace // ignore: cast_nullable_to_non_nullable
as int,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
