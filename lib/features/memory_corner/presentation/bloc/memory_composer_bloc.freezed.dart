// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_composer_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemoryComposerEvent implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryComposerEvent'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryComposerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryComposerEvent()';
}


}

/// @nodoc
class $MemoryComposerEventCopyWith<$Res>  {
$MemoryComposerEventCopyWith(MemoryComposerEvent _, $Res Function(MemoryComposerEvent) __);
}


/// Adds pattern-matching-related methods to [MemoryComposerEvent].
extension MemoryComposerEventPatterns on MemoryComposerEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MemoryComposerStarted value)?  started,TResult Function( MemoryTextChanged value)?  textChanged,TResult Function( MemoryVisitDateChanged value)?  visitDateChanged,TResult Function( MemoryPhotosRequested value)?  photosRequested,TResult Function( MemoryPhotoRemoved value)?  photoRemoved,TResult Function( MemoryPhotoDescriptionChanged value)?  photoDescriptionChanged,TResult Function( MemorySubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MemoryComposerStarted() when started != null:
return started(_that);case MemoryTextChanged() when textChanged != null:
return textChanged(_that);case MemoryVisitDateChanged() when visitDateChanged != null:
return visitDateChanged(_that);case MemoryPhotosRequested() when photosRequested != null:
return photosRequested(_that);case MemoryPhotoRemoved() when photoRemoved != null:
return photoRemoved(_that);case MemoryPhotoDescriptionChanged() when photoDescriptionChanged != null:
return photoDescriptionChanged(_that);case MemorySubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MemoryComposerStarted value)  started,required TResult Function( MemoryTextChanged value)  textChanged,required TResult Function( MemoryVisitDateChanged value)  visitDateChanged,required TResult Function( MemoryPhotosRequested value)  photosRequested,required TResult Function( MemoryPhotoRemoved value)  photoRemoved,required TResult Function( MemoryPhotoDescriptionChanged value)  photoDescriptionChanged,required TResult Function( MemorySubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case MemoryComposerStarted():
return started(_that);case MemoryTextChanged():
return textChanged(_that);case MemoryVisitDateChanged():
return visitDateChanged(_that);case MemoryPhotosRequested():
return photosRequested(_that);case MemoryPhotoRemoved():
return photoRemoved(_that);case MemoryPhotoDescriptionChanged():
return photoDescriptionChanged(_that);case MemorySubmitted():
return submitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MemoryComposerStarted value)?  started,TResult? Function( MemoryTextChanged value)?  textChanged,TResult? Function( MemoryVisitDateChanged value)?  visitDateChanged,TResult? Function( MemoryPhotosRequested value)?  photosRequested,TResult? Function( MemoryPhotoRemoved value)?  photoRemoved,TResult? Function( MemoryPhotoDescriptionChanged value)?  photoDescriptionChanged,TResult? Function( MemorySubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case MemoryComposerStarted() when started != null:
return started(_that);case MemoryTextChanged() when textChanged != null:
return textChanged(_that);case MemoryVisitDateChanged() when visitDateChanged != null:
return visitDateChanged(_that);case MemoryPhotosRequested() when photosRequested != null:
return photosRequested(_that);case MemoryPhotoRemoved() when photoRemoved != null:
return photoRemoved(_that);case MemoryPhotoDescriptionChanged() when photoDescriptionChanged != null:
return photoDescriptionChanged(_that);case MemorySubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String monumentId,  String languageCode)?  started,TResult Function( String text)?  textChanged,TResult Function( DateTime? date)?  visitDateChanged,TResult Function( PhotoSource source)?  photosRequested,TResult Function( String localId)?  photoRemoved,TResult Function( String localId,  String description)?  photoDescriptionChanged,TResult Function()?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MemoryComposerStarted() when started != null:
return started(_that.monumentId,_that.languageCode);case MemoryTextChanged() when textChanged != null:
return textChanged(_that.text);case MemoryVisitDateChanged() when visitDateChanged != null:
return visitDateChanged(_that.date);case MemoryPhotosRequested() when photosRequested != null:
return photosRequested(_that.source);case MemoryPhotoRemoved() when photoRemoved != null:
return photoRemoved(_that.localId);case MemoryPhotoDescriptionChanged() when photoDescriptionChanged != null:
return photoDescriptionChanged(_that.localId,_that.description);case MemorySubmitted() when submitted != null:
return submitted();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String monumentId,  String languageCode)  started,required TResult Function( String text)  textChanged,required TResult Function( DateTime? date)  visitDateChanged,required TResult Function( PhotoSource source)  photosRequested,required TResult Function( String localId)  photoRemoved,required TResult Function( String localId,  String description)  photoDescriptionChanged,required TResult Function()  submitted,}) {final _that = this;
switch (_that) {
case MemoryComposerStarted():
return started(_that.monumentId,_that.languageCode);case MemoryTextChanged():
return textChanged(_that.text);case MemoryVisitDateChanged():
return visitDateChanged(_that.date);case MemoryPhotosRequested():
return photosRequested(_that.source);case MemoryPhotoRemoved():
return photoRemoved(_that.localId);case MemoryPhotoDescriptionChanged():
return photoDescriptionChanged(_that.localId,_that.description);case MemorySubmitted():
return submitted();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String monumentId,  String languageCode)?  started,TResult? Function( String text)?  textChanged,TResult? Function( DateTime? date)?  visitDateChanged,TResult? Function( PhotoSource source)?  photosRequested,TResult? Function( String localId)?  photoRemoved,TResult? Function( String localId,  String description)?  photoDescriptionChanged,TResult? Function()?  submitted,}) {final _that = this;
switch (_that) {
case MemoryComposerStarted() when started != null:
return started(_that.monumentId,_that.languageCode);case MemoryTextChanged() when textChanged != null:
return textChanged(_that.text);case MemoryVisitDateChanged() when visitDateChanged != null:
return visitDateChanged(_that.date);case MemoryPhotosRequested() when photosRequested != null:
return photosRequested(_that.source);case MemoryPhotoRemoved() when photoRemoved != null:
return photoRemoved(_that.localId);case MemoryPhotoDescriptionChanged() when photoDescriptionChanged != null:
return photoDescriptionChanged(_that.localId,_that.description);case MemorySubmitted() when submitted != null:
return submitted();case _:
  return null;

}
}

}

/// @nodoc


class MemoryComposerStarted with DiagnosticableTreeMixin implements MemoryComposerEvent {
  const MemoryComposerStarted({required this.monumentId, required this.languageCode});
  

 final  String monumentId;
 final  String languageCode;

/// Create a copy of MemoryComposerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryComposerStartedCopyWith<MemoryComposerStarted> get copyWith => _$MemoryComposerStartedCopyWithImpl<MemoryComposerStarted>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryComposerEvent.started'))
    ..add(DiagnosticsProperty('monumentId', monumentId))..add(DiagnosticsProperty('languageCode', languageCode));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryComposerStarted&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,monumentId,languageCode);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryComposerEvent.started(monumentId: $monumentId, languageCode: $languageCode)';
}


}

/// @nodoc
abstract mixin class $MemoryComposerStartedCopyWith<$Res> implements $MemoryComposerEventCopyWith<$Res> {
  factory $MemoryComposerStartedCopyWith(MemoryComposerStarted value, $Res Function(MemoryComposerStarted) _then) = _$MemoryComposerStartedCopyWithImpl;
@useResult
$Res call({
 String monumentId, String languageCode
});




}
/// @nodoc
class _$MemoryComposerStartedCopyWithImpl<$Res>
    implements $MemoryComposerStartedCopyWith<$Res> {
  _$MemoryComposerStartedCopyWithImpl(this._self, this._then);

  final MemoryComposerStarted _self;
  final $Res Function(MemoryComposerStarted) _then;

/// Create a copy of MemoryComposerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? monumentId = null,Object? languageCode = null,}) {
  return _then(MemoryComposerStarted(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MemoryTextChanged with DiagnosticableTreeMixin implements MemoryComposerEvent {
  const MemoryTextChanged(this.text);
  

 final  String text;

/// Create a copy of MemoryComposerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryTextChangedCopyWith<MemoryTextChanged> get copyWith => _$MemoryTextChangedCopyWithImpl<MemoryTextChanged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryComposerEvent.textChanged'))
    ..add(DiagnosticsProperty('text', text));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryTextChanged&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryComposerEvent.textChanged(text: $text)';
}


}

/// @nodoc
abstract mixin class $MemoryTextChangedCopyWith<$Res> implements $MemoryComposerEventCopyWith<$Res> {
  factory $MemoryTextChangedCopyWith(MemoryTextChanged value, $Res Function(MemoryTextChanged) _then) = _$MemoryTextChangedCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$MemoryTextChangedCopyWithImpl<$Res>
    implements $MemoryTextChangedCopyWith<$Res> {
  _$MemoryTextChangedCopyWithImpl(this._self, this._then);

  final MemoryTextChanged _self;
  final $Res Function(MemoryTextChanged) _then;

/// Create a copy of MemoryComposerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(MemoryTextChanged(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MemoryVisitDateChanged with DiagnosticableTreeMixin implements MemoryComposerEvent {
  const MemoryVisitDateChanged(this.date);
  

 final  DateTime? date;

/// Create a copy of MemoryComposerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryVisitDateChangedCopyWith<MemoryVisitDateChanged> get copyWith => _$MemoryVisitDateChangedCopyWithImpl<MemoryVisitDateChanged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryComposerEvent.visitDateChanged'))
    ..add(DiagnosticsProperty('date', date));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryVisitDateChanged&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryComposerEvent.visitDateChanged(date: $date)';
}


}

/// @nodoc
abstract mixin class $MemoryVisitDateChangedCopyWith<$Res> implements $MemoryComposerEventCopyWith<$Res> {
  factory $MemoryVisitDateChangedCopyWith(MemoryVisitDateChanged value, $Res Function(MemoryVisitDateChanged) _then) = _$MemoryVisitDateChangedCopyWithImpl;
@useResult
$Res call({
 DateTime? date
});




}
/// @nodoc
class _$MemoryVisitDateChangedCopyWithImpl<$Res>
    implements $MemoryVisitDateChangedCopyWith<$Res> {
  _$MemoryVisitDateChangedCopyWithImpl(this._self, this._then);

  final MemoryVisitDateChanged _self;
  final $Res Function(MemoryVisitDateChanged) _then;

/// Create a copy of MemoryComposerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? date = freezed,}) {
  return _then(MemoryVisitDateChanged(
freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc


class MemoryPhotosRequested with DiagnosticableTreeMixin implements MemoryComposerEvent {
  const MemoryPhotosRequested(this.source);
  

 final  PhotoSource source;

/// Create a copy of MemoryComposerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryPhotosRequestedCopyWith<MemoryPhotosRequested> get copyWith => _$MemoryPhotosRequestedCopyWithImpl<MemoryPhotosRequested>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryComposerEvent.photosRequested'))
    ..add(DiagnosticsProperty('source', source));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryPhotosRequested&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode {
    return Object.hash(runtimeType,source);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryComposerEvent.photosRequested(source: $source)';
}


}

/// @nodoc
abstract mixin class $MemoryPhotosRequestedCopyWith<$Res> implements $MemoryComposerEventCopyWith<$Res> {
  factory $MemoryPhotosRequestedCopyWith(MemoryPhotosRequested value, $Res Function(MemoryPhotosRequested) _then) = _$MemoryPhotosRequestedCopyWithImpl;
@useResult
$Res call({
 PhotoSource source
});




}
/// @nodoc
class _$MemoryPhotosRequestedCopyWithImpl<$Res>
    implements $MemoryPhotosRequestedCopyWith<$Res> {
  _$MemoryPhotosRequestedCopyWithImpl(this._self, this._then);

  final MemoryPhotosRequested _self;
  final $Res Function(MemoryPhotosRequested) _then;

/// Create a copy of MemoryComposerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? source = null,}) {
  return _then(MemoryPhotosRequested(
null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as PhotoSource,
  ));
}


}

/// @nodoc


class MemoryPhotoRemoved with DiagnosticableTreeMixin implements MemoryComposerEvent {
  const MemoryPhotoRemoved(this.localId);
  

 final  String localId;

/// Create a copy of MemoryComposerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryPhotoRemovedCopyWith<MemoryPhotoRemoved> get copyWith => _$MemoryPhotoRemovedCopyWithImpl<MemoryPhotoRemoved>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryComposerEvent.photoRemoved'))
    ..add(DiagnosticsProperty('localId', localId));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryPhotoRemoved&&(identical(other.localId, localId) || other.localId == localId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,localId);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryComposerEvent.photoRemoved(localId: $localId)';
}


}

/// @nodoc
abstract mixin class $MemoryPhotoRemovedCopyWith<$Res> implements $MemoryComposerEventCopyWith<$Res> {
  factory $MemoryPhotoRemovedCopyWith(MemoryPhotoRemoved value, $Res Function(MemoryPhotoRemoved) _then) = _$MemoryPhotoRemovedCopyWithImpl;
@useResult
$Res call({
 String localId
});




}
/// @nodoc
class _$MemoryPhotoRemovedCopyWithImpl<$Res>
    implements $MemoryPhotoRemovedCopyWith<$Res> {
  _$MemoryPhotoRemovedCopyWithImpl(this._self, this._then);

  final MemoryPhotoRemoved _self;
  final $Res Function(MemoryPhotoRemoved) _then;

/// Create a copy of MemoryComposerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? localId = null,}) {
  return _then(MemoryPhotoRemoved(
null == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MemoryPhotoDescriptionChanged with DiagnosticableTreeMixin implements MemoryComposerEvent {
  const MemoryPhotoDescriptionChanged({required this.localId, required this.description});
  

 final  String localId;
 final  String description;

/// Create a copy of MemoryComposerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryPhotoDescriptionChangedCopyWith<MemoryPhotoDescriptionChanged> get copyWith => _$MemoryPhotoDescriptionChangedCopyWithImpl<MemoryPhotoDescriptionChanged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryComposerEvent.photoDescriptionChanged'))
    ..add(DiagnosticsProperty('localId', localId))..add(DiagnosticsProperty('description', description));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryPhotoDescriptionChanged&&(identical(other.localId, localId) || other.localId == localId)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode {
    return Object.hash(runtimeType,localId,description);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryComposerEvent.photoDescriptionChanged(localId: $localId, description: $description)';
}


}

/// @nodoc
abstract mixin class $MemoryPhotoDescriptionChangedCopyWith<$Res> implements $MemoryComposerEventCopyWith<$Res> {
  factory $MemoryPhotoDescriptionChangedCopyWith(MemoryPhotoDescriptionChanged value, $Res Function(MemoryPhotoDescriptionChanged) _then) = _$MemoryPhotoDescriptionChangedCopyWithImpl;
@useResult
$Res call({
 String localId, String description
});




}
/// @nodoc
class _$MemoryPhotoDescriptionChangedCopyWithImpl<$Res>
    implements $MemoryPhotoDescriptionChangedCopyWith<$Res> {
  _$MemoryPhotoDescriptionChangedCopyWithImpl(this._self, this._then);

  final MemoryPhotoDescriptionChanged _self;
  final $Res Function(MemoryPhotoDescriptionChanged) _then;

/// Create a copy of MemoryComposerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? localId = null,Object? description = null,}) {
  return _then(MemoryPhotoDescriptionChanged(
localId: null == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MemorySubmitted with DiagnosticableTreeMixin implements MemoryComposerEvent {
  const MemorySubmitted();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryComposerEvent.submitted'))
    ;
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MemorySubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryComposerEvent.submitted()';
}


}




/// @nodoc
mixin _$MemoryComposerState implements DiagnosticableTreeMixin {

 String get monumentId; String? get monumentName;/// "İlçe, İl".
 String? get monumentPlace; MemoryComposerStatus get status; Failure? get monumentFailure; String get text; DateTime? get visitedOn; List<PhotoDraft> get photos;/// Hazırlanmakta olan (küçültülen) fotoğraf sayısı.
 int get processingPhotos;/// İlk gönderme denemesinden sonra alan hataları gösterilir.
 bool get showValidation;/// Her gönderme denemesinde artar (geçersizse ilk hatalı alana odaklanılır).
 int get submitAttempts;/// 0–1; yalnızca fotoğraf yüklenirken.
 double? get uploadProgress; Failure? get submitFailure; Memory? get created; PhotoNotice? get photoNotice; int get photoNoticeCount;
/// Create a copy of MemoryComposerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryComposerStateCopyWith<MemoryComposerState> get copyWith => _$MemoryComposerStateCopyWithImpl<MemoryComposerState>(this as MemoryComposerState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as MemoryComposerState;
  properties
    ..add(DiagnosticsProperty('type', 'MemoryComposerState'))
    ..add(DiagnosticsProperty('monumentId', _this.monumentId))..add(DiagnosticsProperty('monumentName', _this.monumentName))..add(DiagnosticsProperty('monumentPlace', _this.monumentPlace))..add(DiagnosticsProperty('status', _this.status))..add(DiagnosticsProperty('monumentFailure', _this.monumentFailure))..add(DiagnosticsProperty('text', _this.text))..add(DiagnosticsProperty('visitedOn', _this.visitedOn))..add(DiagnosticsProperty('photos', _this.photos))..add(DiagnosticsProperty('processingPhotos', _this.processingPhotos))..add(DiagnosticsProperty('showValidation', _this.showValidation))..add(DiagnosticsProperty('submitAttempts', _this.submitAttempts))..add(DiagnosticsProperty('uploadProgress', _this.uploadProgress))..add(DiagnosticsProperty('submitFailure', _this.submitFailure))..add(DiagnosticsProperty('created', _this.created))..add(DiagnosticsProperty('photoNotice', _this.photoNotice))..add(DiagnosticsProperty('photoNoticeCount', _this.photoNoticeCount));
}

@override
bool operator ==(Object other) {
  final _this = this as MemoryComposerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryComposerState&&(identical(other.monumentId, _this.monumentId) || other.monumentId == _this.monumentId)&&(identical(other.monumentName, _this.monumentName) || other.monumentName == _this.monumentName)&&(identical(other.monumentPlace, _this.monumentPlace) || other.monumentPlace == _this.monumentPlace)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.monumentFailure, _this.monumentFailure) || other.monumentFailure == _this.monumentFailure)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.visitedOn, _this.visitedOn) || other.visitedOn == _this.visitedOn)&&const DeepCollectionEquality().equals(other.photos, _this.photos)&&(identical(other.processingPhotos, _this.processingPhotos) || other.processingPhotos == _this.processingPhotos)&&(identical(other.showValidation, _this.showValidation) || other.showValidation == _this.showValidation)&&(identical(other.submitAttempts, _this.submitAttempts) || other.submitAttempts == _this.submitAttempts)&&(identical(other.uploadProgress, _this.uploadProgress) || other.uploadProgress == _this.uploadProgress)&&(identical(other.submitFailure, _this.submitFailure) || other.submitFailure == _this.submitFailure)&&(identical(other.created, _this.created) || other.created == _this.created)&&(identical(other.photoNotice, _this.photoNotice) || other.photoNotice == _this.photoNotice)&&(identical(other.photoNoticeCount, _this.photoNoticeCount) || other.photoNoticeCount == _this.photoNoticeCount));
}


@override
int get hashCode {
  final _this = this as MemoryComposerState;
  return Object.hash(runtimeType,_this.monumentId,_this.monumentName,_this.monumentPlace,_this.status,_this.monumentFailure,_this.text,_this.visitedOn,const DeepCollectionEquality().hash(_this.photos),_this.processingPhotos,_this.showValidation,_this.submitAttempts,_this.uploadProgress,_this.submitFailure,_this.created,_this.photoNotice,_this.photoNoticeCount);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as MemoryComposerState;
  return 'MemoryComposerState(monumentId: ${_this.monumentId}, monumentName: ${_this.monumentName}, monumentPlace: ${_this.monumentPlace}, status: ${_this.status}, monumentFailure: ${_this.monumentFailure}, text: ${_this.text}, visitedOn: ${_this.visitedOn}, photos: ${_this.photos}, processingPhotos: ${_this.processingPhotos}, showValidation: ${_this.showValidation}, submitAttempts: ${_this.submitAttempts}, uploadProgress: ${_this.uploadProgress}, submitFailure: ${_this.submitFailure}, created: ${_this.created}, photoNotice: ${_this.photoNotice}, photoNoticeCount: ${_this.photoNoticeCount})';
}


}

/// @nodoc
abstract mixin class $MemoryComposerStateCopyWith<$Res>  {
  factory $MemoryComposerStateCopyWith(MemoryComposerState value, $Res Function(MemoryComposerState) _then) = _$MemoryComposerStateCopyWithImpl;
@useResult
$Res call({
 String monumentId, String? monumentName, String? monumentPlace, MemoryComposerStatus status, Failure? monumentFailure, String text, DateTime? visitedOn, List<PhotoDraft> photos, int processingPhotos, bool showValidation, int submitAttempts, double? uploadProgress, Failure? submitFailure, Memory? created, PhotoNotice? photoNotice, int photoNoticeCount
});




}
/// @nodoc
class _$MemoryComposerStateCopyWithImpl<$Res>
    implements $MemoryComposerStateCopyWith<$Res> {
  _$MemoryComposerStateCopyWithImpl(this._self, this._then);

  final MemoryComposerState _self;
  final $Res Function(MemoryComposerState) _then;

/// Create a copy of MemoryComposerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monumentId = null,Object? monumentName = freezed,Object? monumentPlace = freezed,Object? status = null,Object? monumentFailure = freezed,Object? text = null,Object? visitedOn = freezed,Object? photos = null,Object? processingPhotos = null,Object? showValidation = null,Object? submitAttempts = null,Object? uploadProgress = freezed,Object? submitFailure = freezed,Object? created = freezed,Object? photoNotice = freezed,Object? photoNoticeCount = null,}) {
  return _then(MemoryComposerState(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,monumentName: freezed == monumentName ? _self.monumentName : monumentName // ignore: cast_nullable_to_non_nullable
as String?,monumentPlace: freezed == monumentPlace ? _self.monumentPlace : monumentPlace // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemoryComposerStatus,monumentFailure: freezed == monumentFailure ? _self.monumentFailure : monumentFailure // ignore: cast_nullable_to_non_nullable
as Failure?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,visitedOn: freezed == visitedOn ? _self.visitedOn : visitedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<PhotoDraft>,processingPhotos: null == processingPhotos ? _self.processingPhotos : processingPhotos // ignore: cast_nullable_to_non_nullable
as int,showValidation: null == showValidation ? _self.showValidation : showValidation // ignore: cast_nullable_to_non_nullable
as bool,submitAttempts: null == submitAttempts ? _self.submitAttempts : submitAttempts // ignore: cast_nullable_to_non_nullable
as int,uploadProgress: freezed == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double?,submitFailure: freezed == submitFailure ? _self.submitFailure : submitFailure // ignore: cast_nullable_to_non_nullable
as Failure?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as Memory?,photoNotice: freezed == photoNotice ? _self.photoNotice : photoNotice // ignore: cast_nullable_to_non_nullable
as PhotoNotice?,photoNoticeCount: null == photoNoticeCount ? _self.photoNoticeCount : photoNoticeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryComposerState].
extension MemoryComposerStatePatterns on MemoryComposerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryComposerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryComposerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryComposerState value)  $default,){
final _that = this;
switch (_that) {
case _MemoryComposerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryComposerState value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryComposerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String monumentId,  String? monumentName,  String? monumentPlace,  MemoryComposerStatus status,  Failure? monumentFailure,  String text,  DateTime? visitedOn,  List<PhotoDraft> photos,  int processingPhotos,  bool showValidation,  int submitAttempts,  double? uploadProgress,  Failure? submitFailure,  Memory? created,  PhotoNotice? photoNotice,  int photoNoticeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoryComposerState() when $default != null:
return $default(_that.monumentId,_that.monumentName,_that.monumentPlace,_that.status,_that.monumentFailure,_that.text,_that.visitedOn,_that.photos,_that.processingPhotos,_that.showValidation,_that.submitAttempts,_that.uploadProgress,_that.submitFailure,_that.created,_that.photoNotice,_that.photoNoticeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String monumentId,  String? monumentName,  String? monumentPlace,  MemoryComposerStatus status,  Failure? monumentFailure,  String text,  DateTime? visitedOn,  List<PhotoDraft> photos,  int processingPhotos,  bool showValidation,  int submitAttempts,  double? uploadProgress,  Failure? submitFailure,  Memory? created,  PhotoNotice? photoNotice,  int photoNoticeCount)  $default,) {final _that = this;
switch (_that) {
case _MemoryComposerState():
return $default(_that.monumentId,_that.monumentName,_that.monumentPlace,_that.status,_that.monumentFailure,_that.text,_that.visitedOn,_that.photos,_that.processingPhotos,_that.showValidation,_that.submitAttempts,_that.uploadProgress,_that.submitFailure,_that.created,_that.photoNotice,_that.photoNoticeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String monumentId,  String? monumentName,  String? monumentPlace,  MemoryComposerStatus status,  Failure? monumentFailure,  String text,  DateTime? visitedOn,  List<PhotoDraft> photos,  int processingPhotos,  bool showValidation,  int submitAttempts,  double? uploadProgress,  Failure? submitFailure,  Memory? created,  PhotoNotice? photoNotice,  int photoNoticeCount)?  $default,) {final _that = this;
switch (_that) {
case _MemoryComposerState() when $default != null:
return $default(_that.monumentId,_that.monumentName,_that.monumentPlace,_that.status,_that.monumentFailure,_that.text,_that.visitedOn,_that.photos,_that.processingPhotos,_that.showValidation,_that.submitAttempts,_that.uploadProgress,_that.submitFailure,_that.created,_that.photoNotice,_that.photoNoticeCount);case _:
  return null;

}
}

}

/// @nodoc


class _MemoryComposerState extends MemoryComposerState with DiagnosticableTreeMixin {
  const _MemoryComposerState({this.monumentId = '', this.monumentName, this.monumentPlace, this.status = MemoryComposerStatus.loadingMonument, this.monumentFailure, this.text = '', this.visitedOn,  List<PhotoDraft> photos = const <PhotoDraft>[], this.processingPhotos = 0, this.showValidation = false, this.submitAttempts = 0, this.uploadProgress, this.submitFailure, this.created, this.photoNotice, this.photoNoticeCount = 0}): _photos = photos,super._();
  

@override@JsonKey() final  String monumentId;
@override final  String? monumentName;
/// "İlçe, İl".
@override final  String? monumentPlace;
@override@JsonKey() final  MemoryComposerStatus status;
@override final  Failure? monumentFailure;
@override@JsonKey() final  String text;
@override final  DateTime? visitedOn;
 final  List<PhotoDraft> _photos;
@override@JsonKey() List<PhotoDraft> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

/// Hazırlanmakta olan (küçültülen) fotoğraf sayısı.
@override@JsonKey() final  int processingPhotos;
/// İlk gönderme denemesinden sonra alan hataları gösterilir.
@override@JsonKey() final  bool showValidation;
/// Her gönderme denemesinde artar (geçersizse ilk hatalı alana odaklanılır).
@override@JsonKey() final  int submitAttempts;
/// 0–1; yalnızca fotoğraf yüklenirken.
@override final  double? uploadProgress;
@override final  Failure? submitFailure;
@override final  Memory? created;
@override final  PhotoNotice? photoNotice;
@override@JsonKey() final  int photoNoticeCount;

/// Create a copy of MemoryComposerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryComposerStateCopyWith<_MemoryComposerState> get copyWith => __$MemoryComposerStateCopyWithImpl<_MemoryComposerState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MemoryComposerState'))
    ..add(DiagnosticsProperty('monumentId', monumentId))..add(DiagnosticsProperty('monumentName', monumentName))..add(DiagnosticsProperty('monumentPlace', monumentPlace))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('monumentFailure', monumentFailure))..add(DiagnosticsProperty('text', text))..add(DiagnosticsProperty('visitedOn', visitedOn))..add(DiagnosticsProperty('photos', photos))..add(DiagnosticsProperty('processingPhotos', processingPhotos))..add(DiagnosticsProperty('showValidation', showValidation))..add(DiagnosticsProperty('submitAttempts', submitAttempts))..add(DiagnosticsProperty('uploadProgress', uploadProgress))..add(DiagnosticsProperty('submitFailure', submitFailure))..add(DiagnosticsProperty('created', created))..add(DiagnosticsProperty('photoNotice', photoNotice))..add(DiagnosticsProperty('photoNoticeCount', photoNoticeCount));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryComposerState&&(identical(other.monumentId, monumentId) || other.monumentId == monumentId)&&(identical(other.monumentName, monumentName) || other.monumentName == monumentName)&&(identical(other.monumentPlace, monumentPlace) || other.monumentPlace == monumentPlace)&&(identical(other.status, status) || other.status == status)&&(identical(other.monumentFailure, monumentFailure) || other.monumentFailure == monumentFailure)&&(identical(other.text, text) || other.text == text)&&(identical(other.visitedOn, visitedOn) || other.visitedOn == visitedOn)&&const DeepCollectionEquality().equals(other.photos, _photos)&&(identical(other.processingPhotos, processingPhotos) || other.processingPhotos == processingPhotos)&&(identical(other.showValidation, showValidation) || other.showValidation == showValidation)&&(identical(other.submitAttempts, submitAttempts) || other.submitAttempts == submitAttempts)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.submitFailure, submitFailure) || other.submitFailure == submitFailure)&&(identical(other.created, created) || other.created == created)&&(identical(other.photoNotice, photoNotice) || other.photoNotice == photoNotice)&&(identical(other.photoNoticeCount, photoNoticeCount) || other.photoNoticeCount == photoNoticeCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,monumentId,monumentName,monumentPlace,status,monumentFailure,text,visitedOn,const DeepCollectionEquality().hash(_photos),processingPhotos,showValidation,submitAttempts,uploadProgress,submitFailure,created,photoNotice,photoNoticeCount);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MemoryComposerState(monumentId: $monumentId, monumentName: $monumentName, monumentPlace: $monumentPlace, status: $status, monumentFailure: $monumentFailure, text: $text, visitedOn: $visitedOn, photos: $photos, processingPhotos: $processingPhotos, showValidation: $showValidation, submitAttempts: $submitAttempts, uploadProgress: $uploadProgress, submitFailure: $submitFailure, created: $created, photoNotice: $photoNotice, photoNoticeCount: $photoNoticeCount)';
}


}

/// @nodoc
abstract mixin class _$MemoryComposerStateCopyWith<$Res> implements $MemoryComposerStateCopyWith<$Res> {
  factory _$MemoryComposerStateCopyWith(_MemoryComposerState value, $Res Function(_MemoryComposerState) _then) = __$MemoryComposerStateCopyWithImpl;
@override @useResult
$Res call({
 String monumentId, String? monumentName, String? monumentPlace, MemoryComposerStatus status, Failure? monumentFailure, String text, DateTime? visitedOn, List<PhotoDraft> photos, int processingPhotos, bool showValidation, int submitAttempts, double? uploadProgress, Failure? submitFailure, Memory? created, PhotoNotice? photoNotice, int photoNoticeCount
});




}
/// @nodoc
class __$MemoryComposerStateCopyWithImpl<$Res>
    implements _$MemoryComposerStateCopyWith<$Res> {
  __$MemoryComposerStateCopyWithImpl(this._self, this._then);

  final _MemoryComposerState _self;
  final $Res Function(_MemoryComposerState) _then;

/// Create a copy of MemoryComposerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monumentId = null,Object? monumentName = freezed,Object? monumentPlace = freezed,Object? status = null,Object? monumentFailure = freezed,Object? text = null,Object? visitedOn = freezed,Object? photos = null,Object? processingPhotos = null,Object? showValidation = null,Object? submitAttempts = null,Object? uploadProgress = freezed,Object? submitFailure = freezed,Object? created = freezed,Object? photoNotice = freezed,Object? photoNoticeCount = null,}) {
  return _then(_MemoryComposerState(
monumentId: null == monumentId ? _self.monumentId : monumentId // ignore: cast_nullable_to_non_nullable
as String,monumentName: freezed == monumentName ? _self.monumentName : monumentName // ignore: cast_nullable_to_non_nullable
as String?,monumentPlace: freezed == monumentPlace ? _self.monumentPlace : monumentPlace // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemoryComposerStatus,monumentFailure: freezed == monumentFailure ? _self.monumentFailure : monumentFailure // ignore: cast_nullable_to_non_nullable
as Failure?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,visitedOn: freezed == visitedOn ? _self.visitedOn : visitedOn // ignore: cast_nullable_to_non_nullable
as DateTime?,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<PhotoDraft>,processingPhotos: null == processingPhotos ? _self.processingPhotos : processingPhotos // ignore: cast_nullable_to_non_nullable
as int,showValidation: null == showValidation ? _self.showValidation : showValidation // ignore: cast_nullable_to_non_nullable
as bool,submitAttempts: null == submitAttempts ? _self.submitAttempts : submitAttempts // ignore: cast_nullable_to_non_nullable
as int,uploadProgress: freezed == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double?,submitFailure: freezed == submitFailure ? _self.submitFailure : submitFailure // ignore: cast_nullable_to_non_nullable
as Failure?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as Memory?,photoNotice: freezed == photoNotice ? _self.photoNotice : photoNotice // ignore: cast_nullable_to_non_nullable
as PhotoNotice?,photoNoticeCount: null == photoNoticeCount ? _self.photoNoticeCount : photoNoticeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
