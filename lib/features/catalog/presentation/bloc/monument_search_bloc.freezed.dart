// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monument_search_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonumentSearchEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentSearchEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MonumentSearchEvent()';
}


}

/// @nodoc
class $MonumentSearchEventCopyWith<$Res>  {
$MonumentSearchEventCopyWith(MonumentSearchEvent _, $Res Function(MonumentSearchEvent) __);
}


/// Adds pattern-matching-related methods to [MonumentSearchEvent].
extension MonumentSearchEventPatterns on MonumentSearchEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MonumentSearchStarted value)?  started,TResult Function( MonumentSearchQueryChanged value)?  queryChanged,TResult Function( MonumentSearchNextPageRequested value)?  nextPageRequested,TResult Function( MonumentSearchRetryRequested value)?  retryRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MonumentSearchStarted() when started != null:
return started(_that);case MonumentSearchQueryChanged() when queryChanged != null:
return queryChanged(_that);case MonumentSearchNextPageRequested() when nextPageRequested != null:
return nextPageRequested(_that);case MonumentSearchRetryRequested() when retryRequested != null:
return retryRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MonumentSearchStarted value)  started,required TResult Function( MonumentSearchQueryChanged value)  queryChanged,required TResult Function( MonumentSearchNextPageRequested value)  nextPageRequested,required TResult Function( MonumentSearchRetryRequested value)  retryRequested,}){
final _that = this;
switch (_that) {
case MonumentSearchStarted():
return started(_that);case MonumentSearchQueryChanged():
return queryChanged(_that);case MonumentSearchNextPageRequested():
return nextPageRequested(_that);case MonumentSearchRetryRequested():
return retryRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MonumentSearchStarted value)?  started,TResult? Function( MonumentSearchQueryChanged value)?  queryChanged,TResult? Function( MonumentSearchNextPageRequested value)?  nextPageRequested,TResult? Function( MonumentSearchRetryRequested value)?  retryRequested,}){
final _that = this;
switch (_that) {
case MonumentSearchStarted() when started != null:
return started(_that);case MonumentSearchQueryChanged() when queryChanged != null:
return queryChanged(_that);case MonumentSearchNextPageRequested() when nextPageRequested != null:
return nextPageRequested(_that);case MonumentSearchRetryRequested() when retryRequested != null:
return retryRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String languageCode,  MonumentSearchQuery query)?  started,TResult Function( MonumentSearchQuery query)?  queryChanged,TResult Function()?  nextPageRequested,TResult Function()?  retryRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MonumentSearchStarted() when started != null:
return started(_that.languageCode,_that.query);case MonumentSearchQueryChanged() when queryChanged != null:
return queryChanged(_that.query);case MonumentSearchNextPageRequested() when nextPageRequested != null:
return nextPageRequested();case MonumentSearchRetryRequested() when retryRequested != null:
return retryRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String languageCode,  MonumentSearchQuery query)  started,required TResult Function( MonumentSearchQuery query)  queryChanged,required TResult Function()  nextPageRequested,required TResult Function()  retryRequested,}) {final _that = this;
switch (_that) {
case MonumentSearchStarted():
return started(_that.languageCode,_that.query);case MonumentSearchQueryChanged():
return queryChanged(_that.query);case MonumentSearchNextPageRequested():
return nextPageRequested();case MonumentSearchRetryRequested():
return retryRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String languageCode,  MonumentSearchQuery query)?  started,TResult? Function( MonumentSearchQuery query)?  queryChanged,TResult? Function()?  nextPageRequested,TResult? Function()?  retryRequested,}) {final _that = this;
switch (_that) {
case MonumentSearchStarted() when started != null:
return started(_that.languageCode,_that.query);case MonumentSearchQueryChanged() when queryChanged != null:
return queryChanged(_that.query);case MonumentSearchNextPageRequested() when nextPageRequested != null:
return nextPageRequested();case MonumentSearchRetryRequested() when retryRequested != null:
return retryRequested();case _:
  return null;

}
}

}

/// @nodoc


class MonumentSearchStarted implements MonumentSearchEvent {
  const MonumentSearchStarted({required this.languageCode, this.query = MonumentSearchQuery.empty});
  

 final  String languageCode;
@JsonKey() final  MonumentSearchQuery query;

/// Create a copy of MonumentSearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentSearchStartedCopyWith<MonumentSearchStarted> get copyWith => _$MonumentSearchStartedCopyWithImpl<MonumentSearchStarted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentSearchStarted&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,languageCode,query);
}

@override
String toString() {
    return 'MonumentSearchEvent.started(languageCode: $languageCode, query: $query)';
}


}

/// @nodoc
abstract mixin class $MonumentSearchStartedCopyWith<$Res> implements $MonumentSearchEventCopyWith<$Res> {
  factory $MonumentSearchStartedCopyWith(MonumentSearchStarted value, $Res Function(MonumentSearchStarted) _then) = _$MonumentSearchStartedCopyWithImpl;
@useResult
$Res call({
 String languageCode, MonumentSearchQuery query
});




}
/// @nodoc
class _$MonumentSearchStartedCopyWithImpl<$Res>
    implements $MonumentSearchStartedCopyWith<$Res> {
  _$MonumentSearchStartedCopyWithImpl(this._self, this._then);

  final MonumentSearchStarted _self;
  final $Res Function(MonumentSearchStarted) _then;

/// Create a copy of MonumentSearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? languageCode = null,Object? query = null,}) {
  return _then(MonumentSearchStarted(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as MonumentSearchQuery,
  ));
}


}

/// @nodoc


class MonumentSearchQueryChanged implements MonumentSearchEvent {
  const MonumentSearchQueryChanged(this.query);
  

 final  MonumentSearchQuery query;

/// Create a copy of MonumentSearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentSearchQueryChangedCopyWith<MonumentSearchQueryChanged> get copyWith => _$MonumentSearchQueryChangedCopyWithImpl<MonumentSearchQueryChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentSearchQueryChanged&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query);
}

@override
String toString() {
    return 'MonumentSearchEvent.queryChanged(query: $query)';
}


}

/// @nodoc
abstract mixin class $MonumentSearchQueryChangedCopyWith<$Res> implements $MonumentSearchEventCopyWith<$Res> {
  factory $MonumentSearchQueryChangedCopyWith(MonumentSearchQueryChanged value, $Res Function(MonumentSearchQueryChanged) _then) = _$MonumentSearchQueryChangedCopyWithImpl;
@useResult
$Res call({
 MonumentSearchQuery query
});




}
/// @nodoc
class _$MonumentSearchQueryChangedCopyWithImpl<$Res>
    implements $MonumentSearchQueryChangedCopyWith<$Res> {
  _$MonumentSearchQueryChangedCopyWithImpl(this._self, this._then);

  final MonumentSearchQueryChanged _self;
  final $Res Function(MonumentSearchQueryChanged) _then;

/// Create a copy of MonumentSearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(MonumentSearchQueryChanged(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as MonumentSearchQuery,
  ));
}


}

/// @nodoc


class MonumentSearchNextPageRequested implements MonumentSearchEvent {
  const MonumentSearchNextPageRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentSearchNextPageRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MonumentSearchEvent.nextPageRequested()';
}


}




/// @nodoc


class MonumentSearchRetryRequested implements MonumentSearchEvent {
  const MonumentSearchRetryRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentSearchRetryRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MonumentSearchEvent.retryRequested()';
}


}




/// @nodoc
mixin _$MonumentSearchState {

 String get languageCode; MonumentSearchQuery get query; MonumentSearchStatus get status;/// Şimdiye kadar yüklenen sayfaların eserleri.
 List<MonumentSummary> get items;/// Sorguya uyan toplam eser sayısı (sunucu).
 int get total; String? get nextCursor; List<MonumentPlace> get places; MonumentFacets get facets; bool get isLoadingMore;/// Son yüklenen sayfadaki kayıt sayısı (ekran okuyucu duyurusu).
 int get lastPageSize;/// İlk sayfa hatası.
 Failure? get failure;/// Sonraki sayfa hatası; liste korunur, altta tekrar dene gösterilir.
 Failure? get loadMoreFailure;
/// Create a copy of MonumentSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonumentSearchStateCopyWith<MonumentSearchState> get copyWith => _$MonumentSearchStateCopyWithImpl<MonumentSearchState>(this as MonumentSearchState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MonumentSearchState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonumentSearchState&&(identical(other.languageCode, _this.languageCode) || other.languageCode == _this.languageCode)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&const DeepCollectionEquality().equals(other.places, _this.places)&&(identical(other.facets, _this.facets) || other.facets == _this.facets)&&(identical(other.isLoadingMore, _this.isLoadingMore) || other.isLoadingMore == _this.isLoadingMore)&&(identical(other.lastPageSize, _this.lastPageSize) || other.lastPageSize == _this.lastPageSize)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.loadMoreFailure, _this.loadMoreFailure) || other.loadMoreFailure == _this.loadMoreFailure));
}


@override
int get hashCode {
  final _this = this as MonumentSearchState;
  return Object.hash(runtimeType,_this.languageCode,_this.query,_this.status,const DeepCollectionEquality().hash(_this.items),_this.total,_this.nextCursor,const DeepCollectionEquality().hash(_this.places),_this.facets,_this.isLoadingMore,_this.lastPageSize,_this.failure,_this.loadMoreFailure);
}

@override
String toString() {
  final _this = this as MonumentSearchState;
  return 'MonumentSearchState(languageCode: ${_this.languageCode}, query: ${_this.query}, status: ${_this.status}, items: ${_this.items}, total: ${_this.total}, nextCursor: ${_this.nextCursor}, places: ${_this.places}, facets: ${_this.facets}, isLoadingMore: ${_this.isLoadingMore}, lastPageSize: ${_this.lastPageSize}, failure: ${_this.failure}, loadMoreFailure: ${_this.loadMoreFailure})';
}


}

/// @nodoc
abstract mixin class $MonumentSearchStateCopyWith<$Res>  {
  factory $MonumentSearchStateCopyWith(MonumentSearchState value, $Res Function(MonumentSearchState) _then) = _$MonumentSearchStateCopyWithImpl;
@useResult
$Res call({
 String languageCode, MonumentSearchQuery query, MonumentSearchStatus status, List<MonumentSummary> items, int total, String? nextCursor, List<MonumentPlace> places, MonumentFacets facets, bool isLoadingMore, int lastPageSize, Failure? failure, Failure? loadMoreFailure
});




}
/// @nodoc
class _$MonumentSearchStateCopyWithImpl<$Res>
    implements $MonumentSearchStateCopyWith<$Res> {
  _$MonumentSearchStateCopyWithImpl(this._self, this._then);

  final MonumentSearchState _self;
  final $Res Function(MonumentSearchState) _then;

/// Create a copy of MonumentSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? languageCode = null,Object? query = null,Object? status = null,Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? places = null,Object? facets = null,Object? isLoadingMore = null,Object? lastPageSize = null,Object? failure = freezed,Object? loadMoreFailure = freezed,}) {
  return _then(MonumentSearchState(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as MonumentSearchQuery,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MonumentSearchStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MonumentSummary>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,places: null == places ? _self.places : places // ignore: cast_nullable_to_non_nullable
as List<MonumentPlace>,facets: null == facets ? _self.facets : facets // ignore: cast_nullable_to_non_nullable
as MonumentFacets,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,lastPageSize: null == lastPageSize ? _self.lastPageSize : lastPageSize // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [MonumentSearchState].
extension MonumentSearchStatePatterns on MonumentSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonumentSearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonumentSearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonumentSearchState value)  $default,){
final _that = this;
switch (_that) {
case _MonumentSearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonumentSearchState value)?  $default,){
final _that = this;
switch (_that) {
case _MonumentSearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String languageCode,  MonumentSearchQuery query,  MonumentSearchStatus status,  List<MonumentSummary> items,  int total,  String? nextCursor,  List<MonumentPlace> places,  MonumentFacets facets,  bool isLoadingMore,  int lastPageSize,  Failure? failure,  Failure? loadMoreFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonumentSearchState() when $default != null:
return $default(_that.languageCode,_that.query,_that.status,_that.items,_that.total,_that.nextCursor,_that.places,_that.facets,_that.isLoadingMore,_that.lastPageSize,_that.failure,_that.loadMoreFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String languageCode,  MonumentSearchQuery query,  MonumentSearchStatus status,  List<MonumentSummary> items,  int total,  String? nextCursor,  List<MonumentPlace> places,  MonumentFacets facets,  bool isLoadingMore,  int lastPageSize,  Failure? failure,  Failure? loadMoreFailure)  $default,) {final _that = this;
switch (_that) {
case _MonumentSearchState():
return $default(_that.languageCode,_that.query,_that.status,_that.items,_that.total,_that.nextCursor,_that.places,_that.facets,_that.isLoadingMore,_that.lastPageSize,_that.failure,_that.loadMoreFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String languageCode,  MonumentSearchQuery query,  MonumentSearchStatus status,  List<MonumentSummary> items,  int total,  String? nextCursor,  List<MonumentPlace> places,  MonumentFacets facets,  bool isLoadingMore,  int lastPageSize,  Failure? failure,  Failure? loadMoreFailure)?  $default,) {final _that = this;
switch (_that) {
case _MonumentSearchState() when $default != null:
return $default(_that.languageCode,_that.query,_that.status,_that.items,_that.total,_that.nextCursor,_that.places,_that.facets,_that.isLoadingMore,_that.lastPageSize,_that.failure,_that.loadMoreFailure);case _:
  return null;

}
}

}

/// @nodoc


class _MonumentSearchState extends MonumentSearchState {
  const _MonumentSearchState({this.languageCode = 'tr', this.query = MonumentSearchQuery.empty, this.status = MonumentSearchStatus.initial,  List<MonumentSummary> items = const <MonumentSummary>[], this.total = 0, this.nextCursor,  List<MonumentPlace> places = const <MonumentPlace>[], this.facets = MonumentFacets.empty, this.isLoadingMore = false, this.lastPageSize = 0, this.failure, this.loadMoreFailure}): _items = items,_places = places,super._();
  

@override@JsonKey() final  String languageCode;
@override@JsonKey() final  MonumentSearchQuery query;
@override@JsonKey() final  MonumentSearchStatus status;
/// Şimdiye kadar yüklenen sayfaların eserleri.
 final  List<MonumentSummary> _items;
/// Şimdiye kadar yüklenen sayfaların eserleri.
@override@JsonKey() List<MonumentSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Sorguya uyan toplam eser sayısı (sunucu).
@override@JsonKey() final  int total;
@override final  String? nextCursor;
 final  List<MonumentPlace> _places;
@override@JsonKey() List<MonumentPlace> get places {
  if (_places is EqualUnmodifiableListView) return _places;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_places);
}

@override@JsonKey() final  MonumentFacets facets;
@override@JsonKey() final  bool isLoadingMore;
/// Son yüklenen sayfadaki kayıt sayısı (ekran okuyucu duyurusu).
@override@JsonKey() final  int lastPageSize;
/// İlk sayfa hatası.
@override final  Failure? failure;
/// Sonraki sayfa hatası; liste korunur, altta tekrar dene gösterilir.
@override final  Failure? loadMoreFailure;

/// Create a copy of MonumentSearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonumentSearchStateCopyWith<_MonumentSearchState> get copyWith => __$MonumentSearchStateCopyWithImpl<_MonumentSearchState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonumentSearchState&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.query, query) || other.query == query)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&const DeepCollectionEquality().equals(other.places, _places)&&(identical(other.facets, facets) || other.facets == facets)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.lastPageSize, lastPageSize) || other.lastPageSize == lastPageSize)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.loadMoreFailure, loadMoreFailure) || other.loadMoreFailure == loadMoreFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,languageCode,query,status,const DeepCollectionEquality().hash(_items),total,nextCursor,const DeepCollectionEquality().hash(_places),facets,isLoadingMore,lastPageSize,failure,loadMoreFailure);
}

@override
String toString() {
    return 'MonumentSearchState(languageCode: $languageCode, query: $query, status: $status, items: $items, total: $total, nextCursor: $nextCursor, places: $places, facets: $facets, isLoadingMore: $isLoadingMore, lastPageSize: $lastPageSize, failure: $failure, loadMoreFailure: $loadMoreFailure)';
}


}

/// @nodoc
abstract mixin class _$MonumentSearchStateCopyWith<$Res> implements $MonumentSearchStateCopyWith<$Res> {
  factory _$MonumentSearchStateCopyWith(_MonumentSearchState value, $Res Function(_MonumentSearchState) _then) = __$MonumentSearchStateCopyWithImpl;
@override @useResult
$Res call({
 String languageCode, MonumentSearchQuery query, MonumentSearchStatus status, List<MonumentSummary> items, int total, String? nextCursor, List<MonumentPlace> places, MonumentFacets facets, bool isLoadingMore, int lastPageSize, Failure? failure, Failure? loadMoreFailure
});




}
/// @nodoc
class __$MonumentSearchStateCopyWithImpl<$Res>
    implements _$MonumentSearchStateCopyWith<$Res> {
  __$MonumentSearchStateCopyWithImpl(this._self, this._then);

  final _MonumentSearchState _self;
  final $Res Function(_MonumentSearchState) _then;

/// Create a copy of MonumentSearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? languageCode = null,Object? query = null,Object? status = null,Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? places = null,Object? facets = null,Object? isLoadingMore = null,Object? lastPageSize = null,Object? failure = freezed,Object? loadMoreFailure = freezed,}) {
  return _then(_MonumentSearchState(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as MonumentSearchQuery,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MonumentSearchStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MonumentSummary>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,places: null == places ? _self._places : places // ignore: cast_nullable_to_non_nullable
as List<MonumentPlace>,facets: null == facets ? _self.facets : facets // ignore: cast_nullable_to_non_nullable
as MonumentFacets,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,lastPageSize: null == lastPageSize ? _self.lastPageSize : lastPageSize // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
