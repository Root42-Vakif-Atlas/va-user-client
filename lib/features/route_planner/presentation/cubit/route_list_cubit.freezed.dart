// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RouteListState {

 RouteListStatus get status;/// Son başarılı yüklemenin rotaları; yenileme sırasında da gösterilir.
 List<RouteOverview> get routes; Failure? get failure;
/// Create a copy of RouteListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteListStateCopyWith<RouteListState> get copyWith => _$RouteListStateCopyWithImpl<RouteListState>(this as RouteListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RouteListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteListState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.routes, _this.routes)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as RouteListState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.routes),_this.failure);
}

@override
String toString() {
  final _this = this as RouteListState;
  return 'RouteListState(status: ${_this.status}, routes: ${_this.routes}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $RouteListStateCopyWith<$Res>  {
  factory $RouteListStateCopyWith(RouteListState value, $Res Function(RouteListState) _then) = _$RouteListStateCopyWithImpl;
@useResult
$Res call({
 RouteListStatus status, List<RouteOverview> routes, Failure? failure
});




}
/// @nodoc
class _$RouteListStateCopyWithImpl<$Res>
    implements $RouteListStateCopyWith<$Res> {
  _$RouteListStateCopyWithImpl(this._self, this._then);

  final RouteListState _self;
  final $Res Function(RouteListState) _then;

/// Create a copy of RouteListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? routes = null,Object? failure = freezed,}) {
  return _then(RouteListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RouteListStatus,routes: null == routes ? _self.routes : routes // ignore: cast_nullable_to_non_nullable
as List<RouteOverview>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteListState].
extension RouteListStatePatterns on RouteListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteListState value)  $default,){
final _that = this;
switch (_that) {
case _RouteListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteListState value)?  $default,){
final _that = this;
switch (_that) {
case _RouteListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RouteListStatus status,  List<RouteOverview> routes,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteListState() when $default != null:
return $default(_that.status,_that.routes,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RouteListStatus status,  List<RouteOverview> routes,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _RouteListState():
return $default(_that.status,_that.routes,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RouteListStatus status,  List<RouteOverview> routes,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _RouteListState() when $default != null:
return $default(_that.status,_that.routes,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _RouteListState implements RouteListState {
  const _RouteListState({this.status = RouteListStatus.initial,  List<RouteOverview> routes = const <RouteOverview>[], this.failure}): _routes = routes;
  

@override@JsonKey() final  RouteListStatus status;
/// Son başarılı yüklemenin rotaları; yenileme sırasında da gösterilir.
 final  List<RouteOverview> _routes;
/// Son başarılı yüklemenin rotaları; yenileme sırasında da gösterilir.
@override@JsonKey() List<RouteOverview> get routes {
  if (_routes is EqualUnmodifiableListView) return _routes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routes);
}

@override final  Failure? failure;

/// Create a copy of RouteListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteListStateCopyWith<_RouteListState> get copyWith => __$RouteListStateCopyWithImpl<_RouteListState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.routes, _routes)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_routes),failure);
}

@override
String toString() {
    return 'RouteListState(status: $status, routes: $routes, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$RouteListStateCopyWith<$Res> implements $RouteListStateCopyWith<$Res> {
  factory _$RouteListStateCopyWith(_RouteListState value, $Res Function(_RouteListState) _then) = __$RouteListStateCopyWithImpl;
@override @useResult
$Res call({
 RouteListStatus status, List<RouteOverview> routes, Failure? failure
});




}
/// @nodoc
class __$RouteListStateCopyWithImpl<$Res>
    implements _$RouteListStateCopyWith<$Res> {
  __$RouteListStateCopyWithImpl(this._self, this._then);

  final _RouteListState _self;
  final $Res Function(_RouteListState) _then;

/// Create a copy of RouteListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? routes = null,Object? failure = freezed,}) {
  return _then(_RouteListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RouteListStatus,routes: null == routes ? _self._routes : routes // ignore: cast_nullable_to_non_nullable
as List<RouteOverview>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
