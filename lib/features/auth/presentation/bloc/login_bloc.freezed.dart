// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LoginEvent()';
}


}

/// @nodoc
class $LoginEventCopyWith<$Res>  {
$LoginEventCopyWith(LoginEvent _, $Res Function(LoginEvent) __);
}


/// Adds pattern-matching-related methods to [LoginEvent].
extension LoginEventPatterns on LoginEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoginEmailChanged value)?  emailChanged,TResult Function( LoginPasswordChanged value)?  passwordChanged,TResult Function( LoginSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoginEmailChanged() when emailChanged != null:
return emailChanged(_that);case LoginPasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case LoginSubmitted() when submitted != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoginEmailChanged value)  emailChanged,required TResult Function( LoginPasswordChanged value)  passwordChanged,required TResult Function( LoginSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case LoginEmailChanged():
return emailChanged(_that);case LoginPasswordChanged():
return passwordChanged(_that);case LoginSubmitted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoginEmailChanged value)?  emailChanged,TResult? Function( LoginPasswordChanged value)?  passwordChanged,TResult? Function( LoginSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case LoginEmailChanged() when emailChanged != null:
return emailChanged(_that);case LoginPasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case LoginSubmitted() when submitted != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String email)?  emailChanged,TResult Function( String password)?  passwordChanged,TResult Function()?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoginEmailChanged() when emailChanged != null:
return emailChanged(_that.email);case LoginPasswordChanged() when passwordChanged != null:
return passwordChanged(_that.password);case LoginSubmitted() when submitted != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String email)  emailChanged,required TResult Function( String password)  passwordChanged,required TResult Function()  submitted,}) {final _that = this;
switch (_that) {
case LoginEmailChanged():
return emailChanged(_that.email);case LoginPasswordChanged():
return passwordChanged(_that.password);case LoginSubmitted():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String email)?  emailChanged,TResult? Function( String password)?  passwordChanged,TResult? Function()?  submitted,}) {final _that = this;
switch (_that) {
case LoginEmailChanged() when emailChanged != null:
return emailChanged(_that.email);case LoginPasswordChanged() when passwordChanged != null:
return passwordChanged(_that.password);case LoginSubmitted() when submitted != null:
return submitted();case _:
  return null;

}
}

}

/// @nodoc


class LoginEmailChanged implements LoginEvent {
  const LoginEmailChanged(this.email);
  

 final  String email;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginEmailChangedCopyWith<LoginEmailChanged> get copyWith => _$LoginEmailChangedCopyWithImpl<LoginEmailChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginEmailChanged&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email);
}

@override
String toString() {
    return 'LoginEvent.emailChanged(email: $email)';
}


}

/// @nodoc
abstract mixin class $LoginEmailChangedCopyWith<$Res> implements $LoginEventCopyWith<$Res> {
  factory $LoginEmailChangedCopyWith(LoginEmailChanged value, $Res Function(LoginEmailChanged) _then) = _$LoginEmailChangedCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$LoginEmailChangedCopyWithImpl<$Res>
    implements $LoginEmailChangedCopyWith<$Res> {
  _$LoginEmailChangedCopyWithImpl(this._self, this._then);

  final LoginEmailChanged _self;
  final $Res Function(LoginEmailChanged) _then;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(LoginEmailChanged(
null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoginPasswordChanged implements LoginEvent {
  const LoginPasswordChanged(this.password);
  

 final  String password;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginPasswordChangedCopyWith<LoginPasswordChanged> get copyWith => _$LoginPasswordChangedCopyWithImpl<LoginPasswordChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginPasswordChanged&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode {
    return Object.hash(runtimeType,password);
}

@override
String toString() {
    return 'LoginEvent.passwordChanged(password: $password)';
}


}

/// @nodoc
abstract mixin class $LoginPasswordChangedCopyWith<$Res> implements $LoginEventCopyWith<$Res> {
  factory $LoginPasswordChangedCopyWith(LoginPasswordChanged value, $Res Function(LoginPasswordChanged) _then) = _$LoginPasswordChangedCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class _$LoginPasswordChangedCopyWithImpl<$Res>
    implements $LoginPasswordChangedCopyWith<$Res> {
  _$LoginPasswordChangedCopyWithImpl(this._self, this._then);

  final LoginPasswordChanged _self;
  final $Res Function(LoginPasswordChanged) _then;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(LoginPasswordChanged(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoginSubmitted implements LoginEvent {
  const LoginSubmitted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LoginEvent.submitted()';
}


}




/// @nodoc
mixin _$LoginState {

 String get email; String get password;/// İlk gönderim denemesinden sonra alan hataları gösterilir.
 bool get showValidationErrors; LoginStatus get status;/// Geçersiz her gönderimde artar; aynı hatanın tekrar duyurulmasını sağlar.
 int get invalidSubmissions; Failure? get failure; UserEntity? get user;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LoginState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.showValidationErrors, _this.showValidationErrors) || other.showValidationErrors == _this.showValidationErrors)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.invalidSubmissions, _this.invalidSubmissions) || other.invalidSubmissions == _this.invalidSubmissions)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.user, _this.user) || other.user == _this.user));
}


@override
int get hashCode {
  final _this = this as LoginState;
  return Object.hash(runtimeType,_this.email,_this.password,_this.showValidationErrors,_this.status,_this.invalidSubmissions,_this.failure,_this.user);
}



}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 String email, String password, bool showValidationErrors, LoginStatus status, int invalidSubmissions, Failure? failure, UserEntity? user
});




}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? failure = freezed,Object? user = freezed,}) {
  return _then(LoginState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoginStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginState value)  $default,){
final _that = this;
switch (_that) {
case _LoginState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String password,  bool showValidationErrors,  LoginStatus status,  int invalidSubmissions,  Failure? failure,  UserEntity? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.email,_that.password,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String password,  bool showValidationErrors,  LoginStatus status,  int invalidSubmissions,  Failure? failure,  UserEntity? user)  $default,) {final _that = this;
switch (_that) {
case _LoginState():
return $default(_that.email,_that.password,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String password,  bool showValidationErrors,  LoginStatus status,  int invalidSubmissions,  Failure? failure,  UserEntity? user)?  $default,) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.email,_that.password,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure,_that.user);case _:
  return null;

}
}

}

/// @nodoc


class _LoginState extends LoginState {
  const _LoginState({this.email = '', this.password = '', this.showValidationErrors = false, this.status = LoginStatus.editing, this.invalidSubmissions = 0, this.failure, this.user}): super._();
  

@override@JsonKey() final  String email;
@override@JsonKey() final  String password;
/// İlk gönderim denemesinden sonra alan hataları gösterilir.
@override@JsonKey() final  bool showValidationErrors;
@override@JsonKey() final  LoginStatus status;
/// Geçersiz her gönderimde artar; aynı hatanın tekrar duyurulmasını sağlar.
@override@JsonKey() final  int invalidSubmissions;
@override final  Failure? failure;
@override final  UserEntity? user;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.showValidationErrors, showValidationErrors) || other.showValidationErrors == showValidationErrors)&&(identical(other.status, status) || other.status == status)&&(identical(other.invalidSubmissions, invalidSubmissions) || other.invalidSubmissions == invalidSubmissions)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email,password,showValidationErrors,status,invalidSubmissions,failure,user);
}



}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 String email, String password, bool showValidationErrors, LoginStatus status, int invalidSubmissions, Failure? failure, UserEntity? user
});




}
/// @nodoc
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? failure = freezed,Object? user = freezed,}) {
  return _then(_LoginState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoginStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity?,
  ));
}


}

// dart format on
