// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GamificationState {

 GamificationStatus get status;/// Yenileme başarısız olsa da son profil gösterilmeye devam eder.
 GamificationProfile? get profile; Failure? get failure;
/// Create a copy of GamificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GamificationStateCopyWith<GamificationState> get copyWith => _$GamificationStateCopyWithImpl<GamificationState>(this as GamificationState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GamificationState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GamificationState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as GamificationState;
  return Object.hash(runtimeType,_this.status,_this.profile,_this.failure);
}

@override
String toString() {
  final _this = this as GamificationState;
  return 'GamificationState(status: ${_this.status}, profile: ${_this.profile}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $GamificationStateCopyWith<$Res>  {
  factory $GamificationStateCopyWith(GamificationState value, $Res Function(GamificationState) _then) = _$GamificationStateCopyWithImpl;
@useResult
$Res call({
 GamificationStatus status, GamificationProfile? profile, Failure? failure
});




}
/// @nodoc
class _$GamificationStateCopyWithImpl<$Res>
    implements $GamificationStateCopyWith<$Res> {
  _$GamificationStateCopyWithImpl(this._self, this._then);

  final GamificationState _self;
  final $Res Function(GamificationState) _then;

/// Create a copy of GamificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? profile = freezed,Object? failure = freezed,}) {
  return _then(GamificationState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GamificationStatus,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as GamificationProfile?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [GamificationState].
extension GamificationStatePatterns on GamificationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GamificationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GamificationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GamificationState value)  $default,){
final _that = this;
switch (_that) {
case _GamificationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GamificationState value)?  $default,){
final _that = this;
switch (_that) {
case _GamificationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GamificationStatus status,  GamificationProfile? profile,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GamificationState() when $default != null:
return $default(_that.status,_that.profile,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GamificationStatus status,  GamificationProfile? profile,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _GamificationState():
return $default(_that.status,_that.profile,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GamificationStatus status,  GamificationProfile? profile,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _GamificationState() when $default != null:
return $default(_that.status,_that.profile,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _GamificationState extends GamificationState {
  const _GamificationState({this.status = GamificationStatus.inactive, this.profile, this.failure}): super._();
  

@override@JsonKey() final  GamificationStatus status;
/// Yenileme başarısız olsa da son profil gösterilmeye devam eder.
@override final  GamificationProfile? profile;
@override final  Failure? failure;

/// Create a copy of GamificationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GamificationStateCopyWith<_GamificationState> get copyWith => __$GamificationStateCopyWithImpl<_GamificationState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GamificationState&&(identical(other.status, status) || other.status == status)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,profile,failure);
}

@override
String toString() {
    return 'GamificationState(status: $status, profile: $profile, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$GamificationStateCopyWith<$Res> implements $GamificationStateCopyWith<$Res> {
  factory _$GamificationStateCopyWith(_GamificationState value, $Res Function(_GamificationState) _then) = __$GamificationStateCopyWithImpl;
@override @useResult
$Res call({
 GamificationStatus status, GamificationProfile? profile, Failure? failure
});




}
/// @nodoc
class __$GamificationStateCopyWithImpl<$Res>
    implements _$GamificationStateCopyWith<$Res> {
  __$GamificationStateCopyWithImpl(this._self, this._then);

  final _GamificationState _self;
  final $Res Function(_GamificationState) _then;

/// Create a copy of GamificationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? profile = freezed,Object? failure = freezed,}) {
  return _then(_GamificationState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GamificationStatus,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as GamificationProfile?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
