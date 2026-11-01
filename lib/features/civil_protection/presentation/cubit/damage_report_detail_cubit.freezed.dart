// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'damage_report_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DamageReportDetailState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DamageReportDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DamageReportDetailState()';
}


}

/// @nodoc
class $DamageReportDetailStateCopyWith<$Res>  {
$DamageReportDetailStateCopyWith(DamageReportDetailState _, $Res Function(DamageReportDetailState) __);
}


/// Adds pattern-matching-related methods to [DamageReportDetailState].
extension DamageReportDetailStatePatterns on DamageReportDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DamageReportDetailLoading value)?  loading,TResult Function( DamageReportDetailLoaded value)?  loaded,TResult Function( DamageReportDetailFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DamageReportDetailLoading() when loading != null:
return loading(_that);case DamageReportDetailLoaded() when loaded != null:
return loaded(_that);case DamageReportDetailFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DamageReportDetailLoading value)  loading,required TResult Function( DamageReportDetailLoaded value)  loaded,required TResult Function( DamageReportDetailFailure value)  failure,}){
final _that = this;
switch (_that) {
case DamageReportDetailLoading():
return loading(_that);case DamageReportDetailLoaded():
return loaded(_that);case DamageReportDetailFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DamageReportDetailLoading value)?  loading,TResult? Function( DamageReportDetailLoaded value)?  loaded,TResult? Function( DamageReportDetailFailure value)?  failure,}){
final _that = this;
switch (_that) {
case DamageReportDetailLoading() when loading != null:
return loading(_that);case DamageReportDetailLoaded() when loaded != null:
return loaded(_that);case DamageReportDetailFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( DamageReport report)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DamageReportDetailLoading() when loading != null:
return loading();case DamageReportDetailLoaded() when loaded != null:
return loaded(_that.report);case DamageReportDetailFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( DamageReport report)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case DamageReportDetailLoading():
return loading();case DamageReportDetailLoaded():
return loaded(_that.report);case DamageReportDetailFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( DamageReport report)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case DamageReportDetailLoading() when loading != null:
return loading();case DamageReportDetailLoaded() when loaded != null:
return loaded(_that.report);case DamageReportDetailFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class DamageReportDetailLoading extends DamageReportDetailState {
  const DamageReportDetailLoading(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DamageReportDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'DamageReportDetailState.loading()';
}


}




/// @nodoc


class DamageReportDetailLoaded extends DamageReportDetailState {
  const DamageReportDetailLoaded(this.report): super._();
  

 final  DamageReport report;

/// Create a copy of DamageReportDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DamageReportDetailLoadedCopyWith<DamageReportDetailLoaded> get copyWith => _$DamageReportDetailLoadedCopyWithImpl<DamageReportDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DamageReportDetailLoaded&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode {
    return Object.hash(runtimeType,report);
}

@override
String toString() {
    return 'DamageReportDetailState.loaded(report: $report)';
}


}

/// @nodoc
abstract mixin class $DamageReportDetailLoadedCopyWith<$Res> implements $DamageReportDetailStateCopyWith<$Res> {
  factory $DamageReportDetailLoadedCopyWith(DamageReportDetailLoaded value, $Res Function(DamageReportDetailLoaded) _then) = _$DamageReportDetailLoadedCopyWithImpl;
@useResult
$Res call({
 DamageReport report
});




}
/// @nodoc
class _$DamageReportDetailLoadedCopyWithImpl<$Res>
    implements $DamageReportDetailLoadedCopyWith<$Res> {
  _$DamageReportDetailLoadedCopyWithImpl(this._self, this._then);

  final DamageReportDetailLoaded _self;
  final $Res Function(DamageReportDetailLoaded) _then;

/// Create a copy of DamageReportDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? report = null,}) {
  return _then(DamageReportDetailLoaded(
null == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as DamageReport,
  ));
}


}

/// @nodoc


class DamageReportDetailFailure extends DamageReportDetailState {
  const DamageReportDetailFailure(this.failure): super._();
  

 final  Failure failure;

/// Create a copy of DamageReportDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DamageReportDetailFailureCopyWith<DamageReportDetailFailure> get copyWith => _$DamageReportDetailFailureCopyWithImpl<DamageReportDetailFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DamageReportDetailFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'DamageReportDetailState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DamageReportDetailFailureCopyWith<$Res> implements $DamageReportDetailStateCopyWith<$Res> {
  factory $DamageReportDetailFailureCopyWith(DamageReportDetailFailure value, $Res Function(DamageReportDetailFailure) _then) = _$DamageReportDetailFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$DamageReportDetailFailureCopyWithImpl<$Res>
    implements $DamageReportDetailFailureCopyWith<$Res> {
  _$DamageReportDetailFailureCopyWithImpl(this._self, this._then);

  final DamageReportDetailFailure _self;
  final $Res Function(DamageReportDetailFailure) _then;

/// Create a copy of DamageReportDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(DamageReportDetailFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
