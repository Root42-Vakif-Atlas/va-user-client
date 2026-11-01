// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_export_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RouteExportRecordDto {

 String get id; String get routeId; String get routeName; String get fileName; DateTime get createdAt; int get byteSize; int get stopCount;
/// Create a copy of RouteExportRecordDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteExportRecordDtoCopyWith<RouteExportRecordDto> get copyWith => _$RouteExportRecordDtoCopyWithImpl<RouteExportRecordDto>(this as RouteExportRecordDto, _$identity);

  /// Serializes this RouteExportRecordDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteExportRecordDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteExportRecordDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.routeId, _this.routeId) || other.routeId == _this.routeId)&&(identical(other.routeName, _this.routeName) || other.routeName == _this.routeName)&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.byteSize, _this.byteSize) || other.byteSize == _this.byteSize)&&(identical(other.stopCount, _this.stopCount) || other.stopCount == _this.stopCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteExportRecordDto;
  return Object.hash(runtimeType,_this.id,_this.routeId,_this.routeName,_this.fileName,_this.createdAt,_this.byteSize,_this.stopCount);
}

@override
String toString() {
  final _this = this as RouteExportRecordDto;
  return 'RouteExportRecordDto(id: ${_this.id}, routeId: ${_this.routeId}, routeName: ${_this.routeName}, fileName: ${_this.fileName}, createdAt: ${_this.createdAt}, byteSize: ${_this.byteSize}, stopCount: ${_this.stopCount})';
}


}

/// @nodoc
abstract mixin class $RouteExportRecordDtoCopyWith<$Res>  {
  factory $RouteExportRecordDtoCopyWith(RouteExportRecordDto value, $Res Function(RouteExportRecordDto) _then) = _$RouteExportRecordDtoCopyWithImpl;
@useResult
$Res call({
 String id, String routeId, String routeName, String fileName, DateTime createdAt, int byteSize, int stopCount
});




}
/// @nodoc
class _$RouteExportRecordDtoCopyWithImpl<$Res>
    implements $RouteExportRecordDtoCopyWith<$Res> {
  _$RouteExportRecordDtoCopyWithImpl(this._self, this._then);

  final RouteExportRecordDto _self;
  final $Res Function(RouteExportRecordDto) _then;

/// Create a copy of RouteExportRecordDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? routeId = null,Object? routeName = null,Object? fileName = null,Object? createdAt = null,Object? byteSize = null,Object? stopCount = null,}) {
  return _then(RouteExportRecordDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,routeName: null == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,stopCount: null == stopCount ? _self.stopCount : stopCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteExportRecordDto].
extension RouteExportRecordDtoPatterns on RouteExportRecordDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteExportRecordDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteExportRecordDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteExportRecordDto value)  $default,){
final _that = this;
switch (_that) {
case _RouteExportRecordDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteExportRecordDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouteExportRecordDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String routeId,  String routeName,  String fileName,  DateTime createdAt,  int byteSize,  int stopCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteExportRecordDto() when $default != null:
return $default(_that.id,_that.routeId,_that.routeName,_that.fileName,_that.createdAt,_that.byteSize,_that.stopCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String routeId,  String routeName,  String fileName,  DateTime createdAt,  int byteSize,  int stopCount)  $default,) {final _that = this;
switch (_that) {
case _RouteExportRecordDto():
return $default(_that.id,_that.routeId,_that.routeName,_that.fileName,_that.createdAt,_that.byteSize,_that.stopCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String routeId,  String routeName,  String fileName,  DateTime createdAt,  int byteSize,  int stopCount)?  $default,) {final _that = this;
switch (_that) {
case _RouteExportRecordDto() when $default != null:
return $default(_that.id,_that.routeId,_that.routeName,_that.fileName,_that.createdAt,_that.byteSize,_that.stopCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteExportRecordDto extends RouteExportRecordDto {
  const _RouteExportRecordDto({required this.id, required this.routeId, required this.routeName, required this.fileName, required this.createdAt, required this.byteSize, required this.stopCount}): super._();
  factory _RouteExportRecordDto.fromJson(Map<String, dynamic> json) => _$RouteExportRecordDtoFromJson(json);

@override final  String id;
@override final  String routeId;
@override final  String routeName;
@override final  String fileName;
@override final  DateTime createdAt;
@override final  int byteSize;
@override final  int stopCount;

/// Create a copy of RouteExportRecordDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteExportRecordDtoCopyWith<_RouteExportRecordDto> get copyWith => __$RouteExportRecordDtoCopyWithImpl<_RouteExportRecordDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteExportRecordDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteExportRecordDto&&(identical(other.id, id) || other.id == id)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize)&&(identical(other.stopCount, stopCount) || other.stopCount == stopCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,routeId,routeName,fileName,createdAt,byteSize,stopCount);
}

@override
String toString() {
    return 'RouteExportRecordDto(id: $id, routeId: $routeId, routeName: $routeName, fileName: $fileName, createdAt: $createdAt, byteSize: $byteSize, stopCount: $stopCount)';
}


}

/// @nodoc
abstract mixin class _$RouteExportRecordDtoCopyWith<$Res> implements $RouteExportRecordDtoCopyWith<$Res> {
  factory _$RouteExportRecordDtoCopyWith(_RouteExportRecordDto value, $Res Function(_RouteExportRecordDto) _then) = __$RouteExportRecordDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String routeId, String routeName, String fileName, DateTime createdAt, int byteSize, int stopCount
});




}
/// @nodoc
class __$RouteExportRecordDtoCopyWithImpl<$Res>
    implements _$RouteExportRecordDtoCopyWith<$Res> {
  __$RouteExportRecordDtoCopyWithImpl(this._self, this._then);

  final _RouteExportRecordDto _self;
  final $Res Function(_RouteExportRecordDto) _then;

/// Create a copy of RouteExportRecordDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? routeId = null,Object? routeName = null,Object? fileName = null,Object? createdAt = null,Object? byteSize = null,Object? stopCount = null,}) {
  return _then(_RouteExportRecordDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,routeName: null == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,stopCount: null == stopCount ? _self.stopCount : stopCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RouteExportUploadRequestDto {

 String get routeId; String get routeName; String get fileName; int get byteSize; int get stopCount; String get sha256;
/// Create a copy of RouteExportUploadRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteExportUploadRequestDtoCopyWith<RouteExportUploadRequestDto> get copyWith => _$RouteExportUploadRequestDtoCopyWithImpl<RouteExportUploadRequestDto>(this as RouteExportUploadRequestDto, _$identity);

  /// Serializes this RouteExportUploadRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteExportUploadRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteExportUploadRequestDto&&(identical(other.routeId, _this.routeId) || other.routeId == _this.routeId)&&(identical(other.routeName, _this.routeName) || other.routeName == _this.routeName)&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.byteSize, _this.byteSize) || other.byteSize == _this.byteSize)&&(identical(other.stopCount, _this.stopCount) || other.stopCount == _this.stopCount)&&(identical(other.sha256, _this.sha256) || other.sha256 == _this.sha256));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteExportUploadRequestDto;
  return Object.hash(runtimeType,_this.routeId,_this.routeName,_this.fileName,_this.byteSize,_this.stopCount,_this.sha256);
}

@override
String toString() {
  final _this = this as RouteExportUploadRequestDto;
  return 'RouteExportUploadRequestDto(routeId: ${_this.routeId}, routeName: ${_this.routeName}, fileName: ${_this.fileName}, byteSize: ${_this.byteSize}, stopCount: ${_this.stopCount}, sha256: ${_this.sha256})';
}


}

/// @nodoc
abstract mixin class $RouteExportUploadRequestDtoCopyWith<$Res>  {
  factory $RouteExportUploadRequestDtoCopyWith(RouteExportUploadRequestDto value, $Res Function(RouteExportUploadRequestDto) _then) = _$RouteExportUploadRequestDtoCopyWithImpl;
@useResult
$Res call({
 String routeId, String routeName, String fileName, int byteSize, int stopCount, String sha256
});




}
/// @nodoc
class _$RouteExportUploadRequestDtoCopyWithImpl<$Res>
    implements $RouteExportUploadRequestDtoCopyWith<$Res> {
  _$RouteExportUploadRequestDtoCopyWithImpl(this._self, this._then);

  final RouteExportUploadRequestDto _self;
  final $Res Function(RouteExportUploadRequestDto) _then;

/// Create a copy of RouteExportUploadRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? routeId = null,Object? routeName = null,Object? fileName = null,Object? byteSize = null,Object? stopCount = null,Object? sha256 = null,}) {
  return _then(RouteExportUploadRequestDto(
routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,routeName: null == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,stopCount: null == stopCount ? _self.stopCount : stopCount // ignore: cast_nullable_to_non_nullable
as int,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteExportUploadRequestDto].
extension RouteExportUploadRequestDtoPatterns on RouteExportUploadRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteExportUploadRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteExportUploadRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteExportUploadRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _RouteExportUploadRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteExportUploadRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouteExportUploadRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String routeId,  String routeName,  String fileName,  int byteSize,  int stopCount,  String sha256)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteExportUploadRequestDto() when $default != null:
return $default(_that.routeId,_that.routeName,_that.fileName,_that.byteSize,_that.stopCount,_that.sha256);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String routeId,  String routeName,  String fileName,  int byteSize,  int stopCount,  String sha256)  $default,) {final _that = this;
switch (_that) {
case _RouteExportUploadRequestDto():
return $default(_that.routeId,_that.routeName,_that.fileName,_that.byteSize,_that.stopCount,_that.sha256);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String routeId,  String routeName,  String fileName,  int byteSize,  int stopCount,  String sha256)?  $default,) {final _that = this;
switch (_that) {
case _RouteExportUploadRequestDto() when $default != null:
return $default(_that.routeId,_that.routeName,_that.fileName,_that.byteSize,_that.stopCount,_that.sha256);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteExportUploadRequestDto implements RouteExportUploadRequestDto {
  const _RouteExportUploadRequestDto({required this.routeId, required this.routeName, required this.fileName, required this.byteSize, required this.stopCount, required this.sha256});
  factory _RouteExportUploadRequestDto.fromJson(Map<String, dynamic> json) => _$RouteExportUploadRequestDtoFromJson(json);

@override final  String routeId;
@override final  String routeName;
@override final  String fileName;
@override final  int byteSize;
@override final  int stopCount;
@override final  String sha256;

/// Create a copy of RouteExportUploadRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteExportUploadRequestDtoCopyWith<_RouteExportUploadRequestDto> get copyWith => __$RouteExportUploadRequestDtoCopyWithImpl<_RouteExportUploadRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteExportUploadRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteExportUploadRequestDto&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.routeName, routeName) || other.routeName == routeName)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize)&&(identical(other.stopCount, stopCount) || other.stopCount == stopCount)&&(identical(other.sha256, sha256) || other.sha256 == sha256));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,routeId,routeName,fileName,byteSize,stopCount,sha256);
}

@override
String toString() {
    return 'RouteExportUploadRequestDto(routeId: $routeId, routeName: $routeName, fileName: $fileName, byteSize: $byteSize, stopCount: $stopCount, sha256: $sha256)';
}


}

/// @nodoc
abstract mixin class _$RouteExportUploadRequestDtoCopyWith<$Res> implements $RouteExportUploadRequestDtoCopyWith<$Res> {
  factory _$RouteExportUploadRequestDtoCopyWith(_RouteExportUploadRequestDto value, $Res Function(_RouteExportUploadRequestDto) _then) = __$RouteExportUploadRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String routeId, String routeName, String fileName, int byteSize, int stopCount, String sha256
});




}
/// @nodoc
class __$RouteExportUploadRequestDtoCopyWithImpl<$Res>
    implements _$RouteExportUploadRequestDtoCopyWith<$Res> {
  __$RouteExportUploadRequestDtoCopyWithImpl(this._self, this._then);

  final _RouteExportUploadRequestDto _self;
  final $Res Function(_RouteExportUploadRequestDto) _then;

/// Create a copy of RouteExportUploadRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? routeId = null,Object? routeName = null,Object? fileName = null,Object? byteSize = null,Object? stopCount = null,Object? sha256 = null,}) {
  return _then(_RouteExportUploadRequestDto(
routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,routeName: null == routeName ? _self.routeName : routeName // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,stopCount: null == stopCount ? _self.stopCount : stopCount // ignore: cast_nullable_to_non_nullable
as int,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RouteExportUploadTicketDto {

 String get id; String get uploadUrl; DateTime get expiresAt; Map<String, String> get uploadHeaders;
/// Create a copy of RouteExportUploadTicketDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteExportUploadTicketDtoCopyWith<RouteExportUploadTicketDto> get copyWith => _$RouteExportUploadTicketDtoCopyWithImpl<RouteExportUploadTicketDto>(this as RouteExportUploadTicketDto, _$identity);

  /// Serializes this RouteExportUploadTicketDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteExportUploadTicketDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteExportUploadTicketDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.uploadUrl, _this.uploadUrl) || other.uploadUrl == _this.uploadUrl)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&const DeepCollectionEquality().equals(other.uploadHeaders, _this.uploadHeaders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteExportUploadTicketDto;
  return Object.hash(runtimeType,_this.id,_this.uploadUrl,_this.expiresAt,const DeepCollectionEquality().hash(_this.uploadHeaders));
}

@override
String toString() {
  final _this = this as RouteExportUploadTicketDto;
  return 'RouteExportUploadTicketDto(id: ${_this.id}, uploadUrl: ${_this.uploadUrl}, expiresAt: ${_this.expiresAt}, uploadHeaders: ${_this.uploadHeaders})';
}


}

/// @nodoc
abstract mixin class $RouteExportUploadTicketDtoCopyWith<$Res>  {
  factory $RouteExportUploadTicketDtoCopyWith(RouteExportUploadTicketDto value, $Res Function(RouteExportUploadTicketDto) _then) = _$RouteExportUploadTicketDtoCopyWithImpl;
@useResult
$Res call({
 String id, String uploadUrl, DateTime expiresAt, Map<String, String> uploadHeaders
});




}
/// @nodoc
class _$RouteExportUploadTicketDtoCopyWithImpl<$Res>
    implements $RouteExportUploadTicketDtoCopyWith<$Res> {
  _$RouteExportUploadTicketDtoCopyWithImpl(this._self, this._then);

  final RouteExportUploadTicketDto _self;
  final $Res Function(RouteExportUploadTicketDto) _then;

/// Create a copy of RouteExportUploadTicketDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uploadUrl = null,Object? expiresAt = null,Object? uploadHeaders = null,}) {
  return _then(RouteExportUploadTicketDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,uploadHeaders: null == uploadHeaders ? _self.uploadHeaders : uploadHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteExportUploadTicketDto].
extension RouteExportUploadTicketDtoPatterns on RouteExportUploadTicketDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteExportUploadTicketDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteExportUploadTicketDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteExportUploadTicketDto value)  $default,){
final _that = this;
switch (_that) {
case _RouteExportUploadTicketDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteExportUploadTicketDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouteExportUploadTicketDto() when $default != null:
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
case _RouteExportUploadTicketDto() when $default != null:
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
case _RouteExportUploadTicketDto():
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
case _RouteExportUploadTicketDto() when $default != null:
return $default(_that.id,_that.uploadUrl,_that.expiresAt,_that.uploadHeaders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteExportUploadTicketDto implements RouteExportUploadTicketDto {
  const _RouteExportUploadTicketDto({required this.id, required this.uploadUrl, required this.expiresAt,  Map<String, String> uploadHeaders = const <String, String>{}}): _uploadHeaders = uploadHeaders;
  factory _RouteExportUploadTicketDto.fromJson(Map<String, dynamic> json) => _$RouteExportUploadTicketDtoFromJson(json);

@override final  String id;
@override final  String uploadUrl;
@override final  DateTime expiresAt;
 final  Map<String, String> _uploadHeaders;
@override@JsonKey() Map<String, String> get uploadHeaders {
  if (_uploadHeaders is EqualUnmodifiableMapView) return _uploadHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_uploadHeaders);
}


/// Create a copy of RouteExportUploadTicketDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteExportUploadTicketDtoCopyWith<_RouteExportUploadTicketDto> get copyWith => __$RouteExportUploadTicketDtoCopyWithImpl<_RouteExportUploadTicketDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteExportUploadTicketDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteExportUploadTicketDto&&(identical(other.id, id) || other.id == id)&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other.uploadHeaders, _uploadHeaders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,uploadUrl,expiresAt,const DeepCollectionEquality().hash(_uploadHeaders));
}

@override
String toString() {
    return 'RouteExportUploadTicketDto(id: $id, uploadUrl: $uploadUrl, expiresAt: $expiresAt, uploadHeaders: $uploadHeaders)';
}


}

/// @nodoc
abstract mixin class _$RouteExportUploadTicketDtoCopyWith<$Res> implements $RouteExportUploadTicketDtoCopyWith<$Res> {
  factory _$RouteExportUploadTicketDtoCopyWith(_RouteExportUploadTicketDto value, $Res Function(_RouteExportUploadTicketDto) _then) = __$RouteExportUploadTicketDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String uploadUrl, DateTime expiresAt, Map<String, String> uploadHeaders
});




}
/// @nodoc
class __$RouteExportUploadTicketDtoCopyWithImpl<$Res>
    implements _$RouteExportUploadTicketDtoCopyWith<$Res> {
  __$RouteExportUploadTicketDtoCopyWithImpl(this._self, this._then);

  final _RouteExportUploadTicketDto _self;
  final $Res Function(_RouteExportUploadTicketDto) _then;

/// Create a copy of RouteExportUploadTicketDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uploadUrl = null,Object? expiresAt = null,Object? uploadHeaders = null,}) {
  return _then(_RouteExportUploadTicketDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,uploadHeaders: null == uploadHeaders ? _self._uploadHeaders : uploadHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$RouteExportPageDto {

 List<RouteExportRecordDto> get items; String? get nextCursor;
/// Create a copy of RouteExportPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteExportPageDtoCopyWith<RouteExportPageDto> get copyWith => _$RouteExportPageDtoCopyWithImpl<RouteExportPageDto>(this as RouteExportPageDto, _$identity);

  /// Serializes this RouteExportPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteExportPageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteExportPageDto&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteExportPageDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as RouteExportPageDto;
  return 'RouteExportPageDto(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $RouteExportPageDtoCopyWith<$Res>  {
  factory $RouteExportPageDtoCopyWith(RouteExportPageDto value, $Res Function(RouteExportPageDto) _then) = _$RouteExportPageDtoCopyWithImpl;
@useResult
$Res call({
 List<RouteExportRecordDto> items, String? nextCursor
});




}
/// @nodoc
class _$RouteExportPageDtoCopyWithImpl<$Res>
    implements $RouteExportPageDtoCopyWith<$Res> {
  _$RouteExportPageDtoCopyWithImpl(this._self, this._then);

  final RouteExportPageDto _self;
  final $Res Function(RouteExportPageDto) _then;

/// Create a copy of RouteExportPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(RouteExportPageDto(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<RouteExportRecordDto>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteExportPageDto].
extension RouteExportPageDtoPatterns on RouteExportPageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteExportPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteExportPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteExportPageDto value)  $default,){
final _that = this;
switch (_that) {
case _RouteExportPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteExportPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouteExportPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RouteExportRecordDto> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteExportPageDto() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RouteExportRecordDto> items,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _RouteExportPageDto():
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RouteExportRecordDto> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _RouteExportPageDto() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteExportPageDto implements RouteExportPageDto {
  const _RouteExportPageDto({required  List<RouteExportRecordDto> items, this.nextCursor}): _items = items;
  factory _RouteExportPageDto.fromJson(Map<String, dynamic> json) => _$RouteExportPageDtoFromJson(json);

 final  List<RouteExportRecordDto> _items;
@override List<RouteExportRecordDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? nextCursor;

/// Create a copy of RouteExportPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteExportPageDtoCopyWith<_RouteExportPageDto> get copyWith => __$RouteExportPageDtoCopyWithImpl<_RouteExportPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteExportPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteExportPageDto&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'RouteExportPageDto(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$RouteExportPageDtoCopyWith<$Res> implements $RouteExportPageDtoCopyWith<$Res> {
  factory _$RouteExportPageDtoCopyWith(_RouteExportPageDto value, $Res Function(_RouteExportPageDto) _then) = __$RouteExportPageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<RouteExportRecordDto> items, String? nextCursor
});




}
/// @nodoc
class __$RouteExportPageDtoCopyWithImpl<$Res>
    implements _$RouteExportPageDtoCopyWith<$Res> {
  __$RouteExportPageDtoCopyWithImpl(this._self, this._then);

  final _RouteExportPageDto _self;
  final $Res Function(_RouteExportPageDto) _then;

/// Create a copy of RouteExportPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_RouteExportPageDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<RouteExportRecordDto>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RouteExportDownloadDto {

 String get url; DateTime get expiresAt;
/// Create a copy of RouteExportDownloadDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteExportDownloadDtoCopyWith<RouteExportDownloadDto> get copyWith => _$RouteExportDownloadDtoCopyWithImpl<RouteExportDownloadDto>(this as RouteExportDownloadDto, _$identity);

  /// Serializes this RouteExportDownloadDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteExportDownloadDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteExportDownloadDto&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteExportDownloadDto;
  return Object.hash(runtimeType,_this.url,_this.expiresAt);
}

@override
String toString() {
  final _this = this as RouteExportDownloadDto;
  return 'RouteExportDownloadDto(url: ${_this.url}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $RouteExportDownloadDtoCopyWith<$Res>  {
  factory $RouteExportDownloadDtoCopyWith(RouteExportDownloadDto value, $Res Function(RouteExportDownloadDto) _then) = _$RouteExportDownloadDtoCopyWithImpl;
@useResult
$Res call({
 String url, DateTime expiresAt
});




}
/// @nodoc
class _$RouteExportDownloadDtoCopyWithImpl<$Res>
    implements $RouteExportDownloadDtoCopyWith<$Res> {
  _$RouteExportDownloadDtoCopyWithImpl(this._self, this._then);

  final RouteExportDownloadDto _self;
  final $Res Function(RouteExportDownloadDto) _then;

/// Create a copy of RouteExportDownloadDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? expiresAt = null,}) {
  return _then(RouteExportDownloadDto(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteExportDownloadDto].
extension RouteExportDownloadDtoPatterns on RouteExportDownloadDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteExportDownloadDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteExportDownloadDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteExportDownloadDto value)  $default,){
final _that = this;
switch (_that) {
case _RouteExportDownloadDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteExportDownloadDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouteExportDownloadDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteExportDownloadDto() when $default != null:
return $default(_that.url,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _RouteExportDownloadDto():
return $default(_that.url,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _RouteExportDownloadDto() when $default != null:
return $default(_that.url,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteExportDownloadDto extends RouteExportDownloadDto {
  const _RouteExportDownloadDto({required this.url, required this.expiresAt}): super._();
  factory _RouteExportDownloadDto.fromJson(Map<String, dynamic> json) => _$RouteExportDownloadDtoFromJson(json);

@override final  String url;
@override final  DateTime expiresAt;

/// Create a copy of RouteExportDownloadDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteExportDownloadDtoCopyWith<_RouteExportDownloadDto> get copyWith => __$RouteExportDownloadDtoCopyWithImpl<_RouteExportDownloadDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteExportDownloadDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteExportDownloadDto&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,url,expiresAt);
}

@override
String toString() {
    return 'RouteExportDownloadDto(url: $url, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$RouteExportDownloadDtoCopyWith<$Res> implements $RouteExportDownloadDtoCopyWith<$Res> {
  factory _$RouteExportDownloadDtoCopyWith(_RouteExportDownloadDto value, $Res Function(_RouteExportDownloadDto) _then) = __$RouteExportDownloadDtoCopyWithImpl;
@override @useResult
$Res call({
 String url, DateTime expiresAt
});




}
/// @nodoc
class __$RouteExportDownloadDtoCopyWithImpl<$Res>
    implements _$RouteExportDownloadDtoCopyWith<$Res> {
  __$RouteExportDownloadDtoCopyWithImpl(this._self, this._then);

  final _RouteExportDownloadDto _self;
  final $Res Function(_RouteExportDownloadDto) _then;

/// Create a copy of RouteExportDownloadDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? expiresAt = null,}) {
  return _then(_RouteExportDownloadDto(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
