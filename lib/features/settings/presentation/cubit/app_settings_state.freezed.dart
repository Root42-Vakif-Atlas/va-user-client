// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettingsState {

 AppSettings get settings;/// Son kaydetme denemesi başarısız olduysa nedeni. Değişiklik bu oturumda
/// uygulanmaya devam eder.
 Failure? get saveFailure;
/// Create a copy of AppSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsStateCopyWith<AppSettingsState> get copyWith => _$AppSettingsStateCopyWithImpl<AppSettingsState>(this as AppSettingsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppSettingsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettingsState&&(identical(other.settings, _this.settings) || other.settings == _this.settings)&&(identical(other.saveFailure, _this.saveFailure) || other.saveFailure == _this.saveFailure));
}


@override
int get hashCode {
  final _this = this as AppSettingsState;
  return Object.hash(runtimeType,_this.settings,_this.saveFailure);
}

@override
String toString() {
  final _this = this as AppSettingsState;
  return 'AppSettingsState(settings: ${_this.settings}, saveFailure: ${_this.saveFailure})';
}


}

/// @nodoc
abstract mixin class $AppSettingsStateCopyWith<$Res>  {
  factory $AppSettingsStateCopyWith(AppSettingsState value, $Res Function(AppSettingsState) _then) = _$AppSettingsStateCopyWithImpl;
@useResult
$Res call({
 AppSettings settings, Failure? saveFailure
});




}
/// @nodoc
class _$AppSettingsStateCopyWithImpl<$Res>
    implements $AppSettingsStateCopyWith<$Res> {
  _$AppSettingsStateCopyWithImpl(this._self, this._then);

  final AppSettingsState _self;
  final $Res Function(AppSettingsState) _then;

/// Create a copy of AppSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? settings = null,Object? saveFailure = freezed,}) {
  return _then(AppSettingsState(
settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AppSettings,saveFailure: freezed == saveFailure ? _self.saveFailure : saveFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettingsState].
extension AppSettingsStatePatterns on AppSettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettingsState value)  $default,){
final _that = this;
switch (_that) {
case _AppSettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppSettings settings,  Failure? saveFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettingsState() when $default != null:
return $default(_that.settings,_that.saveFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppSettings settings,  Failure? saveFailure)  $default,) {final _that = this;
switch (_that) {
case _AppSettingsState():
return $default(_that.settings,_that.saveFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppSettings settings,  Failure? saveFailure)?  $default,) {final _that = this;
switch (_that) {
case _AppSettingsState() when $default != null:
return $default(_that.settings,_that.saveFailure);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettingsState implements AppSettingsState {
  const _AppSettingsState({required this.settings, this.saveFailure});
  

@override final  AppSettings settings;
/// Son kaydetme denemesi başarısız olduysa nedeni. Değişiklik bu oturumda
/// uygulanmaya devam eder.
@override final  Failure? saveFailure;

/// Create a copy of AppSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsStateCopyWith<_AppSettingsState> get copyWith => __$AppSettingsStateCopyWithImpl<_AppSettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettingsState&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.saveFailure, saveFailure) || other.saveFailure == saveFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,settings,saveFailure);
}

@override
String toString() {
    return 'AppSettingsState(settings: $settings, saveFailure: $saveFailure)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsStateCopyWith<$Res> implements $AppSettingsStateCopyWith<$Res> {
  factory _$AppSettingsStateCopyWith(_AppSettingsState value, $Res Function(_AppSettingsState) _then) = __$AppSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 AppSettings settings, Failure? saveFailure
});




}
/// @nodoc
class __$AppSettingsStateCopyWithImpl<$Res>
    implements _$AppSettingsStateCopyWith<$Res> {
  __$AppSettingsStateCopyWithImpl(this._self, this._then);

  final _AppSettingsState _self;
  final $Res Function(_AppSettingsState) _then;

/// Create a copy of AppSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? settings = null,Object? saveFailure = freezed,}) {
  return _then(_AppSettingsState(
settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AppSettings,saveFailure: freezed == saveFailure ? _self.saveFailure : saveFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
