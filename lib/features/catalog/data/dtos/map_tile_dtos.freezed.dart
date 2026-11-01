// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_tile_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
MapTileItemDto _$MapTileItemDtoFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'cluster':
          return MapTileClusterDto.fromJson(
            json
          );
                case 'work':
          return MapTileMonumentDto.fromJson(
            json
          );
                case 'complex':
          return MapTileComplexDto.fromJson(
            json
          );
        
          default:
            return MapTileUnknownDto.fromJson(
  json
);
        }
      
}

/// @nodoc
mixin _$MapTileItemDto {



  /// Serializes this MapTileItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapTileItemDto);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MapTileItemDto()';
}


}

/// @nodoc
class $MapTileItemDtoCopyWith<$Res>  {
$MapTileItemDtoCopyWith(MapTileItemDto _, $Res Function(MapTileItemDto) __);
}


/// Adds pattern-matching-related methods to [MapTileItemDto].
extension MapTileItemDtoPatterns on MapTileItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MapTileClusterDto value)?  cluster,TResult Function( MapTileMonumentDto value)?  monument,TResult Function( MapTileComplexDto value)?  complex,TResult Function( MapTileUnknownDto value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MapTileClusterDto() when cluster != null:
return cluster(_that);case MapTileMonumentDto() when monument != null:
return monument(_that);case MapTileComplexDto() when complex != null:
return complex(_that);case MapTileUnknownDto() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MapTileClusterDto value)  cluster,required TResult Function( MapTileMonumentDto value)  monument,required TResult Function( MapTileComplexDto value)  complex,required TResult Function( MapTileUnknownDto value)  unknown,}){
final _that = this;
switch (_that) {
case MapTileClusterDto():
return cluster(_that);case MapTileMonumentDto():
return monument(_that);case MapTileComplexDto():
return complex(_that);case MapTileUnknownDto():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MapTileClusterDto value)?  cluster,TResult? Function( MapTileMonumentDto value)?  monument,TResult? Function( MapTileComplexDto value)?  complex,TResult? Function( MapTileUnknownDto value)?  unknown,}){
final _that = this;
switch (_that) {
case MapTileClusterDto() when cluster != null:
return cluster(_that);case MapTileMonumentDto() when monument != null:
return monument(_that);case MapTileComplexDto() when complex != null:
return complex(_that);case MapTileUnknownDto() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String key,  int count,  double lat,  double lng,  List<double> bounds)?  cluster,TResult Function( String key,  String title, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category,  CityRefDto city,  double lat,  double lng,  String? slug,  String? district,  ComplexRefDto? complex)?  monument,TResult Function( String key,  String name,  CityRefDto city,  double lat,  double lng,  int workCount,  String? district, @JsonKey(fromJson: footprintFromJson)  List<List<double>> footprint)?  complex,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MapTileClusterDto() when cluster != null:
return cluster(_that.key,_that.count,_that.lat,_that.lng,_that.bounds);case MapTileMonumentDto() when monument != null:
return monument(_that.key,_that.title,_that.category,_that.city,_that.lat,_that.lng,_that.slug,_that.district,_that.complex);case MapTileComplexDto() when complex != null:
return complex(_that.key,_that.name,_that.city,_that.lat,_that.lng,_that.workCount,_that.district,_that.footprint);case MapTileUnknownDto() when unknown != null:
return unknown();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String key,  int count,  double lat,  double lng,  List<double> bounds)  cluster,required TResult Function( String key,  String title, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category,  CityRefDto city,  double lat,  double lng,  String? slug,  String? district,  ComplexRefDto? complex)  monument,required TResult Function( String key,  String name,  CityRefDto city,  double lat,  double lng,  int workCount,  String? district, @JsonKey(fromJson: footprintFromJson)  List<List<double>> footprint)  complex,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case MapTileClusterDto():
return cluster(_that.key,_that.count,_that.lat,_that.lng,_that.bounds);case MapTileMonumentDto():
return monument(_that.key,_that.title,_that.category,_that.city,_that.lat,_that.lng,_that.slug,_that.district,_that.complex);case MapTileComplexDto():
return complex(_that.key,_that.name,_that.city,_that.lat,_that.lng,_that.workCount,_that.district,_that.footprint);case MapTileUnknownDto():
return unknown();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String key,  int count,  double lat,  double lng,  List<double> bounds)?  cluster,TResult? Function( String key,  String title, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category,  CityRefDto city,  double lat,  double lng,  String? slug,  String? district,  ComplexRefDto? complex)?  monument,TResult? Function( String key,  String name,  CityRefDto city,  double lat,  double lng,  int workCount,  String? district, @JsonKey(fromJson: footprintFromJson)  List<List<double>> footprint)?  complex,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case MapTileClusterDto() when cluster != null:
return cluster(_that.key,_that.count,_that.lat,_that.lng,_that.bounds);case MapTileMonumentDto() when monument != null:
return monument(_that.key,_that.title,_that.category,_that.city,_that.lat,_that.lng,_that.slug,_that.district,_that.complex);case MapTileComplexDto() when complex != null:
return complex(_that.key,_that.name,_that.city,_that.lat,_that.lng,_that.workCount,_that.district,_that.footprint);case MapTileUnknownDto() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class MapTileClusterDto extends MapTileItemDto {
  const MapTileClusterDto({required this.key, required this.count, required this.lat, required this.lng, required  List<double> bounds,  String? $type}): _bounds = bounds,$type = $type ?? 'cluster',super._();
  factory MapTileClusterDto.fromJson(Map<String, dynamic> json) => _$MapTileClusterDtoFromJson(json);

 final  String key;
 final  int count;
 final  double lat;
 final  double lng;
 final  List<double> _bounds;
 List<double> get bounds {
  if (_bounds is EqualUnmodifiableListView) return _bounds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bounds);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of MapTileItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapTileClusterDtoCopyWith<MapTileClusterDto> get copyWith => _$MapTileClusterDtoCopyWithImpl<MapTileClusterDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapTileClusterDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapTileClusterDto&&(identical(other.key, key) || other.key == key)&&(identical(other.count, count) || other.count == count)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&const DeepCollectionEquality().equals(other.bounds, _bounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,count,lat,lng,const DeepCollectionEquality().hash(_bounds));
}

@override
String toString() {
    return 'MapTileItemDto.cluster(key: $key, count: $count, lat: $lat, lng: $lng, bounds: $bounds)';
}


}

/// @nodoc
abstract mixin class $MapTileClusterDtoCopyWith<$Res> implements $MapTileItemDtoCopyWith<$Res> {
  factory $MapTileClusterDtoCopyWith(MapTileClusterDto value, $Res Function(MapTileClusterDto) _then) = _$MapTileClusterDtoCopyWithImpl;
@useResult
$Res call({
 String key, int count, double lat, double lng, List<double> bounds
});




}
/// @nodoc
class _$MapTileClusterDtoCopyWithImpl<$Res>
    implements $MapTileClusterDtoCopyWith<$Res> {
  _$MapTileClusterDtoCopyWithImpl(this._self, this._then);

  final MapTileClusterDto _self;
  final $Res Function(MapTileClusterDto) _then;

/// Create a copy of MapTileItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? key = null,Object? count = null,Object? lat = null,Object? lng = null,Object? bounds = null,}) {
  return _then(MapTileClusterDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,bounds: null == bounds ? _self._bounds : bounds // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MapTileMonumentDto extends MapTileItemDto {
  const MapTileMonumentDto({required this.key, required this.title, @JsonKey(unknownEnumValue: MonumentCategory.other) required this.category, required this.city, required this.lat, required this.lng, this.slug, this.district, this.complex,  String? $type}): $type = $type ?? 'work',super._();
  factory MapTileMonumentDto.fromJson(Map<String, dynamic> json) => _$MapTileMonumentDtoFromJson(json);

 final  String key;
 final  String title;
@JsonKey(unknownEnumValue: MonumentCategory.other) final  MonumentCategory category;
 final  CityRefDto city;
 final  double lat;
 final  double lng;
 final  String? slug;
 final  String? district;
 final  ComplexRefDto? complex;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of MapTileItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapTileMonumentDtoCopyWith<MapTileMonumentDto> get copyWith => _$MapTileMonumentDtoCopyWithImpl<MapTileMonumentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapTileMonumentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapTileMonumentDto&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.city, city) || other.city == city)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.district, district) || other.district == district)&&(identical(other.complex, complex) || other.complex == complex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,title,category,city,lat,lng,slug,district,complex);
}

@override
String toString() {
    return 'MapTileItemDto.monument(key: $key, title: $title, category: $category, city: $city, lat: $lat, lng: $lng, slug: $slug, district: $district, complex: $complex)';
}


}

/// @nodoc
abstract mixin class $MapTileMonumentDtoCopyWith<$Res> implements $MapTileItemDtoCopyWith<$Res> {
  factory $MapTileMonumentDtoCopyWith(MapTileMonumentDto value, $Res Function(MapTileMonumentDto) _then) = _$MapTileMonumentDtoCopyWithImpl;
@useResult
$Res call({
 String key, String title,@JsonKey(unknownEnumValue: MonumentCategory.other) MonumentCategory category, CityRefDto city, double lat, double lng, String? slug, String? district, ComplexRefDto? complex
});


$CityRefDtoCopyWith<$Res> get city;$ComplexRefDtoCopyWith<$Res>? get complex;

}
/// @nodoc
class _$MapTileMonumentDtoCopyWithImpl<$Res>
    implements $MapTileMonumentDtoCopyWith<$Res> {
  _$MapTileMonumentDtoCopyWithImpl(this._self, this._then);

  final MapTileMonumentDto _self;
  final $Res Function(MapTileMonumentDto) _then;

/// Create a copy of MapTileItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? key = null,Object? title = null,Object? category = null,Object? city = null,Object? lat = null,Object? lng = null,Object? slug = freezed,Object? district = freezed,Object? complex = freezed,}) {
  return _then(MapTileMonumentDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MonumentCategory,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityRefDto,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,complex: freezed == complex ? _self.complex : complex // ignore: cast_nullable_to_non_nullable
as ComplexRefDto?,
  ));
}

/// Create a copy of MapTileItemDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityRefDtoCopyWith<$Res> get city {
  
  return $CityRefDtoCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}/// Create a copy of MapTileItemDto
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
@JsonSerializable()

class MapTileComplexDto extends MapTileItemDto {
  const MapTileComplexDto({required this.key, required this.name, required this.city, required this.lat, required this.lng, required this.workCount, this.district, @JsonKey(fromJson: footprintFromJson)  List<List<double>> footprint = const <List<double>>[],  String? $type}): _footprint = footprint,$type = $type ?? 'complex',super._();
  factory MapTileComplexDto.fromJson(Map<String, dynamic> json) => _$MapTileComplexDtoFromJson(json);

 final  String key;
 final  String name;
 final  CityRefDto city;
 final  double lat;
 final  double lng;
 final  int workCount;
 final  String? district;
 final  List<List<double>> _footprint;
@JsonKey(fromJson: footprintFromJson) List<List<double>> get footprint {
  if (_footprint is EqualUnmodifiableListView) return _footprint;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_footprint);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of MapTileItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapTileComplexDtoCopyWith<MapTileComplexDto> get copyWith => _$MapTileComplexDtoCopyWithImpl<MapTileComplexDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapTileComplexDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapTileComplexDto&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.workCount, workCount) || other.workCount == workCount)&&(identical(other.district, district) || other.district == district)&&const DeepCollectionEquality().equals(other.footprint, _footprint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,name,city,lat,lng,workCount,district,const DeepCollectionEquality().hash(_footprint));
}

@override
String toString() {
    return 'MapTileItemDto.complex(key: $key, name: $name, city: $city, lat: $lat, lng: $lng, workCount: $workCount, district: $district, footprint: $footprint)';
}


}

/// @nodoc
abstract mixin class $MapTileComplexDtoCopyWith<$Res> implements $MapTileItemDtoCopyWith<$Res> {
  factory $MapTileComplexDtoCopyWith(MapTileComplexDto value, $Res Function(MapTileComplexDto) _then) = _$MapTileComplexDtoCopyWithImpl;
@useResult
$Res call({
 String key, String name, CityRefDto city, double lat, double lng, int workCount, String? district,@JsonKey(fromJson: footprintFromJson) List<List<double>> footprint
});


$CityRefDtoCopyWith<$Res> get city;

}
/// @nodoc
class _$MapTileComplexDtoCopyWithImpl<$Res>
    implements $MapTileComplexDtoCopyWith<$Res> {
  _$MapTileComplexDtoCopyWithImpl(this._self, this._then);

  final MapTileComplexDto _self;
  final $Res Function(MapTileComplexDto) _then;

/// Create a copy of MapTileItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? city = null,Object? lat = null,Object? lng = null,Object? workCount = null,Object? district = freezed,Object? footprint = null,}) {
  return _then(MapTileComplexDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityRefDto,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,workCount: null == workCount ? _self.workCount : workCount // ignore: cast_nullable_to_non_nullable
as int,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,footprint: null == footprint ? _self._footprint : footprint // ignore: cast_nullable_to_non_nullable
as List<List<double>>,
  ));
}

/// Create a copy of MapTileItemDto
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
@JsonSerializable()

class MapTileUnknownDto extends MapTileItemDto {
  const MapTileUnknownDto({ String? $type}): $type = $type ?? 'unknown',super._();
  factory MapTileUnknownDto.fromJson(Map<String, dynamic> json) => _$MapTileUnknownDtoFromJson(json);



@JsonKey(name: 'type')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$MapTileUnknownDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MapTileUnknownDto);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MapTileItemDto.unknown()';
}


}





/// @nodoc
mixin _$MapTileResponseDto {

 List<MapTileItemDto> get items;
/// Create a copy of MapTileResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapTileResponseDtoCopyWith<MapTileResponseDto> get copyWith => _$MapTileResponseDtoCopyWithImpl<MapTileResponseDto>(this as MapTileResponseDto, _$identity);

  /// Serializes this MapTileResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapTileResponseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapTileResponseDto&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapTileResponseDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as MapTileResponseDto;
  return 'MapTileResponseDto(items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $MapTileResponseDtoCopyWith<$Res>  {
  factory $MapTileResponseDtoCopyWith(MapTileResponseDto value, $Res Function(MapTileResponseDto) _then) = _$MapTileResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<MapTileItemDto> items
});




}
/// @nodoc
class _$MapTileResponseDtoCopyWithImpl<$Res>
    implements $MapTileResponseDtoCopyWith<$Res> {
  _$MapTileResponseDtoCopyWithImpl(this._self, this._then);

  final MapTileResponseDto _self;
  final $Res Function(MapTileResponseDto) _then;

/// Create a copy of MapTileResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(MapTileResponseDto(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MapTileItemDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [MapTileResponseDto].
extension MapTileResponseDtoPatterns on MapTileResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapTileResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapTileResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapTileResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _MapTileResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapTileResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _MapTileResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MapTileItemDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapTileResponseDto() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MapTileItemDto> items)  $default,) {final _that = this;
switch (_that) {
case _MapTileResponseDto():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MapTileItemDto> items)?  $default,) {final _that = this;
switch (_that) {
case _MapTileResponseDto() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapTileResponseDto implements MapTileResponseDto {
  const _MapTileResponseDto({required  List<MapTileItemDto> items}): _items = items;
  factory _MapTileResponseDto.fromJson(Map<String, dynamic> json) => _$MapTileResponseDtoFromJson(json);

 final  List<MapTileItemDto> _items;
@override List<MapTileItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of MapTileResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapTileResponseDtoCopyWith<_MapTileResponseDto> get copyWith => __$MapTileResponseDtoCopyWithImpl<_MapTileResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapTileResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapTileResponseDto&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'MapTileResponseDto(items: $items)';
}


}

/// @nodoc
abstract mixin class _$MapTileResponseDtoCopyWith<$Res> implements $MapTileResponseDtoCopyWith<$Res> {
  factory _$MapTileResponseDtoCopyWith(_MapTileResponseDto value, $Res Function(_MapTileResponseDto) _then) = __$MapTileResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<MapTileItemDto> items
});




}
/// @nodoc
class __$MapTileResponseDtoCopyWithImpl<$Res>
    implements _$MapTileResponseDtoCopyWith<$Res> {
  __$MapTileResponseDtoCopyWithImpl(this._self, this._then);

  final _MapTileResponseDto _self;
  final $Res Function(_MapTileResponseDto) _then;

/// Create a copy of MapTileResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_MapTileResponseDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MapTileItemDto>,
  ));
}


}


/// @nodoc
mixin _$MapExtentDto {

 int get total; String get version; List<double>? get bounds;
/// Create a copy of MapExtentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapExtentDtoCopyWith<MapExtentDto> get copyWith => _$MapExtentDtoCopyWithImpl<MapExtentDto>(this as MapExtentDto, _$identity);

  /// Serializes this MapExtentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MapExtentDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapExtentDto&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.version, _this.version) || other.version == _this.version)&&const DeepCollectionEquality().equals(other.bounds, _this.bounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MapExtentDto;
  return Object.hash(runtimeType,_this.total,_this.version,const DeepCollectionEquality().hash(_this.bounds));
}

@override
String toString() {
  final _this = this as MapExtentDto;
  return 'MapExtentDto(total: ${_this.total}, version: ${_this.version}, bounds: ${_this.bounds})';
}


}

/// @nodoc
abstract mixin class $MapExtentDtoCopyWith<$Res>  {
  factory $MapExtentDtoCopyWith(MapExtentDto value, $Res Function(MapExtentDto) _then) = _$MapExtentDtoCopyWithImpl;
@useResult
$Res call({
 int total, String version, List<double>? bounds
});




}
/// @nodoc
class _$MapExtentDtoCopyWithImpl<$Res>
    implements $MapExtentDtoCopyWith<$Res> {
  _$MapExtentDtoCopyWithImpl(this._self, this._then);

  final MapExtentDto _self;
  final $Res Function(MapExtentDto) _then;

/// Create a copy of MapExtentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? version = null,Object? bounds = freezed,}) {
  return _then(MapExtentDto(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,bounds: freezed == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as List<double>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapExtentDto].
extension MapExtentDtoPatterns on MapExtentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapExtentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapExtentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapExtentDto value)  $default,){
final _that = this;
switch (_that) {
case _MapExtentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapExtentDto value)?  $default,){
final _that = this;
switch (_that) {
case _MapExtentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  String version,  List<double>? bounds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapExtentDto() when $default != null:
return $default(_that.total,_that.version,_that.bounds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  String version,  List<double>? bounds)  $default,) {final _that = this;
switch (_that) {
case _MapExtentDto():
return $default(_that.total,_that.version,_that.bounds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  String version,  List<double>? bounds)?  $default,) {final _that = this;
switch (_that) {
case _MapExtentDto() when $default != null:
return $default(_that.total,_that.version,_that.bounds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapExtentDto extends MapExtentDto {
  const _MapExtentDto({required this.total, required this.version,  List<double>? bounds}): _bounds = bounds,super._();
  factory _MapExtentDto.fromJson(Map<String, dynamic> json) => _$MapExtentDtoFromJson(json);

@override final  int total;
@override final  String version;
 final  List<double>? _bounds;
@override List<double>? get bounds {
  final value = _bounds;
  if (value == null) return null;
  if (_bounds is EqualUnmodifiableListView) return _bounds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of MapExtentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapExtentDtoCopyWith<_MapExtentDto> get copyWith => __$MapExtentDtoCopyWithImpl<_MapExtentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapExtentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapExtentDto&&(identical(other.total, total) || other.total == total)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.bounds, _bounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,version,const DeepCollectionEquality().hash(_bounds));
}

@override
String toString() {
    return 'MapExtentDto(total: $total, version: $version, bounds: $bounds)';
}


}

/// @nodoc
abstract mixin class _$MapExtentDtoCopyWith<$Res> implements $MapExtentDtoCopyWith<$Res> {
  factory _$MapExtentDtoCopyWith(_MapExtentDto value, $Res Function(_MapExtentDto) _then) = __$MapExtentDtoCopyWithImpl;
@override @useResult
$Res call({
 int total, String version, List<double>? bounds
});




}
/// @nodoc
class __$MapExtentDtoCopyWithImpl<$Res>
    implements _$MapExtentDtoCopyWith<$Res> {
  __$MapExtentDtoCopyWithImpl(this._self, this._then);

  final _MapExtentDto _self;
  final $Res Function(_MapExtentDto) _then;

/// Create a copy of MapExtentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? version = null,Object? bounds = freezed,}) {
  return _then(_MapExtentDto(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,bounds: freezed == bounds ? _self._bounds : bounds // ignore: cast_nullable_to_non_nullable
as List<double>?,
  ));
}


}

// dart format on
