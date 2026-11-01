// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complex_members_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComplexMembersState {

 String? get complexId; String get languageCode; ComplexMembersStatus get status; List<MonumentSummary> get items; int get total; String? get nextCursor; bool get isLoadingMore;/// Seçili türler; boş → tümü.
 Set<MonumentCategory> get categories;/// Çip olarak sunulan türler (külliyede bulunanlar).
 List<MonumentCategory> get availableCategories;/// İlk sayfa hatası ([status] failure) veya sonraki sayfa hatası.
 Failure? get failure;
/// Create a copy of ComplexMembersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplexMembersStateCopyWith<ComplexMembersState> get copyWith => _$ComplexMembersStateCopyWithImpl<ComplexMembersState>(this as ComplexMembersState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ComplexMembersState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComplexMembersState&&(identical(other.complexId, _this.complexId) || other.complexId == _this.complexId)&&(identical(other.languageCode, _this.languageCode) || other.languageCode == _this.languageCode)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&(identical(other.isLoadingMore, _this.isLoadingMore) || other.isLoadingMore == _this.isLoadingMore)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&const DeepCollectionEquality().equals(other.availableCategories, _this.availableCategories)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as ComplexMembersState;
  return Object.hash(runtimeType,_this.complexId,_this.languageCode,_this.status,const DeepCollectionEquality().hash(_this.items),_this.total,_this.nextCursor,_this.isLoadingMore,const DeepCollectionEquality().hash(_this.categories),const DeepCollectionEquality().hash(_this.availableCategories),_this.failure);
}

@override
String toString() {
  final _this = this as ComplexMembersState;
  return 'ComplexMembersState(complexId: ${_this.complexId}, languageCode: ${_this.languageCode}, status: ${_this.status}, items: ${_this.items}, total: ${_this.total}, nextCursor: ${_this.nextCursor}, isLoadingMore: ${_this.isLoadingMore}, categories: ${_this.categories}, availableCategories: ${_this.availableCategories}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $ComplexMembersStateCopyWith<$Res>  {
  factory $ComplexMembersStateCopyWith(ComplexMembersState value, $Res Function(ComplexMembersState) _then) = _$ComplexMembersStateCopyWithImpl;
@useResult
$Res call({
 String? complexId, String languageCode, ComplexMembersStatus status, List<MonumentSummary> items, int total, String? nextCursor, bool isLoadingMore, Set<MonumentCategory> categories, List<MonumentCategory> availableCategories, Failure? failure
});




}
/// @nodoc
class _$ComplexMembersStateCopyWithImpl<$Res>
    implements $ComplexMembersStateCopyWith<$Res> {
  _$ComplexMembersStateCopyWithImpl(this._self, this._then);

  final ComplexMembersState _self;
  final $Res Function(ComplexMembersState) _then;

/// Create a copy of ComplexMembersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? complexId = freezed,Object? languageCode = null,Object? status = null,Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? isLoadingMore = null,Object? categories = null,Object? availableCategories = null,Object? failure = freezed,}) {
  return _then(ComplexMembersState(
complexId: freezed == complexId ? _self.complexId : complexId // ignore: cast_nullable_to_non_nullable
as String?,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ComplexMembersStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MonumentSummary>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as Set<MonumentCategory>,availableCategories: null == availableCategories ? _self.availableCategories : availableCategories // ignore: cast_nullable_to_non_nullable
as List<MonumentCategory>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ComplexMembersState].
extension ComplexMembersStatePatterns on ComplexMembersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComplexMembersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComplexMembersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComplexMembersState value)  $default,){
final _that = this;
switch (_that) {
case _ComplexMembersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComplexMembersState value)?  $default,){
final _that = this;
switch (_that) {
case _ComplexMembersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? complexId,  String languageCode,  ComplexMembersStatus status,  List<MonumentSummary> items,  int total,  String? nextCursor,  bool isLoadingMore,  Set<MonumentCategory> categories,  List<MonumentCategory> availableCategories,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComplexMembersState() when $default != null:
return $default(_that.complexId,_that.languageCode,_that.status,_that.items,_that.total,_that.nextCursor,_that.isLoadingMore,_that.categories,_that.availableCategories,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? complexId,  String languageCode,  ComplexMembersStatus status,  List<MonumentSummary> items,  int total,  String? nextCursor,  bool isLoadingMore,  Set<MonumentCategory> categories,  List<MonumentCategory> availableCategories,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ComplexMembersState():
return $default(_that.complexId,_that.languageCode,_that.status,_that.items,_that.total,_that.nextCursor,_that.isLoadingMore,_that.categories,_that.availableCategories,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? complexId,  String languageCode,  ComplexMembersStatus status,  List<MonumentSummary> items,  int total,  String? nextCursor,  bool isLoadingMore,  Set<MonumentCategory> categories,  List<MonumentCategory> availableCategories,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ComplexMembersState() when $default != null:
return $default(_that.complexId,_that.languageCode,_that.status,_that.items,_that.total,_that.nextCursor,_that.isLoadingMore,_that.categories,_that.availableCategories,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ComplexMembersState extends ComplexMembersState {
  const _ComplexMembersState({this.complexId, this.languageCode = 'tr', this.status = ComplexMembersStatus.initial,  List<MonumentSummary> items = const <MonumentSummary>[], this.total = 0, this.nextCursor, this.isLoadingMore = false,  Set<MonumentCategory> categories = const <MonumentCategory>{},  List<MonumentCategory> availableCategories = const <MonumentCategory>[], this.failure}): _items = items,_categories = categories,_availableCategories = availableCategories,super._();
  

@override final  String? complexId;
@override@JsonKey() final  String languageCode;
@override@JsonKey() final  ComplexMembersStatus status;
 final  List<MonumentSummary> _items;
@override@JsonKey() List<MonumentSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int total;
@override final  String? nextCursor;
@override@JsonKey() final  bool isLoadingMore;
/// Seçili türler; boş → tümü.
 final  Set<MonumentCategory> _categories;
/// Seçili türler; boş → tümü.
@override@JsonKey() Set<MonumentCategory> get categories {
  if (_categories is EqualUnmodifiableSetView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_categories);
}

/// Çip olarak sunulan türler (külliyede bulunanlar).
 final  List<MonumentCategory> _availableCategories;
/// Çip olarak sunulan türler (külliyede bulunanlar).
@override@JsonKey() List<MonumentCategory> get availableCategories {
  if (_availableCategories is EqualUnmodifiableListView) return _availableCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableCategories);
}

/// İlk sayfa hatası ([status] failure) veya sonraki sayfa hatası.
@override final  Failure? failure;

/// Create a copy of ComplexMembersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplexMembersStateCopyWith<_ComplexMembersState> get copyWith => __$ComplexMembersStateCopyWithImpl<_ComplexMembersState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComplexMembersState&&(identical(other.complexId, complexId) || other.complexId == complexId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&const DeepCollectionEquality().equals(other.categories, _categories)&&const DeepCollectionEquality().equals(other.availableCategories, _availableCategories)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,complexId,languageCode,status,const DeepCollectionEquality().hash(_items),total,nextCursor,isLoadingMore,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_availableCategories),failure);
}

@override
String toString() {
    return 'ComplexMembersState(complexId: $complexId, languageCode: $languageCode, status: $status, items: $items, total: $total, nextCursor: $nextCursor, isLoadingMore: $isLoadingMore, categories: $categories, availableCategories: $availableCategories, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ComplexMembersStateCopyWith<$Res> implements $ComplexMembersStateCopyWith<$Res> {
  factory _$ComplexMembersStateCopyWith(_ComplexMembersState value, $Res Function(_ComplexMembersState) _then) = __$ComplexMembersStateCopyWithImpl;
@override @useResult
$Res call({
 String? complexId, String languageCode, ComplexMembersStatus status, List<MonumentSummary> items, int total, String? nextCursor, bool isLoadingMore, Set<MonumentCategory> categories, List<MonumentCategory> availableCategories, Failure? failure
});




}
/// @nodoc
class __$ComplexMembersStateCopyWithImpl<$Res>
    implements _$ComplexMembersStateCopyWith<$Res> {
  __$ComplexMembersStateCopyWithImpl(this._self, this._then);

  final _ComplexMembersState _self;
  final $Res Function(_ComplexMembersState) _then;

/// Create a copy of ComplexMembersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? complexId = freezed,Object? languageCode = null,Object? status = null,Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? isLoadingMore = null,Object? categories = null,Object? availableCategories = null,Object? failure = freezed,}) {
  return _then(_ComplexMembersState(
complexId: freezed == complexId ? _self.complexId : complexId // ignore: cast_nullable_to_non_nullable
as String?,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ComplexMembersStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MonumentSummary>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as Set<MonumentCategory>,availableCategories: null == availableCategories ? _self._availableCategories : availableCategories // ignore: cast_nullable_to_non_nullable
as List<MonumentCategory>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
