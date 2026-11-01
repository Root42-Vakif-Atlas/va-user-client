// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monument_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeoPointDto {

 double get latitude; double get longitude;
/// Create a copy of GeoPointDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoPointDtoCopyWith<GeoPointDto> get copyWith => _$GeoPointDtoCopyWithImpl<GeoPointDto>(this as GeoPointDto, _$identity);

  /// Serializes this GeoPointDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GeoPointDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoPointDto&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GeoPointDto;
  return Object.hash(runtimeType,_this.latitude,_this.longitude);
}

@override
String toString() {
  final _this = this as GeoPointDto;
  return 'GeoPointDto(latitude: ${_this.latitude}, longitude: ${_this.longitude})';
}


}

/// @nodoc
abstract mixin class $GeoPointDtoCopyWith<$Res>  {
  factory $GeoPointDtoCopyWith(GeoPointDto value, $Res Function(GeoPointDto) _then) = _$GeoPointDtoCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$GeoPointDtoCopyWithImpl<$Res>
    implements $GeoPointDtoCopyWith<$Res> {
  _$GeoPointDtoCopyWithImpl(this._self, this._then);

  final GeoPointDto _self;
  final $Res Function(GeoPointDto) _then;

/// Create a copy of GeoPointDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(GeoPointDto(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoPointDto].
extension GeoPointDtoPatterns on GeoPointDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoPointDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoPointDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoPointDto value)  $default,){
final _that = this;
switch (_that) {
case _GeoPointDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoPointDto value)?  $default,){
final _that = this;
switch (_that) {
case _GeoPointDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoPointDto() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _GeoPointDto():
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _GeoPointDto() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoPointDto extends GeoPointDto {
  const _GeoPointDto({required this.latitude, required this.longitude}): super._();
  factory _GeoPointDto.fromJson(Map<String, dynamic> json) => _$GeoPointDtoFromJson(json);

@override final  double latitude;
@override final  double longitude;

/// Create a copy of GeoPointDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoPointDtoCopyWith<_GeoPointDto> get copyWith => __$GeoPointDtoCopyWithImpl<_GeoPointDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoPointDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoPointDto&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,latitude,longitude);
}

@override
String toString() {
    return 'GeoPointDto(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$GeoPointDtoCopyWith<$Res> implements $GeoPointDtoCopyWith<$Res> {
  factory _$GeoPointDtoCopyWith(_GeoPointDto value, $Res Function(_GeoPointDto) _then) = __$GeoPointDtoCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$GeoPointDtoCopyWithImpl<$Res>
    implements _$GeoPointDtoCopyWith<$Res> {
  __$GeoPointDtoCopyWithImpl(this._self, this._then);

  final _GeoPointDto _self;
  final $Res Function(_GeoPointDto) _then;

/// Create a copy of GeoPointDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_GeoPointDto(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$MonumentImageDto {

 String get url; String get thumbnailUrl; String get author; String get license; String get sourceName; String? get altText; String? get sourceUrl; String? get title;
/// Create a copy of MonumentImageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentImageDtoCopyWith<MonumentImageDto> get copyWith => _$MonumentImageDtoCopyWithImpl<MonumentImageDto>(this as MonumentImageDto, _$identity);

  /// Serializes this MonumentImageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonumentImageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentImageDto&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.thumbnailUrl, _this.thumbnailUrl) || other.thumbnailUrl == _this.thumbnailUrl)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.license, _this.license) || other.license == _this.license)&&(identical(other.sourceName, _this.sourceName) || other.sourceName == _this.sourceName)&&(identical(other.altText, _this.altText) || other.altText == _this.altText)&&(identical(other.sourceUrl, _this.sourceUrl) || other.sourceUrl == _this.sourceUrl)&&(identical(other.title, _this.title) || other.title == _this.title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonumentImageDto;
  return Object.hash(runtimeType,_this.url,_this.thumbnailUrl,_this.author,_this.license,_this.sourceName,_this.altText,_this.sourceUrl,_this.title);
}

@override
String toString() {
  final _this = this as MonumentImageDto;
  return 'MonumentImageDto(url: ${_this.url}, thumbnailUrl: ${_this.thumbnailUrl}, author: ${_this.author}, license: ${_this.license}, sourceName: ${_this.sourceName}, altText: ${_this.altText}, sourceUrl: ${_this.sourceUrl}, title: ${_this.title})';
}


}

/// @nodoc
abstract mixin class $MonumentImageDtoCopyWith<$Res>  {
  factory $MonumentImageDtoCopyWith(MonumentImageDto value, $Res Function(MonumentImageDto) _then) = _$MonumentImageDtoCopyWithImpl;
@useResult
$Res call({
 String url, String thumbnailUrl, String author, String license, String sourceName, String? altText, String? sourceUrl, String? title
});




}
/// @nodoc
class _$MonumentImageDtoCopyWithImpl<$Res>
    implements $MonumentImageDtoCopyWith<$Res> {
  _$MonumentImageDtoCopyWithImpl(this._self, this._then);

  final MonumentImageDto _self;
  final $Res Function(MonumentImageDto) _then;

/// Create a copy of MonumentImageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? thumbnailUrl = null,Object? author = null,Object? license = null,Object? sourceName = null,Object? altText = freezed,Object? sourceUrl = freezed,Object? title = freezed,}) {
  return _then(MonumentImageDto(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,license: null == license ? _self.license : license // ignore: cast_nullable_to_non_nullable
as String,sourceName: null == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String,altText: freezed == altText ? _self.altText : altText // ignore: cast_nullable_to_non_nullable
as String?,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonumentImageDto].
extension MonumentImageDtoPatterns on MonumentImageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonumentImageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonumentImageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonumentImageDto value)  $default,){
final _that = this;
switch (_that) {
case _MonumentImageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonumentImageDto value)?  $default,){
final _that = this;
switch (_that) {
case _MonumentImageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String thumbnailUrl,  String author,  String license,  String sourceName,  String? altText,  String? sourceUrl,  String? title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonumentImageDto() when $default != null:
return $default(_that.url,_that.thumbnailUrl,_that.author,_that.license,_that.sourceName,_that.altText,_that.sourceUrl,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String thumbnailUrl,  String author,  String license,  String sourceName,  String? altText,  String? sourceUrl,  String? title)  $default,) {final _that = this;
switch (_that) {
case _MonumentImageDto():
return $default(_that.url,_that.thumbnailUrl,_that.author,_that.license,_that.sourceName,_that.altText,_that.sourceUrl,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String thumbnailUrl,  String author,  String license,  String sourceName,  String? altText,  String? sourceUrl,  String? title)?  $default,) {final _that = this;
switch (_that) {
case _MonumentImageDto() when $default != null:
return $default(_that.url,_that.thumbnailUrl,_that.author,_that.license,_that.sourceName,_that.altText,_that.sourceUrl,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonumentImageDto extends MonumentImageDto {
  const _MonumentImageDto({required this.url, required this.thumbnailUrl, required this.author, required this.license, required this.sourceName, this.altText, this.sourceUrl, this.title}): super._();
  factory _MonumentImageDto.fromJson(Map<String, dynamic> json) => _$MonumentImageDtoFromJson(json);

@override final  String url;
@override final  String thumbnailUrl;
@override final  String author;
@override final  String license;
@override final  String sourceName;
@override final  String? altText;
@override final  String? sourceUrl;
@override final  String? title;

/// Create a copy of MonumentImageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonumentImageDtoCopyWith<_MonumentImageDto> get copyWith => __$MonumentImageDtoCopyWithImpl<_MonumentImageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonumentImageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonumentImageDto&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.author, author) || other.author == author)&&(identical(other.license, license) || other.license == license)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&(identical(other.altText, altText) || other.altText == altText)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,url,thumbnailUrl,author,license,sourceName,altText,sourceUrl,title);
}

@override
String toString() {
    return 'MonumentImageDto(url: $url, thumbnailUrl: $thumbnailUrl, author: $author, license: $license, sourceName: $sourceName, altText: $altText, sourceUrl: $sourceUrl, title: $title)';
}


}

/// @nodoc
abstract mixin class _$MonumentImageDtoCopyWith<$Res> implements $MonumentImageDtoCopyWith<$Res> {
  factory _$MonumentImageDtoCopyWith(_MonumentImageDto value, $Res Function(_MonumentImageDto) _then) = __$MonumentImageDtoCopyWithImpl;
@override @useResult
$Res call({
 String url, String thumbnailUrl, String author, String license, String sourceName, String? altText, String? sourceUrl, String? title
});




}
/// @nodoc
class __$MonumentImageDtoCopyWithImpl<$Res>
    implements _$MonumentImageDtoCopyWith<$Res> {
  __$MonumentImageDtoCopyWithImpl(this._self, this._then);

  final _MonumentImageDto _self;
  final $Res Function(_MonumentImageDto) _then;

/// Create a copy of MonumentImageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? thumbnailUrl = null,Object? author = null,Object? license = null,Object? sourceName = null,Object? altText = freezed,Object? sourceUrl = freezed,Object? title = freezed,}) {
  return _then(_MonumentImageDto(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,license: null == license ? _self.license : license // ignore: cast_nullable_to_non_nullable
as String,sourceName: null == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String,altText: freezed == altText ? _self.altText : altText // ignore: cast_nullable_to_non_nullable
as String?,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CityRefDto {

 int get code; String get name;
/// Create a copy of CityRefDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CityRefDtoCopyWith<CityRefDto> get copyWith => _$CityRefDtoCopyWithImpl<CityRefDto>(this as CityRefDto, _$identity);

  /// Serializes this CityRefDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CityRefDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CityRefDto&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CityRefDto;
  return Object.hash(runtimeType,_this.code,_this.name);
}

@override
String toString() {
  final _this = this as CityRefDto;
  return 'CityRefDto(code: ${_this.code}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $CityRefDtoCopyWith<$Res>  {
  factory $CityRefDtoCopyWith(CityRefDto value, $Res Function(CityRefDto) _then) = _$CityRefDtoCopyWithImpl;
@useResult
$Res call({
 int code, String name
});




}
/// @nodoc
class _$CityRefDtoCopyWithImpl<$Res>
    implements $CityRefDtoCopyWith<$Res> {
  _$CityRefDtoCopyWithImpl(this._self, this._then);

  final CityRefDto _self;
  final $Res Function(CityRefDto) _then;

/// Create a copy of CityRefDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,}) {
  return _then(CityRefDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CityRefDto].
extension CityRefDtoPatterns on CityRefDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CityRefDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CityRefDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CityRefDto value)  $default,){
final _that = this;
switch (_that) {
case _CityRefDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CityRefDto value)?  $default,){
final _that = this;
switch (_that) {
case _CityRefDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int code,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CityRefDto() when $default != null:
return $default(_that.code,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int code,  String name)  $default,) {final _that = this;
switch (_that) {
case _CityRefDto():
return $default(_that.code,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int code,  String name)?  $default,) {final _that = this;
switch (_that) {
case _CityRefDto() when $default != null:
return $default(_that.code,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CityRefDto implements CityRefDto {
  const _CityRefDto({required this.code, required this.name});
  factory _CityRefDto.fromJson(Map<String, dynamic> json) => _$CityRefDtoFromJson(json);

@override final  int code;
@override final  String name;

/// Create a copy of CityRefDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CityRefDtoCopyWith<_CityRefDto> get copyWith => __$CityRefDtoCopyWithImpl<_CityRefDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CityRefDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CityRefDto&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,name);
}

@override
String toString() {
    return 'CityRefDto(code: $code, name: $name)';
}


}

/// @nodoc
abstract mixin class _$CityRefDtoCopyWith<$Res> implements $CityRefDtoCopyWith<$Res> {
  factory _$CityRefDtoCopyWith(_CityRefDto value, $Res Function(_CityRefDto) _then) = __$CityRefDtoCopyWithImpl;
@override @useResult
$Res call({
 int code, String name
});




}
/// @nodoc
class __$CityRefDtoCopyWithImpl<$Res>
    implements _$CityRefDtoCopyWith<$Res> {
  __$CityRefDtoCopyWithImpl(this._self, this._then);

  final _CityRefDto _self;
  final $Res Function(_CityRefDto) _then;

/// Create a copy of CityRefDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,}) {
  return _then(_CityRefDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ComplexRefDto {

 String get key; String get name;
/// Create a copy of ComplexRefDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplexRefDtoCopyWith<ComplexRefDto> get copyWith => _$ComplexRefDtoCopyWithImpl<ComplexRefDto>(this as ComplexRefDto, _$identity);

  /// Serializes this ComplexRefDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ComplexRefDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplexRefDto&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ComplexRefDto;
  return Object.hash(runtimeType,_this.key,_this.name);
}

@override
String toString() {
  final _this = this as ComplexRefDto;
  return 'ComplexRefDto(key: ${_this.key}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $ComplexRefDtoCopyWith<$Res>  {
  factory $ComplexRefDtoCopyWith(ComplexRefDto value, $Res Function(ComplexRefDto) _then) = _$ComplexRefDtoCopyWithImpl;
@useResult
$Res call({
 String key, String name
});




}
/// @nodoc
class _$ComplexRefDtoCopyWithImpl<$Res>
    implements $ComplexRefDtoCopyWith<$Res> {
  _$ComplexRefDtoCopyWithImpl(this._self, this._then);

  final ComplexRefDto _self;
  final $Res Function(ComplexRefDto) _then;

/// Create a copy of ComplexRefDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,}) {
  return _then(ComplexRefDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplexRefDto].
extension ComplexRefDtoPatterns on ComplexRefDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplexRefDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplexRefDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplexRefDto value)  $default,){
final _that = this;
switch (_that) {
case _ComplexRefDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplexRefDto value)?  $default,){
final _that = this;
switch (_that) {
case _ComplexRefDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplexRefDto() when $default != null:
return $default(_that.key,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name)  $default,) {final _that = this;
switch (_that) {
case _ComplexRefDto():
return $default(_that.key,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name)?  $default,) {final _that = this;
switch (_that) {
case _ComplexRefDto() when $default != null:
return $default(_that.key,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplexRefDto extends ComplexRefDto {
  const _ComplexRefDto({required this.key, required this.name}): super._();
  factory _ComplexRefDto.fromJson(Map<String, dynamic> json) => _$ComplexRefDtoFromJson(json);

@override final  String key;
@override final  String name;

/// Create a copy of ComplexRefDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplexRefDtoCopyWith<_ComplexRefDto> get copyWith => __$ComplexRefDtoCopyWithImpl<_ComplexRefDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplexRefDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplexRefDto&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,name);
}

@override
String toString() {
    return 'ComplexRefDto(key: $key, name: $name)';
}


}

/// @nodoc
abstract mixin class _$ComplexRefDtoCopyWith<$Res> implements $ComplexRefDtoCopyWith<$Res> {
  factory _$ComplexRefDtoCopyWith(_ComplexRefDto value, $Res Function(_ComplexRefDto) _then) = __$ComplexRefDtoCopyWithImpl;
@override @useResult
$Res call({
 String key, String name
});




}
/// @nodoc
class __$ComplexRefDtoCopyWithImpl<$Res>
    implements _$ComplexRefDtoCopyWith<$Res> {
  __$ComplexRefDtoCopyWithImpl(this._self, this._then);

  final _ComplexRefDto _self;
  final $Res Function(_ComplexRefDto) _then;

/// Create a copy of ComplexRefDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,}) {
  return _then(_ComplexRefDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MonumentSummaryDto {

 String get key; String get title;@JsonKey(unknownEnumValue: MonumentCategory.other) MonumentCategory get category;@JsonKey(unknownEnumValue: HistoricalPeriod.other) HistoricalPeriod get period; CityRefDto get city; String? get slug; String? get nickname; String? get district; String? get address; GeoPointDto? get location; String? get shortDescription; String? get thumbnailUrl; ComplexRefDto? get complex;
/// Create a copy of MonumentSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentSummaryDtoCopyWith<MonumentSummaryDto> get copyWith => _$MonumentSummaryDtoCopyWithImpl<MonumentSummaryDto>(this as MonumentSummaryDto, _$identity);

  /// Serializes this MonumentSummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonumentSummaryDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentSummaryDto&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.period, _this.period) || other.period == _this.period)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.nickname, _this.nickname) || other.nickname == _this.nickname)&&(identical(other.district, _this.district) || other.district == _this.district)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.shortDescription, _this.shortDescription) || other.shortDescription == _this.shortDescription)&&(identical(other.thumbnailUrl, _this.thumbnailUrl) || other.thumbnailUrl == _this.thumbnailUrl)&&(identical(other.complex, _this.complex) || other.complex == _this.complex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonumentSummaryDto;
  return Object.hash(runtimeType,_this.key,_this.title,_this.category,_this.period,_this.city,_this.slug,_this.nickname,_this.district,_this.address,_this.location,_this.shortDescription,_this.thumbnailUrl,_this.complex);
}

@override
String toString() {
  final _this = this as MonumentSummaryDto;
  return 'MonumentSummaryDto(key: ${_this.key}, title: ${_this.title}, category: ${_this.category}, period: ${_this.period}, city: ${_this.city}, slug: ${_this.slug}, nickname: ${_this.nickname}, district: ${_this.district}, address: ${_this.address}, location: ${_this.location}, shortDescription: ${_this.shortDescription}, thumbnailUrl: ${_this.thumbnailUrl}, complex: ${_this.complex})';
}


}

/// @nodoc
abstract mixin class $MonumentSummaryDtoCopyWith<$Res>  {
  factory $MonumentSummaryDtoCopyWith(MonumentSummaryDto value, $Res Function(MonumentSummaryDto) _then) = _$MonumentSummaryDtoCopyWithImpl;
@useResult
$Res call({
 String key, String title,@JsonKey(unknownEnumValue: MonumentCategory.other) MonumentCategory category,@JsonKey(unknownEnumValue: HistoricalPeriod.other) HistoricalPeriod period, CityRefDto city, String? slug, String? nickname, String? district, String? address, GeoPointDto? location, String? shortDescription, String? thumbnailUrl, ComplexRefDto? complex
});


$CityRefDtoCopyWith<$Res> get city;$GeoPointDtoCopyWith<$Res>? get location;$ComplexRefDtoCopyWith<$Res>? get complex;

}
/// @nodoc
class _$MonumentSummaryDtoCopyWithImpl<$Res>
    implements $MonumentSummaryDtoCopyWith<$Res> {
  _$MonumentSummaryDtoCopyWithImpl(this._self, this._then);

  final MonumentSummaryDto _self;
  final $Res Function(MonumentSummaryDto) _then;

/// Create a copy of MonumentSummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? title = null,Object? category = null,Object? period = null,Object? city = null,Object? slug = freezed,Object? nickname = freezed,Object? district = freezed,Object? address = freezed,Object? location = freezed,Object? shortDescription = freezed,Object? thumbnailUrl = freezed,Object? complex = freezed,}) {
  return _then(MonumentSummaryDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MonumentCategory,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as HistoricalPeriod,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityRefDto,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPointDto?,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,complex: freezed == complex ? _self.complex : complex // ignore: cast_nullable_to_non_nullable
as ComplexRefDto?,
  ));
}
/// Create a copy of MonumentSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityRefDtoCopyWith<$Res> get city {
  
  return $CityRefDtoCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}/// Create a copy of MonumentSummaryDto
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
}/// Create a copy of MonumentSummaryDto
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


/// Adds pattern-matching-related methods to [MonumentSummaryDto].
extension MonumentSummaryDtoPatterns on MonumentSummaryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonumentSummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonumentSummaryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonumentSummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _MonumentSummaryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonumentSummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _MonumentSummaryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String title, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category, @JsonKey(unknownEnumValue: HistoricalPeriod.other)  HistoricalPeriod period,  CityRefDto city,  String? slug,  String? nickname,  String? district,  String? address,  GeoPointDto? location,  String? shortDescription,  String? thumbnailUrl,  ComplexRefDto? complex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonumentSummaryDto() when $default != null:
return $default(_that.key,_that.title,_that.category,_that.period,_that.city,_that.slug,_that.nickname,_that.district,_that.address,_that.location,_that.shortDescription,_that.thumbnailUrl,_that.complex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String title, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category, @JsonKey(unknownEnumValue: HistoricalPeriod.other)  HistoricalPeriod period,  CityRefDto city,  String? slug,  String? nickname,  String? district,  String? address,  GeoPointDto? location,  String? shortDescription,  String? thumbnailUrl,  ComplexRefDto? complex)  $default,) {final _that = this;
switch (_that) {
case _MonumentSummaryDto():
return $default(_that.key,_that.title,_that.category,_that.period,_that.city,_that.slug,_that.nickname,_that.district,_that.address,_that.location,_that.shortDescription,_that.thumbnailUrl,_that.complex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String title, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category, @JsonKey(unknownEnumValue: HistoricalPeriod.other)  HistoricalPeriod period,  CityRefDto city,  String? slug,  String? nickname,  String? district,  String? address,  GeoPointDto? location,  String? shortDescription,  String? thumbnailUrl,  ComplexRefDto? complex)?  $default,) {final _that = this;
switch (_that) {
case _MonumentSummaryDto() when $default != null:
return $default(_that.key,_that.title,_that.category,_that.period,_that.city,_that.slug,_that.nickname,_that.district,_that.address,_that.location,_that.shortDescription,_that.thumbnailUrl,_that.complex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonumentSummaryDto extends MonumentSummaryDto {
  const _MonumentSummaryDto({required this.key, required this.title, @JsonKey(unknownEnumValue: MonumentCategory.other) required this.category, @JsonKey(unknownEnumValue: HistoricalPeriod.other) required this.period, required this.city, this.slug, this.nickname, this.district, this.address, this.location, this.shortDescription, this.thumbnailUrl, this.complex}): super._();
  factory _MonumentSummaryDto.fromJson(Map<String, dynamic> json) => _$MonumentSummaryDtoFromJson(json);

@override final  String key;
@override final  String title;
@override@JsonKey(unknownEnumValue: MonumentCategory.other) final  MonumentCategory category;
@override@JsonKey(unknownEnumValue: HistoricalPeriod.other) final  HistoricalPeriod period;
@override final  CityRefDto city;
@override final  String? slug;
@override final  String? nickname;
@override final  String? district;
@override final  String? address;
@override final  GeoPointDto? location;
@override final  String? shortDescription;
@override final  String? thumbnailUrl;
@override final  ComplexRefDto? complex;

/// Create a copy of MonumentSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonumentSummaryDtoCopyWith<_MonumentSummaryDto> get copyWith => __$MonumentSummaryDtoCopyWithImpl<_MonumentSummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonumentSummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonumentSummaryDto&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.period, period) || other.period == period)&&(identical(other.city, city) || other.city == city)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.district, district) || other.district == district)&&(identical(other.address, address) || other.address == address)&&(identical(other.location, location) || other.location == location)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.complex, complex) || other.complex == complex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,title,category,period,city,slug,nickname,district,address,location,shortDescription,thumbnailUrl,complex);
}

@override
String toString() {
    return 'MonumentSummaryDto(key: $key, title: $title, category: $category, period: $period, city: $city, slug: $slug, nickname: $nickname, district: $district, address: $address, location: $location, shortDescription: $shortDescription, thumbnailUrl: $thumbnailUrl, complex: $complex)';
}


}

/// @nodoc
abstract mixin class _$MonumentSummaryDtoCopyWith<$Res> implements $MonumentSummaryDtoCopyWith<$Res> {
  factory _$MonumentSummaryDtoCopyWith(_MonumentSummaryDto value, $Res Function(_MonumentSummaryDto) _then) = __$MonumentSummaryDtoCopyWithImpl;
@override @useResult
$Res call({
 String key, String title,@JsonKey(unknownEnumValue: MonumentCategory.other) MonumentCategory category,@JsonKey(unknownEnumValue: HistoricalPeriod.other) HistoricalPeriod period, CityRefDto city, String? slug, String? nickname, String? district, String? address, GeoPointDto? location, String? shortDescription, String? thumbnailUrl, ComplexRefDto? complex
});


@override $CityRefDtoCopyWith<$Res> get city;@override $GeoPointDtoCopyWith<$Res>? get location;@override $ComplexRefDtoCopyWith<$Res>? get complex;

}
/// @nodoc
class __$MonumentSummaryDtoCopyWithImpl<$Res>
    implements _$MonumentSummaryDtoCopyWith<$Res> {
  __$MonumentSummaryDtoCopyWithImpl(this._self, this._then);

  final _MonumentSummaryDto _self;
  final $Res Function(_MonumentSummaryDto) _then;

/// Create a copy of MonumentSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? title = null,Object? category = null,Object? period = null,Object? city = null,Object? slug = freezed,Object? nickname = freezed,Object? district = freezed,Object? address = freezed,Object? location = freezed,Object? shortDescription = freezed,Object? thumbnailUrl = freezed,Object? complex = freezed,}) {
  return _then(_MonumentSummaryDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MonumentCategory,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as HistoricalPeriod,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityRefDto,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPointDto?,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,complex: freezed == complex ? _self.complex : complex // ignore: cast_nullable_to_non_nullable
as ComplexRefDto?,
  ));
}

/// Create a copy of MonumentSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityRefDtoCopyWith<$Res> get city {
  
  return $CityRefDtoCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}/// Create a copy of MonumentSummaryDto
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
}/// Create a copy of MonumentSummaryDto
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
mixin _$MonumentDetailDto {

 String get key; String get title;@JsonKey(unknownEnumValue: MonumentCategory.other) MonumentCategory get category;@JsonKey(unknownEnumValue: HistoricalPeriod.other) HistoricalPeriod get period; CityRefDto get city; String? get slug; String? get nickname; String? get district; String? get address; GeoPointDto? get location; String? get shortDescriptionTitle; String? get shortDescription; String? get history; String? get constructionDate; String? get founder; String? get architect; bool get isUnescoWorldHeritage; List<MonumentImageDto> get images; List<MonumentPartDto> get parts; ComplexRefDto? get complex;
/// Create a copy of MonumentDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentDetailDtoCopyWith<MonumentDetailDto> get copyWith => _$MonumentDetailDtoCopyWithImpl<MonumentDetailDto>(this as MonumentDetailDto, _$identity);

  /// Serializes this MonumentDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonumentDetailDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentDetailDto&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.period, _this.period) || other.period == _this.period)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.nickname, _this.nickname) || other.nickname == _this.nickname)&&(identical(other.district, _this.district) || other.district == _this.district)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.shortDescriptionTitle, _this.shortDescriptionTitle) || other.shortDescriptionTitle == _this.shortDescriptionTitle)&&(identical(other.shortDescription, _this.shortDescription) || other.shortDescription == _this.shortDescription)&&(identical(other.history, _this.history) || other.history == _this.history)&&(identical(other.constructionDate, _this.constructionDate) || other.constructionDate == _this.constructionDate)&&(identical(other.founder, _this.founder) || other.founder == _this.founder)&&(identical(other.architect, _this.architect) || other.architect == _this.architect)&&(identical(other.isUnescoWorldHeritage, _this.isUnescoWorldHeritage) || other.isUnescoWorldHeritage == _this.isUnescoWorldHeritage)&&const DeepCollectionEquality().equals(other.images, _this.images)&&const DeepCollectionEquality().equals(other.parts, _this.parts)&&(identical(other.complex, _this.complex) || other.complex == _this.complex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonumentDetailDto;
  return Object.hashAll([runtimeType,_this.key,_this.title,_this.category,_this.period,_this.city,_this.slug,_this.nickname,_this.district,_this.address,_this.location,_this.shortDescriptionTitle,_this.shortDescription,_this.history,_this.constructionDate,_this.founder,_this.architect,_this.isUnescoWorldHeritage,const DeepCollectionEquality().hash(_this.images),const DeepCollectionEquality().hash(_this.parts),_this.complex]);
}

@override
String toString() {
  final _this = this as MonumentDetailDto;
  return 'MonumentDetailDto(key: ${_this.key}, title: ${_this.title}, category: ${_this.category}, period: ${_this.period}, city: ${_this.city}, slug: ${_this.slug}, nickname: ${_this.nickname}, district: ${_this.district}, address: ${_this.address}, location: ${_this.location}, shortDescriptionTitle: ${_this.shortDescriptionTitle}, shortDescription: ${_this.shortDescription}, history: ${_this.history}, constructionDate: ${_this.constructionDate}, founder: ${_this.founder}, architect: ${_this.architect}, isUnescoWorldHeritage: ${_this.isUnescoWorldHeritage}, images: ${_this.images}, parts: ${_this.parts}, complex: ${_this.complex})';
}


}

/// @nodoc
abstract mixin class $MonumentDetailDtoCopyWith<$Res>  {
  factory $MonumentDetailDtoCopyWith(MonumentDetailDto value, $Res Function(MonumentDetailDto) _then) = _$MonumentDetailDtoCopyWithImpl;
@useResult
$Res call({
 String key, String title,@JsonKey(unknownEnumValue: MonumentCategory.other) MonumentCategory category,@JsonKey(unknownEnumValue: HistoricalPeriod.other) HistoricalPeriod period, CityRefDto city, String? slug, String? nickname, String? district, String? address, GeoPointDto? location, String? shortDescriptionTitle, String? shortDescription, String? history, String? constructionDate, String? founder, String? architect, bool isUnescoWorldHeritage, List<MonumentImageDto> images, List<MonumentPartDto> parts, ComplexRefDto? complex
});


$CityRefDtoCopyWith<$Res> get city;$GeoPointDtoCopyWith<$Res>? get location;$ComplexRefDtoCopyWith<$Res>? get complex;

}
/// @nodoc
class _$MonumentDetailDtoCopyWithImpl<$Res>
    implements $MonumentDetailDtoCopyWith<$Res> {
  _$MonumentDetailDtoCopyWithImpl(this._self, this._then);

  final MonumentDetailDto _self;
  final $Res Function(MonumentDetailDto) _then;

/// Create a copy of MonumentDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? title = null,Object? category = null,Object? period = null,Object? city = null,Object? slug = freezed,Object? nickname = freezed,Object? district = freezed,Object? address = freezed,Object? location = freezed,Object? shortDescriptionTitle = freezed,Object? shortDescription = freezed,Object? history = freezed,Object? constructionDate = freezed,Object? founder = freezed,Object? architect = freezed,Object? isUnescoWorldHeritage = null,Object? images = null,Object? parts = null,Object? complex = freezed,}) {
  return _then(MonumentDetailDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MonumentCategory,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as HistoricalPeriod,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityRefDto,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPointDto?,shortDescriptionTitle: freezed == shortDescriptionTitle ? _self.shortDescriptionTitle : shortDescriptionTitle // ignore: cast_nullable_to_non_nullable
as String?,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,history: freezed == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as String?,constructionDate: freezed == constructionDate ? _self.constructionDate : constructionDate // ignore: cast_nullable_to_non_nullable
as String?,founder: freezed == founder ? _self.founder : founder // ignore: cast_nullable_to_non_nullable
as String?,architect: freezed == architect ? _self.architect : architect // ignore: cast_nullable_to_non_nullable
as String?,isUnescoWorldHeritage: null == isUnescoWorldHeritage ? _self.isUnescoWorldHeritage : isUnescoWorldHeritage // ignore: cast_nullable_to_non_nullable
as bool,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<MonumentImageDto>,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<MonumentPartDto>,complex: freezed == complex ? _self.complex : complex // ignore: cast_nullable_to_non_nullable
as ComplexRefDto?,
  ));
}
/// Create a copy of MonumentDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityRefDtoCopyWith<$Res> get city {
  
  return $CityRefDtoCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}/// Create a copy of MonumentDetailDto
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
}/// Create a copy of MonumentDetailDto
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


/// Adds pattern-matching-related methods to [MonumentDetailDto].
extension MonumentDetailDtoPatterns on MonumentDetailDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonumentDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonumentDetailDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonumentDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _MonumentDetailDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonumentDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _MonumentDetailDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String title, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category, @JsonKey(unknownEnumValue: HistoricalPeriod.other)  HistoricalPeriod period,  CityRefDto city,  String? slug,  String? nickname,  String? district,  String? address,  GeoPointDto? location,  String? shortDescriptionTitle,  String? shortDescription,  String? history,  String? constructionDate,  String? founder,  String? architect,  bool isUnescoWorldHeritage,  List<MonumentImageDto> images,  List<MonumentPartDto> parts,  ComplexRefDto? complex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonumentDetailDto() when $default != null:
return $default(_that.key,_that.title,_that.category,_that.period,_that.city,_that.slug,_that.nickname,_that.district,_that.address,_that.location,_that.shortDescriptionTitle,_that.shortDescription,_that.history,_that.constructionDate,_that.founder,_that.architect,_that.isUnescoWorldHeritage,_that.images,_that.parts,_that.complex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String title, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category, @JsonKey(unknownEnumValue: HistoricalPeriod.other)  HistoricalPeriod period,  CityRefDto city,  String? slug,  String? nickname,  String? district,  String? address,  GeoPointDto? location,  String? shortDescriptionTitle,  String? shortDescription,  String? history,  String? constructionDate,  String? founder,  String? architect,  bool isUnescoWorldHeritage,  List<MonumentImageDto> images,  List<MonumentPartDto> parts,  ComplexRefDto? complex)  $default,) {final _that = this;
switch (_that) {
case _MonumentDetailDto():
return $default(_that.key,_that.title,_that.category,_that.period,_that.city,_that.slug,_that.nickname,_that.district,_that.address,_that.location,_that.shortDescriptionTitle,_that.shortDescription,_that.history,_that.constructionDate,_that.founder,_that.architect,_that.isUnescoWorldHeritage,_that.images,_that.parts,_that.complex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String title, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category, @JsonKey(unknownEnumValue: HistoricalPeriod.other)  HistoricalPeriod period,  CityRefDto city,  String? slug,  String? nickname,  String? district,  String? address,  GeoPointDto? location,  String? shortDescriptionTitle,  String? shortDescription,  String? history,  String? constructionDate,  String? founder,  String? architect,  bool isUnescoWorldHeritage,  List<MonumentImageDto> images,  List<MonumentPartDto> parts,  ComplexRefDto? complex)?  $default,) {final _that = this;
switch (_that) {
case _MonumentDetailDto() when $default != null:
return $default(_that.key,_that.title,_that.category,_that.period,_that.city,_that.slug,_that.nickname,_that.district,_that.address,_that.location,_that.shortDescriptionTitle,_that.shortDescription,_that.history,_that.constructionDate,_that.founder,_that.architect,_that.isUnescoWorldHeritage,_that.images,_that.parts,_that.complex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonumentDetailDto extends MonumentDetailDto {
  const _MonumentDetailDto({required this.key, required this.title, @JsonKey(unknownEnumValue: MonumentCategory.other) required this.category, @JsonKey(unknownEnumValue: HistoricalPeriod.other) required this.period, required this.city, this.slug, this.nickname, this.district, this.address, this.location, this.shortDescriptionTitle, this.shortDescription, this.history, this.constructionDate, this.founder, this.architect, this.isUnescoWorldHeritage = false,  List<MonumentImageDto> images = const <MonumentImageDto>[],  List<MonumentPartDto> parts = const <MonumentPartDto>[], this.complex}): _images = images,_parts = parts,super._();
  factory _MonumentDetailDto.fromJson(Map<String, dynamic> json) => _$MonumentDetailDtoFromJson(json);

@override final  String key;
@override final  String title;
@override@JsonKey(unknownEnumValue: MonumentCategory.other) final  MonumentCategory category;
@override@JsonKey(unknownEnumValue: HistoricalPeriod.other) final  HistoricalPeriod period;
@override final  CityRefDto city;
@override final  String? slug;
@override final  String? nickname;
@override final  String? district;
@override final  String? address;
@override final  GeoPointDto? location;
@override final  String? shortDescriptionTitle;
@override final  String? shortDescription;
@override final  String? history;
@override final  String? constructionDate;
@override final  String? founder;
@override final  String? architect;
@override@JsonKey() final  bool isUnescoWorldHeritage;
 final  List<MonumentImageDto> _images;
@override@JsonKey() List<MonumentImageDto> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

 final  List<MonumentPartDto> _parts;
@override@JsonKey() List<MonumentPartDto> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

@override final  ComplexRefDto? complex;

/// Create a copy of MonumentDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonumentDetailDtoCopyWith<_MonumentDetailDto> get copyWith => __$MonumentDetailDtoCopyWithImpl<_MonumentDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonumentDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonumentDetailDto&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.period, period) || other.period == period)&&(identical(other.city, city) || other.city == city)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.district, district) || other.district == district)&&(identical(other.address, address) || other.address == address)&&(identical(other.location, location) || other.location == location)&&(identical(other.shortDescriptionTitle, shortDescriptionTitle) || other.shortDescriptionTitle == shortDescriptionTitle)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.history, history) || other.history == history)&&(identical(other.constructionDate, constructionDate) || other.constructionDate == constructionDate)&&(identical(other.founder, founder) || other.founder == founder)&&(identical(other.architect, architect) || other.architect == architect)&&(identical(other.isUnescoWorldHeritage, isUnescoWorldHeritage) || other.isUnescoWorldHeritage == isUnescoWorldHeritage)&&const DeepCollectionEquality().equals(other.images, _images)&&const DeepCollectionEquality().equals(other.parts, _parts)&&(identical(other.complex, complex) || other.complex == complex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,key,title,category,period,city,slug,nickname,district,address,location,shortDescriptionTitle,shortDescription,history,constructionDate,founder,architect,isUnescoWorldHeritage,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_parts),complex]);
}

@override
String toString() {
    return 'MonumentDetailDto(key: $key, title: $title, category: $category, period: $period, city: $city, slug: $slug, nickname: $nickname, district: $district, address: $address, location: $location, shortDescriptionTitle: $shortDescriptionTitle, shortDescription: $shortDescription, history: $history, constructionDate: $constructionDate, founder: $founder, architect: $architect, isUnescoWorldHeritage: $isUnescoWorldHeritage, images: $images, parts: $parts, complex: $complex)';
}


}

/// @nodoc
abstract mixin class _$MonumentDetailDtoCopyWith<$Res> implements $MonumentDetailDtoCopyWith<$Res> {
  factory _$MonumentDetailDtoCopyWith(_MonumentDetailDto value, $Res Function(_MonumentDetailDto) _then) = __$MonumentDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 String key, String title,@JsonKey(unknownEnumValue: MonumentCategory.other) MonumentCategory category,@JsonKey(unknownEnumValue: HistoricalPeriod.other) HistoricalPeriod period, CityRefDto city, String? slug, String? nickname, String? district, String? address, GeoPointDto? location, String? shortDescriptionTitle, String? shortDescription, String? history, String? constructionDate, String? founder, String? architect, bool isUnescoWorldHeritage, List<MonumentImageDto> images, List<MonumentPartDto> parts, ComplexRefDto? complex
});


@override $CityRefDtoCopyWith<$Res> get city;@override $GeoPointDtoCopyWith<$Res>? get location;@override $ComplexRefDtoCopyWith<$Res>? get complex;

}
/// @nodoc
class __$MonumentDetailDtoCopyWithImpl<$Res>
    implements _$MonumentDetailDtoCopyWith<$Res> {
  __$MonumentDetailDtoCopyWithImpl(this._self, this._then);

  final _MonumentDetailDto _self;
  final $Res Function(_MonumentDetailDto) _then;

/// Create a copy of MonumentDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? title = null,Object? category = null,Object? period = null,Object? city = null,Object? slug = freezed,Object? nickname = freezed,Object? district = freezed,Object? address = freezed,Object? location = freezed,Object? shortDescriptionTitle = freezed,Object? shortDescription = freezed,Object? history = freezed,Object? constructionDate = freezed,Object? founder = freezed,Object? architect = freezed,Object? isUnescoWorldHeritage = null,Object? images = null,Object? parts = null,Object? complex = freezed,}) {
  return _then(_MonumentDetailDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MonumentCategory,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as HistoricalPeriod,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityRefDto,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPointDto?,shortDescriptionTitle: freezed == shortDescriptionTitle ? _self.shortDescriptionTitle : shortDescriptionTitle // ignore: cast_nullable_to_non_nullable
as String?,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,history: freezed == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as String?,constructionDate: freezed == constructionDate ? _self.constructionDate : constructionDate // ignore: cast_nullable_to_non_nullable
as String?,founder: freezed == founder ? _self.founder : founder // ignore: cast_nullable_to_non_nullable
as String?,architect: freezed == architect ? _self.architect : architect // ignore: cast_nullable_to_non_nullable
as String?,isUnescoWorldHeritage: null == isUnescoWorldHeritage ? _self.isUnescoWorldHeritage : isUnescoWorldHeritage // ignore: cast_nullable_to_non_nullable
as bool,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<MonumentImageDto>,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<MonumentPartDto>,complex: freezed == complex ? _self.complex : complex // ignore: cast_nullable_to_non_nullable
as ComplexRefDto?,
  ));
}

/// Create a copy of MonumentDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityRefDtoCopyWith<$Res> get city {
  
  return $CityRefDtoCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}/// Create a copy of MonumentDetailDto
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
}/// Create a copy of MonumentDetailDto
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
mixin _$MonumentPartDto {

 String? get description; String? get title; List<MonumentImageDto> get images;
/// Create a copy of MonumentPartDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentPartDtoCopyWith<MonumentPartDto> get copyWith => _$MonumentPartDtoCopyWithImpl<MonumentPartDto>(this as MonumentPartDto, _$identity);

  /// Serializes this MonumentPartDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonumentPartDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentPartDto&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.title, _this.title) || other.title == _this.title)&&const DeepCollectionEquality().equals(other.images, _this.images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonumentPartDto;
  return Object.hash(runtimeType,_this.description,_this.title,const DeepCollectionEquality().hash(_this.images));
}

@override
String toString() {
  final _this = this as MonumentPartDto;
  return 'MonumentPartDto(description: ${_this.description}, title: ${_this.title}, images: ${_this.images})';
}


}

/// @nodoc
abstract mixin class $MonumentPartDtoCopyWith<$Res>  {
  factory $MonumentPartDtoCopyWith(MonumentPartDto value, $Res Function(MonumentPartDto) _then) = _$MonumentPartDtoCopyWithImpl;
@useResult
$Res call({
 String? description, String? title, List<MonumentImageDto> images
});




}
/// @nodoc
class _$MonumentPartDtoCopyWithImpl<$Res>
    implements $MonumentPartDtoCopyWith<$Res> {
  _$MonumentPartDtoCopyWithImpl(this._self, this._then);

  final MonumentPartDto _self;
  final $Res Function(MonumentPartDto) _then;

/// Create a copy of MonumentPartDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? description = freezed,Object? title = freezed,Object? images = null,}) {
  return _then(MonumentPartDto(
description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<MonumentImageDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonumentPartDto].
extension MonumentPartDtoPatterns on MonumentPartDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonumentPartDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonumentPartDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonumentPartDto value)  $default,){
final _that = this;
switch (_that) {
case _MonumentPartDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonumentPartDto value)?  $default,){
final _that = this;
switch (_that) {
case _MonumentPartDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? description,  String? title,  List<MonumentImageDto> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonumentPartDto() when $default != null:
return $default(_that.description,_that.title,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? description,  String? title,  List<MonumentImageDto> images)  $default,) {final _that = this;
switch (_that) {
case _MonumentPartDto():
return $default(_that.description,_that.title,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? description,  String? title,  List<MonumentImageDto> images)?  $default,) {final _that = this;
switch (_that) {
case _MonumentPartDto() when $default != null:
return $default(_that.description,_that.title,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonumentPartDto extends MonumentPartDto {
  const _MonumentPartDto({this.description, this.title,  List<MonumentImageDto> images = const <MonumentImageDto>[]}): _images = images,super._();
  factory _MonumentPartDto.fromJson(Map<String, dynamic> json) => _$MonumentPartDtoFromJson(json);

@override final  String? description;
@override final  String? title;
 final  List<MonumentImageDto> _images;
@override@JsonKey() List<MonumentImageDto> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of MonumentPartDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonumentPartDtoCopyWith<_MonumentPartDto> get copyWith => __$MonumentPartDtoCopyWithImpl<_MonumentPartDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonumentPartDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonumentPartDto&&(identical(other.description, description) || other.description == description)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.images, _images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,description,title,const DeepCollectionEquality().hash(_images));
}

@override
String toString() {
    return 'MonumentPartDto(description: $description, title: $title, images: $images)';
}


}

/// @nodoc
abstract mixin class _$MonumentPartDtoCopyWith<$Res> implements $MonumentPartDtoCopyWith<$Res> {
  factory _$MonumentPartDtoCopyWith(_MonumentPartDto value, $Res Function(_MonumentPartDto) _then) = __$MonumentPartDtoCopyWithImpl;
@override @useResult
$Res call({
 String? description, String? title, List<MonumentImageDto> images
});




}
/// @nodoc
class __$MonumentPartDtoCopyWithImpl<$Res>
    implements _$MonumentPartDtoCopyWith<$Res> {
  __$MonumentPartDtoCopyWithImpl(this._self, this._then);

  final _MonumentPartDto _self;
  final $Res Function(_MonumentPartDto) _then;

/// Create a copy of MonumentPartDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? description = freezed,Object? title = freezed,Object? images = null,}) {
  return _then(_MonumentPartDto(
description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<MonumentImageDto>,
  ));
}


}


/// @nodoc
mixin _$ComplexMembersPageDto {

 List<MonumentSummaryDto> get items; int get total; String? get nextCursor;
/// Create a copy of ComplexMembersPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplexMembersPageDtoCopyWith<ComplexMembersPageDto> get copyWith => _$ComplexMembersPageDtoCopyWithImpl<ComplexMembersPageDto>(this as ComplexMembersPageDto, _$identity);

  /// Serializes this ComplexMembersPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ComplexMembersPageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplexMembersPageDto&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ComplexMembersPageDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.total,_this.nextCursor);
}

@override
String toString() {
  final _this = this as ComplexMembersPageDto;
  return 'ComplexMembersPageDto(items: ${_this.items}, total: ${_this.total}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $ComplexMembersPageDtoCopyWith<$Res>  {
  factory $ComplexMembersPageDtoCopyWith(ComplexMembersPageDto value, $Res Function(ComplexMembersPageDto) _then) = _$ComplexMembersPageDtoCopyWithImpl;
@useResult
$Res call({
 List<MonumentSummaryDto> items, int total, String? nextCursor
});




}
/// @nodoc
class _$ComplexMembersPageDtoCopyWithImpl<$Res>
    implements $ComplexMembersPageDtoCopyWith<$Res> {
  _$ComplexMembersPageDtoCopyWithImpl(this._self, this._then);

  final ComplexMembersPageDto _self;
  final $Res Function(ComplexMembersPageDto) _then;

/// Create a copy of ComplexMembersPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? nextCursor = freezed,}) {
  return _then(ComplexMembersPageDto(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MonumentSummaryDto>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplexMembersPageDto].
extension ComplexMembersPageDtoPatterns on ComplexMembersPageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplexMembersPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplexMembersPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplexMembersPageDto value)  $default,){
final _that = this;
switch (_that) {
case _ComplexMembersPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplexMembersPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _ComplexMembersPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MonumentSummaryDto> items,  int total,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplexMembersPageDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MonumentSummaryDto> items,  int total,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _ComplexMembersPageDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MonumentSummaryDto> items,  int total,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _ComplexMembersPageDto() when $default != null:
return $default(_that.items,_that.total,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplexMembersPageDto extends ComplexMembersPageDto {
  const _ComplexMembersPageDto({required  List<MonumentSummaryDto> items, this.total = 0, this.nextCursor}): _items = items,super._();
  factory _ComplexMembersPageDto.fromJson(Map<String, dynamic> json) => _$ComplexMembersPageDtoFromJson(json);

 final  List<MonumentSummaryDto> _items;
@override List<MonumentSummaryDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int total;
@override final  String? nextCursor;

/// Create a copy of ComplexMembersPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplexMembersPageDtoCopyWith<_ComplexMembersPageDto> get copyWith => __$ComplexMembersPageDtoCopyWithImpl<_ComplexMembersPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplexMembersPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplexMembersPageDto&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,nextCursor);
}

@override
String toString() {
    return 'ComplexMembersPageDto(items: $items, total: $total, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$ComplexMembersPageDtoCopyWith<$Res> implements $ComplexMembersPageDtoCopyWith<$Res> {
  factory _$ComplexMembersPageDtoCopyWith(_ComplexMembersPageDto value, $Res Function(_ComplexMembersPageDto) _then) = __$ComplexMembersPageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<MonumentSummaryDto> items, int total, String? nextCursor
});




}
/// @nodoc
class __$ComplexMembersPageDtoCopyWithImpl<$Res>
    implements _$ComplexMembersPageDtoCopyWith<$Res> {
  __$ComplexMembersPageDtoCopyWithImpl(this._self, this._then);

  final _ComplexMembersPageDto _self;
  final $Res Function(_ComplexMembersPageDto) _then;

/// Create a copy of ComplexMembersPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? nextCursor = freezed,}) {
  return _then(_ComplexMembersPageDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MonumentSummaryDto>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ComplexDetailDto {

 String get key; String get name; CityRefDto get city; int get workCount; ComplexMembersPageDto get works; String? get district; String? get address; GeoPointDto? get location; List<MonumentImageDto> get images;@JsonKey(fromJson: footprintFromJson) List<List<double>> get footprint; List<double>? get bounds;
/// Create a copy of ComplexDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplexDetailDtoCopyWith<ComplexDetailDto> get copyWith => _$ComplexDetailDtoCopyWithImpl<ComplexDetailDto>(this as ComplexDetailDto, _$identity);

  /// Serializes this ComplexDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ComplexDetailDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplexDetailDto&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.workCount, _this.workCount) || other.workCount == _this.workCount)&&(identical(other.works, _this.works) || other.works == _this.works)&&(identical(other.district, _this.district) || other.district == _this.district)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.location, _this.location) || other.location == _this.location)&&const DeepCollectionEquality().equals(other.images, _this.images)&&const DeepCollectionEquality().equals(other.footprint, _this.footprint)&&const DeepCollectionEquality().equals(other.bounds, _this.bounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ComplexDetailDto;
  return Object.hash(runtimeType,_this.key,_this.name,_this.city,_this.workCount,_this.works,_this.district,_this.address,_this.location,const DeepCollectionEquality().hash(_this.images),const DeepCollectionEquality().hash(_this.footprint),const DeepCollectionEquality().hash(_this.bounds));
}

@override
String toString() {
  final _this = this as ComplexDetailDto;
  return 'ComplexDetailDto(key: ${_this.key}, name: ${_this.name}, city: ${_this.city}, workCount: ${_this.workCount}, works: ${_this.works}, district: ${_this.district}, address: ${_this.address}, location: ${_this.location}, images: ${_this.images}, footprint: ${_this.footprint}, bounds: ${_this.bounds})';
}


}

/// @nodoc
abstract mixin class $ComplexDetailDtoCopyWith<$Res>  {
  factory $ComplexDetailDtoCopyWith(ComplexDetailDto value, $Res Function(ComplexDetailDto) _then) = _$ComplexDetailDtoCopyWithImpl;
@useResult
$Res call({
 String key, String name, CityRefDto city, int workCount, ComplexMembersPageDto works, String? district, String? address, GeoPointDto? location, List<MonumentImageDto> images,@JsonKey(fromJson: footprintFromJson) List<List<double>> footprint, List<double>? bounds
});


$CityRefDtoCopyWith<$Res> get city;$ComplexMembersPageDtoCopyWith<$Res> get works;$GeoPointDtoCopyWith<$Res>? get location;

}
/// @nodoc
class _$ComplexDetailDtoCopyWithImpl<$Res>
    implements $ComplexDetailDtoCopyWith<$Res> {
  _$ComplexDetailDtoCopyWithImpl(this._self, this._then);

  final ComplexDetailDto _self;
  final $Res Function(ComplexDetailDto) _then;

/// Create a copy of ComplexDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,Object? city = null,Object? workCount = null,Object? works = null,Object? district = freezed,Object? address = freezed,Object? location = freezed,Object? images = null,Object? footprint = null,Object? bounds = freezed,}) {
  return _then(ComplexDetailDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityRefDto,workCount: null == workCount ? _self.workCount : workCount // ignore: cast_nullable_to_non_nullable
as int,works: null == works ? _self.works : works // ignore: cast_nullable_to_non_nullable
as ComplexMembersPageDto,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPointDto?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<MonumentImageDto>,footprint: null == footprint ? _self.footprint : footprint // ignore: cast_nullable_to_non_nullable
as List<List<double>>,bounds: freezed == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as List<double>?,
  ));
}
/// Create a copy of ComplexDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityRefDtoCopyWith<$Res> get city {
  
  return $CityRefDtoCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}/// Create a copy of ComplexDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplexMembersPageDtoCopyWith<$Res> get works {
  
  return $ComplexMembersPageDtoCopyWith<$Res>(_self.works, (value) {
    return _then(_self.copyWith(works: value));
  });
}/// Create a copy of ComplexDetailDto
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
}
}


/// Adds pattern-matching-related methods to [ComplexDetailDto].
extension ComplexDetailDtoPatterns on ComplexDetailDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplexDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplexDetailDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplexDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _ComplexDetailDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplexDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _ComplexDetailDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name,  CityRefDto city,  int workCount,  ComplexMembersPageDto works,  String? district,  String? address,  GeoPointDto? location,  List<MonumentImageDto> images, @JsonKey(fromJson: footprintFromJson)  List<List<double>> footprint,  List<double>? bounds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplexDetailDto() when $default != null:
return $default(_that.key,_that.name,_that.city,_that.workCount,_that.works,_that.district,_that.address,_that.location,_that.images,_that.footprint,_that.bounds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name,  CityRefDto city,  int workCount,  ComplexMembersPageDto works,  String? district,  String? address,  GeoPointDto? location,  List<MonumentImageDto> images, @JsonKey(fromJson: footprintFromJson)  List<List<double>> footprint,  List<double>? bounds)  $default,) {final _that = this;
switch (_that) {
case _ComplexDetailDto():
return $default(_that.key,_that.name,_that.city,_that.workCount,_that.works,_that.district,_that.address,_that.location,_that.images,_that.footprint,_that.bounds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name,  CityRefDto city,  int workCount,  ComplexMembersPageDto works,  String? district,  String? address,  GeoPointDto? location,  List<MonumentImageDto> images, @JsonKey(fromJson: footprintFromJson)  List<List<double>> footprint,  List<double>? bounds)?  $default,) {final _that = this;
switch (_that) {
case _ComplexDetailDto() when $default != null:
return $default(_that.key,_that.name,_that.city,_that.workCount,_that.works,_that.district,_that.address,_that.location,_that.images,_that.footprint,_that.bounds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComplexDetailDto extends ComplexDetailDto {
  const _ComplexDetailDto({required this.key, required this.name, required this.city, required this.workCount, required this.works, this.district, this.address, this.location,  List<MonumentImageDto> images = const <MonumentImageDto>[], @JsonKey(fromJson: footprintFromJson)  List<List<double>> footprint = const <List<double>>[],  List<double>? bounds}): _images = images,_footprint = footprint,_bounds = bounds,super._();
  factory _ComplexDetailDto.fromJson(Map<String, dynamic> json) => _$ComplexDetailDtoFromJson(json);

@override final  String key;
@override final  String name;
@override final  CityRefDto city;
@override final  int workCount;
@override final  ComplexMembersPageDto works;
@override final  String? district;
@override final  String? address;
@override final  GeoPointDto? location;
 final  List<MonumentImageDto> _images;
@override@JsonKey() List<MonumentImageDto> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

 final  List<List<double>> _footprint;
@override@JsonKey(fromJson: footprintFromJson) List<List<double>> get footprint {
  if (_footprint is EqualUnmodifiableListView) return _footprint;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_footprint);
}

 final  List<double>? _bounds;
@override List<double>? get bounds {
  final value = _bounds;
  if (value == null) return null;
  if (_bounds is EqualUnmodifiableListView) return _bounds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ComplexDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplexDetailDtoCopyWith<_ComplexDetailDto> get copyWith => __$ComplexDetailDtoCopyWithImpl<_ComplexDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplexDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplexDetailDto&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.workCount, workCount) || other.workCount == workCount)&&(identical(other.works, works) || other.works == works)&&(identical(other.district, district) || other.district == district)&&(identical(other.address, address) || other.address == address)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.images, _images)&&const DeepCollectionEquality().equals(other.footprint, _footprint)&&const DeepCollectionEquality().equals(other.bounds, _bounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,name,city,workCount,works,district,address,location,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_footprint),const DeepCollectionEquality().hash(_bounds));
}

@override
String toString() {
    return 'ComplexDetailDto(key: $key, name: $name, city: $city, workCount: $workCount, works: $works, district: $district, address: $address, location: $location, images: $images, footprint: $footprint, bounds: $bounds)';
}


}

/// @nodoc
abstract mixin class _$ComplexDetailDtoCopyWith<$Res> implements $ComplexDetailDtoCopyWith<$Res> {
  factory _$ComplexDetailDtoCopyWith(_ComplexDetailDto value, $Res Function(_ComplexDetailDto) _then) = __$ComplexDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 String key, String name, CityRefDto city, int workCount, ComplexMembersPageDto works, String? district, String? address, GeoPointDto? location, List<MonumentImageDto> images,@JsonKey(fromJson: footprintFromJson) List<List<double>> footprint, List<double>? bounds
});


@override $CityRefDtoCopyWith<$Res> get city;@override $ComplexMembersPageDtoCopyWith<$Res> get works;@override $GeoPointDtoCopyWith<$Res>? get location;

}
/// @nodoc
class __$ComplexDetailDtoCopyWithImpl<$Res>
    implements _$ComplexDetailDtoCopyWith<$Res> {
  __$ComplexDetailDtoCopyWithImpl(this._self, this._then);

  final _ComplexDetailDto _self;
  final $Res Function(_ComplexDetailDto) _then;

/// Create a copy of ComplexDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? city = null,Object? workCount = null,Object? works = null,Object? district = freezed,Object? address = freezed,Object? location = freezed,Object? images = null,Object? footprint = null,Object? bounds = freezed,}) {
  return _then(_ComplexDetailDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as CityRefDto,workCount: null == workCount ? _self.workCount : workCount // ignore: cast_nullable_to_non_nullable
as int,works: null == works ? _self.works : works // ignore: cast_nullable_to_non_nullable
as ComplexMembersPageDto,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPointDto?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<MonumentImageDto>,footprint: null == footprint ? _self._footprint : footprint // ignore: cast_nullable_to_non_nullable
as List<List<double>>,bounds: freezed == bounds ? _self._bounds : bounds // ignore: cast_nullable_to_non_nullable
as List<double>?,
  ));
}

/// Create a copy of ComplexDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CityRefDtoCopyWith<$Res> get city {
  
  return $CityRefDtoCopyWith<$Res>(_self.city, (value) {
    return _then(_self.copyWith(city: value));
  });
}/// Create a copy of ComplexDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComplexMembersPageDtoCopyWith<$Res> get works {
  
  return $ComplexMembersPageDtoCopyWith<$Res>(_self.works, (value) {
    return _then(_self.copyWith(works: value));
  });
}/// Create a copy of ComplexDetailDto
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
}
}

// dart format on
