// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VerifyEmailEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyEmailEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'VerifyEmailEvent()';
}


}

/// @nodoc
class $VerifyEmailEventCopyWith<$Res>  {
$VerifyEmailEventCopyWith(VerifyEmailEvent _, $Res Function(VerifyEmailEvent) __);
}


/// Adds pattern-matching-related methods to [VerifyEmailEvent].
extension VerifyEmailEventPatterns on VerifyEmailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( VerifyEmailCodeChanged value)?  codeChanged,TResult Function( VerifyEmailSubmitted value)?  submitted,TResult Function( VerifyEmailResendRequested value)?  resendRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case VerifyEmailCodeChanged() when codeChanged != null:
return codeChanged(_that);case VerifyEmailSubmitted() when submitted != null:
return submitted(_that);case VerifyEmailResendRequested() when resendRequested != null:
return resendRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( VerifyEmailCodeChanged value)  codeChanged,required TResult Function( VerifyEmailSubmitted value)  submitted,required TResult Function( VerifyEmailResendRequested value)  resendRequested,}){
final _that = this;
switch (_that) {
case VerifyEmailCodeChanged():
return codeChanged(_that);case VerifyEmailSubmitted():
return submitted(_that);case VerifyEmailResendRequested():
return resendRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( VerifyEmailCodeChanged value)?  codeChanged,TResult? Function( VerifyEmailSubmitted value)?  submitted,TResult? Function( VerifyEmailResendRequested value)?  resendRequested,}){
final _that = this;
switch (_that) {
case VerifyEmailCodeChanged() when codeChanged != null:
return codeChanged(_that);case VerifyEmailSubmitted() when submitted != null:
return submitted(_that);case VerifyEmailResendRequested() when resendRequested != null:
return resendRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  codeChanged,TResult Function()?  submitted,TResult Function()?  resendRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case VerifyEmailCodeChanged() when codeChanged != null:
return codeChanged(_that.value);case VerifyEmailSubmitted() when submitted != null:
return submitted();case VerifyEmailResendRequested() when resendRequested != null:
return resendRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  codeChanged,required TResult Function()  submitted,required TResult Function()  resendRequested,}) {final _that = this;
switch (_that) {
case VerifyEmailCodeChanged():
return codeChanged(_that.value);case VerifyEmailSubmitted():
return submitted();case VerifyEmailResendRequested():
return resendRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  codeChanged,TResult? Function()?  submitted,TResult? Function()?  resendRequested,}) {final _that = this;
switch (_that) {
case VerifyEmailCodeChanged() when codeChanged != null:
return codeChanged(_that.value);case VerifyEmailSubmitted() when submitted != null:
return submitted();case VerifyEmailResendRequested() when resendRequested != null:
return resendRequested();case _:
  return null;

}
}

}

/// @nodoc


class VerifyEmailCodeChanged implements VerifyEmailEvent {
  const VerifyEmailCodeChanged(this.value);
  

 final  String value;

/// Create a copy of VerifyEmailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyEmailCodeChangedCopyWith<VerifyEmailCodeChanged> get copyWith => _$VerifyEmailCodeChangedCopyWithImpl<VerifyEmailCodeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyEmailCodeChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'VerifyEmailEvent.codeChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $VerifyEmailCodeChangedCopyWith<$Res> implements $VerifyEmailEventCopyWith<$Res> {
  factory $VerifyEmailCodeChangedCopyWith(VerifyEmailCodeChanged value, $Res Function(VerifyEmailCodeChanged) _then) = _$VerifyEmailCodeChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$VerifyEmailCodeChangedCopyWithImpl<$Res>
    implements $VerifyEmailCodeChangedCopyWith<$Res> {
  _$VerifyEmailCodeChangedCopyWithImpl(this._self, this._then);

  final VerifyEmailCodeChanged _self;
  final $Res Function(VerifyEmailCodeChanged) _then;

/// Create a copy of VerifyEmailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(VerifyEmailCodeChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class VerifyEmailSubmitted implements VerifyEmailEvent {
  const VerifyEmailSubmitted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyEmailSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'VerifyEmailEvent.submitted()';
}


}




/// @nodoc


class VerifyEmailResendRequested implements VerifyEmailEvent {
  const VerifyEmailResendRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyEmailResendRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'VerifyEmailEvent.resendRequested()';
}


}




/// @nodoc
mixin _$VerifyEmailState {

 String get email; String get code; bool get showValidationErrors; FormStatus get status; int get invalidSubmissions; ResendStatus get resendStatus;/// Her yeniden gönderim denemesinin sonucunda artar (dinleyiciler için).
 int get resendAttempts;/// Sunucunun bildirdiği yeni bekleme süresi.
 Duration? get cooldown; Failure? get failure; UserEntity? get user;
/// Create a copy of VerifyEmailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyEmailStateCopyWith<VerifyEmailState> get copyWith => _$VerifyEmailStateCopyWithImpl<VerifyEmailState>(this as VerifyEmailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VerifyEmailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyEmailState&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.showValidationErrors, _this.showValidationErrors) || other.showValidationErrors == _this.showValidationErrors)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.invalidSubmissions, _this.invalidSubmissions) || other.invalidSubmissions == _this.invalidSubmissions)&&(identical(other.resendStatus, _this.resendStatus) || other.resendStatus == _this.resendStatus)&&(identical(other.resendAttempts, _this.resendAttempts) || other.resendAttempts == _this.resendAttempts)&&(identical(other.cooldown, _this.cooldown) || other.cooldown == _this.cooldown)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.user, _this.user) || other.user == _this.user));
}


@override
int get hashCode {
  final _this = this as VerifyEmailState;
  return Object.hash(runtimeType,_this.email,_this.code,_this.showValidationErrors,_this.status,_this.invalidSubmissions,_this.resendStatus,_this.resendAttempts,_this.cooldown,_this.failure,_this.user);
}



}

/// @nodoc
abstract mixin class $VerifyEmailStateCopyWith<$Res>  {
  factory $VerifyEmailStateCopyWith(VerifyEmailState value, $Res Function(VerifyEmailState) _then) = _$VerifyEmailStateCopyWithImpl;
@useResult
$Res call({
 String email, String code, bool showValidationErrors, FormStatus status, int invalidSubmissions, ResendStatus resendStatus, int resendAttempts, Duration? cooldown, Failure? failure, UserEntity? user
});




}
/// @nodoc
class _$VerifyEmailStateCopyWithImpl<$Res>
    implements $VerifyEmailStateCopyWith<$Res> {
  _$VerifyEmailStateCopyWithImpl(this._self, this._then);

  final VerifyEmailState _self;
  final $Res Function(VerifyEmailState) _then;

/// Create a copy of VerifyEmailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? code = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? resendStatus = null,Object? resendAttempts = null,Object? cooldown = freezed,Object? failure = freezed,Object? user = freezed,}) {
  return _then(VerifyEmailState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,resendStatus: null == resendStatus ? _self.resendStatus : resendStatus // ignore: cast_nullable_to_non_nullable
as ResendStatus,resendAttempts: null == resendAttempts ? _self.resendAttempts : resendAttempts // ignore: cast_nullable_to_non_nullable
as int,cooldown: freezed == cooldown ? _self.cooldown : cooldown // ignore: cast_nullable_to_non_nullable
as Duration?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity?,
  ));
}

}


/// Adds pattern-matching-related methods to [VerifyEmailState].
extension VerifyEmailStatePatterns on VerifyEmailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerifyEmailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerifyEmailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerifyEmailState value)  $default,){
final _that = this;
switch (_that) {
case _VerifyEmailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerifyEmailState value)?  $default,){
final _that = this;
switch (_that) {
case _VerifyEmailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String code,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  ResendStatus resendStatus,  int resendAttempts,  Duration? cooldown,  Failure? failure,  UserEntity? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerifyEmailState() when $default != null:
return $default(_that.email,_that.code,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.resendStatus,_that.resendAttempts,_that.cooldown,_that.failure,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String code,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  ResendStatus resendStatus,  int resendAttempts,  Duration? cooldown,  Failure? failure,  UserEntity? user)  $default,) {final _that = this;
switch (_that) {
case _VerifyEmailState():
return $default(_that.email,_that.code,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.resendStatus,_that.resendAttempts,_that.cooldown,_that.failure,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String code,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  ResendStatus resendStatus,  int resendAttempts,  Duration? cooldown,  Failure? failure,  UserEntity? user)?  $default,) {final _that = this;
switch (_that) {
case _VerifyEmailState() when $default != null:
return $default(_that.email,_that.code,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.resendStatus,_that.resendAttempts,_that.cooldown,_that.failure,_that.user);case _:
  return null;

}
}

}

/// @nodoc


class _VerifyEmailState extends VerifyEmailState {
  const _VerifyEmailState({required this.email, this.code = '', this.showValidationErrors = false, this.status = FormStatus.editing, this.invalidSubmissions = 0, this.resendStatus = ResendStatus.idle, this.resendAttempts = 0, this.cooldown, this.failure, this.user}): super._();
  

@override final  String email;
@override@JsonKey() final  String code;
@override@JsonKey() final  bool showValidationErrors;
@override@JsonKey() final  FormStatus status;
@override@JsonKey() final  int invalidSubmissions;
@override@JsonKey() final  ResendStatus resendStatus;
/// Her yeniden gönderim denemesinin sonucunda artar (dinleyiciler için).
@override@JsonKey() final  int resendAttempts;
/// Sunucunun bildirdiği yeni bekleme süresi.
@override final  Duration? cooldown;
@override final  Failure? failure;
@override final  UserEntity? user;

/// Create a copy of VerifyEmailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyEmailStateCopyWith<_VerifyEmailState> get copyWith => __$VerifyEmailStateCopyWithImpl<_VerifyEmailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyEmailState&&(identical(other.email, email) || other.email == email)&&(identical(other.code, code) || other.code == code)&&(identical(other.showValidationErrors, showValidationErrors) || other.showValidationErrors == showValidationErrors)&&(identical(other.status, status) || other.status == status)&&(identical(other.invalidSubmissions, invalidSubmissions) || other.invalidSubmissions == invalidSubmissions)&&(identical(other.resendStatus, resendStatus) || other.resendStatus == resendStatus)&&(identical(other.resendAttempts, resendAttempts) || other.resendAttempts == resendAttempts)&&(identical(other.cooldown, cooldown) || other.cooldown == cooldown)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email,code,showValidationErrors,status,invalidSubmissions,resendStatus,resendAttempts,cooldown,failure,user);
}



}

/// @nodoc
abstract mixin class _$VerifyEmailStateCopyWith<$Res> implements $VerifyEmailStateCopyWith<$Res> {
  factory _$VerifyEmailStateCopyWith(_VerifyEmailState value, $Res Function(_VerifyEmailState) _then) = __$VerifyEmailStateCopyWithImpl;
@override @useResult
$Res call({
 String email, String code, bool showValidationErrors, FormStatus status, int invalidSubmissions, ResendStatus resendStatus, int resendAttempts, Duration? cooldown, Failure? failure, UserEntity? user
});




}
/// @nodoc
class __$VerifyEmailStateCopyWithImpl<$Res>
    implements _$VerifyEmailStateCopyWith<$Res> {
  __$VerifyEmailStateCopyWithImpl(this._self, this._then);

  final _VerifyEmailState _self;
  final $Res Function(_VerifyEmailState) _then;

/// Create a copy of VerifyEmailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? code = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? resendStatus = null,Object? resendAttempts = null,Object? cooldown = freezed,Object? failure = freezed,Object? user = freezed,}) {
  return _then(_VerifyEmailState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,resendStatus: null == resendStatus ? _self.resendStatus : resendStatus // ignore: cast_nullable_to_non_nullable
as ResendStatus,resendAttempts: null == resendAttempts ? _self.resendAttempts : resendAttempts // ignore: cast_nullable_to_non_nullable
as int,cooldown: freezed == cooldown ? _self.cooldown : cooldown // ignore: cast_nullable_to_non_nullable
as Duration?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity?,
  ));
}


}

/// @nodoc
mixin _$ResetPasswordEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ResetPasswordEvent()';
}


}

/// @nodoc
class $ResetPasswordEventCopyWith<$Res>  {
$ResetPasswordEventCopyWith(ResetPasswordEvent _, $Res Function(ResetPasswordEvent) __);
}


/// Adds pattern-matching-related methods to [ResetPasswordEvent].
extension ResetPasswordEventPatterns on ResetPasswordEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ResetPasswordCodeChanged value)?  codeChanged,TResult Function( ResetPasswordPasswordChanged value)?  passwordChanged,TResult Function( ResetPasswordConfirmationChanged value)?  confirmationChanged,TResult Function( ResetPasswordSubmitted value)?  submitted,TResult Function( ResetPasswordResendRequested value)?  resendRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ResetPasswordCodeChanged() when codeChanged != null:
return codeChanged(_that);case ResetPasswordPasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case ResetPasswordConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that);case ResetPasswordSubmitted() when submitted != null:
return submitted(_that);case ResetPasswordResendRequested() when resendRequested != null:
return resendRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ResetPasswordCodeChanged value)  codeChanged,required TResult Function( ResetPasswordPasswordChanged value)  passwordChanged,required TResult Function( ResetPasswordConfirmationChanged value)  confirmationChanged,required TResult Function( ResetPasswordSubmitted value)  submitted,required TResult Function( ResetPasswordResendRequested value)  resendRequested,}){
final _that = this;
switch (_that) {
case ResetPasswordCodeChanged():
return codeChanged(_that);case ResetPasswordPasswordChanged():
return passwordChanged(_that);case ResetPasswordConfirmationChanged():
return confirmationChanged(_that);case ResetPasswordSubmitted():
return submitted(_that);case ResetPasswordResendRequested():
return resendRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ResetPasswordCodeChanged value)?  codeChanged,TResult? Function( ResetPasswordPasswordChanged value)?  passwordChanged,TResult? Function( ResetPasswordConfirmationChanged value)?  confirmationChanged,TResult? Function( ResetPasswordSubmitted value)?  submitted,TResult? Function( ResetPasswordResendRequested value)?  resendRequested,}){
final _that = this;
switch (_that) {
case ResetPasswordCodeChanged() when codeChanged != null:
return codeChanged(_that);case ResetPasswordPasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case ResetPasswordConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that);case ResetPasswordSubmitted() when submitted != null:
return submitted(_that);case ResetPasswordResendRequested() when resendRequested != null:
return resendRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  codeChanged,TResult Function( String value)?  passwordChanged,TResult Function( String value)?  confirmationChanged,TResult Function()?  submitted,TResult Function()?  resendRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ResetPasswordCodeChanged() when codeChanged != null:
return codeChanged(_that.value);case ResetPasswordPasswordChanged() when passwordChanged != null:
return passwordChanged(_that.value);case ResetPasswordConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that.value);case ResetPasswordSubmitted() when submitted != null:
return submitted();case ResetPasswordResendRequested() when resendRequested != null:
return resendRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  codeChanged,required TResult Function( String value)  passwordChanged,required TResult Function( String value)  confirmationChanged,required TResult Function()  submitted,required TResult Function()  resendRequested,}) {final _that = this;
switch (_that) {
case ResetPasswordCodeChanged():
return codeChanged(_that.value);case ResetPasswordPasswordChanged():
return passwordChanged(_that.value);case ResetPasswordConfirmationChanged():
return confirmationChanged(_that.value);case ResetPasswordSubmitted():
return submitted();case ResetPasswordResendRequested():
return resendRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  codeChanged,TResult? Function( String value)?  passwordChanged,TResult? Function( String value)?  confirmationChanged,TResult? Function()?  submitted,TResult? Function()?  resendRequested,}) {final _that = this;
switch (_that) {
case ResetPasswordCodeChanged() when codeChanged != null:
return codeChanged(_that.value);case ResetPasswordPasswordChanged() when passwordChanged != null:
return passwordChanged(_that.value);case ResetPasswordConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that.value);case ResetPasswordSubmitted() when submitted != null:
return submitted();case ResetPasswordResendRequested() when resendRequested != null:
return resendRequested();case _:
  return null;

}
}

}

/// @nodoc


class ResetPasswordCodeChanged implements ResetPasswordEvent {
  const ResetPasswordCodeChanged(this.value);
  

 final  String value;

/// Create a copy of ResetPasswordEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetPasswordCodeChangedCopyWith<ResetPasswordCodeChanged> get copyWith => _$ResetPasswordCodeChangedCopyWithImpl<ResetPasswordCodeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordCodeChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'ResetPasswordEvent.codeChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $ResetPasswordCodeChangedCopyWith<$Res> implements $ResetPasswordEventCopyWith<$Res> {
  factory $ResetPasswordCodeChangedCopyWith(ResetPasswordCodeChanged value, $Res Function(ResetPasswordCodeChanged) _then) = _$ResetPasswordCodeChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$ResetPasswordCodeChangedCopyWithImpl<$Res>
    implements $ResetPasswordCodeChangedCopyWith<$Res> {
  _$ResetPasswordCodeChangedCopyWithImpl(this._self, this._then);

  final ResetPasswordCodeChanged _self;
  final $Res Function(ResetPasswordCodeChanged) _then;

/// Create a copy of ResetPasswordEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(ResetPasswordCodeChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ResetPasswordPasswordChanged implements ResetPasswordEvent {
  const ResetPasswordPasswordChanged(this.value);
  

 final  String value;

/// Create a copy of ResetPasswordEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetPasswordPasswordChangedCopyWith<ResetPasswordPasswordChanged> get copyWith => _$ResetPasswordPasswordChangedCopyWithImpl<ResetPasswordPasswordChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordPasswordChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'ResetPasswordEvent.passwordChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $ResetPasswordPasswordChangedCopyWith<$Res> implements $ResetPasswordEventCopyWith<$Res> {
  factory $ResetPasswordPasswordChangedCopyWith(ResetPasswordPasswordChanged value, $Res Function(ResetPasswordPasswordChanged) _then) = _$ResetPasswordPasswordChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$ResetPasswordPasswordChangedCopyWithImpl<$Res>
    implements $ResetPasswordPasswordChangedCopyWith<$Res> {
  _$ResetPasswordPasswordChangedCopyWithImpl(this._self, this._then);

  final ResetPasswordPasswordChanged _self;
  final $Res Function(ResetPasswordPasswordChanged) _then;

/// Create a copy of ResetPasswordEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(ResetPasswordPasswordChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ResetPasswordConfirmationChanged implements ResetPasswordEvent {
  const ResetPasswordConfirmationChanged(this.value);
  

 final  String value;

/// Create a copy of ResetPasswordEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetPasswordConfirmationChangedCopyWith<ResetPasswordConfirmationChanged> get copyWith => _$ResetPasswordConfirmationChangedCopyWithImpl<ResetPasswordConfirmationChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordConfirmationChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'ResetPasswordEvent.confirmationChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $ResetPasswordConfirmationChangedCopyWith<$Res> implements $ResetPasswordEventCopyWith<$Res> {
  factory $ResetPasswordConfirmationChangedCopyWith(ResetPasswordConfirmationChanged value, $Res Function(ResetPasswordConfirmationChanged) _then) = _$ResetPasswordConfirmationChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$ResetPasswordConfirmationChangedCopyWithImpl<$Res>
    implements $ResetPasswordConfirmationChangedCopyWith<$Res> {
  _$ResetPasswordConfirmationChangedCopyWithImpl(this._self, this._then);

  final ResetPasswordConfirmationChanged _self;
  final $Res Function(ResetPasswordConfirmationChanged) _then;

/// Create a copy of ResetPasswordEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(ResetPasswordConfirmationChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ResetPasswordSubmitted implements ResetPasswordEvent {
  const ResetPasswordSubmitted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ResetPasswordEvent.submitted()';
}


}




/// @nodoc


class ResetPasswordResendRequested implements ResetPasswordEvent {
  const ResetPasswordResendRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordResendRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ResetPasswordEvent.resendRequested()';
}


}




/// @nodoc
mixin _$ResetPasswordState {

 String get email; String get code; String get password; String get confirmation; bool get showValidationErrors; FormStatus get status; int get invalidSubmissions; ResendStatus get resendStatus; int get resendAttempts; Duration? get cooldown; Failure? get failure;
/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetPasswordStateCopyWith<ResetPasswordState> get copyWith => _$ResetPasswordStateCopyWithImpl<ResetPasswordState>(this as ResetPasswordState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ResetPasswordState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordState&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.confirmation, _this.confirmation) || other.confirmation == _this.confirmation)&&(identical(other.showValidationErrors, _this.showValidationErrors) || other.showValidationErrors == _this.showValidationErrors)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.invalidSubmissions, _this.invalidSubmissions) || other.invalidSubmissions == _this.invalidSubmissions)&&(identical(other.resendStatus, _this.resendStatus) || other.resendStatus == _this.resendStatus)&&(identical(other.resendAttempts, _this.resendAttempts) || other.resendAttempts == _this.resendAttempts)&&(identical(other.cooldown, _this.cooldown) || other.cooldown == _this.cooldown)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as ResetPasswordState;
  return Object.hash(runtimeType,_this.email,_this.code,_this.password,_this.confirmation,_this.showValidationErrors,_this.status,_this.invalidSubmissions,_this.resendStatus,_this.resendAttempts,_this.cooldown,_this.failure);
}



}

/// @nodoc
abstract mixin class $ResetPasswordStateCopyWith<$Res>  {
  factory $ResetPasswordStateCopyWith(ResetPasswordState value, $Res Function(ResetPasswordState) _then) = _$ResetPasswordStateCopyWithImpl;
@useResult
$Res call({
 String email, String code, String password, String confirmation, bool showValidationErrors, FormStatus status, int invalidSubmissions, ResendStatus resendStatus, int resendAttempts, Duration? cooldown, Failure? failure
});




}
/// @nodoc
class _$ResetPasswordStateCopyWithImpl<$Res>
    implements $ResetPasswordStateCopyWith<$Res> {
  _$ResetPasswordStateCopyWithImpl(this._self, this._then);

  final ResetPasswordState _self;
  final $Res Function(ResetPasswordState) _then;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? code = null,Object? password = null,Object? confirmation = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? resendStatus = null,Object? resendAttempts = null,Object? cooldown = freezed,Object? failure = freezed,}) {
  return _then(ResetPasswordState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmation: null == confirmation ? _self.confirmation : confirmation // ignore: cast_nullable_to_non_nullable
as String,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,resendStatus: null == resendStatus ? _self.resendStatus : resendStatus // ignore: cast_nullable_to_non_nullable
as ResendStatus,resendAttempts: null == resendAttempts ? _self.resendAttempts : resendAttempts // ignore: cast_nullable_to_non_nullable
as int,cooldown: freezed == cooldown ? _self.cooldown : cooldown // ignore: cast_nullable_to_non_nullable
as Duration?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResetPasswordState].
extension ResetPasswordStatePatterns on ResetPasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResetPasswordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResetPasswordState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResetPasswordState value)  $default,){
final _that = this;
switch (_that) {
case _ResetPasswordState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResetPasswordState value)?  $default,){
final _that = this;
switch (_that) {
case _ResetPasswordState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String code,  String password,  String confirmation,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  ResendStatus resendStatus,  int resendAttempts,  Duration? cooldown,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResetPasswordState() when $default != null:
return $default(_that.email,_that.code,_that.password,_that.confirmation,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.resendStatus,_that.resendAttempts,_that.cooldown,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String code,  String password,  String confirmation,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  ResendStatus resendStatus,  int resendAttempts,  Duration? cooldown,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ResetPasswordState():
return $default(_that.email,_that.code,_that.password,_that.confirmation,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.resendStatus,_that.resendAttempts,_that.cooldown,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String code,  String password,  String confirmation,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  ResendStatus resendStatus,  int resendAttempts,  Duration? cooldown,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ResetPasswordState() when $default != null:
return $default(_that.email,_that.code,_that.password,_that.confirmation,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.resendStatus,_that.resendAttempts,_that.cooldown,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ResetPasswordState extends ResetPasswordState {
  const _ResetPasswordState({required this.email, this.code = '', this.password = '', this.confirmation = '', this.showValidationErrors = false, this.status = FormStatus.editing, this.invalidSubmissions = 0, this.resendStatus = ResendStatus.idle, this.resendAttempts = 0, this.cooldown, this.failure}): super._();
  

@override final  String email;
@override@JsonKey() final  String code;
@override@JsonKey() final  String password;
@override@JsonKey() final  String confirmation;
@override@JsonKey() final  bool showValidationErrors;
@override@JsonKey() final  FormStatus status;
@override@JsonKey() final  int invalidSubmissions;
@override@JsonKey() final  ResendStatus resendStatus;
@override@JsonKey() final  int resendAttempts;
@override final  Duration? cooldown;
@override final  Failure? failure;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResetPasswordStateCopyWith<_ResetPasswordState> get copyWith => __$ResetPasswordStateCopyWithImpl<_ResetPasswordState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetPasswordState&&(identical(other.email, email) || other.email == email)&&(identical(other.code, code) || other.code == code)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmation, confirmation) || other.confirmation == confirmation)&&(identical(other.showValidationErrors, showValidationErrors) || other.showValidationErrors == showValidationErrors)&&(identical(other.status, status) || other.status == status)&&(identical(other.invalidSubmissions, invalidSubmissions) || other.invalidSubmissions == invalidSubmissions)&&(identical(other.resendStatus, resendStatus) || other.resendStatus == resendStatus)&&(identical(other.resendAttempts, resendAttempts) || other.resendAttempts == resendAttempts)&&(identical(other.cooldown, cooldown) || other.cooldown == cooldown)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email,code,password,confirmation,showValidationErrors,status,invalidSubmissions,resendStatus,resendAttempts,cooldown,failure);
}



}

/// @nodoc
abstract mixin class _$ResetPasswordStateCopyWith<$Res> implements $ResetPasswordStateCopyWith<$Res> {
  factory _$ResetPasswordStateCopyWith(_ResetPasswordState value, $Res Function(_ResetPasswordState) _then) = __$ResetPasswordStateCopyWithImpl;
@override @useResult
$Res call({
 String email, String code, String password, String confirmation, bool showValidationErrors, FormStatus status, int invalidSubmissions, ResendStatus resendStatus, int resendAttempts, Duration? cooldown, Failure? failure
});




}
/// @nodoc
class __$ResetPasswordStateCopyWithImpl<$Res>
    implements _$ResetPasswordStateCopyWith<$Res> {
  __$ResetPasswordStateCopyWithImpl(this._self, this._then);

  final _ResetPasswordState _self;
  final $Res Function(_ResetPasswordState) _then;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? code = null,Object? password = null,Object? confirmation = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? resendStatus = null,Object? resendAttempts = null,Object? cooldown = freezed,Object? failure = freezed,}) {
  return _then(_ResetPasswordState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmation: null == confirmation ? _self.confirmation : confirmation // ignore: cast_nullable_to_non_nullable
as String,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,resendStatus: null == resendStatus ? _self.resendStatus : resendStatus // ignore: cast_nullable_to_non_nullable
as ResendStatus,resendAttempts: null == resendAttempts ? _self.resendAttempts : resendAttempts // ignore: cast_nullable_to_non_nullable
as int,cooldown: freezed == cooldown ? _self.cooldown : cooldown // ignore: cast_nullable_to_non_nullable
as Duration?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
