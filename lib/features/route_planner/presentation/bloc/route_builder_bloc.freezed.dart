// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_builder_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RouteBuilderEvent implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent()';
}


}

/// @nodoc
class $RouteBuilderEventCopyWith<$Res>  {
$RouteBuilderEventCopyWith(RouteBuilderEvent _, $Res Function(RouteBuilderEvent) __);
}


/// Adds pattern-matching-related methods to [RouteBuilderEvent].
extension RouteBuilderEventPatterns on RouteBuilderEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RouteBuilderStarted value)?  started,TResult Function( RouteBuilderEditRequested value)?  editRequested,TResult Function( RouteBuilderMonumentToggled value)?  monumentToggled,TResult Function( RouteBuilderMonumentsResolveRequested value)?  monumentsResolveRequested,TResult Function( RouteBuilderStopMoved value)?  stopMoved,TResult Function( RouteBuilderStopRemoved value)?  stopRemoved,TResult Function( RouteBuilderVisitChanged value)?  visitChanged,TResult Function( RouteBuilderBreakAdded value)?  breakAdded,TResult Function( RouteBuilderBreakChanged value)?  breakChanged,TResult Function( RouteBuilderBreakRemoved value)?  breakRemoved,TResult Function( RouteBuilderNameChanged value)?  nameChanged,TResult Function( RouteBuilderOrderOptimized value)?  orderOptimized,TResult Function( RouteBuilderPreviewRequested value)?  previewRequested,TResult Function( RouteBuilderSubmitted value)?  submitted,TResult Function( RouteBuilderReset value)?  reset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RouteBuilderStarted() when started != null:
return started(_that);case RouteBuilderEditRequested() when editRequested != null:
return editRequested(_that);case RouteBuilderMonumentToggled() when monumentToggled != null:
return monumentToggled(_that);case RouteBuilderMonumentsResolveRequested() when monumentsResolveRequested != null:
return monumentsResolveRequested(_that);case RouteBuilderStopMoved() when stopMoved != null:
return stopMoved(_that);case RouteBuilderStopRemoved() when stopRemoved != null:
return stopRemoved(_that);case RouteBuilderVisitChanged() when visitChanged != null:
return visitChanged(_that);case RouteBuilderBreakAdded() when breakAdded != null:
return breakAdded(_that);case RouteBuilderBreakChanged() when breakChanged != null:
return breakChanged(_that);case RouteBuilderBreakRemoved() when breakRemoved != null:
return breakRemoved(_that);case RouteBuilderNameChanged() when nameChanged != null:
return nameChanged(_that);case RouteBuilderOrderOptimized() when orderOptimized != null:
return orderOptimized(_that);case RouteBuilderPreviewRequested() when previewRequested != null:
return previewRequested(_that);case RouteBuilderSubmitted() when submitted != null:
return submitted(_that);case RouteBuilderReset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RouteBuilderStarted value)  started,required TResult Function( RouteBuilderEditRequested value)  editRequested,required TResult Function( RouteBuilderMonumentToggled value)  monumentToggled,required TResult Function( RouteBuilderMonumentsResolveRequested value)  monumentsResolveRequested,required TResult Function( RouteBuilderStopMoved value)  stopMoved,required TResult Function( RouteBuilderStopRemoved value)  stopRemoved,required TResult Function( RouteBuilderVisitChanged value)  visitChanged,required TResult Function( RouteBuilderBreakAdded value)  breakAdded,required TResult Function( RouteBuilderBreakChanged value)  breakChanged,required TResult Function( RouteBuilderBreakRemoved value)  breakRemoved,required TResult Function( RouteBuilderNameChanged value)  nameChanged,required TResult Function( RouteBuilderOrderOptimized value)  orderOptimized,required TResult Function( RouteBuilderPreviewRequested value)  previewRequested,required TResult Function( RouteBuilderSubmitted value)  submitted,required TResult Function( RouteBuilderReset value)  reset,}){
final _that = this;
switch (_that) {
case RouteBuilderStarted():
return started(_that);case RouteBuilderEditRequested():
return editRequested(_that);case RouteBuilderMonumentToggled():
return monumentToggled(_that);case RouteBuilderMonumentsResolveRequested():
return monumentsResolveRequested(_that);case RouteBuilderStopMoved():
return stopMoved(_that);case RouteBuilderStopRemoved():
return stopRemoved(_that);case RouteBuilderVisitChanged():
return visitChanged(_that);case RouteBuilderBreakAdded():
return breakAdded(_that);case RouteBuilderBreakChanged():
return breakChanged(_that);case RouteBuilderBreakRemoved():
return breakRemoved(_that);case RouteBuilderNameChanged():
return nameChanged(_that);case RouteBuilderOrderOptimized():
return orderOptimized(_that);case RouteBuilderPreviewRequested():
return previewRequested(_that);case RouteBuilderSubmitted():
return submitted(_that);case RouteBuilderReset():
return reset(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RouteBuilderStarted value)?  started,TResult? Function( RouteBuilderEditRequested value)?  editRequested,TResult? Function( RouteBuilderMonumentToggled value)?  monumentToggled,TResult? Function( RouteBuilderMonumentsResolveRequested value)?  monumentsResolveRequested,TResult? Function( RouteBuilderStopMoved value)?  stopMoved,TResult? Function( RouteBuilderStopRemoved value)?  stopRemoved,TResult? Function( RouteBuilderVisitChanged value)?  visitChanged,TResult? Function( RouteBuilderBreakAdded value)?  breakAdded,TResult? Function( RouteBuilderBreakChanged value)?  breakChanged,TResult? Function( RouteBuilderBreakRemoved value)?  breakRemoved,TResult? Function( RouteBuilderNameChanged value)?  nameChanged,TResult? Function( RouteBuilderOrderOptimized value)?  orderOptimized,TResult? Function( RouteBuilderPreviewRequested value)?  previewRequested,TResult? Function( RouteBuilderSubmitted value)?  submitted,TResult? Function( RouteBuilderReset value)?  reset,}){
final _that = this;
switch (_that) {
case RouteBuilderStarted() when started != null:
return started(_that);case RouteBuilderEditRequested() when editRequested != null:
return editRequested(_that);case RouteBuilderMonumentToggled() when monumentToggled != null:
return monumentToggled(_that);case RouteBuilderMonumentsResolveRequested() when monumentsResolveRequested != null:
return monumentsResolveRequested(_that);case RouteBuilderStopMoved() when stopMoved != null:
return stopMoved(_that);case RouteBuilderStopRemoved() when stopRemoved != null:
return stopRemoved(_that);case RouteBuilderVisitChanged() when visitChanged != null:
return visitChanged(_that);case RouteBuilderBreakAdded() when breakAdded != null:
return breakAdded(_that);case RouteBuilderBreakChanged() when breakChanged != null:
return breakChanged(_that);case RouteBuilderBreakRemoved() when breakRemoved != null:
return breakRemoved(_that);case RouteBuilderNameChanged() when nameChanged != null:
return nameChanged(_that);case RouteBuilderOrderOptimized() when orderOptimized != null:
return orderOptimized(_that);case RouteBuilderPreviewRequested() when previewRequested != null:
return previewRequested(_that);case RouteBuilderSubmitted() when submitted != null:
return submitted(_that);case RouteBuilderReset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String languageCode)?  started,TResult Function( String routeId,  String languageCode)?  editRequested,TResult Function( String monumentId,  MonumentPin? monument)?  monumentToggled,TResult Function()?  monumentsResolveRequested,TResult Function( int from,  int to)?  stopMoved,TResult Function( int index)?  stopRemoved,TResult Function( int index,  Duration visit)?  visitChanged,TResult Function( int stopIndex,  RouteBreakKind kind)?  breakAdded,TResult Function( int stopIndex,  int breakIndex,  Duration duration)?  breakChanged,TResult Function( int stopIndex,  int breakIndex)?  breakRemoved,TResult Function( String name)?  nameChanged,TResult Function()?  orderOptimized,TResult Function()?  previewRequested,TResult Function( String languageCode,  String fallbackName)?  submitted,TResult Function()?  reset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RouteBuilderStarted() when started != null:
return started(_that.languageCode);case RouteBuilderEditRequested() when editRequested != null:
return editRequested(_that.routeId,_that.languageCode);case RouteBuilderMonumentToggled() when monumentToggled != null:
return monumentToggled(_that.monumentId,_that.monument);case RouteBuilderMonumentsResolveRequested() when monumentsResolveRequested != null:
return monumentsResolveRequested();case RouteBuilderStopMoved() when stopMoved != null:
return stopMoved(_that.from,_that.to);case RouteBuilderStopRemoved() when stopRemoved != null:
return stopRemoved(_that.index);case RouteBuilderVisitChanged() when visitChanged != null:
return visitChanged(_that.index,_that.visit);case RouteBuilderBreakAdded() when breakAdded != null:
return breakAdded(_that.stopIndex,_that.kind);case RouteBuilderBreakChanged() when breakChanged != null:
return breakChanged(_that.stopIndex,_that.breakIndex,_that.duration);case RouteBuilderBreakRemoved() when breakRemoved != null:
return breakRemoved(_that.stopIndex,_that.breakIndex);case RouteBuilderNameChanged() when nameChanged != null:
return nameChanged(_that.name);case RouteBuilderOrderOptimized() when orderOptimized != null:
return orderOptimized();case RouteBuilderPreviewRequested() when previewRequested != null:
return previewRequested();case RouteBuilderSubmitted() when submitted != null:
return submitted(_that.languageCode,_that.fallbackName);case RouteBuilderReset() when reset != null:
return reset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String languageCode)  started,required TResult Function( String routeId,  String languageCode)  editRequested,required TResult Function( String monumentId,  MonumentPin? monument)  monumentToggled,required TResult Function()  monumentsResolveRequested,required TResult Function( int from,  int to)  stopMoved,required TResult Function( int index)  stopRemoved,required TResult Function( int index,  Duration visit)  visitChanged,required TResult Function( int stopIndex,  RouteBreakKind kind)  breakAdded,required TResult Function( int stopIndex,  int breakIndex,  Duration duration)  breakChanged,required TResult Function( int stopIndex,  int breakIndex)  breakRemoved,required TResult Function( String name)  nameChanged,required TResult Function()  orderOptimized,required TResult Function()  previewRequested,required TResult Function( String languageCode,  String fallbackName)  submitted,required TResult Function()  reset,}) {final _that = this;
switch (_that) {
case RouteBuilderStarted():
return started(_that.languageCode);case RouteBuilderEditRequested():
return editRequested(_that.routeId,_that.languageCode);case RouteBuilderMonumentToggled():
return monumentToggled(_that.monumentId,_that.monument);case RouteBuilderMonumentsResolveRequested():
return monumentsResolveRequested();case RouteBuilderStopMoved():
return stopMoved(_that.from,_that.to);case RouteBuilderStopRemoved():
return stopRemoved(_that.index);case RouteBuilderVisitChanged():
return visitChanged(_that.index,_that.visit);case RouteBuilderBreakAdded():
return breakAdded(_that.stopIndex,_that.kind);case RouteBuilderBreakChanged():
return breakChanged(_that.stopIndex,_that.breakIndex,_that.duration);case RouteBuilderBreakRemoved():
return breakRemoved(_that.stopIndex,_that.breakIndex);case RouteBuilderNameChanged():
return nameChanged(_that.name);case RouteBuilderOrderOptimized():
return orderOptimized();case RouteBuilderPreviewRequested():
return previewRequested();case RouteBuilderSubmitted():
return submitted(_that.languageCode,_that.fallbackName);case RouteBuilderReset():
return reset();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String languageCode)?  started,TResult? Function( String routeId,  String languageCode)?  editRequested,TResult? Function( String monumentId,  MonumentPin? monument)?  monumentToggled,TResult? Function()?  monumentsResolveRequested,TResult? Function( int from,  int to)?  stopMoved,TResult? Function( int index)?  stopRemoved,TResult? Function( int index,  Duration visit)?  visitChanged,TResult? Function( int stopIndex,  RouteBreakKind kind)?  breakAdded,TResult? Function( int stopIndex,  int breakIndex,  Duration duration)?  breakChanged,TResult? Function( int stopIndex,  int breakIndex)?  breakRemoved,TResult? Function( String name)?  nameChanged,TResult? Function()?  orderOptimized,TResult? Function()?  previewRequested,TResult? Function( String languageCode,  String fallbackName)?  submitted,TResult? Function()?  reset,}) {final _that = this;
switch (_that) {
case RouteBuilderStarted() when started != null:
return started(_that.languageCode);case RouteBuilderEditRequested() when editRequested != null:
return editRequested(_that.routeId,_that.languageCode);case RouteBuilderMonumentToggled() when monumentToggled != null:
return monumentToggled(_that.monumentId,_that.monument);case RouteBuilderMonumentsResolveRequested() when monumentsResolveRequested != null:
return monumentsResolveRequested();case RouteBuilderStopMoved() when stopMoved != null:
return stopMoved(_that.from,_that.to);case RouteBuilderStopRemoved() when stopRemoved != null:
return stopRemoved(_that.index);case RouteBuilderVisitChanged() when visitChanged != null:
return visitChanged(_that.index,_that.visit);case RouteBuilderBreakAdded() when breakAdded != null:
return breakAdded(_that.stopIndex,_that.kind);case RouteBuilderBreakChanged() when breakChanged != null:
return breakChanged(_that.stopIndex,_that.breakIndex,_that.duration);case RouteBuilderBreakRemoved() when breakRemoved != null:
return breakRemoved(_that.stopIndex,_that.breakIndex);case RouteBuilderNameChanged() when nameChanged != null:
return nameChanged(_that.name);case RouteBuilderOrderOptimized() when orderOptimized != null:
return orderOptimized();case RouteBuilderPreviewRequested() when previewRequested != null:
return previewRequested();case RouteBuilderSubmitted() when submitted != null:
return submitted(_that.languageCode,_that.fallbackName);case RouteBuilderReset() when reset != null:
return reset();case _:
  return null;

}
}

}

/// @nodoc


class RouteBuilderStarted with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderStarted({required this.languageCode});
  

 final  String languageCode;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteBuilderStartedCopyWith<RouteBuilderStarted> get copyWith => _$RouteBuilderStartedCopyWithImpl<RouteBuilderStarted>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.started'))
    ..add(DiagnosticsProperty('languageCode', languageCode));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderStarted&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,languageCode);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.started(languageCode: $languageCode)';
}


}

/// @nodoc
abstract mixin class $RouteBuilderStartedCopyWith<$Res> implements $RouteBuilderEventCopyWith<$Res> {
  factory $RouteBuilderStartedCopyWith(RouteBuilderStarted value, $Res Function(RouteBuilderStarted) _then) = _$RouteBuilderStartedCopyWithImpl;
@useResult
$Res call({
 String languageCode
});




}
/// @nodoc
class _$RouteBuilderStartedCopyWithImpl<$Res>
    implements $RouteBuilderStartedCopyWith<$Res> {
  _$RouteBuilderStartedCopyWithImpl(this._self, this._then);

  final RouteBuilderStarted _self;
  final $Res Function(RouteBuilderStarted) _then;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? languageCode = null,}) {
  return _then(RouteBuilderStarted(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RouteBuilderEditRequested with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderEditRequested({required this.routeId, required this.languageCode});
  

 final  String routeId;
 final  String languageCode;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteBuilderEditRequestedCopyWith<RouteBuilderEditRequested> get copyWith => _$RouteBuilderEditRequestedCopyWithImpl<RouteBuilderEditRequested>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.editRequested'))
    ..add(DiagnosticsProperty('routeId', routeId))..add(DiagnosticsProperty('languageCode', languageCode));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderEditRequested&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,routeId,languageCode);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.editRequested(routeId: $routeId, languageCode: $languageCode)';
}


}

/// @nodoc
abstract mixin class $RouteBuilderEditRequestedCopyWith<$Res> implements $RouteBuilderEventCopyWith<$Res> {
  factory $RouteBuilderEditRequestedCopyWith(RouteBuilderEditRequested value, $Res Function(RouteBuilderEditRequested) _then) = _$RouteBuilderEditRequestedCopyWithImpl;
@useResult
$Res call({
 String routeId, String languageCode
});




}
/// @nodoc
class _$RouteBuilderEditRequestedCopyWithImpl<$Res>
    implements $RouteBuilderEditRequestedCopyWith<$Res> {
  _$RouteBuilderEditRequestedCopyWithImpl(this._self, this._then);

  final RouteBuilderEditRequested _self;
  final $Res Function(RouteBuilderEditRequested) _then;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? routeId = null,Object? languageCode = null,}) {
  return _then(RouteBuilderEditRequested(
routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RouteBuilderMonumentToggled with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderMonumentToggled(this.monumentId, {this.monument});
  

 final  String monumentId;
 final  MonumentPin? monument;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteBuilderMonumentToggledCopyWith<RouteBuilderMonumentToggled> get copyWith => _$RouteBuilderMonumentToggledCopyWithImpl<RouteBuilderMonumentToggled>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.monumentToggled'))
    ..add(DiagnosticsProperty('monumentId', monumentId))..add(DiagnosticsProperty('monument', monument));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderMonumentToggled&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.monument, monument) || other.monument == monument));
}


@override
int get hashCode {
    return Object.hash(runtimeType,monumentId,monument);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.monumentToggled(monumentId: $monumentId, monument: $monument)';
}


}

/// @nodoc
abstract mixin class $RouteBuilderMonumentToggledCopyWith<$Res> implements $RouteBuilderEventCopyWith<$Res> {
  factory $RouteBuilderMonumentToggledCopyWith(RouteBuilderMonumentToggled value, $Res Function(RouteBuilderMonumentToggled) _then) = _$RouteBuilderMonumentToggledCopyWithImpl;
@useResult
$Res call({
 String monumentId, MonumentPin? monument
});




}
/// @nodoc
class _$RouteBuilderMonumentToggledCopyWithImpl<$Res>
    implements $RouteBuilderMonumentToggledCopyWith<$Res> {
  _$RouteBuilderMonumentToggledCopyWithImpl(this._self, this._then);

  final RouteBuilderMonumentToggled _self;
  final $Res Function(RouteBuilderMonumentToggled) _then;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? monumentId = null,Object? monument = freezed,}) {
  return _then(RouteBuilderMonumentToggled(
null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,monument: freezed == monument ? _self.monument : monument // ignore: cast_nullable_to_non_nullable
as MonumentPin?,
  ));
}


}

/// @nodoc


class RouteBuilderMonumentsResolveRequested with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderMonumentsResolveRequested();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.monumentsResolveRequested'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderMonumentsResolveRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.monumentsResolveRequested()';
}


}




/// @nodoc


class RouteBuilderStopMoved with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderStopMoved({required this.from, required this.to});
  

 final  int from;
 final  int to;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteBuilderStopMovedCopyWith<RouteBuilderStopMoved> get copyWith => _$RouteBuilderStopMovedCopyWithImpl<RouteBuilderStopMoved>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.stopMoved'))
    ..add(DiagnosticsProperty('from', from))..add(DiagnosticsProperty('to', to));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderStopMoved&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode {
    return Object.hash(runtimeType,from,to);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.stopMoved(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $RouteBuilderStopMovedCopyWith<$Res> implements $RouteBuilderEventCopyWith<$Res> {
  factory $RouteBuilderStopMovedCopyWith(RouteBuilderStopMoved value, $Res Function(RouteBuilderStopMoved) _then) = _$RouteBuilderStopMovedCopyWithImpl;
@useResult
$Res call({
 int from, int to
});




}
/// @nodoc
class _$RouteBuilderStopMovedCopyWithImpl<$Res>
    implements $RouteBuilderStopMovedCopyWith<$Res> {
  _$RouteBuilderStopMovedCopyWithImpl(this._self, this._then);

  final RouteBuilderStopMoved _self;
  final $Res Function(RouteBuilderStopMoved) _then;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,}) {
  return _then(RouteBuilderStopMoved(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class RouteBuilderStopRemoved with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderStopRemoved(this.index);
  

 final  int index;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteBuilderStopRemovedCopyWith<RouteBuilderStopRemoved> get copyWith => _$RouteBuilderStopRemovedCopyWithImpl<RouteBuilderStopRemoved>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.stopRemoved'))
    ..add(DiagnosticsProperty('index', index));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderStopRemoved&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode {
    return Object.hash(runtimeType,index);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.stopRemoved(index: $index)';
}


}

/// @nodoc
abstract mixin class $RouteBuilderStopRemovedCopyWith<$Res> implements $RouteBuilderEventCopyWith<$Res> {
  factory $RouteBuilderStopRemovedCopyWith(RouteBuilderStopRemoved value, $Res Function(RouteBuilderStopRemoved) _then) = _$RouteBuilderStopRemovedCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$RouteBuilderStopRemovedCopyWithImpl<$Res>
    implements $RouteBuilderStopRemovedCopyWith<$Res> {
  _$RouteBuilderStopRemovedCopyWithImpl(this._self, this._then);

  final RouteBuilderStopRemoved _self;
  final $Res Function(RouteBuilderStopRemoved) _then;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(RouteBuilderStopRemoved(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class RouteBuilderVisitChanged with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderVisitChanged({required this.index, required this.visit});
  

 final  int index;
 final  Duration visit;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteBuilderVisitChangedCopyWith<RouteBuilderVisitChanged> get copyWith => _$RouteBuilderVisitChangedCopyWithImpl<RouteBuilderVisitChanged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.visitChanged'))
    ..add(DiagnosticsProperty('index', index))..add(DiagnosticsProperty('visit', visit));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderVisitChanged&&(identical(other.index, index) || other.index == index)&&(identical(other.visit, visit) || other.visit == visit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,index,visit);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.visitChanged(index: $index, visit: $visit)';
}


}

/// @nodoc
abstract mixin class $RouteBuilderVisitChangedCopyWith<$Res> implements $RouteBuilderEventCopyWith<$Res> {
  factory $RouteBuilderVisitChangedCopyWith(RouteBuilderVisitChanged value, $Res Function(RouteBuilderVisitChanged) _then) = _$RouteBuilderVisitChangedCopyWithImpl;
@useResult
$Res call({
 int index, Duration visit
});




}
/// @nodoc
class _$RouteBuilderVisitChangedCopyWithImpl<$Res>
    implements $RouteBuilderVisitChangedCopyWith<$Res> {
  _$RouteBuilderVisitChangedCopyWithImpl(this._self, this._then);

  final RouteBuilderVisitChanged _self;
  final $Res Function(RouteBuilderVisitChanged) _then;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,Object? visit = null,}) {
  return _then(RouteBuilderVisitChanged(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,visit: null == visit ? _self.visit : visit // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class RouteBuilderBreakAdded with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderBreakAdded({required this.stopIndex, required this.kind});
  

 final  int stopIndex;
 final  RouteBreakKind kind;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteBuilderBreakAddedCopyWith<RouteBuilderBreakAdded> get copyWith => _$RouteBuilderBreakAddedCopyWithImpl<RouteBuilderBreakAdded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.breakAdded'))
    ..add(DiagnosticsProperty('stopIndex', stopIndex))..add(DiagnosticsProperty('kind', kind));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderBreakAdded&&(identical(other.stopIndex, stopIndex) || other.stopIndex == stopIndex)&&(identical(other.kind, kind) || other.kind == kind));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stopIndex,kind);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.breakAdded(stopIndex: $stopIndex, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $RouteBuilderBreakAddedCopyWith<$Res> implements $RouteBuilderEventCopyWith<$Res> {
  factory $RouteBuilderBreakAddedCopyWith(RouteBuilderBreakAdded value, $Res Function(RouteBuilderBreakAdded) _then) = _$RouteBuilderBreakAddedCopyWithImpl;
@useResult
$Res call({
 int stopIndex, RouteBreakKind kind
});




}
/// @nodoc
class _$RouteBuilderBreakAddedCopyWithImpl<$Res>
    implements $RouteBuilderBreakAddedCopyWith<$Res> {
  _$RouteBuilderBreakAddedCopyWithImpl(this._self, this._then);

  final RouteBuilderBreakAdded _self;
  final $Res Function(RouteBuilderBreakAdded) _then;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stopIndex = null,Object? kind = null,}) {
  return _then(RouteBuilderBreakAdded(
stopIndex: null == stopIndex ? _self.stopIndex : stopIndex // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RouteBreakKind,
  ));
}


}

/// @nodoc


class RouteBuilderBreakChanged with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderBreakChanged({required this.stopIndex, required this.breakIndex, required this.duration});
  

 final  int stopIndex;
 final  int breakIndex;
 final  Duration duration;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteBuilderBreakChangedCopyWith<RouteBuilderBreakChanged> get copyWith => _$RouteBuilderBreakChangedCopyWithImpl<RouteBuilderBreakChanged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.breakChanged'))
    ..add(DiagnosticsProperty('stopIndex', stopIndex))..add(DiagnosticsProperty('breakIndex', breakIndex))..add(DiagnosticsProperty('duration', duration));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderBreakChanged&&(identical(other.stopIndex, stopIndex) || other.stopIndex == stopIndex)&&(identical(other.breakIndex, breakIndex) || other.breakIndex == breakIndex)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stopIndex,breakIndex,duration);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.breakChanged(stopIndex: $stopIndex, breakIndex: $breakIndex, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $RouteBuilderBreakChangedCopyWith<$Res> implements $RouteBuilderEventCopyWith<$Res> {
  factory $RouteBuilderBreakChangedCopyWith(RouteBuilderBreakChanged value, $Res Function(RouteBuilderBreakChanged) _then) = _$RouteBuilderBreakChangedCopyWithImpl;
@useResult
$Res call({
 int stopIndex, int breakIndex, Duration duration
});




}
/// @nodoc
class _$RouteBuilderBreakChangedCopyWithImpl<$Res>
    implements $RouteBuilderBreakChangedCopyWith<$Res> {
  _$RouteBuilderBreakChangedCopyWithImpl(this._self, this._then);

  final RouteBuilderBreakChanged _self;
  final $Res Function(RouteBuilderBreakChanged) _then;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stopIndex = null,Object? breakIndex = null,Object? duration = null,}) {
  return _then(RouteBuilderBreakChanged(
stopIndex: null == stopIndex ? _self.stopIndex : stopIndex // ignore: cast_nullable_to_non_nullable
as int,breakIndex: null == breakIndex ? _self.breakIndex : breakIndex // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class RouteBuilderBreakRemoved with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderBreakRemoved({required this.stopIndex, required this.breakIndex});
  

 final  int stopIndex;
 final  int breakIndex;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteBuilderBreakRemovedCopyWith<RouteBuilderBreakRemoved> get copyWith => _$RouteBuilderBreakRemovedCopyWithImpl<RouteBuilderBreakRemoved>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.breakRemoved'))
    ..add(DiagnosticsProperty('stopIndex', stopIndex))..add(DiagnosticsProperty('breakIndex', breakIndex));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderBreakRemoved&&(identical(other.stopIndex, stopIndex) || other.stopIndex == stopIndex)&&(identical(other.breakIndex, breakIndex) || other.breakIndex == breakIndex));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stopIndex,breakIndex);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.breakRemoved(stopIndex: $stopIndex, breakIndex: $breakIndex)';
}


}

/// @nodoc
abstract mixin class $RouteBuilderBreakRemovedCopyWith<$Res> implements $RouteBuilderEventCopyWith<$Res> {
  factory $RouteBuilderBreakRemovedCopyWith(RouteBuilderBreakRemoved value, $Res Function(RouteBuilderBreakRemoved) _then) = _$RouteBuilderBreakRemovedCopyWithImpl;
@useResult
$Res call({
 int stopIndex, int breakIndex
});




}
/// @nodoc
class _$RouteBuilderBreakRemovedCopyWithImpl<$Res>
    implements $RouteBuilderBreakRemovedCopyWith<$Res> {
  _$RouteBuilderBreakRemovedCopyWithImpl(this._self, this._then);

  final RouteBuilderBreakRemoved _self;
  final $Res Function(RouteBuilderBreakRemoved) _then;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stopIndex = null,Object? breakIndex = null,}) {
  return _then(RouteBuilderBreakRemoved(
stopIndex: null == stopIndex ? _self.stopIndex : stopIndex // ignore: cast_nullable_to_non_nullable
as int,breakIndex: null == breakIndex ? _self.breakIndex : breakIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class RouteBuilderNameChanged with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderNameChanged(this.name);
  

 final  String name;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteBuilderNameChangedCopyWith<RouteBuilderNameChanged> get copyWith => _$RouteBuilderNameChangedCopyWithImpl<RouteBuilderNameChanged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.nameChanged'))
    ..add(DiagnosticsProperty('name', name));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderNameChanged&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.nameChanged(name: $name)';
}


}

/// @nodoc
abstract mixin class $RouteBuilderNameChangedCopyWith<$Res> implements $RouteBuilderEventCopyWith<$Res> {
  factory $RouteBuilderNameChangedCopyWith(RouteBuilderNameChanged value, $Res Function(RouteBuilderNameChanged) _then) = _$RouteBuilderNameChangedCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$RouteBuilderNameChangedCopyWithImpl<$Res>
    implements $RouteBuilderNameChangedCopyWith<$Res> {
  _$RouteBuilderNameChangedCopyWithImpl(this._self, this._then);

  final RouteBuilderNameChanged _self;
  final $Res Function(RouteBuilderNameChanged) _then;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(RouteBuilderNameChanged(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RouteBuilderOrderOptimized with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderOrderOptimized();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.orderOptimized'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderOrderOptimized);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.orderOptimized()';
}


}




/// @nodoc


class RouteBuilderPreviewRequested with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderPreviewRequested();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.previewRequested'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderPreviewRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.previewRequested()';
}


}




/// @nodoc


class RouteBuilderSubmitted with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderSubmitted({required this.languageCode, required this.fallbackName});
  

 final  String languageCode;
 final  String fallbackName;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteBuilderSubmittedCopyWith<RouteBuilderSubmitted> get copyWith => _$RouteBuilderSubmittedCopyWithImpl<RouteBuilderSubmitted>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.submitted'))
    ..add(DiagnosticsProperty('languageCode', languageCode))..add(DiagnosticsProperty('fallbackName', fallbackName));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderSubmitted&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.fallbackName, fallbackName) || other.fallbackName == fallbackName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,languageCode,fallbackName);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.submitted(languageCode: $languageCode, fallbackName: $fallbackName)';
}


}

/// @nodoc
abstract mixin class $RouteBuilderSubmittedCopyWith<$Res> implements $RouteBuilderEventCopyWith<$Res> {
  factory $RouteBuilderSubmittedCopyWith(RouteBuilderSubmitted value, $Res Function(RouteBuilderSubmitted) _then) = _$RouteBuilderSubmittedCopyWithImpl;
@useResult
$Res call({
 String languageCode, String fallbackName
});




}
/// @nodoc
class _$RouteBuilderSubmittedCopyWithImpl<$Res>
    implements $RouteBuilderSubmittedCopyWith<$Res> {
  _$RouteBuilderSubmittedCopyWithImpl(this._self, this._then);

  final RouteBuilderSubmitted _self;
  final $Res Function(RouteBuilderSubmitted) _then;

/// Create a copy of RouteBuilderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? languageCode = null,Object? fallbackName = null,}) {
  return _then(RouteBuilderSubmitted(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,fallbackName: null == fallbackName ? _self.fallbackName : fallbackName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RouteBuilderReset with DiagnosticableTreeMixin implements RouteBuilderEvent {
  const RouteBuilderReset();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderEvent.reset'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderReset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderEvent.reset()';
}


}




/// @nodoc
mixin _$RouteOptimizationOutcome implements DiagnosticableTreeMixin {

 RouteOptimizationBasis get basis;/// [basis] biriminde (saniye / metre) önceki ve yeni toplam.
 double get before; double get after;/// Her optimizasyonda artar; aynı sonucun tekrar duyurulmasını sağlar.
 int get sequence;
/// Create a copy of RouteOptimizationOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteOptimizationOutcomeCopyWith<RouteOptimizationOutcome> get copyWith => _$RouteOptimizationOutcomeCopyWithImpl<RouteOptimizationOutcome>(this as RouteOptimizationOutcome, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as RouteOptimizationOutcome;
  properties
    ..add(DiagnosticsProperty('type', 'RouteOptimizationOutcome'))
    ..add(DiagnosticsProperty('basis', _this.basis))..add(DiagnosticsProperty('before', _this.before))..add(DiagnosticsProperty('after', _this.after))..add(DiagnosticsProperty('sequence', _this.sequence));
}

@override
bool operator ==(Object other) {
  final _this = this as RouteOptimizationOutcome;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteOptimizationOutcome&&(identical(other.basis, _this.basis) || other.basis == _this.basis)&&(identical(other.before, _this.before) || other.before == _this.before)&&(identical(other.after, _this.after) || other.after == _this.after)&&(identical(other.sequence, _this.sequence) || other.sequence == _this.sequence));
}


@override
int get hashCode {
  final _this = this as RouteOptimizationOutcome;
  return Object.hash(runtimeType,_this.basis,_this.before,_this.after,_this.sequence);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as RouteOptimizationOutcome;
  return 'RouteOptimizationOutcome(basis: ${_this.basis}, before: ${_this.before}, after: ${_this.after}, sequence: ${_this.sequence})';
}


}

/// @nodoc
abstract mixin class $RouteOptimizationOutcomeCopyWith<$Res>  {
  factory $RouteOptimizationOutcomeCopyWith(RouteOptimizationOutcome value, $Res Function(RouteOptimizationOutcome) _then) = _$RouteOptimizationOutcomeCopyWithImpl;
@useResult
$Res call({
 RouteOptimizationBasis basis, double before, double after, int sequence
});




}
/// @nodoc
class _$RouteOptimizationOutcomeCopyWithImpl<$Res>
    implements $RouteOptimizationOutcomeCopyWith<$Res> {
  _$RouteOptimizationOutcomeCopyWithImpl(this._self, this._then);

  final RouteOptimizationOutcome _self;
  final $Res Function(RouteOptimizationOutcome) _then;

/// Create a copy of RouteOptimizationOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? basis = null,Object? before = null,Object? after = null,Object? sequence = null,}) {
  return _then(RouteOptimizationOutcome(
basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as RouteOptimizationBasis,before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as double,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as double,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteOptimizationOutcome].
extension RouteOptimizationOutcomePatterns on RouteOptimizationOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteOptimizationOutcome value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteOptimizationOutcome() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteOptimizationOutcome value)  $default,){
final _that = this;
switch (_that) {
case _RouteOptimizationOutcome():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteOptimizationOutcome value)?  $default,){
final _that = this;
switch (_that) {
case _RouteOptimizationOutcome() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RouteOptimizationBasis basis,  double before,  double after,  int sequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteOptimizationOutcome() when $default != null:
return $default(_that.basis,_that.before,_that.after,_that.sequence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RouteOptimizationBasis basis,  double before,  double after,  int sequence)  $default,) {final _that = this;
switch (_that) {
case _RouteOptimizationOutcome():
return $default(_that.basis,_that.before,_that.after,_that.sequence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RouteOptimizationBasis basis,  double before,  double after,  int sequence)?  $default,) {final _that = this;
switch (_that) {
case _RouteOptimizationOutcome() when $default != null:
return $default(_that.basis,_that.before,_that.after,_that.sequence);case _:
  return null;

}
}

}

/// @nodoc


class _RouteOptimizationOutcome extends RouteOptimizationOutcome with DiagnosticableTreeMixin {
  const _RouteOptimizationOutcome({required this.basis, required this.before, required this.after, required this.sequence}): super._();
  

@override final  RouteOptimizationBasis basis;
/// [basis] biriminde (saniye / metre) önceki ve yeni toplam.
@override final  double before;
@override final  double after;
/// Her optimizasyonda artar; aynı sonucun tekrar duyurulmasını sağlar.
@override final  int sequence;

/// Create a copy of RouteOptimizationOutcome
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteOptimizationOutcomeCopyWith<_RouteOptimizationOutcome> get copyWith => __$RouteOptimizationOutcomeCopyWithImpl<_RouteOptimizationOutcome>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteOptimizationOutcome'))
    ..add(DiagnosticsProperty('basis', basis))..add(DiagnosticsProperty('before', before))..add(DiagnosticsProperty('after', after))..add(DiagnosticsProperty('sequence', sequence));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteOptimizationOutcome&&(identical(other.basis, basis) || other.basis == basis)&&(identical(other.before, before) || other.before == before)&&(identical(other.after, after) || other.after == after)&&(identical(other.sequence, sequence) || other.sequence == sequence));
}


@override
int get hashCode {
    return Object.hash(runtimeType,basis,before,after,sequence);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteOptimizationOutcome(basis: $basis, before: $before, after: $after, sequence: $sequence)';
}


}

/// @nodoc
abstract mixin class _$RouteOptimizationOutcomeCopyWith<$Res> implements $RouteOptimizationOutcomeCopyWith<$Res> {
  factory _$RouteOptimizationOutcomeCopyWith(_RouteOptimizationOutcome value, $Res Function(_RouteOptimizationOutcome) _then) = __$RouteOptimizationOutcomeCopyWithImpl;
@override @useResult
$Res call({
 RouteOptimizationBasis basis, double before, double after, int sequence
});




}
/// @nodoc
class __$RouteOptimizationOutcomeCopyWithImpl<$Res>
    implements _$RouteOptimizationOutcomeCopyWith<$Res> {
  __$RouteOptimizationOutcomeCopyWithImpl(this._self, this._then);

  final _RouteOptimizationOutcome _self;
  final $Res Function(_RouteOptimizationOutcome) _then;

/// Create a copy of RouteOptimizationOutcome
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? basis = null,Object? before = null,Object? after = null,Object? sequence = null,}) {
  return _then(_RouteOptimizationOutcome(
basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as RouteOptimizationBasis,before: null == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as double,after: null == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as double,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$RouteBuilderState implements DiagnosticableTreeMixin {

 RouteBuilderStatus get status;/// Duraklardaki eserlerin ad / il / konum bilgisi (arayüz dilinde).
/// Tüm katalog indirilmez: seçiciden gelen kayıt saklanır, eksikler
/// kimlikle tek istekte çözülür.
 Map<String, MonumentPin> get monuments;/// Sunucunun döndürmediği (katalogdan kaldırılmış) durak eserleri.
 Set<String> get unavailableMonumentIds; String? get languageCode; List<RouteStopPlan> get stops; String get name;/// Düzenlenen rota; yeni rotada `null`.
 String? get routeId;/// İlk gönderim denemesinden sonra doğrulama mesajları gösterilir.
 bool get showValidation;/// Geçersiz her gönderimde artar (aynı hatanın tekrar duyurulması).
 int get invalidSubmissions;/// Durak sınırına ulaşılmışken eklenmek istendiğinde artar.
 int get limitNotices; RouteOptimizationOutcome? get optimization;/// Karayolu matrisi beklenirken optimize butonu meşguldür.
 bool get isOptimizing;/// Son karayolu ön hesabı; dizi değiştiyse eskidir ([currentPreview]).
 RoutePreview? get preview; Failure? get loadFailure; Failure? get saveFailure; TravelRoute? get savedRoute;
/// Create a copy of RouteBuilderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteBuilderStateCopyWith<RouteBuilderState> get copyWith => _$RouteBuilderStateCopyWithImpl<RouteBuilderState>(this as RouteBuilderState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as RouteBuilderState;
  properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderState'))
    ..add(DiagnosticsProperty('status', _this.status))..add(DiagnosticsProperty('monuments', _this.monuments))..add(DiagnosticsProperty('unavailableMonumentIds', _this.unavailableMonumentIds))..add(DiagnosticsProperty('languageCode', _this.languageCode))..add(DiagnosticsProperty('stops', _this.stops))..add(DiagnosticsProperty('name', _this.name))..add(DiagnosticsProperty('routeId', _this.routeId))..add(DiagnosticsProperty('showValidation', _this.showValidation))..add(DiagnosticsProperty('invalidSubmissions', _this.invalidSubmissions))..add(DiagnosticsProperty('limitNotices', _this.limitNotices))..add(DiagnosticsProperty('optimization', _this.optimization))..add(DiagnosticsProperty('isOptimizing', _this.isOptimizing))..add(DiagnosticsProperty('preview', _this.preview))..add(DiagnosticsProperty('loadFailure', _this.loadFailure))..add(DiagnosticsProperty('saveFailure', _this.saveFailure))..add(DiagnosticsProperty('savedRoute', _this.savedRoute));
}

@override
bool operator ==(Object other) {
  final _this = this as RouteBuilderState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteBuilderState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.monuments, _this.monuments)&&const DeepCollectionEquality().equals(other.unavailableMonumentIds, _this.unavailableMonumentIds)&&(identical(other.languageCode, _this.languageCode) || other.languageCode == _this.languageCode)&&const DeepCollectionEquality().equals(other.stops, _this.stops)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.routeId, _this.routeId) || other.routeId == _this.routeId)&&(identical(other.showValidation, _this.showValidation) || other.showValidation == _this.showValidation)&&(identical(other.invalidSubmissions, _this.invalidSubmissions) || other.invalidSubmissions == _this.invalidSubmissions)&&(identical(other.limitNotices, _this.limitNotices) || other.limitNotices == _this.limitNotices)&&(identical(other.optimization, _this.optimization) || other.optimization == _this.optimization)&&(identical(other.isOptimizing, _this.isOptimizing) || other.isOptimizing == _this.isOptimizing)&&(identical(other.preview, _this.preview) || other.preview == _this.preview)&&(identical(other.loadFailure, _this.loadFailure) || other.loadFailure == _this.loadFailure)&&(identical(other.saveFailure, _this.saveFailure) || other.saveFailure == _this.saveFailure)&&(identical(other.savedRoute, _this.savedRoute) || other.savedRoute == _this.savedRoute));
}


@override
int get hashCode {
  final _this = this as RouteBuilderState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.monuments),const DeepCollectionEquality().hash(_this.unavailableMonumentIds),_this.languageCode,const DeepCollectionEquality().hash(_this.stops),_this.name,_this.routeId,_this.showValidation,_this.invalidSubmissions,_this.limitNotices,_this.optimization,_this.isOptimizing,_this.preview,_this.loadFailure,_this.saveFailure,_this.savedRoute);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as RouteBuilderState;
  return 'RouteBuilderState(status: ${_this.status}, monuments: ${_this.monuments}, unavailableMonumentIds: ${_this.unavailableMonumentIds}, languageCode: ${_this.languageCode}, stops: ${_this.stops}, name: ${_this.name}, routeId: ${_this.routeId}, showValidation: ${_this.showValidation}, invalidSubmissions: ${_this.invalidSubmissions}, limitNotices: ${_this.limitNotices}, optimization: ${_this.optimization}, isOptimizing: ${_this.isOptimizing}, preview: ${_this.preview}, loadFailure: ${_this.loadFailure}, saveFailure: ${_this.saveFailure}, savedRoute: ${_this.savedRoute})';
}


}

/// @nodoc
abstract mixin class $RouteBuilderStateCopyWith<$Res>  {
  factory $RouteBuilderStateCopyWith(RouteBuilderState value, $Res Function(RouteBuilderState) _then) = _$RouteBuilderStateCopyWithImpl;
@useResult
$Res call({
 RouteBuilderStatus status, Map<String, MonumentPin> monuments, Set<String> unavailableMonumentIds, String? languageCode, List<RouteStopPlan> stops, String name, String? routeId, bool showValidation, int invalidSubmissions, int limitNotices, RouteOptimizationOutcome? optimization, bool isOptimizing, RoutePreview? preview, Failure? loadFailure, Failure? saveFailure, TravelRoute? savedRoute
});


$RouteOptimizationOutcomeCopyWith<$Res>? get optimization;

}
/// @nodoc
class _$RouteBuilderStateCopyWithImpl<$Res>
    implements $RouteBuilderStateCopyWith<$Res> {
  _$RouteBuilderStateCopyWithImpl(this._self, this._then);

  final RouteBuilderState _self;
  final $Res Function(RouteBuilderState) _then;

/// Create a copy of RouteBuilderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? monuments = null,Object? unavailableMonumentIds = null,Object? languageCode = freezed,Object? stops = null,Object? name = null,Object? routeId = freezed,Object? showValidation = null,Object? invalidSubmissions = null,Object? limitNotices = null,Object? optimization = freezed,Object? isOptimizing = null,Object? preview = freezed,Object? loadFailure = freezed,Object? saveFailure = freezed,Object? savedRoute = freezed,}) {
  return _then(RouteBuilderState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RouteBuilderStatus,monuments: null == monuments ? _self.monuments : monuments // ignore: cast_nullable_to_non_nullable
as Map<String, MonumentPin>,unavailableMonumentIds: null == unavailableMonumentIds ? _self.unavailableMonumentIds : unavailableMonumentIds // ignore: cast_nullable_to_non_nullable
as Set<String>,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,stops: null == stops ? _self.stops : stops // ignore: cast_nullable_to_non_nullable
as List<RouteStopPlan>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,routeId: freezed == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String?,showValidation: null == showValidation ? _self.showValidation : showValidation // ignore: cast_nullable_to_non_nullable
as bool,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,limitNotices: null == limitNotices ? _self.limitNotices : limitNotices // ignore: cast_nullable_to_non_nullable
as int,optimization: freezed == optimization ? _self.optimization : optimization // ignore: cast_nullable_to_non_nullable
as RouteOptimizationOutcome?,isOptimizing: null == isOptimizing ? _self.isOptimizing : isOptimizing // ignore: cast_nullable_to_non_nullable
as bool,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as RoutePreview?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as Failure?,saveFailure: freezed == saveFailure ? _self.saveFailure : saveFailure // ignore: cast_nullable_to_non_nullable
as Failure?,savedRoute: freezed == savedRoute ? _self.savedRoute : savedRoute // ignore: cast_nullable_to_non_nullable
as TravelRoute?,
  ));
}
/// Create a copy of RouteBuilderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteOptimizationOutcomeCopyWith<$Res>? get optimization {
    if (_self.optimization == null) {
    return null;
  }

  return $RouteOptimizationOutcomeCopyWith<$Res>(_self.optimization!, (value) {
    return _then(_self.copyWith(optimization: value));
  });
}
}


/// Adds pattern-matching-related methods to [RouteBuilderState].
extension RouteBuilderStatePatterns on RouteBuilderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteBuilderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteBuilderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteBuilderState value)  $default,){
final _that = this;
switch (_that) {
case _RouteBuilderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteBuilderState value)?  $default,){
final _that = this;
switch (_that) {
case _RouteBuilderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RouteBuilderStatus status,  Map<String, MonumentPin> monuments,  Set<String> unavailableMonumentIds,  String? languageCode,  List<RouteStopPlan> stops,  String name,  String? routeId,  bool showValidation,  int invalidSubmissions,  int limitNotices,  RouteOptimizationOutcome? optimization,  bool isOptimizing,  RoutePreview? preview,  Failure? loadFailure,  Failure? saveFailure,  TravelRoute? savedRoute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteBuilderState() when $default != null:
return $default(_that.status,_that.monuments,_that.unavailableMonumentIds,_that.languageCode,_that.stops,_that.name,_that.routeId,_that.showValidation,_that.invalidSubmissions,_that.limitNotices,_that.optimization,_that.isOptimizing,_that.preview,_that.loadFailure,_that.saveFailure,_that.savedRoute);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RouteBuilderStatus status,  Map<String, MonumentPin> monuments,  Set<String> unavailableMonumentIds,  String? languageCode,  List<RouteStopPlan> stops,  String name,  String? routeId,  bool showValidation,  int invalidSubmissions,  int limitNotices,  RouteOptimizationOutcome? optimization,  bool isOptimizing,  RoutePreview? preview,  Failure? loadFailure,  Failure? saveFailure,  TravelRoute? savedRoute)  $default,) {final _that = this;
switch (_that) {
case _RouteBuilderState():
return $default(_that.status,_that.monuments,_that.unavailableMonumentIds,_that.languageCode,_that.stops,_that.name,_that.routeId,_that.showValidation,_that.invalidSubmissions,_that.limitNotices,_that.optimization,_that.isOptimizing,_that.preview,_that.loadFailure,_that.saveFailure,_that.savedRoute);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RouteBuilderStatus status,  Map<String, MonumentPin> monuments,  Set<String> unavailableMonumentIds,  String? languageCode,  List<RouteStopPlan> stops,  String name,  String? routeId,  bool showValidation,  int invalidSubmissions,  int limitNotices,  RouteOptimizationOutcome? optimization,  bool isOptimizing,  RoutePreview? preview,  Failure? loadFailure,  Failure? saveFailure,  TravelRoute? savedRoute)?  $default,) {final _that = this;
switch (_that) {
case _RouteBuilderState() when $default != null:
return $default(_that.status,_that.monuments,_that.unavailableMonumentIds,_that.languageCode,_that.stops,_that.name,_that.routeId,_that.showValidation,_that.invalidSubmissions,_that.limitNotices,_that.optimization,_that.isOptimizing,_that.preview,_that.loadFailure,_that.saveFailure,_that.savedRoute);case _:
  return null;

}
}

}

/// @nodoc


class _RouteBuilderState extends RouteBuilderState with DiagnosticableTreeMixin {
  const _RouteBuilderState({this.status = RouteBuilderStatus.loading,  Map<String, MonumentPin> monuments = const <String, MonumentPin>{},  Set<String> unavailableMonumentIds = const <String>{}, this.languageCode,  List<RouteStopPlan> stops = const <RouteStopPlan>[], this.name = '', this.routeId, this.showValidation = false, this.invalidSubmissions = 0, this.limitNotices = 0, this.optimization, this.isOptimizing = false, this.preview, this.loadFailure, this.saveFailure, this.savedRoute}): _monuments = monuments,_unavailableMonumentIds = unavailableMonumentIds,_stops = stops,super._();
  

@override@JsonKey() final  RouteBuilderStatus status;
/// Duraklardaki eserlerin ad / il / konum bilgisi (arayüz dilinde).
/// Tüm katalog indirilmez: seçiciden gelen kayıt saklanır, eksikler
/// kimlikle tek istekte çözülür.
 final  Map<String, MonumentPin> _monuments;
/// Duraklardaki eserlerin ad / il / konum bilgisi (arayüz dilinde).
/// Tüm katalog indirilmez: seçiciden gelen kayıt saklanır, eksikler
/// kimlikle tek istekte çözülür.
@override@JsonKey() Map<String, MonumentPin> get monuments {
  if (_monuments is EqualUnmodifiableMapView) return _monuments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_monuments);
}

/// Sunucunun döndürmediği (katalogdan kaldırılmış) durak eserleri.
 final  Set<String> _unavailableMonumentIds;
/// Sunucunun döndürmediği (katalogdan kaldırılmış) durak eserleri.
@override@JsonKey() Set<String> get unavailableMonumentIds {
  if (_unavailableMonumentIds is EqualUnmodifiableSetView) return _unavailableMonumentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_unavailableMonumentIds);
}

@override final  String? languageCode;
 final  List<RouteStopPlan> _stops;
@override@JsonKey() List<RouteStopPlan> get stops {
  if (_stops is EqualUnmodifiableListView) return _stops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stops);
}

@override@JsonKey() final  String name;
/// Düzenlenen rota; yeni rotada `null`.
@override final  String? routeId;
/// İlk gönderim denemesinden sonra doğrulama mesajları gösterilir.
@override@JsonKey() final  bool showValidation;
/// Geçersiz her gönderimde artar (aynı hatanın tekrar duyurulması).
@override@JsonKey() final  int invalidSubmissions;
/// Durak sınırına ulaşılmışken eklenmek istendiğinde artar.
@override@JsonKey() final  int limitNotices;
@override final  RouteOptimizationOutcome? optimization;
/// Karayolu matrisi beklenirken optimize butonu meşguldür.
@override@JsonKey() final  bool isOptimizing;
/// Son karayolu ön hesabı; dizi değiştiyse eskidir ([currentPreview]).
@override final  RoutePreview? preview;
@override final  Failure? loadFailure;
@override final  Failure? saveFailure;
@override final  TravelRoute? savedRoute;

/// Create a copy of RouteBuilderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteBuilderStateCopyWith<_RouteBuilderState> get copyWith => __$RouteBuilderStateCopyWithImpl<_RouteBuilderState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'RouteBuilderState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('monuments', monuments))..add(DiagnosticsProperty('unavailableMonumentIds', unavailableMonumentIds))..add(DiagnosticsProperty('languageCode', languageCode))..add(DiagnosticsProperty('stops', stops))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('routeId', routeId))..add(DiagnosticsProperty('showValidation', showValidation))..add(DiagnosticsProperty('invalidSubmissions', invalidSubmissions))..add(DiagnosticsProperty('limitNotices', limitNotices))..add(DiagnosticsProperty('optimization', optimization))..add(DiagnosticsProperty('isOptimizing', isOptimizing))..add(DiagnosticsProperty('preview', preview))..add(DiagnosticsProperty('loadFailure', loadFailure))..add(DiagnosticsProperty('saveFailure', saveFailure))..add(DiagnosticsProperty('savedRoute', savedRoute));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteBuilderState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.monuments, _monuments)&&const DeepCollectionEquality().equals(other.unavailableMonumentIds, _unavailableMonumentIds)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&const DeepCollectionEquality().equals(other.stops, _stops)&&(identical(other.name, name) || other.name == name)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.showValidation, showValidation) || other.showValidation == showValidation)&&(identical(other.invalidSubmissions, invalidSubmissions) || other.invalidSubmissions == invalidSubmissions)&&(identical(other.limitNotices, limitNotices) || other.limitNotices == limitNotices)&&(identical(other.optimization, optimization) || other.optimization == optimization)&&(identical(other.isOptimizing, isOptimizing) || other.isOptimizing == isOptimizing)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.saveFailure, saveFailure) || other.saveFailure == saveFailure)&&(identical(other.savedRoute, savedRoute) || other.savedRoute == savedRoute));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_monuments),const DeepCollectionEquality().hash(_unavailableMonumentIds),languageCode,const DeepCollectionEquality().hash(_stops),name,routeId,showValidation,invalidSubmissions,limitNotices,optimization,isOptimizing,preview,loadFailure,saveFailure,savedRoute);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'RouteBuilderState(status: $status, monuments: $monuments, unavailableMonumentIds: $unavailableMonumentIds, languageCode: $languageCode, stops: $stops, name: $name, routeId: $routeId, showValidation: $showValidation, invalidSubmissions: $invalidSubmissions, limitNotices: $limitNotices, optimization: $optimization, isOptimizing: $isOptimizing, preview: $preview, loadFailure: $loadFailure, saveFailure: $saveFailure, savedRoute: $savedRoute)';
}


}

/// @nodoc
abstract mixin class _$RouteBuilderStateCopyWith<$Res> implements $RouteBuilderStateCopyWith<$Res> {
  factory _$RouteBuilderStateCopyWith(_RouteBuilderState value, $Res Function(_RouteBuilderState) _then) = __$RouteBuilderStateCopyWithImpl;
@override @useResult
$Res call({
 RouteBuilderStatus status, Map<String, MonumentPin> monuments, Set<String> unavailableMonumentIds, String? languageCode, List<RouteStopPlan> stops, String name, String? routeId, bool showValidation, int invalidSubmissions, int limitNotices, RouteOptimizationOutcome? optimization, bool isOptimizing, RoutePreview? preview, Failure? loadFailure, Failure? saveFailure, TravelRoute? savedRoute
});


@override $RouteOptimizationOutcomeCopyWith<$Res>? get optimization;

}
/// @nodoc
class __$RouteBuilderStateCopyWithImpl<$Res>
    implements _$RouteBuilderStateCopyWith<$Res> {
  __$RouteBuilderStateCopyWithImpl(this._self, this._then);

  final _RouteBuilderState _self;
  final $Res Function(_RouteBuilderState) _then;

/// Create a copy of RouteBuilderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? monuments = null,Object? unavailableMonumentIds = null,Object? languageCode = freezed,Object? stops = null,Object? name = null,Object? routeId = freezed,Object? showValidation = null,Object? invalidSubmissions = null,Object? limitNotices = null,Object? optimization = freezed,Object? isOptimizing = null,Object? preview = freezed,Object? loadFailure = freezed,Object? saveFailure = freezed,Object? savedRoute = freezed,}) {
  return _then(_RouteBuilderState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RouteBuilderStatus,monuments: null == monuments ? _self._monuments : monuments // ignore: cast_nullable_to_non_nullable
as Map<String, MonumentPin>,unavailableMonumentIds: null == unavailableMonumentIds ? _self._unavailableMonumentIds : unavailableMonumentIds // ignore: cast_nullable_to_non_nullable
as Set<String>,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,stops: null == stops ? _self._stops : stops // ignore: cast_nullable_to_non_nullable
as List<RouteStopPlan>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,routeId: freezed == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String?,showValidation: null == showValidation ? _self.showValidation : showValidation // ignore: cast_nullable_to_non_nullable
as bool,invalidSubmissions: null == invalidSubmissions ? _self.invalidSubmissions : invalidSubmissions // ignore: cast_nullable_to_non_nullable
as int,limitNotices: null == limitNotices ? _self.limitNotices : limitNotices // ignore: cast_nullable_to_non_nullable
as int,optimization: freezed == optimization ? _self.optimization : optimization // ignore: cast_nullable_to_non_nullable
as RouteOptimizationOutcome?,isOptimizing: null == isOptimizing ? _self.isOptimizing : isOptimizing // ignore: cast_nullable_to_non_nullable
as bool,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as RoutePreview?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as Failure?,saveFailure: freezed == saveFailure ? _self.saveFailure : saveFailure // ignore: cast_nullable_to_non_nullable
as Failure?,savedRoute: freezed == savedRoute ? _self.savedRoute : savedRoute // ignore: cast_nullable_to_non_nullable
as TravelRoute?,
  ));
}

/// Create a copy of RouteBuilderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteOptimizationOutcomeCopyWith<$Res>? get optimization {
    if (_self.optimization == null) {
    return null;
  }

  return $RouteOptimizationOutcomeCopyWith<$Res>(_self.optimization!, (value) {
    return _then(_self.copyWith(optimization: value));
  });
}
}

// dart format on
