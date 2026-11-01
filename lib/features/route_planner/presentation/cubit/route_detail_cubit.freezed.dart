// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RouteDetailState {

 RouteDetailStatus get status; TravelRoute? get route; Failure? get failure;/// Silme başarısız olduysa nedeni (rota görünmeye devam eder).
 Failure? get deleteFailure;
/// Create a copy of RouteDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteDetailStateCopyWith<RouteDetailState> get copyWith => _$RouteDetailStateCopyWithImpl<RouteDetailState>(this as RouteDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RouteDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteDetailState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.route, _this.route) || other.route == _this.route)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.deleteFailure, _this.deleteFailure) || other.deleteFailure == _this.deleteFailure));
}


@override
int get hashCode {
  final _this = this as RouteDetailState;
  return Object.hash(runtimeType,_this.status,_this.route,_this.failure,_this.deleteFailure);
}

@override
String toString() {
  final _this = this as RouteDetailState;
  return 'RouteDetailState(status: ${_this.status}, route: ${_this.route}, failure: ${_this.failure}, deleteFailure: ${_this.deleteFailure})';
}


}

/// @nodoc
abstract mixin class $RouteDetailStateCopyWith<$Res>  {
  factory $RouteDetailStateCopyWith(RouteDetailState value, $Res Function(RouteDetailState) _then) = _$RouteDetailStateCopyWithImpl;
@useResult
$Res call({
 RouteDetailStatus status, TravelRoute? route, Failure? failure, Failure? deleteFailure
});




}
/// @nodoc
class _$RouteDetailStateCopyWithImpl<$Res>
    implements $RouteDetailStateCopyWith<$Res> {
  _$RouteDetailStateCopyWithImpl(this._self, this._then);

  final RouteDetailState _self;
  final $Res Function(RouteDetailState) _then;

/// Create a copy of RouteDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? route = freezed,Object? failure = freezed,Object? deleteFailure = freezed,}) {
  return _then(RouteDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RouteDetailStatus,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as TravelRoute?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,deleteFailure: freezed == deleteFailure ? _self.deleteFailure : deleteFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteDetailState].
extension RouteDetailStatePatterns on RouteDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteDetailState value)  $default,){
final _that = this;
switch (_that) {
case _RouteDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _RouteDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RouteDetailStatus status,  TravelRoute? route,  Failure? failure,  Failure? deleteFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteDetailState() when $default != null:
return $default(_that.status,_that.route,_that.failure,_that.deleteFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RouteDetailStatus status,  TravelRoute? route,  Failure? failure,  Failure? deleteFailure)  $default,) {final _that = this;
switch (_that) {
case _RouteDetailState():
return $default(_that.status,_that.route,_that.failure,_that.deleteFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RouteDetailStatus status,  TravelRoute? route,  Failure? failure,  Failure? deleteFailure)?  $default,) {final _that = this;
switch (_that) {
case _RouteDetailState() when $default != null:
return $default(_that.status,_that.route,_that.failure,_that.deleteFailure);case _:
  return null;

}
}

}

/// @nodoc


class _RouteDetailState extends RouteDetailState {
  const _RouteDetailState({this.status = RouteDetailStatus.loading, this.route, this.failure, this.deleteFailure}): super._();
  

@override@JsonKey() final  RouteDetailStatus status;
@override final  TravelRoute? route;
@override final  Failure? failure;
/// Silme başarısız olduysa nedeni (rota görünmeye devam eder).
@override final  Failure? deleteFailure;

/// Create a copy of RouteDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteDetailStateCopyWith<_RouteDetailState> get copyWith => __$RouteDetailStateCopyWithImpl<_RouteDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.route, route) || other.route == route)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.deleteFailure, deleteFailure) || other.deleteFailure == deleteFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,route,failure,deleteFailure);
}

@override
String toString() {
    return 'RouteDetailState(status: $status, route: $route, failure: $failure, deleteFailure: $deleteFailure)';
}


}

/// @nodoc
abstract mixin class _$RouteDetailStateCopyWith<$Res> implements $RouteDetailStateCopyWith<$Res> {
  factory _$RouteDetailStateCopyWith(_RouteDetailState value, $Res Function(_RouteDetailState) _then) = __$RouteDetailStateCopyWithImpl;
@override @useResult
$Res call({
 RouteDetailStatus status, TravelRoute? route, Failure? failure, Failure? deleteFailure
});




}
/// @nodoc
class __$RouteDetailStateCopyWithImpl<$Res>
    implements _$RouteDetailStateCopyWith<$Res> {
  __$RouteDetailStateCopyWithImpl(this._self, this._then);

  final _RouteDetailState _self;
  final $Res Function(_RouteDetailState) _then;

/// Create a copy of RouteDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? route = freezed,Object? failure = freezed,Object? deleteFailure = freezed,}) {
  return _then(_RouteDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RouteDetailStatus,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as TravelRoute?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,deleteFailure: freezed == deleteFailure ? _self.deleteFailure : deleteFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
