// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedbackFormState {

 FeedbackCategory get category; int? get rating; String get message; FeedbackFormStatus get status; bool get showValidationErrors;/// Her geçersiz gönderimde artar (hata duyurusu tekrarlanır).
 int get invalidSubmissions; Failure? get failure;
/// Create a copy of FeedbackFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedbackFormStateCopyWith<FeedbackFormState> get copyWith => _$FeedbackFormStateCopyWithImpl<FeedbackFormState>(this as FeedbackFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FeedbackFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedbackFormState&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.showValidationErrors, _this.showValidationErrors) || other.showValidationErrors == _this.showValidationErrors)&&(identical(other.invalidSubmissions, _this.invalidSubmissions) || other.invalidSubmissions == _this.invalidSubmissions)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as FeedbackFormState;
  return Object.hash(runtimeType,_this.category,_this.rating,_this.message,_this.status,_this.showValidationErrors,_this.invalidSubmissions,_this.failure);
}



}

/// @nodoc
abstract mixin class $FeedbackFormStateCopyWith<$Res>  {
  factory $FeedbackFormStateCopyWith(FeedbackFormState value, $Res Function(FeedbackFormState) _then) = _$FeedbackFormStateCopyWithImpl;
@useResult
$Res call({
 FeedbackCategory category, int? rating, String message, FeedbackFormStatus status, bool showValidationErrors, int invalidSubmissions, Failure? failure
});




}
/// @nodoc
class _$FeedbackFormStateCopyWithImpl<$Res>
    implements $FeedbackFormStateCopyWith<$Res> {
  _$FeedbackFormStateCopyWithImpl(this._self, this._then);

  final FeedbackFormState _self;
  final $Res Function(FeedbackFormState) _then;

/// Create a copy of FeedbackFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? rating = freezed,Object? message = null,Object? status = null,Object? showValidationErrors = null,Object? invalidSubmissions = null,Object? failure = freezed,}) {
  return _then(FeedbackFormState(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FeedbackCategory,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FeedbackFormStatus,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedbackFormState].
extension FeedbackFormStatePatterns on FeedbackFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedbackFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedbackFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedbackFormState value)  $default,){
final _that = this;
switch (_that) {
case _FeedbackFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedbackFormState value)?  $default,){
final _that = this;
switch (_that) {
case _FeedbackFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FeedbackCategory category,  int? rating,  String message,  FeedbackFormStatus status,  bool showValidationErrors,  int invalidSubmissions,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedbackFormState() when $default != null:
return $default(_that.category,_that.rating,_that.message,_that.status,_that.showValidationErrors,_that.invalidSubmissions,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FeedbackCategory category,  int? rating,  String message,  FeedbackFormStatus status,  bool showValidationErrors,  int invalidSubmissions,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _FeedbackFormState():
return $default(_that.category,_that.rating,_that.message,_that.status,_that.showValidationErrors,_that.invalidSubmissions,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FeedbackCategory category,  int? rating,  String message,  FeedbackFormStatus status,  bool showValidationErrors,  int invalidSubmissions,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _FeedbackFormState() when $default != null:
return $default(_that.category,_that.rating,_that.message,_that.status,_that.showValidationErrors,_that.invalidSubmissions,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _FeedbackFormState extends FeedbackFormState {
  const _FeedbackFormState({this.category = FeedbackCategory.suggestion, this.rating, this.message = '', this.status = FeedbackFormStatus.editing, this.showValidationErrors = false, this.invalidSubmissions = 0, this.failure}): super._();
  

@override@JsonKey() final  FeedbackCategory category;
@override final  int? rating;
@override@JsonKey() final  String message;
@override@JsonKey() final  FeedbackFormStatus status;
@override@JsonKey() final  bool showValidationErrors;
/// Her geçersiz gönderimde artar (hata duyurusu tekrarlanır).
@override@JsonKey() final  int invalidSubmissions;
@override final  Failure? failure;

/// Create a copy of FeedbackFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedbackFormStateCopyWith<_FeedbackFormState> get copyWith => __$FeedbackFormStateCopyWithImpl<_FeedbackFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedbackFormState&&(identical(other.category, category) || other.category == category)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&(identical(other.showValidationErrors, showValidationErrors) || other.showValidationErrors == showValidationErrors)&&(identical(other.invalidSubmissions, invalidSubmissions) || other.invalidSubmissions == invalidSubmissions)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,category,rating,message,status,showValidationErrors,invalidSubmissions,failure);
}



}

/// @nodoc
abstract mixin class _$FeedbackFormStateCopyWith<$Res> implements $FeedbackFormStateCopyWith<$Res> {
  factory _$FeedbackFormStateCopyWith(_FeedbackFormState value, $Res Function(_FeedbackFormState) _then) = __$FeedbackFormStateCopyWithImpl;
@override @useResult
$Res call({
 FeedbackCategory category, int? rating, String message, FeedbackFormStatus status, bool showValidationErrors, int invalidSubmissions, Failure? failure
});




}
/// @nodoc
class __$FeedbackFormStateCopyWithImpl<$Res>
    implements _$FeedbackFormStateCopyWith<$Res> {
  __$FeedbackFormStateCopyWithImpl(this._self, this._then);

  final _FeedbackFormState _self;
  final $Res Function(_FeedbackFormState) _then;

/// Create a copy of FeedbackFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? rating = freezed,Object? message = null,Object? status = null,Object? showValidationErrors = null,Object? invalidSubmissions = null,Object? failure = freezed,}) {
  return _then(_FeedbackFormState(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FeedbackCategory,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FeedbackFormStatus,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
