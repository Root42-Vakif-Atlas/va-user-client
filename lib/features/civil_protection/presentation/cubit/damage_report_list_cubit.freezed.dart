// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'damage_report_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DamageReportListState {

 DamageReportListStatus get status; String get languageCode; List<DamageReport> get items; int get total; String? get nextCursor; Failure? get failure; bool get isLoadingMore; Failure? get loadMoreFailure;
/// Create a copy of DamageReportListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DamageReportListStateCopyWith<DamageReportListState> get copyWith => _$DamageReportListStateCopyWithImpl<DamageReportListState>(this as DamageReportListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DamageReportListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DamageReportListState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.languageCode, _this.languageCode) || other.languageCode == _this.languageCode)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.isLoadingMore, _this.isLoadingMore) || other.isLoadingMore == _this.isLoadingMore)&&(identical(other.loadMoreFailure, _this.loadMoreFailure) || other.loadMoreFailure == _this.loadMoreFailure));
}


@override
int get hashCode {
  final _this = this as DamageReportListState;
  return Object.hash(runtimeType,_this.status,_this.languageCode,const DeepCollectionEquality().hash(_this.items),_this.total,_this.nextCursor,_this.failure,_this.isLoadingMore,_this.loadMoreFailure);
}

@override
String toString() {
  final _this = this as DamageReportListState;
  return 'DamageReportListState(status: ${_this.status}, languageCode: ${_this.languageCode}, items: ${_this.items}, total: ${_this.total}, nextCursor: ${_this.nextCursor}, failure: ${_this.failure}, isLoadingMore: ${_this.isLoadingMore}, loadMoreFailure: ${_this.loadMoreFailure})';
}


}

/// @nodoc
abstract mixin class $DamageReportListStateCopyWith<$Res>  {
  factory $DamageReportListStateCopyWith(DamageReportListState value, $Res Function(DamageReportListState) _then) = _$DamageReportListStateCopyWithImpl;
@useResult
$Res call({
 DamageReportListStatus status, String languageCode, List<DamageReport> items, int total, String? nextCursor, Failure? failure, bool isLoadingMore, Failure? loadMoreFailure
});




}
/// @nodoc
class _$DamageReportListStateCopyWithImpl<$Res>
    implements $DamageReportListStateCopyWith<$Res> {
  _$DamageReportListStateCopyWithImpl(this._self, this._then);

  final DamageReportListState _self;
  final $Res Function(DamageReportListState) _then;

/// Create a copy of DamageReportListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? languageCode = null,Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? failure = freezed,Object? isLoadingMore = null,Object? loadMoreFailure = freezed,}) {
  return _then(DamageReportListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DamageReportListStatus,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DamageReport>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [DamageReportListState].
extension DamageReportListStatePatterns on DamageReportListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DamageReportListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DamageReportListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DamageReportListState value)  $default,){
final _that = this;
switch (_that) {
case _DamageReportListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DamageReportListState value)?  $default,){
final _that = this;
switch (_that) {
case _DamageReportListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DamageReportListStatus status,  String languageCode,  List<DamageReport> items,  int total,  String? nextCursor,  Failure? failure,  bool isLoadingMore,  Failure? loadMoreFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DamageReportListState() when $default != null:
return $default(_that.status,_that.languageCode,_that.items,_that.total,_that.nextCursor,_that.failure,_that.isLoadingMore,_that.loadMoreFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DamageReportListStatus status,  String languageCode,  List<DamageReport> items,  int total,  String? nextCursor,  Failure? failure,  bool isLoadingMore,  Failure? loadMoreFailure)  $default,) {final _that = this;
switch (_that) {
case _DamageReportListState():
return $default(_that.status,_that.languageCode,_that.items,_that.total,_that.nextCursor,_that.failure,_that.isLoadingMore,_that.loadMoreFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DamageReportListStatus status,  String languageCode,  List<DamageReport> items,  int total,  String? nextCursor,  Failure? failure,  bool isLoadingMore,  Failure? loadMoreFailure)?  $default,) {final _that = this;
switch (_that) {
case _DamageReportListState() when $default != null:
return $default(_that.status,_that.languageCode,_that.items,_that.total,_that.nextCursor,_that.failure,_that.isLoadingMore,_that.loadMoreFailure);case _:
  return null;

}
}

}

/// @nodoc


class _DamageReportListState extends DamageReportListState {
  const _DamageReportListState({this.status = DamageReportListStatus.initial, this.languageCode = 'tr',  List<DamageReport> items = const <DamageReport>[], this.total = 0, this.nextCursor, this.failure, this.isLoadingMore = false, this.loadMoreFailure}): _items = items,super._();
  

@override@JsonKey() final  DamageReportListStatus status;
@override@JsonKey() final  String languageCode;
 final  List<DamageReport> _items;
@override@JsonKey() List<DamageReport> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int total;
@override final  String? nextCursor;
@override final  Failure? failure;
@override@JsonKey() final  bool isLoadingMore;
@override final  Failure? loadMoreFailure;

/// Create a copy of DamageReportListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DamageReportListStateCopyWith<_DamageReportListState> get copyWith => __$DamageReportListStateCopyWithImpl<_DamageReportListState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DamageReportListState&&(identical(other.status, status) || other.status == status)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreFailure, loadMoreFailure) || other.loadMoreFailure == loadMoreFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,languageCode,const DeepCollectionEquality().hash(_items),total,nextCursor,failure,isLoadingMore,loadMoreFailure);
}

@override
String toString() {
    return 'DamageReportListState(status: $status, languageCode: $languageCode, items: $items, total: $total, nextCursor: $nextCursor, failure: $failure, isLoadingMore: $isLoadingMore, loadMoreFailure: $loadMoreFailure)';
}


}

/// @nodoc
abstract mixin class _$DamageReportListStateCopyWith<$Res> implements $DamageReportListStateCopyWith<$Res> {
  factory _$DamageReportListStateCopyWith(_DamageReportListState value, $Res Function(_DamageReportListState) _then) = __$DamageReportListStateCopyWithImpl;
@override @useResult
$Res call({
 DamageReportListStatus status, String languageCode, List<DamageReport> items, int total, String? nextCursor, Failure? failure, bool isLoadingMore, Failure? loadMoreFailure
});




}
/// @nodoc
class __$DamageReportListStateCopyWithImpl<$Res>
    implements _$DamageReportListStateCopyWith<$Res> {
  __$DamageReportListStateCopyWithImpl(this._self, this._then);

  final _DamageReportListState _self;
  final $Res Function(_DamageReportListState) _then;

/// Create a copy of DamageReportListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? languageCode = null,Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? failure = freezed,Object? isLoadingMore = null,Object? loadMoreFailure = freezed,}) {
  return _then(_DamageReportListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DamageReportListStatus,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DamageReport>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
