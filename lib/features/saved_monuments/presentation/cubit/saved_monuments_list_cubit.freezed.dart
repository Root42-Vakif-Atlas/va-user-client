// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_monuments_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavedMonumentsListState {

 SavedMonumentsListStatus get status; List<SavedMonumentEntry> get entries; Failure? get failure;
/// Create a copy of SavedMonumentsListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedMonumentsListStateCopyWith<SavedMonumentsListState> get copyWith => _$SavedMonumentsListStateCopyWithImpl<SavedMonumentsListState>(this as SavedMonumentsListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SavedMonumentsListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedMonumentsListState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as SavedMonumentsListState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.entries),_this.failure);
}

@override
String toString() {
  final _this = this as SavedMonumentsListState;
  return 'SavedMonumentsListState(status: ${_this.status}, entries: ${_this.entries}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $SavedMonumentsListStateCopyWith<$Res>  {
  factory $SavedMonumentsListStateCopyWith(SavedMonumentsListState value, $Res Function(SavedMonumentsListState) _then) = _$SavedMonumentsListStateCopyWithImpl;
@useResult
$Res call({
 SavedMonumentsListStatus status, List<SavedMonumentEntry> entries, Failure? failure
});




}
/// @nodoc
class _$SavedMonumentsListStateCopyWithImpl<$Res>
    implements $SavedMonumentsListStateCopyWith<$Res> {
  _$SavedMonumentsListStateCopyWithImpl(this._self, this._then);

  final SavedMonumentsListState _self;
  final $Res Function(SavedMonumentsListState) _then;

/// Create a copy of SavedMonumentsListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? entries = null,Object? failure = freezed,}) {
  return _then(SavedMonumentsListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SavedMonumentsListStatus,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<SavedMonumentEntry>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedMonumentsListState].
extension SavedMonumentsListStatePatterns on SavedMonumentsListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedMonumentsListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedMonumentsListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedMonumentsListState value)  $default,){
final _that = this;
switch (_that) {
case _SavedMonumentsListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedMonumentsListState value)?  $default,){
final _that = this;
switch (_that) {
case _SavedMonumentsListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SavedMonumentsListStatus status,  List<SavedMonumentEntry> entries,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedMonumentsListState() when $default != null:
return $default(_that.status,_that.entries,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SavedMonumentsListStatus status,  List<SavedMonumentEntry> entries,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _SavedMonumentsListState():
return $default(_that.status,_that.entries,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SavedMonumentsListStatus status,  List<SavedMonumentEntry> entries,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _SavedMonumentsListState() when $default != null:
return $default(_that.status,_that.entries,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _SavedMonumentsListState implements SavedMonumentsListState {
  const _SavedMonumentsListState({this.status = SavedMonumentsListStatus.loading,  List<SavedMonumentEntry> entries = const <SavedMonumentEntry>[], this.failure}): _entries = entries;
  

@override@JsonKey() final  SavedMonumentsListStatus status;
 final  List<SavedMonumentEntry> _entries;
@override@JsonKey() List<SavedMonumentEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override final  Failure? failure;

/// Create a copy of SavedMonumentsListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedMonumentsListStateCopyWith<_SavedMonumentsListState> get copyWith => __$SavedMonumentsListStateCopyWithImpl<_SavedMonumentsListState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedMonumentsListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_entries),failure);
}

@override
String toString() {
    return 'SavedMonumentsListState(status: $status, entries: $entries, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$SavedMonumentsListStateCopyWith<$Res> implements $SavedMonumentsListStateCopyWith<$Res> {
  factory _$SavedMonumentsListStateCopyWith(_SavedMonumentsListState value, $Res Function(_SavedMonumentsListState) _then) = __$SavedMonumentsListStateCopyWithImpl;
@override @useResult
$Res call({
 SavedMonumentsListStatus status, List<SavedMonumentEntry> entries, Failure? failure
});




}
/// @nodoc
class __$SavedMonumentsListStateCopyWithImpl<$Res>
    implements _$SavedMonumentsListStateCopyWith<$Res> {
  __$SavedMonumentsListStateCopyWithImpl(this._self, this._then);

  final _SavedMonumentsListState _self;
  final $Res Function(_SavedMonumentsListState) _then;

/// Create a copy of SavedMonumentsListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? entries = null,Object? failure = freezed,}) {
  return _then(_SavedMonumentsListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SavedMonumentsListStatus,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<SavedMonumentEntry>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
