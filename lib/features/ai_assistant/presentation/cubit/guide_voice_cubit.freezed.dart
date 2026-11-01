// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guide_voice_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GuideVoiceState {

 GuideVoiceStatus get status;/// Bu oturumda tanınan metin (dinlerken kısmi).
 String get transcript; GuideVoiceIssue? get issue;/// `false` → mikrofon butonu gösterilmez.
 bool get isAvailable; bool get canOpenSettings;/// Her dinleme oturumunda artar.
 int get session;
/// Create a copy of GuideVoiceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuideVoiceStateCopyWith<GuideVoiceState> get copyWith => _$GuideVoiceStateCopyWithImpl<GuideVoiceState>(this as GuideVoiceState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GuideVoiceState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuideVoiceState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.transcript, _this.transcript) || other.transcript == _this.transcript)&&(identical(other.issue, _this.issue) || other.issue == _this.issue)&&(identical(other.isAvailable, _this.isAvailable) || other.isAvailable == _this.isAvailable)&&(identical(other.canOpenSettings, _this.canOpenSettings) || other.canOpenSettings == _this.canOpenSettings)&&(identical(other.session, _this.session) || other.session == _this.session));
}


@override
int get hashCode {
  final _this = this as GuideVoiceState;
  return Object.hash(runtimeType,_this.status,_this.transcript,_this.issue,_this.isAvailable,_this.canOpenSettings,_this.session);
}



}

/// @nodoc
abstract mixin class $GuideVoiceStateCopyWith<$Res>  {
  factory $GuideVoiceStateCopyWith(GuideVoiceState value, $Res Function(GuideVoiceState) _then) = _$GuideVoiceStateCopyWithImpl;
@useResult
$Res call({
 GuideVoiceStatus status, String transcript, GuideVoiceIssue? issue, bool isAvailable, bool canOpenSettings, int session
});




}
/// @nodoc
class _$GuideVoiceStateCopyWithImpl<$Res>
    implements $GuideVoiceStateCopyWith<$Res> {
  _$GuideVoiceStateCopyWithImpl(this._self, this._then);

  final GuideVoiceState _self;
  final $Res Function(GuideVoiceState) _then;

/// Create a copy of GuideVoiceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? transcript = null,Object? issue = freezed,Object? isAvailable = null,Object? canOpenSettings = null,Object? session = null,}) {
  return _then(GuideVoiceState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GuideVoiceStatus,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,issue: freezed == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as GuideVoiceIssue?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,canOpenSettings: null == canOpenSettings ? _self.canOpenSettings : canOpenSettings // ignore: cast_nullable_to_non_nullable
as bool,session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GuideVoiceState].
extension GuideVoiceStatePatterns on GuideVoiceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuideVoiceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuideVoiceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuideVoiceState value)  $default,){
final _that = this;
switch (_that) {
case _GuideVoiceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuideVoiceState value)?  $default,){
final _that = this;
switch (_that) {
case _GuideVoiceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GuideVoiceStatus status,  String transcript,  GuideVoiceIssue? issue,  bool isAvailable,  bool canOpenSettings,  int session)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuideVoiceState() when $default != null:
return $default(_that.status,_that.transcript,_that.issue,_that.isAvailable,_that.canOpenSettings,_that.session);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GuideVoiceStatus status,  String transcript,  GuideVoiceIssue? issue,  bool isAvailable,  bool canOpenSettings,  int session)  $default,) {final _that = this;
switch (_that) {
case _GuideVoiceState():
return $default(_that.status,_that.transcript,_that.issue,_that.isAvailable,_that.canOpenSettings,_that.session);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GuideVoiceStatus status,  String transcript,  GuideVoiceIssue? issue,  bool isAvailable,  bool canOpenSettings,  int session)?  $default,) {final _that = this;
switch (_that) {
case _GuideVoiceState() when $default != null:
return $default(_that.status,_that.transcript,_that.issue,_that.isAvailable,_that.canOpenSettings,_that.session);case _:
  return null;

}
}

}

/// @nodoc


class _GuideVoiceState extends GuideVoiceState {
  const _GuideVoiceState({this.status = GuideVoiceStatus.idle, this.transcript = '', this.issue, this.isAvailable = true, this.canOpenSettings = false, this.session = 0}): super._();
  

@override@JsonKey() final  GuideVoiceStatus status;
/// Bu oturumda tanınan metin (dinlerken kısmi).
@override@JsonKey() final  String transcript;
@override final  GuideVoiceIssue? issue;
/// `false` → mikrofon butonu gösterilmez.
@override@JsonKey() final  bool isAvailable;
@override@JsonKey() final  bool canOpenSettings;
/// Her dinleme oturumunda artar.
@override@JsonKey() final  int session;

/// Create a copy of GuideVoiceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuideVoiceStateCopyWith<_GuideVoiceState> get copyWith => __$GuideVoiceStateCopyWithImpl<_GuideVoiceState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuideVoiceState&&(identical(other.status, status) || other.status == status)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.issue, issue) || other.issue == issue)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.canOpenSettings, canOpenSettings) || other.canOpenSettings == canOpenSettings)&&(identical(other.session, session) || other.session == session));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,transcript,issue,isAvailable,canOpenSettings,session);
}



}

/// @nodoc
abstract mixin class _$GuideVoiceStateCopyWith<$Res> implements $GuideVoiceStateCopyWith<$Res> {
  factory _$GuideVoiceStateCopyWith(_GuideVoiceState value, $Res Function(_GuideVoiceState) _then) = __$GuideVoiceStateCopyWithImpl;
@override @useResult
$Res call({
 GuideVoiceStatus status, String transcript, GuideVoiceIssue? issue, bool isAvailable, bool canOpenSettings, int session
});




}
/// @nodoc
class __$GuideVoiceStateCopyWithImpl<$Res>
    implements _$GuideVoiceStateCopyWith<$Res> {
  __$GuideVoiceStateCopyWithImpl(this._self, this._then);

  final _GuideVoiceState _self;
  final $Res Function(_GuideVoiceState) _then;

/// Create a copy of GuideVoiceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? transcript = null,Object? issue = freezed,Object? isAvailable = null,Object? canOpenSettings = null,Object? session = null,}) {
  return _then(_GuideVoiceState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GuideVoiceStatus,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,issue: freezed == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as GuideVoiceIssue?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,canOpenSettings: null == canOpenSettings ? _self.canOpenSettings : canOpenSettings // ignore: cast_nullable_to_non_nullable
as bool,session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
