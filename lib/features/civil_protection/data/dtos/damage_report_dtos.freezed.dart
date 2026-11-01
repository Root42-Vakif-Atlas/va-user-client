// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'damage_report_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportMonumentDto {

 String get id; String get name; String get city; String get district;
/// Create a copy of ReportMonumentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportMonumentDtoCopyWith<ReportMonumentDto> get copyWith => _$ReportMonumentDtoCopyWithImpl<ReportMonumentDto>(this as ReportMonumentDto, _$identity);

  /// Serializes this ReportMonumentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportMonumentDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportMonumentDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.district, _this.district) || other.district == _this.district));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportMonumentDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.city,_this.district);
}

@override
String toString() {
  final _this = this as ReportMonumentDto;
  return 'ReportMonumentDto(id: ${_this.id}, name: ${_this.name}, city: ${_this.city}, district: ${_this.district})';
}


}

/// @nodoc
abstract mixin class $ReportMonumentDtoCopyWith<$Res>  {
  factory $ReportMonumentDtoCopyWith(ReportMonumentDto value, $Res Function(ReportMonumentDto) _then) = _$ReportMonumentDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String city, String district
});




}
/// @nodoc
class _$ReportMonumentDtoCopyWithImpl<$Res>
    implements $ReportMonumentDtoCopyWith<$Res> {
  _$ReportMonumentDtoCopyWithImpl(this._self, this._then);

  final ReportMonumentDto _self;
  final $Res Function(ReportMonumentDto) _then;

/// Create a copy of ReportMonumentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? city = null,Object? district = null,}) {
  return _then(ReportMonumentDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportMonumentDto].
extension ReportMonumentDtoPatterns on ReportMonumentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportMonumentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportMonumentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportMonumentDto value)  $default,){
final _that = this;
switch (_that) {
case _ReportMonumentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportMonumentDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReportMonumentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String city,  String district)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportMonumentDto() when $default != null:
return $default(_that.id,_that.name,_that.city,_that.district);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String city,  String district)  $default,) {final _that = this;
switch (_that) {
case _ReportMonumentDto():
return $default(_that.id,_that.name,_that.city,_that.district);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String city,  String district)?  $default,) {final _that = this;
switch (_that) {
case _ReportMonumentDto() when $default != null:
return $default(_that.id,_that.name,_that.city,_that.district);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportMonumentDto extends ReportMonumentDto {
  const _ReportMonumentDto({required this.id, required this.name, required this.city, required this.district}): super._();
  factory _ReportMonumentDto.fromJson(Map<String, dynamic> json) => _$ReportMonumentDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String city;
@override final  String district;

/// Create a copy of ReportMonumentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportMonumentDtoCopyWith<_ReportMonumentDto> get copyWith => __$ReportMonumentDtoCopyWithImpl<_ReportMonumentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportMonumentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportMonumentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,city,district);
}

@override
String toString() {
    return 'ReportMonumentDto(id: $id, name: $name, city: $city, district: $district)';
}


}

/// @nodoc
abstract mixin class _$ReportMonumentDtoCopyWith<$Res> implements $ReportMonumentDtoCopyWith<$Res> {
  factory _$ReportMonumentDtoCopyWith(_ReportMonumentDto value, $Res Function(_ReportMonumentDto) _then) = __$ReportMonumentDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String city, String district
});




}
/// @nodoc
class __$ReportMonumentDtoCopyWithImpl<$Res>
    implements _$ReportMonumentDtoCopyWith<$Res> {
  __$ReportMonumentDtoCopyWithImpl(this._self, this._then);

  final _ReportMonumentDto _self;
  final $Res Function(_ReportMonumentDto) _then;

/// Create a copy of ReportMonumentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? city = null,Object? district = null,}) {
  return _then(_ReportMonumentDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReportPhotoDto {

 String get id; String get url; String get thumbnailUrl; int get width; int get height; String? get description;
/// Create a copy of ReportPhotoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportPhotoDtoCopyWith<ReportPhotoDto> get copyWith => _$ReportPhotoDtoCopyWithImpl<ReportPhotoDto>(this as ReportPhotoDto, _$identity);

  /// Serializes this ReportPhotoDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportPhotoDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportPhotoDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.thumbnailUrl, _this.thumbnailUrl) || other.thumbnailUrl == _this.thumbnailUrl)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.height, _this.height) || other.height == _this.height)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportPhotoDto;
  return Object.hash(runtimeType,_this.id,_this.url,_this.thumbnailUrl,_this.width,_this.height,_this.description);
}

@override
String toString() {
  final _this = this as ReportPhotoDto;
  return 'ReportPhotoDto(id: ${_this.id}, url: ${_this.url}, thumbnailUrl: ${_this.thumbnailUrl}, width: ${_this.width}, height: ${_this.height}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $ReportPhotoDtoCopyWith<$Res>  {
  factory $ReportPhotoDtoCopyWith(ReportPhotoDto value, $Res Function(ReportPhotoDto) _then) = _$ReportPhotoDtoCopyWithImpl;
@useResult
$Res call({
 String id, String url, String thumbnailUrl, int width, int height, String? description
});




}
/// @nodoc
class _$ReportPhotoDtoCopyWithImpl<$Res>
    implements $ReportPhotoDtoCopyWith<$Res> {
  _$ReportPhotoDtoCopyWithImpl(this._self, this._then);

  final ReportPhotoDto _self;
  final $Res Function(ReportPhotoDto) _then;

/// Create a copy of ReportPhotoDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? thumbnailUrl = null,Object? width = null,Object? height = null,Object? description = freezed,}) {
  return _then(ReportPhotoDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportPhotoDto].
extension ReportPhotoDtoPatterns on ReportPhotoDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportPhotoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportPhotoDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportPhotoDto value)  $default,){
final _that = this;
switch (_that) {
case _ReportPhotoDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportPhotoDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReportPhotoDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String url,  String thumbnailUrl,  int width,  int height,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportPhotoDto() when $default != null:
return $default(_that.id,_that.url,_that.thumbnailUrl,_that.width,_that.height,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String url,  String thumbnailUrl,  int width,  int height,  String? description)  $default,) {final _that = this;
switch (_that) {
case _ReportPhotoDto():
return $default(_that.id,_that.url,_that.thumbnailUrl,_that.width,_that.height,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String url,  String thumbnailUrl,  int width,  int height,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _ReportPhotoDto() when $default != null:
return $default(_that.id,_that.url,_that.thumbnailUrl,_that.width,_that.height,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportPhotoDto extends ReportPhotoDto {
  const _ReportPhotoDto({required this.id, required this.url, required this.thumbnailUrl, required this.width, required this.height, this.description}): super._();
  factory _ReportPhotoDto.fromJson(Map<String, dynamic> json) => _$ReportPhotoDtoFromJson(json);

@override final  String id;
@override final  String url;
@override final  String thumbnailUrl;
@override final  int width;
@override final  int height;
@override final  String? description;

/// Create a copy of ReportPhotoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportPhotoDtoCopyWith<_ReportPhotoDto> get copyWith => __$ReportPhotoDtoCopyWithImpl<_ReportPhotoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportPhotoDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportPhotoDto&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,url,thumbnailUrl,width,height,description);
}

@override
String toString() {
    return 'ReportPhotoDto(id: $id, url: $url, thumbnailUrl: $thumbnailUrl, width: $width, height: $height, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ReportPhotoDtoCopyWith<$Res> implements $ReportPhotoDtoCopyWith<$Res> {
  factory _$ReportPhotoDtoCopyWith(_ReportPhotoDto value, $Res Function(_ReportPhotoDto) _then) = __$ReportPhotoDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String url, String thumbnailUrl, int width, int height, String? description
});




}
/// @nodoc
class __$ReportPhotoDtoCopyWithImpl<$Res>
    implements _$ReportPhotoDtoCopyWith<$Res> {
  __$ReportPhotoDtoCopyWithImpl(this._self, this._then);

  final _ReportPhotoDto _self;
  final $Res Function(_ReportPhotoDto) _then;

/// Create a copy of ReportPhotoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? thumbnailUrl = null,Object? width = null,Object? height = null,Object? description = freezed,}) {
  return _then(_ReportPhotoDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReportLocationCheckDto {

@JsonKey(unknownEnumValue: LocationVerification.notProvided) LocationVerification get verification; int? get distanceMeters;
/// Create a copy of ReportLocationCheckDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportLocationCheckDtoCopyWith<ReportLocationCheckDto> get copyWith => _$ReportLocationCheckDtoCopyWithImpl<ReportLocationCheckDto>(this as ReportLocationCheckDto, _$identity);

  /// Serializes this ReportLocationCheckDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportLocationCheckDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportLocationCheckDto&&(identical(other.verification, _this.verification) || other.verification == _this.verification)&&(identical(other.distanceMeters, _this.distanceMeters) || other.distanceMeters == _this.distanceMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportLocationCheckDto;
  return Object.hash(runtimeType,_this.verification,_this.distanceMeters);
}

@override
String toString() {
  final _this = this as ReportLocationCheckDto;
  return 'ReportLocationCheckDto(verification: ${_this.verification}, distanceMeters: ${_this.distanceMeters})';
}


}

/// @nodoc
abstract mixin class $ReportLocationCheckDtoCopyWith<$Res>  {
  factory $ReportLocationCheckDtoCopyWith(ReportLocationCheckDto value, $Res Function(ReportLocationCheckDto) _then) = _$ReportLocationCheckDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: LocationVerification.notProvided) LocationVerification verification, int? distanceMeters
});




}
/// @nodoc
class _$ReportLocationCheckDtoCopyWithImpl<$Res>
    implements $ReportLocationCheckDtoCopyWith<$Res> {
  _$ReportLocationCheckDtoCopyWithImpl(this._self, this._then);

  final ReportLocationCheckDto _self;
  final $Res Function(ReportLocationCheckDto) _then;

/// Create a copy of ReportLocationCheckDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? verification = null,Object? distanceMeters = freezed,}) {
  return _then(ReportLocationCheckDto(
verification: null == verification ? _self.verification : verification // ignore: cast_nullable_to_non_nullable
as LocationVerification,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportLocationCheckDto].
extension ReportLocationCheckDtoPatterns on ReportLocationCheckDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportLocationCheckDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportLocationCheckDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportLocationCheckDto value)  $default,){
final _that = this;
switch (_that) {
case _ReportLocationCheckDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportLocationCheckDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReportLocationCheckDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: LocationVerification.notProvided)  LocationVerification verification,  int? distanceMeters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportLocationCheckDto() when $default != null:
return $default(_that.verification,_that.distanceMeters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: LocationVerification.notProvided)  LocationVerification verification,  int? distanceMeters)  $default,) {final _that = this;
switch (_that) {
case _ReportLocationCheckDto():
return $default(_that.verification,_that.distanceMeters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: LocationVerification.notProvided)  LocationVerification verification,  int? distanceMeters)?  $default,) {final _that = this;
switch (_that) {
case _ReportLocationCheckDto() when $default != null:
return $default(_that.verification,_that.distanceMeters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportLocationCheckDto extends ReportLocationCheckDto {
  const _ReportLocationCheckDto({@JsonKey(unknownEnumValue: LocationVerification.notProvided) required this.verification, this.distanceMeters}): super._();
  factory _ReportLocationCheckDto.fromJson(Map<String, dynamic> json) => _$ReportLocationCheckDtoFromJson(json);

@override@JsonKey(unknownEnumValue: LocationVerification.notProvided) final  LocationVerification verification;
@override final  int? distanceMeters;

/// Create a copy of ReportLocationCheckDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportLocationCheckDtoCopyWith<_ReportLocationCheckDto> get copyWith => __$ReportLocationCheckDtoCopyWithImpl<_ReportLocationCheckDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportLocationCheckDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportLocationCheckDto&&(identical(other.verification, verification) || other.verification == verification)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,verification,distanceMeters);
}

@override
String toString() {
    return 'ReportLocationCheckDto(verification: $verification, distanceMeters: $distanceMeters)';
}


}

/// @nodoc
abstract mixin class _$ReportLocationCheckDtoCopyWith<$Res> implements $ReportLocationCheckDtoCopyWith<$Res> {
  factory _$ReportLocationCheckDtoCopyWith(_ReportLocationCheckDto value, $Res Function(_ReportLocationCheckDto) _then) = __$ReportLocationCheckDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: LocationVerification.notProvided) LocationVerification verification, int? distanceMeters
});




}
/// @nodoc
class __$ReportLocationCheckDtoCopyWithImpl<$Res>
    implements _$ReportLocationCheckDtoCopyWith<$Res> {
  __$ReportLocationCheckDtoCopyWithImpl(this._self, this._then);

  final _ReportLocationCheckDto _self;
  final $Res Function(_ReportLocationCheckDto) _then;

/// Create a copy of ReportLocationCheckDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? verification = null,Object? distanceMeters = freezed,}) {
  return _then(_ReportLocationCheckDto(
verification: null == verification ? _self.verification : verification // ignore: cast_nullable_to_non_nullable
as LocationVerification,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$DamageReportStatusChangeDto {

@JsonKey(unknownEnumValue: DamageReportStatus.inReview) DamageReportStatus get status; DateTime get at; String? get note;
/// Create a copy of DamageReportStatusChangeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DamageReportStatusChangeDtoCopyWith<DamageReportStatusChangeDto> get copyWith => _$DamageReportStatusChangeDtoCopyWithImpl<DamageReportStatusChangeDto>(this as DamageReportStatusChangeDto, _$identity);

  /// Serializes this DamageReportStatusChangeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DamageReportStatusChangeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DamageReportStatusChangeDto&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.note, _this.note) || other.note == _this.note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DamageReportStatusChangeDto;
  return Object.hash(runtimeType,_this.status,_this.at,_this.note);
}

@override
String toString() {
  final _this = this as DamageReportStatusChangeDto;
  return 'DamageReportStatusChangeDto(status: ${_this.status}, at: ${_this.at}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $DamageReportStatusChangeDtoCopyWith<$Res>  {
  factory $DamageReportStatusChangeDtoCopyWith(DamageReportStatusChangeDto value, $Res Function(DamageReportStatusChangeDto) _then) = _$DamageReportStatusChangeDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: DamageReportStatus.inReview) DamageReportStatus status, DateTime at, String? note
});




}
/// @nodoc
class _$DamageReportStatusChangeDtoCopyWithImpl<$Res>
    implements $DamageReportStatusChangeDtoCopyWith<$Res> {
  _$DamageReportStatusChangeDtoCopyWithImpl(this._self, this._then);

  final DamageReportStatusChangeDto _self;
  final $Res Function(DamageReportStatusChangeDto) _then;

/// Create a copy of DamageReportStatusChangeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? at = null,Object? note = freezed,}) {
  return _then(DamageReportStatusChangeDto(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DamageReportStatus,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DamageReportStatusChangeDto].
extension DamageReportStatusChangeDtoPatterns on DamageReportStatusChangeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DamageReportStatusChangeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DamageReportStatusChangeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DamageReportStatusChangeDto value)  $default,){
final _that = this;
switch (_that) {
case _DamageReportStatusChangeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DamageReportStatusChangeDto value)?  $default,){
final _that = this;
switch (_that) {
case _DamageReportStatusChangeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: DamageReportStatus.inReview)  DamageReportStatus status,  DateTime at,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DamageReportStatusChangeDto() when $default != null:
return $default(_that.status,_that.at,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: DamageReportStatus.inReview)  DamageReportStatus status,  DateTime at,  String? note)  $default,) {final _that = this;
switch (_that) {
case _DamageReportStatusChangeDto():
return $default(_that.status,_that.at,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: DamageReportStatus.inReview)  DamageReportStatus status,  DateTime at,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _DamageReportStatusChangeDto() when $default != null:
return $default(_that.status,_that.at,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DamageReportStatusChangeDto extends DamageReportStatusChangeDto {
  const _DamageReportStatusChangeDto({@JsonKey(unknownEnumValue: DamageReportStatus.inReview) required this.status, required this.at, this.note}): super._();
  factory _DamageReportStatusChangeDto.fromJson(Map<String, dynamic> json) => _$DamageReportStatusChangeDtoFromJson(json);

@override@JsonKey(unknownEnumValue: DamageReportStatus.inReview) final  DamageReportStatus status;
@override final  DateTime at;
@override final  String? note;

/// Create a copy of DamageReportStatusChangeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DamageReportStatusChangeDtoCopyWith<_DamageReportStatusChangeDto> get copyWith => __$DamageReportStatusChangeDtoCopyWithImpl<_DamageReportStatusChangeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DamageReportStatusChangeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DamageReportStatusChangeDto&&(identical(other.status, status) || other.status == status)&&(identical(other.at, at) || other.at == at)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,at,note);
}

@override
String toString() {
    return 'DamageReportStatusChangeDto(status: $status, at: $at, note: $note)';
}


}

/// @nodoc
abstract mixin class _$DamageReportStatusChangeDtoCopyWith<$Res> implements $DamageReportStatusChangeDtoCopyWith<$Res> {
  factory _$DamageReportStatusChangeDtoCopyWith(_DamageReportStatusChangeDto value, $Res Function(_DamageReportStatusChangeDto) _then) = __$DamageReportStatusChangeDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: DamageReportStatus.inReview) DamageReportStatus status, DateTime at, String? note
});




}
/// @nodoc
class __$DamageReportStatusChangeDtoCopyWithImpl<$Res>
    implements _$DamageReportStatusChangeDtoCopyWith<$Res> {
  __$DamageReportStatusChangeDtoCopyWithImpl(this._self, this._then);

  final _DamageReportStatusChangeDto _self;
  final $Res Function(_DamageReportStatusChangeDto) _then;

/// Create a copy of DamageReportStatusChangeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? at = null,Object? note = freezed,}) {
  return _then(_DamageReportStatusChangeDto(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DamageReportStatus,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DamageReportDto {

 String get id; String get referenceCode; ReportMonumentDto get monument;@JsonKey(unknownEnumValue: DamageCategory.other) DamageCategory get category;@JsonKey(unknownEnumValue: ReportUrgency.medium) ReportUrgency get urgency; String get description; ReportLocationCheckDto get locationCheck;@JsonKey(unknownEnumValue: DamageReportStatus.inReview) DamageReportStatus get status; DateTime get createdAt; List<ReportPhotoDto> get photos; List<DamageReportStatusChangeDto> get history;
/// Create a copy of DamageReportDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DamageReportDtoCopyWith<DamageReportDto> get copyWith => _$DamageReportDtoCopyWithImpl<DamageReportDto>(this as DamageReportDto, _$identity);

  /// Serializes this DamageReportDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DamageReportDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DamageReportDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.referenceCode, _this.referenceCode) || other.referenceCode == _this.referenceCode)&&(identical(other.monument, _this.monument) || other.monument == _this.monument)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.urgency, _this.urgency) || other.urgency == _this.urgency)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.locationCheck, _this.locationCheck) || other.locationCheck == _this.locationCheck)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.photos, _this.photos)&&const DeepCollectionEquality().equals(other.history, _this.history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DamageReportDto;
  return Object.hash(runtimeType,_this.id,_this.referenceCode,_this.monument,_this.category,_this.urgency,_this.description,_this.locationCheck,_this.status,_this.createdAt,const DeepCollectionEquality().hash(_this.photos),const DeepCollectionEquality().hash(_this.history));
}

@override
String toString() {
  final _this = this as DamageReportDto;
  return 'DamageReportDto(id: ${_this.id}, referenceCode: ${_this.referenceCode}, monument: ${_this.monument}, category: ${_this.category}, urgency: ${_this.urgency}, description: ${_this.description}, locationCheck: ${_this.locationCheck}, status: ${_this.status}, createdAt: ${_this.createdAt}, photos: ${_this.photos}, history: ${_this.history})';
}


}

/// @nodoc
abstract mixin class $DamageReportDtoCopyWith<$Res>  {
  factory $DamageReportDtoCopyWith(DamageReportDto value, $Res Function(DamageReportDto) _then) = _$DamageReportDtoCopyWithImpl;
@useResult
$Res call({
 String id, String referenceCode, ReportMonumentDto monument,@JsonKey(unknownEnumValue: DamageCategory.other) DamageCategory category,@JsonKey(unknownEnumValue: ReportUrgency.medium) ReportUrgency urgency, String description, ReportLocationCheckDto locationCheck,@JsonKey(unknownEnumValue: DamageReportStatus.inReview) DamageReportStatus status, DateTime createdAt, List<ReportPhotoDto> photos, List<DamageReportStatusChangeDto> history
});


$ReportMonumentDtoCopyWith<$Res> get monument;$ReportLocationCheckDtoCopyWith<$Res> get locationCheck;

}
/// @nodoc
class _$DamageReportDtoCopyWithImpl<$Res>
    implements $DamageReportDtoCopyWith<$Res> {
  _$DamageReportDtoCopyWithImpl(this._self, this._then);

  final DamageReportDto _self;
  final $Res Function(DamageReportDto) _then;

/// Create a copy of DamageReportDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? referenceCode = null,Object? monument = null,Object? category = null,Object? urgency = null,Object? description = null,Object? locationCheck = null,Object? status = null,Object? createdAt = null,Object? photos = null,Object? history = null,}) {
  return _then(DamageReportDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referenceCode: null == referenceCode ? _self.referenceCode : referenceCode // ignore: cast_nullable_to_non_nullable
as String,monument: null == monument ? _self.monument : monument // ignore: cast_nullable_to_non_nullable
as ReportMonumentDto,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DamageCategory,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as ReportUrgency,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,locationCheck: null == locationCheck ? _self.locationCheck : locationCheck // ignore: cast_nullable_to_non_nullable
as ReportLocationCheckDto,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DamageReportStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<ReportPhotoDto>,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<DamageReportStatusChangeDto>,
  ));
}
/// Create a copy of DamageReportDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportMonumentDtoCopyWith<$Res> get monument {
  
  return $ReportMonumentDtoCopyWith<$Res>(_self.monument, (value) {
    return _then(_self.copyWith(monument: value));
  });
}/// Create a copy of DamageReportDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportLocationCheckDtoCopyWith<$Res> get locationCheck {
  
  return $ReportLocationCheckDtoCopyWith<$Res>(_self.locationCheck, (value) {
    return _then(_self.copyWith(locationCheck: value));
  });
}
}


/// Adds pattern-matching-related methods to [DamageReportDto].
extension DamageReportDtoPatterns on DamageReportDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DamageReportDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DamageReportDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DamageReportDto value)  $default,){
final _that = this;
switch (_that) {
case _DamageReportDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DamageReportDto value)?  $default,){
final _that = this;
switch (_that) {
case _DamageReportDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String referenceCode,  ReportMonumentDto monument, @JsonKey(unknownEnumValue: DamageCategory.other)  DamageCategory category, @JsonKey(unknownEnumValue: ReportUrgency.medium)  ReportUrgency urgency,  String description,  ReportLocationCheckDto locationCheck, @JsonKey(unknownEnumValue: DamageReportStatus.inReview)  DamageReportStatus status,  DateTime createdAt,  List<ReportPhotoDto> photos,  List<DamageReportStatusChangeDto> history)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DamageReportDto() when $default != null:
return $default(_that.id,_that.referenceCode,_that.monument,_that.category,_that.urgency,_that.description,_that.locationCheck,_that.status,_that.createdAt,_that.photos,_that.history);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String referenceCode,  ReportMonumentDto monument, @JsonKey(unknownEnumValue: DamageCategory.other)  DamageCategory category, @JsonKey(unknownEnumValue: ReportUrgency.medium)  ReportUrgency urgency,  String description,  ReportLocationCheckDto locationCheck, @JsonKey(unknownEnumValue: DamageReportStatus.inReview)  DamageReportStatus status,  DateTime createdAt,  List<ReportPhotoDto> photos,  List<DamageReportStatusChangeDto> history)  $default,) {final _that = this;
switch (_that) {
case _DamageReportDto():
return $default(_that.id,_that.referenceCode,_that.monument,_that.category,_that.urgency,_that.description,_that.locationCheck,_that.status,_that.createdAt,_that.photos,_that.history);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String referenceCode,  ReportMonumentDto monument, @JsonKey(unknownEnumValue: DamageCategory.other)  DamageCategory category, @JsonKey(unknownEnumValue: ReportUrgency.medium)  ReportUrgency urgency,  String description,  ReportLocationCheckDto locationCheck, @JsonKey(unknownEnumValue: DamageReportStatus.inReview)  DamageReportStatus status,  DateTime createdAt,  List<ReportPhotoDto> photos,  List<DamageReportStatusChangeDto> history)?  $default,) {final _that = this;
switch (_that) {
case _DamageReportDto() when $default != null:
return $default(_that.id,_that.referenceCode,_that.monument,_that.category,_that.urgency,_that.description,_that.locationCheck,_that.status,_that.createdAt,_that.photos,_that.history);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DamageReportDto extends DamageReportDto {
  const _DamageReportDto({required this.id, required this.referenceCode, required this.monument, @JsonKey(unknownEnumValue: DamageCategory.other) required this.category, @JsonKey(unknownEnumValue: ReportUrgency.medium) required this.urgency, required this.description, required this.locationCheck, @JsonKey(unknownEnumValue: DamageReportStatus.inReview) required this.status, required this.createdAt,  List<ReportPhotoDto> photos = const <ReportPhotoDto>[],  List<DamageReportStatusChangeDto> history = const <DamageReportStatusChangeDto>[]}): _photos = photos,_history = history,super._();
  factory _DamageReportDto.fromJson(Map<String, dynamic> json) => _$DamageReportDtoFromJson(json);

@override final  String id;
@override final  String referenceCode;
@override final  ReportMonumentDto monument;
@override@JsonKey(unknownEnumValue: DamageCategory.other) final  DamageCategory category;
@override@JsonKey(unknownEnumValue: ReportUrgency.medium) final  ReportUrgency urgency;
@override final  String description;
@override final  ReportLocationCheckDto locationCheck;
@override@JsonKey(unknownEnumValue: DamageReportStatus.inReview) final  DamageReportStatus status;
@override final  DateTime createdAt;
 final  List<ReportPhotoDto> _photos;
@override@JsonKey() List<ReportPhotoDto> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

 final  List<DamageReportStatusChangeDto> _history;
@override@JsonKey() List<DamageReportStatusChangeDto> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of DamageReportDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DamageReportDtoCopyWith<_DamageReportDto> get copyWith => __$DamageReportDtoCopyWithImpl<_DamageReportDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DamageReportDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DamageReportDto&&(identical(other.id, id) || other.id == id)&&(identical(other.referenceCode, referenceCode) || other.referenceCode == referenceCode)&&(identical(other.monument, monument) || other.monument == monument)&&(identical(other.category, category) || other.category == category)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.description, description) || other.description == description)&&(identical(other.locationCheck, locationCheck) || other.locationCheck == locationCheck)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.photos, _photos)&&const DeepCollectionEquality().equals(other.history, _history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,referenceCode,monument,category,urgency,description,locationCheck,status,createdAt,const DeepCollectionEquality().hash(_photos),const DeepCollectionEquality().hash(_history));
}

@override
String toString() {
    return 'DamageReportDto(id: $id, referenceCode: $referenceCode, monument: $monument, category: $category, urgency: $urgency, description: $description, locationCheck: $locationCheck, status: $status, createdAt: $createdAt, photos: $photos, history: $history)';
}


}

/// @nodoc
abstract mixin class _$DamageReportDtoCopyWith<$Res> implements $DamageReportDtoCopyWith<$Res> {
  factory _$DamageReportDtoCopyWith(_DamageReportDto value, $Res Function(_DamageReportDto) _then) = __$DamageReportDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String referenceCode, ReportMonumentDto monument,@JsonKey(unknownEnumValue: DamageCategory.other) DamageCategory category,@JsonKey(unknownEnumValue: ReportUrgency.medium) ReportUrgency urgency, String description, ReportLocationCheckDto locationCheck,@JsonKey(unknownEnumValue: DamageReportStatus.inReview) DamageReportStatus status, DateTime createdAt, List<ReportPhotoDto> photos, List<DamageReportStatusChangeDto> history
});


@override $ReportMonumentDtoCopyWith<$Res> get monument;@override $ReportLocationCheckDtoCopyWith<$Res> get locationCheck;

}
/// @nodoc
class __$DamageReportDtoCopyWithImpl<$Res>
    implements _$DamageReportDtoCopyWith<$Res> {
  __$DamageReportDtoCopyWithImpl(this._self, this._then);

  final _DamageReportDto _self;
  final $Res Function(_DamageReportDto) _then;

/// Create a copy of DamageReportDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? referenceCode = null,Object? monument = null,Object? category = null,Object? urgency = null,Object? description = null,Object? locationCheck = null,Object? status = null,Object? createdAt = null,Object? photos = null,Object? history = null,}) {
  return _then(_DamageReportDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referenceCode: null == referenceCode ? _self.referenceCode : referenceCode // ignore: cast_nullable_to_non_nullable
as String,monument: null == monument ? _self.monument : monument // ignore: cast_nullable_to_non_nullable
as ReportMonumentDto,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DamageCategory,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as ReportUrgency,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,locationCheck: null == locationCheck ? _self.locationCheck : locationCheck // ignore: cast_nullable_to_non_nullable
as ReportLocationCheckDto,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DamageReportStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<ReportPhotoDto>,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<DamageReportStatusChangeDto>,
  ));
}

/// Create a copy of DamageReportDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportMonumentDtoCopyWith<$Res> get monument {
  
  return $ReportMonumentDtoCopyWith<$Res>(_self.monument, (value) {
    return _then(_self.copyWith(monument: value));
  });
}/// Create a copy of DamageReportDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportLocationCheckDtoCopyWith<$Res> get locationCheck {
  
  return $ReportLocationCheckDtoCopyWith<$Res>(_self.locationCheck, (value) {
    return _then(_self.copyWith(locationCheck: value));
  });
}
}


/// @nodoc
mixin _$DamageReportPageDto {

 List<DamageReportDto> get items; int get total; String? get nextCursor;
/// Create a copy of DamageReportPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DamageReportPageDtoCopyWith<DamageReportPageDto> get copyWith => _$DamageReportPageDtoCopyWithImpl<DamageReportPageDto>(this as DamageReportPageDto, _$identity);

  /// Serializes this DamageReportPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DamageReportPageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DamageReportPageDto&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DamageReportPageDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.total,_this.nextCursor);
}

@override
String toString() {
  final _this = this as DamageReportPageDto;
  return 'DamageReportPageDto(items: ${_this.items}, total: ${_this.total}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $DamageReportPageDtoCopyWith<$Res>  {
  factory $DamageReportPageDtoCopyWith(DamageReportPageDto value, $Res Function(DamageReportPageDto) _then) = _$DamageReportPageDtoCopyWithImpl;
@useResult
$Res call({
 List<DamageReportDto> items, int total, String? nextCursor
});




}
/// @nodoc
class _$DamageReportPageDtoCopyWithImpl<$Res>
    implements $DamageReportPageDtoCopyWith<$Res> {
  _$DamageReportPageDtoCopyWithImpl(this._self, this._then);

  final DamageReportPageDto _self;
  final $Res Function(DamageReportPageDto) _then;

/// Create a copy of DamageReportPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? nextCursor = freezed,}) {
  return _then(DamageReportPageDto(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DamageReportDto>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DamageReportPageDto].
extension DamageReportPageDtoPatterns on DamageReportPageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DamageReportPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DamageReportPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DamageReportPageDto value)  $default,){
final _that = this;
switch (_that) {
case _DamageReportPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DamageReportPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _DamageReportPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DamageReportDto> items,  int total,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DamageReportPageDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DamageReportDto> items,  int total,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _DamageReportPageDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DamageReportDto> items,  int total,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _DamageReportPageDto() when $default != null:
return $default(_that.items,_that.total,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DamageReportPageDto extends DamageReportPageDto {
  const _DamageReportPageDto({required  List<DamageReportDto> items, required this.total, this.nextCursor}): _items = items,super._();
  factory _DamageReportPageDto.fromJson(Map<String, dynamic> json) => _$DamageReportPageDtoFromJson(json);

 final  List<DamageReportDto> _items;
@override List<DamageReportDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int total;
@override final  String? nextCursor;

/// Create a copy of DamageReportPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DamageReportPageDtoCopyWith<_DamageReportPageDto> get copyWith => __$DamageReportPageDtoCopyWithImpl<_DamageReportPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DamageReportPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DamageReportPageDto&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,nextCursor);
}

@override
String toString() {
    return 'DamageReportPageDto(items: $items, total: $total, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$DamageReportPageDtoCopyWith<$Res> implements $DamageReportPageDtoCopyWith<$Res> {
  factory _$DamageReportPageDtoCopyWith(_DamageReportPageDto value, $Res Function(_DamageReportPageDto) _then) = __$DamageReportPageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<DamageReportDto> items, int total, String? nextCursor
});




}
/// @nodoc
class __$DamageReportPageDtoCopyWithImpl<$Res>
    implements _$DamageReportPageDtoCopyWith<$Res> {
  __$DamageReportPageDtoCopyWithImpl(this._self, this._then);

  final _DamageReportPageDto _self;
  final $Res Function(_DamageReportPageDto) _then;

/// Create a copy of DamageReportPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? nextCursor = freezed,}) {
  return _then(_DamageReportPageDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DamageReportDto>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReportPhotoUploadRequestDto {

 String get contentType; int get byteSize; int get width; int get height;
/// Create a copy of ReportPhotoUploadRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportPhotoUploadRequestDtoCopyWith<ReportPhotoUploadRequestDto> get copyWith => _$ReportPhotoUploadRequestDtoCopyWithImpl<ReportPhotoUploadRequestDto>(this as ReportPhotoUploadRequestDto, _$identity);

  /// Serializes this ReportPhotoUploadRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportPhotoUploadRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportPhotoUploadRequestDto&&(identical(other.contentType, _this.contentType) || other.contentType == _this.contentType)&&(identical(other.byteSize, _this.byteSize) || other.byteSize == _this.byteSize)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.height, _this.height) || other.height == _this.height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportPhotoUploadRequestDto;
  return Object.hash(runtimeType,_this.contentType,_this.byteSize,_this.width,_this.height);
}

@override
String toString() {
  final _this = this as ReportPhotoUploadRequestDto;
  return 'ReportPhotoUploadRequestDto(contentType: ${_this.contentType}, byteSize: ${_this.byteSize}, width: ${_this.width}, height: ${_this.height})';
}


}

/// @nodoc
abstract mixin class $ReportPhotoUploadRequestDtoCopyWith<$Res>  {
  factory $ReportPhotoUploadRequestDtoCopyWith(ReportPhotoUploadRequestDto value, $Res Function(ReportPhotoUploadRequestDto) _then) = _$ReportPhotoUploadRequestDtoCopyWithImpl;
@useResult
$Res call({
 String contentType, int byteSize, int width, int height
});




}
/// @nodoc
class _$ReportPhotoUploadRequestDtoCopyWithImpl<$Res>
    implements $ReportPhotoUploadRequestDtoCopyWith<$Res> {
  _$ReportPhotoUploadRequestDtoCopyWithImpl(this._self, this._then);

  final ReportPhotoUploadRequestDto _self;
  final $Res Function(ReportPhotoUploadRequestDto) _then;

/// Create a copy of ReportPhotoUploadRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contentType = null,Object? byteSize = null,Object? width = null,Object? height = null,}) {
  return _then(ReportPhotoUploadRequestDto(
contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportPhotoUploadRequestDto].
extension ReportPhotoUploadRequestDtoPatterns on ReportPhotoUploadRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportPhotoUploadRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportPhotoUploadRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportPhotoUploadRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _ReportPhotoUploadRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportPhotoUploadRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReportPhotoUploadRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contentType,  int byteSize,  int width,  int height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportPhotoUploadRequestDto() when $default != null:
return $default(_that.contentType,_that.byteSize,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contentType,  int byteSize,  int width,  int height)  $default,) {final _that = this;
switch (_that) {
case _ReportPhotoUploadRequestDto():
return $default(_that.contentType,_that.byteSize,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contentType,  int byteSize,  int width,  int height)?  $default,) {final _that = this;
switch (_that) {
case _ReportPhotoUploadRequestDto() when $default != null:
return $default(_that.contentType,_that.byteSize,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportPhotoUploadRequestDto implements ReportPhotoUploadRequestDto {
  const _ReportPhotoUploadRequestDto({required this.contentType, required this.byteSize, required this.width, required this.height});
  factory _ReportPhotoUploadRequestDto.fromJson(Map<String, dynamic> json) => _$ReportPhotoUploadRequestDtoFromJson(json);

@override final  String contentType;
@override final  int byteSize;
@override final  int width;
@override final  int height;

/// Create a copy of ReportPhotoUploadRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportPhotoUploadRequestDtoCopyWith<_ReportPhotoUploadRequestDto> get copyWith => __$ReportPhotoUploadRequestDtoCopyWithImpl<_ReportPhotoUploadRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportPhotoUploadRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportPhotoUploadRequestDto&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,contentType,byteSize,width,height);
}

@override
String toString() {
    return 'ReportPhotoUploadRequestDto(contentType: $contentType, byteSize: $byteSize, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$ReportPhotoUploadRequestDtoCopyWith<$Res> implements $ReportPhotoUploadRequestDtoCopyWith<$Res> {
  factory _$ReportPhotoUploadRequestDtoCopyWith(_ReportPhotoUploadRequestDto value, $Res Function(_ReportPhotoUploadRequestDto) _then) = __$ReportPhotoUploadRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String contentType, int byteSize, int width, int height
});




}
/// @nodoc
class __$ReportPhotoUploadRequestDtoCopyWithImpl<$Res>
    implements _$ReportPhotoUploadRequestDtoCopyWith<$Res> {
  __$ReportPhotoUploadRequestDtoCopyWithImpl(this._self, this._then);

  final _ReportPhotoUploadRequestDto _self;
  final $Res Function(_ReportPhotoUploadRequestDto) _then;

/// Create a copy of ReportPhotoUploadRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contentType = null,Object? byteSize = null,Object? width = null,Object? height = null,}) {
  return _then(_ReportPhotoUploadRequestDto(
contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ReportPhotoUploadTicketDto {

 String get id; String get uploadUrl; DateTime get expiresAt; Map<String, String> get uploadHeaders;
/// Create a copy of ReportPhotoUploadTicketDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportPhotoUploadTicketDtoCopyWith<ReportPhotoUploadTicketDto> get copyWith => _$ReportPhotoUploadTicketDtoCopyWithImpl<ReportPhotoUploadTicketDto>(this as ReportPhotoUploadTicketDto, _$identity);

  /// Serializes this ReportPhotoUploadTicketDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportPhotoUploadTicketDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportPhotoUploadTicketDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.uploadUrl, _this.uploadUrl) || other.uploadUrl == _this.uploadUrl)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&const DeepCollectionEquality().equals(other.uploadHeaders, _this.uploadHeaders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportPhotoUploadTicketDto;
  return Object.hash(runtimeType,_this.id,_this.uploadUrl,_this.expiresAt,const DeepCollectionEquality().hash(_this.uploadHeaders));
}

@override
String toString() {
  final _this = this as ReportPhotoUploadTicketDto;
  return 'ReportPhotoUploadTicketDto(id: ${_this.id}, uploadUrl: ${_this.uploadUrl}, expiresAt: ${_this.expiresAt}, uploadHeaders: ${_this.uploadHeaders})';
}


}

/// @nodoc
abstract mixin class $ReportPhotoUploadTicketDtoCopyWith<$Res>  {
  factory $ReportPhotoUploadTicketDtoCopyWith(ReportPhotoUploadTicketDto value, $Res Function(ReportPhotoUploadTicketDto) _then) = _$ReportPhotoUploadTicketDtoCopyWithImpl;
@useResult
$Res call({
 String id, String uploadUrl, DateTime expiresAt, Map<String, String> uploadHeaders
});




}
/// @nodoc
class _$ReportPhotoUploadTicketDtoCopyWithImpl<$Res>
    implements $ReportPhotoUploadTicketDtoCopyWith<$Res> {
  _$ReportPhotoUploadTicketDtoCopyWithImpl(this._self, this._then);

  final ReportPhotoUploadTicketDto _self;
  final $Res Function(ReportPhotoUploadTicketDto) _then;

/// Create a copy of ReportPhotoUploadTicketDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uploadUrl = null,Object? expiresAt = null,Object? uploadHeaders = null,}) {
  return _then(ReportPhotoUploadTicketDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,uploadHeaders: null == uploadHeaders ? _self.uploadHeaders : uploadHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportPhotoUploadTicketDto].
extension ReportPhotoUploadTicketDtoPatterns on ReportPhotoUploadTicketDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportPhotoUploadTicketDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportPhotoUploadTicketDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportPhotoUploadTicketDto value)  $default,){
final _that = this;
switch (_that) {
case _ReportPhotoUploadTicketDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportPhotoUploadTicketDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReportPhotoUploadTicketDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String uploadUrl,  DateTime expiresAt,  Map<String, String> uploadHeaders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportPhotoUploadTicketDto() when $default != null:
return $default(_that.id,_that.uploadUrl,_that.expiresAt,_that.uploadHeaders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String uploadUrl,  DateTime expiresAt,  Map<String, String> uploadHeaders)  $default,) {final _that = this;
switch (_that) {
case _ReportPhotoUploadTicketDto():
return $default(_that.id,_that.uploadUrl,_that.expiresAt,_that.uploadHeaders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String uploadUrl,  DateTime expiresAt,  Map<String, String> uploadHeaders)?  $default,) {final _that = this;
switch (_that) {
case _ReportPhotoUploadTicketDto() when $default != null:
return $default(_that.id,_that.uploadUrl,_that.expiresAt,_that.uploadHeaders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportPhotoUploadTicketDto implements ReportPhotoUploadTicketDto {
  const _ReportPhotoUploadTicketDto({required this.id, required this.uploadUrl, required this.expiresAt,  Map<String, String> uploadHeaders = const <String, String>{}}): _uploadHeaders = uploadHeaders;
  factory _ReportPhotoUploadTicketDto.fromJson(Map<String, dynamic> json) => _$ReportPhotoUploadTicketDtoFromJson(json);

@override final  String id;
@override final  String uploadUrl;
@override final  DateTime expiresAt;
 final  Map<String, String> _uploadHeaders;
@override@JsonKey() Map<String, String> get uploadHeaders {
  if (_uploadHeaders is EqualUnmodifiableMapView) return _uploadHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_uploadHeaders);
}


/// Create a copy of ReportPhotoUploadTicketDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportPhotoUploadTicketDtoCopyWith<_ReportPhotoUploadTicketDto> get copyWith => __$ReportPhotoUploadTicketDtoCopyWithImpl<_ReportPhotoUploadTicketDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportPhotoUploadTicketDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportPhotoUploadTicketDto&&(identical(other.id, id) || other.id == id)&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other.uploadHeaders, _uploadHeaders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,uploadUrl,expiresAt,const DeepCollectionEquality().hash(_uploadHeaders));
}

@override
String toString() {
    return 'ReportPhotoUploadTicketDto(id: $id, uploadUrl: $uploadUrl, expiresAt: $expiresAt, uploadHeaders: $uploadHeaders)';
}


}

/// @nodoc
abstract mixin class _$ReportPhotoUploadTicketDtoCopyWith<$Res> implements $ReportPhotoUploadTicketDtoCopyWith<$Res> {
  factory _$ReportPhotoUploadTicketDtoCopyWith(_ReportPhotoUploadTicketDto value, $Res Function(_ReportPhotoUploadTicketDto) _then) = __$ReportPhotoUploadTicketDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String uploadUrl, DateTime expiresAt, Map<String, String> uploadHeaders
});




}
/// @nodoc
class __$ReportPhotoUploadTicketDtoCopyWithImpl<$Res>
    implements _$ReportPhotoUploadTicketDtoCopyWith<$Res> {
  __$ReportPhotoUploadTicketDtoCopyWithImpl(this._self, this._then);

  final _ReportPhotoUploadTicketDto _self;
  final $Res Function(_ReportPhotoUploadTicketDto) _then;

/// Create a copy of ReportPhotoUploadTicketDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uploadUrl = null,Object? expiresAt = null,Object? uploadHeaders = null,}) {
  return _then(_ReportPhotoUploadTicketDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,uploadHeaders: null == uploadHeaders ? _self._uploadHeaders : uploadHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$ReportPhotoAttachmentDto {

 String get uploadId;@JsonKey(includeIfNull: false) String? get description;
/// Create a copy of ReportPhotoAttachmentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportPhotoAttachmentDtoCopyWith<ReportPhotoAttachmentDto> get copyWith => _$ReportPhotoAttachmentDtoCopyWithImpl<ReportPhotoAttachmentDto>(this as ReportPhotoAttachmentDto, _$identity);

  /// Serializes this ReportPhotoAttachmentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportPhotoAttachmentDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportPhotoAttachmentDto&&(identical(other.uploadId, _this.uploadId) || other.uploadId == _this.uploadId)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportPhotoAttachmentDto;
  return Object.hash(runtimeType,_this.uploadId,_this.description);
}

@override
String toString() {
  final _this = this as ReportPhotoAttachmentDto;
  return 'ReportPhotoAttachmentDto(uploadId: ${_this.uploadId}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $ReportPhotoAttachmentDtoCopyWith<$Res>  {
  factory $ReportPhotoAttachmentDtoCopyWith(ReportPhotoAttachmentDto value, $Res Function(ReportPhotoAttachmentDto) _then) = _$ReportPhotoAttachmentDtoCopyWithImpl;
@useResult
$Res call({
 String uploadId,@JsonKey(includeIfNull: false) String? description
});




}
/// @nodoc
class _$ReportPhotoAttachmentDtoCopyWithImpl<$Res>
    implements $ReportPhotoAttachmentDtoCopyWith<$Res> {
  _$ReportPhotoAttachmentDtoCopyWithImpl(this._self, this._then);

  final ReportPhotoAttachmentDto _self;
  final $Res Function(ReportPhotoAttachmentDto) _then;

/// Create a copy of ReportPhotoAttachmentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uploadId = null,Object? description = freezed,}) {
  return _then(ReportPhotoAttachmentDto(
uploadId: null == uploadId ? _self.uploadId : uploadId // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportPhotoAttachmentDto].
extension ReportPhotoAttachmentDtoPatterns on ReportPhotoAttachmentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportPhotoAttachmentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportPhotoAttachmentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportPhotoAttachmentDto value)  $default,){
final _that = this;
switch (_that) {
case _ReportPhotoAttachmentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportPhotoAttachmentDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReportPhotoAttachmentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uploadId, @JsonKey(includeIfNull: false)  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportPhotoAttachmentDto() when $default != null:
return $default(_that.uploadId,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uploadId, @JsonKey(includeIfNull: false)  String? description)  $default,) {final _that = this;
switch (_that) {
case _ReportPhotoAttachmentDto():
return $default(_that.uploadId,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uploadId, @JsonKey(includeIfNull: false)  String? description)?  $default,) {final _that = this;
switch (_that) {
case _ReportPhotoAttachmentDto() when $default != null:
return $default(_that.uploadId,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportPhotoAttachmentDto implements ReportPhotoAttachmentDto {
  const _ReportPhotoAttachmentDto({required this.uploadId, @JsonKey(includeIfNull: false) this.description});
  factory _ReportPhotoAttachmentDto.fromJson(Map<String, dynamic> json) => _$ReportPhotoAttachmentDtoFromJson(json);

@override final  String uploadId;
@override@JsonKey(includeIfNull: false) final  String? description;

/// Create a copy of ReportPhotoAttachmentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportPhotoAttachmentDtoCopyWith<_ReportPhotoAttachmentDto> get copyWith => __$ReportPhotoAttachmentDtoCopyWithImpl<_ReportPhotoAttachmentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportPhotoAttachmentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportPhotoAttachmentDto&&(identical(other.uploadId, uploadId) || other.uploadId == uploadId)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,uploadId,description);
}

@override
String toString() {
    return 'ReportPhotoAttachmentDto(uploadId: $uploadId, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ReportPhotoAttachmentDtoCopyWith<$Res> implements $ReportPhotoAttachmentDtoCopyWith<$Res> {
  factory _$ReportPhotoAttachmentDtoCopyWith(_ReportPhotoAttachmentDto value, $Res Function(_ReportPhotoAttachmentDto) _then) = __$ReportPhotoAttachmentDtoCopyWithImpl;
@override @useResult
$Res call({
 String uploadId,@JsonKey(includeIfNull: false) String? description
});




}
/// @nodoc
class __$ReportPhotoAttachmentDtoCopyWithImpl<$Res>
    implements _$ReportPhotoAttachmentDtoCopyWith<$Res> {
  __$ReportPhotoAttachmentDtoCopyWithImpl(this._self, this._then);

  final _ReportPhotoAttachmentDto _self;
  final $Res Function(_ReportPhotoAttachmentDto) _then;

/// Create a copy of ReportPhotoAttachmentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uploadId = null,Object? description = freezed,}) {
  return _then(_ReportPhotoAttachmentDto(
uploadId: null == uploadId ? _self.uploadId : uploadId // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReportLocationDto {

 double get latitude; double get longitude; double get accuracyMeters;
/// Create a copy of ReportLocationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportLocationDtoCopyWith<ReportLocationDto> get copyWith => _$ReportLocationDtoCopyWithImpl<ReportLocationDto>(this as ReportLocationDto, _$identity);

  /// Serializes this ReportLocationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportLocationDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportLocationDto&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.accuracyMeters, _this.accuracyMeters) || other.accuracyMeters == _this.accuracyMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportLocationDto;
  return Object.hash(runtimeType,_this.latitude,_this.longitude,_this.accuracyMeters);
}

@override
String toString() {
  final _this = this as ReportLocationDto;
  return 'ReportLocationDto(latitude: ${_this.latitude}, longitude: ${_this.longitude}, accuracyMeters: ${_this.accuracyMeters})';
}


}

/// @nodoc
abstract mixin class $ReportLocationDtoCopyWith<$Res>  {
  factory $ReportLocationDtoCopyWith(ReportLocationDto value, $Res Function(ReportLocationDto) _then) = _$ReportLocationDtoCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, double accuracyMeters
});




}
/// @nodoc
class _$ReportLocationDtoCopyWithImpl<$Res>
    implements $ReportLocationDtoCopyWith<$Res> {
  _$ReportLocationDtoCopyWithImpl(this._self, this._then);

  final ReportLocationDto _self;
  final $Res Function(ReportLocationDto) _then;

/// Create a copy of ReportLocationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? accuracyMeters = null,}) {
  return _then(ReportLocationDto(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracyMeters: null == accuracyMeters ? _self.accuracyMeters : accuracyMeters // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportLocationDto].
extension ReportLocationDtoPatterns on ReportLocationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportLocationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportLocationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportLocationDto value)  $default,){
final _that = this;
switch (_that) {
case _ReportLocationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportLocationDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReportLocationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double accuracyMeters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportLocationDto() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracyMeters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double accuracyMeters)  $default,) {final _that = this;
switch (_that) {
case _ReportLocationDto():
return $default(_that.latitude,_that.longitude,_that.accuracyMeters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  double accuracyMeters)?  $default,) {final _that = this;
switch (_that) {
case _ReportLocationDto() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracyMeters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportLocationDto extends ReportLocationDto {
  const _ReportLocationDto({required this.latitude, required this.longitude, required this.accuracyMeters}): super._();
  factory _ReportLocationDto.fromJson(Map<String, dynamic> json) => _$ReportLocationDtoFromJson(json);

@override final  double latitude;
@override final  double longitude;
@override final  double accuracyMeters;

/// Create a copy of ReportLocationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportLocationDtoCopyWith<_ReportLocationDto> get copyWith => __$ReportLocationDtoCopyWithImpl<_ReportLocationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportLocationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportLocationDto&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracyMeters, accuracyMeters) || other.accuracyMeters == accuracyMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,latitude,longitude,accuracyMeters);
}

@override
String toString() {
    return 'ReportLocationDto(latitude: $latitude, longitude: $longitude, accuracyMeters: $accuracyMeters)';
}


}

/// @nodoc
abstract mixin class _$ReportLocationDtoCopyWith<$Res> implements $ReportLocationDtoCopyWith<$Res> {
  factory _$ReportLocationDtoCopyWith(_ReportLocationDto value, $Res Function(_ReportLocationDto) _then) = __$ReportLocationDtoCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, double accuracyMeters
});




}
/// @nodoc
class __$ReportLocationDtoCopyWithImpl<$Res>
    implements _$ReportLocationDtoCopyWith<$Res> {
  __$ReportLocationDtoCopyWithImpl(this._self, this._then);

  final _ReportLocationDto _self;
  final $Res Function(_ReportLocationDto) _then;

/// Create a copy of ReportLocationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? accuracyMeters = null,}) {
  return _then(_ReportLocationDto(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracyMeters: null == accuracyMeters ? _self.accuracyMeters : accuracyMeters // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$SubmitDamageReportRequestDto {

 String get monumentId; DamageCategory get category; ReportUrgency get urgency; String get description; List<ReportPhotoAttachmentDto> get photos;@JsonKey(includeIfNull: false) ReportLocationDto? get location;
/// Create a copy of SubmitDamageReportRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitDamageReportRequestDtoCopyWith<SubmitDamageReportRequestDto> get copyWith => _$SubmitDamageReportRequestDtoCopyWithImpl<SubmitDamageReportRequestDto>(this as SubmitDamageReportRequestDto, _$identity);

  /// Serializes this SubmitDamageReportRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SubmitDamageReportRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitDamageReportRequestDto&&(identical(other.monumentId, _this.monumentId) || other.monumentId == _this.monumentId)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.urgency, _this.urgency) || other.urgency == _this.urgency)&&(identical(other.description, _this.description) || other.description == _this.description)&&const DeepCollectionEquality().equals(other.photos, _this.photos)&&(identical(other.location, _this.location) || other.location == _this.location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SubmitDamageReportRequestDto;
  return Object.hash(runtimeType,_this.monumentId,_this.category,_this.urgency,_this.description,const DeepCollectionEquality().hash(_this.photos),_this.location);
}

@override
String toString() {
  final _this = this as SubmitDamageReportRequestDto;
  return 'SubmitDamageReportRequestDto(monumentId: ${_this.monumentId}, category: ${_this.category}, urgency: ${_this.urgency}, description: ${_this.description}, photos: ${_this.photos}, location: ${_this.location})';
}


}

/// @nodoc
abstract mixin class $SubmitDamageReportRequestDtoCopyWith<$Res>  {
  factory $SubmitDamageReportRequestDtoCopyWith(SubmitDamageReportRequestDto value, $Res Function(SubmitDamageReportRequestDto) _then) = _$SubmitDamageReportRequestDtoCopyWithImpl;
@useResult
$Res call({
 String monumentId, DamageCategory category, ReportUrgency urgency, String description, List<ReportPhotoAttachmentDto> photos,@JsonKey(includeIfNull: false) ReportLocationDto? location
});


$ReportLocationDtoCopyWith<$Res>? get location;

}
/// @nodoc
class _$SubmitDamageReportRequestDtoCopyWithImpl<$Res>
    implements $SubmitDamageReportRequestDtoCopyWith<$Res> {
  _$SubmitDamageReportRequestDtoCopyWithImpl(this._self, this._then);

  final SubmitDamageReportRequestDto _self;
  final $Res Function(SubmitDamageReportRequestDto) _then;

/// Create a copy of SubmitDamageReportRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monumentId = null,Object? category = null,Object? urgency = null,Object? description = null,Object? photos = null,Object? location = freezed,}) {
  return _then(SubmitDamageReportRequestDto(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DamageCategory,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as ReportUrgency,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<ReportPhotoAttachmentDto>,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as ReportLocationDto?,
  ));
}
/// Create a copy of SubmitDamageReportRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportLocationDtoCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $ReportLocationDtoCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [SubmitDamageReportRequestDto].
extension SubmitDamageReportRequestDtoPatterns on SubmitDamageReportRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmitDamageReportRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmitDamageReportRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmitDamageReportRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _SubmitDamageReportRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmitDamageReportRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _SubmitDamageReportRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String monumentId,  DamageCategory category,  ReportUrgency urgency,  String description,  List<ReportPhotoAttachmentDto> photos, @JsonKey(includeIfNull: false)  ReportLocationDto? location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmitDamageReportRequestDto() when $default != null:
return $default(_that.monumentId,_that.category,_that.urgency,_that.description,_that.photos,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String monumentId,  DamageCategory category,  ReportUrgency urgency,  String description,  List<ReportPhotoAttachmentDto> photos, @JsonKey(includeIfNull: false)  ReportLocationDto? location)  $default,) {final _that = this;
switch (_that) {
case _SubmitDamageReportRequestDto():
return $default(_that.monumentId,_that.category,_that.urgency,_that.description,_that.photos,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String monumentId,  DamageCategory category,  ReportUrgency urgency,  String description,  List<ReportPhotoAttachmentDto> photos, @JsonKey(includeIfNull: false)  ReportLocationDto? location)?  $default,) {final _that = this;
switch (_that) {
case _SubmitDamageReportRequestDto() when $default != null:
return $default(_that.monumentId,_that.category,_that.urgency,_that.description,_that.photos,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubmitDamageReportRequestDto implements SubmitDamageReportRequestDto {
  const _SubmitDamageReportRequestDto({required this.monumentId, required this.category, required this.urgency, required this.description,  List<ReportPhotoAttachmentDto> photos = const <ReportPhotoAttachmentDto>[], @JsonKey(includeIfNull: false) this.location}): _photos = photos;
  factory _SubmitDamageReportRequestDto.fromJson(Map<String, dynamic> json) => _$SubmitDamageReportRequestDtoFromJson(json);

@override final  String monumentId;
@override final  DamageCategory category;
@override final  ReportUrgency urgency;
@override final  String description;
 final  List<ReportPhotoAttachmentDto> _photos;
@override@JsonKey() List<ReportPhotoAttachmentDto> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override@JsonKey(includeIfNull: false) final  ReportLocationDto? location;

/// Create a copy of SubmitDamageReportRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmitDamageReportRequestDtoCopyWith<_SubmitDamageReportRequestDto> get copyWith => __$SubmitDamageReportRequestDtoCopyWithImpl<_SubmitDamageReportRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmitDamageReportRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitDamageReportRequestDto&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.category, category) || other.category == category)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.photos, _photos)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,monumentId,category,urgency,description,const DeepCollectionEquality().hash(_photos),location);
}

@override
String toString() {
    return 'SubmitDamageReportRequestDto(monumentId: $monumentId, category: $category, urgency: $urgency, description: $description, photos: $photos, location: $location)';
}


}

/// @nodoc
abstract mixin class _$SubmitDamageReportRequestDtoCopyWith<$Res> implements $SubmitDamageReportRequestDtoCopyWith<$Res> {
  factory _$SubmitDamageReportRequestDtoCopyWith(_SubmitDamageReportRequestDto value, $Res Function(_SubmitDamageReportRequestDto) _then) = __$SubmitDamageReportRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String monumentId, DamageCategory category, ReportUrgency urgency, String description, List<ReportPhotoAttachmentDto> photos,@JsonKey(includeIfNull: false) ReportLocationDto? location
});


@override $ReportLocationDtoCopyWith<$Res>? get location;

}
/// @nodoc
class __$SubmitDamageReportRequestDtoCopyWithImpl<$Res>
    implements _$SubmitDamageReportRequestDtoCopyWith<$Res> {
  __$SubmitDamageReportRequestDtoCopyWithImpl(this._self, this._then);

  final _SubmitDamageReportRequestDto _self;
  final $Res Function(_SubmitDamageReportRequestDto) _then;

/// Create a copy of SubmitDamageReportRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monumentId = null,Object? category = null,Object? urgency = null,Object? description = null,Object? photos = null,Object? location = freezed,}) {
  return _then(_SubmitDamageReportRequestDto(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DamageCategory,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as ReportUrgency,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<ReportPhotoAttachmentDto>,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as ReportLocationDto?,
  ));
}

/// Create a copy of SubmitDamageReportRequestDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportLocationDtoCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $ReportLocationDtoCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

// dart format on
