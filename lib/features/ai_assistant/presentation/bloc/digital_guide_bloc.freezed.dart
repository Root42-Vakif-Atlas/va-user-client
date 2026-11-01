// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'digital_guide_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DigitalGuideEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DigitalGuideEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DigitalGuideEvent()';
}


}

/// @nodoc
class $DigitalGuideEventCopyWith<$Res>  {
$DigitalGuideEventCopyWith(DigitalGuideEvent _, $Res Function(DigitalGuideEvent) __);
}


/// Adds pattern-matching-related methods to [DigitalGuideEvent].
extension DigitalGuideEventPatterns on DigitalGuideEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GuideQuestionSubmitted value)?  questionSubmitted,TResult Function( GuideRetryRequested value)?  retryRequested,TResult Function( GuideConversationReset value)?  conversationReset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GuideQuestionSubmitted() when questionSubmitted != null:
return questionSubmitted(_that);case GuideRetryRequested() when retryRequested != null:
return retryRequested(_that);case GuideConversationReset() when conversationReset != null:
return conversationReset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GuideQuestionSubmitted value)  questionSubmitted,required TResult Function( GuideRetryRequested value)  retryRequested,required TResult Function( GuideConversationReset value)  conversationReset,}){
final _that = this;
switch (_that) {
case GuideQuestionSubmitted():
return questionSubmitted(_that);case GuideRetryRequested():
return retryRequested(_that);case GuideConversationReset():
return conversationReset(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GuideQuestionSubmitted value)?  questionSubmitted,TResult? Function( GuideRetryRequested value)?  retryRequested,TResult? Function( GuideConversationReset value)?  conversationReset,}){
final _that = this;
switch (_that) {
case GuideQuestionSubmitted() when questionSubmitted != null:
return questionSubmitted(_that);case GuideRetryRequested() when retryRequested != null:
return retryRequested(_that);case GuideConversationReset() when conversationReset != null:
return conversationReset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String question,  String languageCode)?  questionSubmitted,TResult Function( String languageCode)?  retryRequested,TResult Function()?  conversationReset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GuideQuestionSubmitted() when questionSubmitted != null:
return questionSubmitted(_that.question,_that.languageCode);case GuideRetryRequested() when retryRequested != null:
return retryRequested(_that.languageCode);case GuideConversationReset() when conversationReset != null:
return conversationReset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String question,  String languageCode)  questionSubmitted,required TResult Function( String languageCode)  retryRequested,required TResult Function()  conversationReset,}) {final _that = this;
switch (_that) {
case GuideQuestionSubmitted():
return questionSubmitted(_that.question,_that.languageCode);case GuideRetryRequested():
return retryRequested(_that.languageCode);case GuideConversationReset():
return conversationReset();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String question,  String languageCode)?  questionSubmitted,TResult? Function( String languageCode)?  retryRequested,TResult? Function()?  conversationReset,}) {final _that = this;
switch (_that) {
case GuideQuestionSubmitted() when questionSubmitted != null:
return questionSubmitted(_that.question,_that.languageCode);case GuideRetryRequested() when retryRequested != null:
return retryRequested(_that.languageCode);case GuideConversationReset() when conversationReset != null:
return conversationReset();case _:
  return null;

}
}

}

/// @nodoc


class GuideQuestionSubmitted implements DigitalGuideEvent {
  const GuideQuestionSubmitted({required this.question, required this.languageCode});
  

 final  String question;
 final  String languageCode;

/// Create a copy of DigitalGuideEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuideQuestionSubmittedCopyWith<GuideQuestionSubmitted> get copyWith => _$GuideQuestionSubmittedCopyWithImpl<GuideQuestionSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is GuideQuestionSubmitted&&(identical(other.question, question) || other.question == question)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,question,languageCode);
}

@override
String toString() {
    return 'DigitalGuideEvent.questionSubmitted(question: $question, languageCode: $languageCode)';
}


}

/// @nodoc
abstract mixin class $GuideQuestionSubmittedCopyWith<$Res> implements $DigitalGuideEventCopyWith<$Res> {
  factory $GuideQuestionSubmittedCopyWith(GuideQuestionSubmitted value, $Res Function(GuideQuestionSubmitted) _then) = _$GuideQuestionSubmittedCopyWithImpl;
@useResult
$Res call({
 String question, String languageCode
});




}
/// @nodoc
class _$GuideQuestionSubmittedCopyWithImpl<$Res>
    implements $GuideQuestionSubmittedCopyWith<$Res> {
  _$GuideQuestionSubmittedCopyWithImpl(this._self, this._then);

  final GuideQuestionSubmitted _self;
  final $Res Function(GuideQuestionSubmitted) _then;

/// Create a copy of DigitalGuideEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? question = null,Object? languageCode = null,}) {
  return _then(GuideQuestionSubmitted(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class GuideRetryRequested implements DigitalGuideEvent {
  const GuideRetryRequested({required this.languageCode});
  

 final  String languageCode;

/// Create a copy of DigitalGuideEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuideRetryRequestedCopyWith<GuideRetryRequested> get copyWith => _$GuideRetryRequestedCopyWithImpl<GuideRetryRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is GuideRetryRequested&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,languageCode);
}

@override
String toString() {
    return 'DigitalGuideEvent.retryRequested(languageCode: $languageCode)';
}


}

/// @nodoc
abstract mixin class $GuideRetryRequestedCopyWith<$Res> implements $DigitalGuideEventCopyWith<$Res> {
  factory $GuideRetryRequestedCopyWith(GuideRetryRequested value, $Res Function(GuideRetryRequested) _then) = _$GuideRetryRequestedCopyWithImpl;
@useResult
$Res call({
 String languageCode
});




}
/// @nodoc
class _$GuideRetryRequestedCopyWithImpl<$Res>
    implements $GuideRetryRequestedCopyWith<$Res> {
  _$GuideRetryRequestedCopyWithImpl(this._self, this._then);

  final GuideRetryRequested _self;
  final $Res Function(GuideRetryRequested) _then;

/// Create a copy of DigitalGuideEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? languageCode = null,}) {
  return _then(GuideRetryRequested(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class GuideConversationReset implements DigitalGuideEvent {
  const GuideConversationReset();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is GuideConversationReset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DigitalGuideEvent.conversationReset()';
}


}




/// @nodoc
mixin _$DigitalGuideState {

 List<GuideChatEntry> get entries; bool get isSending; String? get conversationId;/// Son sorunun gönderim hatası; [failedQuestion] yeniden gönderilir.
 Failure? get failure; String? get failedQuestion;/// "Yeni sohbet" ile artar; eski sohbete gelen yanıt yok sayılır.
 int get generation;
/// Create a copy of DigitalGuideState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DigitalGuideStateCopyWith<DigitalGuideState> get copyWith => _$DigitalGuideStateCopyWithImpl<DigitalGuideState>(this as DigitalGuideState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DigitalGuideState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DigitalGuideState&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.isSending, _this.isSending) || other.isSending == _this.isSending)&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.failedQuestion, _this.failedQuestion) || other.failedQuestion == _this.failedQuestion)&&(identical(other.generation, _this.generation) || other.generation == _this.generation));
}


@override
int get hashCode {
  final _this = this as DigitalGuideState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries),_this.isSending,_this.conversationId,_this.failure,_this.failedQuestion,_this.generation);
}



}

/// @nodoc
abstract mixin class $DigitalGuideStateCopyWith<$Res>  {
  factory $DigitalGuideStateCopyWith(DigitalGuideState value, $Res Function(DigitalGuideState) _then) = _$DigitalGuideStateCopyWithImpl;
@useResult
$Res call({
 List<GuideChatEntry> entries, bool isSending, String? conversationId, Failure? failure, String? failedQuestion, int generation
});




}
/// @nodoc
class _$DigitalGuideStateCopyWithImpl<$Res>
    implements $DigitalGuideStateCopyWith<$Res> {
  _$DigitalGuideStateCopyWithImpl(this._self, this._then);

  final DigitalGuideState _self;
  final $Res Function(DigitalGuideState) _then;

/// Create a copy of DigitalGuideState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? isSending = null,Object? conversationId = freezed,Object? failure = freezed,Object? failedQuestion = freezed,Object? generation = null,}) {
  return _then(DigitalGuideState(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<GuideChatEntry>,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,failedQuestion: freezed == failedQuestion ? _self.failedQuestion : failedQuestion // ignore: cast_nullable_to_non_nullable
as String?,generation: null == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DigitalGuideState].
extension DigitalGuideStatePatterns on DigitalGuideState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DigitalGuideState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DigitalGuideState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DigitalGuideState value)  $default,){
final _that = this;
switch (_that) {
case _DigitalGuideState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DigitalGuideState value)?  $default,){
final _that = this;
switch (_that) {
case _DigitalGuideState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GuideChatEntry> entries,  bool isSending,  String? conversationId,  Failure? failure,  String? failedQuestion,  int generation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DigitalGuideState() when $default != null:
return $default(_that.entries,_that.isSending,_that.conversationId,_that.failure,_that.failedQuestion,_that.generation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GuideChatEntry> entries,  bool isSending,  String? conversationId,  Failure? failure,  String? failedQuestion,  int generation)  $default,) {final _that = this;
switch (_that) {
case _DigitalGuideState():
return $default(_that.entries,_that.isSending,_that.conversationId,_that.failure,_that.failedQuestion,_that.generation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GuideChatEntry> entries,  bool isSending,  String? conversationId,  Failure? failure,  String? failedQuestion,  int generation)?  $default,) {final _that = this;
switch (_that) {
case _DigitalGuideState() when $default != null:
return $default(_that.entries,_that.isSending,_that.conversationId,_that.failure,_that.failedQuestion,_that.generation);case _:
  return null;

}
}

}

/// @nodoc


class _DigitalGuideState extends DigitalGuideState {
  const _DigitalGuideState({ List<GuideChatEntry> entries = const <GuideChatEntry>[], this.isSending = false, this.conversationId, this.failure, this.failedQuestion, this.generation = 0}): _entries = entries,super._();
  

 final  List<GuideChatEntry> _entries;
@override@JsonKey() List<GuideChatEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override@JsonKey() final  bool isSending;
@override final  String? conversationId;
/// Son sorunun gönderim hatası; [failedQuestion] yeniden gönderilir.
@override final  Failure? failure;
@override final  String? failedQuestion;
/// "Yeni sohbet" ile artar; eski sohbete gelen yanıt yok sayılır.
@override@JsonKey() final  int generation;

/// Create a copy of DigitalGuideState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DigitalGuideStateCopyWith<_DigitalGuideState> get copyWith => __$DigitalGuideStateCopyWithImpl<_DigitalGuideState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DigitalGuideState&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.failedQuestion, failedQuestion) || other.failedQuestion == failedQuestion)&&(identical(other.generation, generation) || other.generation == generation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),isSending,conversationId,failure,failedQuestion,generation);
}



}

/// @nodoc
abstract mixin class _$DigitalGuideStateCopyWith<$Res> implements $DigitalGuideStateCopyWith<$Res> {
  factory _$DigitalGuideStateCopyWith(_DigitalGuideState value, $Res Function(_DigitalGuideState) _then) = __$DigitalGuideStateCopyWithImpl;
@override @useResult
$Res call({
 List<GuideChatEntry> entries, bool isSending, String? conversationId, Failure? failure, String? failedQuestion, int generation
});




}
/// @nodoc
class __$DigitalGuideStateCopyWithImpl<$Res>
    implements _$DigitalGuideStateCopyWith<$Res> {
  __$DigitalGuideStateCopyWithImpl(this._self, this._then);

  final _DigitalGuideState _self;
  final $Res Function(_DigitalGuideState) _then;

/// Create a copy of DigitalGuideState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? isSending = null,Object? conversationId = freezed,Object? failure = freezed,Object? failedQuestion = freezed,Object? generation = null,}) {
  return _then(_DigitalGuideState(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<GuideChatEntry>,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,failedQuestion: freezed == failedQuestion ? _self.failedQuestion : failedQuestion // ignore: cast_nullable_to_non_nullable
as String?,generation: null == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
