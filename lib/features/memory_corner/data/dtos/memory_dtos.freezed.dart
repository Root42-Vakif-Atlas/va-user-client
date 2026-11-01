// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemoryAuthorDto {

 String get id; String get displayName;
/// Create a copy of MemoryAuthorDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryAuthorDtoCopyWith<MemoryAuthorDto> get copyWith => _$MemoryAuthorDtoCopyWithImpl<MemoryAuthorDto>(this as MemoryAuthorDto, _$identity);

  /// Serializes this MemoryAuthorDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemoryAuthorDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryAuthorDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemoryAuthorDto;
  return Object.hash(runtimeType,_this.id,_this.displayName);
}

@override
String toString() {
  final _this = this as MemoryAuthorDto;
  return 'MemoryAuthorDto(id: ${_this.id}, displayName: ${_this.displayName})';
}


}

/// @nodoc
abstract mixin class $MemoryAuthorDtoCopyWith<$Res>  {
  factory $MemoryAuthorDtoCopyWith(MemoryAuthorDto value, $Res Function(MemoryAuthorDto) _then) = _$MemoryAuthorDtoCopyWithImpl;
@useResult
$Res call({
 String id, String displayName
});




}
/// @nodoc
class _$MemoryAuthorDtoCopyWithImpl<$Res>
    implements $MemoryAuthorDtoCopyWith<$Res> {
  _$MemoryAuthorDtoCopyWithImpl(this._self, this._then);

  final MemoryAuthorDto _self;
  final $Res Function(MemoryAuthorDto) _then;

/// Create a copy of MemoryAuthorDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,}) {
  return _then(MemoryAuthorDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryAuthorDto].
extension MemoryAuthorDtoPatterns on MemoryAuthorDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryAuthorDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryAuthorDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryAuthorDto value)  $default,){
final _that = this;
switch (_that) {
case _MemoryAuthorDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryAuthorDto value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryAuthorDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoryAuthorDto() when $default != null:
return $default(_that.id,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName)  $default,) {final _that = this;
switch (_that) {
case _MemoryAuthorDto():
return $default(_that.id,_that.displayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName)?  $default,) {final _that = this;
switch (_that) {
case _MemoryAuthorDto() when $default != null:
return $default(_that.id,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemoryAuthorDto extends MemoryAuthorDto {
  const _MemoryAuthorDto({required this.id, required this.displayName}): super._();
  factory _MemoryAuthorDto.fromJson(Map<String, dynamic> json) => _$MemoryAuthorDtoFromJson(json);

@override final  String id;
@override final  String displayName;

/// Create a copy of MemoryAuthorDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryAuthorDtoCopyWith<_MemoryAuthorDto> get copyWith => __$MemoryAuthorDtoCopyWithImpl<_MemoryAuthorDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryAuthorDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryAuthorDto&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,displayName);
}

@override
String toString() {
    return 'MemoryAuthorDto(id: $id, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$MemoryAuthorDtoCopyWith<$Res> implements $MemoryAuthorDtoCopyWith<$Res> {
  factory _$MemoryAuthorDtoCopyWith(_MemoryAuthorDto value, $Res Function(_MemoryAuthorDto) _then) = __$MemoryAuthorDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName
});




}
/// @nodoc
class __$MemoryAuthorDtoCopyWithImpl<$Res>
    implements _$MemoryAuthorDtoCopyWith<$Res> {
  __$MemoryAuthorDtoCopyWithImpl(this._self, this._then);

  final _MemoryAuthorDto _self;
  final $Res Function(_MemoryAuthorDto) _then;

/// Create a copy of MemoryAuthorDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,}) {
  return _then(_MemoryAuthorDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MemoryPhotoDto {

 String get id; String get url; String get thumbnailUrl; int get width; int get height; String? get description;
/// Create a copy of MemoryPhotoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryPhotoDtoCopyWith<MemoryPhotoDto> get copyWith => _$MemoryPhotoDtoCopyWithImpl<MemoryPhotoDto>(this as MemoryPhotoDto, _$identity);

  /// Serializes this MemoryPhotoDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemoryPhotoDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryPhotoDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.thumbnailUrl, _this.thumbnailUrl) || other.thumbnailUrl == _this.thumbnailUrl)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.height, _this.height) || other.height == _this.height)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemoryPhotoDto;
  return Object.hash(runtimeType,_this.id,_this.url,_this.thumbnailUrl,_this.width,_this.height,_this.description);
}

@override
String toString() {
  final _this = this as MemoryPhotoDto;
  return 'MemoryPhotoDto(id: ${_this.id}, url: ${_this.url}, thumbnailUrl: ${_this.thumbnailUrl}, width: ${_this.width}, height: ${_this.height}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $MemoryPhotoDtoCopyWith<$Res>  {
  factory $MemoryPhotoDtoCopyWith(MemoryPhotoDto value, $Res Function(MemoryPhotoDto) _then) = _$MemoryPhotoDtoCopyWithImpl;
@useResult
$Res call({
 String id, String url, String thumbnailUrl, int width, int height, String? description
});




}
/// @nodoc
class _$MemoryPhotoDtoCopyWithImpl<$Res>
    implements $MemoryPhotoDtoCopyWith<$Res> {
  _$MemoryPhotoDtoCopyWithImpl(this._self, this._then);

  final MemoryPhotoDto _self;
  final $Res Function(MemoryPhotoDto) _then;

/// Create a copy of MemoryPhotoDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? thumbnailUrl = null,Object? width = null,Object? height = null,Object? description = freezed,}) {
  return _then(MemoryPhotoDto(
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


/// Adds pattern-matching-related methods to [MemoryPhotoDto].
extension MemoryPhotoDtoPatterns on MemoryPhotoDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryPhotoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryPhotoDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryPhotoDto value)  $default,){
final _that = this;
switch (_that) {
case _MemoryPhotoDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryPhotoDto value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryPhotoDto() when $default != null:
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
case _MemoryPhotoDto() when $default != null:
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
case _MemoryPhotoDto():
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
case _MemoryPhotoDto() when $default != null:
return $default(_that.id,_that.url,_that.thumbnailUrl,_that.width,_that.height,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemoryPhotoDto extends MemoryPhotoDto {
  const _MemoryPhotoDto({required this.id, required this.url, required this.thumbnailUrl, required this.width, required this.height, this.description}): super._();
  factory _MemoryPhotoDto.fromJson(Map<String, dynamic> json) => _$MemoryPhotoDtoFromJson(json);

@override final  String id;
@override final  String url;
@override final  String thumbnailUrl;
@override final  int width;
@override final  int height;
@override final  String? description;

/// Create a copy of MemoryPhotoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryPhotoDtoCopyWith<_MemoryPhotoDto> get copyWith => __$MemoryPhotoDtoCopyWithImpl<_MemoryPhotoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryPhotoDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryPhotoDto&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,url,thumbnailUrl,width,height,description);
}

@override
String toString() {
    return 'MemoryPhotoDto(id: $id, url: $url, thumbnailUrl: $thumbnailUrl, width: $width, height: $height, description: $description)';
}


}

/// @nodoc
abstract mixin class _$MemoryPhotoDtoCopyWith<$Res> implements $MemoryPhotoDtoCopyWith<$Res> {
  factory _$MemoryPhotoDtoCopyWith(_MemoryPhotoDto value, $Res Function(_MemoryPhotoDto) _then) = __$MemoryPhotoDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String url, String thumbnailUrl, int width, int height, String? description
});




}
/// @nodoc
class __$MemoryPhotoDtoCopyWithImpl<$Res>
    implements _$MemoryPhotoDtoCopyWith<$Res> {
  __$MemoryPhotoDtoCopyWithImpl(this._self, this._then);

  final _MemoryPhotoDto _self;
  final $Res Function(_MemoryPhotoDto) _then;

/// Create a copy of MemoryPhotoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? thumbnailUrl = null,Object? width = null,Object? height = null,Object? description = freezed,}) {
  return _then(_MemoryPhotoDto(
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
mixin _$MemoryDto {

 String get id; String get monumentId; MemoryAuthorDto get author; String get text; DateTime get createdAt; List<MemoryPhotoDto> get photos; String? get visitedOn;/// Zaman çizelgesi günü (ziyaret, yoksa paylaşım günü — sunucu saat
/// diliminde). Eski yanıtlarda yoksa istemcide türetilir.
 String? get memoryDate;@JsonKey(unknownEnumValue: MemoryModerationStatus.pending) MemoryModerationStatus get status;
/// Create a copy of MemoryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryDtoCopyWith<MemoryDto> get copyWith => _$MemoryDtoCopyWithImpl<MemoryDto>(this as MemoryDto, _$identity);

  /// Serializes this MemoryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemoryDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.monumentId, _this.monumentId) || other.monumentId == _this.monumentId)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.photos, _this.photos)&&(identical(other.visitedOn, _this.visitedOn) || other.visitedOn == _this.visitedOn)&&(identical(other.memoryDate, _this.memoryDate) || other.memoryDate == _this.memoryDate)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemoryDto;
  return Object.hash(runtimeType,_this.id,_this.monumentId,_this.author,_this.text,_this.createdAt,const DeepCollectionEquality().hash(_this.photos),_this.visitedOn,_this.memoryDate,_this.status);
}

@override
String toString() {
  final _this = this as MemoryDto;
  return 'MemoryDto(id: ${_this.id}, monumentId: ${_this.monumentId}, author: ${_this.author}, text: ${_this.text}, createdAt: ${_this.createdAt}, photos: ${_this.photos}, visitedOn: ${_this.visitedOn}, memoryDate: ${_this.memoryDate}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $MemoryDtoCopyWith<$Res>  {
  factory $MemoryDtoCopyWith(MemoryDto value, $Res Function(MemoryDto) _then) = _$MemoryDtoCopyWithImpl;
@useResult
$Res call({
 String id, String monumentId, MemoryAuthorDto author, String text, DateTime createdAt, List<MemoryPhotoDto> photos, String? visitedOn, String? memoryDate,@JsonKey(unknownEnumValue: MemoryModerationStatus.pending) MemoryModerationStatus status
});


$MemoryAuthorDtoCopyWith<$Res> get author;

}
/// @nodoc
class _$MemoryDtoCopyWithImpl<$Res>
    implements $MemoryDtoCopyWith<$Res> {
  _$MemoryDtoCopyWithImpl(this._self, this._then);

  final MemoryDto _self;
  final $Res Function(MemoryDto) _then;

/// Create a copy of MemoryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? monumentId = null,Object? author = null,Object? text = null,Object? createdAt = null,Object? photos = null,Object? visitedOn = freezed,Object? memoryDate = freezed,Object? status = null,}) {
  return _then(MemoryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as MemoryAuthorDto,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<MemoryPhotoDto>,visitedOn: freezed == visitedOn ? _self.visitedOn : visitedOn // ignore: cast_nullable_to_non_nullable
as String?,memoryDate: freezed == memoryDate ? _self.memoryDate : memoryDate // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemoryModerationStatus,
  ));
}
/// Create a copy of MemoryDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemoryAuthorDtoCopyWith<$Res> get author {
  
  return $MemoryAuthorDtoCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [MemoryDto].
extension MemoryDtoPatterns on MemoryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryDto value)  $default,){
final _that = this;
switch (_that) {
case _MemoryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryDto value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String monumentId,  MemoryAuthorDto author,  String text,  DateTime createdAt,  List<MemoryPhotoDto> photos,  String? visitedOn,  String? memoryDate, @JsonKey(unknownEnumValue: MemoryModerationStatus.pending)  MemoryModerationStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoryDto() when $default != null:
return $default(_that.id,_that.monumentId,_that.author,_that.text,_that.createdAt,_that.photos,_that.visitedOn,_that.memoryDate,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String monumentId,  MemoryAuthorDto author,  String text,  DateTime createdAt,  List<MemoryPhotoDto> photos,  String? visitedOn,  String? memoryDate, @JsonKey(unknownEnumValue: MemoryModerationStatus.pending)  MemoryModerationStatus status)  $default,) {final _that = this;
switch (_that) {
case _MemoryDto():
return $default(_that.id,_that.monumentId,_that.author,_that.text,_that.createdAt,_that.photos,_that.visitedOn,_that.memoryDate,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String monumentId,  MemoryAuthorDto author,  String text,  DateTime createdAt,  List<MemoryPhotoDto> photos,  String? visitedOn,  String? memoryDate, @JsonKey(unknownEnumValue: MemoryModerationStatus.pending)  MemoryModerationStatus status)?  $default,) {final _that = this;
switch (_that) {
case _MemoryDto() when $default != null:
return $default(_that.id,_that.monumentId,_that.author,_that.text,_that.createdAt,_that.photos,_that.visitedOn,_that.memoryDate,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemoryDto extends MemoryDto {
  const _MemoryDto({required this.id, required this.monumentId, required this.author, required this.text, required this.createdAt,  List<MemoryPhotoDto> photos = const <MemoryPhotoDto>[], this.visitedOn, this.memoryDate, @JsonKey(unknownEnumValue: MemoryModerationStatus.pending) this.status = MemoryModerationStatus.approved}): _photos = photos,super._();
  factory _MemoryDto.fromJson(Map<String, dynamic> json) => _$MemoryDtoFromJson(json);

@override final  String id;
@override final  String monumentId;
@override final  MemoryAuthorDto author;
@override final  String text;
@override final  DateTime createdAt;
 final  List<MemoryPhotoDto> _photos;
@override@JsonKey() List<MemoryPhotoDto> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override final  String? visitedOn;
/// Zaman çizelgesi günü (ziyaret, yoksa paylaşım günü — sunucu saat
/// diliminde). Eski yanıtlarda yoksa istemcide türetilir.
@override final  String? memoryDate;
@override@JsonKey(unknownEnumValue: MemoryModerationStatus.pending) final  MemoryModerationStatus status;

/// Create a copy of MemoryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryDtoCopyWith<_MemoryDto> get copyWith => __$MemoryDtoCopyWithImpl<_MemoryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.author, author) || other.author == author)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.photos, _photos)&&(identical(other.visitedOn, visitedOn) || other.visitedOn == visitedOn)&&(identical(other.memoryDate, memoryDate) || other.memoryDate == memoryDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,monumentId,author,text,createdAt,const DeepCollectionEquality().hash(_photos),visitedOn,memoryDate,status);
}

@override
String toString() {
    return 'MemoryDto(id: $id, monumentId: $monumentId, author: $author, text: $text, createdAt: $createdAt, photos: $photos, visitedOn: $visitedOn, memoryDate: $memoryDate, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MemoryDtoCopyWith<$Res> implements $MemoryDtoCopyWith<$Res> {
  factory _$MemoryDtoCopyWith(_MemoryDto value, $Res Function(_MemoryDto) _then) = __$MemoryDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String monumentId, MemoryAuthorDto author, String text, DateTime createdAt, List<MemoryPhotoDto> photos, String? visitedOn, String? memoryDate,@JsonKey(unknownEnumValue: MemoryModerationStatus.pending) MemoryModerationStatus status
});


@override $MemoryAuthorDtoCopyWith<$Res> get author;

}
/// @nodoc
class __$MemoryDtoCopyWithImpl<$Res>
    implements _$MemoryDtoCopyWith<$Res> {
  __$MemoryDtoCopyWithImpl(this._self, this._then);

  final _MemoryDto _self;
  final $Res Function(_MemoryDto) _then;

/// Create a copy of MemoryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? monumentId = null,Object? author = null,Object? text = null,Object? createdAt = null,Object? photos = null,Object? visitedOn = freezed,Object? memoryDate = freezed,Object? status = null,}) {
  return _then(_MemoryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as MemoryAuthorDto,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<MemoryPhotoDto>,visitedOn: freezed == visitedOn ? _self.visitedOn : visitedOn // ignore: cast_nullable_to_non_nullable
as String?,memoryDate: freezed == memoryDate ? _self.memoryDate : memoryDate // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemoryModerationStatus,
  ));
}

/// Create a copy of MemoryDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemoryAuthorDtoCopyWith<$Res> get author {
  
  return $MemoryAuthorDtoCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// @nodoc
mixin _$MemoryYearCountDto {

 int get year; int get count;
/// Create a copy of MemoryYearCountDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryYearCountDtoCopyWith<MemoryYearCountDto> get copyWith => _$MemoryYearCountDtoCopyWithImpl<MemoryYearCountDto>(this as MemoryYearCountDto, _$identity);

  /// Serializes this MemoryYearCountDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemoryYearCountDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryYearCountDto&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemoryYearCountDto;
  return Object.hash(runtimeType,_this.year,_this.count);
}

@override
String toString() {
  final _this = this as MemoryYearCountDto;
  return 'MemoryYearCountDto(year: ${_this.year}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $MemoryYearCountDtoCopyWith<$Res>  {
  factory $MemoryYearCountDtoCopyWith(MemoryYearCountDto value, $Res Function(MemoryYearCountDto) _then) = _$MemoryYearCountDtoCopyWithImpl;
@useResult
$Res call({
 int year, int count
});




}
/// @nodoc
class _$MemoryYearCountDtoCopyWithImpl<$Res>
    implements $MemoryYearCountDtoCopyWith<$Res> {
  _$MemoryYearCountDtoCopyWithImpl(this._self, this._then);

  final MemoryYearCountDto _self;
  final $Res Function(MemoryYearCountDto) _then;

/// Create a copy of MemoryYearCountDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? count = null,}) {
  return _then(MemoryYearCountDto(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryYearCountDto].
extension MemoryYearCountDtoPatterns on MemoryYearCountDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryYearCountDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryYearCountDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryYearCountDto value)  $default,){
final _that = this;
switch (_that) {
case _MemoryYearCountDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryYearCountDto value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryYearCountDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoryYearCountDto() when $default != null:
return $default(_that.year,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int count)  $default,) {final _that = this;
switch (_that) {
case _MemoryYearCountDto():
return $default(_that.year,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int count)?  $default,) {final _that = this;
switch (_that) {
case _MemoryYearCountDto() when $default != null:
return $default(_that.year,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemoryYearCountDto extends MemoryYearCountDto {
  const _MemoryYearCountDto({required this.year, required this.count}): super._();
  factory _MemoryYearCountDto.fromJson(Map<String, dynamic> json) => _$MemoryYearCountDtoFromJson(json);

@override final  int year;
@override final  int count;

/// Create a copy of MemoryYearCountDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryYearCountDtoCopyWith<_MemoryYearCountDto> get copyWith => __$MemoryYearCountDtoCopyWithImpl<_MemoryYearCountDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryYearCountDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryYearCountDto&&(identical(other.year, year) || other.year == year)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,year,count);
}

@override
String toString() {
    return 'MemoryYearCountDto(year: $year, count: $count)';
}


}

/// @nodoc
abstract mixin class _$MemoryYearCountDtoCopyWith<$Res> implements $MemoryYearCountDtoCopyWith<$Res> {
  factory _$MemoryYearCountDtoCopyWith(_MemoryYearCountDto value, $Res Function(_MemoryYearCountDto) _then) = __$MemoryYearCountDtoCopyWithImpl;
@override @useResult
$Res call({
 int year, int count
});




}
/// @nodoc
class __$MemoryYearCountDtoCopyWithImpl<$Res>
    implements _$MemoryYearCountDtoCopyWith<$Res> {
  __$MemoryYearCountDtoCopyWithImpl(this._self, this._then);

  final _MemoryYearCountDto _self;
  final $Res Function(_MemoryYearCountDto) _then;

/// Create a copy of MemoryYearCountDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? count = null,}) {
  return _then(_MemoryYearCountDto(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MemoryFacetsDto {

 List<MemoryYearCountDto> get years;
/// Create a copy of MemoryFacetsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryFacetsDtoCopyWith<MemoryFacetsDto> get copyWith => _$MemoryFacetsDtoCopyWithImpl<MemoryFacetsDto>(this as MemoryFacetsDto, _$identity);

  /// Serializes this MemoryFacetsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemoryFacetsDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryFacetsDto&&const DeepCollectionEquality().equals(other.years, _this.years));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemoryFacetsDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.years));
}

@override
String toString() {
  final _this = this as MemoryFacetsDto;
  return 'MemoryFacetsDto(years: ${_this.years})';
}


}

/// @nodoc
abstract mixin class $MemoryFacetsDtoCopyWith<$Res>  {
  factory $MemoryFacetsDtoCopyWith(MemoryFacetsDto value, $Res Function(MemoryFacetsDto) _then) = _$MemoryFacetsDtoCopyWithImpl;
@useResult
$Res call({
 List<MemoryYearCountDto> years
});




}
/// @nodoc
class _$MemoryFacetsDtoCopyWithImpl<$Res>
    implements $MemoryFacetsDtoCopyWith<$Res> {
  _$MemoryFacetsDtoCopyWithImpl(this._self, this._then);

  final MemoryFacetsDto _self;
  final $Res Function(MemoryFacetsDto) _then;

/// Create a copy of MemoryFacetsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? years = null,}) {
  return _then(MemoryFacetsDto(
years: null == years ? _self.years : years // ignore: cast_nullable_to_non_nullable
as List<MemoryYearCountDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryFacetsDto].
extension MemoryFacetsDtoPatterns on MemoryFacetsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryFacetsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryFacetsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryFacetsDto value)  $default,){
final _that = this;
switch (_that) {
case _MemoryFacetsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryFacetsDto value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryFacetsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MemoryYearCountDto> years)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoryFacetsDto() when $default != null:
return $default(_that.years);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MemoryYearCountDto> years)  $default,) {final _that = this;
switch (_that) {
case _MemoryFacetsDto():
return $default(_that.years);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MemoryYearCountDto> years)?  $default,) {final _that = this;
switch (_that) {
case _MemoryFacetsDto() when $default != null:
return $default(_that.years);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemoryFacetsDto implements MemoryFacetsDto {
  const _MemoryFacetsDto({ List<MemoryYearCountDto> years = const <MemoryYearCountDto>[]}): _years = years;
  factory _MemoryFacetsDto.fromJson(Map<String, dynamic> json) => _$MemoryFacetsDtoFromJson(json);

 final  List<MemoryYearCountDto> _years;
@override@JsonKey() List<MemoryYearCountDto> get years {
  if (_years is EqualUnmodifiableListView) return _years;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_years);
}


/// Create a copy of MemoryFacetsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryFacetsDtoCopyWith<_MemoryFacetsDto> get copyWith => __$MemoryFacetsDtoCopyWithImpl<_MemoryFacetsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryFacetsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryFacetsDto&&const DeepCollectionEquality().equals(other.years, _years));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_years));
}

@override
String toString() {
    return 'MemoryFacetsDto(years: $years)';
}


}

/// @nodoc
abstract mixin class _$MemoryFacetsDtoCopyWith<$Res> implements $MemoryFacetsDtoCopyWith<$Res> {
  factory _$MemoryFacetsDtoCopyWith(_MemoryFacetsDto value, $Res Function(_MemoryFacetsDto) _then) = __$MemoryFacetsDtoCopyWithImpl;
@override @useResult
$Res call({
 List<MemoryYearCountDto> years
});




}
/// @nodoc
class __$MemoryFacetsDtoCopyWithImpl<$Res>
    implements _$MemoryFacetsDtoCopyWith<$Res> {
  __$MemoryFacetsDtoCopyWithImpl(this._self, this._then);

  final _MemoryFacetsDto _self;
  final $Res Function(_MemoryFacetsDto) _then;

/// Create a copy of MemoryFacetsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? years = null,}) {
  return _then(_MemoryFacetsDto(
years: null == years ? _self._years : years // ignore: cast_nullable_to_non_nullable
as List<MemoryYearCountDto>,
  ));
}


}


/// @nodoc
mixin _$MemoryPageDto {

 List<MemoryDto> get items; int get total; String? get nextCursor; MemoryFacetsDto? get facets;
/// Create a copy of MemoryPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryPageDtoCopyWith<MemoryPageDto> get copyWith => _$MemoryPageDtoCopyWithImpl<MemoryPageDto>(this as MemoryPageDto, _$identity);

  /// Serializes this MemoryPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemoryPageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryPageDto&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&(identical(other.facets, _this.facets) || other.facets == _this.facets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemoryPageDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.total,_this.nextCursor,_this.facets);
}

@override
String toString() {
  final _this = this as MemoryPageDto;
  return 'MemoryPageDto(items: ${_this.items}, total: ${_this.total}, nextCursor: ${_this.nextCursor}, facets: ${_this.facets})';
}


}

/// @nodoc
abstract mixin class $MemoryPageDtoCopyWith<$Res>  {
  factory $MemoryPageDtoCopyWith(MemoryPageDto value, $Res Function(MemoryPageDto) _then) = _$MemoryPageDtoCopyWithImpl;
@useResult
$Res call({
 List<MemoryDto> items, int total, String? nextCursor, MemoryFacetsDto? facets
});


$MemoryFacetsDtoCopyWith<$Res>? get facets;

}
/// @nodoc
class _$MemoryPageDtoCopyWithImpl<$Res>
    implements $MemoryPageDtoCopyWith<$Res> {
  _$MemoryPageDtoCopyWithImpl(this._self, this._then);

  final MemoryPageDto _self;
  final $Res Function(MemoryPageDto) _then;

/// Create a copy of MemoryPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? facets = freezed,}) {
  return _then(MemoryPageDto(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MemoryDto>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,facets: freezed == facets ? _self.facets : facets // ignore: cast_nullable_to_non_nullable
as MemoryFacetsDto?,
  ));
}
/// Create a copy of MemoryPageDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemoryFacetsDtoCopyWith<$Res>? get facets {
    if (_self.facets == null) {
    return null;
  }

  return $MemoryFacetsDtoCopyWith<$Res>(_self.facets!, (value) {
    return _then(_self.copyWith(facets: value));
  });
}
}


/// Adds pattern-matching-related methods to [MemoryPageDto].
extension MemoryPageDtoPatterns on MemoryPageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryPageDto value)  $default,){
final _that = this;
switch (_that) {
case _MemoryPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MemoryDto> items,  int total,  String? nextCursor,  MemoryFacetsDto? facets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoryPageDto() when $default != null:
return $default(_that.items,_that.total,_that.nextCursor,_that.facets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MemoryDto> items,  int total,  String? nextCursor,  MemoryFacetsDto? facets)  $default,) {final _that = this;
switch (_that) {
case _MemoryPageDto():
return $default(_that.items,_that.total,_that.nextCursor,_that.facets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MemoryDto> items,  int total,  String? nextCursor,  MemoryFacetsDto? facets)?  $default,) {final _that = this;
switch (_that) {
case _MemoryPageDto() when $default != null:
return $default(_that.items,_that.total,_that.nextCursor,_that.facets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemoryPageDto extends MemoryPageDto {
  const _MemoryPageDto({required  List<MemoryDto> items, required this.total, this.nextCursor, this.facets}): _items = items,super._();
  factory _MemoryPageDto.fromJson(Map<String, dynamic> json) => _$MemoryPageDtoFromJson(json);

 final  List<MemoryDto> _items;
@override List<MemoryDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int total;
@override final  String? nextCursor;
@override final  MemoryFacetsDto? facets;

/// Create a copy of MemoryPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryPageDtoCopyWith<_MemoryPageDto> get copyWith => __$MemoryPageDtoCopyWithImpl<_MemoryPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryPageDto&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.facets, facets) || other.facets == facets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,nextCursor,facets);
}

@override
String toString() {
    return 'MemoryPageDto(items: $items, total: $total, nextCursor: $nextCursor, facets: $facets)';
}


}

/// @nodoc
abstract mixin class _$MemoryPageDtoCopyWith<$Res> implements $MemoryPageDtoCopyWith<$Res> {
  factory _$MemoryPageDtoCopyWith(_MemoryPageDto value, $Res Function(_MemoryPageDto) _then) = __$MemoryPageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<MemoryDto> items, int total, String? nextCursor, MemoryFacetsDto? facets
});


@override $MemoryFacetsDtoCopyWith<$Res>? get facets;

}
/// @nodoc
class __$MemoryPageDtoCopyWithImpl<$Res>
    implements _$MemoryPageDtoCopyWith<$Res> {
  __$MemoryPageDtoCopyWithImpl(this._self, this._then);

  final _MemoryPageDto _self;
  final $Res Function(_MemoryPageDto) _then;

/// Create a copy of MemoryPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? facets = freezed,}) {
  return _then(_MemoryPageDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MemoryDto>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,facets: freezed == facets ? _self.facets : facets // ignore: cast_nullable_to_non_nullable
as MemoryFacetsDto?,
  ));
}

/// Create a copy of MemoryPageDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemoryFacetsDtoCopyWith<$Res>? get facets {
    if (_self.facets == null) {
    return null;
  }

  return $MemoryFacetsDtoCopyWith<$Res>(_self.facets!, (value) {
    return _then(_self.copyWith(facets: value));
  });
}
}


/// @nodoc
mixin _$PhotoUploadRequestDto {

 String get contentType; int get byteSize; int get width; int get height;
/// Create a copy of PhotoUploadRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoUploadRequestDtoCopyWith<PhotoUploadRequestDto> get copyWith => _$PhotoUploadRequestDtoCopyWithImpl<PhotoUploadRequestDto>(this as PhotoUploadRequestDto, _$identity);

  /// Serializes this PhotoUploadRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PhotoUploadRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotoUploadRequestDto&&(identical(other.contentType, _this.contentType) || other.contentType == _this.contentType)&&(identical(other.byteSize, _this.byteSize) || other.byteSize == _this.byteSize)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.height, _this.height) || other.height == _this.height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PhotoUploadRequestDto;
  return Object.hash(runtimeType,_this.contentType,_this.byteSize,_this.width,_this.height);
}

@override
String toString() {
  final _this = this as PhotoUploadRequestDto;
  return 'PhotoUploadRequestDto(contentType: ${_this.contentType}, byteSize: ${_this.byteSize}, width: ${_this.width}, height: ${_this.height})';
}


}

/// @nodoc
abstract mixin class $PhotoUploadRequestDtoCopyWith<$Res>  {
  factory $PhotoUploadRequestDtoCopyWith(PhotoUploadRequestDto value, $Res Function(PhotoUploadRequestDto) _then) = _$PhotoUploadRequestDtoCopyWithImpl;
@useResult
$Res call({
 String contentType, int byteSize, int width, int height
});




}
/// @nodoc
class _$PhotoUploadRequestDtoCopyWithImpl<$Res>
    implements $PhotoUploadRequestDtoCopyWith<$Res> {
  _$PhotoUploadRequestDtoCopyWithImpl(this._self, this._then);

  final PhotoUploadRequestDto _self;
  final $Res Function(PhotoUploadRequestDto) _then;

/// Create a copy of PhotoUploadRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contentType = null,Object? byteSize = null,Object? width = null,Object? height = null,}) {
  return _then(PhotoUploadRequestDto(
contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PhotoUploadRequestDto].
extension PhotoUploadRequestDtoPatterns on PhotoUploadRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotoUploadRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotoUploadRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotoUploadRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _PhotoUploadRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotoUploadRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _PhotoUploadRequestDto() when $default != null:
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
case _PhotoUploadRequestDto() when $default != null:
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
case _PhotoUploadRequestDto():
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
case _PhotoUploadRequestDto() when $default != null:
return $default(_that.contentType,_that.byteSize,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhotoUploadRequestDto implements PhotoUploadRequestDto {
  const _PhotoUploadRequestDto({required this.contentType, required this.byteSize, required this.width, required this.height});
  factory _PhotoUploadRequestDto.fromJson(Map<String, dynamic> json) => _$PhotoUploadRequestDtoFromJson(json);

@override final  String contentType;
@override final  int byteSize;
@override final  int width;
@override final  int height;

/// Create a copy of PhotoUploadRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoUploadRequestDtoCopyWith<_PhotoUploadRequestDto> get copyWith => __$PhotoUploadRequestDtoCopyWithImpl<_PhotoUploadRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotoUploadRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoUploadRequestDto&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,contentType,byteSize,width,height);
}

@override
String toString() {
    return 'PhotoUploadRequestDto(contentType: $contentType, byteSize: $byteSize, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$PhotoUploadRequestDtoCopyWith<$Res> implements $PhotoUploadRequestDtoCopyWith<$Res> {
  factory _$PhotoUploadRequestDtoCopyWith(_PhotoUploadRequestDto value, $Res Function(_PhotoUploadRequestDto) _then) = __$PhotoUploadRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String contentType, int byteSize, int width, int height
});




}
/// @nodoc
class __$PhotoUploadRequestDtoCopyWithImpl<$Res>
    implements _$PhotoUploadRequestDtoCopyWith<$Res> {
  __$PhotoUploadRequestDtoCopyWithImpl(this._self, this._then);

  final _PhotoUploadRequestDto _self;
  final $Res Function(_PhotoUploadRequestDto) _then;

/// Create a copy of PhotoUploadRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contentType = null,Object? byteSize = null,Object? width = null,Object? height = null,}) {
  return _then(_PhotoUploadRequestDto(
contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PhotoUploadTicketDto {

 String get id; String get uploadUrl; DateTime get expiresAt; Map<String, String> get uploadHeaders;
/// Create a copy of PhotoUploadTicketDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoUploadTicketDtoCopyWith<PhotoUploadTicketDto> get copyWith => _$PhotoUploadTicketDtoCopyWithImpl<PhotoUploadTicketDto>(this as PhotoUploadTicketDto, _$identity);

  /// Serializes this PhotoUploadTicketDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PhotoUploadTicketDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotoUploadTicketDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.uploadUrl, _this.uploadUrl) || other.uploadUrl == _this.uploadUrl)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&const DeepCollectionEquality().equals(other.uploadHeaders, _this.uploadHeaders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PhotoUploadTicketDto;
  return Object.hash(runtimeType,_this.id,_this.uploadUrl,_this.expiresAt,const DeepCollectionEquality().hash(_this.uploadHeaders));
}

@override
String toString() {
  final _this = this as PhotoUploadTicketDto;
  return 'PhotoUploadTicketDto(id: ${_this.id}, uploadUrl: ${_this.uploadUrl}, expiresAt: ${_this.expiresAt}, uploadHeaders: ${_this.uploadHeaders})';
}


}

/// @nodoc
abstract mixin class $PhotoUploadTicketDtoCopyWith<$Res>  {
  factory $PhotoUploadTicketDtoCopyWith(PhotoUploadTicketDto value, $Res Function(PhotoUploadTicketDto) _then) = _$PhotoUploadTicketDtoCopyWithImpl;
@useResult
$Res call({
 String id, String uploadUrl, DateTime expiresAt, Map<String, String> uploadHeaders
});




}
/// @nodoc
class _$PhotoUploadTicketDtoCopyWithImpl<$Res>
    implements $PhotoUploadTicketDtoCopyWith<$Res> {
  _$PhotoUploadTicketDtoCopyWithImpl(this._self, this._then);

  final PhotoUploadTicketDto _self;
  final $Res Function(PhotoUploadTicketDto) _then;

/// Create a copy of PhotoUploadTicketDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uploadUrl = null,Object? expiresAt = null,Object? uploadHeaders = null,}) {
  return _then(PhotoUploadTicketDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,uploadHeaders: null == uploadHeaders ? _self.uploadHeaders : uploadHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PhotoUploadTicketDto].
extension PhotoUploadTicketDtoPatterns on PhotoUploadTicketDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotoUploadTicketDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotoUploadTicketDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotoUploadTicketDto value)  $default,){
final _that = this;
switch (_that) {
case _PhotoUploadTicketDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotoUploadTicketDto value)?  $default,){
final _that = this;
switch (_that) {
case _PhotoUploadTicketDto() when $default != null:
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
case _PhotoUploadTicketDto() when $default != null:
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
case _PhotoUploadTicketDto():
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
case _PhotoUploadTicketDto() when $default != null:
return $default(_that.id,_that.uploadUrl,_that.expiresAt,_that.uploadHeaders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhotoUploadTicketDto implements PhotoUploadTicketDto {
  const _PhotoUploadTicketDto({required this.id, required this.uploadUrl, required this.expiresAt,  Map<String, String> uploadHeaders = const <String, String>{}}): _uploadHeaders = uploadHeaders;
  factory _PhotoUploadTicketDto.fromJson(Map<String, dynamic> json) => _$PhotoUploadTicketDtoFromJson(json);

@override final  String id;
@override final  String uploadUrl;
@override final  DateTime expiresAt;
 final  Map<String, String> _uploadHeaders;
@override@JsonKey() Map<String, String> get uploadHeaders {
  if (_uploadHeaders is EqualUnmodifiableMapView) return _uploadHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_uploadHeaders);
}


/// Create a copy of PhotoUploadTicketDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoUploadTicketDtoCopyWith<_PhotoUploadTicketDto> get copyWith => __$PhotoUploadTicketDtoCopyWithImpl<_PhotoUploadTicketDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotoUploadTicketDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoUploadTicketDto&&(identical(other.id, id) || other.id == id)&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other.uploadHeaders, _uploadHeaders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,uploadUrl,expiresAt,const DeepCollectionEquality().hash(_uploadHeaders));
}

@override
String toString() {
    return 'PhotoUploadTicketDto(id: $id, uploadUrl: $uploadUrl, expiresAt: $expiresAt, uploadHeaders: $uploadHeaders)';
}


}

/// @nodoc
abstract mixin class _$PhotoUploadTicketDtoCopyWith<$Res> implements $PhotoUploadTicketDtoCopyWith<$Res> {
  factory _$PhotoUploadTicketDtoCopyWith(_PhotoUploadTicketDto value, $Res Function(_PhotoUploadTicketDto) _then) = __$PhotoUploadTicketDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String uploadUrl, DateTime expiresAt, Map<String, String> uploadHeaders
});




}
/// @nodoc
class __$PhotoUploadTicketDtoCopyWithImpl<$Res>
    implements _$PhotoUploadTicketDtoCopyWith<$Res> {
  __$PhotoUploadTicketDtoCopyWithImpl(this._self, this._then);

  final _PhotoUploadTicketDto _self;
  final $Res Function(_PhotoUploadTicketDto) _then;

/// Create a copy of PhotoUploadTicketDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uploadUrl = null,Object? expiresAt = null,Object? uploadHeaders = null,}) {
  return _then(_PhotoUploadTicketDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,uploadHeaders: null == uploadHeaders ? _self._uploadHeaders : uploadHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$MemoryPhotoAttachmentDto {

 String get uploadId;@JsonKey(includeIfNull: false) String? get description;
/// Create a copy of MemoryPhotoAttachmentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryPhotoAttachmentDtoCopyWith<MemoryPhotoAttachmentDto> get copyWith => _$MemoryPhotoAttachmentDtoCopyWithImpl<MemoryPhotoAttachmentDto>(this as MemoryPhotoAttachmentDto, _$identity);

  /// Serializes this MemoryPhotoAttachmentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemoryPhotoAttachmentDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryPhotoAttachmentDto&&(identical(other.uploadId, _this.uploadId) || other.uploadId == _this.uploadId)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemoryPhotoAttachmentDto;
  return Object.hash(runtimeType,_this.uploadId,_this.description);
}

@override
String toString() {
  final _this = this as MemoryPhotoAttachmentDto;
  return 'MemoryPhotoAttachmentDto(uploadId: ${_this.uploadId}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $MemoryPhotoAttachmentDtoCopyWith<$Res>  {
  factory $MemoryPhotoAttachmentDtoCopyWith(MemoryPhotoAttachmentDto value, $Res Function(MemoryPhotoAttachmentDto) _then) = _$MemoryPhotoAttachmentDtoCopyWithImpl;
@useResult
$Res call({
 String uploadId,@JsonKey(includeIfNull: false) String? description
});




}
/// @nodoc
class _$MemoryPhotoAttachmentDtoCopyWithImpl<$Res>
    implements $MemoryPhotoAttachmentDtoCopyWith<$Res> {
  _$MemoryPhotoAttachmentDtoCopyWithImpl(this._self, this._then);

  final MemoryPhotoAttachmentDto _self;
  final $Res Function(MemoryPhotoAttachmentDto) _then;

/// Create a copy of MemoryPhotoAttachmentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uploadId = null,Object? description = freezed,}) {
  return _then(MemoryPhotoAttachmentDto(
uploadId: null == uploadId ? _self.uploadId : uploadId // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryPhotoAttachmentDto].
extension MemoryPhotoAttachmentDtoPatterns on MemoryPhotoAttachmentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryPhotoAttachmentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryPhotoAttachmentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryPhotoAttachmentDto value)  $default,){
final _that = this;
switch (_that) {
case _MemoryPhotoAttachmentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryPhotoAttachmentDto value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryPhotoAttachmentDto() when $default != null:
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
case _MemoryPhotoAttachmentDto() when $default != null:
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
case _MemoryPhotoAttachmentDto():
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
case _MemoryPhotoAttachmentDto() when $default != null:
return $default(_that.uploadId,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemoryPhotoAttachmentDto implements MemoryPhotoAttachmentDto {
  const _MemoryPhotoAttachmentDto({required this.uploadId, @JsonKey(includeIfNull: false) this.description});
  factory _MemoryPhotoAttachmentDto.fromJson(Map<String, dynamic> json) => _$MemoryPhotoAttachmentDtoFromJson(json);

@override final  String uploadId;
@override@JsonKey(includeIfNull: false) final  String? description;

/// Create a copy of MemoryPhotoAttachmentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryPhotoAttachmentDtoCopyWith<_MemoryPhotoAttachmentDto> get copyWith => __$MemoryPhotoAttachmentDtoCopyWithImpl<_MemoryPhotoAttachmentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryPhotoAttachmentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryPhotoAttachmentDto&&(identical(other.uploadId, uploadId) || other.uploadId == uploadId)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,uploadId,description);
}

@override
String toString() {
    return 'MemoryPhotoAttachmentDto(uploadId: $uploadId, description: $description)';
}


}

/// @nodoc
abstract mixin class _$MemoryPhotoAttachmentDtoCopyWith<$Res> implements $MemoryPhotoAttachmentDtoCopyWith<$Res> {
  factory _$MemoryPhotoAttachmentDtoCopyWith(_MemoryPhotoAttachmentDto value, $Res Function(_MemoryPhotoAttachmentDto) _then) = __$MemoryPhotoAttachmentDtoCopyWithImpl;
@override @useResult
$Res call({
 String uploadId,@JsonKey(includeIfNull: false) String? description
});




}
/// @nodoc
class __$MemoryPhotoAttachmentDtoCopyWithImpl<$Res>
    implements _$MemoryPhotoAttachmentDtoCopyWith<$Res> {
  __$MemoryPhotoAttachmentDtoCopyWithImpl(this._self, this._then);

  final _MemoryPhotoAttachmentDto _self;
  final $Res Function(_MemoryPhotoAttachmentDto) _then;

/// Create a copy of MemoryPhotoAttachmentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uploadId = null,Object? description = freezed,}) {
  return _then(_MemoryPhotoAttachmentDto(
uploadId: null == uploadId ? _self.uploadId : uploadId // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateMemoryRequestDto {

 String get monumentId; String get text; List<MemoryPhotoAttachmentDto> get photos;@JsonKey(includeIfNull: false) String? get visitedOn;
/// Create a copy of CreateMemoryRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateMemoryRequestDtoCopyWith<CreateMemoryRequestDto> get copyWith => _$CreateMemoryRequestDtoCopyWithImpl<CreateMemoryRequestDto>(this as CreateMemoryRequestDto, _$identity);

  /// Serializes this CreateMemoryRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateMemoryRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateMemoryRequestDto&&(identical(other.monumentId, _this.monumentId) || other.monumentId == _this.monumentId)&&(identical(other.text, _this.text) || other.text == _this.text)&&const DeepCollectionEquality().equals(other.photos, _this.photos)&&(identical(other.visitedOn, _this.visitedOn) || other.visitedOn == _this.visitedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateMemoryRequestDto;
  return Object.hash(runtimeType,_this.monumentId,_this.text,const DeepCollectionEquality().hash(_this.photos),_this.visitedOn);
}

@override
String toString() {
  final _this = this as CreateMemoryRequestDto;
  return 'CreateMemoryRequestDto(monumentId: ${_this.monumentId}, text: ${_this.text}, photos: ${_this.photos}, visitedOn: ${_this.visitedOn})';
}


}

/// @nodoc
abstract mixin class $CreateMemoryRequestDtoCopyWith<$Res>  {
  factory $CreateMemoryRequestDtoCopyWith(CreateMemoryRequestDto value, $Res Function(CreateMemoryRequestDto) _then) = _$CreateMemoryRequestDtoCopyWithImpl;
@useResult
$Res call({
 String monumentId, String text, List<MemoryPhotoAttachmentDto> photos,@JsonKey(includeIfNull: false) String? visitedOn
});




}
/// @nodoc
class _$CreateMemoryRequestDtoCopyWithImpl<$Res>
    implements $CreateMemoryRequestDtoCopyWith<$Res> {
  _$CreateMemoryRequestDtoCopyWithImpl(this._self, this._then);

  final CreateMemoryRequestDto _self;
  final $Res Function(CreateMemoryRequestDto) _then;

/// Create a copy of CreateMemoryRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monumentId = null,Object? text = null,Object? photos = null,Object? visitedOn = freezed,}) {
  return _then(CreateMemoryRequestDto(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<MemoryPhotoAttachmentDto>,visitedOn: freezed == visitedOn ? _self.visitedOn : visitedOn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateMemoryRequestDto].
extension CreateMemoryRequestDtoPatterns on CreateMemoryRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateMemoryRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateMemoryRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateMemoryRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _CreateMemoryRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateMemoryRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _CreateMemoryRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String monumentId,  String text,  List<MemoryPhotoAttachmentDto> photos, @JsonKey(includeIfNull: false)  String? visitedOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateMemoryRequestDto() when $default != null:
return $default(_that.monumentId,_that.text,_that.photos,_that.visitedOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String monumentId,  String text,  List<MemoryPhotoAttachmentDto> photos, @JsonKey(includeIfNull: false)  String? visitedOn)  $default,) {final _that = this;
switch (_that) {
case _CreateMemoryRequestDto():
return $default(_that.monumentId,_that.text,_that.photos,_that.visitedOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String monumentId,  String text,  List<MemoryPhotoAttachmentDto> photos, @JsonKey(includeIfNull: false)  String? visitedOn)?  $default,) {final _that = this;
switch (_that) {
case _CreateMemoryRequestDto() when $default != null:
return $default(_that.monumentId,_that.text,_that.photos,_that.visitedOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateMemoryRequestDto implements CreateMemoryRequestDto {
  const _CreateMemoryRequestDto({required this.monumentId, required this.text,  List<MemoryPhotoAttachmentDto> photos = const <MemoryPhotoAttachmentDto>[], @JsonKey(includeIfNull: false) this.visitedOn}): _photos = photos;
  factory _CreateMemoryRequestDto.fromJson(Map<String, dynamic> json) => _$CreateMemoryRequestDtoFromJson(json);

@override final  String monumentId;
@override final  String text;
 final  List<MemoryPhotoAttachmentDto> _photos;
@override@JsonKey() List<MemoryPhotoAttachmentDto> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override@JsonKey(includeIfNull: false) final  String? visitedOn;

/// Create a copy of CreateMemoryRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateMemoryRequestDtoCopyWith<_CreateMemoryRequestDto> get copyWith => __$CreateMemoryRequestDtoCopyWithImpl<_CreateMemoryRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateMemoryRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateMemoryRequestDto&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.photos, _photos)&&(identical(other.visitedOn, visitedOn) || other.visitedOn == visitedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,monumentId,text,const DeepCollectionEquality().hash(_photos),visitedOn);
}

@override
String toString() {
    return 'CreateMemoryRequestDto(monumentId: $monumentId, text: $text, photos: $photos, visitedOn: $visitedOn)';
}


}

/// @nodoc
abstract mixin class _$CreateMemoryRequestDtoCopyWith<$Res> implements $CreateMemoryRequestDtoCopyWith<$Res> {
  factory _$CreateMemoryRequestDtoCopyWith(_CreateMemoryRequestDto value, $Res Function(_CreateMemoryRequestDto) _then) = __$CreateMemoryRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String monumentId, String text, List<MemoryPhotoAttachmentDto> photos,@JsonKey(includeIfNull: false) String? visitedOn
});




}
/// @nodoc
class __$CreateMemoryRequestDtoCopyWithImpl<$Res>
    implements _$CreateMemoryRequestDtoCopyWith<$Res> {
  __$CreateMemoryRequestDtoCopyWithImpl(this._self, this._then);

  final _CreateMemoryRequestDto _self;
  final $Res Function(_CreateMemoryRequestDto) _then;

/// Create a copy of CreateMemoryRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monumentId = null,Object? text = null,Object? photos = null,Object? visitedOn = freezed,}) {
  return _then(_CreateMemoryRequestDto(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<MemoryPhotoAttachmentDto>,visitedOn: freezed == visitedOn ? _self.visitedOn : visitedOn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MemoryReportRequestDto {

 MemoryReportReason get reason;@JsonKey(includeIfNull: false) String? get note;
/// Create a copy of MemoryReportRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryReportRequestDtoCopyWith<MemoryReportRequestDto> get copyWith => _$MemoryReportRequestDtoCopyWithImpl<MemoryReportRequestDto>(this as MemoryReportRequestDto, _$identity);

  /// Serializes this MemoryReportRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemoryReportRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryReportRequestDto&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.note, _this.note) || other.note == _this.note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemoryReportRequestDto;
  return Object.hash(runtimeType,_this.reason,_this.note);
}

@override
String toString() {
  final _this = this as MemoryReportRequestDto;
  return 'MemoryReportRequestDto(reason: ${_this.reason}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $MemoryReportRequestDtoCopyWith<$Res>  {
  factory $MemoryReportRequestDtoCopyWith(MemoryReportRequestDto value, $Res Function(MemoryReportRequestDto) _then) = _$MemoryReportRequestDtoCopyWithImpl;
@useResult
$Res call({
 MemoryReportReason reason,@JsonKey(includeIfNull: false) String? note
});




}
/// @nodoc
class _$MemoryReportRequestDtoCopyWithImpl<$Res>
    implements $MemoryReportRequestDtoCopyWith<$Res> {
  _$MemoryReportRequestDtoCopyWithImpl(this._self, this._then);

  final MemoryReportRequestDto _self;
  final $Res Function(MemoryReportRequestDto) _then;

/// Create a copy of MemoryReportRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reason = null,Object? note = freezed,}) {
  return _then(MemoryReportRequestDto(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as MemoryReportReason,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryReportRequestDto].
extension MemoryReportRequestDtoPatterns on MemoryReportRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryReportRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryReportRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryReportRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _MemoryReportRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryReportRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryReportRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MemoryReportReason reason, @JsonKey(includeIfNull: false)  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoryReportRequestDto() when $default != null:
return $default(_that.reason,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MemoryReportReason reason, @JsonKey(includeIfNull: false)  String? note)  $default,) {final _that = this;
switch (_that) {
case _MemoryReportRequestDto():
return $default(_that.reason,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MemoryReportReason reason, @JsonKey(includeIfNull: false)  String? note)?  $default,) {final _that = this;
switch (_that) {
case _MemoryReportRequestDto() when $default != null:
return $default(_that.reason,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemoryReportRequestDto implements MemoryReportRequestDto {
  const _MemoryReportRequestDto({required this.reason, @JsonKey(includeIfNull: false) this.note});
  factory _MemoryReportRequestDto.fromJson(Map<String, dynamic> json) => _$MemoryReportRequestDtoFromJson(json);

@override final  MemoryReportReason reason;
@override@JsonKey(includeIfNull: false) final  String? note;

/// Create a copy of MemoryReportRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryReportRequestDtoCopyWith<_MemoryReportRequestDto> get copyWith => __$MemoryReportRequestDtoCopyWithImpl<_MemoryReportRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryReportRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryReportRequestDto&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,reason,note);
}

@override
String toString() {
    return 'MemoryReportRequestDto(reason: $reason, note: $note)';
}


}

/// @nodoc
abstract mixin class _$MemoryReportRequestDtoCopyWith<$Res> implements $MemoryReportRequestDtoCopyWith<$Res> {
  factory _$MemoryReportRequestDtoCopyWith(_MemoryReportRequestDto value, $Res Function(_MemoryReportRequestDto) _then) = __$MemoryReportRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 MemoryReportReason reason,@JsonKey(includeIfNull: false) String? note
});




}
/// @nodoc
class __$MemoryReportRequestDtoCopyWithImpl<$Res>
    implements _$MemoryReportRequestDtoCopyWith<$Res> {
  __$MemoryReportRequestDtoCopyWithImpl(this._self, this._then);

  final _MemoryReportRequestDto _self;
  final $Res Function(_MemoryReportRequestDto) _then;

/// Create a copy of MemoryReportRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = null,Object? note = freezed,}) {
  return _then(_MemoryReportRequestDto(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as MemoryReportReason,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
