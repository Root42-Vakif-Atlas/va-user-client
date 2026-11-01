// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserDto {

 String get id; String get displayName; String get email;
/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDtoCopyWith<UserDto> get copyWith => _$UserDtoCopyWithImpl<UserDto>(this as UserDto, _$identity);

  /// Serializes this UserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.email, _this.email) || other.email == _this.email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserDto;
  return Object.hash(runtimeType,_this.id,_this.displayName,_this.email);
}

@override
String toString() {
  final _this = this as UserDto;
  return 'UserDto(id: ${_this.id}, displayName: ${_this.displayName}, email: ${_this.email})';
}


}

/// @nodoc
abstract mixin class $UserDtoCopyWith<$Res>  {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) _then) = _$UserDtoCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, String email
});




}
/// @nodoc
class _$UserDtoCopyWithImpl<$Res>
    implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._self, this._then);

  final UserDto _self;
  final $Res Function(UserDto) _then;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? email = null,}) {
  return _then(UserDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserDto].
extension UserDtoPatterns on UserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDto value)  $default,){
final _that = this;
switch (_that) {
case _UserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDto value)?  $default,){
final _that = this;
switch (_that) {
case _UserDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDto() when $default != null:
return $default(_that.id,_that.displayName,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  String email)  $default,) {final _that = this;
switch (_that) {
case _UserDto():
return $default(_that.id,_that.displayName,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  String email)?  $default,) {final _that = this;
switch (_that) {
case _UserDto() when $default != null:
return $default(_that.id,_that.displayName,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserDto extends UserDto {
  const _UserDto({required this.id, required this.displayName, required this.email}): super._();
  factory _UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

@override final  String id;
@override final  String displayName;
@override final  String email;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDtoCopyWith<_UserDto> get copyWith => __$UserDtoCopyWithImpl<_UserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,displayName,email);
}

@override
String toString() {
    return 'UserDto(id: $id, displayName: $displayName, email: $email)';
}


}

/// @nodoc
abstract mixin class _$UserDtoCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$UserDtoCopyWith(_UserDto value, $Res Function(_UserDto) _then) = __$UserDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, String email
});




}
/// @nodoc
class __$UserDtoCopyWithImpl<$Res>
    implements _$UserDtoCopyWith<$Res> {
  __$UserDtoCopyWithImpl(this._self, this._then);

  final _UserDto _self;
  final $Res Function(_UserDto) _then;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? email = null,}) {
  return _then(_UserDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AuthResponseDto {

 String get accessToken; String get refreshToken;/// Erişim anahtarının saniye cinsinden geçerlilik süresi.
 int get expiresIn; UserDto? get user;
/// Create a copy of AuthResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthResponseDtoCopyWith<AuthResponseDto> get copyWith => _$AuthResponseDtoCopyWithImpl<AuthResponseDto>(this as AuthResponseDto, _$identity);

  /// Serializes this AuthResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AuthResponseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthResponseDto&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.refreshToken, _this.refreshToken) || other.refreshToken == _this.refreshToken)&&(identical(other.expiresIn, _this.expiresIn) || other.expiresIn == _this.expiresIn)&&(identical(other.user, _this.user) || other.user == _this.user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AuthResponseDto;
  return Object.hash(runtimeType,_this.accessToken,_this.refreshToken,_this.expiresIn,_this.user);
}

@override
String toString() {
  final _this = this as AuthResponseDto;
  return 'AuthResponseDto(accessToken: ${_this.accessToken}, refreshToken: ${_this.refreshToken}, expiresIn: ${_this.expiresIn}, user: ${_this.user})';
}


}

/// @nodoc
abstract mixin class $AuthResponseDtoCopyWith<$Res>  {
  factory $AuthResponseDtoCopyWith(AuthResponseDto value, $Res Function(AuthResponseDto) _then) = _$AuthResponseDtoCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, int expiresIn, UserDto? user
});


$UserDtoCopyWith<$Res>? get user;

}
/// @nodoc
class _$AuthResponseDtoCopyWithImpl<$Res>
    implements $AuthResponseDtoCopyWith<$Res> {
  _$AuthResponseDtoCopyWithImpl(this._self, this._then);

  final AuthResponseDto _self;
  final $Res Function(AuthResponseDto) _then;

/// Create a copy of AuthResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresIn = null,Object? user = freezed,}) {
  return _then(AuthResponseDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserDto?,
  ));
}
/// Create a copy of AuthResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserDtoCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthResponseDto].
extension AuthResponseDtoPatterns on AuthResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  int expiresIn,  UserDto? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthResponseDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresIn,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  int expiresIn,  UserDto? user)  $default,) {final _that = this;
switch (_that) {
case _AuthResponseDto():
return $default(_that.accessToken,_that.refreshToken,_that.expiresIn,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  int expiresIn,  UserDto? user)?  $default,) {final _that = this;
switch (_that) {
case _AuthResponseDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresIn,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthResponseDto extends AuthResponseDto {
  const _AuthResponseDto({required this.accessToken, required this.refreshToken, required this.expiresIn, this.user}): super._();
  factory _AuthResponseDto.fromJson(Map<String, dynamic> json) => _$AuthResponseDtoFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;
/// Erişim anahtarının saniye cinsinden geçerlilik süresi.
@override final  int expiresIn;
@override final  UserDto? user;

/// Create a copy of AuthResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthResponseDtoCopyWith<_AuthResponseDto> get copyWith => __$AuthResponseDtoCopyWithImpl<_AuthResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthResponseDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accessToken,refreshToken,expiresIn,user);
}

@override
String toString() {
    return 'AuthResponseDto(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn, user: $user)';
}


}

/// @nodoc
abstract mixin class _$AuthResponseDtoCopyWith<$Res> implements $AuthResponseDtoCopyWith<$Res> {
  factory _$AuthResponseDtoCopyWith(_AuthResponseDto value, $Res Function(_AuthResponseDto) _then) = __$AuthResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, int expiresIn, UserDto? user
});


@override $UserDtoCopyWith<$Res>? get user;

}
/// @nodoc
class __$AuthResponseDtoCopyWithImpl<$Res>
    implements _$AuthResponseDtoCopyWith<$Res> {
  __$AuthResponseDtoCopyWithImpl(this._self, this._then);

  final _AuthResponseDto _self;
  final $Res Function(_AuthResponseDto) _then;

/// Create a copy of AuthResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresIn = null,Object? user = freezed,}) {
  return _then(_AuthResponseDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserDto?,
  ));
}

/// Create a copy of AuthResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserDtoCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$VerificationChallengeDto {

/// Yeni kod istenebilmesi için saniye cinsinden bekleme süresi.
 int get resendAfter; int get codeLength;
/// Create a copy of VerificationChallengeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerificationChallengeDtoCopyWith<VerificationChallengeDto> get copyWith => _$VerificationChallengeDtoCopyWithImpl<VerificationChallengeDto>(this as VerificationChallengeDto, _$identity);

  /// Serializes this VerificationChallengeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VerificationChallengeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerificationChallengeDto&&(identical(other.resendAfter, _this.resendAfter) || other.resendAfter == _this.resendAfter)&&(identical(other.codeLength, _this.codeLength) || other.codeLength == _this.codeLength));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VerificationChallengeDto;
  return Object.hash(runtimeType,_this.resendAfter,_this.codeLength);
}

@override
String toString() {
  final _this = this as VerificationChallengeDto;
  return 'VerificationChallengeDto(resendAfter: ${_this.resendAfter}, codeLength: ${_this.codeLength})';
}


}

/// @nodoc
abstract mixin class $VerificationChallengeDtoCopyWith<$Res>  {
  factory $VerificationChallengeDtoCopyWith(VerificationChallengeDto value, $Res Function(VerificationChallengeDto) _then) = _$VerificationChallengeDtoCopyWithImpl;
@useResult
$Res call({
 int resendAfter, int codeLength
});




}
/// @nodoc
class _$VerificationChallengeDtoCopyWithImpl<$Res>
    implements $VerificationChallengeDtoCopyWith<$Res> {
  _$VerificationChallengeDtoCopyWithImpl(this._self, this._then);

  final VerificationChallengeDto _self;
  final $Res Function(VerificationChallengeDto) _then;

/// Create a copy of VerificationChallengeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? resendAfter = null,Object? codeLength = null,}) {
  return _then(VerificationChallengeDto(
resendAfter: null == resendAfter ? _self.resendAfter : resendAfter // ignore: cast_nullable_to_non_nullable
as int,codeLength: null == codeLength ? _self.codeLength : codeLength // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VerificationChallengeDto].
extension VerificationChallengeDtoPatterns on VerificationChallengeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerificationChallengeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerificationChallengeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerificationChallengeDto value)  $default,){
final _that = this;
switch (_that) {
case _VerificationChallengeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerificationChallengeDto value)?  $default,){
final _that = this;
switch (_that) {
case _VerificationChallengeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int resendAfter,  int codeLength)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerificationChallengeDto() when $default != null:
return $default(_that.resendAfter,_that.codeLength);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int resendAfter,  int codeLength)  $default,) {final _that = this;
switch (_that) {
case _VerificationChallengeDto():
return $default(_that.resendAfter,_that.codeLength);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int resendAfter,  int codeLength)?  $default,) {final _that = this;
switch (_that) {
case _VerificationChallengeDto() when $default != null:
return $default(_that.resendAfter,_that.codeLength);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerificationChallengeDto extends VerificationChallengeDto {
  const _VerificationChallengeDto({required this.resendAfter, this.codeLength = VerificationChallenge.defaultCodeLength}): super._();
  factory _VerificationChallengeDto.fromJson(Map<String, dynamic> json) => _$VerificationChallengeDtoFromJson(json);

/// Yeni kod istenebilmesi için saniye cinsinden bekleme süresi.
@override final  int resendAfter;
@override@JsonKey() final  int codeLength;

/// Create a copy of VerificationChallengeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerificationChallengeDtoCopyWith<_VerificationChallengeDto> get copyWith => __$VerificationChallengeDtoCopyWithImpl<_VerificationChallengeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerificationChallengeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerificationChallengeDto&&(identical(other.resendAfter, resendAfter) || other.resendAfter == resendAfter)&&(identical(other.codeLength, codeLength) || other.codeLength == codeLength));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,resendAfter,codeLength);
}

@override
String toString() {
    return 'VerificationChallengeDto(resendAfter: $resendAfter, codeLength: $codeLength)';
}


}

/// @nodoc
abstract mixin class _$VerificationChallengeDtoCopyWith<$Res> implements $VerificationChallengeDtoCopyWith<$Res> {
  factory _$VerificationChallengeDtoCopyWith(_VerificationChallengeDto value, $Res Function(_VerificationChallengeDto) _then) = __$VerificationChallengeDtoCopyWithImpl;
@override @useResult
$Res call({
 int resendAfter, int codeLength
});




}
/// @nodoc
class __$VerificationChallengeDtoCopyWithImpl<$Res>
    implements _$VerificationChallengeDtoCopyWith<$Res> {
  __$VerificationChallengeDtoCopyWithImpl(this._self, this._then);

  final _VerificationChallengeDto _self;
  final $Res Function(_VerificationChallengeDto) _then;

/// Create a copy of VerificationChallengeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? resendAfter = null,Object? codeLength = null,}) {
  return _then(_VerificationChallengeDto(
resendAfter: null == resendAfter ? _self.resendAfter : resendAfter // ignore: cast_nullable_to_non_nullable
as int,codeLength: null == codeLength ? _self.codeLength : codeLength // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LegalDocumentDto {

 String get type; String get version; String get title; String get body; DateTime get effectiveDate;
/// Create a copy of LegalDocumentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LegalDocumentDtoCopyWith<LegalDocumentDto> get copyWith => _$LegalDocumentDtoCopyWithImpl<LegalDocumentDto>(this as LegalDocumentDto, _$identity);

  /// Serializes this LegalDocumentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LegalDocumentDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LegalDocumentDto&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.effectiveDate, _this.effectiveDate) || other.effectiveDate == _this.effectiveDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LegalDocumentDto;
  return Object.hash(runtimeType,_this.type,_this.version,_this.title,_this.body,_this.effectiveDate);
}

@override
String toString() {
  final _this = this as LegalDocumentDto;
  return 'LegalDocumentDto(type: ${_this.type}, version: ${_this.version}, title: ${_this.title}, body: ${_this.body}, effectiveDate: ${_this.effectiveDate})';
}


}

/// @nodoc
abstract mixin class $LegalDocumentDtoCopyWith<$Res>  {
  factory $LegalDocumentDtoCopyWith(LegalDocumentDto value, $Res Function(LegalDocumentDto) _then) = _$LegalDocumentDtoCopyWithImpl;
@useResult
$Res call({
 String type, String version, String title, String body, DateTime effectiveDate
});




}
/// @nodoc
class _$LegalDocumentDtoCopyWithImpl<$Res>
    implements $LegalDocumentDtoCopyWith<$Res> {
  _$LegalDocumentDtoCopyWithImpl(this._self, this._then);

  final LegalDocumentDto _self;
  final $Res Function(LegalDocumentDto) _then;

/// Create a copy of LegalDocumentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? version = null,Object? title = null,Object? body = null,Object? effectiveDate = null,}) {
  return _then(LegalDocumentDto(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,effectiveDate: null == effectiveDate ? _self.effectiveDate : effectiveDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LegalDocumentDto].
extension LegalDocumentDtoPatterns on LegalDocumentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LegalDocumentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LegalDocumentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LegalDocumentDto value)  $default,){
final _that = this;
switch (_that) {
case _LegalDocumentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LegalDocumentDto value)?  $default,){
final _that = this;
switch (_that) {
case _LegalDocumentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String version,  String title,  String body,  DateTime effectiveDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LegalDocumentDto() when $default != null:
return $default(_that.type,_that.version,_that.title,_that.body,_that.effectiveDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String version,  String title,  String body,  DateTime effectiveDate)  $default,) {final _that = this;
switch (_that) {
case _LegalDocumentDto():
return $default(_that.type,_that.version,_that.title,_that.body,_that.effectiveDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String version,  String title,  String body,  DateTime effectiveDate)?  $default,) {final _that = this;
switch (_that) {
case _LegalDocumentDto() when $default != null:
return $default(_that.type,_that.version,_that.title,_that.body,_that.effectiveDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LegalDocumentDto extends LegalDocumentDto {
  const _LegalDocumentDto({required this.type, required this.version, required this.title, required this.body, required this.effectiveDate}): super._();
  factory _LegalDocumentDto.fromJson(Map<String, dynamic> json) => _$LegalDocumentDtoFromJson(json);

@override final  String type;
@override final  String version;
@override final  String title;
@override final  String body;
@override final  DateTime effectiveDate;

/// Create a copy of LegalDocumentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LegalDocumentDtoCopyWith<_LegalDocumentDto> get copyWith => __$LegalDocumentDtoCopyWithImpl<_LegalDocumentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LegalDocumentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LegalDocumentDto&&(identical(other.type, type) || other.type == type)&&(identical(other.version, version) || other.version == version)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.effectiveDate, effectiveDate) || other.effectiveDate == effectiveDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,version,title,body,effectiveDate);
}

@override
String toString() {
    return 'LegalDocumentDto(type: $type, version: $version, title: $title, body: $body, effectiveDate: $effectiveDate)';
}


}

/// @nodoc
abstract mixin class _$LegalDocumentDtoCopyWith<$Res> implements $LegalDocumentDtoCopyWith<$Res> {
  factory _$LegalDocumentDtoCopyWith(_LegalDocumentDto value, $Res Function(_LegalDocumentDto) _then) = __$LegalDocumentDtoCopyWithImpl;
@override @useResult
$Res call({
 String type, String version, String title, String body, DateTime effectiveDate
});




}
/// @nodoc
class __$LegalDocumentDtoCopyWithImpl<$Res>
    implements _$LegalDocumentDtoCopyWith<$Res> {
  __$LegalDocumentDtoCopyWithImpl(this._self, this._then);

  final _LegalDocumentDto _self;
  final $Res Function(_LegalDocumentDto) _then;

/// Create a copy of LegalDocumentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? version = null,Object? title = null,Object? body = null,Object? effectiveDate = null,}) {
  return _then(_LegalDocumentDto(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,effectiveDate: null == effectiveDate ? _self.effectiveDate : effectiveDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
