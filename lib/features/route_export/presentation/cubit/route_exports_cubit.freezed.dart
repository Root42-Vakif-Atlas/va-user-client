// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_exports_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RouteExportsState {

 RouteExportsStatus get status; List<RouteExport> get items; Failure? get failure;/// Açılan veya silinen kaydın işlem hatası (liste korunur).
 Failure? get actionFailure;/// Her silme başarısında artar (duyuru).
 int get deletions;
/// Create a copy of RouteExportsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteExportsStateCopyWith<RouteExportsState> get copyWith => _$RouteExportsStateCopyWithImpl<RouteExportsState>(this as RouteExportsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RouteExportsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteExportsState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.actionFailure, _this.actionFailure) || other.actionFailure == _this.actionFailure)&&(identical(other.deletions, _this.deletions) || other.deletions == _this.deletions));
}


@override
int get hashCode {
  final _this = this as RouteExportsState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.items),_this.failure,_this.actionFailure,_this.deletions);
}

@override
String toString() {
  final _this = this as RouteExportsState;
  return 'RouteExportsState(status: ${_this.status}, items: ${_this.items}, failure: ${_this.failure}, actionFailure: ${_this.actionFailure}, deletions: ${_this.deletions})';
}


}

/// @nodoc
abstract mixin class $RouteExportsStateCopyWith<$Res>  {
  factory $RouteExportsStateCopyWith(RouteExportsState value, $Res Function(RouteExportsState) _then) = _$RouteExportsStateCopyWithImpl;
@useResult
$Res call({
 RouteExportsStatus status, List<RouteExport> items, Failure? failure, Failure? actionFailure, int deletions
});




}
/// @nodoc
class _$RouteExportsStateCopyWithImpl<$Res>
    implements $RouteExportsStateCopyWith<$Res> {
  _$RouteExportsStateCopyWithImpl(this._self, this._then);

  final RouteExportsState _self;
  final $Res Function(RouteExportsState) _then;

/// Create a copy of RouteExportsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? failure = freezed,Object? actionFailure = freezed,Object? deletions = null,}) {
  return _then(RouteExportsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RouteExportsStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<RouteExport>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,deletions: null == deletions ? _self.deletions : deletions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteExportsState].
extension RouteExportsStatePatterns on RouteExportsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteExportsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteExportsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteExportsState value)  $default,){
final _that = this;
switch (_that) {
case _RouteExportsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteExportsState value)?  $default,){
final _that = this;
switch (_that) {
case _RouteExportsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RouteExportsStatus status,  List<RouteExport> items,  Failure? failure,  Failure? actionFailure,  int deletions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteExportsState() when $default != null:
return $default(_that.status,_that.items,_that.failure,_that.actionFailure,_that.deletions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RouteExportsStatus status,  List<RouteExport> items,  Failure? failure,  Failure? actionFailure,  int deletions)  $default,) {final _that = this;
switch (_that) {
case _RouteExportsState():
return $default(_that.status,_that.items,_that.failure,_that.actionFailure,_that.deletions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RouteExportsStatus status,  List<RouteExport> items,  Failure? failure,  Failure? actionFailure,  int deletions)?  $default,) {final _that = this;
switch (_that) {
case _RouteExportsState() when $default != null:
return $default(_that.status,_that.items,_that.failure,_that.actionFailure,_that.deletions);case _:
  return null;

}
}

}

/// @nodoc


class _RouteExportsState implements RouteExportsState {
  const _RouteExportsState({this.status = RouteExportsStatus.loading,  List<RouteExport> items = const <RouteExport>[], this.failure, this.actionFailure, this.deletions = 0}): _items = items;
  

@override@JsonKey() final  RouteExportsStatus status;
 final  List<RouteExport> _items;
@override@JsonKey() List<RouteExport> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Failure? failure;
/// Açılan veya silinen kaydın işlem hatası (liste korunur).
@override final  Failure? actionFailure;
/// Her silme başarısında artar (duyuru).
@override@JsonKey() final  int deletions;

/// Create a copy of RouteExportsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteExportsStateCopyWith<_RouteExportsState> get copyWith => __$RouteExportsStateCopyWithImpl<_RouteExportsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteExportsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure)&&(identical(other.deletions, deletions) || other.deletions == deletions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),failure,actionFailure,deletions);
}

@override
String toString() {
    return 'RouteExportsState(status: $status, items: $items, failure: $failure, actionFailure: $actionFailure, deletions: $deletions)';
}


}

/// @nodoc
abstract mixin class _$RouteExportsStateCopyWith<$Res> implements $RouteExportsStateCopyWith<$Res> {
  factory _$RouteExportsStateCopyWith(_RouteExportsState value, $Res Function(_RouteExportsState) _then) = __$RouteExportsStateCopyWithImpl;
@override @useResult
$Res call({
 RouteExportsStatus status, List<RouteExport> items, Failure? failure, Failure? actionFailure, int deletions
});




}
/// @nodoc
class __$RouteExportsStateCopyWithImpl<$Res>
    implements _$RouteExportsStateCopyWith<$Res> {
  __$RouteExportsStateCopyWithImpl(this._self, this._then);

  final _RouteExportsState _self;
  final $Res Function(_RouteExportsState) _then;

/// Create a copy of RouteExportsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? failure = freezed,Object? actionFailure = freezed,Object? deletions = null,}) {
  return _then(_RouteExportsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RouteExportsStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<RouteExport>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,deletions: null == deletions ? _self.deletions : deletions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
