// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complex_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComplexDetailState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplexDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ComplexDetailState()';
}


}

/// @nodoc
class $ComplexDetailStateCopyWith<$Res>  {
$ComplexDetailStateCopyWith(ComplexDetailState _, $Res Function(ComplexDetailState) __);
}


/// Adds pattern-matching-related methods to [ComplexDetailState].
extension ComplexDetailStatePatterns on ComplexDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ComplexDetailInitial value)?  initial,TResult Function( ComplexDetailLoading value)?  loading,TResult Function( ComplexDetailLoaded value)?  loaded,TResult Function( ComplexDetailFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ComplexDetailInitial() when initial != null:
return initial(_that);case ComplexDetailLoading() when loading != null:
return loading(_that);case ComplexDetailLoaded() when loaded != null:
return loaded(_that);case ComplexDetailFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ComplexDetailInitial value)  initial,required TResult Function( ComplexDetailLoading value)  loading,required TResult Function( ComplexDetailLoaded value)  loaded,required TResult Function( ComplexDetailFailure value)  failure,}){
final _that = this;
switch (_that) {
case ComplexDetailInitial():
return initial(_that);case ComplexDetailLoading():
return loading(_that);case ComplexDetailLoaded():
return loaded(_that);case ComplexDetailFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ComplexDetailInitial value)?  initial,TResult? Function( ComplexDetailLoading value)?  loading,TResult? Function( ComplexDetailLoaded value)?  loaded,TResult? Function( ComplexDetailFailure value)?  failure,}){
final _that = this;
switch (_that) {
case ComplexDetailInitial() when initial != null:
return initial(_that);case ComplexDetailLoading() when loading != null:
return loading(_that);case ComplexDetailLoaded() when loaded != null:
return loaded(_that);case ComplexDetailFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( ComplexDetail complex)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ComplexDetailInitial() when initial != null:
return initial();case ComplexDetailLoading() when loading != null:
return loading();case ComplexDetailLoaded() when loaded != null:
return loaded(_that.complex);case ComplexDetailFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( ComplexDetail complex)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case ComplexDetailInitial():
return initial();case ComplexDetailLoading():
return loading();case ComplexDetailLoaded():
return loaded(_that.complex);case ComplexDetailFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( ComplexDetail complex)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case ComplexDetailInitial() when initial != null:
return initial();case ComplexDetailLoading() when loading != null:
return loading();case ComplexDetailLoaded() when loaded != null:
return loaded(_that.complex);case ComplexDetailFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ComplexDetailInitial extends ComplexDetailState {
  const ComplexDetailInitial(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplexDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ComplexDetailState.initial()';
}


}




/// @nodoc


class ComplexDetailLoading extends ComplexDetailState {
  const ComplexDetailLoading(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplexDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ComplexDetailState.loading()';
}


}




/// @nodoc


class ComplexDetailLoaded extends ComplexDetailState {
  const ComplexDetailLoaded(this.complex): super._();
  

 final  ComplexDetail complex;

/// Create a copy of ComplexDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplexDetailLoadedCopyWith<ComplexDetailLoaded> get copyWith => _$ComplexDetailLoadedCopyWithImpl<ComplexDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplexDetailLoaded&&(identical(other.complex, complex) || other.complex == complex));
}


@override
int get hashCode {
    return Object.hash(runtimeType,complex);
}

@override
String toString() {
    return 'ComplexDetailState.loaded(complex: $complex)';
}


}

/// @nodoc
abstract mixin class $ComplexDetailLoadedCopyWith<$Res> implements $ComplexDetailStateCopyWith<$Res> {
  factory $ComplexDetailLoadedCopyWith(ComplexDetailLoaded value, $Res Function(ComplexDetailLoaded) _then) = _$ComplexDetailLoadedCopyWithImpl;
@useResult
$Res call({
 ComplexDetail complex
});




}
/// @nodoc
class _$ComplexDetailLoadedCopyWithImpl<$Res>
    implements $ComplexDetailLoadedCopyWith<$Res> {
  _$ComplexDetailLoadedCopyWithImpl(this._self, this._then);

  final ComplexDetailLoaded _self;
  final $Res Function(ComplexDetailLoaded) _then;

/// Create a copy of ComplexDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? complex = null,}) {
  return _then(ComplexDetailLoaded(
null == complex ? _self.complex : complex // ignore: cast_nullable_to_non_nullable
as ComplexDetail,
  ));
}


}

/// @nodoc


class ComplexDetailFailure extends ComplexDetailState {
  const ComplexDetailFailure(this.failure): super._();
  

 final  Failure failure;

/// Create a copy of ComplexDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplexDetailFailureCopyWith<ComplexDetailFailure> get copyWith => _$ComplexDetailFailureCopyWithImpl<ComplexDetailFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplexDetailFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'ComplexDetailState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ComplexDetailFailureCopyWith<$Res> implements $ComplexDetailStateCopyWith<$Res> {
  factory $ComplexDetailFailureCopyWith(ComplexDetailFailure value, $Res Function(ComplexDetailFailure) _then) = _$ComplexDetailFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$ComplexDetailFailureCopyWithImpl<$Res>
    implements $ComplexDetailFailureCopyWith<$Res> {
  _$ComplexDetailFailureCopyWithImpl(this._self, this._then);

  final ComplexDetailFailure _self;
  final $Res Function(ComplexDetailFailure) _then;

/// Create a copy of ComplexDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ComplexDetailFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
