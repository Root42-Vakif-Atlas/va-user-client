// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_permissions_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DevicePermissionsState {

/// Okunmamış izinler haritada yoktur.
 Map<AppPermission, PermissionAccess> get access;/// Sistem penceresi veya ayarlar açıkken ilgili izin.
 AppPermission? get busy;/// Kalıcı ret sistem ayarlarından çözülebiliyorsa `true` (web'de hayır).
 bool get canOpenSettings;
/// Create a copy of DevicePermissionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DevicePermissionsStateCopyWith<DevicePermissionsState> get copyWith => _$DevicePermissionsStateCopyWithImpl<DevicePermissionsState>(this as DevicePermissionsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DevicePermissionsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DevicePermissionsState&&const DeepCollectionEquality().equals(other.access, _this.access)&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.canOpenSettings, _this.canOpenSettings) || other.canOpenSettings == _this.canOpenSettings));
}


@override
int get hashCode {
  final _this = this as DevicePermissionsState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.access),_this.busy,_this.canOpenSettings);
}

@override
String toString() {
  final _this = this as DevicePermissionsState;
  return 'DevicePermissionsState(access: ${_this.access}, busy: ${_this.busy}, canOpenSettings: ${_this.canOpenSettings})';
}


}

/// @nodoc
abstract mixin class $DevicePermissionsStateCopyWith<$Res>  {
  factory $DevicePermissionsStateCopyWith(DevicePermissionsState value, $Res Function(DevicePermissionsState) _then) = _$DevicePermissionsStateCopyWithImpl;
@useResult
$Res call({
 Map<AppPermission, PermissionAccess> access, AppPermission? busy, bool canOpenSettings
});




}
/// @nodoc
class _$DevicePermissionsStateCopyWithImpl<$Res>
    implements $DevicePermissionsStateCopyWith<$Res> {
  _$DevicePermissionsStateCopyWithImpl(this._self, this._then);

  final DevicePermissionsState _self;
  final $Res Function(DevicePermissionsState) _then;

/// Create a copy of DevicePermissionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? access = null,Object? busy = freezed,Object? canOpenSettings = null,}) {
  return _then(DevicePermissionsState(
access: null == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as Map<AppPermission, PermissionAccess>,busy: freezed == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as AppPermission?,canOpenSettings: null == canOpenSettings ? _self.canOpenSettings : canOpenSettings // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DevicePermissionsState].
extension DevicePermissionsStatePatterns on DevicePermissionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DevicePermissionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DevicePermissionsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DevicePermissionsState value)  $default,){
final _that = this;
switch (_that) {
case _DevicePermissionsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DevicePermissionsState value)?  $default,){
final _that = this;
switch (_that) {
case _DevicePermissionsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<AppPermission, PermissionAccess> access,  AppPermission? busy,  bool canOpenSettings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DevicePermissionsState() when $default != null:
return $default(_that.access,_that.busy,_that.canOpenSettings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<AppPermission, PermissionAccess> access,  AppPermission? busy,  bool canOpenSettings)  $default,) {final _that = this;
switch (_that) {
case _DevicePermissionsState():
return $default(_that.access,_that.busy,_that.canOpenSettings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<AppPermission, PermissionAccess> access,  AppPermission? busy,  bool canOpenSettings)?  $default,) {final _that = this;
switch (_that) {
case _DevicePermissionsState() when $default != null:
return $default(_that.access,_that.busy,_that.canOpenSettings);case _:
  return null;

}
}

}

/// @nodoc


class _DevicePermissionsState implements DevicePermissionsState {
  const _DevicePermissionsState({ Map<AppPermission, PermissionAccess> access = const <AppPermission, PermissionAccess>{}, this.busy, this.canOpenSettings = false}): _access = access;
  

/// Okunmamış izinler haritada yoktur.
 final  Map<AppPermission, PermissionAccess> _access;
/// Okunmamış izinler haritada yoktur.
@override@JsonKey() Map<AppPermission, PermissionAccess> get access {
  if (_access is EqualUnmodifiableMapView) return _access;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_access);
}

/// Sistem penceresi veya ayarlar açıkken ilgili izin.
@override final  AppPermission? busy;
/// Kalıcı ret sistem ayarlarından çözülebiliyorsa `true` (web'de hayır).
@override@JsonKey() final  bool canOpenSettings;

/// Create a copy of DevicePermissionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DevicePermissionsStateCopyWith<_DevicePermissionsState> get copyWith => __$DevicePermissionsStateCopyWithImpl<_DevicePermissionsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DevicePermissionsState&&const DeepCollectionEquality().equals(other.access, _access)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.canOpenSettings, canOpenSettings) || other.canOpenSettings == canOpenSettings));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_access),busy,canOpenSettings);
}

@override
String toString() {
    return 'DevicePermissionsState(access: $access, busy: $busy, canOpenSettings: $canOpenSettings)';
}


}

/// @nodoc
abstract mixin class _$DevicePermissionsStateCopyWith<$Res> implements $DevicePermissionsStateCopyWith<$Res> {
  factory _$DevicePermissionsStateCopyWith(_DevicePermissionsState value, $Res Function(_DevicePermissionsState) _then) = __$DevicePermissionsStateCopyWithImpl;
@override @useResult
$Res call({
 Map<AppPermission, PermissionAccess> access, AppPermission? busy, bool canOpenSettings
});




}
/// @nodoc
class __$DevicePermissionsStateCopyWithImpl<$Res>
    implements _$DevicePermissionsStateCopyWith<$Res> {
  __$DevicePermissionsStateCopyWithImpl(this._self, this._then);

  final _DevicePermissionsState _self;
  final $Res Function(_DevicePermissionsState) _then;

/// Create a copy of DevicePermissionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? access = null,Object? busy = freezed,Object? canOpenSettings = null,}) {
  return _then(_DevicePermissionsState(
access: null == access ? _self._access : access // ignore: cast_nullable_to_non_nullable
as Map<AppPermission, PermissionAccess>,busy: freezed == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as AppPermission?,canOpenSettings: null == canOpenSettings ? _self.canOpenSettings : canOpenSettings // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
