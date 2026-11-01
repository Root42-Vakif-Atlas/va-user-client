// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_monuments_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavedMonumentsState {

/// En son kaydedilen önce.
 List<SavedMonument> get items; bool get isLoaded;
/// Create a copy of SavedMonumentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedMonumentsStateCopyWith<SavedMonumentsState> get copyWith => _$SavedMonumentsStateCopyWithImpl<SavedMonumentsState>(this as SavedMonumentsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SavedMonumentsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedMonumentsState&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.isLoaded, _this.isLoaded) || other.isLoaded == _this.isLoaded));
}


@override
int get hashCode {
  final _this = this as SavedMonumentsState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.isLoaded);
}

@override
String toString() {
  final _this = this as SavedMonumentsState;
  return 'SavedMonumentsState(items: ${_this.items}, isLoaded: ${_this.isLoaded})';
}


}

/// @nodoc
abstract mixin class $SavedMonumentsStateCopyWith<$Res>  {
  factory $SavedMonumentsStateCopyWith(SavedMonumentsState value, $Res Function(SavedMonumentsState) _then) = _$SavedMonumentsStateCopyWithImpl;
@useResult
$Res call({
 List<SavedMonument> items, bool isLoaded
});




}
/// @nodoc
class _$SavedMonumentsStateCopyWithImpl<$Res>
    implements $SavedMonumentsStateCopyWith<$Res> {
  _$SavedMonumentsStateCopyWithImpl(this._self, this._then);

  final SavedMonumentsState _self;
  final $Res Function(SavedMonumentsState) _then;

/// Create a copy of SavedMonumentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? isLoaded = null,}) {
  return _then(SavedMonumentsState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SavedMonument>,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedMonumentsState].
extension SavedMonumentsStatePatterns on SavedMonumentsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedMonumentsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedMonumentsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedMonumentsState value)  $default,){
final _that = this;
switch (_that) {
case _SavedMonumentsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedMonumentsState value)?  $default,){
final _that = this;
switch (_that) {
case _SavedMonumentsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SavedMonument> items,  bool isLoaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedMonumentsState() when $default != null:
return $default(_that.items,_that.isLoaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SavedMonument> items,  bool isLoaded)  $default,) {final _that = this;
switch (_that) {
case _SavedMonumentsState():
return $default(_that.items,_that.isLoaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SavedMonument> items,  bool isLoaded)?  $default,) {final _that = this;
switch (_that) {
case _SavedMonumentsState() when $default != null:
return $default(_that.items,_that.isLoaded);case _:
  return null;

}
}

}

/// @nodoc


class _SavedMonumentsState extends SavedMonumentsState {
  const _SavedMonumentsState({ List<SavedMonument> items = const <SavedMonument>[], this.isLoaded = false}): _items = items,super._();
  

/// En son kaydedilen önce.
 final  List<SavedMonument> _items;
/// En son kaydedilen önce.
@override@JsonKey() List<SavedMonument> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool isLoaded;

/// Create a copy of SavedMonumentsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedMonumentsStateCopyWith<_SavedMonumentsState> get copyWith => __$SavedMonumentsStateCopyWithImpl<_SavedMonumentsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedMonumentsState&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),isLoaded);
}

@override
String toString() {
    return 'SavedMonumentsState(items: $items, isLoaded: $isLoaded)';
}


}

/// @nodoc
abstract mixin class _$SavedMonumentsStateCopyWith<$Res> implements $SavedMonumentsStateCopyWith<$Res> {
  factory _$SavedMonumentsStateCopyWith(_SavedMonumentsState value, $Res Function(_SavedMonumentsState) _then) = __$SavedMonumentsStateCopyWithImpl;
@override @useResult
$Res call({
 List<SavedMonument> items, bool isLoaded
});




}
/// @nodoc
class __$SavedMonumentsStateCopyWithImpl<$Res>
    implements _$SavedMonumentsStateCopyWith<$Res> {
  __$SavedMonumentsStateCopyWithImpl(this._self, this._then);

  final _SavedMonumentsState _self;
  final $Res Function(_SavedMonumentsState) _then;

/// Create a copy of SavedMonumentsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? isLoaded = null,}) {
  return _then(_SavedMonumentsState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SavedMonument>,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
