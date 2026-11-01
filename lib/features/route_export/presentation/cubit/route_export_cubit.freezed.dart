// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_export_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RouteExportState {

 RouteExportStatus get status;/// Son üretilen PDF.
 RouteExportFile? get file; Failure? get failure;
/// Create a copy of RouteExportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteExportStateCopyWith<RouteExportState> get copyWith => _$RouteExportStateCopyWithImpl<RouteExportState>(this as RouteExportState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RouteExportState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteExportState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.file, _this.file) || other.file == _this.file)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as RouteExportState;
  return Object.hash(runtimeType,_this.status,_this.file,_this.failure);
}

@override
String toString() {
  final _this = this as RouteExportState;
  return 'RouteExportState(status: ${_this.status}, file: ${_this.file}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $RouteExportStateCopyWith<$Res>  {
  factory $RouteExportStateCopyWith(RouteExportState value, $Res Function(RouteExportState) _then) = _$RouteExportStateCopyWithImpl;
@useResult
$Res call({
 RouteExportStatus status, RouteExportFile? file, Failure? failure
});




}
/// @nodoc
class _$RouteExportStateCopyWithImpl<$Res>
    implements $RouteExportStateCopyWith<$Res> {
  _$RouteExportStateCopyWithImpl(this._self, this._then);

  final RouteExportState _self;
  final $Res Function(RouteExportState) _then;

/// Create a copy of RouteExportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? file = freezed,Object? failure = freezed,}) {
  return _then(RouteExportState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RouteExportStatus,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as RouteExportFile?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteExportState].
extension RouteExportStatePatterns on RouteExportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteExportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteExportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteExportState value)  $default,){
final _that = this;
switch (_that) {
case _RouteExportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteExportState value)?  $default,){
final _that = this;
switch (_that) {
case _RouteExportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RouteExportStatus status,  RouteExportFile? file,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteExportState() when $default != null:
return $default(_that.status,_that.file,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RouteExportStatus status,  RouteExportFile? file,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _RouteExportState():
return $default(_that.status,_that.file,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RouteExportStatus status,  RouteExportFile? file,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _RouteExportState() when $default != null:
return $default(_that.status,_that.file,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _RouteExportState extends RouteExportState {
  const _RouteExportState({this.status = RouteExportStatus.idle, this.file, this.failure}): super._();
  

@override@JsonKey() final  RouteExportStatus status;
/// Son üretilen PDF.
@override final  RouteExportFile? file;
@override final  Failure? failure;

/// Create a copy of RouteExportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteExportStateCopyWith<_RouteExportState> get copyWith => __$RouteExportStateCopyWithImpl<_RouteExportState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteExportState&&(identical(other.status, status) || other.status == status)&&(identical(other.file, file) || other.file == file)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,file,failure);
}

@override
String toString() {
    return 'RouteExportState(status: $status, file: $file, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$RouteExportStateCopyWith<$Res> implements $RouteExportStateCopyWith<$Res> {
  factory _$RouteExportStateCopyWith(_RouteExportState value, $Res Function(_RouteExportState) _then) = __$RouteExportStateCopyWithImpl;
@override @useResult
$Res call({
 RouteExportStatus status, RouteExportFile? file, Failure? failure
});




}
/// @nodoc
class __$RouteExportStateCopyWithImpl<$Res>
    implements _$RouteExportStateCopyWith<$Res> {
  __$RouteExportStateCopyWithImpl(this._self, this._then);

  final _RouteExportState _self;
  final $Res Function(_RouteExportState) _then;

/// Create a copy of RouteExportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? file = freezed,Object? failure = freezed,}) {
  return _then(_RouteExportState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RouteExportStatus,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as RouteExportFile?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
