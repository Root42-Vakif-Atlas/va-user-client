// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_permission_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocationPermissionState {

/// `null` → durum henüz okunmadı.
 LocationAccess? get access;/// Sistem penceresi veya ayarlar açıkken `true`.
 bool get isBusy;/// Kalıcı ret / kapalı servis sistem ayarlarından çözülebiliyorsa `true`.
 bool get canOpenSettings;
/// Create a copy of LocationPermissionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationPermissionStateCopyWith<LocationPermissionState> get copyWith => _$LocationPermissionStateCopyWithImpl<LocationPermissionState>(this as LocationPermissionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LocationPermissionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationPermissionState&&(identical(other.access, _this.access) || other.access == _this.access)&&(identical(other.isBusy, _this.isBusy) || other.isBusy == _this.isBusy)&&(identical(other.canOpenSettings, _this.canOpenSettings) || other.canOpenSettings == _this.canOpenSettings));
}


@override
int get hashCode {
  final _this = this as LocationPermissionState;
  return Object.hash(runtimeType,_this.access,_this.isBusy,_this.canOpenSettings);
}

@override
String toString() {
  final _this = this as LocationPermissionState;
  return 'LocationPermissionState(access: ${_this.access}, isBusy: ${_this.isBusy}, canOpenSettings: ${_this.canOpenSettings})';
}


}

/// @nodoc
abstract mixin class $LocationPermissionStateCopyWith<$Res>  {
  factory $LocationPermissionStateCopyWith(LocationPermissionState value, $Res Function(LocationPermissionState) _then) = _$LocationPermissionStateCopyWithImpl;
@useResult
$Res call({
 LocationAccess? access, bool isBusy, bool canOpenSettings
});




}
/// @nodoc
class _$LocationPermissionStateCopyWithImpl<$Res>
    implements $LocationPermissionStateCopyWith<$Res> {
  _$LocationPermissionStateCopyWithImpl(this._self, this._then);

  final LocationPermissionState _self;
  final $Res Function(LocationPermissionState) _then;

/// Create a copy of LocationPermissionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? access = freezed,Object? isBusy = null,Object? canOpenSettings = null,}) {
  return _then(LocationPermissionState(
access: freezed == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as LocationAccess?,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,canOpenSettings: null == canOpenSettings ? _self.canOpenSettings : canOpenSettings // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationPermissionState].
extension LocationPermissionStatePatterns on LocationPermissionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationPermissionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationPermissionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationPermissionState value)  $default,){
final _that = this;
switch (_that) {
case _LocationPermissionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationPermissionState value)?  $default,){
final _that = this;
switch (_that) {
case _LocationPermissionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LocationAccess? access,  bool isBusy,  bool canOpenSettings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationPermissionState() when $default != null:
return $default(_that.access,_that.isBusy,_that.canOpenSettings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LocationAccess? access,  bool isBusy,  bool canOpenSettings)  $default,) {final _that = this;
switch (_that) {
case _LocationPermissionState():
return $default(_that.access,_that.isBusy,_that.canOpenSettings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LocationAccess? access,  bool isBusy,  bool canOpenSettings)?  $default,) {final _that = this;
switch (_that) {
case _LocationPermissionState() when $default != null:
return $default(_that.access,_that.isBusy,_that.canOpenSettings);case _:
  return null;

}
}

}

/// @nodoc


class _LocationPermissionState implements LocationPermissionState {
  const _LocationPermissionState({this.access, this.isBusy = false, this.canOpenSettings = false});
  

/// `null` → durum henüz okunmadı.
@override final  LocationAccess? access;
/// Sistem penceresi veya ayarlar açıkken `true`.
@override@JsonKey() final  bool isBusy;
/// Kalıcı ret / kapalı servis sistem ayarlarından çözülebiliyorsa `true`.
@override@JsonKey() final  bool canOpenSettings;

/// Create a copy of LocationPermissionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationPermissionStateCopyWith<_LocationPermissionState> get copyWith => __$LocationPermissionStateCopyWithImpl<_LocationPermissionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationPermissionState&&(identical(other.access, access) || other.access == access)&&(identical(other.isBusy, isBusy) || other.isBusy == isBusy)&&(identical(other.canOpenSettings, canOpenSettings) || other.canOpenSettings == canOpenSettings));
}


@override
int get hashCode {
    return Object.hash(runtimeType,access,isBusy,canOpenSettings);
}

@override
String toString() {
    return 'LocationPermissionState(access: $access, isBusy: $isBusy, canOpenSettings: $canOpenSettings)';
}


}

/// @nodoc
abstract mixin class _$LocationPermissionStateCopyWith<$Res> implements $LocationPermissionStateCopyWith<$Res> {
  factory _$LocationPermissionStateCopyWith(_LocationPermissionState value, $Res Function(_LocationPermissionState) _then) = __$LocationPermissionStateCopyWithImpl;
@override @useResult
$Res call({
 LocationAccess? access, bool isBusy, bool canOpenSettings
});




}
/// @nodoc
class __$LocationPermissionStateCopyWithImpl<$Res>
    implements _$LocationPermissionStateCopyWith<$Res> {
  __$LocationPermissionStateCopyWithImpl(this._self, this._then);

  final _LocationPermissionState _self;
  final $Res Function(_LocationPermissionState) _then;

/// Create a copy of LocationPermissionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? access = freezed,Object? isBusy = null,Object? canOpenSettings = null,}) {
  return _then(_LocationPermissionState(
access: freezed == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as LocationAccess?,isBusy: null == isBusy ? _self.isBusy : isBusy // ignore: cast_nullable_to_non_nullable
as bool,canOpenSettings: null == canOpenSettings ? _self.canOpenSettings : canOpenSettings // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
