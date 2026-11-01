// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedbackRequestDto {

 String get category; String get message;@JsonKey(includeIfNull: false) int? get rating;@JsonKey(includeIfNull: false) String? get appVersion;@JsonKey(includeIfNull: false) String? get platform;
/// Create a copy of FeedbackRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedbackRequestDtoCopyWith<FeedbackRequestDto> get copyWith => _$FeedbackRequestDtoCopyWithImpl<FeedbackRequestDto>(this as FeedbackRequestDto, _$identity);

  /// Serializes this FeedbackRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedbackRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedbackRequestDto&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.appVersion, _this.appVersion) || other.appVersion == _this.appVersion)&&(identical(other.platform, _this.platform) || other.platform == _this.platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedbackRequestDto;
  return Object.hash(runtimeType,_this.category,_this.message,_this.rating,_this.appVersion,_this.platform);
}

@override
String toString() {
  final _this = this as FeedbackRequestDto;
  return 'FeedbackRequestDto(category: ${_this.category}, message: ${_this.message}, rating: ${_this.rating}, appVersion: ${_this.appVersion}, platform: ${_this.platform})';
}


}

/// @nodoc
abstract mixin class $FeedbackRequestDtoCopyWith<$Res>  {
  factory $FeedbackRequestDtoCopyWith(FeedbackRequestDto value, $Res Function(FeedbackRequestDto) _then) = _$FeedbackRequestDtoCopyWithImpl;
@useResult
$Res call({
 String category, String message,@JsonKey(includeIfNull: false) int? rating,@JsonKey(includeIfNull: false) String? appVersion,@JsonKey(includeIfNull: false) String? platform
});




}
/// @nodoc
class _$FeedbackRequestDtoCopyWithImpl<$Res>
    implements $FeedbackRequestDtoCopyWith<$Res> {
  _$FeedbackRequestDtoCopyWithImpl(this._self, this._then);

  final FeedbackRequestDto _self;
  final $Res Function(FeedbackRequestDto) _then;

/// Create a copy of FeedbackRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? message = null,Object? rating = freezed,Object? appVersion = freezed,Object? platform = freezed,}) {
  return _then(FeedbackRequestDto(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedbackRequestDto].
extension FeedbackRequestDtoPatterns on FeedbackRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedbackRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedbackRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedbackRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _FeedbackRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedbackRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _FeedbackRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String category,  String message, @JsonKey(includeIfNull: false)  int? rating, @JsonKey(includeIfNull: false)  String? appVersion, @JsonKey(includeIfNull: false)  String? platform)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedbackRequestDto() when $default != null:
return $default(_that.category,_that.message,_that.rating,_that.appVersion,_that.platform);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String category,  String message, @JsonKey(includeIfNull: false)  int? rating, @JsonKey(includeIfNull: false)  String? appVersion, @JsonKey(includeIfNull: false)  String? platform)  $default,) {final _that = this;
switch (_that) {
case _FeedbackRequestDto():
return $default(_that.category,_that.message,_that.rating,_that.appVersion,_that.platform);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String category,  String message, @JsonKey(includeIfNull: false)  int? rating, @JsonKey(includeIfNull: false)  String? appVersion, @JsonKey(includeIfNull: false)  String? platform)?  $default,) {final _that = this;
switch (_that) {
case _FeedbackRequestDto() when $default != null:
return $default(_that.category,_that.message,_that.rating,_that.appVersion,_that.platform);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedbackRequestDto implements FeedbackRequestDto {
  const _FeedbackRequestDto({required this.category, required this.message, @JsonKey(includeIfNull: false) this.rating, @JsonKey(includeIfNull: false) this.appVersion, @JsonKey(includeIfNull: false) this.platform});
  factory _FeedbackRequestDto.fromJson(Map<String, dynamic> json) => _$FeedbackRequestDtoFromJson(json);

@override final  String category;
@override final  String message;
@override@JsonKey(includeIfNull: false) final  int? rating;
@override@JsonKey(includeIfNull: false) final  String? appVersion;
@override@JsonKey(includeIfNull: false) final  String? platform;

/// Create a copy of FeedbackRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedbackRequestDtoCopyWith<_FeedbackRequestDto> get copyWith => __$FeedbackRequestDtoCopyWithImpl<_FeedbackRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedbackRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedbackRequestDto&&(identical(other.category, category) || other.category == category)&&(identical(other.message, message) || other.message == message)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.platform, platform) || other.platform == platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,category,message,rating,appVersion,platform);
}

@override
String toString() {
    return 'FeedbackRequestDto(category: $category, message: $message, rating: $rating, appVersion: $appVersion, platform: $platform)';
}


}

/// @nodoc
abstract mixin class _$FeedbackRequestDtoCopyWith<$Res> implements $FeedbackRequestDtoCopyWith<$Res> {
  factory _$FeedbackRequestDtoCopyWith(_FeedbackRequestDto value, $Res Function(_FeedbackRequestDto) _then) = __$FeedbackRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String category, String message,@JsonKey(includeIfNull: false) int? rating,@JsonKey(includeIfNull: false) String? appVersion,@JsonKey(includeIfNull: false) String? platform
});




}
/// @nodoc
class __$FeedbackRequestDtoCopyWithImpl<$Res>
    implements _$FeedbackRequestDtoCopyWith<$Res> {
  __$FeedbackRequestDtoCopyWithImpl(this._self, this._then);

  final _FeedbackRequestDto _self;
  final $Res Function(_FeedbackRequestDto) _then;

/// Create a copy of FeedbackRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? message = null,Object? rating = freezed,Object? appVersion = freezed,Object? platform = freezed,}) {
  return _then(_FeedbackRequestDto(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
