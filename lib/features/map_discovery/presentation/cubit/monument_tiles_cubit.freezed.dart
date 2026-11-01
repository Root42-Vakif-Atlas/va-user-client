// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monument_tiles_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonumentTilesState {

/// Görünür alanın kümeleri ve tekil eserleri.
 List<MapTileItem> get items;/// Yakın zum'da ([MapTiles.complexExpandZoom]) açılan külliyelerin
/// yerleşim alanları; [items]'tan ayrıdır, birleştirmeye girmez.
 List<MapTileComplex> get complexes; bool get isLoading;/// Son istek hatası; [items] son başarılı görünümdür.
 Failure? get failure;/// Katalog sürümü; `null` → henüz bilinmiyor, istek yapılmaz.
 String? get version; String get languageCode; MonumentSearchQuery get query;
/// Create a copy of MonumentTilesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentTilesStateCopyWith<MonumentTilesState> get copyWith => _$MonumentTilesStateCopyWithImpl<MonumentTilesState>(this as MonumentTilesState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MonumentTilesState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentTilesState&&const DeepCollectionEquality().equals(other.items, _this.items)&&const DeepCollectionEquality().equals(other.complexes, _this.complexes)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.languageCode, _this.languageCode) || other.languageCode == _this.languageCode)&&(identical(other.query, _this.query) || other.query == _this.query));
}


@override
int get hashCode {
  final _this = this as MonumentTilesState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),const DeepCollectionEquality().hash(_this.complexes),_this.isLoading,_this.failure,_this.version,_this.languageCode,_this.query);
}

@override
String toString() {
  final _this = this as MonumentTilesState;
  return 'MonumentTilesState(items: ${_this.items}, complexes: ${_this.complexes}, isLoading: ${_this.isLoading}, failure: ${_this.failure}, version: ${_this.version}, languageCode: ${_this.languageCode}, query: ${_this.query})';
}


}

/// @nodoc
abstract mixin class $MonumentTilesStateCopyWith<$Res>  {
  factory $MonumentTilesStateCopyWith(MonumentTilesState value, $Res Function(MonumentTilesState) _then) = _$MonumentTilesStateCopyWithImpl;
@useResult
$Res call({
 List<MapTileItem> items, List<MapTileComplex> complexes, bool isLoading, Failure? failure, String? version, String languageCode, MonumentSearchQuery query
});




}
/// @nodoc
class _$MonumentTilesStateCopyWithImpl<$Res>
    implements $MonumentTilesStateCopyWith<$Res> {
  _$MonumentTilesStateCopyWithImpl(this._self, this._then);

  final MonumentTilesState _self;
  final $Res Function(MonumentTilesState) _then;

/// Create a copy of MonumentTilesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? complexes = null,Object? isLoading = null,Object? failure = freezed,Object? version = freezed,Object? languageCode = null,Object? query = null,}) {
  return _then(MonumentTilesState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MapTileItem>,complexes: null == complexes ? _self.complexes : complexes // ignore: cast_nullable_to_non_nullable
as List<MapTileComplex>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as MonumentSearchQuery,
  ));
}

}


/// Adds pattern-matching-related methods to [MonumentTilesState].
extension MonumentTilesStatePatterns on MonumentTilesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonumentTilesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonumentTilesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonumentTilesState value)  $default,){
final _that = this;
switch (_that) {
case _MonumentTilesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonumentTilesState value)?  $default,){
final _that = this;
switch (_that) {
case _MonumentTilesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MapTileItem> items,  List<MapTileComplex> complexes,  bool isLoading,  Failure? failure,  String? version,  String languageCode,  MonumentSearchQuery query)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonumentTilesState() when $default != null:
return $default(_that.items,_that.complexes,_that.isLoading,_that.failure,_that.version,_that.languageCode,_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MapTileItem> items,  List<MapTileComplex> complexes,  bool isLoading,  Failure? failure,  String? version,  String languageCode,  MonumentSearchQuery query)  $default,) {final _that = this;
switch (_that) {
case _MonumentTilesState():
return $default(_that.items,_that.complexes,_that.isLoading,_that.failure,_that.version,_that.languageCode,_that.query);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MapTileItem> items,  List<MapTileComplex> complexes,  bool isLoading,  Failure? failure,  String? version,  String languageCode,  MonumentSearchQuery query)?  $default,) {final _that = this;
switch (_that) {
case _MonumentTilesState() when $default != null:
return $default(_that.items,_that.complexes,_that.isLoading,_that.failure,_that.version,_that.languageCode,_that.query);case _:
  return null;

}
}

}

/// @nodoc


class _MonumentTilesState implements MonumentTilesState {
  const _MonumentTilesState({ List<MapTileItem> items = const <MapTileItem>[],  List<MapTileComplex> complexes = const <MapTileComplex>[], this.isLoading = false, this.failure, this.version, this.languageCode = 'tr', this.query = MonumentSearchQuery.empty}): _items = items,_complexes = complexes;
  

/// Görünür alanın kümeleri ve tekil eserleri.
 final  List<MapTileItem> _items;
/// Görünür alanın kümeleri ve tekil eserleri.
@override@JsonKey() List<MapTileItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Yakın zum'da ([MapTiles.complexExpandZoom]) açılan külliyelerin
/// yerleşim alanları; [items]'tan ayrıdır, birleştirmeye girmez.
 final  List<MapTileComplex> _complexes;
/// Yakın zum'da ([MapTiles.complexExpandZoom]) açılan külliyelerin
/// yerleşim alanları; [items]'tan ayrıdır, birleştirmeye girmez.
@override@JsonKey() List<MapTileComplex> get complexes {
  if (_complexes is EqualUnmodifiableListView) return _complexes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_complexes);
}

@override@JsonKey() final  bool isLoading;
/// Son istek hatası; [items] son başarılı görünümdür.
@override final  Failure? failure;
/// Katalog sürümü; `null` → henüz bilinmiyor, istek yapılmaz.
@override final  String? version;
@override@JsonKey() final  String languageCode;
@override@JsonKey() final  MonumentSearchQuery query;

/// Create a copy of MonumentTilesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonumentTilesStateCopyWith<_MonumentTilesState> get copyWith => __$MonumentTilesStateCopyWithImpl<_MonumentTilesState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonumentTilesState&&const DeepCollectionEquality().equals(other.items, _items)&&const DeepCollectionEquality().equals(other.complexes, _complexes)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.version, version) || other.version == version)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_complexes),isLoading,failure,version,languageCode,query);
}

@override
String toString() {
    return 'MonumentTilesState(items: $items, complexes: $complexes, isLoading: $isLoading, failure: $failure, version: $version, languageCode: $languageCode, query: $query)';
}


}

/// @nodoc
abstract mixin class _$MonumentTilesStateCopyWith<$Res> implements $MonumentTilesStateCopyWith<$Res> {
  factory _$MonumentTilesStateCopyWith(_MonumentTilesState value, $Res Function(_MonumentTilesState) _then) = __$MonumentTilesStateCopyWithImpl;
@override @useResult
$Res call({
 List<MapTileItem> items, List<MapTileComplex> complexes, bool isLoading, Failure? failure, String? version, String languageCode, MonumentSearchQuery query
});




}
/// @nodoc
class __$MonumentTilesStateCopyWithImpl<$Res>
    implements _$MonumentTilesStateCopyWith<$Res> {
  __$MonumentTilesStateCopyWithImpl(this._self, this._then);

  final _MonumentTilesState _self;
  final $Res Function(_MonumentTilesState) _then;

/// Create a copy of MonumentTilesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? complexes = null,Object? isLoading = null,Object? failure = freezed,Object? version = freezed,Object? languageCode = null,Object? query = null,}) {
  return _then(_MonumentTilesState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MapTileItem>,complexes: null == complexes ? _self._complexes : complexes // ignore: cast_nullable_to_non_nullable
as List<MapTileComplex>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as MonumentSearchQuery,
  ));
}


}

// dart format on
