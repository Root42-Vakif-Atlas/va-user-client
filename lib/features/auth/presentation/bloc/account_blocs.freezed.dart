// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_blocs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ForgotPasswordEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ForgotPasswordEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ForgotPasswordEvent()';
}


}

/// @nodoc
class $ForgotPasswordEventCopyWith<$Res>  {
$ForgotPasswordEventCopyWith(ForgotPasswordEvent _, $Res Function(ForgotPasswordEvent) __);
}


/// Adds pattern-matching-related methods to [ForgotPasswordEvent].
extension ForgotPasswordEventPatterns on ForgotPasswordEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ForgotPasswordEmailChanged value)?  emailChanged,TResult Function( ForgotPasswordSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ForgotPasswordEmailChanged() when emailChanged != null:
return emailChanged(_that);case ForgotPasswordSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ForgotPasswordEmailChanged value)  emailChanged,required TResult Function( ForgotPasswordSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case ForgotPasswordEmailChanged():
return emailChanged(_that);case ForgotPasswordSubmitted():
return submitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ForgotPasswordEmailChanged value)?  emailChanged,TResult? Function( ForgotPasswordSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case ForgotPasswordEmailChanged() when emailChanged != null:
return emailChanged(_that);case ForgotPasswordSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  emailChanged,TResult Function()?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ForgotPasswordEmailChanged() when emailChanged != null:
return emailChanged(_that.value);case ForgotPasswordSubmitted() when submitted != null:
return submitted();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  emailChanged,required TResult Function()  submitted,}) {final _that = this;
switch (_that) {
case ForgotPasswordEmailChanged():
return emailChanged(_that.value);case ForgotPasswordSubmitted():
return submitted();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  emailChanged,TResult? Function()?  submitted,}) {final _that = this;
switch (_that) {
case ForgotPasswordEmailChanged() when emailChanged != null:
return emailChanged(_that.value);case ForgotPasswordSubmitted() when submitted != null:
return submitted();case _:
  return null;

}
}

}

/// @nodoc


class ForgotPasswordEmailChanged implements ForgotPasswordEvent {
  const ForgotPasswordEmailChanged(this.value);
  

 final  String value;

/// Create a copy of ForgotPasswordEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForgotPasswordEmailChangedCopyWith<ForgotPasswordEmailChanged> get copyWith => _$ForgotPasswordEmailChangedCopyWithImpl<ForgotPasswordEmailChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ForgotPasswordEmailChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'ForgotPasswordEvent.emailChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $ForgotPasswordEmailChangedCopyWith<$Res> implements $ForgotPasswordEventCopyWith<$Res> {
  factory $ForgotPasswordEmailChangedCopyWith(ForgotPasswordEmailChanged value, $Res Function(ForgotPasswordEmailChanged) _then) = _$ForgotPasswordEmailChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$ForgotPasswordEmailChangedCopyWithImpl<$Res>
    implements $ForgotPasswordEmailChangedCopyWith<$Res> {
  _$ForgotPasswordEmailChangedCopyWithImpl(this._self, this._then);

  final ForgotPasswordEmailChanged _self;
  final $Res Function(ForgotPasswordEmailChanged) _then;

/// Create a copy of ForgotPasswordEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(ForgotPasswordEmailChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ForgotPasswordSubmitted implements ForgotPasswordEvent {
  const ForgotPasswordSubmitted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ForgotPasswordSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ForgotPasswordEvent.submitted()';
}


}




/// @nodoc
mixin _$ForgotPasswordState {

 String get email; bool get showValidationErrors; FormStatus get status; int get invalidSubmissions; Failure? get failure; VerificationChallenge? get challenge;
/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForgotPasswordStateCopyWith<ForgotPasswordState> get copyWith => _$ForgotPasswordStateCopyWithImpl<ForgotPasswordState>(this as ForgotPasswordState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ForgotPasswordState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForgotPasswordState&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.showValidationErrors, _this.showValidationErrors) || other.showValidationErrors == _this.showValidationErrors)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.invalidSubmissions, _this.invalidSubmissions) || other.invalidSubmissions == _this.invalidSubmissions)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.challenge, _this.challenge) || other.challenge == _this.challenge));
}


@override
int get hashCode {
  final _this = this as ForgotPasswordState;
  return Object.hash(runtimeType,_this.email,_this.showValidationErrors,_this.status,_this.invalidSubmissions,_this.failure,_this.challenge);
}



}

/// @nodoc
abstract mixin class $ForgotPasswordStateCopyWith<$Res>  {
  factory $ForgotPasswordStateCopyWith(ForgotPasswordState value, $Res Function(ForgotPasswordState) _then) = _$ForgotPasswordStateCopyWithImpl;
@useResult
$Res call({
 String email, bool showValidationErrors, FormStatus status, int invalidSubmissions, Failure? failure, VerificationChallenge? challenge
});




}
/// @nodoc
class _$ForgotPasswordStateCopyWithImpl<$Res>
    implements $ForgotPasswordStateCopyWith<$Res> {
  _$ForgotPasswordStateCopyWithImpl(this._self, this._then);

  final ForgotPasswordState _self;
  final $Res Function(ForgotPasswordState) _then;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? failure = freezed,Object? challenge = freezed,}) {
  return _then(ForgotPasswordState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,challenge: freezed == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as VerificationChallenge?,
  ));
}

}


/// Adds pattern-matching-related methods to [ForgotPasswordState].
extension ForgotPasswordStatePatterns on ForgotPasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForgotPasswordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForgotPasswordState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForgotPasswordState value)  $default,){
final _that = this;
switch (_that) {
case _ForgotPasswordState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForgotPasswordState value)?  $default,){
final _that = this;
switch (_that) {
case _ForgotPasswordState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  Failure? failure,  VerificationChallenge? challenge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForgotPasswordState() when $default != null:
return $default(_that.email,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure,_that.challenge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  Failure? failure,  VerificationChallenge? challenge)  $default,) {final _that = this;
switch (_that) {
case _ForgotPasswordState():
return $default(_that.email,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure,_that.challenge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  Failure? failure,  VerificationChallenge? challenge)?  $default,) {final _that = this;
switch (_that) {
case _ForgotPasswordState() when $default != null:
return $default(_that.email,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure,_that.challenge);case _:
  return null;

}
}

}

/// @nodoc


class _ForgotPasswordState extends ForgotPasswordState {
  const _ForgotPasswordState({this.email = '', this.showValidationErrors = false, this.status = FormStatus.editing, this.invalidSubmissions = 0, this.failure, this.challenge}): super._();
  

@override@JsonKey() final  String email;
@override@JsonKey() final  bool showValidationErrors;
@override@JsonKey() final  FormStatus status;
@override@JsonKey() final  int invalidSubmissions;
@override final  Failure? failure;
@override final  VerificationChallenge? challenge;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForgotPasswordStateCopyWith<_ForgotPasswordState> get copyWith => __$ForgotPasswordStateCopyWithImpl<_ForgotPasswordState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForgotPasswordState&&(identical(other.email, email) || other.email == email)&&(identical(other.showValidationErrors, showValidationErrors) || other.showValidationErrors == showValidationErrors)&&(identical(other.status, status) || other.status == status)&&(identical(other.invalidSubmissions, invalidSubmissions) || other.invalidSubmissions == invalidSubmissions)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.challenge, challenge) || other.challenge == challenge));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email,showValidationErrors,status,invalidSubmissions,failure,challenge);
}



}

/// @nodoc
abstract mixin class _$ForgotPasswordStateCopyWith<$Res> implements $ForgotPasswordStateCopyWith<$Res> {
  factory _$ForgotPasswordStateCopyWith(_ForgotPasswordState value, $Res Function(_ForgotPasswordState) _then) = __$ForgotPasswordStateCopyWithImpl;
@override @useResult
$Res call({
 String email, bool showValidationErrors, FormStatus status, int invalidSubmissions, Failure? failure, VerificationChallenge? challenge
});




}
/// @nodoc
class __$ForgotPasswordStateCopyWithImpl<$Res>
    implements _$ForgotPasswordStateCopyWith<$Res> {
  __$ForgotPasswordStateCopyWithImpl(this._self, this._then);

  final _ForgotPasswordState _self;
  final $Res Function(_ForgotPasswordState) _then;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? failure = freezed,Object? challenge = freezed,}) {
  return _then(_ForgotPasswordState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,challenge: freezed == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as VerificationChallenge?,
  ));
}


}

/// @nodoc
mixin _$ChangePasswordEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ChangePasswordEvent()';
}


}

/// @nodoc
class $ChangePasswordEventCopyWith<$Res>  {
$ChangePasswordEventCopyWith(ChangePasswordEvent _, $Res Function(ChangePasswordEvent) __);
}


/// Adds pattern-matching-related methods to [ChangePasswordEvent].
extension ChangePasswordEventPatterns on ChangePasswordEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChangePasswordCurrentChanged value)?  currentPasswordChanged,TResult Function( ChangePasswordNewChanged value)?  newPasswordChanged,TResult Function( ChangePasswordConfirmationChanged value)?  confirmationChanged,TResult Function( ChangePasswordSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChangePasswordCurrentChanged() when currentPasswordChanged != null:
return currentPasswordChanged(_that);case ChangePasswordNewChanged() when newPasswordChanged != null:
return newPasswordChanged(_that);case ChangePasswordConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that);case ChangePasswordSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChangePasswordCurrentChanged value)  currentPasswordChanged,required TResult Function( ChangePasswordNewChanged value)  newPasswordChanged,required TResult Function( ChangePasswordConfirmationChanged value)  confirmationChanged,required TResult Function( ChangePasswordSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case ChangePasswordCurrentChanged():
return currentPasswordChanged(_that);case ChangePasswordNewChanged():
return newPasswordChanged(_that);case ChangePasswordConfirmationChanged():
return confirmationChanged(_that);case ChangePasswordSubmitted():
return submitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChangePasswordCurrentChanged value)?  currentPasswordChanged,TResult? Function( ChangePasswordNewChanged value)?  newPasswordChanged,TResult? Function( ChangePasswordConfirmationChanged value)?  confirmationChanged,TResult? Function( ChangePasswordSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case ChangePasswordCurrentChanged() when currentPasswordChanged != null:
return currentPasswordChanged(_that);case ChangePasswordNewChanged() when newPasswordChanged != null:
return newPasswordChanged(_that);case ChangePasswordConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that);case ChangePasswordSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  currentPasswordChanged,TResult Function( String value)?  newPasswordChanged,TResult Function( String value)?  confirmationChanged,TResult Function()?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChangePasswordCurrentChanged() when currentPasswordChanged != null:
return currentPasswordChanged(_that.value);case ChangePasswordNewChanged() when newPasswordChanged != null:
return newPasswordChanged(_that.value);case ChangePasswordConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that.value);case ChangePasswordSubmitted() when submitted != null:
return submitted();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  currentPasswordChanged,required TResult Function( String value)  newPasswordChanged,required TResult Function( String value)  confirmationChanged,required TResult Function()  submitted,}) {final _that = this;
switch (_that) {
case ChangePasswordCurrentChanged():
return currentPasswordChanged(_that.value);case ChangePasswordNewChanged():
return newPasswordChanged(_that.value);case ChangePasswordConfirmationChanged():
return confirmationChanged(_that.value);case ChangePasswordSubmitted():
return submitted();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  currentPasswordChanged,TResult? Function( String value)?  newPasswordChanged,TResult? Function( String value)?  confirmationChanged,TResult? Function()?  submitted,}) {final _that = this;
switch (_that) {
case ChangePasswordCurrentChanged() when currentPasswordChanged != null:
return currentPasswordChanged(_that.value);case ChangePasswordNewChanged() when newPasswordChanged != null:
return newPasswordChanged(_that.value);case ChangePasswordConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that.value);case ChangePasswordSubmitted() when submitted != null:
return submitted();case _:
  return null;

}
}

}

/// @nodoc


class ChangePasswordCurrentChanged implements ChangePasswordEvent {
  const ChangePasswordCurrentChanged(this.value);
  

 final  String value;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePasswordCurrentChangedCopyWith<ChangePasswordCurrentChanged> get copyWith => _$ChangePasswordCurrentChangedCopyWithImpl<ChangePasswordCurrentChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordCurrentChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'ChangePasswordEvent.currentPasswordChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $ChangePasswordCurrentChangedCopyWith<$Res> implements $ChangePasswordEventCopyWith<$Res> {
  factory $ChangePasswordCurrentChangedCopyWith(ChangePasswordCurrentChanged value, $Res Function(ChangePasswordCurrentChanged) _then) = _$ChangePasswordCurrentChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$ChangePasswordCurrentChangedCopyWithImpl<$Res>
    implements $ChangePasswordCurrentChangedCopyWith<$Res> {
  _$ChangePasswordCurrentChangedCopyWithImpl(this._self, this._then);

  final ChangePasswordCurrentChanged _self;
  final $Res Function(ChangePasswordCurrentChanged) _then;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(ChangePasswordCurrentChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChangePasswordNewChanged implements ChangePasswordEvent {
  const ChangePasswordNewChanged(this.value);
  

 final  String value;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePasswordNewChangedCopyWith<ChangePasswordNewChanged> get copyWith => _$ChangePasswordNewChangedCopyWithImpl<ChangePasswordNewChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordNewChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'ChangePasswordEvent.newPasswordChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $ChangePasswordNewChangedCopyWith<$Res> implements $ChangePasswordEventCopyWith<$Res> {
  factory $ChangePasswordNewChangedCopyWith(ChangePasswordNewChanged value, $Res Function(ChangePasswordNewChanged) _then) = _$ChangePasswordNewChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$ChangePasswordNewChangedCopyWithImpl<$Res>
    implements $ChangePasswordNewChangedCopyWith<$Res> {
  _$ChangePasswordNewChangedCopyWithImpl(this._self, this._then);

  final ChangePasswordNewChanged _self;
  final $Res Function(ChangePasswordNewChanged) _then;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(ChangePasswordNewChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChangePasswordConfirmationChanged implements ChangePasswordEvent {
  const ChangePasswordConfirmationChanged(this.value);
  

 final  String value;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePasswordConfirmationChangedCopyWith<ChangePasswordConfirmationChanged> get copyWith => _$ChangePasswordConfirmationChangedCopyWithImpl<ChangePasswordConfirmationChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordConfirmationChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'ChangePasswordEvent.confirmationChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $ChangePasswordConfirmationChangedCopyWith<$Res> implements $ChangePasswordEventCopyWith<$Res> {
  factory $ChangePasswordConfirmationChangedCopyWith(ChangePasswordConfirmationChanged value, $Res Function(ChangePasswordConfirmationChanged) _then) = _$ChangePasswordConfirmationChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$ChangePasswordConfirmationChangedCopyWithImpl<$Res>
    implements $ChangePasswordConfirmationChangedCopyWith<$Res> {
  _$ChangePasswordConfirmationChangedCopyWithImpl(this._self, this._then);

  final ChangePasswordConfirmationChanged _self;
  final $Res Function(ChangePasswordConfirmationChanged) _then;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(ChangePasswordConfirmationChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChangePasswordSubmitted implements ChangePasswordEvent {
  const ChangePasswordSubmitted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ChangePasswordEvent.submitted()';
}


}




/// @nodoc
mixin _$ChangePasswordState {

/// Kişisel bilgi içeren şifreleri reddetmek için.
 String get email; String get displayName; String get currentPassword; String get newPassword; String get confirmation; bool get showValidationErrors; FormStatus get status; int get invalidSubmissions; Failure? get failure;
/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePasswordStateCopyWith<ChangePasswordState> get copyWith => _$ChangePasswordStateCopyWithImpl<ChangePasswordState>(this as ChangePasswordState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChangePasswordState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordState&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.currentPassword, _this.currentPassword) || other.currentPassword == _this.currentPassword)&&(identical(other.newPassword, _this.newPassword) || other.newPassword == _this.newPassword)&&(identical(other.confirmation, _this.confirmation) || other.confirmation == _this.confirmation)&&(identical(other.showValidationErrors, _this.showValidationErrors) || other.showValidationErrors == _this.showValidationErrors)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.invalidSubmissions, _this.invalidSubmissions) || other.invalidSubmissions == _this.invalidSubmissions)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as ChangePasswordState;
  return Object.hash(runtimeType,_this.email,_this.displayName,_this.currentPassword,_this.newPassword,_this.confirmation,_this.showValidationErrors,_this.status,_this.invalidSubmissions,_this.failure);
}



}

/// @nodoc
abstract mixin class $ChangePasswordStateCopyWith<$Res>  {
  factory $ChangePasswordStateCopyWith(ChangePasswordState value, $Res Function(ChangePasswordState) _then) = _$ChangePasswordStateCopyWithImpl;
@useResult
$Res call({
 String email, String displayName, String currentPassword, String newPassword, String confirmation, bool showValidationErrors, FormStatus status, int invalidSubmissions, Failure? failure
});




}
/// @nodoc
class _$ChangePasswordStateCopyWithImpl<$Res>
    implements $ChangePasswordStateCopyWith<$Res> {
  _$ChangePasswordStateCopyWithImpl(this._self, this._then);

  final ChangePasswordState _self;
  final $Res Function(ChangePasswordState) _then;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? displayName = null,Object? currentPassword = null,Object? newPassword = null,Object? confirmation = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? failure = freezed,}) {
  return _then(ChangePasswordState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,currentPassword: null == currentPassword ? _self.currentPassword : currentPassword // ignore: cast_nullable_to_non_nullable
as String,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,confirmation: null == confirmation ? _self.confirmation : confirmation // ignore: cast_nullable_to_non_nullable
as String,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangePasswordState].
extension ChangePasswordStatePatterns on ChangePasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangePasswordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangePasswordState value)  $default,){
final _that = this;
switch (_that) {
case _ChangePasswordState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangePasswordState value)?  $default,){
final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String displayName,  String currentPassword,  String newPassword,  String confirmation,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
return $default(_that.email,_that.displayName,_that.currentPassword,_that.newPassword,_that.confirmation,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String displayName,  String currentPassword,  String newPassword,  String confirmation,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ChangePasswordState():
return $default(_that.email,_that.displayName,_that.currentPassword,_that.newPassword,_that.confirmation,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String displayName,  String currentPassword,  String newPassword,  String confirmation,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
return $default(_that.email,_that.displayName,_that.currentPassword,_that.newPassword,_that.confirmation,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ChangePasswordState extends ChangePasswordState {
  const _ChangePasswordState({this.email = '', this.displayName = '', this.currentPassword = '', this.newPassword = '', this.confirmation = '', this.showValidationErrors = false, this.status = FormStatus.editing, this.invalidSubmissions = 0, this.failure}): super._();
  

/// Kişisel bilgi içeren şifreleri reddetmek için.
@override@JsonKey() final  String email;
@override@JsonKey() final  String displayName;
@override@JsonKey() final  String currentPassword;
@override@JsonKey() final  String newPassword;
@override@JsonKey() final  String confirmation;
@override@JsonKey() final  bool showValidationErrors;
@override@JsonKey() final  FormStatus status;
@override@JsonKey() final  int invalidSubmissions;
@override final  Failure? failure;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangePasswordStateCopyWith<_ChangePasswordState> get copyWith => __$ChangePasswordStateCopyWithImpl<_ChangePasswordState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangePasswordState&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.currentPassword, currentPassword) || other.currentPassword == currentPassword)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword)&&(identical(other.confirmation, confirmation) || other.confirmation == confirmation)&&(identical(other.showValidationErrors, showValidationErrors) || other.showValidationErrors == showValidationErrors)&&(identical(other.status, status) || other.status == status)&&(identical(other.invalidSubmissions, invalidSubmissions) || other.invalidSubmissions == invalidSubmissions)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email,displayName,currentPassword,newPassword,confirmation,showValidationErrors,status,invalidSubmissions,failure);
}



}

/// @nodoc
abstract mixin class _$ChangePasswordStateCopyWith<$Res> implements $ChangePasswordStateCopyWith<$Res> {
  factory _$ChangePasswordStateCopyWith(_ChangePasswordState value, $Res Function(_ChangePasswordState) _then) = __$ChangePasswordStateCopyWithImpl;
@override @useResult
$Res call({
 String email, String displayName, String currentPassword, String newPassword, String confirmation, bool showValidationErrors, FormStatus status, int invalidSubmissions, Failure? failure
});




}
/// @nodoc
class __$ChangePasswordStateCopyWithImpl<$Res>
    implements _$ChangePasswordStateCopyWith<$Res> {
  __$ChangePasswordStateCopyWithImpl(this._self, this._then);

  final _ChangePasswordState _self;
  final $Res Function(_ChangePasswordState) _then;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? displayName = null,Object? currentPassword = null,Object? newPassword = null,Object? confirmation = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? failure = freezed,}) {
  return _then(_ChangePasswordState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,currentPassword: null == currentPassword ? _self.currentPassword : currentPassword // ignore: cast_nullable_to_non_nullable
as String,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,confirmation: null == confirmation ? _self.confirmation : confirmation // ignore: cast_nullable_to_non_nullable
as String,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

/// @nodoc
mixin _$DeleteAccountEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeleteAccountEvent()';
}


}

/// @nodoc
class $DeleteAccountEventCopyWith<$Res>  {
$DeleteAccountEventCopyWith(DeleteAccountEvent _, $Res Function(DeleteAccountEvent) __);
}


/// Adds pattern-matching-related methods to [DeleteAccountEvent].
extension DeleteAccountEventPatterns on DeleteAccountEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DeleteAccountPasswordChanged value)?  passwordChanged,TResult Function( DeleteAccountConfirmationChanged value)?  confirmationChanged,TResult Function( DeleteAccountSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DeleteAccountPasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case DeleteAccountConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that);case DeleteAccountSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DeleteAccountPasswordChanged value)  passwordChanged,required TResult Function( DeleteAccountConfirmationChanged value)  confirmationChanged,required TResult Function( DeleteAccountSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case DeleteAccountPasswordChanged():
return passwordChanged(_that);case DeleteAccountConfirmationChanged():
return confirmationChanged(_that);case DeleteAccountSubmitted():
return submitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DeleteAccountPasswordChanged value)?  passwordChanged,TResult? Function( DeleteAccountConfirmationChanged value)?  confirmationChanged,TResult? Function( DeleteAccountSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case DeleteAccountPasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case DeleteAccountConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that);case DeleteAccountSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  passwordChanged,TResult Function( bool confirmed)?  confirmationChanged,TResult Function()?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DeleteAccountPasswordChanged() when passwordChanged != null:
return passwordChanged(_that.value);case DeleteAccountConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that.confirmed);case DeleteAccountSubmitted() when submitted != null:
return submitted();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  passwordChanged,required TResult Function( bool confirmed)  confirmationChanged,required TResult Function()  submitted,}) {final _that = this;
switch (_that) {
case DeleteAccountPasswordChanged():
return passwordChanged(_that.value);case DeleteAccountConfirmationChanged():
return confirmationChanged(_that.confirmed);case DeleteAccountSubmitted():
return submitted();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  passwordChanged,TResult? Function( bool confirmed)?  confirmationChanged,TResult? Function()?  submitted,}) {final _that = this;
switch (_that) {
case DeleteAccountPasswordChanged() when passwordChanged != null:
return passwordChanged(_that.value);case DeleteAccountConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that.confirmed);case DeleteAccountSubmitted() when submitted != null:
return submitted();case _:
  return null;

}
}

}

/// @nodoc


class DeleteAccountPasswordChanged implements DeleteAccountEvent {
  const DeleteAccountPasswordChanged(this.value);
  

 final  String value;

/// Create a copy of DeleteAccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteAccountPasswordChangedCopyWith<DeleteAccountPasswordChanged> get copyWith => _$DeleteAccountPasswordChangedCopyWithImpl<DeleteAccountPasswordChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountPasswordChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'DeleteAccountEvent.passwordChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $DeleteAccountPasswordChangedCopyWith<$Res> implements $DeleteAccountEventCopyWith<$Res> {
  factory $DeleteAccountPasswordChangedCopyWith(DeleteAccountPasswordChanged value, $Res Function(DeleteAccountPasswordChanged) _then) = _$DeleteAccountPasswordChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$DeleteAccountPasswordChangedCopyWithImpl<$Res>
    implements $DeleteAccountPasswordChangedCopyWith<$Res> {
  _$DeleteAccountPasswordChangedCopyWithImpl(this._self, this._then);

  final DeleteAccountPasswordChanged _self;
  final $Res Function(DeleteAccountPasswordChanged) _then;

/// Create a copy of DeleteAccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(DeleteAccountPasswordChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DeleteAccountConfirmationChanged implements DeleteAccountEvent {
  const DeleteAccountConfirmationChanged({required this.confirmed});
  

 final  bool confirmed;

/// Create a copy of DeleteAccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteAccountConfirmationChangedCopyWith<DeleteAccountConfirmationChanged> get copyWith => _$DeleteAccountConfirmationChangedCopyWithImpl<DeleteAccountConfirmationChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountConfirmationChanged&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,confirmed);
}

@override
String toString() {
    return 'DeleteAccountEvent.confirmationChanged(confirmed: $confirmed)';
}


}

/// @nodoc
abstract mixin class $DeleteAccountConfirmationChangedCopyWith<$Res> implements $DeleteAccountEventCopyWith<$Res> {
  factory $DeleteAccountConfirmationChangedCopyWith(DeleteAccountConfirmationChanged value, $Res Function(DeleteAccountConfirmationChanged) _then) = _$DeleteAccountConfirmationChangedCopyWithImpl;
@useResult
$Res call({
 bool confirmed
});




}
/// @nodoc
class _$DeleteAccountConfirmationChangedCopyWithImpl<$Res>
    implements $DeleteAccountConfirmationChangedCopyWith<$Res> {
  _$DeleteAccountConfirmationChangedCopyWithImpl(this._self, this._then);

  final DeleteAccountConfirmationChanged _self;
  final $Res Function(DeleteAccountConfirmationChanged) _then;

/// Create a copy of DeleteAccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? confirmed = null,}) {
  return _then(DeleteAccountConfirmationChanged(
confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class DeleteAccountSubmitted implements DeleteAccountEvent {
  const DeleteAccountSubmitted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DeleteAccountEvent.submitted()';
}


}




/// @nodoc
mixin _$DeleteAccountState {

 String get password; bool get confirmed; bool get showValidationErrors; FormStatus get status; int get invalidSubmissions; Failure? get failure;
/// Create a copy of DeleteAccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteAccountStateCopyWith<DeleteAccountState> get copyWith => _$DeleteAccountStateCopyWithImpl<DeleteAccountState>(this as DeleteAccountState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeleteAccountState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountState&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.confirmed, _this.confirmed) || other.confirmed == _this.confirmed)&&(identical(other.showValidationErrors, _this.showValidationErrors) || other.showValidationErrors == _this.showValidationErrors)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.invalidSubmissions, _this.invalidSubmissions) || other.invalidSubmissions == _this.invalidSubmissions)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as DeleteAccountState;
  return Object.hash(runtimeType,_this.password,_this.confirmed,_this.showValidationErrors,_this.status,_this.invalidSubmissions,_this.failure);
}



}

/// @nodoc
abstract mixin class $DeleteAccountStateCopyWith<$Res>  {
  factory $DeleteAccountStateCopyWith(DeleteAccountState value, $Res Function(DeleteAccountState) _then) = _$DeleteAccountStateCopyWithImpl;
@useResult
$Res call({
 String password, bool confirmed, bool showValidationErrors, FormStatus status, int invalidSubmissions, Failure? failure
});




}
/// @nodoc
class _$DeleteAccountStateCopyWithImpl<$Res>
    implements $DeleteAccountStateCopyWith<$Res> {
  _$DeleteAccountStateCopyWithImpl(this._self, this._then);

  final DeleteAccountState _self;
  final $Res Function(DeleteAccountState) _then;

/// Create a copy of DeleteAccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? password = null,Object? confirmed = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? failure = freezed,}) {
  return _then(DeleteAccountState(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as bool,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeleteAccountState].
extension DeleteAccountStatePatterns on DeleteAccountState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeleteAccountState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeleteAccountState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeleteAccountState value)  $default,){
final _that = this;
switch (_that) {
case _DeleteAccountState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeleteAccountState value)?  $default,){
final _that = this;
switch (_that) {
case _DeleteAccountState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String password,  bool confirmed,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeleteAccountState() when $default != null:
return $default(_that.password,_that.confirmed,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String password,  bool confirmed,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _DeleteAccountState():
return $default(_that.password,_that.confirmed,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String password,  bool confirmed,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _DeleteAccountState() when $default != null:
return $default(_that.password,_that.confirmed,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DeleteAccountState extends DeleteAccountState {
  const _DeleteAccountState({this.password = '', this.confirmed = false, this.showValidationErrors = false, this.status = FormStatus.editing, this.invalidSubmissions = 0, this.failure}): super._();
  

@override@JsonKey() final  String password;
@override@JsonKey() final  bool confirmed;
@override@JsonKey() final  bool showValidationErrors;
@override@JsonKey() final  FormStatus status;
@override@JsonKey() final  int invalidSubmissions;
@override final  Failure? failure;

/// Create a copy of DeleteAccountState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteAccountStateCopyWith<_DeleteAccountState> get copyWith => __$DeleteAccountStateCopyWithImpl<_DeleteAccountState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteAccountState&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed)&&(identical(other.showValidationErrors, showValidationErrors) || other.showValidationErrors == showValidationErrors)&&(identical(other.status, status) || other.status == status)&&(identical(other.invalidSubmissions, invalidSubmissions) || other.invalidSubmissions == invalidSubmissions)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,password,confirmed,showValidationErrors,status,invalidSubmissions,failure);
}



}

/// @nodoc
abstract mixin class _$DeleteAccountStateCopyWith<$Res> implements $DeleteAccountStateCopyWith<$Res> {
  factory _$DeleteAccountStateCopyWith(_DeleteAccountState value, $Res Function(_DeleteAccountState) _then) = __$DeleteAccountStateCopyWithImpl;
@override @useResult
$Res call({
 String password, bool confirmed, bool showValidationErrors, FormStatus status, int invalidSubmissions, Failure? failure
});




}
/// @nodoc
class __$DeleteAccountStateCopyWithImpl<$Res>
    implements _$DeleteAccountStateCopyWith<$Res> {
  __$DeleteAccountStateCopyWithImpl(this._self, this._then);

  final _DeleteAccountState _self;
  final $Res Function(_DeleteAccountState) _then;

/// Create a copy of DeleteAccountState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? password = null,Object? confirmed = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? failure = freezed,}) {
  return _then(_DeleteAccountState(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as bool,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

/// @nodoc
mixin _$LegalDocumentState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LegalDocumentState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LegalDocumentState()';
}


}

/// @nodoc
class $LegalDocumentStateCopyWith<$Res>  {
$LegalDocumentStateCopyWith(LegalDocumentState _, $Res Function(LegalDocumentState) __);
}


/// Adds pattern-matching-related methods to [LegalDocumentState].
extension LegalDocumentStatePatterns on LegalDocumentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LegalDocumentLoading value)?  loading,TResult Function( LegalDocumentLoaded value)?  loaded,TResult Function( LegalDocumentFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LegalDocumentLoading() when loading != null:
return loading(_that);case LegalDocumentLoaded() when loaded != null:
return loaded(_that);case LegalDocumentFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LegalDocumentLoading value)  loading,required TResult Function( LegalDocumentLoaded value)  loaded,required TResult Function( LegalDocumentFailure value)  failure,}){
final _that = this;
switch (_that) {
case LegalDocumentLoading():
return loading(_that);case LegalDocumentLoaded():
return loaded(_that);case LegalDocumentFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LegalDocumentLoading value)?  loading,TResult? Function( LegalDocumentLoaded value)?  loaded,TResult? Function( LegalDocumentFailure value)?  failure,}){
final _that = this;
switch (_that) {
case LegalDocumentLoading() when loading != null:
return loading(_that);case LegalDocumentLoaded() when loaded != null:
return loaded(_that);case LegalDocumentFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( LegalDocument document)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LegalDocumentLoading() when loading != null:
return loading();case LegalDocumentLoaded() when loaded != null:
return loaded(_that.document);case LegalDocumentFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( LegalDocument document)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case LegalDocumentLoading():
return loading();case LegalDocumentLoaded():
return loaded(_that.document);case LegalDocumentFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( LegalDocument document)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case LegalDocumentLoading() when loading != null:
return loading();case LegalDocumentLoaded() when loaded != null:
return loaded(_that.document);case LegalDocumentFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class LegalDocumentLoading implements LegalDocumentState {
  const LegalDocumentLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LegalDocumentLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LegalDocumentState.loading()';
}


}




/// @nodoc


class LegalDocumentLoaded implements LegalDocumentState {
  const LegalDocumentLoaded(this.document);
  

 final  LegalDocument document;

/// Create a copy of LegalDocumentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LegalDocumentLoadedCopyWith<LegalDocumentLoaded> get copyWith => _$LegalDocumentLoadedCopyWithImpl<LegalDocumentLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LegalDocumentLoaded&&(identical(other.document, document) || other.document == document));
}


@override
int get hashCode {
    return Object.hash(runtimeType,document);
}

@override
String toString() {
    return 'LegalDocumentState.loaded(document: $document)';
}


}

/// @nodoc
abstract mixin class $LegalDocumentLoadedCopyWith<$Res> implements $LegalDocumentStateCopyWith<$Res> {
  factory $LegalDocumentLoadedCopyWith(LegalDocumentLoaded value, $Res Function(LegalDocumentLoaded) _then) = _$LegalDocumentLoadedCopyWithImpl;
@useResult
$Res call({
 LegalDocument document
});




}
/// @nodoc
class _$LegalDocumentLoadedCopyWithImpl<$Res>
    implements $LegalDocumentLoadedCopyWith<$Res> {
  _$LegalDocumentLoadedCopyWithImpl(this._self, this._then);

  final LegalDocumentLoaded _self;
  final $Res Function(LegalDocumentLoaded) _then;

/// Create a copy of LegalDocumentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? document = null,}) {
  return _then(LegalDocumentLoaded(
null == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as LegalDocument,
  ));
}


}

/// @nodoc


class LegalDocumentFailure implements LegalDocumentState {
  const LegalDocumentFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of LegalDocumentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LegalDocumentFailureCopyWith<LegalDocumentFailure> get copyWith => _$LegalDocumentFailureCopyWithImpl<LegalDocumentFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LegalDocumentFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'LegalDocumentState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $LegalDocumentFailureCopyWith<$Res> implements $LegalDocumentStateCopyWith<$Res> {
  factory $LegalDocumentFailureCopyWith(LegalDocumentFailure value, $Res Function(LegalDocumentFailure) _then) = _$LegalDocumentFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$LegalDocumentFailureCopyWithImpl<$Res>
    implements $LegalDocumentFailureCopyWith<$Res> {
  _$LegalDocumentFailureCopyWithImpl(this._self, this._then);

  final LegalDocumentFailure _self;
  final $Res Function(LegalDocumentFailure) _then;

/// Create a copy of LegalDocumentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(LegalDocumentFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
