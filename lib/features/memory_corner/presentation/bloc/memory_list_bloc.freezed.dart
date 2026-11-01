// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_list_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemoryListEvent implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryListEvent'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryListEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryListEvent()';
}


}

/// @nodoc
class $MemoryListEventCopyWith<$Res>  {
$MemoryListEventCopyWith(MemoryListEvent _, $Res Function(MemoryListEvent) __);
}


/// Adds pattern-matching-related methods to [MemoryListEvent].
extension MemoryListEventPatterns on MemoryListEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MemoryListStarted value)?  started,TResult Function( MemoryListRefreshed value)?  refreshed,TResult Function( MemoryListRangeChanged value)?  rangeChanged,TResult Function( MemoryListNextPageRequested value)?  nextPageRequested,TResult Function( MemoryListRetryRequested value)?  retryRequested,TResult Function( MemoryDeleteRequested value)?  deleteRequested,TResult Function( MemoryReportRequested value)?  reportRequested,TResult Function( _MemoryChangeReceived value)?  changeReceived,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MemoryListStarted() when started != null:
return started(_that);case MemoryListRefreshed() when refreshed != null:
return refreshed(_that);case MemoryListRangeChanged() when rangeChanged != null:
return rangeChanged(_that);case MemoryListNextPageRequested() when nextPageRequested != null:
return nextPageRequested(_that);case MemoryListRetryRequested() when retryRequested != null:
return retryRequested(_that);case MemoryDeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case MemoryReportRequested() when reportRequested != null:
return reportRequested(_that);case _MemoryChangeReceived() when changeReceived != null:
return changeReceived(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MemoryListStarted value)  started,required TResult Function( MemoryListRefreshed value)  refreshed,required TResult Function( MemoryListRangeChanged value)  rangeChanged,required TResult Function( MemoryListNextPageRequested value)  nextPageRequested,required TResult Function( MemoryListRetryRequested value)  retryRequested,required TResult Function( MemoryDeleteRequested value)  deleteRequested,required TResult Function( MemoryReportRequested value)  reportRequested,required TResult Function( _MemoryChangeReceived value)  changeReceived,}){
final _that = this;
switch (_that) {
case MemoryListStarted():
return started(_that);case MemoryListRefreshed():
return refreshed(_that);case MemoryListRangeChanged():
return rangeChanged(_that);case MemoryListNextPageRequested():
return nextPageRequested(_that);case MemoryListRetryRequested():
return retryRequested(_that);case MemoryDeleteRequested():
return deleteRequested(_that);case MemoryReportRequested():
return reportRequested(_that);case _MemoryChangeReceived():
return changeReceived(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MemoryListStarted value)?  started,TResult? Function( MemoryListRefreshed value)?  refreshed,TResult? Function( MemoryListRangeChanged value)?  rangeChanged,TResult? Function( MemoryListNextPageRequested value)?  nextPageRequested,TResult? Function( MemoryListRetryRequested value)?  retryRequested,TResult? Function( MemoryDeleteRequested value)?  deleteRequested,TResult? Function( MemoryReportRequested value)?  reportRequested,TResult? Function( _MemoryChangeReceived value)?  changeReceived,}){
final _that = this;
switch (_that) {
case MemoryListStarted() when started != null:
return started(_that);case MemoryListRefreshed() when refreshed != null:
return refreshed(_that);case MemoryListRangeChanged() when rangeChanged != null:
return rangeChanged(_that);case MemoryListNextPageRequested() when nextPageRequested != null:
return nextPageRequested(_that);case MemoryListRetryRequested() when retryRequested != null:
return retryRequested(_that);case MemoryDeleteRequested() when deleteRequested != null:
return deleteRequested(_that);case MemoryReportRequested() when reportRequested != null:
return reportRequested(_that);case _MemoryChangeReceived() when changeReceived != null:
return changeReceived(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String monumentId,  int pageSize)?  started,TResult Function()?  refreshed,TResult Function( MemoryDateRange? range)?  rangeChanged,TResult Function()?  nextPageRequested,TResult Function()?  retryRequested,TResult Function( Memory memory)?  deleteRequested,TResult Function( Memory memory,  MemoryReportReason reason,  String note)?  reportRequested,TResult Function( MemoryChange change)?  changeReceived,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MemoryListStarted() when started != null:
return started(_that.monumentId,_that.pageSize);case MemoryListRefreshed() when refreshed != null:
return refreshed();case MemoryListRangeChanged() when rangeChanged != null:
return rangeChanged(_that.range);case MemoryListNextPageRequested() when nextPageRequested != null:
return nextPageRequested();case MemoryListRetryRequested() when retryRequested != null:
return retryRequested();case MemoryDeleteRequested() when deleteRequested != null:
return deleteRequested(_that.memory);case MemoryReportRequested() when reportRequested != null:
return reportRequested(_that.memory,_that.reason,_that.note);case _MemoryChangeReceived() when changeReceived != null:
return changeReceived(_that.change);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String monumentId,  int pageSize)  started,required TResult Function()  refreshed,required TResult Function( MemoryDateRange? range)  rangeChanged,required TResult Function()  nextPageRequested,required TResult Function()  retryRequested,required TResult Function( Memory memory)  deleteRequested,required TResult Function( Memory memory,  MemoryReportReason reason,  String note)  reportRequested,required TResult Function( MemoryChange change)  changeReceived,}) {final _that = this;
switch (_that) {
case MemoryListStarted():
return started(_that.monumentId,_that.pageSize);case MemoryListRefreshed():
return refreshed();case MemoryListRangeChanged():
return rangeChanged(_that.range);case MemoryListNextPageRequested():
return nextPageRequested();case MemoryListRetryRequested():
return retryRequested();case MemoryDeleteRequested():
return deleteRequested(_that.memory);case MemoryReportRequested():
return reportRequested(_that.memory,_that.reason,_that.note);case _MemoryChangeReceived():
return changeReceived(_that.change);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String monumentId,  int pageSize)?  started,TResult? Function()?  refreshed,TResult? Function( MemoryDateRange? range)?  rangeChanged,TResult? Function()?  nextPageRequested,TResult? Function()?  retryRequested,TResult? Function( Memory memory)?  deleteRequested,TResult? Function( Memory memory,  MemoryReportReason reason,  String note)?  reportRequested,TResult? Function( MemoryChange change)?  changeReceived,}) {final _that = this;
switch (_that) {
case MemoryListStarted() when started != null:
return started(_that.monumentId,_that.pageSize);case MemoryListRefreshed() when refreshed != null:
return refreshed();case MemoryListRangeChanged() when rangeChanged != null:
return rangeChanged(_that.range);case MemoryListNextPageRequested() when nextPageRequested != null:
return nextPageRequested();case MemoryListRetryRequested() when retryRequested != null:
return retryRequested();case MemoryDeleteRequested() when deleteRequested != null:
return deleteRequested(_that.memory);case MemoryReportRequested() when reportRequested != null:
return reportRequested(_that.memory,_that.reason,_that.note);case _MemoryChangeReceived() when changeReceived != null:
return changeReceived(_that.change);case _:
  return null;

}
}

}

/// @nodoc


class MemoryListStarted with DiagnosticableTreeMixin implements MemoryListEvent {
  const MemoryListStarted({required this.monumentId, required this.pageSize});
  

 final  String monumentId;
 final  int pageSize;

/// Create a copy of MemoryListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryListStartedCopyWith<MemoryListStarted> get copyWith => _$MemoryListStartedCopyWithImpl<MemoryListStarted>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryListEvent.started'))
    ..add(DiagnosticsProperty('monumentId', monumentId))..add(DiagnosticsProperty('pageSize', pageSize));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryListStarted&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}


@override
int get hashCode {
    return Object.hash(runtimeType,monumentId,pageSize);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryListEvent.started(monumentId: $monumentId, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $MemoryListStartedCopyWith<$Res> implements $MemoryListEventCopyWith<$Res> {
  factory $MemoryListStartedCopyWith(MemoryListStarted value, $Res Function(MemoryListStarted) _then) = _$MemoryListStartedCopyWithImpl;
@useResult
$Res call({
 String monumentId, int pageSize
});




}
/// @nodoc
class _$MemoryListStartedCopyWithImpl<$Res>
    implements $MemoryListStartedCopyWith<$Res> {
  _$MemoryListStartedCopyWithImpl(this._self, this._then);

  final MemoryListStarted _self;
  final $Res Function(MemoryListStarted) _then;

/// Create a copy of MemoryListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? monumentId = null,Object? pageSize = null,}) {
  return _then(MemoryListStarted(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class MemoryListRefreshed with DiagnosticableTreeMixin implements MemoryListEvent {
  const MemoryListRefreshed();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryListEvent.refreshed'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryListRefreshed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryListEvent.refreshed()';
}


}




/// @nodoc


class MemoryListRangeChanged with DiagnosticableTreeMixin implements MemoryListEvent {
  const MemoryListRangeChanged(this.range);
  

 final  MemoryDateRange? range;

/// Create a copy of MemoryListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryListRangeChangedCopyWith<MemoryListRangeChanged> get copyWith => _$MemoryListRangeChangedCopyWithImpl<MemoryListRangeChanged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryListEvent.rangeChanged'))
    ..add(DiagnosticsProperty('range', range));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryListRangeChanged&&(identical(other.range, range) || other.range == range));
}


@override
int get hashCode {
    return Object.hash(runtimeType,range);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryListEvent.rangeChanged(range: $range)';
}


}

/// @nodoc
abstract mixin class $MemoryListRangeChangedCopyWith<$Res> implements $MemoryListEventCopyWith<$Res> {
  factory $MemoryListRangeChangedCopyWith(MemoryListRangeChanged value, $Res Function(MemoryListRangeChanged) _then) = _$MemoryListRangeChangedCopyWithImpl;
@useResult
$Res call({
 MemoryDateRange? range
});




}
/// @nodoc
class _$MemoryListRangeChangedCopyWithImpl<$Res>
    implements $MemoryListRangeChangedCopyWith<$Res> {
  _$MemoryListRangeChangedCopyWithImpl(this._self, this._then);

  final MemoryListRangeChanged _self;
  final $Res Function(MemoryListRangeChanged) _then;

/// Create a copy of MemoryListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? range = freezed,}) {
  return _then(MemoryListRangeChanged(
freezed == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as MemoryDateRange?,
  ));
}


}

/// @nodoc


class MemoryListNextPageRequested with DiagnosticableTreeMixin implements MemoryListEvent {
  const MemoryListNextPageRequested();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryListEvent.nextPageRequested'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryListNextPageRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryListEvent.nextPageRequested()';
}


}




/// @nodoc


class MemoryListRetryRequested with DiagnosticableTreeMixin implements MemoryListEvent {
  const MemoryListRetryRequested();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryListEvent.retryRequested'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryListRetryRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryListEvent.retryRequested()';
}


}




/// @nodoc


class MemoryDeleteRequested with DiagnosticableTreeMixin implements MemoryListEvent {
  const MemoryDeleteRequested(this.memory);
  

 final  Memory memory;

/// Create a copy of MemoryListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryDeleteRequestedCopyWith<MemoryDeleteRequested> get copyWith => _$MemoryDeleteRequestedCopyWithImpl<MemoryDeleteRequested>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryListEvent.deleteRequested'))
    ..add(DiagnosticsProperty('memory', memory));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryDeleteRequested&&(identical(other.memory, memory) || other.memory == memory));
}


@override
int get hashCode {
    return Object.hash(runtimeType,memory);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryListEvent.deleteRequested(memory: $memory)';
}


}

/// @nodoc
abstract mixin class $MemoryDeleteRequestedCopyWith<$Res> implements $MemoryListEventCopyWith<$Res> {
  factory $MemoryDeleteRequestedCopyWith(MemoryDeleteRequested value, $Res Function(MemoryDeleteRequested) _then) = _$MemoryDeleteRequestedCopyWithImpl;
@useResult
$Res call({
 Memory memory
});




}
/// @nodoc
class _$MemoryDeleteRequestedCopyWithImpl<$Res>
    implements $MemoryDeleteRequestedCopyWith<$Res> {
  _$MemoryDeleteRequestedCopyWithImpl(this._self, this._then);

  final MemoryDeleteRequested _self;
  final $Res Function(MemoryDeleteRequested) _then;

/// Create a copy of MemoryListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? memory = null,}) {
  return _then(MemoryDeleteRequested(
null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as Memory,
  ));
}


}

/// @nodoc


class MemoryReportRequested with DiagnosticableTreeMixin implements MemoryListEvent {
  const MemoryReportRequested({required this.memory, required this.reason, this.note = ''});
  

 final  Memory memory;
 final  MemoryReportReason reason;
@JsonKey() final  String note;

/// Create a copy of MemoryListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryReportRequestedCopyWith<MemoryReportRequested> get copyWith => _$MemoryReportRequestedCopyWithImpl<MemoryReportRequested>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryListEvent.reportRequested'))
    ..add(DiagnosticsProperty('memory', memory))..add(DiagnosticsProperty('reason', reason))..add(DiagnosticsProperty('note', note));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryReportRequested&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,memory,reason,note);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryListEvent.reportRequested(memory: $memory, reason: $reason, note: $note)';
}


}

/// @nodoc
abstract mixin class $MemoryReportRequestedCopyWith<$Res> implements $MemoryListEventCopyWith<$Res> {
  factory $MemoryReportRequestedCopyWith(MemoryReportRequested value, $Res Function(MemoryReportRequested) _then) = _$MemoryReportRequestedCopyWithImpl;
@useResult
$Res call({
 Memory memory, MemoryReportReason reason, String note
});




}
/// @nodoc
class _$MemoryReportRequestedCopyWithImpl<$Res>
    implements $MemoryReportRequestedCopyWith<$Res> {
  _$MemoryReportRequestedCopyWithImpl(this._self, this._then);

  final MemoryReportRequested _self;
  final $Res Function(MemoryReportRequested) _then;

/// Create a copy of MemoryListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? memory = null,Object? reason = null,Object? note = null,}) {
  return _then(MemoryReportRequested(
memory: null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as Memory,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as MemoryReportReason,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _MemoryChangeReceived with DiagnosticableTreeMixin implements MemoryListEvent {
  const _MemoryChangeReceived(this.change);
  

 final  MemoryChange change;

/// Create a copy of MemoryListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryChangeReceivedCopyWith<_MemoryChangeReceived> get copyWith => __$MemoryChangeReceivedCopyWithImpl<_MemoryChangeReceived>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryListEvent.changeReceived'))
    ..add(DiagnosticsProperty('change', change));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryChangeReceived&&(identical(other.change, change) || other.change == change));
}


@override
int get hashCode {
    return Object.hash(runtimeType,change);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryListEvent.changeReceived(change: $change)';
}


}

/// @nodoc
abstract mixin class _$MemoryChangeReceivedCopyWith<$Res> implements $MemoryListEventCopyWith<$Res> {
  factory _$MemoryChangeReceivedCopyWith(_MemoryChangeReceived value, $Res Function(_MemoryChangeReceived) _then) = __$MemoryChangeReceivedCopyWithImpl;
@useResult
$Res call({
 MemoryChange change
});




}
/// @nodoc
class __$MemoryChangeReceivedCopyWithImpl<$Res>
    implements _$MemoryChangeReceivedCopyWith<$Res> {
  __$MemoryChangeReceivedCopyWithImpl(this._self, this._then);

  final _MemoryChangeReceived _self;
  final $Res Function(_MemoryChangeReceived) _then;

/// Create a copy of MemoryListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? change = null,}) {
  return _then(_MemoryChangeReceived(
null == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as MemoryChange,
  ));
}


}

/// @nodoc
mixin _$MemoryListState implements DiagnosticableTreeMixin {

 String get monumentId; int get pageSize; MemoryListStatus get status;/// Anı tarihi filtresi; `null` → tüm zamanlar.
 MemoryDateRange? get range;/// Yıllara göre sayılar (filtreden bağımsız), en yeni yıl önce.
 List<MemoryYearCount> get years; List<Memory> get items; int get total; String? get nextCursor; Failure? get failure; bool get isLoadingMore; Failure? get loadMoreFailure;/// Silme / bildirme isteği süren anılar.
 Set<String> get busyIds; MemoryNotice? get notice;/// Her yeni bildirimde artar (aynı bildirimin tekrarı da dinlenir).
 int get noticeCount;
/// Create a copy of MemoryListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryListStateCopyWith<MemoryListState> get copyWith => _$MemoryListStateCopyWithImpl<MemoryListState>(this as MemoryListState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as MemoryListState;
  properties
    ..add(DiagnosticsProperty('type', 'MemoryListState'))
    ..add(DiagnosticsProperty('monumentId', _this.monumentId))..add(DiagnosticsProperty('pageSize', _this.pageSize))..add(DiagnosticsProperty('status', _this.status))..add(DiagnosticsProperty('range', _this.range))..add(DiagnosticsProperty('years', _this.years))..add(DiagnosticsProperty('items', _this.items))..add(DiagnosticsProperty('total', _this.total))..add(DiagnosticsProperty('nextCursor', _this.nextCursor))..add(DiagnosticsProperty('failure', _this.failure))..add(DiagnosticsProperty('isLoadingMore', _this.isLoadingMore))..add(DiagnosticsProperty('loadMoreFailure', _this.loadMoreFailure))..add(DiagnosticsProperty('busyIds', _this.busyIds))..add(DiagnosticsProperty('notice', _this.notice))..add(DiagnosticsProperty('noticeCount', _this.noticeCount));
}

@override
bool operator ==(Object other) {
  final _this = this as MemoryListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryListState&&(identical(other.monumentId, _this.monumentId) || other.monumentId == _this.monumentId)&&(identical(other.pageSize, _this.pageSize) || other.pageSize == _this.pageSize)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.range, _this.range) || other.range == _this.range)&&const DeepCollectionEquality().equals(other.years, _this.years)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.isLoadingMore, _this.isLoadingMore) || other.isLoadingMore == _this.isLoadingMore)&&(identical(other.loadMoreFailure, _this.loadMoreFailure) || other.loadMoreFailure == _this.loadMoreFailure)&&const DeepCollectionEquality().equals(other.busyIds, _this.busyIds)&&(identical(other.notice, _this.notice) || other.notice == _this.notice)&&(identical(other.noticeCount, _this.noticeCount) || other.noticeCount == _this.noticeCount));
}


@override
int get hashCode {
  final _this = this as MemoryListState;
  return Object.hash(runtimeType,_this.monumentId,_this.pageSize,_this.status,_this.range,const DeepCollectionEquality().hash(_this.years),const DeepCollectionEquality().hash(_this.items),_this.total,_this.nextCursor,_this.failure,_this.isLoadingMore,_this.loadMoreFailure,const DeepCollectionEquality().hash(_this.busyIds),_this.notice,_this.noticeCount);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as MemoryListState;
  return 'MemoryListState(monumentId: ${_this.monumentId}, pageSize: ${_this.pageSize}, status: ${_this.status}, range: ${_this.range}, years: ${_this.years}, items: ${_this.items}, total: ${_this.total}, nextCursor: ${_this.nextCursor}, failure: ${_this.failure}, isLoadingMore: ${_this.isLoadingMore}, loadMoreFailure: ${_this.loadMoreFailure}, busyIds: ${_this.busyIds}, notice: ${_this.notice}, noticeCount: ${_this.noticeCount})';
}


}

/// @nodoc
abstract mixin class $MemoryListStateCopyWith<$Res>  {
  factory $MemoryListStateCopyWith(MemoryListState value, $Res Function(MemoryListState) _then) = _$MemoryListStateCopyWithImpl;
@useResult
$Res call({
 String monumentId, int pageSize, MemoryListStatus status, MemoryDateRange? range, List<MemoryYearCount> years, List<Memory> items, int total, String? nextCursor, Failure? failure, bool isLoadingMore, Failure? loadMoreFailure, Set<String> busyIds, MemoryNotice? notice, int noticeCount
});




}
/// @nodoc
class _$MemoryListStateCopyWithImpl<$Res>
    implements $MemoryListStateCopyWith<$Res> {
  _$MemoryListStateCopyWithImpl(this._self, this._then);

  final MemoryListState _self;
  final $Res Function(MemoryListState) _then;

/// Create a copy of MemoryListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monumentId = null,Object? pageSize = null,Object? status = null,Object? range = freezed,Object? years = null,Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? failure = freezed,Object? isLoadingMore = null,Object? loadMoreFailure = freezed,Object? busyIds = null,Object? notice = freezed,Object? noticeCount = null,}) {
  return _then(MemoryListState(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemoryListStatus,range: freezed == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as MemoryDateRange?,years: null == years ? _self.years : years // ignore: cast_nullable_to_non_nullable
as List<MemoryYearCount>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Memory>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,busyIds: null == busyIds ? _self.busyIds : busyIds // ignore: cast_nullable_to_non_nullable
as Set<String>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as MemoryNotice?,noticeCount: null == noticeCount ? _self.noticeCount : noticeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryListState].
extension MemoryListStatePatterns on MemoryListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryListState value)  $default,){
final _that = this;
switch (_that) {
case _MemoryListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryListState value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String monumentId,  int pageSize,  MemoryListStatus status,  MemoryDateRange? range,  List<MemoryYearCount> years,  List<Memory> items,  int total,  String? nextCursor,  Failure? failure,  bool isLoadingMore,  Failure? loadMoreFailure,  Set<String> busyIds,  MemoryNotice? notice,  int noticeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoryListState() when $default != null:
return $default(_that.monumentId,_that.pageSize,_that.status,_that.range,_that.years,_that.items,_that.total,_that.nextCursor,_that.failure,_that.isLoadingMore,_that.loadMoreFailure,_that.busyIds,_that.notice,_that.noticeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String monumentId,  int pageSize,  MemoryListStatus status,  MemoryDateRange? range,  List<MemoryYearCount> years,  List<Memory> items,  int total,  String? nextCursor,  Failure? failure,  bool isLoadingMore,  Failure? loadMoreFailure,  Set<String> busyIds,  MemoryNotice? notice,  int noticeCount)  $default,) {final _that = this;
switch (_that) {
case _MemoryListState():
return $default(_that.monumentId,_that.pageSize,_that.status,_that.range,_that.years,_that.items,_that.total,_that.nextCursor,_that.failure,_that.isLoadingMore,_that.loadMoreFailure,_that.busyIds,_that.notice,_that.noticeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String monumentId,  int pageSize,  MemoryListStatus status,  MemoryDateRange? range,  List<MemoryYearCount> years,  List<Memory> items,  int total,  String? nextCursor,  Failure? failure,  bool isLoadingMore,  Failure? loadMoreFailure,  Set<String> busyIds,  MemoryNotice? notice,  int noticeCount)?  $default,) {final _that = this;
switch (_that) {
case _MemoryListState() when $default != null:
return $default(_that.monumentId,_that.pageSize,_that.status,_that.range,_that.years,_that.items,_that.total,_that.nextCursor,_that.failure,_that.isLoadingMore,_that.loadMoreFailure,_that.busyIds,_that.notice,_that.noticeCount);case _:
  return null;

}
}

}

/// @nodoc


class _MemoryListState extends MemoryListState with DiagnosticableTreeMixin {
  const _MemoryListState({this.monumentId = '', this.pageSize = MemoryRules.pageSize, this.status = MemoryListStatus.initial, this.range,  List<MemoryYearCount> years = const <MemoryYearCount>[],  List<Memory> items = const <Memory>[], this.total = 0, this.nextCursor, this.failure, this.isLoadingMore = false, this.loadMoreFailure,  Set<String> busyIds = const <String>{}, this.notice, this.noticeCount = 0}): _years = years,_items = items,_busyIds = busyIds,super._();
  

@override@JsonKey() final  String monumentId;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  MemoryListStatus status;
/// Anı tarihi filtresi; `null` → tüm zamanlar.
@override final  MemoryDateRange? range;
/// Yıllara göre sayılar (filtreden bağımsız), en yeni yıl önce.
 final  List<MemoryYearCount> _years;
/// Yıllara göre sayılar (filtreden bağımsız), en yeni yıl önce.
@override@JsonKey() List<MemoryYearCount> get years {
  if (_years is EqualUnmodifiableListView) return _years;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_years);
}

 final  List<Memory> _items;
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
/// Silme / bildirme isteği süren anılar.
 final  Set<String> _busyIds;
/// Silme / bildirme isteği süren anılar.
@override@JsonKey() Set<String> get busyIds {
  if (_busyIds is EqualUnmodifiableSetView) return _busyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_busyIds);
}

@override final  MemoryNotice? notice;
/// Her yeni bildirimde artar (aynı bildirimin tekrarı da dinlenir).
@override@JsonKey() final  int noticeCount;

/// Create a copy of MemoryListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryListStateCopyWith<_MemoryListState> get copyWith => __$MemoryListStateCopyWithImpl<_MemoryListState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryListState'))
    ..add(DiagnosticsProperty('monumentId', monumentId))..add(DiagnosticsProperty('pageSize', pageSize))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('range', range))..add(DiagnosticsProperty('years', years))..add(DiagnosticsProperty('items', items))..add(DiagnosticsProperty('total', total))..add(DiagnosticsProperty('nextCursor', nextCursor))..add(DiagnosticsProperty('failure', failure))..add(DiagnosticsProperty('isLoadingMore', isLoadingMore))..add(DiagnosticsProperty('loadMoreFailure', loadMoreFailure))..add(DiagnosticsProperty('busyIds', busyIds))..add(DiagnosticsProperty('notice', notice))..add(DiagnosticsProperty('noticeCount', noticeCount));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryListState&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.status, status) || other.status == status)&&(identical(other.range, range) || other.range == range)&&const DeepCollectionEquality().equals(other.years, _years)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreFailure, loadMoreFailure) || other.loadMoreFailure == loadMoreFailure)&&const DeepCollectionEquality().equals(other.busyIds, _busyIds)&&(identical(other.notice, notice) || other.notice == notice)&&(identical(other.noticeCount, noticeCount) || other.noticeCount == noticeCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,monumentId,pageSize,status,range,const DeepCollectionEquality().hash(_years),const DeepCollectionEquality().hash(_items),total,nextCursor,failure,isLoadingMore,loadMoreFailure,const DeepCollectionEquality().hash(_busyIds),notice,noticeCount);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryListState(monumentId: $monumentId, pageSize: $pageSize, status: $status, range: $range, years: $years, items: $items, total: $total, nextCursor: $nextCursor, failure: $failure, isLoadingMore: $isLoadingMore, loadMoreFailure: $loadMoreFailure, busyIds: $busyIds, notice: $notice, noticeCount: $noticeCount)';
}


}

/// @nodoc
abstract mixin class _$MemoryListStateCopyWith<$Res> implements $MemoryListStateCopyWith<$Res> {
  factory _$MemoryListStateCopyWith(_MemoryListState value, $Res Function(_MemoryListState) _then) = __$MemoryListStateCopyWithImpl;
@override @useResult
$Res call({
 String monumentId, int pageSize, MemoryListStatus status, MemoryDateRange? range, List<MemoryYearCount> years, List<Memory> items, int total, String? nextCursor, Failure? failure, bool isLoadingMore, Failure? loadMoreFailure, Set<String> busyIds, MemoryNotice? notice, int noticeCount
});




}
/// @nodoc
class __$MemoryListStateCopyWithImpl<$Res>
    implements _$MemoryListStateCopyWith<$Res> {
  __$MemoryListStateCopyWithImpl(this._self, this._then);

  final _MemoryListState _self;
  final $Res Function(_MemoryListState) _then;

/// Create a copy of MemoryListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monumentId = null,Object? pageSize = null,Object? status = null,Object? range = freezed,Object? years = null,Object? items = null,Object? total = null,Object? nextCursor = freezed,Object? failure = freezed,Object? isLoadingMore = null,Object? loadMoreFailure = freezed,Object? busyIds = null,Object? notice = freezed,Object? noticeCount = null,}) {
  return _then(_MemoryListState(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemoryListStatus,range: freezed == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as MemoryDateRange?,years: null == years ? _self._years : years // ignore: cast_nullable_to_non_nullable
as List<MemoryYearCount>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Memory>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,busyIds: null == busyIds ? _self._busyIds : busyIds // ignore: cast_nullable_to_non_nullable
as Set<String>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as MemoryNotice?,noticeCount: null == noticeCount ? _self.noticeCount : noticeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
