// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monument_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonumentDetailState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MonumentDetailState()';
}


}

/// @nodoc
class $MonumentDetailStateCopyWith<$Res>  {
$MonumentDetailStateCopyWith(MonumentDetailState _, $Res Function(MonumentDetailState) __);
}


/// Adds pattern-matching-related methods to [MonumentDetailState].
extension MonumentDetailStatePatterns on MonumentDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MonumentDetailInitial value)?  initial,TResult Function( MonumentDetailLoading value)?  loading,TResult Function( MonumentDetailLoaded value)?  loaded,TResult Function( MonumentDetailFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MonumentDetailInitial() when initial != null:
return initial(_that);case MonumentDetailLoading() when loading != null:
return loading(_that);case MonumentDetailLoaded() when loaded != null:
return loaded(_that);case MonumentDetailFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MonumentDetailInitial value)  initial,required TResult Function( MonumentDetailLoading value)  loading,required TResult Function( MonumentDetailLoaded value)  loaded,required TResult Function( MonumentDetailFailure value)  failure,}){
final _that = this;
switch (_that) {
case MonumentDetailInitial():
return initial(_that);case MonumentDetailLoading():
return loading(_that);case MonumentDetailLoaded():
return loaded(_that);case MonumentDetailFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MonumentDetailInitial value)?  initial,TResult? Function( MonumentDetailLoading value)?  loading,TResult? Function( MonumentDetailLoaded value)?  loaded,TResult? Function( MonumentDetailFailure value)?  failure,}){
final _that = this;
switch (_that) {
case MonumentDetailInitial() when initial != null:
return initial(_that);case MonumentDetailLoading() when loading != null:
return loading(_that);case MonumentDetailLoaded() when loaded != null:
return loaded(_that);case MonumentDetailFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( MonumentDetail monument,  List<MonumentSummary> siblings)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MonumentDetailInitial() when initial != null:
return initial();case MonumentDetailLoading() when loading != null:
return loading();case MonumentDetailLoaded() when loaded != null:
return loaded(_that.monument,_that.siblings);case MonumentDetailFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( MonumentDetail monument,  List<MonumentSummary> siblings)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case MonumentDetailInitial():
return initial();case MonumentDetailLoading():
return loading();case MonumentDetailLoaded():
return loaded(_that.monument,_that.siblings);case MonumentDetailFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( MonumentDetail monument,  List<MonumentSummary> siblings)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case MonumentDetailInitial() when initial != null:
return initial();case MonumentDetailLoading() when loading != null:
return loading();case MonumentDetailLoaded() when loaded != null:
return loaded(_that.monument,_that.siblings);case MonumentDetailFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class MonumentDetailInitial extends MonumentDetailState {
  const MonumentDetailInitial(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MonumentDetailState.initial()';
}


}




/// @nodoc


class MonumentDetailLoading extends MonumentDetailState {
  const MonumentDetailLoading(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MonumentDetailState.loading()';
}


}




/// @nodoc


class MonumentDetailLoaded extends MonumentDetailState {
  const MonumentDetailLoaded(this.monument, { List<MonumentSummary> siblings = const <MonumentSummary>[]}): _siblings = siblings,super._();
  

 final  MonumentDetail monument;
 final  List<MonumentSummary> _siblings;
@JsonKey() List<MonumentSummary> get siblings {
  if (_siblings is EqualUnmodifiableListView) return _siblings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_siblings);
}


/// Create a copy of MonumentDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentDetailLoadedCopyWith<MonumentDetailLoaded> get copyWith => _$MonumentDetailLoadedCopyWithImpl<MonumentDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentDetailLoaded&&(identical(other.monument, monument) || other.monument == monument)&&const DeepCollectionEquality().equals(other.siblings, _siblings));
}


@override
int get hashCode {
    return Object.hash(runtimeType,monument,const DeepCollectionEquality().hash(_siblings));
}

@override
String toString() {
    return 'MonumentDetailState.loaded(monument: $monument, siblings: $siblings)';
}


}

/// @nodoc
abstract mixin class $MonumentDetailLoadedCopyWith<$Res> implements $MonumentDetailStateCopyWith<$Res> {
  factory $MonumentDetailLoadedCopyWith(MonumentDetailLoaded value, $Res Function(MonumentDetailLoaded) _then) = _$MonumentDetailLoadedCopyWithImpl;
@useResult
$Res call({
 MonumentDetail monument, List<MonumentSummary> siblings
});




}
/// @nodoc
class _$MonumentDetailLoadedCopyWithImpl<$Res>
    implements $MonumentDetailLoadedCopyWith<$Res> {
  _$MonumentDetailLoadedCopyWithImpl(this._self, this._then);

  final MonumentDetailLoaded _self;
  final $Res Function(MonumentDetailLoaded) _then;

/// Create a copy of MonumentDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? monument = null,Object? siblings = null,}) {
  return _then(MonumentDetailLoaded(
null == monument ? _self.monument : monument // ignore: cast_nullable_to_non_nullable
as MonumentDetail,siblings: null == siblings ? _self._siblings : siblings // ignore: cast_nullable_to_non_nullable
as List<MonumentSummary>,
  ));
}


}

/// @nodoc


class MonumentDetailFailure extends MonumentDetailState {
  const MonumentDetailFailure(this.failure): super._();
  

 final  Failure failure;

/// Create a copy of MonumentDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentDetailFailureCopyWith<MonumentDetailFailure> get copyWith => _$MonumentDetailFailureCopyWithImpl<MonumentDetailFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentDetailFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'MonumentDetailState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MonumentDetailFailureCopyWith<$Res> implements $MonumentDetailStateCopyWith<$Res> {
  factory $MonumentDetailFailureCopyWith(MonumentDetailFailure value, $Res Function(MonumentDetailFailure) _then) = _$MonumentDetailFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$MonumentDetailFailureCopyWithImpl<$Res>
    implements $MonumentDetailFailureCopyWith<$Res> {
  _$MonumentDetailFailureCopyWithImpl(this._self, this._then);

  final MonumentDetailFailure _self;
  final $Res Function(MonumentDetailFailure) _then;

/// Create a copy of MonumentDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(MonumentDetailFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
