// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monument_search_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonumentSearchResponseDto {

 List<MonumentSummaryDto> get items; int get total; String? get nextCursor; List<MonumentPlaceDto> get places; MonumentFacetsDto? get facets;
/// Create a copy of MonumentSearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentSearchResponseDtoCopyWith<MonumentSearchResponseDto> get copyWith => _$MonumentSearchResponseDtoCopyWithImpl<MonumentSearchResponseDto>(this as MonumentSearchResponseDto, _$identity);

  /// Serializes this MonumentSearchResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonumentSearchResponseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentSearchResponseDto&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&const DeepCollectionEquality().equals(other.places, _this.places)&&(identical(other.facets, _this.facets) || other.facets == _this.facets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonumentSearchResponseDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.total,_this.nextCursor,const DeepCollectionEquality().hash(_this.places),_this.facets);
}

@override
String toString() {
  final _this = this as MonumentSearchResponseDto;
  return 'MonumentSearchResponseDto(items: ${_this.items}, total: ${_this.total}, nextCursor: ${_this.nextCursor}, places: ${_this.places}, facets: ${_this.facets})';
}


}

/// @nodoc
abstract mixin class $MonumentSearchResponseDtoCopyWith<$Res>  {
  factory $MonumentSearchResponseDtoCopyWith(MonumentSearchResponseDto value, $Res Function(MonumentSearchResponseDto) _then) = _$MonumentSearchResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<MonumentSummaryDto> items, int total, String? nextCursor, List<MonumentPlaceDto> places, MonumentFacetsDto? facets
});


$MonumentFacetsDtoCopyWith<$Res>? get facets;

}
/// @nodoc
class _$MonumentSearchResponseDtoCopyWithImpl<$Res>
    implements $MonumentSearchResponseDtoCopyWith<$Res> {
  _$MonumentSearchResponseDtoCopyWithImpl(this._self, this._then);

  final MonumentSearchResponseDto _self;
  final $Res Function(MonumentSearchResponseDto) _then;

/// Create a copy of MonumentSearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? places = null,Object? facets = freezed,}) {
  return _then(MonumentSearchResponseDto(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MonumentSummaryDto>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,places: null == places ? _self.places : places // ignore: cast_nullable_to_non_nullable
as List<MonumentPlaceDto>,facets: freezed == facets ? _self.facets : facets // ignore: cast_nullable_to_non_nullable
as MonumentFacetsDto?,
  ));
}
/// Create a copy of MonumentSearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonumentFacetsDtoCopyWith<$Res>? get facets {
    if (_self.facets == null) {
    return null;
  }

  return $MonumentFacetsDtoCopyWith<$Res>(_self.facets!, (value) {
    return _then(_self.copyWith(facets: value));
  });
}
}


/// Adds pattern-matching-related methods to [MonumentSearchResponseDto].
extension MonumentSearchResponseDtoPatterns on MonumentSearchResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonumentSearchResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonumentSearchResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonumentSearchResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _MonumentSearchResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonumentSearchResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _MonumentSearchResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MonumentSummaryDto> items,  int total,  String? nextCursor,  List<MonumentPlaceDto> places,  MonumentFacetsDto? facets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonumentSearchResponseDto() when $default != null:
return $default(_that.items,_that.total,_that.nextCursor,_that.places,_that.facets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MonumentSummaryDto> items,  int total,  String? nextCursor,  List<MonumentPlaceDto> places,  MonumentFacetsDto? facets)  $default,) {final _that = this;
switch (_that) {
case _MonumentSearchResponseDto():
return $default(_that.items,_that.total,_that.nextCursor,_that.places,_that.facets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MonumentSummaryDto> items,  int total,  String? nextCursor,  List<MonumentPlaceDto> places,  MonumentFacetsDto? facets)?  $default,) {final _that = this;
switch (_that) {
case _MonumentSearchResponseDto() when $default != null:
return $default(_that.items,_that.total,_that.nextCursor,_that.places,_that.facets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonumentSearchResponseDto extends MonumentSearchResponseDto {
  const _MonumentSearchResponseDto({required  List<MonumentSummaryDto> items, required this.total, this.nextCursor,  List<MonumentPlaceDto> places = const <MonumentPlaceDto>[], this.facets}): _items = items,_places = places,super._();
  factory _MonumentSearchResponseDto.fromJson(Map<String, dynamic> json) => _$MonumentSearchResponseDtoFromJson(json);

 final  List<MonumentSummaryDto> _items;
@override List<MonumentSummaryDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int total;
@override final  String? nextCursor;
 final  List<MonumentPlaceDto> _places;
@override@JsonKey() List<MonumentPlaceDto> get places {
  if (_places is EqualUnmodifiableListView) return _places;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_places);
}

@override final  MonumentFacetsDto? facets;

/// Create a copy of MonumentSearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonumentSearchResponseDtoCopyWith<_MonumentSearchResponseDto> get copyWith => __$MonumentSearchResponseDtoCopyWithImpl<_MonumentSearchResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonumentSearchResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonumentSearchResponseDto&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&const DeepCollectionEquality().equals(other.places, _places)&&(identical(other.facets, facets) || other.facets == facets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,nextCursor,const DeepCollectionEquality().hash(_places),facets);
}

@override
String toString() {
    return 'MonumentSearchResponseDto(items: $items, total: $total, nextCursor: $nextCursor, places: $places, facets: $facets)';
}


}

/// @nodoc
abstract mixin class _$MonumentSearchResponseDtoCopyWith<$Res> implements $MonumentSearchResponseDtoCopyWith<$Res> {
  factory _$MonumentSearchResponseDtoCopyWith(_MonumentSearchResponseDto value, $Res Function(_MonumentSearchResponseDto) _then) = __$MonumentSearchResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<MonumentSummaryDto> items, int total, String? nextCursor, List<MonumentPlaceDto> places, MonumentFacetsDto? facets
});


@override $MonumentFacetsDtoCopyWith<$Res>? get facets;

}
/// @nodoc
class __$MonumentSearchResponseDtoCopyWithImpl<$Res>
    implements _$MonumentSearchResponseDtoCopyWith<$Res> {
  __$MonumentSearchResponseDtoCopyWithImpl(this._self, this._then);

  final _MonumentSearchResponseDto _self;
  final $Res Function(_MonumentSearchResponseDto) _then;

/// Create a copy of MonumentSearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? places = null,Object? facets = freezed,}) {
  return _then(_MonumentSearchResponseDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MonumentSummaryDto>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,places: null == places ? _self._places : places // ignore: cast_nullable_to_non_nullable
as List<MonumentPlaceDto>,facets: freezed == facets ? _self.facets : facets // ignore: cast_nullable_to_non_nullable
as MonumentFacetsDto?,
  ));
}

/// Create a copy of MonumentSearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonumentFacetsDtoCopyWith<$Res>? get facets {
    if (_self.facets == null) {
    return null;
  }

  return $MonumentFacetsDtoCopyWith<$Res>(_self.facets!, (value) {
    return _then(_self.copyWith(facets: value));
  });
}
}


/// @nodoc
mixin _$MonumentPlaceDto {

 CityRefDto get city; int get count; String? get district; List<double>? get bounds;
/// Create a copy of MonumentPlaceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentPlaceDtoCopyWith<MonumentPlaceDto> get copyWith => _$MonumentPlaceDtoCopyWithImpl<MonumentPlaceDto>(this as MonumentPlaceDto, _$identity);

  /// Serializes this MonumentPlaceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonumentPlaceDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentPlaceDto&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.district, _this.district) || other.district == _this.district)&&const DeepCollectionEquality().equals(other.bounds, _this.bounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonumentPlaceDto;
  return Object.hash(runtimeType,_this.city,_this.count,_this.district,const DeepCollectionEquality().hash(_this.bounds));
}

@override
String toString() {
  final _this = this as MonumentPlaceDto;
  return 'MonumentPlaceDto(city: ${_this.city}, count: ${_this.count}, district: ${_this.district}, bounds: ${_this.bounds})';
}


}

/// @nodoc
abstract mixin class $MonumentPlaceDtoCopyWith<$Res>  {
  factory $MonumentPlaceDtoCopyWith(MonumentPlaceDto value, $Res Function(MonumentPlaceDto) _then) = _$MonumentPlaceDtoCopyWithImpl;
@useResult
$Res call({
 CityRefDto city, int count, String? district, List<double>? bounds
});


$CityRefDtoCopyWith<$Res> get city;

}
/// @nodoc
class _$MonumentPlaceDtoCopyWithImpl<$Res>
    implements $MonumentPlaceDtoCopyWith<$Res> {
  _$MonumentPlaceDtoCopyWithImpl(this._self, this._then);

  final MonumentPlaceDto _self;
  final $Res Function(MonumentPlaceDto) _then;

/// Create a copy of MonumentPlaceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? city = null,Object? count = null,Object? district = freezed,Object? bounds = freezed,}) {
  return _then(MonumentPlaceDto(
city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityRefDto,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,bounds: freezed == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as List<double>?,
  ));
}
/// Create a copy of MonumentPlaceDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityRefDtoCopyWith<$Res> get city {
  
  return $CityRefDtoCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}


/// Adds pattern-matching-related methods to [MonumentPlaceDto].
extension MonumentPlaceDtoPatterns on MonumentPlaceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonumentPlaceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonumentPlaceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonumentPlaceDto value)  $default,){
final _that = this;
switch (_that) {
case _MonumentPlaceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonumentPlaceDto value)?  $default,){
final _that = this;
switch (_that) {
case _MonumentPlaceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CityRefDto city,  int count,  String? district,  List<double>? bounds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonumentPlaceDto() when $default != null:
return $default(_that.city,_that.count,_that.district,_that.bounds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CityRefDto city,  int count,  String? district,  List<double>? bounds)  $default,) {final _that = this;
switch (_that) {
case _MonumentPlaceDto():
return $default(_that.city,_that.count,_that.district,_that.bounds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CityRefDto city,  int count,  String? district,  List<double>? bounds)?  $default,) {final _that = this;
switch (_that) {
case _MonumentPlaceDto() when $default != null:
return $default(_that.city,_that.count,_that.district,_that.bounds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonumentPlaceDto extends MonumentPlaceDto {
  const _MonumentPlaceDto({required this.city, required this.count, this.district,  List<double>? bounds}): _bounds = bounds,super._();
  factory _MonumentPlaceDto.fromJson(Map<String, dynamic> json) => _$MonumentPlaceDtoFromJson(json);

@override final  CityRefDto city;
@override final  int count;
@override final  String? district;
 final  List<double>? _bounds;
@override List<double>? get bounds {
  final value = _bounds;
  if (value == null) return null;
  if (_bounds is EqualUnmodifiableListView) return _bounds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of MonumentPlaceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonumentPlaceDtoCopyWith<_MonumentPlaceDto> get copyWith => __$MonumentPlaceDtoCopyWithImpl<_MonumentPlaceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonumentPlaceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonumentPlaceDto&&(identical(other.city, city) || other.city == city)&&(identical(other.count, count) || other.count == count)&&(identical(other.district, district) || other.district == district)&&const DeepCollectionEquality().equals(other.bounds, _bounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,city,count,district,const DeepCollectionEquality().hash(_bounds));
}

@override
String toString() {
    return 'MonumentPlaceDto(city: $city, count: $count, district: $district, bounds: $bounds)';
}


}

/// @nodoc
abstract mixin class _$MonumentPlaceDtoCopyWith<$Res> implements $MonumentPlaceDtoCopyWith<$Res> {
  factory _$MonumentPlaceDtoCopyWith(_MonumentPlaceDto value, $Res Function(_MonumentPlaceDto) _then) = __$MonumentPlaceDtoCopyWithImpl;
@override @useResult
$Res call({
 CityRefDto city, int count, String? district, List<double>? bounds
});


@override $CityRefDtoCopyWith<$Res> get city;

}
/// @nodoc
class __$MonumentPlaceDtoCopyWithImpl<$Res>
    implements _$MonumentPlaceDtoCopyWith<$Res> {
  __$MonumentPlaceDtoCopyWithImpl(this._self, this._then);

  final _MonumentPlaceDto _self;
  final $Res Function(_MonumentPlaceDto) _then;

/// Create a copy of MonumentPlaceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? city = null,Object? count = null,Object? district = freezed,Object? bounds = freezed,}) {
  return _then(_MonumentPlaceDto(
city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityRefDto,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,bounds: freezed == bounds ? _self._bounds : bounds // ignore: cast_nullable_to_non_nullable
as List<double>?,
  ));
}

/// Create a copy of MonumentPlaceDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityRefDtoCopyWith<$Res> get city {
  
  return $CityRefDtoCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}
}


/// @nodoc
mixin _$CityFacetDto {

 int get code; String get name; int get count;
/// Create a copy of CityFacetDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CityFacetDtoCopyWith<CityFacetDto> get copyWith => _$CityFacetDtoCopyWithImpl<CityFacetDto>(this as CityFacetDto, _$identity);

  /// Serializes this CityFacetDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CityFacetDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CityFacetDto&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CityFacetDto;
  return Object.hash(runtimeType,_this.code,_this.name,_this.count);
}

@override
String toString() {
  final _this = this as CityFacetDto;
  return 'CityFacetDto(code: ${_this.code}, name: ${_this.name}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $CityFacetDtoCopyWith<$Res>  {
  factory $CityFacetDtoCopyWith(CityFacetDto value, $Res Function(CityFacetDto) _then) = _$CityFacetDtoCopyWithImpl;
@useResult
$Res call({
 int code, String name, int count
});




}
/// @nodoc
class _$CityFacetDtoCopyWithImpl<$Res>
    implements $CityFacetDtoCopyWith<$Res> {
  _$CityFacetDtoCopyWithImpl(this._self, this._then);

  final CityFacetDto _self;
  final $Res Function(CityFacetDto) _then;

/// Create a copy of CityFacetDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? count = null,}) {
  return _then(CityFacetDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CityFacetDto].
extension CityFacetDtoPatterns on CityFacetDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CityFacetDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CityFacetDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CityFacetDto value)  $default,){
final _that = this;
switch (_that) {
case _CityFacetDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CityFacetDto value)?  $default,){
final _that = this;
switch (_that) {
case _CityFacetDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int code,  String name,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CityFacetDto() when $default != null:
return $default(_that.code,_that.name,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int code,  String name,  int count)  $default,) {final _that = this;
switch (_that) {
case _CityFacetDto():
return $default(_that.code,_that.name,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int code,  String name,  int count)?  $default,) {final _that = this;
switch (_that) {
case _CityFacetDto() when $default != null:
return $default(_that.code,_that.name,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CityFacetDto implements CityFacetDto {
  const _CityFacetDto({required this.code, required this.name, required this.count});
  factory _CityFacetDto.fromJson(Map<String, dynamic> json) => _$CityFacetDtoFromJson(json);

@override final  int code;
@override final  String name;
@override final  int count;

/// Create a copy of CityFacetDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CityFacetDtoCopyWith<_CityFacetDto> get copyWith => __$CityFacetDtoCopyWithImpl<_CityFacetDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CityFacetDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CityFacetDto&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,name,count);
}

@override
String toString() {
    return 'CityFacetDto(code: $code, name: $name, count: $count)';
}


}

/// @nodoc
abstract mixin class _$CityFacetDtoCopyWith<$Res> implements $CityFacetDtoCopyWith<$Res> {
  factory _$CityFacetDtoCopyWith(_CityFacetDto value, $Res Function(_CityFacetDto) _then) = __$CityFacetDtoCopyWithImpl;
@override @useResult
$Res call({
 int code, String name, int count
});




}
/// @nodoc
class __$CityFacetDtoCopyWithImpl<$Res>
    implements _$CityFacetDtoCopyWith<$Res> {
  __$CityFacetDtoCopyWithImpl(this._self, this._then);

  final _CityFacetDto _self;
  final $Res Function(_CityFacetDto) _then;

/// Create a copy of CityFacetDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? count = null,}) {
  return _then(_CityFacetDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MonumentFacetsDto {

 Map<String, int> get category; Map<String, int> get period; List<CityFacetDto> get city;
/// Create a copy of MonumentFacetsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentFacetsDtoCopyWith<MonumentFacetsDto> get copyWith => _$MonumentFacetsDtoCopyWithImpl<MonumentFacetsDto>(this as MonumentFacetsDto, _$identity);

  /// Serializes this MonumentFacetsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonumentFacetsDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentFacetsDto&&const DeepCollectionEquality().equals(other.category, _this.category)&&const DeepCollectionEquality().equals(other.period, _this.period)&&const DeepCollectionEquality().equals(other.city, _this.city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonumentFacetsDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.category),const DeepCollectionEquality().hash(_this.period),const DeepCollectionEquality().hash(_this.city));
}

@override
String toString() {
  final _this = this as MonumentFacetsDto;
  return 'MonumentFacetsDto(category: ${_this.category}, period: ${_this.period}, city: ${_this.city})';
}


}

/// @nodoc
abstract mixin class $MonumentFacetsDtoCopyWith<$Res>  {
  factory $MonumentFacetsDtoCopyWith(MonumentFacetsDto value, $Res Function(MonumentFacetsDto) _then) = _$MonumentFacetsDtoCopyWithImpl;
@useResult
$Res call({
 Map<String, int> category, Map<String, int> period, List<CityFacetDto> city
});




}
/// @nodoc
class _$MonumentFacetsDtoCopyWithImpl<$Res>
    implements $MonumentFacetsDtoCopyWith<$Res> {
  _$MonumentFacetsDtoCopyWithImpl(this._self, this._then);

  final MonumentFacetsDto _self;
  final $Res Function(MonumentFacetsDto) _then;

/// Create a copy of MonumentFacetsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? period = null,Object? city = null,}) {
  return _then(MonumentFacetsDto(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Map<String, int>,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as Map<String, int>,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as List<CityFacetDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonumentFacetsDto].
extension MonumentFacetsDtoPatterns on MonumentFacetsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonumentFacetsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonumentFacetsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonumentFacetsDto value)  $default,){
final _that = this;
switch (_that) {
case _MonumentFacetsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonumentFacetsDto value)?  $default,){
final _that = this;
switch (_that) {
case _MonumentFacetsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, int> category,  Map<String, int> period,  List<CityFacetDto> city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonumentFacetsDto() when $default != null:
return $default(_that.category,_that.period,_that.city);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, int> category,  Map<String, int> period,  List<CityFacetDto> city)  $default,) {final _that = this;
switch (_that) {
case _MonumentFacetsDto():
return $default(_that.category,_that.period,_that.city);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, int> category,  Map<String, int> period,  List<CityFacetDto> city)?  $default,) {final _that = this;
switch (_that) {
case _MonumentFacetsDto() when $default != null:
return $default(_that.category,_that.period,_that.city);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonumentFacetsDto extends MonumentFacetsDto {
  const _MonumentFacetsDto({ Map<String, int> category = const <String, int>{},  Map<String, int> period = const <String, int>{},  List<CityFacetDto> city = const <CityFacetDto>[]}): _category = category,_period = period,_city = city,super._();
  factory _MonumentFacetsDto.fromJson(Map<String, dynamic> json) => _$MonumentFacetsDtoFromJson(json);

 final  Map<String, int> _category;
@override@JsonKey() Map<String, int> get category {
  if (_category is EqualUnmodifiableMapView) return _category;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_category);
}

 final  Map<String, int> _period;
@override@JsonKey() Map<String, int> get period {
  if (_period is EqualUnmodifiableMapView) return _period;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_period);
}

 final  List<CityFacetDto> _city;
@override@JsonKey() List<CityFacetDto> get city {
  if (_city is EqualUnmodifiableListView) return _city;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_city);
}


/// Create a copy of MonumentFacetsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonumentFacetsDtoCopyWith<_MonumentFacetsDto> get copyWith => __$MonumentFacetsDtoCopyWithImpl<_MonumentFacetsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonumentFacetsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonumentFacetsDto&&const DeepCollectionEquality().equals(other.category, _category)&&const DeepCollectionEquality().equals(other.period, _period)&&const DeepCollectionEquality().equals(other.city, _city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_category),const DeepCollectionEquality().hash(_period),const DeepCollectionEquality().hash(_city));
}

@override
String toString() {
    return 'MonumentFacetsDto(category: $category, period: $period, city: $city)';
}


}

/// @nodoc
abstract mixin class _$MonumentFacetsDtoCopyWith<$Res> implements $MonumentFacetsDtoCopyWith<$Res> {
  factory _$MonumentFacetsDtoCopyWith(_MonumentFacetsDto value, $Res Function(_MonumentFacetsDto) _then) = __$MonumentFacetsDtoCopyWithImpl;
@override @useResult
$Res call({
 Map<String, int> category, Map<String, int> period, List<CityFacetDto> city
});




}
/// @nodoc
class __$MonumentFacetsDtoCopyWithImpl<$Res>
    implements _$MonumentFacetsDtoCopyWith<$Res> {
  __$MonumentFacetsDtoCopyWithImpl(this._self, this._then);

  final _MonumentFacetsDto _self;
  final $Res Function(_MonumentFacetsDto) _then;

/// Create a copy of MonumentFacetsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? period = null,Object? city = null,}) {
  return _then(_MonumentFacetsDto(
category: null == category ? _self._category : category // ignore: cast_nullable_to_non_nullable
as Map<String, int>,period: null == period ? _self._period : period // ignore: cast_nullable_to_non_nullable
as Map<String, int>,city: null == city ? _self._city : city // ignore: cast_nullable_to_non_nullable
as List<CityFacetDto>,
  ));
}


}


/// @nodoc
mixin _$MonumentPinDto {

 String get key; String get title;@JsonKey(unknownEnumValue: MonumentCategory.other) MonumentCategory get category; CityRefDto get city; String? get slug; String? get district; GeoPointDto? get location; ComplexRefDto? get complex;
/// Create a copy of MonumentPinDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentPinDtoCopyWith<MonumentPinDto> get copyWith => _$MonumentPinDtoCopyWithImpl<MonumentPinDto>(this as MonumentPinDto, _$identity);

  /// Serializes this MonumentPinDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonumentPinDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentPinDto&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.district, _this.district) || other.district == _this.district)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.complex, _this.complex) || other.complex == _this.complex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonumentPinDto;
  return Object.hash(runtimeType,_this.key,_this.title,_this.category,_this.city,_this.slug,_this.district,_this.location,_this.complex);
}

@override
String toString() {
  final _this = this as MonumentPinDto;
  return 'MonumentPinDto(key: ${_this.key}, title: ${_this.title}, category: ${_this.category}, city: ${_this.city}, slug: ${_this.slug}, district: ${_this.district}, location: ${_this.location}, complex: ${_this.complex})';
}


}

/// @nodoc
abstract mixin class $MonumentPinDtoCopyWith<$Res>  {
  factory $MonumentPinDtoCopyWith(MonumentPinDto value, $Res Function(MonumentPinDto) _then) = _$MonumentPinDtoCopyWithImpl;
@useResult
$Res call({
 String key, String title,@JsonKey(unknownEnumValue: MonumentCategory.other) MonumentCategory category, CityRefDto city, String? slug, String? district, GeoPointDto? location, ComplexRefDto? complex
});


$CityRefDtoCopyWith<$Res> get city;$GeoPointDtoCopyWith<$Res>? get location;$ComplexRefDtoCopyWith<$Res>? get complex;

}
/// @nodoc
class _$MonumentPinDtoCopyWithImpl<$Res>
    implements $MonumentPinDtoCopyWith<$Res> {
  _$MonumentPinDtoCopyWithImpl(this._self, this._then);

  final MonumentPinDto _self;
  final $Res Function(MonumentPinDto) _then;

/// Create a copy of MonumentPinDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? title = null,Object? category = null,Object? city = null,Object? slug = freezed,Object? district = freezed,Object? location = freezed,Object? complex = freezed,}) {
  return _then(MonumentPinDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MonumentCategory,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityRefDto,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPointDto?,complex: freezed == complex ? _self.complex : complex // ignore: cast_nullable_to_non_nullable
as ComplexRefDto?,
  ));
}
/// Create a copy of MonumentPinDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityRefDtoCopyWith<$Res> get city {
  
  return $CityRefDtoCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}/// Create a copy of MonumentPinDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointDtoCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $GeoPointDtoCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of MonumentPinDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplexRefDtoCopyWith<$Res>? get complex {
    if (_self.complex == null) {
    return null;
  }

  return $ComplexRefDtoCopyWith<$Res>(_self.complex!, (value) {
    return _then(_self.copyWith(complex: value));
  });
}
}


/// Adds pattern-matching-related methods to [MonumentPinDto].
extension MonumentPinDtoPatterns on MonumentPinDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonumentPinDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonumentPinDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonumentPinDto value)  $default,){
final _that = this;
switch (_that) {
case _MonumentPinDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonumentPinDto value)?  $default,){
final _that = this;
switch (_that) {
case _MonumentPinDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String title, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category,  CityRefDto city,  String? slug,  String? district,  GeoPointDto? location,  ComplexRefDto? complex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonumentPinDto() when $default != null:
return $default(_that.key,_that.title,_that.category,_that.city,_that.slug,_that.district,_that.location,_that.complex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String title, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category,  CityRefDto city,  String? slug,  String? district,  GeoPointDto? location,  ComplexRefDto? complex)  $default,) {final _that = this;
switch (_that) {
case _MonumentPinDto():
return $default(_that.key,_that.title,_that.category,_that.city,_that.slug,_that.district,_that.location,_that.complex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String title, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category,  CityRefDto city,  String? slug,  String? district,  GeoPointDto? location,  ComplexRefDto? complex)?  $default,) {final _that = this;
switch (_that) {
case _MonumentPinDto() when $default != null:
return $default(_that.key,_that.title,_that.category,_that.city,_that.slug,_that.district,_that.location,_that.complex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonumentPinDto extends MonumentPinDto {
  const _MonumentPinDto({required this.key, required this.title, @JsonKey(unknownEnumValue: MonumentCategory.other) required this.category, required this.city, this.slug, this.district, this.location, this.complex}): super._();
  factory _MonumentPinDto.fromJson(Map<String, dynamic> json) => _$MonumentPinDtoFromJson(json);

@override final  String key;
@override final  String title;
@override@JsonKey(unknownEnumValue: MonumentCategory.other) final  MonumentCategory category;
@override final  CityRefDto city;
@override final  String? slug;
@override final  String? district;
@override final  GeoPointDto? location;
@override final  ComplexRefDto? complex;

/// Create a copy of MonumentPinDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonumentPinDtoCopyWith<_MonumentPinDto> get copyWith => __$MonumentPinDtoCopyWithImpl<_MonumentPinDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonumentPinDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonumentPinDto&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.city, city) || other.city == city)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.district, district) || other.district == district)&&(identical(other.location, location) || other.location == location)&&(identical(other.complex, complex) || other.complex == complex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,title,category,city,slug,district,location,complex);
}

@override
String toString() {
    return 'MonumentPinDto(key: $key, title: $title, category: $category, city: $city, slug: $slug, district: $district, location: $location, complex: $complex)';
}


}

/// @nodoc
abstract mixin class _$MonumentPinDtoCopyWith<$Res> implements $MonumentPinDtoCopyWith<$Res> {
  factory _$MonumentPinDtoCopyWith(_MonumentPinDto value, $Res Function(_MonumentPinDto) _then) = __$MonumentPinDtoCopyWithImpl;
@override @useResult
$Res call({
 String key, String title,@JsonKey(unknownEnumValue: MonumentCategory.other) MonumentCategory category, CityRefDto city, String? slug, String? district, GeoPointDto? location, ComplexRefDto? complex
});


@override $CityRefDtoCopyWith<$Res> get city;@override $GeoPointDtoCopyWith<$Res>? get location;@override $ComplexRefDtoCopyWith<$Res>? get complex;

}
/// @nodoc
class __$MonumentPinDtoCopyWithImpl<$Res>
    implements _$MonumentPinDtoCopyWith<$Res> {
  __$MonumentPinDtoCopyWithImpl(this._self, this._then);

  final _MonumentPinDto _self;
  final $Res Function(_MonumentPinDto) _then;

/// Create a copy of MonumentPinDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? title = null,Object? category = null,Object? city = null,Object? slug = freezed,Object? district = freezed,Object? location = freezed,Object? complex = freezed,}) {
  return _then(_MonumentPinDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MonumentCategory,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityRefDto,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPointDto?,complex: freezed == complex ? _self.complex : complex // ignore: cast_nullable_to_non_nullable
as ComplexRefDto?,
  ));
}

/// Create a copy of MonumentPinDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityRefDtoCopyWith<$Res> get city {
  
  return $CityRefDtoCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}/// Create a copy of MonumentPinDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointDtoCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $GeoPointDtoCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}/// Create a copy of MonumentPinDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplexRefDtoCopyWith<$Res>? get complex {
    if (_self.complex == null) {
    return null;
  }

  return $ComplexRefDtoCopyWith<$Res>(_self.complex!, (value) {
    return _then(_self.copyWith(complex: value));
  });
}
}


/// @nodoc
mixin _$MonumentPinPageDto {

 List<MonumentPinDto> get items; int get total; String? get nextCursor;
/// Create a copy of MonumentPinPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentPinPageDtoCopyWith<MonumentPinPageDto> get copyWith => _$MonumentPinPageDtoCopyWithImpl<MonumentPinPageDto>(this as MonumentPinPageDto, _$identity);

  /// Serializes this MonumentPinPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonumentPinPageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentPinPageDto&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonumentPinPageDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.total,_this.nextCursor);
}

@override
String toString() {
  final _this = this as MonumentPinPageDto;
  return 'MonumentPinPageDto(items: ${_this.items}, total: ${_this.total}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $MonumentPinPageDtoCopyWith<$Res>  {
  factory $MonumentPinPageDtoCopyWith(MonumentPinPageDto value, $Res Function(MonumentPinPageDto) _then) = _$MonumentPinPageDtoCopyWithImpl;
@useResult
$Res call({
 List<MonumentPinDto> items, int total, String? nextCursor
});




}
/// @nodoc
class _$MonumentPinPageDtoCopyWithImpl<$Res>
    implements $MonumentPinPageDtoCopyWith<$Res> {
  _$MonumentPinPageDtoCopyWithImpl(this._self, this._then);

  final MonumentPinPageDto _self;
  final $Res Function(MonumentPinPageDto) _then;

/// Create a copy of MonumentPinPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? nextCursor = freezed,}) {
  return _then(MonumentPinPageDto(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MonumentPinDto>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonumentPinPageDto].
extension MonumentPinPageDtoPatterns on MonumentPinPageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonumentPinPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonumentPinPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonumentPinPageDto value)  $default,){
final _that = this;
switch (_that) {
case _MonumentPinPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonumentPinPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _MonumentPinPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MonumentPinDto> items,  int total,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonumentPinPageDto() when $default != null:
return $default(_that.items,_that.total,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MonumentPinDto> items,  int total,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _MonumentPinPageDto():
return $default(_that.items,_that.total,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MonumentPinDto> items,  int total,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _MonumentPinPageDto() when $default != null:
return $default(_that.items,_that.total,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonumentPinPageDto implements MonumentPinPageDto {
  const _MonumentPinPageDto({required  List<MonumentPinDto> items, this.total = 0, this.nextCursor}): _items = items;
  factory _MonumentPinPageDto.fromJson(Map<String, dynamic> json) => _$MonumentPinPageDtoFromJson(json);

 final  List<MonumentPinDto> _items;
@override List<MonumentPinDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int total;
@override final  String? nextCursor;

/// Create a copy of MonumentPinPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonumentPinPageDtoCopyWith<_MonumentPinPageDto> get copyWith => __$MonumentPinPageDtoCopyWithImpl<_MonumentPinPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonumentPinPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonumentPinPageDto&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,nextCursor);
}

@override
String toString() {
    return 'MonumentPinPageDto(items: $items, total: $total, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$MonumentPinPageDtoCopyWith<$Res> implements $MonumentPinPageDtoCopyWith<$Res> {
  factory _$MonumentPinPageDtoCopyWith(_MonumentPinPageDto value, $Res Function(_MonumentPinPageDto) _then) = __$MonumentPinPageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<MonumentPinDto> items, int total, String? nextCursor
});




}
/// @nodoc
class __$MonumentPinPageDtoCopyWithImpl<$Res>
    implements _$MonumentPinPageDtoCopyWith<$Res> {
  __$MonumentPinPageDtoCopyWithImpl(this._self, this._then);

  final _MonumentPinPageDto _self;
  final $Res Function(_MonumentPinPageDto) _then;

/// Create a copy of MonumentPinPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? nextCursor = freezed,}) {
  return _then(_MonumentPinPageDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MonumentPinDto>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
