// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_location_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserLocationState {

/// `false` → platformda konum yok; buton gösterilmez.
 bool get isSupported; UserLocationStatus get status; DevicePosition? get position;/// Kamera konumu takip ediyor (buton dolu ikonla gösterilir).
 bool get following;/// Her artışta harita kullanıcı konumuna gider (butona basıldı).
 int get centerRequest;/// Son denemenin hatası; yeni denemede temizlenir.
 LocationIssue? get issue;
/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserLocationStateCopyWith<UserLocationState> get copyWith => _$UserLocationStateCopyWithImpl<UserLocationState>(this as UserLocationState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserLocationState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserLocationState&&(identical(other.isSupported, _this.isSupported) || other.isSupported == _this.isSupported)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.following, _this.following) || other.following == _this.following)&&(identical(other.centerRequest, _this.centerRequest) || other.centerRequest == _this.centerRequest)&&(identical(other.issue, _this.issue) || other.issue == _this.issue));
}


@override
int get hashCode {
  final _this = this as UserLocationState;
  return Object.hash(runtimeType,_this.isSupported,_this.status,_this.position,_this.following,_this.centerRequest,_this.issue);
}

@override
String toString() {
  final _this = this as UserLocationState;
  return 'UserLocationState(isSupported: ${_this.isSupported}, status: ${_this.status}, position: ${_this.position}, following: ${_this.following}, centerRequest: ${_this.centerRequest}, issue: ${_this.issue})';
}


}

/// @nodoc
abstract mixin class $UserLocationStateCopyWith<$Res>  {
  factory $UserLocationStateCopyWith(UserLocationState value, $Res Function(UserLocationState) _then) = _$UserLocationStateCopyWithImpl;
@useResult
$Res call({
 bool isSupported, UserLocationStatus status, DevicePosition? position, bool following, int centerRequest, LocationIssue? issue
});




}
/// @nodoc
class _$UserLocationStateCopyWithImpl<$Res>
    implements $UserLocationStateCopyWith<$Res> {
  _$UserLocationStateCopyWithImpl(this._self, this._then);

  final UserLocationState _self;
  final $Res Function(UserLocationState) _then;

/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSupported = null,Object? status = null,Object? position = freezed,Object? following = null,Object? centerRequest = null,Object? issue = freezed,}) {
  return _then(UserLocationState(
isSupported: null == isSupported ? _self.isSupported : isSupported // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserLocationStatus,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as DevicePosition?,following: null == following ? _self.following : following // ignore: cast_nullable_to_non_nullable
as bool,centerRequest: null == centerRequest ? _self.centerRequest : centerRequest // ignore: cast_nullable_to_non_nullable
as int,issue: freezed == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as LocationIssue?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserLocationState].
extension UserLocationStatePatterns on UserLocationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserLocationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserLocationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserLocationState value)  $default,){
final _that = this;
switch (_that) {
case _UserLocationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserLocationState value)?  $default,){
final _that = this;
switch (_that) {
case _UserLocationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSupported,  UserLocationStatus status,  DevicePosition? position,  bool following,  int centerRequest,  LocationIssue? issue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserLocationState() when $default != null:
return $default(_that.isSupported,_that.status,_that.position,_that.following,_that.centerRequest,_that.issue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSupported,  UserLocationStatus status,  DevicePosition? position,  bool following,  int centerRequest,  LocationIssue? issue)  $default,) {final _that = this;
switch (_that) {
case _UserLocationState():
return $default(_that.isSupported,_that.status,_that.position,_that.following,_that.centerRequest,_that.issue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSupported,  UserLocationStatus status,  DevicePosition? position,  bool following,  int centerRequest,  LocationIssue? issue)?  $default,) {final _that = this;
switch (_that) {
case _UserLocationState() when $default != null:
return $default(_that.isSupported,_that.status,_that.position,_that.following,_that.centerRequest,_that.issue);case _:
  return null;

}
}

}

/// @nodoc


class _UserLocationState implements UserLocationState {
  const _UserLocationState({required this.isSupported, this.status = UserLocationStatus.idle, this.position, this.following = false, this.centerRequest = 0, this.issue});
  

/// `false` → platformda konum yok; buton gösterilmez.
@override final  bool isSupported;
@override@JsonKey() final  UserLocationStatus status;
@override final  DevicePosition? position;
/// Kamera konumu takip ediyor (buton dolu ikonla gösterilir).
@override@JsonKey() final  bool following;
/// Her artışta harita kullanıcı konumuna gider (butona basıldı).
@override@JsonKey() final  int centerRequest;
/// Son denemenin hatası; yeni denemede temizlenir.
@override final  LocationIssue? issue;

/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserLocationStateCopyWith<_UserLocationState> get copyWith => __$UserLocationStateCopyWithImpl<_UserLocationState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserLocationState&&(identical(other.isSupported, isSupported) || other.isSupported == isSupported)&&(identical(other.status, status) || other.status == status)&&(identical(other.position, position) || other.position == position)&&(identical(other.following, following) || other.following == following)&&(identical(other.centerRequest, centerRequest) || other.centerRequest == centerRequest)&&(identical(other.issue, issue) || other.issue == issue));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isSupported,status,position,following,centerRequest,issue);
}

@override
String toString() {
    return 'UserLocationState(isSupported: $isSupported, status: $status, position: $position, following: $following, centerRequest: $centerRequest, issue: $issue)';
}


}

/// @nodoc
abstract mixin class _$UserLocationStateCopyWith<$Res> implements $UserLocationStateCopyWith<$Res> {
  factory _$UserLocationStateCopyWith(_UserLocationState value, $Res Function(_UserLocationState) _then) = __$UserLocationStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSupported, UserLocationStatus status, DevicePosition? position, bool following, int centerRequest, LocationIssue? issue
});




}
/// @nodoc
class __$UserLocationStateCopyWithImpl<$Res>
    implements _$UserLocationStateCopyWith<$Res> {
  __$UserLocationStateCopyWithImpl(this._self, this._then);

  final _UserLocationState _self;
  final $Res Function(_UserLocationState) _then;

/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSupported = null,Object? status = null,Object? position = freezed,Object? following = null,Object? centerRequest = null,Object? issue = freezed,}) {
  return _then(_UserLocationState(
isSupported: null == isSupported ? _self.isSupported : isSupported // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserLocationStatus,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as DevicePosition?,following: null == following ? _self.following : following // ignore: cast_nullable_to_non_nullable
as bool,centerRequest: null == centerRequest ? _self.centerRequest : centerRequest // ignore: cast_nullable_to_non_nullable
as int,issue: freezed == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as LocationIssue?,
  ));
}


}

// dart format on
