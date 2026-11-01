// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_discovery_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapDiscoveryEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapDiscoveryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MapDiscoveryEvent()';
}


}

/// @nodoc
class $MapDiscoveryEventCopyWith<$Res>  {
$MapDiscoveryEventCopyWith(MapDiscoveryEvent _, $Res Function(MapDiscoveryEvent) __);
}


/// Adds pattern-matching-related methods to [MapDiscoveryEvent].
extension MapDiscoveryEventPatterns on MapDiscoveryEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MapDiscoveryLoadRequested value)?  loadRequested,TResult Function( MapDiscoveryMonumentSelected value)?  monumentSelected,TResult Function( MapDiscoverySelectionCleared value)?  selectionCleared,TResult Function( MapDiscoverySelectionRetryRequested value)?  selectionRetryRequested,TResult Function( MapDiscoveryRefinementApplied value)?  refinementApplied,TResult Function( MapDiscoveryRefinementsCleared value)?  refinementsCleared,TResult Function( MapDiscoveryClusterOpened value)?  clusterOpened,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MapDiscoveryLoadRequested() when loadRequested != null:
return loadRequested(_that);case MapDiscoveryMonumentSelected() when monumentSelected != null:
return monumentSelected(_that);case MapDiscoverySelectionCleared() when selectionCleared != null:
return selectionCleared(_that);case MapDiscoverySelectionRetryRequested() when selectionRetryRequested != null:
return selectionRetryRequested(_that);case MapDiscoveryRefinementApplied() when refinementApplied != null:
return refinementApplied(_that);case MapDiscoveryRefinementsCleared() when refinementsCleared != null:
return refinementsCleared(_that);case MapDiscoveryClusterOpened() when clusterOpened != null:
return clusterOpened(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MapDiscoveryLoadRequested value)  loadRequested,required TResult Function( MapDiscoveryMonumentSelected value)  monumentSelected,required TResult Function( MapDiscoverySelectionCleared value)  selectionCleared,required TResult Function( MapDiscoverySelectionRetryRequested value)  selectionRetryRequested,required TResult Function( MapDiscoveryRefinementApplied value)  refinementApplied,required TResult Function( MapDiscoveryRefinementsCleared value)  refinementsCleared,required TResult Function( MapDiscoveryClusterOpened value)  clusterOpened,}){
final _that = this;
switch (_that) {
case MapDiscoveryLoadRequested():
return loadRequested(_that);case MapDiscoveryMonumentSelected():
return monumentSelected(_that);case MapDiscoverySelectionCleared():
return selectionCleared(_that);case MapDiscoverySelectionRetryRequested():
return selectionRetryRequested(_that);case MapDiscoveryRefinementApplied():
return refinementApplied(_that);case MapDiscoveryRefinementsCleared():
return refinementsCleared(_that);case MapDiscoveryClusterOpened():
return clusterOpened(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MapDiscoveryLoadRequested value)?  loadRequested,TResult? Function( MapDiscoveryMonumentSelected value)?  monumentSelected,TResult? Function( MapDiscoverySelectionCleared value)?  selectionCleared,TResult? Function( MapDiscoverySelectionRetryRequested value)?  selectionRetryRequested,TResult? Function( MapDiscoveryRefinementApplied value)?  refinementApplied,TResult? Function( MapDiscoveryRefinementsCleared value)?  refinementsCleared,TResult? Function( MapDiscoveryClusterOpened value)?  clusterOpened,}){
final _that = this;
switch (_that) {
case MapDiscoveryLoadRequested() when loadRequested != null:
return loadRequested(_that);case MapDiscoveryMonumentSelected() when monumentSelected != null:
return monumentSelected(_that);case MapDiscoverySelectionCleared() when selectionCleared != null:
return selectionCleared(_that);case MapDiscoverySelectionRetryRequested() when selectionRetryRequested != null:
return selectionRetryRequested(_that);case MapDiscoveryRefinementApplied() when refinementApplied != null:
return refinementApplied(_that);case MapDiscoveryRefinementsCleared() when refinementsCleared != null:
return refinementsCleared(_that);case MapDiscoveryClusterOpened() when clusterOpened != null:
return clusterOpened(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String languageCode)?  loadRequested,TResult Function( String id,  MonumentPin? pin)?  monumentSelected,TResult Function()?  selectionCleared,TResult Function()?  selectionRetryRequested,TResult Function( MonumentSearchQuery query)?  refinementApplied,TResult Function()?  refinementsCleared,TResult Function( GeoBounds bounds)?  clusterOpened,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MapDiscoveryLoadRequested() when loadRequested != null:
return loadRequested(_that.languageCode);case MapDiscoveryMonumentSelected() when monumentSelected != null:
return monumentSelected(_that.id,_that.pin);case MapDiscoverySelectionCleared() when selectionCleared != null:
return selectionCleared();case MapDiscoverySelectionRetryRequested() when selectionRetryRequested != null:
return selectionRetryRequested();case MapDiscoveryRefinementApplied() when refinementApplied != null:
return refinementApplied(_that.query);case MapDiscoveryRefinementsCleared() when refinementsCleared != null:
return refinementsCleared();case MapDiscoveryClusterOpened() when clusterOpened != null:
return clusterOpened(_that.bounds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String languageCode)  loadRequested,required TResult Function( String id,  MonumentPin? pin)  monumentSelected,required TResult Function()  selectionCleared,required TResult Function()  selectionRetryRequested,required TResult Function( MonumentSearchQuery query)  refinementApplied,required TResult Function()  refinementsCleared,required TResult Function( GeoBounds bounds)  clusterOpened,}) {final _that = this;
switch (_that) {
case MapDiscoveryLoadRequested():
return loadRequested(_that.languageCode);case MapDiscoveryMonumentSelected():
return monumentSelected(_that.id,_that.pin);case MapDiscoverySelectionCleared():
return selectionCleared();case MapDiscoverySelectionRetryRequested():
return selectionRetryRequested();case MapDiscoveryRefinementApplied():
return refinementApplied(_that.query);case MapDiscoveryRefinementsCleared():
return refinementsCleared();case MapDiscoveryClusterOpened():
return clusterOpened(_that.bounds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String languageCode)?  loadRequested,TResult? Function( String id,  MonumentPin? pin)?  monumentSelected,TResult? Function()?  selectionCleared,TResult? Function()?  selectionRetryRequested,TResult? Function( MonumentSearchQuery query)?  refinementApplied,TResult? Function()?  refinementsCleared,TResult? Function( GeoBounds bounds)?  clusterOpened,}) {final _that = this;
switch (_that) {
case MapDiscoveryLoadRequested() when loadRequested != null:
return loadRequested(_that.languageCode);case MapDiscoveryMonumentSelected() when monumentSelected != null:
return monumentSelected(_that.id,_that.pin);case MapDiscoverySelectionCleared() when selectionCleared != null:
return selectionCleared();case MapDiscoverySelectionRetryRequested() when selectionRetryRequested != null:
return selectionRetryRequested();case MapDiscoveryRefinementApplied() when refinementApplied != null:
return refinementApplied(_that.query);case MapDiscoveryRefinementsCleared() when refinementsCleared != null:
return refinementsCleared();case MapDiscoveryClusterOpened() when clusterOpened != null:
return clusterOpened(_that.bounds);case _:
  return null;

}
}

}

/// @nodoc


class MapDiscoveryLoadRequested implements MapDiscoveryEvent {
  const MapDiscoveryLoadRequested({required this.languageCode});
  

 final  String languageCode;

/// Create a copy of MapDiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapDiscoveryLoadRequestedCopyWith<MapDiscoveryLoadRequested> get copyWith => _$MapDiscoveryLoadRequestedCopyWithImpl<MapDiscoveryLoadRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapDiscoveryLoadRequested&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,languageCode);
}

@override
String toString() {
    return 'MapDiscoveryEvent.loadRequested(languageCode: $languageCode)';
}


}

/// @nodoc
abstract mixin class $MapDiscoveryLoadRequestedCopyWith<$Res> implements $MapDiscoveryEventCopyWith<$Res> {
  factory $MapDiscoveryLoadRequestedCopyWith(MapDiscoveryLoadRequested value, $Res Function(MapDiscoveryLoadRequested) _then) = _$MapDiscoveryLoadRequestedCopyWithImpl;
@useResult
$Res call({
 String languageCode
});




}
/// @nodoc
class _$MapDiscoveryLoadRequestedCopyWithImpl<$Res>
    implements $MapDiscoveryLoadRequestedCopyWith<$Res> {
  _$MapDiscoveryLoadRequestedCopyWithImpl(this._self, this._then);

  final MapDiscoveryLoadRequested _self;
  final $Res Function(MapDiscoveryLoadRequested) _then;

/// Create a copy of MapDiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? languageCode = null,}) {
  return _then(MapDiscoveryLoadRequested(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MapDiscoveryMonumentSelected implements MapDiscoveryEvent {
  const MapDiscoveryMonumentSelected(this.id, {this.pin});
  

 final  String id;
 final  MonumentPin? pin;

/// Create a copy of MapDiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapDiscoveryMonumentSelectedCopyWith<MapDiscoveryMonumentSelected> get copyWith => _$MapDiscoveryMonumentSelectedCopyWithImpl<MapDiscoveryMonumentSelected>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapDiscoveryMonumentSelected&&(identical(other.id, id) || other.id == id)&&(identical(other.pin, pin) || other.pin == pin));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,pin);
}

@override
String toString() {
    return 'MapDiscoveryEvent.monumentSelected(id: $id, pin: $pin)';
}


}

/// @nodoc
abstract mixin class $MapDiscoveryMonumentSelectedCopyWith<$Res> implements $MapDiscoveryEventCopyWith<$Res> {
  factory $MapDiscoveryMonumentSelectedCopyWith(MapDiscoveryMonumentSelected value, $Res Function(MapDiscoveryMonumentSelected) _then) = _$MapDiscoveryMonumentSelectedCopyWithImpl;
@useResult
$Res call({
 String id, MonumentPin? pin
});




}
/// @nodoc
class _$MapDiscoveryMonumentSelectedCopyWithImpl<$Res>
    implements $MapDiscoveryMonumentSelectedCopyWith<$Res> {
  _$MapDiscoveryMonumentSelectedCopyWithImpl(this._self, this._then);

  final MapDiscoveryMonumentSelected _self;
  final $Res Function(MapDiscoveryMonumentSelected) _then;

/// Create a copy of MapDiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pin = freezed,}) {
  return _then(MapDiscoveryMonumentSelected(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pin: freezed == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as MonumentPin?,
  ));
}


}

/// @nodoc


class MapDiscoverySelectionCleared implements MapDiscoveryEvent {
  const MapDiscoverySelectionCleared();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapDiscoverySelectionCleared);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MapDiscoveryEvent.selectionCleared()';
}


}




/// @nodoc


class MapDiscoverySelectionRetryRequested implements MapDiscoveryEvent {
  const MapDiscoverySelectionRetryRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapDiscoverySelectionRetryRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MapDiscoveryEvent.selectionRetryRequested()';
}


}




/// @nodoc


class MapDiscoveryRefinementApplied implements MapDiscoveryEvent {
  const MapDiscoveryRefinementApplied(this.query);
  

 final  MonumentSearchQuery query;

/// Create a copy of MapDiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapDiscoveryRefinementAppliedCopyWith<MapDiscoveryRefinementApplied> get copyWith => _$MapDiscoveryRefinementAppliedCopyWithImpl<MapDiscoveryRefinementApplied>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapDiscoveryRefinementApplied&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query);
}

@override
String toString() {
    return 'MapDiscoveryEvent.refinementApplied(query: $query)';
}


}

/// @nodoc
abstract mixin class $MapDiscoveryRefinementAppliedCopyWith<$Res> implements $MapDiscoveryEventCopyWith<$Res> {
  factory $MapDiscoveryRefinementAppliedCopyWith(MapDiscoveryRefinementApplied value, $Res Function(MapDiscoveryRefinementApplied) _then) = _$MapDiscoveryRefinementAppliedCopyWithImpl;
@useResult
$Res call({
 MonumentSearchQuery query
});




}
/// @nodoc
class _$MapDiscoveryRefinementAppliedCopyWithImpl<$Res>
    implements $MapDiscoveryRefinementAppliedCopyWith<$Res> {
  _$MapDiscoveryRefinementAppliedCopyWithImpl(this._self, this._then);

  final MapDiscoveryRefinementApplied _self;
  final $Res Function(MapDiscoveryRefinementApplied) _then;

/// Create a copy of MapDiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(MapDiscoveryRefinementApplied(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as MonumentSearchQuery,
  ));
}


}

/// @nodoc


class MapDiscoveryRefinementsCleared implements MapDiscoveryEvent {
  const MapDiscoveryRefinementsCleared();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapDiscoveryRefinementsCleared);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MapDiscoveryEvent.refinementsCleared()';
}


}




/// @nodoc


class MapDiscoveryClusterOpened implements MapDiscoveryEvent {
  const MapDiscoveryClusterOpened(this.bounds);
  

 final  GeoBounds bounds;

/// Create a copy of MapDiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapDiscoveryClusterOpenedCopyWith<MapDiscoveryClusterOpened> get copyWith => _$MapDiscoveryClusterOpenedCopyWithImpl<MapDiscoveryClusterOpened>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapDiscoveryClusterOpened&&(identical(other.bounds, bounds) || other.bounds == bounds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,bounds);
}

@override
String toString() {
    return 'MapDiscoveryEvent.clusterOpened(bounds: $bounds)';
}


}

/// @nodoc
abstract mixin class $MapDiscoveryClusterOpenedCopyWith<$Res> implements $MapDiscoveryEventCopyWith<$Res> {
  factory $MapDiscoveryClusterOpenedCopyWith(MapDiscoveryClusterOpened value, $Res Function(MapDiscoveryClusterOpened) _then) = _$MapDiscoveryClusterOpenedCopyWithImpl;
@useResult
$Res call({
 GeoBounds bounds
});




}
/// @nodoc
class _$MapDiscoveryClusterOpenedCopyWithImpl<$Res>
    implements $MapDiscoveryClusterOpenedCopyWith<$Res> {
  _$MapDiscoveryClusterOpenedCopyWithImpl(this._self, this._then);

  final MapDiscoveryClusterOpened _self;
  final $Res Function(MapDiscoveryClusterOpened) _then;

/// Create a copy of MapDiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bounds = null,}) {
  return _then(MapDiscoveryClusterOpened(
null == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as GeoBounds,
  ));
}


}

/// @nodoc
mixin _$MapDiscoveryState {

 MapDiscoveryStatus get status;/// Uygulanan sorguya uyan eserlerin toplamı, sınırı ve katalog sürümü.
 MapExtent? get extent;/// Haritaya uygulanmış arama sorgusu ve filtre.
 MonumentSearchQuery get query;/// Sorgu kapsamı isteniyor.
 bool get isRefining;/// Son daraltma isteğinin hatası (önceki daraltma korunur).
 Failure? get refinementFailure; String? get selectedId;/// Haritadaki pinden seçildiyse pin kaydı (önizleme gelmeden konum/ad).
 MonumentPin? get selectedPin;/// Seçili eserin önizleme içeriği (eser detayından).
 MonumentDetail? get selection; SelectionStatus get selectionStatus; Failure? get selectionFailure;/// Aynı konum kümesi listesi.
 SelectionStatus get clusterStatus; List<MonumentPin> get clusterMonuments; Failure? get failure;
/// Create a copy of MapDiscoveryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapDiscoveryStateCopyWith<MapDiscoveryState> get copyWith => _$MapDiscoveryStateCopyWithImpl<MapDiscoveryState>(this as MapDiscoveryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MapDiscoveryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapDiscoveryState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.extent, _this.extent) || other.extent == _this.extent)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.isRefining, _this.isRefining) || other.isRefining == _this.isRefining)&&(identical(other.refinementFailure, _this.refinementFailure) || other.refinementFailure == _this.refinementFailure)&&(identical(other.selectedId, _this.selectedId) || other.selectedId == _this.selectedId)&&(identical(other.selectedPin, _this.selectedPin) || other.selectedPin == _this.selectedPin)&&(identical(other.selection, _this.selection) || other.selection == _this.selection)&&(identical(other.selectionStatus, _this.selectionStatus) || other.selectionStatus == _this.selectionStatus)&&(identical(other.selectionFailure, _this.selectionFailure) || other.selectionFailure == _this.selectionFailure)&&(identical(other.clusterStatus, _this.clusterStatus) || other.clusterStatus == _this.clusterStatus)&&const DeepCollectionEquality().equals(other.clusterMonuments, _this.clusterMonuments)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as MapDiscoveryState;
  return Object.hash(runtimeType,_this.status,_this.extent,_this.query,_this.isRefining,_this.refinementFailure,_this.selectedId,_this.selectedPin,_this.selection,_this.selectionStatus,_this.selectionFailure,_this.clusterStatus,const DeepCollectionEquality().hash(_this.clusterMonuments),_this.failure);
}

@override
String toString() {
  final _this = this as MapDiscoveryState;
  return 'MapDiscoveryState(status: ${_this.status}, extent: ${_this.extent}, query: ${_this.query}, isRefining: ${_this.isRefining}, refinementFailure: ${_this.refinementFailure}, selectedId: ${_this.selectedId}, selectedPin: ${_this.selectedPin}, selection: ${_this.selection}, selectionStatus: ${_this.selectionStatus}, selectionFailure: ${_this.selectionFailure}, clusterStatus: ${_this.clusterStatus}, clusterMonuments: ${_this.clusterMonuments}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $MapDiscoveryStateCopyWith<$Res>  {
  factory $MapDiscoveryStateCopyWith(MapDiscoveryState value, $Res Function(MapDiscoveryState) _then) = _$MapDiscoveryStateCopyWithImpl;
@useResult
$Res call({
 MapDiscoveryStatus status, MapExtent? extent, MonumentSearchQuery query, bool isRefining, Failure? refinementFailure, String? selectedId, MonumentPin? selectedPin, MonumentDetail? selection, SelectionStatus selectionStatus, Failure? selectionFailure, SelectionStatus clusterStatus, List<MonumentPin> clusterMonuments, Failure? failure
});




}
/// @nodoc
class _$MapDiscoveryStateCopyWithImpl<$Res>
    implements $MapDiscoveryStateCopyWith<$Res> {
  _$MapDiscoveryStateCopyWithImpl(this._self, this._then);

  final MapDiscoveryState _self;
  final $Res Function(MapDiscoveryState) _then;

/// Create a copy of MapDiscoveryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? extent = freezed,Object? query = null,Object? isRefining = null,Object? refinementFailure = freezed,Object? selectedId = freezed,Object? selectedPin = freezed,Object? selection = freezed,Object? selectionStatus = null,Object? selectionFailure = freezed,Object? clusterStatus = null,Object? clusterMonuments = null,Object? failure = freezed,}) {
  return _then(MapDiscoveryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MapDiscoveryStatus,extent: freezed == extent ? _self.extent : extent // ignore: cast_nullable_to_non_nullable
as MapExtent?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as MonumentSearchQuery,isRefining: null == isRefining ? _self.isRefining : isRefining // ignore: cast_nullable_to_non_nullable
as bool,refinementFailure: freezed == refinementFailure ? _self.refinementFailure : refinementFailure // ignore: cast_nullable_to_non_nullable
as Failure?,selectedId: freezed == selectedId ? _self.selectedId : selectedId // ignore: cast_nullable_to_non_nullable
as String?,selectedPin: freezed == selectedPin ? _self.selectedPin : selectedPin // ignore: cast_nullable_to_non_nullable
as MonumentPin?,selection: freezed == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as MonumentDetail?,selectionStatus: null == selectionStatus ? _self.selectionStatus : selectionStatus // ignore: cast_nullable_to_non_nullable
as SelectionStatus,selectionFailure: freezed == selectionFailure ? _self.selectionFailure : selectionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,clusterStatus: null == clusterStatus ? _self.clusterStatus : clusterStatus // ignore: cast_nullable_to_non_nullable
as SelectionStatus,clusterMonuments: null == clusterMonuments ? _self.clusterMonuments : clusterMonuments // ignore: cast_nullable_to_non_nullable
as List<MonumentPin>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapDiscoveryState].
extension MapDiscoveryStatePatterns on MapDiscoveryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapDiscoveryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapDiscoveryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapDiscoveryState value)  $default,){
final _that = this;
switch (_that) {
case _MapDiscoveryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapDiscoveryState value)?  $default,){
final _that = this;
switch (_that) {
case _MapDiscoveryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MapDiscoveryStatus status,  MapExtent? extent,  MonumentSearchQuery query,  bool isRefining,  Failure? refinementFailure,  String? selectedId,  MonumentPin? selectedPin,  MonumentDetail? selection,  SelectionStatus selectionStatus,  Failure? selectionFailure,  SelectionStatus clusterStatus,  List<MonumentPin> clusterMonuments,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapDiscoveryState() when $default != null:
return $default(_that.status,_that.extent,_that.query,_that.isRefining,_that.refinementFailure,_that.selectedId,_that.selectedPin,_that.selection,_that.selectionStatus,_that.selectionFailure,_that.clusterStatus,_that.clusterMonuments,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MapDiscoveryStatus status,  MapExtent? extent,  MonumentSearchQuery query,  bool isRefining,  Failure? refinementFailure,  String? selectedId,  MonumentPin? selectedPin,  MonumentDetail? selection,  SelectionStatus selectionStatus,  Failure? selectionFailure,  SelectionStatus clusterStatus,  List<MonumentPin> clusterMonuments,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _MapDiscoveryState():
return $default(_that.status,_that.extent,_that.query,_that.isRefining,_that.refinementFailure,_that.selectedId,_that.selectedPin,_that.selection,_that.selectionStatus,_that.selectionFailure,_that.clusterStatus,_that.clusterMonuments,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MapDiscoveryStatus status,  MapExtent? extent,  MonumentSearchQuery query,  bool isRefining,  Failure? refinementFailure,  String? selectedId,  MonumentPin? selectedPin,  MonumentDetail? selection,  SelectionStatus selectionStatus,  Failure? selectionFailure,  SelectionStatus clusterStatus,  List<MonumentPin> clusterMonuments,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _MapDiscoveryState() when $default != null:
return $default(_that.status,_that.extent,_that.query,_that.isRefining,_that.refinementFailure,_that.selectedId,_that.selectedPin,_that.selection,_that.selectionStatus,_that.selectionFailure,_that.clusterStatus,_that.clusterMonuments,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _MapDiscoveryState extends MapDiscoveryState {
  const _MapDiscoveryState({this.status = MapDiscoveryStatus.initial, this.extent, this.query = MonumentSearchQuery.empty, this.isRefining = false, this.refinementFailure, this.selectedId, this.selectedPin, this.selection, this.selectionStatus = SelectionStatus.none, this.selectionFailure, this.clusterStatus = SelectionStatus.none,  List<MonumentPin> clusterMonuments = const <MonumentPin>[], this.failure}): _clusterMonuments = clusterMonuments,super._();
  

@override@JsonKey() final  MapDiscoveryStatus status;
/// Uygulanan sorguya uyan eserlerin toplamı, sınırı ve katalog sürümü.
@override final  MapExtent? extent;
/// Haritaya uygulanmış arama sorgusu ve filtre.
@override@JsonKey() final  MonumentSearchQuery query;
/// Sorgu kapsamı isteniyor.
@override@JsonKey() final  bool isRefining;
/// Son daraltma isteğinin hatası (önceki daraltma korunur).
@override final  Failure? refinementFailure;
@override final  String? selectedId;
/// Haritadaki pinden seçildiyse pin kaydı (önizleme gelmeden konum/ad).
@override final  MonumentPin? selectedPin;
/// Seçili eserin önizleme içeriği (eser detayından).
@override final  MonumentDetail? selection;
@override@JsonKey() final  SelectionStatus selectionStatus;
@override final  Failure? selectionFailure;
/// Aynı konum kümesi listesi.
@override@JsonKey() final  SelectionStatus clusterStatus;
 final  List<MonumentPin> _clusterMonuments;
@override@JsonKey() List<MonumentPin> get clusterMonuments {
  if (_clusterMonuments is EqualUnmodifiableListView) return _clusterMonuments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_clusterMonuments);
}

@override final  Failure? failure;

/// Create a copy of MapDiscoveryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapDiscoveryStateCopyWith<_MapDiscoveryState> get copyWith => __$MapDiscoveryStateCopyWithImpl<_MapDiscoveryState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapDiscoveryState&&(identical(other.status, status) || other.status == status)&&(identical(other.extent, extent) || other.extent == extent)&&(identical(other.query, query) || other.query == query)&&(identical(other.isRefining, isRefining) || other.isRefining == isRefining)&&(identical(other.refinementFailure, refinementFailure) || other.refinementFailure == refinementFailure)&&(identical(other.selectedId, selectedId) || other.selectedId == selectedId)&&(identical(other.selectedPin, selectedPin) || other.selectedPin == selectedPin)&&(identical(other.selection, selection) || other.selection == selection)&&(identical(other.selectionStatus, selectionStatus) || other.selectionStatus == selectionStatus)&&(identical(other.selectionFailure, selectionFailure) || other.selectionFailure == selectionFailure)&&(identical(other.clusterStatus, clusterStatus) || other.clusterStatus == clusterStatus)&&const DeepCollectionEquality().equals(other.clusterMonuments, _clusterMonuments)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,extent,query,isRefining,refinementFailure,selectedId,selectedPin,selection,selectionStatus,selectionFailure,clusterStatus,const DeepCollectionEquality().hash(_clusterMonuments),failure);
}

@override
String toString() {
    return 'MapDiscoveryState(status: $status, extent: $extent, query: $query, isRefining: $isRefining, refinementFailure: $refinementFailure, selectedId: $selectedId, selectedPin: $selectedPin, selection: $selection, selectionStatus: $selectionStatus, selectionFailure: $selectionFailure, clusterStatus: $clusterStatus, clusterMonuments: $clusterMonuments, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$MapDiscoveryStateCopyWith<$Res> implements $MapDiscoveryStateCopyWith<$Res> {
  factory _$MapDiscoveryStateCopyWith(_MapDiscoveryState value, $Res Function(_MapDiscoveryState) _then) = __$MapDiscoveryStateCopyWithImpl;
@override @useResult
$Res call({
 MapDiscoveryStatus status, MapExtent? extent, MonumentSearchQuery query, bool isRefining, Failure? refinementFailure, String? selectedId, MonumentPin? selectedPin, MonumentDetail? selection, SelectionStatus selectionStatus, Failure? selectionFailure, SelectionStatus clusterStatus, List<MonumentPin> clusterMonuments, Failure? failure
});




}
/// @nodoc
class __$MapDiscoveryStateCopyWithImpl<$Res>
    implements _$MapDiscoveryStateCopyWith<$Res> {
  __$MapDiscoveryStateCopyWithImpl(this._self, this._then);

  final _MapDiscoveryState _self;
  final $Res Function(_MapDiscoveryState) _then;

/// Create a copy of MapDiscoveryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? extent = freezed,Object? query = null,Object? isRefining = null,Object? refinementFailure = freezed,Object? selectedId = freezed,Object? selectedPin = freezed,Object? selection = freezed,Object? selectionStatus = null,Object? selectionFailure = freezed,Object? clusterStatus = null,Object? clusterMonuments = null,Object? failure = freezed,}) {
  return _then(_MapDiscoveryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MapDiscoveryStatus,extent: freezed == extent ? _self.extent : extent // ignore: cast_nullable_to_non_nullable
as MapExtent?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as MonumentSearchQuery,isRefining: null == isRefining ? _self.isRefining : isRefining // ignore: cast_nullable_to_non_nullable
as bool,refinementFailure: freezed == refinementFailure ? _self.refinementFailure : refinementFailure // ignore: cast_nullable_to_non_nullable
as Failure?,selectedId: freezed == selectedId ? _self.selectedId : selectedId // ignore: cast_nullable_to_non_nullable
as String?,selectedPin: freezed == selectedPin ? _self.selectedPin : selectedPin // ignore: cast_nullable_to_non_nullable
as MonumentPin?,selection: freezed == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as MonumentDetail?,selectionStatus: null == selectionStatus ? _self.selectionStatus : selectionStatus // ignore: cast_nullable_to_non_nullable
as SelectionStatus,selectionFailure: freezed == selectionFailure ? _self.selectionFailure : selectionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,clusterStatus: null == clusterStatus ? _self.clusterStatus : clusterStatus // ignore: cast_nullable_to_non_nullable
as SelectionStatus,clusterMonuments: null == clusterMonuments ? _self._clusterMonuments : clusterMonuments // ignore: cast_nullable_to_non_nullable
as List<MonumentPin>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
