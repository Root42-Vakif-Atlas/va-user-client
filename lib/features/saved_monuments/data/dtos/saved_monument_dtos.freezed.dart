// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_monument_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavedMonumentDto {

 String get monumentId; DateTime get savedAt;
/// Create a copy of SavedMonumentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedMonumentDtoCopyWith<SavedMonumentDto> get copyWith => _$SavedMonumentDtoCopyWithImpl<SavedMonumentDto>(this as SavedMonumentDto, _$identity);

  /// Serializes this SavedMonumentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SavedMonumentDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedMonumentDto&&(identical(other.monumentId, _this.monumentId) || other.monumentId == _this.monumentId)&&(identical(other.savedAt, _this.savedAt) || other.savedAt == _this.savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SavedMonumentDto;
  return Object.hash(runtimeType,_this.monumentId,_this.savedAt);
}

@override
String toString() {
  final _this = this as SavedMonumentDto;
  return 'SavedMonumentDto(monumentId: ${_this.monumentId}, savedAt: ${_this.savedAt})';
}


}

/// @nodoc
abstract mixin class $SavedMonumentDtoCopyWith<$Res>  {
  factory $SavedMonumentDtoCopyWith(SavedMonumentDto value, $Res Function(SavedMonumentDto) _then) = _$SavedMonumentDtoCopyWithImpl;
@useResult
$Res call({
 String monumentId, DateTime savedAt
});




}
/// @nodoc
class _$SavedMonumentDtoCopyWithImpl<$Res>
    implements $SavedMonumentDtoCopyWith<$Res> {
  _$SavedMonumentDtoCopyWithImpl(this._self, this._then);

  final SavedMonumentDto _self;
  final $Res Function(SavedMonumentDto) _then;

/// Create a copy of SavedMonumentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monumentId = null,Object? savedAt = null,}) {
  return _then(SavedMonumentDto(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedMonumentDto].
extension SavedMonumentDtoPatterns on SavedMonumentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedMonumentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedMonumentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedMonumentDto value)  $default,){
final _that = this;
switch (_that) {
case _SavedMonumentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedMonumentDto value)?  $default,){
final _that = this;
switch (_that) {
case _SavedMonumentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String monumentId,  DateTime savedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedMonumentDto() when $default != null:
return $default(_that.monumentId,_that.savedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String monumentId,  DateTime savedAt)  $default,) {final _that = this;
switch (_that) {
case _SavedMonumentDto():
return $default(_that.monumentId,_that.savedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String monumentId,  DateTime savedAt)?  $default,) {final _that = this;
switch (_that) {
case _SavedMonumentDto() when $default != null:
return $default(_that.monumentId,_that.savedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavedMonumentDto extends SavedMonumentDto {
  const _SavedMonumentDto({required this.monumentId, required this.savedAt}): super._();
  factory _SavedMonumentDto.fromJson(Map<String, dynamic> json) => _$SavedMonumentDtoFromJson(json);

@override final  String monumentId;
@override final  DateTime savedAt;

/// Create a copy of SavedMonumentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedMonumentDtoCopyWith<_SavedMonumentDto> get copyWith => __$SavedMonumentDtoCopyWithImpl<_SavedMonumentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedMonumentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedMonumentDto&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,monumentId,savedAt);
}

@override
String toString() {
    return 'SavedMonumentDto(monumentId: $monumentId, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class _$SavedMonumentDtoCopyWith<$Res> implements $SavedMonumentDtoCopyWith<$Res> {
  factory _$SavedMonumentDtoCopyWith(_SavedMonumentDto value, $Res Function(_SavedMonumentDto) _then) = __$SavedMonumentDtoCopyWithImpl;
@override @useResult
$Res call({
 String monumentId, DateTime savedAt
});




}
/// @nodoc
class __$SavedMonumentDtoCopyWithImpl<$Res>
    implements _$SavedMonumentDtoCopyWith<$Res> {
  __$SavedMonumentDtoCopyWithImpl(this._self, this._then);

  final _SavedMonumentDto _self;
  final $Res Function(_SavedMonumentDto) _then;

/// Create a copy of SavedMonumentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monumentId = null,Object? savedAt = null,}) {
  return _then(_SavedMonumentDto(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$SavedMonumentListDto {

 List<SavedMonumentDto> get items;
/// Create a copy of SavedMonumentListDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedMonumentListDtoCopyWith<SavedMonumentListDto> get copyWith => _$SavedMonumentListDtoCopyWithImpl<SavedMonumentListDto>(this as SavedMonumentListDto, _$identity);

  /// Serializes this SavedMonumentListDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SavedMonumentListDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedMonumentListDto&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SavedMonumentListDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as SavedMonumentListDto;
  return 'SavedMonumentListDto(items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $SavedMonumentListDtoCopyWith<$Res>  {
  factory $SavedMonumentListDtoCopyWith(SavedMonumentListDto value, $Res Function(SavedMonumentListDto) _then) = _$SavedMonumentListDtoCopyWithImpl;
@useResult
$Res call({
 List<SavedMonumentDto> items
});




}
/// @nodoc
class _$SavedMonumentListDtoCopyWithImpl<$Res>
    implements $SavedMonumentListDtoCopyWith<$Res> {
  _$SavedMonumentListDtoCopyWithImpl(this._self, this._then);

  final SavedMonumentListDto _self;
  final $Res Function(SavedMonumentListDto) _then;

/// Create a copy of SavedMonumentListDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(SavedMonumentListDto(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SavedMonumentDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedMonumentListDto].
extension SavedMonumentListDtoPatterns on SavedMonumentListDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedMonumentListDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedMonumentListDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedMonumentListDto value)  $default,){
final _that = this;
switch (_that) {
case _SavedMonumentListDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedMonumentListDto value)?  $default,){
final _that = this;
switch (_that) {
case _SavedMonumentListDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SavedMonumentDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedMonumentListDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SavedMonumentDto> items)  $default,) {final _that = this;
switch (_that) {
case _SavedMonumentListDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SavedMonumentDto> items)?  $default,) {final _that = this;
switch (_that) {
case _SavedMonumentListDto() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavedMonumentListDto implements SavedMonumentListDto {
  const _SavedMonumentListDto({required  List<SavedMonumentDto> items}): _items = items;
  factory _SavedMonumentListDto.fromJson(Map<String, dynamic> json) => _$SavedMonumentListDtoFromJson(json);

 final  List<SavedMonumentDto> _items;
@override List<SavedMonumentDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SavedMonumentListDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedMonumentListDtoCopyWith<_SavedMonumentListDto> get copyWith => __$SavedMonumentListDtoCopyWithImpl<_SavedMonumentListDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedMonumentListDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedMonumentListDto&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'SavedMonumentListDto(items: $items)';
}


}

/// @nodoc
abstract mixin class _$SavedMonumentListDtoCopyWith<$Res> implements $SavedMonumentListDtoCopyWith<$Res> {
  factory _$SavedMonumentListDtoCopyWith(_SavedMonumentListDto value, $Res Function(_SavedMonumentListDto) _then) = __$SavedMonumentListDtoCopyWithImpl;
@override @useResult
$Res call({
 List<SavedMonumentDto> items
});




}
/// @nodoc
class __$SavedMonumentListDtoCopyWithImpl<$Res>
    implements _$SavedMonumentListDtoCopyWith<$Res> {
  __$SavedMonumentListDtoCopyWithImpl(this._self, this._then);

  final _SavedMonumentListDto _self;
  final $Res Function(_SavedMonumentListDto) _then;

/// Create a copy of SavedMonumentListDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_SavedMonumentListDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SavedMonumentDto>,
  ));
}


}

// dart format on
