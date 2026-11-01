// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RouteBreakDto {

@JsonKey(unknownEnumValue: RouteBreakKind.rest) RouteBreakKind get kind; int get minutes;
/// Create a copy of RouteBreakDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteBreakDtoCopyWith<RouteBreakDto> get copyWith => _$RouteBreakDtoCopyWithImpl<RouteBreakDto>(this as RouteBreakDto, _$identity);

  /// Serializes this RouteBreakDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteBreakDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBreakDto&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.minutes, _this.minutes) || other.minutes == _this.minutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteBreakDto;
  return Object.hash(runtimeType,_this.kind,_this.minutes);
}

@override
String toString() {
  final _this = this as RouteBreakDto;
  return 'RouteBreakDto(kind: ${_this.kind}, minutes: ${_this.minutes})';
}


}

/// @nodoc
abstract mixin class $RouteBreakDtoCopyWith<$Res>  {
  factory $RouteBreakDtoCopyWith(RouteBreakDto value, $Res Function(RouteBreakDto) _then) = _$RouteBreakDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: RouteBreakKind.rest) RouteBreakKind kind, int minutes
});




}
/// @nodoc
class _$RouteBreakDtoCopyWithImpl<$Res>
    implements $RouteBreakDtoCopyWith<$Res> {
  _$RouteBreakDtoCopyWithImpl(this._self, this._then);

  final RouteBreakDto _self;
  final $Res Function(RouteBreakDto) _then;

/// Create a copy of RouteBreakDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? minutes = null,}) {
  return _then(RouteBreakDto(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RouteBreakKind,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteBreakDto].
extension RouteBreakDtoPatterns on RouteBreakDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteBreakDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteBreakDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteBreakDto value)  $default,){
final _that = this;
switch (_that) {
case _RouteBreakDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteBreakDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouteBreakDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: RouteBreakKind.rest)  RouteBreakKind kind,  int minutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteBreakDto() when $default != null:
return $default(_that.kind,_that.minutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: RouteBreakKind.rest)  RouteBreakKind kind,  int minutes)  $default,) {final _that = this;
switch (_that) {
case _RouteBreakDto():
return $default(_that.kind,_that.minutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: RouteBreakKind.rest)  RouteBreakKind kind,  int minutes)?  $default,) {final _that = this;
switch (_that) {
case _RouteBreakDto() when $default != null:
return $default(_that.kind,_that.minutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteBreakDto extends RouteBreakDto {
  const _RouteBreakDto({@JsonKey(unknownEnumValue: RouteBreakKind.rest) required this.kind, required this.minutes}): super._();
  factory _RouteBreakDto.fromJson(Map<String, dynamic> json) => _$RouteBreakDtoFromJson(json);

@override@JsonKey(unknownEnumValue: RouteBreakKind.rest) final  RouteBreakKind kind;
@override final  int minutes;

/// Create a copy of RouteBreakDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteBreakDtoCopyWith<_RouteBreakDto> get copyWith => __$RouteBreakDtoCopyWithImpl<_RouteBreakDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteBreakDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteBreakDto&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.minutes, minutes) || other.minutes == minutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,minutes);
}

@override
String toString() {
    return 'RouteBreakDto(kind: $kind, minutes: $minutes)';
}


}

/// @nodoc
abstract mixin class _$RouteBreakDtoCopyWith<$Res> implements $RouteBreakDtoCopyWith<$Res> {
  factory _$RouteBreakDtoCopyWith(_RouteBreakDto value, $Res Function(_RouteBreakDto) _then) = __$RouteBreakDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: RouteBreakKind.rest) RouteBreakKind kind, int minutes
});




}
/// @nodoc
class __$RouteBreakDtoCopyWithImpl<$Res>
    implements _$RouteBreakDtoCopyWith<$Res> {
  __$RouteBreakDtoCopyWithImpl(this._self, this._then);

  final _RouteBreakDto _self;
  final $Res Function(_RouteBreakDto) _then;

/// Create a copy of RouteBreakDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? minutes = null,}) {
  return _then(_RouteBreakDto(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RouteBreakKind,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RouteStopPlanDto {

 String get monumentId; int get visitMinutes; List<RouteBreakDto> get breaks;
/// Create a copy of RouteStopPlanDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteStopPlanDtoCopyWith<RouteStopPlanDto> get copyWith => _$RouteStopPlanDtoCopyWithImpl<RouteStopPlanDto>(this as RouteStopPlanDto, _$identity);

  /// Serializes this RouteStopPlanDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteStopPlanDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteStopPlanDto&&(identical(other.monumentId, _this.monumentId) || other.monumentId == _this.monumentId)&&(identical(other.visitMinutes, _this.visitMinutes) || other.visitMinutes == _this.visitMinutes)&&const DeepCollectionEquality().equals(other.breaks, _this.breaks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteStopPlanDto;
  return Object.hash(runtimeType,_this.monumentId,_this.visitMinutes,const DeepCollectionEquality().hash(_this.breaks));
}

@override
String toString() {
  final _this = this as RouteStopPlanDto;
  return 'RouteStopPlanDto(monumentId: ${_this.monumentId}, visitMinutes: ${_this.visitMinutes}, breaks: ${_this.breaks})';
}


}

/// @nodoc
abstract mixin class $RouteStopPlanDtoCopyWith<$Res>  {
  factory $RouteStopPlanDtoCopyWith(RouteStopPlanDto value, $Res Function(RouteStopPlanDto) _then) = _$RouteStopPlanDtoCopyWithImpl;
@useResult
$Res call({
 String monumentId, int visitMinutes, List<RouteBreakDto> breaks
});




}
/// @nodoc
class _$RouteStopPlanDtoCopyWithImpl<$Res>
    implements $RouteStopPlanDtoCopyWith<$Res> {
  _$RouteStopPlanDtoCopyWithImpl(this._self, this._then);

  final RouteStopPlanDto _self;
  final $Res Function(RouteStopPlanDto) _then;

/// Create a copy of RouteStopPlanDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monumentId = null,Object? visitMinutes = null,Object? breaks = null,}) {
  return _then(RouteStopPlanDto(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,visitMinutes: null == visitMinutes ? _self.visitMinutes : visitMinutes // ignore: cast_nullable_to_non_nullable
as int,breaks: null == breaks ? _self.breaks : breaks // ignore: cast_nullable_to_non_nullable
as List<RouteBreakDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteStopPlanDto].
extension RouteStopPlanDtoPatterns on RouteStopPlanDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteStopPlanDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteStopPlanDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteStopPlanDto value)  $default,){
final _that = this;
switch (_that) {
case _RouteStopPlanDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteStopPlanDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouteStopPlanDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String monumentId,  int visitMinutes,  List<RouteBreakDto> breaks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteStopPlanDto() when $default != null:
return $default(_that.monumentId,_that.visitMinutes,_that.breaks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String monumentId,  int visitMinutes,  List<RouteBreakDto> breaks)  $default,) {final _that = this;
switch (_that) {
case _RouteStopPlanDto():
return $default(_that.monumentId,_that.visitMinutes,_that.breaks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String monumentId,  int visitMinutes,  List<RouteBreakDto> breaks)?  $default,) {final _that = this;
switch (_that) {
case _RouteStopPlanDto() when $default != null:
return $default(_that.monumentId,_that.visitMinutes,_that.breaks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteStopPlanDto extends RouteStopPlanDto {
  const _RouteStopPlanDto({required this.monumentId, required this.visitMinutes,  List<RouteBreakDto> breaks = const <RouteBreakDto>[]}): _breaks = breaks,super._();
  factory _RouteStopPlanDto.fromJson(Map<String, dynamic> json) => _$RouteStopPlanDtoFromJson(json);

@override final  String monumentId;
@override final  int visitMinutes;
 final  List<RouteBreakDto> _breaks;
@override@JsonKey() List<RouteBreakDto> get breaks {
  if (_breaks is EqualUnmodifiableListView) return _breaks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_breaks);
}


/// Create a copy of RouteStopPlanDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteStopPlanDtoCopyWith<_RouteStopPlanDto> get copyWith => __$RouteStopPlanDtoCopyWithImpl<_RouteStopPlanDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteStopPlanDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteStopPlanDto&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.visitMinutes, visitMinutes) || other.visitMinutes == visitMinutes)&&const DeepCollectionEquality().equals(other.breaks, _breaks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,monumentId,visitMinutes,const DeepCollectionEquality().hash(_breaks));
}

@override
String toString() {
    return 'RouteStopPlanDto(monumentId: $monumentId, visitMinutes: $visitMinutes, breaks: $breaks)';
}


}

/// @nodoc
abstract mixin class _$RouteStopPlanDtoCopyWith<$Res> implements $RouteStopPlanDtoCopyWith<$Res> {
  factory _$RouteStopPlanDtoCopyWith(_RouteStopPlanDto value, $Res Function(_RouteStopPlanDto) _then) = __$RouteStopPlanDtoCopyWithImpl;
@override @useResult
$Res call({
 String monumentId, int visitMinutes, List<RouteBreakDto> breaks
});




}
/// @nodoc
class __$RouteStopPlanDtoCopyWithImpl<$Res>
    implements _$RouteStopPlanDtoCopyWith<$Res> {
  __$RouteStopPlanDtoCopyWithImpl(this._self, this._then);

  final _RouteStopPlanDto _self;
  final $Res Function(_RouteStopPlanDto) _then;

/// Create a copy of RouteStopPlanDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monumentId = null,Object? visitMinutes = null,Object? breaks = null,}) {
  return _then(_RouteStopPlanDto(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,visitMinutes: null == visitMinutes ? _self.visitMinutes : visitMinutes // ignore: cast_nullable_to_non_nullable
as int,breaks: null == breaks ? _self._breaks : breaks // ignore: cast_nullable_to_non_nullable
as List<RouteBreakDto>,
  ));
}


}


/// @nodoc
mixin _$RoutePlanRequestDto {

 String get name; List<RouteStopPlanDto> get stops; String get travelMode;
/// Create a copy of RoutePlanRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutePlanRequestDtoCopyWith<RoutePlanRequestDto> get copyWith => _$RoutePlanRequestDtoCopyWithImpl<RoutePlanRequestDto>(this as RoutePlanRequestDto, _$identity);

  /// Serializes this RoutePlanRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RoutePlanRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutePlanRequestDto&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.stops, _this.stops)&&(identical(other.travelMode, _this.travelMode) || other.travelMode == _this.travelMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RoutePlanRequestDto;
  return Object.hash(runtimeType,_this.name,const DeepCollectionEquality().hash(_this.stops),_this.travelMode);
}

@override
String toString() {
  final _this = this as RoutePlanRequestDto;
  return 'RoutePlanRequestDto(name: ${_this.name}, stops: ${_this.stops}, travelMode: ${_this.travelMode})';
}


}

/// @nodoc
abstract mixin class $RoutePlanRequestDtoCopyWith<$Res>  {
  factory $RoutePlanRequestDtoCopyWith(RoutePlanRequestDto value, $Res Function(RoutePlanRequestDto) _then) = _$RoutePlanRequestDtoCopyWithImpl;
@useResult
$Res call({
 String name, List<RouteStopPlanDto> stops, String travelMode
});




}
/// @nodoc
class _$RoutePlanRequestDtoCopyWithImpl<$Res>
    implements $RoutePlanRequestDtoCopyWith<$Res> {
  _$RoutePlanRequestDtoCopyWithImpl(this._self, this._then);

  final RoutePlanRequestDto _self;
  final $Res Function(RoutePlanRequestDto) _then;

/// Create a copy of RoutePlanRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? stops = null,Object? travelMode = null,}) {
  return _then(RoutePlanRequestDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,stops: null == stops ? _self.stops : stops // ignore: cast_nullable_to_non_nullable
as List<RouteStopPlanDto>,travelMode: null == travelMode ? _self.travelMode : travelMode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RoutePlanRequestDto].
extension RoutePlanRequestDtoPatterns on RoutePlanRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutePlanRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutePlanRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutePlanRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _RoutePlanRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutePlanRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _RoutePlanRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<RouteStopPlanDto> stops,  String travelMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutePlanRequestDto() when $default != null:
return $default(_that.name,_that.stops,_that.travelMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<RouteStopPlanDto> stops,  String travelMode)  $default,) {final _that = this;
switch (_that) {
case _RoutePlanRequestDto():
return $default(_that.name,_that.stops,_that.travelMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<RouteStopPlanDto> stops,  String travelMode)?  $default,) {final _that = this;
switch (_that) {
case _RoutePlanRequestDto() when $default != null:
return $default(_that.name,_that.stops,_that.travelMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoutePlanRequestDto extends RoutePlanRequestDto {
  const _RoutePlanRequestDto({required this.name, required  List<RouteStopPlanDto> stops, this.travelMode = RouteTravelModes.driving}): _stops = stops,super._();
  factory _RoutePlanRequestDto.fromJson(Map<String, dynamic> json) => _$RoutePlanRequestDtoFromJson(json);

@override final  String name;
 final  List<RouteStopPlanDto> _stops;
@override List<RouteStopPlanDto> get stops {
  if (_stops is EqualUnmodifiableListView) return _stops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stops);
}

@override@JsonKey() final  String travelMode;

/// Create a copy of RoutePlanRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutePlanRequestDtoCopyWith<_RoutePlanRequestDto> get copyWith => __$RoutePlanRequestDtoCopyWithImpl<_RoutePlanRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoutePlanRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutePlanRequestDto&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.stops, _stops)&&(identical(other.travelMode, travelMode) || other.travelMode == travelMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_stops),travelMode);
}

@override
String toString() {
    return 'RoutePlanRequestDto(name: $name, stops: $stops, travelMode: $travelMode)';
}


}

/// @nodoc
abstract mixin class _$RoutePlanRequestDtoCopyWith<$Res> implements $RoutePlanRequestDtoCopyWith<$Res> {
  factory _$RoutePlanRequestDtoCopyWith(_RoutePlanRequestDto value, $Res Function(_RoutePlanRequestDto) _then) = __$RoutePlanRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, List<RouteStopPlanDto> stops, String travelMode
});




}
/// @nodoc
class __$RoutePlanRequestDtoCopyWithImpl<$Res>
    implements _$RoutePlanRequestDtoCopyWith<$Res> {
  __$RoutePlanRequestDtoCopyWithImpl(this._self, this._then);

  final _RoutePlanRequestDto _self;
  final $Res Function(_RoutePlanRequestDto) _then;

/// Create a copy of RoutePlanRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? stops = null,Object? travelMode = null,}) {
  return _then(_RoutePlanRequestDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,stops: null == stops ? _self._stops : stops // ignore: cast_nullable_to_non_nullable
as List<RouteStopPlanDto>,travelMode: null == travelMode ? _self.travelMode : travelMode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RouteStopDto {

 String get monumentId; String get name; String get city; String get district;@JsonKey(unknownEnumValue: MonumentCategory.other) MonumentCategory get category; GeoPointDto get location; int get visitMinutes; List<RouteBreakDto> get breaks;
/// Create a copy of RouteStopDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteStopDtoCopyWith<RouteStopDto> get copyWith => _$RouteStopDtoCopyWithImpl<RouteStopDto>(this as RouteStopDto, _$identity);

  /// Serializes this RouteStopDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteStopDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteStopDto&&(identical(other.monumentId, _this.monumentId) || other.monumentId == _this.monumentId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.district, _this.district) || other.district == _this.district)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.visitMinutes, _this.visitMinutes) || other.visitMinutes == _this.visitMinutes)&&const DeepCollectionEquality().equals(other.breaks, _this.breaks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteStopDto;
  return Object.hash(runtimeType,_this.monumentId,_this.name,_this.city,_this.district,_this.category,_this.location,_this.visitMinutes,const DeepCollectionEquality().hash(_this.breaks));
}

@override
String toString() {
  final _this = this as RouteStopDto;
  return 'RouteStopDto(monumentId: ${_this.monumentId}, name: ${_this.name}, city: ${_this.city}, district: ${_this.district}, category: ${_this.category}, location: ${_this.location}, visitMinutes: ${_this.visitMinutes}, breaks: ${_this.breaks})';
}


}

/// @nodoc
abstract mixin class $RouteStopDtoCopyWith<$Res>  {
  factory $RouteStopDtoCopyWith(RouteStopDto value, $Res Function(RouteStopDto) _then) = _$RouteStopDtoCopyWithImpl;
@useResult
$Res call({
 String monumentId, String name, String city, String district,@JsonKey(unknownEnumValue: MonumentCategory.other) MonumentCategory category, GeoPointDto location, int visitMinutes, List<RouteBreakDto> breaks
});


$GeoPointDtoCopyWith<$Res> get location;

}
/// @nodoc
class _$RouteStopDtoCopyWithImpl<$Res>
    implements $RouteStopDtoCopyWith<$Res> {
  _$RouteStopDtoCopyWithImpl(this._self, this._then);

  final RouteStopDto _self;
  final $Res Function(RouteStopDto) _then;

/// Create a copy of RouteStopDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monumentId = null,Object? name = null,Object? city = null,Object? district = null,Object? category = null,Object? location = null,Object? visitMinutes = null,Object? breaks = null,}) {
  return _then(RouteStopDto(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MonumentCategory,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPointDto,visitMinutes: null == visitMinutes ? _self.visitMinutes : visitMinutes // ignore: cast_nullable_to_non_nullable
as int,breaks: null == breaks ? _self.breaks : breaks // ignore: cast_nullable_to_non_nullable
as List<RouteBreakDto>,
  ));
}
/// Create a copy of RouteStopDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointDtoCopyWith<$Res> get location {
  
  return $GeoPointDtoCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [RouteStopDto].
extension RouteStopDtoPatterns on RouteStopDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteStopDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteStopDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteStopDto value)  $default,){
final _that = this;
switch (_that) {
case _RouteStopDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteStopDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouteStopDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String monumentId,  String name,  String city,  String district, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category,  GeoPointDto location,  int visitMinutes,  List<RouteBreakDto> breaks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteStopDto() when $default != null:
return $default(_that.monumentId,_that.name,_that.city,_that.district,_that.category,_that.location,_that.visitMinutes,_that.breaks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String monumentId,  String name,  String city,  String district, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category,  GeoPointDto location,  int visitMinutes,  List<RouteBreakDto> breaks)  $default,) {final _that = this;
switch (_that) {
case _RouteStopDto():
return $default(_that.monumentId,_that.name,_that.city,_that.district,_that.category,_that.location,_that.visitMinutes,_that.breaks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String monumentId,  String name,  String city,  String district, @JsonKey(unknownEnumValue: MonumentCategory.other)  MonumentCategory category,  GeoPointDto location,  int visitMinutes,  List<RouteBreakDto> breaks)?  $default,) {final _that = this;
switch (_that) {
case _RouteStopDto() when $default != null:
return $default(_that.monumentId,_that.name,_that.city,_that.district,_that.category,_that.location,_that.visitMinutes,_that.breaks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteStopDto extends RouteStopDto {
  const _RouteStopDto({required this.monumentId, required this.name, required this.city, required this.district, @JsonKey(unknownEnumValue: MonumentCategory.other) required this.category, required this.location, required this.visitMinutes,  List<RouteBreakDto> breaks = const <RouteBreakDto>[]}): _breaks = breaks,super._();
  factory _RouteStopDto.fromJson(Map<String, dynamic> json) => _$RouteStopDtoFromJson(json);

@override final  String monumentId;
@override final  String name;
@override final  String city;
@override final  String district;
@override@JsonKey(unknownEnumValue: MonumentCategory.other) final  MonumentCategory category;
@override final  GeoPointDto location;
@override final  int visitMinutes;
 final  List<RouteBreakDto> _breaks;
@override@JsonKey() List<RouteBreakDto> get breaks {
  if (_breaks is EqualUnmodifiableListView) return _breaks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_breaks);
}


/// Create a copy of RouteStopDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteStopDtoCopyWith<_RouteStopDto> get copyWith => __$RouteStopDtoCopyWithImpl<_RouteStopDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteStopDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteStopDto&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.category, category) || other.category == category)&&(identical(other.location, location) || other.location == location)&&(identical(other.visitMinutes, visitMinutes) || other.visitMinutes == visitMinutes)&&const DeepCollectionEquality().equals(other.breaks, _breaks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,monumentId,name,city,district,category,location,visitMinutes,const DeepCollectionEquality().hash(_breaks));
}

@override
String toString() {
    return 'RouteStopDto(monumentId: $monumentId, name: $name, city: $city, district: $district, category: $category, location: $location, visitMinutes: $visitMinutes, breaks: $breaks)';
}


}

/// @nodoc
abstract mixin class _$RouteStopDtoCopyWith<$Res> implements $RouteStopDtoCopyWith<$Res> {
  factory _$RouteStopDtoCopyWith(_RouteStopDto value, $Res Function(_RouteStopDto) _then) = __$RouteStopDtoCopyWithImpl;
@override @useResult
$Res call({
 String monumentId, String name, String city, String district,@JsonKey(unknownEnumValue: MonumentCategory.other) MonumentCategory category, GeoPointDto location, int visitMinutes, List<RouteBreakDto> breaks
});


@override $GeoPointDtoCopyWith<$Res> get location;

}
/// @nodoc
class __$RouteStopDtoCopyWithImpl<$Res>
    implements _$RouteStopDtoCopyWith<$Res> {
  __$RouteStopDtoCopyWithImpl(this._self, this._then);

  final _RouteStopDto _self;
  final $Res Function(_RouteStopDto) _then;

/// Create a copy of RouteStopDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monumentId = null,Object? name = null,Object? city = null,Object? district = null,Object? category = null,Object? location = null,Object? visitMinutes = null,Object? breaks = null,}) {
  return _then(_RouteStopDto(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MonumentCategory,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPointDto,visitMinutes: null == visitMinutes ? _self.visitMinutes : visitMinutes // ignore: cast_nullable_to_non_nullable
as int,breaks: null == breaks ? _self._breaks : breaks // ignore: cast_nullable_to_non_nullable
as List<RouteBreakDto>,
  ));
}

/// Create a copy of RouteStopDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointDtoCopyWith<$Res> get location {
  
  return $GeoPointDtoCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// @nodoc
mixin _$RouteLegDto {

 int get distanceMeters; int get durationSeconds;/// Encoded polyline (hassasiyet 5).
 String get geometry;
/// Create a copy of RouteLegDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteLegDtoCopyWith<RouteLegDto> get copyWith => _$RouteLegDtoCopyWithImpl<RouteLegDto>(this as RouteLegDto, _$identity);

  /// Serializes this RouteLegDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteLegDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteLegDto&&(identical(other.distanceMeters, _this.distanceMeters) || other.distanceMeters == _this.distanceMeters)&&(identical(other.durationSeconds, _this.durationSeconds) || other.durationSeconds == _this.durationSeconds)&&(identical(other.geometry, _this.geometry) || other.geometry == _this.geometry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteLegDto;
  return Object.hash(runtimeType,_this.distanceMeters,_this.durationSeconds,_this.geometry);
}

@override
String toString() {
  final _this = this as RouteLegDto;
  return 'RouteLegDto(distanceMeters: ${_this.distanceMeters}, durationSeconds: ${_this.durationSeconds}, geometry: ${_this.geometry})';
}


}

/// @nodoc
abstract mixin class $RouteLegDtoCopyWith<$Res>  {
  factory $RouteLegDtoCopyWith(RouteLegDto value, $Res Function(RouteLegDto) _then) = _$RouteLegDtoCopyWithImpl;
@useResult
$Res call({
 int distanceMeters, int durationSeconds, String geometry
});




}
/// @nodoc
class _$RouteLegDtoCopyWithImpl<$Res>
    implements $RouteLegDtoCopyWith<$Res> {
  _$RouteLegDtoCopyWithImpl(this._self, this._then);

  final RouteLegDto _self;
  final $Res Function(RouteLegDto) _then;

/// Create a copy of RouteLegDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? distanceMeters = null,Object? durationSeconds = null,Object? geometry = null,}) {
  return _then(RouteLegDto(
distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as int,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,geometry: null == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteLegDto].
extension RouteLegDtoPatterns on RouteLegDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteLegDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteLegDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteLegDto value)  $default,){
final _that = this;
switch (_that) {
case _RouteLegDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteLegDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouteLegDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int distanceMeters,  int durationSeconds,  String geometry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteLegDto() when $default != null:
return $default(_that.distanceMeters,_that.durationSeconds,_that.geometry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int distanceMeters,  int durationSeconds,  String geometry)  $default,) {final _that = this;
switch (_that) {
case _RouteLegDto():
return $default(_that.distanceMeters,_that.durationSeconds,_that.geometry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int distanceMeters,  int durationSeconds,  String geometry)?  $default,) {final _that = this;
switch (_that) {
case _RouteLegDto() when $default != null:
return $default(_that.distanceMeters,_that.durationSeconds,_that.geometry);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteLegDto extends RouteLegDto {
  const _RouteLegDto({required this.distanceMeters, required this.durationSeconds, required this.geometry}): super._();
  factory _RouteLegDto.fromJson(Map<String, dynamic> json) => _$RouteLegDtoFromJson(json);

@override final  int distanceMeters;
@override final  int durationSeconds;
/// Encoded polyline (hassasiyet 5).
@override final  String geometry;

/// Create a copy of RouteLegDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteLegDtoCopyWith<_RouteLegDto> get copyWith => __$RouteLegDtoCopyWithImpl<_RouteLegDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteLegDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteLegDto&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.geometry, geometry) || other.geometry == geometry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,distanceMeters,durationSeconds,geometry);
}

@override
String toString() {
    return 'RouteLegDto(distanceMeters: $distanceMeters, durationSeconds: $durationSeconds, geometry: $geometry)';
}


}

/// @nodoc
abstract mixin class _$RouteLegDtoCopyWith<$Res> implements $RouteLegDtoCopyWith<$Res> {
  factory _$RouteLegDtoCopyWith(_RouteLegDto value, $Res Function(_RouteLegDto) _then) = __$RouteLegDtoCopyWithImpl;
@override @useResult
$Res call({
 int distanceMeters, int durationSeconds, String geometry
});




}
/// @nodoc
class __$RouteLegDtoCopyWithImpl<$Res>
    implements _$RouteLegDtoCopyWith<$Res> {
  __$RouteLegDtoCopyWithImpl(this._self, this._then);

  final _RouteLegDto _self;
  final $Res Function(_RouteLegDto) _then;

/// Create a copy of RouteLegDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? distanceMeters = null,Object? durationSeconds = null,Object? geometry = null,}) {
  return _then(_RouteLegDto(
distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as int,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,geometry: null == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RouteSummaryDto {

 int get distanceMeters; int get travelSeconds; int get visitSeconds; int get breakSeconds; int get totalSeconds;
/// Create a copy of RouteSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteSummaryDtoCopyWith<RouteSummaryDto> get copyWith => _$RouteSummaryDtoCopyWithImpl<RouteSummaryDto>(this as RouteSummaryDto, _$identity);

  /// Serializes this RouteSummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteSummaryDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteSummaryDto&&(identical(other.distanceMeters, _this.distanceMeters) || other.distanceMeters == _this.distanceMeters)&&(identical(other.travelSeconds, _this.travelSeconds) || other.travelSeconds == _this.travelSeconds)&&(identical(other.visitSeconds, _this.visitSeconds) || other.visitSeconds == _this.visitSeconds)&&(identical(other.breakSeconds, _this.breakSeconds) || other.breakSeconds == _this.breakSeconds)&&(identical(other.totalSeconds, _this.totalSeconds) || other.totalSeconds == _this.totalSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteSummaryDto;
  return Object.hash(runtimeType,_this.distanceMeters,_this.travelSeconds,_this.visitSeconds,_this.breakSeconds,_this.totalSeconds);
}

@override
String toString() {
  final _this = this as RouteSummaryDto;
  return 'RouteSummaryDto(distanceMeters: ${_this.distanceMeters}, travelSeconds: ${_this.travelSeconds}, visitSeconds: ${_this.visitSeconds}, breakSeconds: ${_this.breakSeconds}, totalSeconds: ${_this.totalSeconds})';
}


}

/// @nodoc
abstract mixin class $RouteSummaryDtoCopyWith<$Res>  {
  factory $RouteSummaryDtoCopyWith(RouteSummaryDto value, $Res Function(RouteSummaryDto) _then) = _$RouteSummaryDtoCopyWithImpl;
@useResult
$Res call({
 int distanceMeters, int travelSeconds, int visitSeconds, int breakSeconds, int totalSeconds
});




}
/// @nodoc
class _$RouteSummaryDtoCopyWithImpl<$Res>
    implements $RouteSummaryDtoCopyWith<$Res> {
  _$RouteSummaryDtoCopyWithImpl(this._self, this._then);

  final RouteSummaryDto _self;
  final $Res Function(RouteSummaryDto) _then;

/// Create a copy of RouteSummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? distanceMeters = null,Object? travelSeconds = null,Object? visitSeconds = null,Object? breakSeconds = null,Object? totalSeconds = null,}) {
  return _then(RouteSummaryDto(
distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as int,travelSeconds: null == travelSeconds ? _self.travelSeconds : travelSeconds // ignore: cast_nullable_to_non_nullable
as int,visitSeconds: null == visitSeconds ? _self.visitSeconds : visitSeconds // ignore: cast_nullable_to_non_nullable
as int,breakSeconds: null == breakSeconds ? _self.breakSeconds : breakSeconds // ignore: cast_nullable_to_non_nullable
as int,totalSeconds: null == totalSeconds ? _self.totalSeconds : totalSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteSummaryDto].
extension RouteSummaryDtoPatterns on RouteSummaryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteSummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteSummaryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteSummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _RouteSummaryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteSummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouteSummaryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int distanceMeters,  int travelSeconds,  int visitSeconds,  int breakSeconds,  int totalSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteSummaryDto() when $default != null:
return $default(_that.distanceMeters,_that.travelSeconds,_that.visitSeconds,_that.breakSeconds,_that.totalSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int distanceMeters,  int travelSeconds,  int visitSeconds,  int breakSeconds,  int totalSeconds)  $default,) {final _that = this;
switch (_that) {
case _RouteSummaryDto():
return $default(_that.distanceMeters,_that.travelSeconds,_that.visitSeconds,_that.breakSeconds,_that.totalSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int distanceMeters,  int travelSeconds,  int visitSeconds,  int breakSeconds,  int totalSeconds)?  $default,) {final _that = this;
switch (_that) {
case _RouteSummaryDto() when $default != null:
return $default(_that.distanceMeters,_that.travelSeconds,_that.visitSeconds,_that.breakSeconds,_that.totalSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteSummaryDto extends RouteSummaryDto {
  const _RouteSummaryDto({required this.distanceMeters, required this.travelSeconds, required this.visitSeconds, required this.breakSeconds, required this.totalSeconds}): super._();
  factory _RouteSummaryDto.fromJson(Map<String, dynamic> json) => _$RouteSummaryDtoFromJson(json);

@override final  int distanceMeters;
@override final  int travelSeconds;
@override final  int visitSeconds;
@override final  int breakSeconds;
@override final  int totalSeconds;

/// Create a copy of RouteSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteSummaryDtoCopyWith<_RouteSummaryDto> get copyWith => __$RouteSummaryDtoCopyWithImpl<_RouteSummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteSummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteSummaryDto&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.travelSeconds, travelSeconds) || other.travelSeconds == travelSeconds)&&(identical(other.visitSeconds, visitSeconds) || other.visitSeconds == visitSeconds)&&(identical(other.breakSeconds, breakSeconds) || other.breakSeconds == breakSeconds)&&(identical(other.totalSeconds, totalSeconds) || other.totalSeconds == totalSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,distanceMeters,travelSeconds,visitSeconds,breakSeconds,totalSeconds);
}

@override
String toString() {
    return 'RouteSummaryDto(distanceMeters: $distanceMeters, travelSeconds: $travelSeconds, visitSeconds: $visitSeconds, breakSeconds: $breakSeconds, totalSeconds: $totalSeconds)';
}


}

/// @nodoc
abstract mixin class _$RouteSummaryDtoCopyWith<$Res> implements $RouteSummaryDtoCopyWith<$Res> {
  factory _$RouteSummaryDtoCopyWith(_RouteSummaryDto value, $Res Function(_RouteSummaryDto) _then) = __$RouteSummaryDtoCopyWithImpl;
@override @useResult
$Res call({
 int distanceMeters, int travelSeconds, int visitSeconds, int breakSeconds, int totalSeconds
});




}
/// @nodoc
class __$RouteSummaryDtoCopyWithImpl<$Res>
    implements _$RouteSummaryDtoCopyWith<$Res> {
  __$RouteSummaryDtoCopyWithImpl(this._self, this._then);

  final _RouteSummaryDto _self;
  final $Res Function(_RouteSummaryDto) _then;

/// Create a copy of RouteSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? distanceMeters = null,Object? travelSeconds = null,Object? visitSeconds = null,Object? breakSeconds = null,Object? totalSeconds = null,}) {
  return _then(_RouteSummaryDto(
distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as int,travelSeconds: null == travelSeconds ? _self.travelSeconds : travelSeconds // ignore: cast_nullable_to_non_nullable
as int,visitSeconds: null == visitSeconds ? _self.visitSeconds : visitSeconds // ignore: cast_nullable_to_non_nullable
as int,breakSeconds: null == breakSeconds ? _self.breakSeconds : breakSeconds // ignore: cast_nullable_to_non_nullable
as int,totalSeconds: null == totalSeconds ? _self.totalSeconds : totalSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TravelRouteDto {

 String get id; String get name; DateTime get createdAt; DateTime get updatedAt; List<RouteStopDto> get stops; List<RouteLegDto> get legs; RouteSummaryDto get summary; String get travelMode;
/// Create a copy of TravelRouteDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TravelRouteDtoCopyWith<TravelRouteDto> get copyWith => _$TravelRouteDtoCopyWithImpl<TravelRouteDto>(this as TravelRouteDto, _$identity);

  /// Serializes this TravelRouteDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TravelRouteDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TravelRouteDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.stops, _this.stops)&&const DeepCollectionEquality().equals(other.legs, _this.legs)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.travelMode, _this.travelMode) || other.travelMode == _this.travelMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TravelRouteDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.stops),const DeepCollectionEquality().hash(_this.legs),_this.summary,_this.travelMode);
}

@override
String toString() {
  final _this = this as TravelRouteDto;
  return 'TravelRouteDto(id: ${_this.id}, name: ${_this.name}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, stops: ${_this.stops}, legs: ${_this.legs}, summary: ${_this.summary}, travelMode: ${_this.travelMode})';
}


}

/// @nodoc
abstract mixin class $TravelRouteDtoCopyWith<$Res>  {
  factory $TravelRouteDtoCopyWith(TravelRouteDto value, $Res Function(TravelRouteDto) _then) = _$TravelRouteDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime createdAt, DateTime updatedAt, List<RouteStopDto> stops, List<RouteLegDto> legs, RouteSummaryDto summary, String travelMode
});


$RouteSummaryDtoCopyWith<$Res> get summary;

}
/// @nodoc
class _$TravelRouteDtoCopyWithImpl<$Res>
    implements $TravelRouteDtoCopyWith<$Res> {
  _$TravelRouteDtoCopyWithImpl(this._self, this._then);

  final TravelRouteDto _self;
  final $Res Function(TravelRouteDto) _then;

/// Create a copy of TravelRouteDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? stops = null,Object? legs = null,Object? summary = null,Object? travelMode = null,}) {
  return _then(TravelRouteDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stops: null == stops ? _self.stops : stops // ignore: cast_nullable_to_non_nullable
as List<RouteStopDto>,legs: null == legs ? _self.legs : legs // ignore: cast_nullable_to_non_nullable
as List<RouteLegDto>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as RouteSummaryDto,travelMode: null == travelMode ? _self.travelMode : travelMode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of TravelRouteDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteSummaryDtoCopyWith<$Res> get summary {
  
  return $RouteSummaryDtoCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [TravelRouteDto].
extension TravelRouteDtoPatterns on TravelRouteDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TravelRouteDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TravelRouteDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TravelRouteDto value)  $default,){
final _that = this;
switch (_that) {
case _TravelRouteDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TravelRouteDto value)?  $default,){
final _that = this;
switch (_that) {
case _TravelRouteDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime createdAt,  DateTime updatedAt,  List<RouteStopDto> stops,  List<RouteLegDto> legs,  RouteSummaryDto summary,  String travelMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TravelRouteDto() when $default != null:
return $default(_that.id,_that.name,_that.createdAt,_that.updatedAt,_that.stops,_that.legs,_that.summary,_that.travelMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime createdAt,  DateTime updatedAt,  List<RouteStopDto> stops,  List<RouteLegDto> legs,  RouteSummaryDto summary,  String travelMode)  $default,) {final _that = this;
switch (_that) {
case _TravelRouteDto():
return $default(_that.id,_that.name,_that.createdAt,_that.updatedAt,_that.stops,_that.legs,_that.summary,_that.travelMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime createdAt,  DateTime updatedAt,  List<RouteStopDto> stops,  List<RouteLegDto> legs,  RouteSummaryDto summary,  String travelMode)?  $default,) {final _that = this;
switch (_that) {
case _TravelRouteDto() when $default != null:
return $default(_that.id,_that.name,_that.createdAt,_that.updatedAt,_that.stops,_that.legs,_that.summary,_that.travelMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TravelRouteDto extends TravelRouteDto {
  const _TravelRouteDto({required this.id, required this.name, required this.createdAt, required this.updatedAt, required  List<RouteStopDto> stops, required  List<RouteLegDto> legs, required this.summary, this.travelMode = RouteTravelModes.driving}): _stops = stops,_legs = legs,super._();
  factory _TravelRouteDto.fromJson(Map<String, dynamic> json) => _$TravelRouteDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<RouteStopDto> _stops;
@override List<RouteStopDto> get stops {
  if (_stops is EqualUnmodifiableListView) return _stops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stops);
}

 final  List<RouteLegDto> _legs;
@override List<RouteLegDto> get legs {
  if (_legs is EqualUnmodifiableListView) return _legs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_legs);
}

@override final  RouteSummaryDto summary;
@override@JsonKey() final  String travelMode;

/// Create a copy of TravelRouteDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TravelRouteDtoCopyWith<_TravelRouteDto> get copyWith => __$TravelRouteDtoCopyWithImpl<_TravelRouteDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TravelRouteDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TravelRouteDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.stops, _stops)&&const DeepCollectionEquality().equals(other.legs, _legs)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.travelMode, travelMode) || other.travelMode == travelMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,createdAt,updatedAt,const DeepCollectionEquality().hash(_stops),const DeepCollectionEquality().hash(_legs),summary,travelMode);
}

@override
String toString() {
    return 'TravelRouteDto(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, stops: $stops, legs: $legs, summary: $summary, travelMode: $travelMode)';
}


}

/// @nodoc
abstract mixin class _$TravelRouteDtoCopyWith<$Res> implements $TravelRouteDtoCopyWith<$Res> {
  factory _$TravelRouteDtoCopyWith(_TravelRouteDto value, $Res Function(_TravelRouteDto) _then) = __$TravelRouteDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime createdAt, DateTime updatedAt, List<RouteStopDto> stops, List<RouteLegDto> legs, RouteSummaryDto summary, String travelMode
});


@override $RouteSummaryDtoCopyWith<$Res> get summary;

}
/// @nodoc
class __$TravelRouteDtoCopyWithImpl<$Res>
    implements _$TravelRouteDtoCopyWith<$Res> {
  __$TravelRouteDtoCopyWithImpl(this._self, this._then);

  final _TravelRouteDto _self;
  final $Res Function(_TravelRouteDto) _then;

/// Create a copy of TravelRouteDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? stops = null,Object? legs = null,Object? summary = null,Object? travelMode = null,}) {
  return _then(_TravelRouteDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stops: null == stops ? _self._stops : stops // ignore: cast_nullable_to_non_nullable
as List<RouteStopDto>,legs: null == legs ? _self._legs : legs // ignore: cast_nullable_to_non_nullable
as List<RouteLegDto>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as RouteSummaryDto,travelMode: null == travelMode ? _self.travelMode : travelMode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of TravelRouteDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteSummaryDtoCopyWith<$Res> get summary {
  
  return $RouteSummaryDtoCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// @nodoc
mixin _$RouteOverviewDto {

 String get id; String get name; DateTime get createdAt; int get stopCount; List<String> get cities; RouteSummaryDto get summary;
/// Create a copy of RouteOverviewDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteOverviewDtoCopyWith<RouteOverviewDto> get copyWith => _$RouteOverviewDtoCopyWithImpl<RouteOverviewDto>(this as RouteOverviewDto, _$identity);

  /// Serializes this RouteOverviewDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteOverviewDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteOverviewDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.stopCount, _this.stopCount) || other.stopCount == _this.stopCount)&&const DeepCollectionEquality().equals(other.cities, _this.cities)&&(identical(other.summary, _this.summary) || other.summary == _this.summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteOverviewDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.createdAt,_this.stopCount,const DeepCollectionEquality().hash(_this.cities),_this.summary);
}

@override
String toString() {
  final _this = this as RouteOverviewDto;
  return 'RouteOverviewDto(id: ${_this.id}, name: ${_this.name}, createdAt: ${_this.createdAt}, stopCount: ${_this.stopCount}, cities: ${_this.cities}, summary: ${_this.summary})';
}


}

/// @nodoc
abstract mixin class $RouteOverviewDtoCopyWith<$Res>  {
  factory $RouteOverviewDtoCopyWith(RouteOverviewDto value, $Res Function(RouteOverviewDto) _then) = _$RouteOverviewDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime createdAt, int stopCount, List<String> cities, RouteSummaryDto summary
});


$RouteSummaryDtoCopyWith<$Res> get summary;

}
/// @nodoc
class _$RouteOverviewDtoCopyWithImpl<$Res>
    implements $RouteOverviewDtoCopyWith<$Res> {
  _$RouteOverviewDtoCopyWithImpl(this._self, this._then);

  final RouteOverviewDto _self;
  final $Res Function(RouteOverviewDto) _then;

/// Create a copy of RouteOverviewDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? createdAt = null,Object? stopCount = null,Object? cities = null,Object? summary = null,}) {
  return _then(RouteOverviewDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,stopCount: null == stopCount ? _self.stopCount : stopCount // ignore: cast_nullable_to_non_nullable
as int,cities: null == cities ? _self.cities : cities // ignore: cast_nullable_to_non_nullable
as List<String>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as RouteSummaryDto,
  ));
}
/// Create a copy of RouteOverviewDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteSummaryDtoCopyWith<$Res> get summary {
  
  return $RouteSummaryDtoCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [RouteOverviewDto].
extension RouteOverviewDtoPatterns on RouteOverviewDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteOverviewDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteOverviewDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteOverviewDto value)  $default,){
final _that = this;
switch (_that) {
case _RouteOverviewDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteOverviewDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouteOverviewDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime createdAt,  int stopCount,  List<String> cities,  RouteSummaryDto summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteOverviewDto() when $default != null:
return $default(_that.id,_that.name,_that.createdAt,_that.stopCount,_that.cities,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime createdAt,  int stopCount,  List<String> cities,  RouteSummaryDto summary)  $default,) {final _that = this;
switch (_that) {
case _RouteOverviewDto():
return $default(_that.id,_that.name,_that.createdAt,_that.stopCount,_that.cities,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime createdAt,  int stopCount,  List<String> cities,  RouteSummaryDto summary)?  $default,) {final _that = this;
switch (_that) {
case _RouteOverviewDto() when $default != null:
return $default(_that.id,_that.name,_that.createdAt,_that.stopCount,_that.cities,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteOverviewDto extends RouteOverviewDto {
  const _RouteOverviewDto({required this.id, required this.name, required this.createdAt, required this.stopCount, required  List<String> cities, required this.summary}): _cities = cities,super._();
  factory _RouteOverviewDto.fromJson(Map<String, dynamic> json) => _$RouteOverviewDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  DateTime createdAt;
@override final  int stopCount;
 final  List<String> _cities;
@override List<String> get cities {
  if (_cities is EqualUnmodifiableListView) return _cities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cities);
}

@override final  RouteSummaryDto summary;

/// Create a copy of RouteOverviewDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteOverviewDtoCopyWith<_RouteOverviewDto> get copyWith => __$RouteOverviewDtoCopyWithImpl<_RouteOverviewDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteOverviewDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteOverviewDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.stopCount, stopCount) || other.stopCount == stopCount)&&const DeepCollectionEquality().equals(other.cities, _cities)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,createdAt,stopCount,const DeepCollectionEquality().hash(_cities),summary);
}

@override
String toString() {
    return 'RouteOverviewDto(id: $id, name: $name, createdAt: $createdAt, stopCount: $stopCount, cities: $cities, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$RouteOverviewDtoCopyWith<$Res> implements $RouteOverviewDtoCopyWith<$Res> {
  factory _$RouteOverviewDtoCopyWith(_RouteOverviewDto value, $Res Function(_RouteOverviewDto) _then) = __$RouteOverviewDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime createdAt, int stopCount, List<String> cities, RouteSummaryDto summary
});


@override $RouteSummaryDtoCopyWith<$Res> get summary;

}
/// @nodoc
class __$RouteOverviewDtoCopyWithImpl<$Res>
    implements _$RouteOverviewDtoCopyWith<$Res> {
  __$RouteOverviewDtoCopyWithImpl(this._self, this._then);

  final _RouteOverviewDto _self;
  final $Res Function(_RouteOverviewDto) _then;

/// Create a copy of RouteOverviewDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? createdAt = null,Object? stopCount = null,Object? cities = null,Object? summary = null,}) {
  return _then(_RouteOverviewDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,stopCount: null == stopCount ? _self.stopCount : stopCount // ignore: cast_nullable_to_non_nullable
as int,cities: null == cities ? _self._cities : cities // ignore: cast_nullable_to_non_nullable
as List<String>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as RouteSummaryDto,
  ));
}

/// Create a copy of RouteOverviewDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteSummaryDtoCopyWith<$Res> get summary {
  
  return $RouteSummaryDtoCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// @nodoc
mixin _$RouteListResponseDto {

 List<RouteOverviewDto> get items;
/// Create a copy of RouteListResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteListResponseDtoCopyWith<RouteListResponseDto> get copyWith => _$RouteListResponseDtoCopyWithImpl<RouteListResponseDto>(this as RouteListResponseDto, _$identity);

  /// Serializes this RouteListResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteListResponseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteListResponseDto&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteListResponseDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as RouteListResponseDto;
  return 'RouteListResponseDto(items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $RouteListResponseDtoCopyWith<$Res>  {
  factory $RouteListResponseDtoCopyWith(RouteListResponseDto value, $Res Function(RouteListResponseDto) _then) = _$RouteListResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<RouteOverviewDto> items
});




}
/// @nodoc
class _$RouteListResponseDtoCopyWithImpl<$Res>
    implements $RouteListResponseDtoCopyWith<$Res> {
  _$RouteListResponseDtoCopyWithImpl(this._self, this._then);

  final RouteListResponseDto _self;
  final $Res Function(RouteListResponseDto) _then;

/// Create a copy of RouteListResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(RouteListResponseDto(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<RouteOverviewDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteListResponseDto].
extension RouteListResponseDtoPatterns on RouteListResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteListResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteListResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteListResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _RouteListResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteListResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _RouteListResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RouteOverviewDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteListResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RouteOverviewDto> items)  $default,) {final _that = this;
switch (_that) {
case _RouteListResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RouteOverviewDto> items)?  $default,) {final _that = this;
switch (_that) {
case _RouteListResponseDto() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteListResponseDto implements RouteListResponseDto {
  const _RouteListResponseDto({required  List<RouteOverviewDto> items}): _items = items;
  factory _RouteListResponseDto.fromJson(Map<String, dynamic> json) => _$RouteListResponseDtoFromJson(json);

 final  List<RouteOverviewDto> _items;
@override List<RouteOverviewDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of RouteListResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteListResponseDtoCopyWith<_RouteListResponseDto> get copyWith => __$RouteListResponseDtoCopyWithImpl<_RouteListResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteListResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteListResponseDto&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'RouteListResponseDto(items: $items)';
}


}

/// @nodoc
abstract mixin class _$RouteListResponseDtoCopyWith<$Res> implements $RouteListResponseDtoCopyWith<$Res> {
  factory _$RouteListResponseDtoCopyWith(_RouteListResponseDto value, $Res Function(_RouteListResponseDto) _then) = __$RouteListResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<RouteOverviewDto> items
});




}
/// @nodoc
class __$RouteListResponseDtoCopyWithImpl<$Res>
    implements _$RouteListResponseDtoCopyWith<$Res> {
  __$RouteListResponseDtoCopyWithImpl(this._self, this._then);

  final _RouteListResponseDto _self;
  final $Res Function(_RouteListResponseDto) _then;

/// Create a copy of RouteListResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_RouteListResponseDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<RouteOverviewDto>,
  ));
}


}

// dart format on
