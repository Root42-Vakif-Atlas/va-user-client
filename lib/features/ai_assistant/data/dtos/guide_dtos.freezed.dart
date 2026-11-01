// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guide_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AskGuideRequestDto {

 String get message;@JsonKey(includeIfNull: false) String? get conversationId;
/// Create a copy of AskGuideRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AskGuideRequestDtoCopyWith<AskGuideRequestDto> get copyWith => _$AskGuideRequestDtoCopyWithImpl<AskGuideRequestDto>(this as AskGuideRequestDto, _$identity);

  /// Serializes this AskGuideRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AskGuideRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AskGuideRequestDto&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AskGuideRequestDto;
  return Object.hash(runtimeType,_this.message,_this.conversationId);
}

@override
String toString() {
  final _this = this as AskGuideRequestDto;
  return 'AskGuideRequestDto(message: ${_this.message}, conversationId: ${_this.conversationId})';
}


}

/// @nodoc
abstract mixin class $AskGuideRequestDtoCopyWith<$Res>  {
  factory $AskGuideRequestDtoCopyWith(AskGuideRequestDto value, $Res Function(AskGuideRequestDto) _then) = _$AskGuideRequestDtoCopyWithImpl;
@useResult
$Res call({
 String message,@JsonKey(includeIfNull: false) String? conversationId
});




}
/// @nodoc
class _$AskGuideRequestDtoCopyWithImpl<$Res>
    implements $AskGuideRequestDtoCopyWith<$Res> {
  _$AskGuideRequestDtoCopyWithImpl(this._self, this._then);

  final AskGuideRequestDto _self;
  final $Res Function(AskGuideRequestDto) _then;

/// Create a copy of AskGuideRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? conversationId = freezed,}) {
  return _then(AskGuideRequestDto(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AskGuideRequestDto].
extension AskGuideRequestDtoPatterns on AskGuideRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AskGuideRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AskGuideRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AskGuideRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _AskGuideRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AskGuideRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _AskGuideRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message, @JsonKey(includeIfNull: false)  String? conversationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AskGuideRequestDto() when $default != null:
return $default(_that.message,_that.conversationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message, @JsonKey(includeIfNull: false)  String? conversationId)  $default,) {final _that = this;
switch (_that) {
case _AskGuideRequestDto():
return $default(_that.message,_that.conversationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message, @JsonKey(includeIfNull: false)  String? conversationId)?  $default,) {final _that = this;
switch (_that) {
case _AskGuideRequestDto() when $default != null:
return $default(_that.message,_that.conversationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AskGuideRequestDto implements AskGuideRequestDto {
  const _AskGuideRequestDto({required this.message, @JsonKey(includeIfNull: false) this.conversationId});
  factory _AskGuideRequestDto.fromJson(Map<String, dynamic> json) => _$AskGuideRequestDtoFromJson(json);

@override final  String message;
@override@JsonKey(includeIfNull: false) final  String? conversationId;

/// Create a copy of AskGuideRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AskGuideRequestDtoCopyWith<_AskGuideRequestDto> get copyWith => __$AskGuideRequestDtoCopyWithImpl<_AskGuideRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AskGuideRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AskGuideRequestDto&&(identical(other.message, message) || other.message == message)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,message,conversationId);
}

@override
String toString() {
    return 'AskGuideRequestDto(message: $message, conversationId: $conversationId)';
}


}

/// @nodoc
abstract mixin class _$AskGuideRequestDtoCopyWith<$Res> implements $AskGuideRequestDtoCopyWith<$Res> {
  factory _$AskGuideRequestDtoCopyWith(_AskGuideRequestDto value, $Res Function(_AskGuideRequestDto) _then) = __$AskGuideRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String message,@JsonKey(includeIfNull: false) String? conversationId
});




}
/// @nodoc
class __$AskGuideRequestDtoCopyWithImpl<$Res>
    implements _$AskGuideRequestDtoCopyWith<$Res> {
  __$AskGuideRequestDtoCopyWithImpl(this._self, this._then);

  final _AskGuideRequestDto _self;
  final $Res Function(_AskGuideRequestDto) _then;

/// Create a copy of AskGuideRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? conversationId = freezed,}) {
  return _then(_AskGuideRequestDto(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GuideReplyDto {

 String get conversationId; GuideMessageDto get message;
/// Create a copy of GuideReplyDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuideReplyDtoCopyWith<GuideReplyDto> get copyWith => _$GuideReplyDtoCopyWithImpl<GuideReplyDto>(this as GuideReplyDto, _$identity);

  /// Serializes this GuideReplyDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GuideReplyDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuideReplyDto&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.message, _this.message) || other.message == _this.message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GuideReplyDto;
  return Object.hash(runtimeType,_this.conversationId,_this.message);
}

@override
String toString() {
  final _this = this as GuideReplyDto;
  return 'GuideReplyDto(conversationId: ${_this.conversationId}, message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $GuideReplyDtoCopyWith<$Res>  {
  factory $GuideReplyDtoCopyWith(GuideReplyDto value, $Res Function(GuideReplyDto) _then) = _$GuideReplyDtoCopyWithImpl;
@useResult
$Res call({
 String conversationId, GuideMessageDto message
});


$GuideMessageDtoCopyWith<$Res> get message;

}
/// @nodoc
class _$GuideReplyDtoCopyWithImpl<$Res>
    implements $GuideReplyDtoCopyWith<$Res> {
  _$GuideReplyDtoCopyWithImpl(this._self, this._then);

  final GuideReplyDto _self;
  final $Res Function(GuideReplyDto) _then;

/// Create a copy of GuideReplyDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? message = null,}) {
  return _then(GuideReplyDto(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as GuideMessageDto,
  ));
}
/// Create a copy of GuideReplyDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GuideMessageDtoCopyWith<$Res> get message {
  
  return $GuideMessageDtoCopyWith<$Res>(_self.message, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}


/// Adds pattern-matching-related methods to [GuideReplyDto].
extension GuideReplyDtoPatterns on GuideReplyDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuideReplyDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuideReplyDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuideReplyDto value)  $default,){
final _that = this;
switch (_that) {
case _GuideReplyDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuideReplyDto value)?  $default,){
final _that = this;
switch (_that) {
case _GuideReplyDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String conversationId,  GuideMessageDto message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuideReplyDto() when $default != null:
return $default(_that.conversationId,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String conversationId,  GuideMessageDto message)  $default,) {final _that = this;
switch (_that) {
case _GuideReplyDto():
return $default(_that.conversationId,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String conversationId,  GuideMessageDto message)?  $default,) {final _that = this;
switch (_that) {
case _GuideReplyDto() when $default != null:
return $default(_that.conversationId,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GuideReplyDto extends GuideReplyDto {
  const _GuideReplyDto({required this.conversationId, required this.message}): super._();
  factory _GuideReplyDto.fromJson(Map<String, dynamic> json) => _$GuideReplyDtoFromJson(json);

@override final  String conversationId;
@override final  GuideMessageDto message;

/// Create a copy of GuideReplyDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuideReplyDtoCopyWith<_GuideReplyDto> get copyWith => __$GuideReplyDtoCopyWithImpl<_GuideReplyDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuideReplyDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuideReplyDto&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,conversationId,message);
}

@override
String toString() {
    return 'GuideReplyDto(conversationId: $conversationId, message: $message)';
}


}

/// @nodoc
abstract mixin class _$GuideReplyDtoCopyWith<$Res> implements $GuideReplyDtoCopyWith<$Res> {
  factory _$GuideReplyDtoCopyWith(_GuideReplyDto value, $Res Function(_GuideReplyDto) _then) = __$GuideReplyDtoCopyWithImpl;
@override @useResult
$Res call({
 String conversationId, GuideMessageDto message
});


@override $GuideMessageDtoCopyWith<$Res> get message;

}
/// @nodoc
class __$GuideReplyDtoCopyWithImpl<$Res>
    implements _$GuideReplyDtoCopyWith<$Res> {
  __$GuideReplyDtoCopyWithImpl(this._self, this._then);

  final _GuideReplyDto _self;
  final $Res Function(_GuideReplyDto) _then;

/// Create a copy of GuideReplyDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? message = null,}) {
  return _then(_GuideReplyDto(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as GuideMessageDto,
  ));
}

/// Create a copy of GuideReplyDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GuideMessageDtoCopyWith<$Res> get message {
  
  return $GuideMessageDtoCopyWith<$Res>(_self.message, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}


/// @nodoc
mixin _$GuideMessageDto {

 String get id; String get text; DateTime get createdAt; List<GuideSourceDto> get sources; List<GuideActionDto> get actions; List<String> get suggestions; String? get notice;
/// Create a copy of GuideMessageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuideMessageDtoCopyWith<GuideMessageDto> get copyWith => _$GuideMessageDtoCopyWithImpl<GuideMessageDto>(this as GuideMessageDto, _$identity);

  /// Serializes this GuideMessageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GuideMessageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuideMessageDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.sources, _this.sources)&&const DeepCollectionEquality().equals(other.actions, _this.actions)&&const DeepCollectionEquality().equals(other.suggestions, _this.suggestions)&&(identical(other.notice, _this.notice) || other.notice == _this.notice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GuideMessageDto;
  return Object.hash(runtimeType,_this.id,_this.text,_this.createdAt,const DeepCollectionEquality().hash(_this.sources),const DeepCollectionEquality().hash(_this.actions),const DeepCollectionEquality().hash(_this.suggestions),_this.notice);
}

@override
String toString() {
  final _this = this as GuideMessageDto;
  return 'GuideMessageDto(id: ${_this.id}, text: ${_this.text}, createdAt: ${_this.createdAt}, sources: ${_this.sources}, actions: ${_this.actions}, suggestions: ${_this.suggestions}, notice: ${_this.notice})';
}


}

/// @nodoc
abstract mixin class $GuideMessageDtoCopyWith<$Res>  {
  factory $GuideMessageDtoCopyWith(GuideMessageDto value, $Res Function(GuideMessageDto) _then) = _$GuideMessageDtoCopyWithImpl;
@useResult
$Res call({
 String id, String text, DateTime createdAt, List<GuideSourceDto> sources, List<GuideActionDto> actions, List<String> suggestions, String? notice
});




}
/// @nodoc
class _$GuideMessageDtoCopyWithImpl<$Res>
    implements $GuideMessageDtoCopyWith<$Res> {
  _$GuideMessageDtoCopyWithImpl(this._self, this._then);

  final GuideMessageDto _self;
  final $Res Function(GuideMessageDto) _then;

/// Create a copy of GuideMessageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? createdAt = null,Object? sources = null,Object? actions = null,Object? suggestions = null,Object? notice = freezed,}) {
  return _then(GuideMessageDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<GuideSourceDto>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<GuideActionDto>,suggestions: null == suggestions ? _self.suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GuideMessageDto].
extension GuideMessageDtoPatterns on GuideMessageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuideMessageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuideMessageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuideMessageDto value)  $default,){
final _that = this;
switch (_that) {
case _GuideMessageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuideMessageDto value)?  $default,){
final _that = this;
switch (_that) {
case _GuideMessageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  DateTime createdAt,  List<GuideSourceDto> sources,  List<GuideActionDto> actions,  List<String> suggestions,  String? notice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuideMessageDto() when $default != null:
return $default(_that.id,_that.text,_that.createdAt,_that.sources,_that.actions,_that.suggestions,_that.notice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  DateTime createdAt,  List<GuideSourceDto> sources,  List<GuideActionDto> actions,  List<String> suggestions,  String? notice)  $default,) {final _that = this;
switch (_that) {
case _GuideMessageDto():
return $default(_that.id,_that.text,_that.createdAt,_that.sources,_that.actions,_that.suggestions,_that.notice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  DateTime createdAt,  List<GuideSourceDto> sources,  List<GuideActionDto> actions,  List<String> suggestions,  String? notice)?  $default,) {final _that = this;
switch (_that) {
case _GuideMessageDto() when $default != null:
return $default(_that.id,_that.text,_that.createdAt,_that.sources,_that.actions,_that.suggestions,_that.notice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GuideMessageDto extends GuideMessageDto {
  const _GuideMessageDto({required this.id, required this.text, required this.createdAt,  List<GuideSourceDto> sources = const <GuideSourceDto>[],  List<GuideActionDto> actions = const <GuideActionDto>[],  List<String> suggestions = const <String>[], this.notice}): _sources = sources,_actions = actions,_suggestions = suggestions,super._();
  factory _GuideMessageDto.fromJson(Map<String, dynamic> json) => _$GuideMessageDtoFromJson(json);

@override final  String id;
@override final  String text;
@override final  DateTime createdAt;
 final  List<GuideSourceDto> _sources;
@override@JsonKey() List<GuideSourceDto> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

 final  List<GuideActionDto> _actions;
@override@JsonKey() List<GuideActionDto> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}

 final  List<String> _suggestions;
@override@JsonKey() List<String> get suggestions {
  if (_suggestions is EqualUnmodifiableListView) return _suggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestions);
}

@override final  String? notice;

/// Create a copy of GuideMessageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuideMessageDtoCopyWith<_GuideMessageDto> get copyWith => __$GuideMessageDtoCopyWithImpl<_GuideMessageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuideMessageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuideMessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.sources, _sources)&&const DeepCollectionEquality().equals(other.actions, _actions)&&const DeepCollectionEquality().equals(other.suggestions, _suggestions)&&(identical(other.notice, notice) || other.notice == notice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,text,createdAt,const DeepCollectionEquality().hash(_sources),const DeepCollectionEquality().hash(_actions),const DeepCollectionEquality().hash(_suggestions),notice);
}

@override
String toString() {
    return 'GuideMessageDto(id: $id, text: $text, createdAt: $createdAt, sources: $sources, actions: $actions, suggestions: $suggestions, notice: $notice)';
}


}

/// @nodoc
abstract mixin class _$GuideMessageDtoCopyWith<$Res> implements $GuideMessageDtoCopyWith<$Res> {
  factory _$GuideMessageDtoCopyWith(_GuideMessageDto value, $Res Function(_GuideMessageDto) _then) = __$GuideMessageDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, DateTime createdAt, List<GuideSourceDto> sources, List<GuideActionDto> actions, List<String> suggestions, String? notice
});




}
/// @nodoc
class __$GuideMessageDtoCopyWithImpl<$Res>
    implements _$GuideMessageDtoCopyWith<$Res> {
  __$GuideMessageDtoCopyWithImpl(this._self, this._then);

  final _GuideMessageDto _self;
  final $Res Function(_GuideMessageDto) _then;

/// Create a copy of GuideMessageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? createdAt = null,Object? sources = null,Object? actions = null,Object? suggestions = null,Object? notice = freezed,}) {
  return _then(_GuideMessageDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<GuideSourceDto>,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<GuideActionDto>,suggestions: null == suggestions ? _self._suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GuideSourceDto {

 String get monumentId; String get name; String? get city;
/// Create a copy of GuideSourceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuideSourceDtoCopyWith<GuideSourceDto> get copyWith => _$GuideSourceDtoCopyWithImpl<GuideSourceDto>(this as GuideSourceDto, _$identity);

  /// Serializes this GuideSourceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GuideSourceDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuideSourceDto&&(identical(other.monumentId, _this.monumentId) || other.monumentId == _this.monumentId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.city, _this.city) || other.city == _this.city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GuideSourceDto;
  return Object.hash(runtimeType,_this.monumentId,_this.name,_this.city);
}

@override
String toString() {
  final _this = this as GuideSourceDto;
  return 'GuideSourceDto(monumentId: ${_this.monumentId}, name: ${_this.name}, city: ${_this.city})';
}


}

/// @nodoc
abstract mixin class $GuideSourceDtoCopyWith<$Res>  {
  factory $GuideSourceDtoCopyWith(GuideSourceDto value, $Res Function(GuideSourceDto) _then) = _$GuideSourceDtoCopyWithImpl;
@useResult
$Res call({
 String monumentId, String name, String? city
});




}
/// @nodoc
class _$GuideSourceDtoCopyWithImpl<$Res>
    implements $GuideSourceDtoCopyWith<$Res> {
  _$GuideSourceDtoCopyWithImpl(this._self, this._then);

  final GuideSourceDto _self;
  final $Res Function(GuideSourceDto) _then;

/// Create a copy of GuideSourceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monumentId = null,Object? name = null,Object? city = freezed,}) {
  return _then(GuideSourceDto(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GuideSourceDto].
extension GuideSourceDtoPatterns on GuideSourceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuideSourceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuideSourceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuideSourceDto value)  $default,){
final _that = this;
switch (_that) {
case _GuideSourceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuideSourceDto value)?  $default,){
final _that = this;
switch (_that) {
case _GuideSourceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String monumentId,  String name,  String? city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuideSourceDto() when $default != null:
return $default(_that.monumentId,_that.name,_that.city);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String monumentId,  String name,  String? city)  $default,) {final _that = this;
switch (_that) {
case _GuideSourceDto():
return $default(_that.monumentId,_that.name,_that.city);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String monumentId,  String name,  String? city)?  $default,) {final _that = this;
switch (_that) {
case _GuideSourceDto() when $default != null:
return $default(_that.monumentId,_that.name,_that.city);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GuideSourceDto extends GuideSourceDto {
  const _GuideSourceDto({required this.monumentId, required this.name, this.city}): super._();
  factory _GuideSourceDto.fromJson(Map<String, dynamic> json) => _$GuideSourceDtoFromJson(json);

@override final  String monumentId;
@override final  String name;
@override final  String? city;

/// Create a copy of GuideSourceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuideSourceDtoCopyWith<_GuideSourceDto> get copyWith => __$GuideSourceDtoCopyWithImpl<_GuideSourceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuideSourceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuideSourceDto&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,monumentId,name,city);
}

@override
String toString() {
    return 'GuideSourceDto(monumentId: $monumentId, name: $name, city: $city)';
}


}

/// @nodoc
abstract mixin class _$GuideSourceDtoCopyWith<$Res> implements $GuideSourceDtoCopyWith<$Res> {
  factory _$GuideSourceDtoCopyWith(_GuideSourceDto value, $Res Function(_GuideSourceDto) _then) = __$GuideSourceDtoCopyWithImpl;
@override @useResult
$Res call({
 String monumentId, String name, String? city
});




}
/// @nodoc
class __$GuideSourceDtoCopyWithImpl<$Res>
    implements _$GuideSourceDtoCopyWith<$Res> {
  __$GuideSourceDtoCopyWithImpl(this._self, this._then);

  final _GuideSourceDto _self;
  final $Res Function(_GuideSourceDto) _then;

/// Create a copy of GuideSourceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monumentId = null,Object? name = null,Object? city = freezed,}) {
  return _then(_GuideSourceDto(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GuideActionDto {

 String get type; String? get monumentId; String? get monumentName; String? get destination; String? get q; List<String> get categories; List<String> get periods; List<String> get cities; int? get total;
/// Create a copy of GuideActionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuideActionDtoCopyWith<GuideActionDto> get copyWith => _$GuideActionDtoCopyWithImpl<GuideActionDto>(this as GuideActionDto, _$identity);

  /// Serializes this GuideActionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GuideActionDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuideActionDto&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.monumentId, _this.monumentId) || other.monumentId == _this.monumentId)&&(identical(other.monumentName, _this.monumentName) || other.monumentName == _this.monumentName)&&(identical(other.destination, _this.destination) || other.destination == _this.destination)&&(identical(other.q, _this.q) || other.q == _this.q)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&const DeepCollectionEquality().equals(other.periods, _this.periods)&&const DeepCollectionEquality().equals(other.cities, _this.cities)&&(identical(other.total, _this.total) || other.total == _this.total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GuideActionDto;
  return Object.hash(runtimeType,_this.type,_this.monumentId,_this.monumentName,_this.destination,_this.q,const DeepCollectionEquality().hash(_this.categories),const DeepCollectionEquality().hash(_this.periods),const DeepCollectionEquality().hash(_this.cities),_this.total);
}

@override
String toString() {
  final _this = this as GuideActionDto;
  return 'GuideActionDto(type: ${_this.type}, monumentId: ${_this.monumentId}, monumentName: ${_this.monumentName}, destination: ${_this.destination}, q: ${_this.q}, categories: ${_this.categories}, periods: ${_this.periods}, cities: ${_this.cities}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $GuideActionDtoCopyWith<$Res>  {
  factory $GuideActionDtoCopyWith(GuideActionDto value, $Res Function(GuideActionDto) _then) = _$GuideActionDtoCopyWithImpl;
@useResult
$Res call({
 String type, String? monumentId, String? monumentName, String? destination, String? q, List<String> categories, List<String> periods, List<String> cities, int? total
});




}
/// @nodoc
class _$GuideActionDtoCopyWithImpl<$Res>
    implements $GuideActionDtoCopyWith<$Res> {
  _$GuideActionDtoCopyWithImpl(this._self, this._then);

  final GuideActionDto _self;
  final $Res Function(GuideActionDto) _then;

/// Create a copy of GuideActionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? monumentId = freezed,Object? monumentName = freezed,Object? destination = freezed,Object? q = freezed,Object? categories = null,Object? periods = null,Object? cities = null,Object? total = freezed,}) {
  return _then(GuideActionDto(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,monumentId: freezed == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String?,monumentName: freezed == monumentName ? _self.monumentName : monumentName // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,q: freezed == q ? _self.q : q // ignore: cast_nullable_to_non_nullable
as String?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,periods: null == periods ? _self.periods : periods // ignore: cast_nullable_to_non_nullable
as List<String>,cities: null == cities ? _self.cities : cities // ignore: cast_nullable_to_non_nullable
as List<String>,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [GuideActionDto].
extension GuideActionDtoPatterns on GuideActionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuideActionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuideActionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuideActionDto value)  $default,){
final _that = this;
switch (_that) {
case _GuideActionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuideActionDto value)?  $default,){
final _that = this;
switch (_that) {
case _GuideActionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String? monumentId,  String? monumentName,  String? destination,  String? q,  List<String> categories,  List<String> periods,  List<String> cities,  int? total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuideActionDto() when $default != null:
return $default(_that.type,_that.monumentId,_that.monumentName,_that.destination,_that.q,_that.categories,_that.periods,_that.cities,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String? monumentId,  String? monumentName,  String? destination,  String? q,  List<String> categories,  List<String> periods,  List<String> cities,  int? total)  $default,) {final _that = this;
switch (_that) {
case _GuideActionDto():
return $default(_that.type,_that.monumentId,_that.monumentName,_that.destination,_that.q,_that.categories,_that.periods,_that.cities,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String? monumentId,  String? monumentName,  String? destination,  String? q,  List<String> categories,  List<String> periods,  List<String> cities,  int? total)?  $default,) {final _that = this;
switch (_that) {
case _GuideActionDto() when $default != null:
return $default(_that.type,_that.monumentId,_that.monumentName,_that.destination,_that.q,_that.categories,_that.periods,_that.cities,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GuideActionDto extends GuideActionDto {
  const _GuideActionDto({required this.type, this.monumentId, this.monumentName, this.destination, this.q,  List<String> categories = const <String>[],  List<String> periods = const <String>[],  List<String> cities = const <String>[], this.total}): _categories = categories,_periods = periods,_cities = cities,super._();
  factory _GuideActionDto.fromJson(Map<String, dynamic> json) => _$GuideActionDtoFromJson(json);

@override final  String type;
@override final  String? monumentId;
@override final  String? monumentName;
@override final  String? destination;
@override final  String? q;
 final  List<String> _categories;
@override@JsonKey() List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<String> _periods;
@override@JsonKey() List<String> get periods {
  if (_periods is EqualUnmodifiableListView) return _periods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_periods);
}

 final  List<String> _cities;
@override@JsonKey() List<String> get cities {
  if (_cities is EqualUnmodifiableListView) return _cities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cities);
}

@override final  int? total;

/// Create a copy of GuideActionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuideActionDtoCopyWith<_GuideActionDto> get copyWith => __$GuideActionDtoCopyWithImpl<_GuideActionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuideActionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuideActionDto&&(identical(other.type, type) || other.type == type)&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.monumentName, monumentName) || other.monumentName == monumentName)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.q, q) || other.q == q)&&const DeepCollectionEquality().equals(other.categories, _categories)&&const DeepCollectionEquality().equals(other.periods, _periods)&&const DeepCollectionEquality().equals(other.cities, _cities)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,monumentId,monumentName,destination,q,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_periods),const DeepCollectionEquality().hash(_cities),total);
}

@override
String toString() {
    return 'GuideActionDto(type: $type, monumentId: $monumentId, monumentName: $monumentName, destination: $destination, q: $q, categories: $categories, periods: $periods, cities: $cities, total: $total)';
}


}

/// @nodoc
abstract mixin class _$GuideActionDtoCopyWith<$Res> implements $GuideActionDtoCopyWith<$Res> {
  factory _$GuideActionDtoCopyWith(_GuideActionDto value, $Res Function(_GuideActionDto) _then) = __$GuideActionDtoCopyWithImpl;
@override @useResult
$Res call({
 String type, String? monumentId, String? monumentName, String? destination, String? q, List<String> categories, List<String> periods, List<String> cities, int? total
});




}
/// @nodoc
class __$GuideActionDtoCopyWithImpl<$Res>
    implements _$GuideActionDtoCopyWith<$Res> {
  __$GuideActionDtoCopyWithImpl(this._self, this._then);

  final _GuideActionDto _self;
  final $Res Function(_GuideActionDto) _then;

/// Create a copy of GuideActionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? monumentId = freezed,Object? monumentName = freezed,Object? destination = freezed,Object? q = freezed,Object? categories = null,Object? periods = null,Object? cities = null,Object? total = freezed,}) {
  return _then(_GuideActionDto(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,monumentId: freezed == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String?,monumentName: freezed == monumentName ? _self.monumentName : monumentName // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,q: freezed == q ? _self.q : q // ignore: cast_nullable_to_non_nullable
as String?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,periods: null == periods ? _self._periods : periods // ignore: cast_nullable_to_non_nullable
as List<String>,cities: null == cities ? _self._cities : cities // ignore: cast_nullable_to_non_nullable
as List<String>,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
