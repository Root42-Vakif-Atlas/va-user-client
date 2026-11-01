// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegisterEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RegisterEvent()';
}


}

/// @nodoc
class $RegisterEventCopyWith<$Res>  {
$RegisterEventCopyWith(RegisterEvent _, $Res Function(RegisterEvent) __);
}


/// Adds pattern-matching-related methods to [RegisterEvent].
extension RegisterEventPatterns on RegisterEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RegisterDisplayNameChanged value)?  displayNameChanged,TResult Function( RegisterEmailChanged value)?  emailChanged,TResult Function( RegisterPasswordChanged value)?  passwordChanged,TResult Function( RegisterConfirmationChanged value)?  confirmationChanged,TResult Function( RegisterTermsChanged value)?  termsChanged,TResult Function( RegisterPrivacyNoticeChanged value)?  privacyNoticeChanged,TResult Function( RegisterSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RegisterDisplayNameChanged() when displayNameChanged != null:
return displayNameChanged(_that);case RegisterEmailChanged() when emailChanged != null:
return emailChanged(_that);case RegisterPasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case RegisterConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that);case RegisterTermsChanged() when termsChanged != null:
return termsChanged(_that);case RegisterPrivacyNoticeChanged() when privacyNoticeChanged != null:
return privacyNoticeChanged(_that);case RegisterSubmitted() when submitted != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RegisterDisplayNameChanged value)  displayNameChanged,required TResult Function( RegisterEmailChanged value)  emailChanged,required TResult Function( RegisterPasswordChanged value)  passwordChanged,required TResult Function( RegisterConfirmationChanged value)  confirmationChanged,required TResult Function( RegisterTermsChanged value)  termsChanged,required TResult Function( RegisterPrivacyNoticeChanged value)  privacyNoticeChanged,required TResult Function( RegisterSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case RegisterDisplayNameChanged():
return displayNameChanged(_that);case RegisterEmailChanged():
return emailChanged(_that);case RegisterPasswordChanged():
return passwordChanged(_that);case RegisterConfirmationChanged():
return confirmationChanged(_that);case RegisterTermsChanged():
return termsChanged(_that);case RegisterPrivacyNoticeChanged():
return privacyNoticeChanged(_that);case RegisterSubmitted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RegisterDisplayNameChanged value)?  displayNameChanged,TResult? Function( RegisterEmailChanged value)?  emailChanged,TResult? Function( RegisterPasswordChanged value)?  passwordChanged,TResult? Function( RegisterConfirmationChanged value)?  confirmationChanged,TResult? Function( RegisterTermsChanged value)?  termsChanged,TResult? Function( RegisterPrivacyNoticeChanged value)?  privacyNoticeChanged,TResult? Function( RegisterSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case RegisterDisplayNameChanged() when displayNameChanged != null:
return displayNameChanged(_that);case RegisterEmailChanged() when emailChanged != null:
return emailChanged(_that);case RegisterPasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case RegisterConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that);case RegisterTermsChanged() when termsChanged != null:
return termsChanged(_that);case RegisterPrivacyNoticeChanged() when privacyNoticeChanged != null:
return privacyNoticeChanged(_that);case RegisterSubmitted() when submitted != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  displayNameChanged,TResult Function( String value)?  emailChanged,TResult Function( String value)?  passwordChanged,TResult Function( String value)?  confirmationChanged,TResult Function( bool accepted)?  termsChanged,TResult Function( bool acknowledged)?  privacyNoticeChanged,TResult Function()?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RegisterDisplayNameChanged() when displayNameChanged != null:
return displayNameChanged(_that.value);case RegisterEmailChanged() when emailChanged != null:
return emailChanged(_that.value);case RegisterPasswordChanged() when passwordChanged != null:
return passwordChanged(_that.value);case RegisterConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that.value);case RegisterTermsChanged() when termsChanged != null:
return termsChanged(_that.accepted);case RegisterPrivacyNoticeChanged() when privacyNoticeChanged != null:
return privacyNoticeChanged(_that.acknowledged);case RegisterSubmitted() when submitted != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  displayNameChanged,required TResult Function( String value)  emailChanged,required TResult Function( String value)  passwordChanged,required TResult Function( String value)  confirmationChanged,required TResult Function( bool accepted)  termsChanged,required TResult Function( bool acknowledged)  privacyNoticeChanged,required TResult Function()  submitted,}) {final _that = this;
switch (_that) {
case RegisterDisplayNameChanged():
return displayNameChanged(_that.value);case RegisterEmailChanged():
return emailChanged(_that.value);case RegisterPasswordChanged():
return passwordChanged(_that.value);case RegisterConfirmationChanged():
return confirmationChanged(_that.value);case RegisterTermsChanged():
return termsChanged(_that.accepted);case RegisterPrivacyNoticeChanged():
return privacyNoticeChanged(_that.acknowledged);case RegisterSubmitted():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  displayNameChanged,TResult? Function( String value)?  emailChanged,TResult? Function( String value)?  passwordChanged,TResult? Function( String value)?  confirmationChanged,TResult? Function( bool accepted)?  termsChanged,TResult? Function( bool acknowledged)?  privacyNoticeChanged,TResult? Function()?  submitted,}) {final _that = this;
switch (_that) {
case RegisterDisplayNameChanged() when displayNameChanged != null:
return displayNameChanged(_that.value);case RegisterEmailChanged() when emailChanged != null:
return emailChanged(_that.value);case RegisterPasswordChanged() when passwordChanged != null:
return passwordChanged(_that.value);case RegisterConfirmationChanged() when confirmationChanged != null:
return confirmationChanged(_that.value);case RegisterTermsChanged() when termsChanged != null:
return termsChanged(_that.accepted);case RegisterPrivacyNoticeChanged() when privacyNoticeChanged != null:
return privacyNoticeChanged(_that.acknowledged);case RegisterSubmitted() when submitted != null:
return submitted();case _:
  return null;

}
}

}

/// @nodoc


class RegisterDisplayNameChanged implements RegisterEvent {
  const RegisterDisplayNameChanged(this.value);
  

 final  String value;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterDisplayNameChangedCopyWith<RegisterDisplayNameChanged> get copyWith => _$RegisterDisplayNameChangedCopyWithImpl<RegisterDisplayNameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterDisplayNameChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'RegisterEvent.displayNameChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $RegisterDisplayNameChangedCopyWith<$Res> implements $RegisterEventCopyWith<$Res> {
  factory $RegisterDisplayNameChangedCopyWith(RegisterDisplayNameChanged value, $Res Function(RegisterDisplayNameChanged) _then) = _$RegisterDisplayNameChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$RegisterDisplayNameChangedCopyWithImpl<$Res>
    implements $RegisterDisplayNameChangedCopyWith<$Res> {
  _$RegisterDisplayNameChangedCopyWithImpl(this._self, this._then);

  final RegisterDisplayNameChanged _self;
  final $Res Function(RegisterDisplayNameChanged) _then;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(RegisterDisplayNameChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RegisterEmailChanged implements RegisterEvent {
  const RegisterEmailChanged(this.value);
  

 final  String value;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterEmailChangedCopyWith<RegisterEmailChanged> get copyWith => _$RegisterEmailChangedCopyWithImpl<RegisterEmailChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterEmailChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'RegisterEvent.emailChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $RegisterEmailChangedCopyWith<$Res> implements $RegisterEventCopyWith<$Res> {
  factory $RegisterEmailChangedCopyWith(RegisterEmailChanged value, $Res Function(RegisterEmailChanged) _then) = _$RegisterEmailChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$RegisterEmailChangedCopyWithImpl<$Res>
    implements $RegisterEmailChangedCopyWith<$Res> {
  _$RegisterEmailChangedCopyWithImpl(this._self, this._then);

  final RegisterEmailChanged _self;
  final $Res Function(RegisterEmailChanged) _then;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(RegisterEmailChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RegisterPasswordChanged implements RegisterEvent {
  const RegisterPasswordChanged(this.value);
  

 final  String value;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterPasswordChangedCopyWith<RegisterPasswordChanged> get copyWith => _$RegisterPasswordChangedCopyWithImpl<RegisterPasswordChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterPasswordChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'RegisterEvent.passwordChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $RegisterPasswordChangedCopyWith<$Res> implements $RegisterEventCopyWith<$Res> {
  factory $RegisterPasswordChangedCopyWith(RegisterPasswordChanged value, $Res Function(RegisterPasswordChanged) _then) = _$RegisterPasswordChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$RegisterPasswordChangedCopyWithImpl<$Res>
    implements $RegisterPasswordChangedCopyWith<$Res> {
  _$RegisterPasswordChangedCopyWithImpl(this._self, this._then);

  final RegisterPasswordChanged _self;
  final $Res Function(RegisterPasswordChanged) _then;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(RegisterPasswordChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RegisterConfirmationChanged implements RegisterEvent {
  const RegisterConfirmationChanged(this.value);
  

 final  String value;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterConfirmationChangedCopyWith<RegisterConfirmationChanged> get copyWith => _$RegisterConfirmationChangedCopyWithImpl<RegisterConfirmationChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterConfirmationChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'RegisterEvent.confirmationChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $RegisterConfirmationChangedCopyWith<$Res> implements $RegisterEventCopyWith<$Res> {
  factory $RegisterConfirmationChangedCopyWith(RegisterConfirmationChanged value, $Res Function(RegisterConfirmationChanged) _then) = _$RegisterConfirmationChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$RegisterConfirmationChangedCopyWithImpl<$Res>
    implements $RegisterConfirmationChangedCopyWith<$Res> {
  _$RegisterConfirmationChangedCopyWithImpl(this._self, this._then);

  final RegisterConfirmationChanged _self;
  final $Res Function(RegisterConfirmationChanged) _then;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(RegisterConfirmationChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RegisterTermsChanged implements RegisterEvent {
  const RegisterTermsChanged({required this.accepted});
  

 final  bool accepted;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterTermsChangedCopyWith<RegisterTermsChanged> get copyWith => _$RegisterTermsChangedCopyWithImpl<RegisterTermsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterTermsChanged&&(identical(other.accepted, accepted) || other.accepted == accepted));
}


@override
int get hashCode {
    return Object.hash(runtimeType,accepted);
}

@override
String toString() {
    return 'RegisterEvent.termsChanged(accepted: $accepted)';
}


}

/// @nodoc
abstract mixin class $RegisterTermsChangedCopyWith<$Res> implements $RegisterEventCopyWith<$Res> {
  factory $RegisterTermsChangedCopyWith(RegisterTermsChanged value, $Res Function(RegisterTermsChanged) _then) = _$RegisterTermsChangedCopyWithImpl;
@useResult
$Res call({
 bool accepted
});




}
/// @nodoc
class _$RegisterTermsChangedCopyWithImpl<$Res>
    implements $RegisterTermsChangedCopyWith<$Res> {
  _$RegisterTermsChangedCopyWithImpl(this._self, this._then);

  final RegisterTermsChanged _self;
  final $Res Function(RegisterTermsChanged) _then;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accepted = null,}) {
  return _then(RegisterTermsChanged(
accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class RegisterPrivacyNoticeChanged implements RegisterEvent {
  const RegisterPrivacyNoticeChanged({required this.acknowledged});
  

 final  bool acknowledged;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterPrivacyNoticeChangedCopyWith<RegisterPrivacyNoticeChanged> get copyWith => _$RegisterPrivacyNoticeChangedCopyWithImpl<RegisterPrivacyNoticeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterPrivacyNoticeChanged&&(identical(other.acknowledged, acknowledged) || other.acknowledged == acknowledged));
}


@override
int get hashCode {
    return Object.hash(runtimeType,acknowledged);
}

@override
String toString() {
    return 'RegisterEvent.privacyNoticeChanged(acknowledged: $acknowledged)';
}


}

/// @nodoc
abstract mixin class $RegisterPrivacyNoticeChangedCopyWith<$Res> implements $RegisterEventCopyWith<$Res> {
  factory $RegisterPrivacyNoticeChangedCopyWith(RegisterPrivacyNoticeChanged value, $Res Function(RegisterPrivacyNoticeChanged) _then) = _$RegisterPrivacyNoticeChangedCopyWithImpl;
@useResult
$Res call({
 bool acknowledged
});




}
/// @nodoc
class _$RegisterPrivacyNoticeChangedCopyWithImpl<$Res>
    implements $RegisterPrivacyNoticeChangedCopyWith<$Res> {
  _$RegisterPrivacyNoticeChangedCopyWithImpl(this._self, this._then);

  final RegisterPrivacyNoticeChanged _self;
  final $Res Function(RegisterPrivacyNoticeChanged) _then;

/// Create a copy of RegisterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? acknowledged = null,}) {
  return _then(RegisterPrivacyNoticeChanged(
acknowledged: null == acknowledged ? _self.acknowledged : acknowledged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class RegisterSubmitted implements RegisterEvent {
  const RegisterSubmitted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RegisterEvent.submitted()';
}


}




/// @nodoc
mixin _$RegisterState {

 String get displayName; String get email; String get password; String get confirmation; bool get acceptedTerms; bool get acknowledgedPrivacyNotice; bool get showValidationErrors; FormStatus get status; int get invalidSubmissions; Failure? get failure; VerificationChallenge? get challenge;
/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterStateCopyWith<RegisterState> get copyWith => _$RegisterStateCopyWithImpl<RegisterState>(this as RegisterState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RegisterState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterState&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.confirmation, _this.confirmation) || other.confirmation == _this.confirmation)&&(identical(other.acceptedTerms, _this.acceptedTerms) || other.acceptedTerms == _this.acceptedTerms)&&(identical(other.acknowledgedPrivacyNotice, _this.acknowledgedPrivacyNotice) || other.acknowledgedPrivacyNotice == _this.acknowledgedPrivacyNotice)&&(identical(other.showValidationErrors, _this.showValidationErrors) || other.showValidationErrors == _this.showValidationErrors)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.invalidSubmissions, _this.invalidSubmissions) || other.invalidSubmissions == _this.invalidSubmissions)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.challenge, _this.challenge) || other.challenge == _this.challenge));
}


@override
int get hashCode {
  final _this = this as RegisterState;
  return Object.hash(runtimeType,_this.displayName,_this.email,_this.password,_this.confirmation,_this.acceptedTerms,_this.acknowledgedPrivacyNotice,_this.showValidationErrors,_this.status,_this.invalidSubmissions,_this.failure,_this.challenge);
}



}

/// @nodoc
abstract mixin class $RegisterStateCopyWith<$Res>  {
  factory $RegisterStateCopyWith(RegisterState value, $Res Function(RegisterState) _then) = _$RegisterStateCopyWithImpl;
@useResult
$Res call({
 String displayName, String email, String password, String confirmation, bool acceptedTerms, bool acknowledgedPrivacyNotice, bool showValidationErrors, FormStatus status, int invalidSubmissions, Failure? failure, VerificationChallenge? challenge
});




}
/// @nodoc
class _$RegisterStateCopyWithImpl<$Res>
    implements $RegisterStateCopyWith<$Res> {
  _$RegisterStateCopyWithImpl(this._self, this._then);

  final RegisterState _self;
  final $Res Function(RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? email = null,Object? password = null,Object? confirmation = null,Object? acceptedTerms = null,Object? acknowledgedPrivacyNotice = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? failure = freezed,Object? challenge = freezed,}) {
  return _then(RegisterState(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmation: null == confirmation ? _self.confirmation : confirmation // ignore: cast_nullable_to_non_nullable
as String,acceptedTerms: null == acceptedTerms ? _self.acceptedTerms : acceptedTerms // ignore: cast_nullable_to_non_nullable
as bool,acknowledgedPrivacyNotice: null == acknowledgedPrivacyNotice ? _self.acknowledgedPrivacyNotice : acknowledgedPrivacyNotice // ignore: cast_nullable_to_non_nullable
as bool,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,challenge: freezed == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as VerificationChallenge?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterState].
extension RegisterStatePatterns on RegisterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterState value)  $default,){
final _that = this;
switch (_that) {
case _RegisterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterState value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String displayName,  String email,  String password,  String confirmation,  bool acceptedTerms,  bool acknowledgedPrivacyNotice,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  Failure? failure,  VerificationChallenge? challenge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.displayName,_that.email,_that.password,_that.confirmation,_that.acceptedTerms,_that.acknowledgedPrivacyNotice,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure,_that.challenge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String displayName,  String email,  String password,  String confirmation,  bool acceptedTerms,  bool acknowledgedPrivacyNotice,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  Failure? failure,  VerificationChallenge? challenge)  $default,) {final _that = this;
switch (_that) {
case _RegisterState():
return $default(_that.displayName,_that.email,_that.password,_that.confirmation,_that.acceptedTerms,_that.acknowledgedPrivacyNotice,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure,_that.challenge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String displayName,  String email,  String password,  String confirmation,  bool acceptedTerms,  bool acknowledgedPrivacyNotice,  bool showValidationErrors,  FormStatus status,  int invalidSubmissions,  Failure? failure,  VerificationChallenge? challenge)?  $default,) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.displayName,_that.email,_that.password,_that.confirmation,_that.acceptedTerms,_that.acknowledgedPrivacyNotice,_that.showValidationErrors,_that.status,_that.invalidSubmissions,_that.failure,_that.challenge);case _:
  return null;

}
}

}

/// @nodoc


class _RegisterState extends RegisterState {
  const _RegisterState({this.displayName = '', this.email = '', this.password = '', this.confirmation = '', this.acceptedTerms = false, this.acknowledgedPrivacyNotice = false, this.showValidationErrors = false, this.status = FormStatus.editing, this.invalidSubmissions = 0, this.failure, this.challenge}): super._();
  

@override@JsonKey() final  String displayName;
@override@JsonKey() final  String email;
@override@JsonKey() final  String password;
@override@JsonKey() final  String confirmation;
@override@JsonKey() final  bool acceptedTerms;
@override@JsonKey() final  bool acknowledgedPrivacyNotice;
@override@JsonKey() final  bool showValidationErrors;
@override@JsonKey() final  FormStatus status;
@override@JsonKey() final  int invalidSubmissions;
@override final  Failure? failure;
@override final  VerificationChallenge? challenge;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterStateCopyWith<_RegisterState> get copyWith => __$RegisterStateCopyWithImpl<_RegisterState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterState&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmation, confirmation) || other.confirmation == confirmation)&&(identical(other.acceptedTerms, acceptedTerms) || other.acceptedTerms == acceptedTerms)&&(identical(other.acknowledgedPrivacyNotice, acknowledgedPrivacyNotice) || other.acknowledgedPrivacyNotice == acknowledgedPrivacyNotice)&&(identical(other.showValidationErrors, showValidationErrors) || other.showValidationErrors == showValidationErrors)&&(identical(other.status, status) || other.status == status)&&(identical(other.invalidSubmissions, invalidSubmissions) || other.invalidSubmissions == invalidSubmissions)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.challenge, challenge) || other.challenge == challenge));
}


@override
int get hashCode {
    return Object.hash(runtimeType,displayName,email,password,confirmation,acceptedTerms,acknowledgedPrivacyNotice,showValidationErrors,status,invalidSubmissions,failure,challenge);
}



}

/// @nodoc
abstract mixin class _$RegisterStateCopyWith<$Res> implements $RegisterStateCopyWith<$Res> {
  factory _$RegisterStateCopyWith(_RegisterState value, $Res Function(_RegisterState) _then) = __$RegisterStateCopyWithImpl;
@override @useResult
$Res call({
 String displayName, String email, String password, String confirmation, bool acceptedTerms, bool acknowledgedPrivacyNotice, bool showValidationErrors, FormStatus status, int invalidSubmissions, Failure? failure, VerificationChallenge? challenge
});




}
/// @nodoc
class __$RegisterStateCopyWithImpl<$Res>
    implements _$RegisterStateCopyWith<$Res> {
  __$RegisterStateCopyWithImpl(this._self, this._then);

  final _RegisterState _self;
  final $Res Function(_RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? email = null,Object? password = null,Object? confirmation = null,Object? acceptedTerms = null,Object? acknowledgedPrivacyNotice = null,Object? showValidationErrors = null,Object? status = null,Object? invalidSubmissions = null,Object? failure = freezed,Object? challenge = freezed,}) {
  return _then(_RegisterState(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmation: null == confirmation ? _self.confirmation : confirmation // ignore: cast_nullable_to_non_nullable
as String,acceptedTerms: null == acceptedTerms ? _self.acceptedTerms : acceptedTerms // ignore: cast_nullable_to_non_nullable
as bool,acknowledgedPrivacyNotice: null == acknowledgedPrivacyNotice ? _self.acknowledgedPrivacyNotice : acknowledgedPrivacyNotice // ignore: cast_nullable_to_non_nullable
as bool,showValidationErrors: null == showValidationErrors ? _self.showValidationErrors : showValidationErrors // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,challenge: freezed == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as VerificationChallenge?,
  ));
}


}

// dart format on
