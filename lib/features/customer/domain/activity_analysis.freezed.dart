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
mixin _$TimelineAnalysis {

/// Transactions with their anomalies and security events, oldest first.
 List<TimelinePoint> get timeline; List<BurstWindow> get bursts;/// The range had more activity than was read (see [CustomerActivity.truncated]).
 bool get truncated;
/// Create a copy of TimelineAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineAnalysisCopyWith<TimelineAnalysis> get copyWith => _$TimelineAnalysisCopyWithImpl<TimelineAnalysis>(this as TimelineAnalysis, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TimelineAnalysis;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineAnalysis&&const DeepCollectionEquality().equals(other.timeline, _this.timeline)&&const DeepCollectionEquality().equals(other.bursts, _this.bursts)&&(identical(other.truncated, _this.truncated) || other.truncated == _this.truncated));
}


@override
int get hashCode {
  final _this = this as TimelineAnalysis;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.timeline),const DeepCollectionEquality().hash(_this.bursts),_this.truncated);
}

@override
String toString() {
  final _this = this as TimelineAnalysis;
  return 'TimelineAnalysis(timeline: ${_this.timeline}, bursts: ${_this.bursts}, truncated: ${_this.truncated})';
}


}

/// @nodoc
abstract mixin class $TimelineAnalysisCopyWith<$Res>  {
  factory $TimelineAnalysisCopyWith(TimelineAnalysis value, $Res Function(TimelineAnalysis) _then) = _$TimelineAnalysisCopyWithImpl;
@useResult
$Res call({
 List<TimelinePoint> timeline, List<BurstWindow> bursts, bool truncated
});




}
/// @nodoc
class _$TimelineAnalysisCopyWithImpl<$Res>
    implements $TimelineAnalysisCopyWith<$Res> {
  _$TimelineAnalysisCopyWithImpl(this._self, this._then);

  final TimelineAnalysis _self;
  final $Res Function(TimelineAnalysis) _then;

/// Create a copy of TimelineAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timeline = null,Object? bursts = null,Object? truncated = null,}) {
  return _then(TimelineAnalysis(
timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<TimelinePoint>,bursts: null == bursts ? _self.bursts : bursts // ignore: cast_nullable_to_non_nullable
as List<BurstWindow>,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TimelineAnalysis].
extension TimelineAnalysisPatterns on TimelineAnalysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimelineAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimelineAnalysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimelineAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _TimelineAnalysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimelineAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _TimelineAnalysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TimelinePoint> timeline,  List<BurstWindow> bursts,  bool truncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimelineAnalysis() when $default != null:
return $default(_that.timeline,_that.bursts,_that.truncated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TimelinePoint> timeline,  List<BurstWindow> bursts,  bool truncated)  $default,) {final _that = this;
switch (_that) {
case _TimelineAnalysis():
return $default(_that.timeline,_that.bursts,_that.truncated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TimelinePoint> timeline,  List<BurstWindow> bursts,  bool truncated)?  $default,) {final _that = this;
switch (_that) {
case _TimelineAnalysis() when $default != null:
return $default(_that.timeline,_that.bursts,_that.truncated);case _:
  return null;

}
}

}

/// @nodoc


class _TimelineAnalysis extends TimelineAnalysis {
  const _TimelineAnalysis({required  List<TimelinePoint> timeline, required  List<BurstWindow> bursts, this.truncated = false}): _timeline = timeline,_bursts = bursts,super._();
  

/// Transactions with their anomalies and security events, oldest first.
 final  List<TimelinePoint> _timeline;
/// Transactions with their anomalies and security events, oldest first.
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

/// The range had more activity than was read (see [CustomerActivity.truncated]).
@override@JsonKey() final  bool truncated;

/// Create a copy of TimelineAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelineAnalysisCopyWith<_TimelineAnalysis> get copyWith => __$TimelineAnalysisCopyWithImpl<_TimelineAnalysis>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimelineAnalysis&&const DeepCollectionEquality().equals(other.timeline, _timeline)&&const DeepCollectionEquality().equals(other.bursts, _bursts)&&(identical(other.truncated, truncated) || other.truncated == truncated));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_timeline),const DeepCollectionEquality().hash(_bursts),truncated);
}

@override
String toString() {
    return 'TimelineAnalysis(timeline: $timeline, bursts: $bursts, truncated: $truncated)';
}


}

/// @nodoc
abstract mixin class _$TimelineAnalysisCopyWith<$Res> implements $TimelineAnalysisCopyWith<$Res> {
  factory _$TimelineAnalysisCopyWith(_TimelineAnalysis value, $Res Function(_TimelineAnalysis) _then) = __$TimelineAnalysisCopyWithImpl;
@override @useResult
$Res call({
 List<TimelinePoint> timeline, List<BurstWindow> bursts, bool truncated
});




}
/// @nodoc
class __$TimelineAnalysisCopyWithImpl<$Res>
    implements _$TimelineAnalysisCopyWith<$Res> {
  __$TimelineAnalysisCopyWithImpl(this._self, this._then);

  final _TimelineAnalysis _self;
  final $Res Function(_TimelineAnalysis) _then;

/// Create a copy of TimelineAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timeline = null,Object? bursts = null,Object? truncated = null,}) {
  return _then(_TimelineAnalysis(
timeline: null == timeline ? _self._timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<TimelinePoint>,bursts: null == bursts ? _self._bursts : bursts // ignore: cast_nullable_to_non_nullable
as List<BurstWindow>,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$MapAnalysis {

/// The transactions with a place, oldest first.
 List<MapPoint> get points; List<ImpossibleTravel> get trips;/// Anomalies by transaction id, for the detail card. Ids without any are left out.
 Map<int, Set<ActivityAnomaly>> get anomalies;/// Transactions without a place, which the map cannot show.
 int get withoutPlace;/// The range had more activity than was read (see [CustomerActivity.truncated]).
 bool get truncated;
/// Create a copy of MapAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapAnalysisCopyWith<MapAnalysis> get copyWith => _$MapAnalysisCopyWithImpl<MapAnalysis>(this as MapAnalysis, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MapAnalysis;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapAnalysis&&const DeepCollectionEquality().equals(other.points, _this.points)&&const DeepCollectionEquality().equals(other.trips, _this.trips)&&const DeepCollectionEquality().equals(other.anomalies, _this.anomalies)&&(identical(other.withoutPlace, _this.withoutPlace) || other.withoutPlace == _this.withoutPlace)&&(identical(other.truncated, _this.truncated) || other.truncated == _this.truncated));
}


@override
int get hashCode {
  final _this = this as MapAnalysis;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.points),const DeepCollectionEquality().hash(_this.trips),const DeepCollectionEquality().hash(_this.anomalies),_this.withoutPlace,_this.truncated);
}

@override
String toString() {
  final _this = this as MapAnalysis;
  return 'MapAnalysis(points: ${_this.points}, trips: ${_this.trips}, anomalies: ${_this.anomalies}, withoutPlace: ${_this.withoutPlace}, truncated: ${_this.truncated})';
}


}

/// @nodoc
abstract mixin class $MapAnalysisCopyWith<$Res>  {
  factory $MapAnalysisCopyWith(MapAnalysis value, $Res Function(MapAnalysis) _then) = _$MapAnalysisCopyWithImpl;
@useResult
$Res call({
 List<MapPoint> points, List<ImpossibleTravel> trips, Map<int, Set<ActivityAnomaly>> anomalies, int withoutPlace, bool truncated
});




}
/// @nodoc
class _$MapAnalysisCopyWithImpl<$Res>
    implements $MapAnalysisCopyWith<$Res> {
  _$MapAnalysisCopyWithImpl(this._self, this._then);

  final MapAnalysis _self;
  final $Res Function(MapAnalysis) _then;

/// Create a copy of MapAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? points = null,Object? trips = null,Object? anomalies = null,Object? withoutPlace = null,Object? truncated = null,}) {
  return _then(MapAnalysis(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<MapPoint>,trips: null == trips ? _self.trips : trips // ignore: cast_nullable_to_non_nullable
as List<ImpossibleTravel>,anomalies: null == anomalies ? _self.anomalies : anomalies // ignore: cast_nullable_to_non_nullable
as Map<int, Set<ActivityAnomaly>>,withoutPlace: null == withoutPlace ? _self.withoutPlace : withoutPlace // ignore: cast_nullable_to_non_nullable
as int,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MapAnalysis].
extension MapAnalysisPatterns on MapAnalysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapAnalysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _MapAnalysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _MapAnalysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MapPoint> points,  List<ImpossibleTravel> trips,  Map<int, Set<ActivityAnomaly>> anomalies,  int withoutPlace,  bool truncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapAnalysis() when $default != null:
return $default(_that.points,_that.trips,_that.anomalies,_that.withoutPlace,_that.truncated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MapPoint> points,  List<ImpossibleTravel> trips,  Map<int, Set<ActivityAnomaly>> anomalies,  int withoutPlace,  bool truncated)  $default,) {final _that = this;
switch (_that) {
case _MapAnalysis():
return $default(_that.points,_that.trips,_that.anomalies,_that.withoutPlace,_that.truncated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MapPoint> points,  List<ImpossibleTravel> trips,  Map<int, Set<ActivityAnomaly>> anomalies,  int withoutPlace,  bool truncated)?  $default,) {final _that = this;
switch (_that) {
case _MapAnalysis() when $default != null:
return $default(_that.points,_that.trips,_that.anomalies,_that.withoutPlace,_that.truncated);case _:
  return null;

}
}

}

/// @nodoc


class _MapAnalysis extends MapAnalysis {
  const _MapAnalysis({required  List<MapPoint> points, required  List<ImpossibleTravel> trips, required  Map<int, Set<ActivityAnomaly>> anomalies, required this.withoutPlace, this.truncated = false}): _points = points,_trips = trips,_anomalies = anomalies,super._();
  

/// The transactions with a place, oldest first.
 final  List<MapPoint> _points;
/// The transactions with a place, oldest first.
@override List<MapPoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

 final  List<ImpossibleTravel> _trips;
@override List<ImpossibleTravel> get trips {
  if (_trips is EqualUnmodifiableListView) return _trips;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trips);
}

/// Anomalies by transaction id, for the detail card. Ids without any are left out.
 final  Map<int, Set<ActivityAnomaly>> _anomalies;
/// Anomalies by transaction id, for the detail card. Ids without any are left out.
@override Map<int, Set<ActivityAnomaly>> get anomalies {
  if (_anomalies is EqualUnmodifiableMapView) return _anomalies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_anomalies);
}

/// Transactions without a place, which the map cannot show.
@override final  int withoutPlace;
/// The range had more activity than was read (see [CustomerActivity.truncated]).
@override@JsonKey() final  bool truncated;

/// Create a copy of MapAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapAnalysisCopyWith<_MapAnalysis> get copyWith => __$MapAnalysisCopyWithImpl<_MapAnalysis>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapAnalysis&&const DeepCollectionEquality().equals(other.points, _points)&&const DeepCollectionEquality().equals(other.trips, _trips)&&const DeepCollectionEquality().equals(other.anomalies, _anomalies)&&(identical(other.withoutPlace, withoutPlace) || other.withoutPlace == withoutPlace)&&(identical(other.truncated, truncated) || other.truncated == truncated));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_points),const DeepCollectionEquality().hash(_trips),const DeepCollectionEquality().hash(_anomalies),withoutPlace,truncated);
}

@override
String toString() {
    return 'MapAnalysis(points: $points, trips: $trips, anomalies: $anomalies, withoutPlace: $withoutPlace, truncated: $truncated)';
}


}

/// @nodoc
abstract mixin class _$MapAnalysisCopyWith<$Res> implements $MapAnalysisCopyWith<$Res> {
  factory _$MapAnalysisCopyWith(_MapAnalysis value, $Res Function(_MapAnalysis) _then) = __$MapAnalysisCopyWithImpl;
@override @useResult
$Res call({
 List<MapPoint> points, List<ImpossibleTravel> trips, Map<int, Set<ActivityAnomaly>> anomalies, int withoutPlace, bool truncated
});




}
/// @nodoc
class __$MapAnalysisCopyWithImpl<$Res>
    implements _$MapAnalysisCopyWith<$Res> {
  __$MapAnalysisCopyWithImpl(this._self, this._then);

  final _MapAnalysis _self;
  final $Res Function(_MapAnalysis) _then;

/// Create a copy of MapAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? trips = null,Object? anomalies = null,Object? withoutPlace = null,Object? truncated = null,}) {
  return _then(_MapAnalysis(
points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<MapPoint>,trips: null == trips ? _self._trips : trips // ignore: cast_nullable_to_non_nullable
as List<ImpossibleTravel>,anomalies: null == anomalies ? _self._anomalies : anomalies // ignore: cast_nullable_to_non_nullable
as Map<int, Set<ActivityAnomaly>>,withoutPlace: null == withoutPlace ? _self.withoutPlace : withoutPlace // ignore: cast_nullable_to_non_nullable
as int,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
