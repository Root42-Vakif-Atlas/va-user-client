// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_memories_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyMemoriesState {

 MyMemoriesStatus get status;/// En son paylaşılan önce.
 List<Memory> get items; int get total; String? get nextCursor; Failure? get failure; bool get isLoadingMore; Failure? get loadMoreFailure;/// Eser kimliği → arayüz dilindeki adı (katalogdan çözülür).
 Map<String, String> get monumentNames;/// Silme isteği süren anılar.
 Set<String> get busyIds; MemoryNotice? get notice;/// Her yeni bildirimde artar.
 int get noticeCount;
/// Create a copy of MyMemoriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyMemoriesStateCopyWith<MyMemoriesState> get copyWith => _$MyMemoriesStateCopyWithImpl<MyMemoriesState>(this as MyMemoriesState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MyMemoriesState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyMemoriesState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.isLoadingMore, _this.isLoadingMore) || other.isLoadingMore == _this.isLoadingMore)&&(identical(other.loadMoreFailure, _this.loadMoreFailure) || other.loadMoreFailure == _this.loadMoreFailure)&&const DeepCollectionEquality().equals(other.monumentNames, _this.monumentNames)&&const DeepCollectionEquality().equals(other.busyIds, _this.busyIds)&&(identical(other.notice, _this.notice) || other.notice == _this.notice)&&(identical(other.noticeCount, _this.noticeCount) || other.noticeCount == _this.noticeCount));
}


@override
int get hashCode {
  final _this = this as MyMemoriesState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.items),_this.total,_this.nextCursor,_this.failure,_this.isLoadingMore,_this.loadMoreFailure,const DeepCollectionEquality().hash(_this.monumentNames),const DeepCollectionEquality().hash(_this.busyIds),_this.notice,_this.noticeCount);
}



}

/// @nodoc
abstract mixin class $MyMemoriesStateCopyWith<$Res>  {
  factory $MyMemoriesStateCopyWith(MyMemoriesState value, $Res Function(MyMemoriesState) _then) = _$MyMemoriesStateCopyWithImpl;
@useResult
$Res call({
 MyMemoriesStatus status, List<Memory> items, int total, String? nextCursor, Failure? failure, bool isLoadingMore, Failure? loadMoreFailure, Map<String, String> monumentNames, Set<String> busyIds, MemoryNotice? notice, int noticeCount
});




}
/// @nodoc
class _$MyMemoriesStateCopyWithImpl<$Res>
    implements $MyMemoriesStateCopyWith<$Res> {
  _$MyMemoriesStateCopyWithImpl(this._self, this._then);

  final MyMemoriesState _self;
  final $Res Function(MyMemoriesState) _then;

/// Create a copy of MyMemoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? failure = freezed,Object? isLoadingMore = null,Object? loadMoreFailure = freezed,Object? monumentNames = null,Object? busyIds = null,Object? notice = freezed,Object? noticeCount = null,}) {
  return _then(MyMemoriesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MyMemoriesStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Memory>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,monumentNames: null == monumentNames ? _self.monumentNames : monumentNames // ignore: cast_nullable_to_non_nullable
as Map<String, String>,busyIds: null == busyIds ? _self.busyIds : busyIds // ignore: cast_nullable_to_non_nullable
as Set<String>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as MemoryNotice?,noticeCount: null == noticeCount ? _self.noticeCount : noticeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MyMemoriesState].
extension MyMemoriesStatePatterns on MyMemoriesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyMemoriesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyMemoriesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyMemoriesState value)  $default,){
final _that = this;
switch (_that) {
case _MyMemoriesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyMemoriesState value)?  $default,){
final _that = this;
switch (_that) {
case _MyMemoriesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MyMemoriesStatus status,  List<Memory> items,  int total,  String? nextCursor,  Failure? failure,  bool isLoadingMore,  Failure? loadMoreFailure,  Map<String, String> monumentNames,  Set<String> busyIds,  MemoryNotice? notice,  int noticeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyMemoriesState() when $default != null:
return $default(_that.status,_that.items,_that.total,_that.nextCursor,_that.failure,_that.isLoadingMore,_that.loadMoreFailure,_that.monumentNames,_that.busyIds,_that.notice,_that.noticeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MyMemoriesStatus status,  List<Memory> items,  int total,  String? nextCursor,  Failure? failure,  bool isLoadingMore,  Failure? loadMoreFailure,  Map<String, String> monumentNames,  Set<String> busyIds,  MemoryNotice? notice,  int noticeCount)  $default,) {final _that = this;
switch (_that) {
case _MyMemoriesState():
return $default(_that.status,_that.items,_that.total,_that.nextCursor,_that.failure,_that.isLoadingMore,_that.loadMoreFailure,_that.monumentNames,_that.busyIds,_that.notice,_that.noticeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MyMemoriesStatus status,  List<Memory> items,  int total,  String? nextCursor,  Failure? failure,  bool isLoadingMore,  Failure? loadMoreFailure,  Map<String, String> monumentNames,  Set<String> busyIds,  MemoryNotice? notice,  int noticeCount)?  $default,) {final _that = this;
switch (_that) {
case _MyMemoriesState() when $default != null:
return $default(_that.status,_that.items,_that.total,_that.nextCursor,_that.failure,_that.isLoadingMore,_that.loadMoreFailure,_that.monumentNames,_that.busyIds,_that.notice,_that.noticeCount);case _:
  return null;

}
}

}

/// @nodoc


class _MyMemoriesState extends MyMemoriesState {
  const _MyMemoriesState({this.status = MyMemoriesStatus.loading,  List<Memory> items = const <Memory>[], this.total = 0, this.nextCursor, this.failure, this.isLoadingMore = false, this.loadMoreFailure,  Map<String, String> monumentNames = const <String, String>{},  Set<String> busyIds = const <String>{}, this.notice, this.noticeCount = 0}): _items = items,_monumentNames = monumentNames,_busyIds = busyIds,super._();
  

@override@JsonKey() final  MyMemoriesStatus status;
/// En son paylaşılan önce.
 final  List<Memory> _items;
/// En son paylaşılan önce.
@override@JsonKey() List<Memory> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int total;
@override final  String? nextCursor;
@override final  Failure? failure;
@override@JsonKey() final  bool isLoadingMore;
@override final  Failure? loadMoreFailure;
/// Eser kimliği → arayüz dilindeki adı (katalogdan çözülür).
 final  Map<String, String> _monumentNames;
/// Eser kimliği → arayüz dilindeki adı (katalogdan çözülür).
@override@JsonKey() Map<String, String> get monumentNames {
  if (_monumentNames is EqualUnmodifiableMapView) return _monumentNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_monumentNames);
}

/// Silme isteği süren anılar.
 final  Set<String> _busyIds;
/// Silme isteği süren anılar.
@override@JsonKey() Set<String> get busyIds {
  if (_busyIds is EqualUnmodifiableSetView) return _busyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_busyIds);
}

@override final  MemoryNotice? notice;
/// Her yeni bildirimde artar.
@override@JsonKey() final  int noticeCount;

/// Create a copy of MyMemoriesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyMemoriesStateCopyWith<_MyMemoriesState> get copyWith => __$MyMemoriesStateCopyWithImpl<_MyMemoriesState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyMemoriesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreFailure, loadMoreFailure) || other.loadMoreFailure == loadMoreFailure)&&const DeepCollectionEquality().equals(other.monumentNames, _monumentNames)&&const DeepCollectionEquality().equals(other.busyIds, _busyIds)&&(identical(other.notice, notice) || other.notice == notice)&&(identical(other.noticeCount, noticeCount) || other.noticeCount == noticeCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),total,nextCursor,failure,isLoadingMore,loadMoreFailure,const DeepCollectionEquality().hash(_monumentNames),const DeepCollectionEquality().hash(_busyIds),notice,noticeCount);
}



}

/// @nodoc
abstract mixin class _$MyMemoriesStateCopyWith<$Res> implements $MyMemoriesStateCopyWith<$Res> {
  factory _$MyMemoriesStateCopyWith(_MyMemoriesState value, $Res Function(_MyMemoriesState) _then) = __$MyMemoriesStateCopyWithImpl;
@override @useResult
$Res call({
 MyMemoriesStatus status, List<Memory> items, int total, String? nextCursor, Failure? failure, bool isLoadingMore, Failure? loadMoreFailure, Map<String, String> monumentNames, Set<String> busyIds, MemoryNotice? notice, int noticeCount
});




}
/// @nodoc
class __$MyMemoriesStateCopyWithImpl<$Res>
    implements _$MyMemoriesStateCopyWith<$Res> {
  __$MyMemoriesStateCopyWithImpl(this._self, this._then);

  final _MyMemoriesState _self;
  final $Res Function(_MyMemoriesState) _then;

/// Create a copy of MyMemoriesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? failure = freezed,Object? isLoadingMore = null,Object? loadMoreFailure = freezed,Object? monumentNames = null,Object? busyIds = null,Object? notice = freezed,Object? noticeCount = null,}) {
  return _then(_MyMemoriesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MyMemoriesStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Memory>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,monumentNames: null == monumentNames ? _self._monumentNames : monumentNames // ignore: cast_nullable_to_non_nullable
as Map<String, String>,busyIds: null == busyIds ? _self._busyIds : busyIds // ignore: cast_nullable_to_non_nullable
as Set<String>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as MemoryNotice?,noticeCount: null == noticeCount ? _self.noticeCount : noticeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
