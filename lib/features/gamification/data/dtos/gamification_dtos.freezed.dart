// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GamificationProfileDto {

 int get level; String get levelTitle; int get xp; int get levelStartXp; int? get nextLevelXp; List<AchievementDto> get achievements; List<String> get unseen;
/// Create a copy of GamificationProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GamificationProfileDtoCopyWith<GamificationProfileDto> get copyWith => _$GamificationProfileDtoCopyWithImpl<GamificationProfileDto>(this as GamificationProfileDto, _$identity);

  /// Serializes this GamificationProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GamificationProfileDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GamificationProfileDto&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.levelTitle, _this.levelTitle) || other.levelTitle == _this.levelTitle)&&(identical(other.xp, _this.xp) || other.xp == _this.xp)&&(identical(other.levelStartXp, _this.levelStartXp) || other.levelStartXp == _this.levelStartXp)&&(identical(other.nextLevelXp, _this.nextLevelXp) || other.nextLevelXp == _this.nextLevelXp)&&const DeepCollectionEquality().equals(other.achievements, _this.achievements)&&const DeepCollectionEquality().equals(other.unseen, _this.unseen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GamificationProfileDto;
  return Object.hash(runtimeType,_this.level,_this.levelTitle,_this.xp,_this.levelStartXp,_this.nextLevelXp,const DeepCollectionEquality().hash(_this.achievements),const DeepCollectionEquality().hash(_this.unseen));
}

@override
String toString() {
  final _this = this as GamificationProfileDto;
  return 'GamificationProfileDto(level: ${_this.level}, levelTitle: ${_this.levelTitle}, xp: ${_this.xp}, levelStartXp: ${_this.levelStartXp}, nextLevelXp: ${_this.nextLevelXp}, achievements: ${_this.achievements}, unseen: ${_this.unseen})';
}


}

/// @nodoc
abstract mixin class $GamificationProfileDtoCopyWith<$Res>  {
  factory $GamificationProfileDtoCopyWith(GamificationProfileDto value, $Res Function(GamificationProfileDto) _then) = _$GamificationProfileDtoCopyWithImpl;
@useResult
$Res call({
 int level, String levelTitle, int xp, int levelStartXp, int? nextLevelXp, List<AchievementDto> achievements, List<String> unseen
});




}
/// @nodoc
class _$GamificationProfileDtoCopyWithImpl<$Res>
    implements $GamificationProfileDtoCopyWith<$Res> {
  _$GamificationProfileDtoCopyWithImpl(this._self, this._then);

  final GamificationProfileDto _self;
  final $Res Function(GamificationProfileDto) _then;

/// Create a copy of GamificationProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? levelTitle = null,Object? xp = null,Object? levelStartXp = null,Object? nextLevelXp = freezed,Object? achievements = null,Object? unseen = null,}) {
  return _then(GamificationProfileDto(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelTitle: null == levelTitle ? _self.levelTitle : levelTitle // ignore: cast_nullable_to_non_nullable
as String,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,levelStartXp: null == levelStartXp ? _self.levelStartXp : levelStartXp // ignore: cast_nullable_to_non_nullable
as int,nextLevelXp: freezed == nextLevelXp ? _self.nextLevelXp : nextLevelXp // ignore: cast_nullable_to_non_nullable
as int?,achievements: null == achievements ? _self.achievements : achievements // ignore: cast_nullable_to_non_nullable
as List<AchievementDto>,unseen: null == unseen ? _self.unseen : unseen // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [GamificationProfileDto].
extension GamificationProfileDtoPatterns on GamificationProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GamificationProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GamificationProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GamificationProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _GamificationProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GamificationProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _GamificationProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int level,  String levelTitle,  int xp,  int levelStartXp,  int? nextLevelXp,  List<AchievementDto> achievements,  List<String> unseen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GamificationProfileDto() when $default != null:
return $default(_that.level,_that.levelTitle,_that.xp,_that.levelStartXp,_that.nextLevelXp,_that.achievements,_that.unseen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int level,  String levelTitle,  int xp,  int levelStartXp,  int? nextLevelXp,  List<AchievementDto> achievements,  List<String> unseen)  $default,) {final _that = this;
switch (_that) {
case _GamificationProfileDto():
return $default(_that.level,_that.levelTitle,_that.xp,_that.levelStartXp,_that.nextLevelXp,_that.achievements,_that.unseen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int level,  String levelTitle,  int xp,  int levelStartXp,  int? nextLevelXp,  List<AchievementDto> achievements,  List<String> unseen)?  $default,) {final _that = this;
switch (_that) {
case _GamificationProfileDto() when $default != null:
return $default(_that.level,_that.levelTitle,_that.xp,_that.levelStartXp,_that.nextLevelXp,_that.achievements,_that.unseen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GamificationProfileDto extends GamificationProfileDto {
  const _GamificationProfileDto({required this.level, required this.levelTitle, required this.xp, required this.levelStartXp, this.nextLevelXp,  List<AchievementDto> achievements = const <AchievementDto>[],  List<String> unseen = const <String>[]}): _achievements = achievements,_unseen = unseen,super._();
  factory _GamificationProfileDto.fromJson(Map<String, dynamic> json) => _$GamificationProfileDtoFromJson(json);

@override final  int level;
@override final  String levelTitle;
@override final  int xp;
@override final  int levelStartXp;
@override final  int? nextLevelXp;
 final  List<AchievementDto> _achievements;
@override@JsonKey() List<AchievementDto> get achievements {
  if (_achievements is EqualUnmodifiableListView) return _achievements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_achievements);
}

 final  List<String> _unseen;
@override@JsonKey() List<String> get unseen {
  if (_unseen is EqualUnmodifiableListView) return _unseen;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unseen);
}


/// Create a copy of GamificationProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GamificationProfileDtoCopyWith<_GamificationProfileDto> get copyWith => __$GamificationProfileDtoCopyWithImpl<_GamificationProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GamificationProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GamificationProfileDto&&(identical(other.level, level) || other.level == level)&&(identical(other.levelTitle, levelTitle) || other.levelTitle == levelTitle)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.levelStartXp, levelStartXp) || other.levelStartXp == levelStartXp)&&(identical(other.nextLevelXp, nextLevelXp) || other.nextLevelXp == nextLevelXp)&&const DeepCollectionEquality().equals(other.achievements, _achievements)&&const DeepCollectionEquality().equals(other.unseen, _unseen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,level,levelTitle,xp,levelStartXp,nextLevelXp,const DeepCollectionEquality().hash(_achievements),const DeepCollectionEquality().hash(_unseen));
}

@override
String toString() {
    return 'GamificationProfileDto(level: $level, levelTitle: $levelTitle, xp: $xp, levelStartXp: $levelStartXp, nextLevelXp: $nextLevelXp, achievements: $achievements, unseen: $unseen)';
}


}

/// @nodoc
abstract mixin class _$GamificationProfileDtoCopyWith<$Res> implements $GamificationProfileDtoCopyWith<$Res> {
  factory _$GamificationProfileDtoCopyWith(_GamificationProfileDto value, $Res Function(_GamificationProfileDto) _then) = __$GamificationProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 int level, String levelTitle, int xp, int levelStartXp, int? nextLevelXp, List<AchievementDto> achievements, List<String> unseen
});




}
/// @nodoc
class __$GamificationProfileDtoCopyWithImpl<$Res>
    implements _$GamificationProfileDtoCopyWith<$Res> {
  __$GamificationProfileDtoCopyWithImpl(this._self, this._then);

  final _GamificationProfileDto _self;
  final $Res Function(_GamificationProfileDto) _then;

/// Create a copy of GamificationProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? levelTitle = null,Object? xp = null,Object? levelStartXp = null,Object? nextLevelXp = freezed,Object? achievements = null,Object? unseen = null,}) {
  return _then(_GamificationProfileDto(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelTitle: null == levelTitle ? _self.levelTitle : levelTitle // ignore: cast_nullable_to_non_nullable
as String,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,levelStartXp: null == levelStartXp ? _self.levelStartXp : levelStartXp // ignore: cast_nullable_to_non_nullable
as int,nextLevelXp: freezed == nextLevelXp ? _self.nextLevelXp : nextLevelXp // ignore: cast_nullable_to_non_nullable
as int?,achievements: null == achievements ? _self._achievements : achievements // ignore: cast_nullable_to_non_nullable
as List<AchievementDto>,unseen: null == unseen ? _self._unseen : unseen // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$AchievementDto {

 String get id; String get title; String get description; String get icon; int get progress; int get target; DateTime? get unlockedAt;
/// Create a copy of AchievementDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AchievementDtoCopyWith<AchievementDto> get copyWith => _$AchievementDtoCopyWithImpl<AchievementDto>(this as AchievementDto, _$identity);

  /// Serializes this AchievementDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AchievementDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AchievementDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.unlockedAt, _this.unlockedAt) || other.unlockedAt == _this.unlockedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AchievementDto;
  return Object.hash(runtimeType,_this.id,_this.title,_this.description,_this.icon,_this.progress,_this.target,_this.unlockedAt);
}

@override
String toString() {
  final _this = this as AchievementDto;
  return 'AchievementDto(id: ${_this.id}, title: ${_this.title}, description: ${_this.description}, icon: ${_this.icon}, progress: ${_this.progress}, target: ${_this.target}, unlockedAt: ${_this.unlockedAt})';
}


}

/// @nodoc
abstract mixin class $AchievementDtoCopyWith<$Res>  {
  factory $AchievementDtoCopyWith(AchievementDto value, $Res Function(AchievementDto) _then) = _$AchievementDtoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String icon, int progress, int target, DateTime? unlockedAt
});




}
/// @nodoc
class _$AchievementDtoCopyWithImpl<$Res>
    implements $AchievementDtoCopyWith<$Res> {
  _$AchievementDtoCopyWithImpl(this._self, this._then);

  final AchievementDto _self;
  final $Res Function(AchievementDto) _then;

/// Create a copy of AchievementDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? icon = null,Object? progress = null,Object? target = null,Object? unlockedAt = freezed,}) {
  return _then(AchievementDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,unlockedAt: freezed == unlockedAt ? _self.unlockedAt : unlockedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AchievementDto].
extension AchievementDtoPatterns on AchievementDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AchievementDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AchievementDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AchievementDto value)  $default,){
final _that = this;
switch (_that) {
case _AchievementDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AchievementDto value)?  $default,){
final _that = this;
switch (_that) {
case _AchievementDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String icon,  int progress,  int target,  DateTime? unlockedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AchievementDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.icon,_that.progress,_that.target,_that.unlockedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String icon,  int progress,  int target,  DateTime? unlockedAt)  $default,) {final _that = this;
switch (_that) {
case _AchievementDto():
return $default(_that.id,_that.title,_that.description,_that.icon,_that.progress,_that.target,_that.unlockedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String icon,  int progress,  int target,  DateTime? unlockedAt)?  $default,) {final _that = this;
switch (_that) {
case _AchievementDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.icon,_that.progress,_that.target,_that.unlockedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AchievementDto extends AchievementDto {
  const _AchievementDto({required this.id, required this.title, required this.description, required this.icon, required this.progress, required this.target, this.unlockedAt}): super._();
  factory _AchievementDto.fromJson(Map<String, dynamic> json) => _$AchievementDtoFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String icon;
@override final  int progress;
@override final  int target;
@override final  DateTime? unlockedAt;

/// Create a copy of AchievementDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AchievementDtoCopyWith<_AchievementDto> get copyWith => __$AchievementDtoCopyWithImpl<_AchievementDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AchievementDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AchievementDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.target, target) || other.target == target)&&(identical(other.unlockedAt, unlockedAt) || other.unlockedAt == unlockedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,description,icon,progress,target,unlockedAt);
}

@override
String toString() {
    return 'AchievementDto(id: $id, title: $title, description: $description, icon: $icon, progress: $progress, target: $target, unlockedAt: $unlockedAt)';
}


}

/// @nodoc
abstract mixin class _$AchievementDtoCopyWith<$Res> implements $AchievementDtoCopyWith<$Res> {
  factory _$AchievementDtoCopyWith(_AchievementDto value, $Res Function(_AchievementDto) _then) = __$AchievementDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String icon, int progress, int target, DateTime? unlockedAt
});




}
/// @nodoc
class __$AchievementDtoCopyWithImpl<$Res>
    implements _$AchievementDtoCopyWith<$Res> {
  __$AchievementDtoCopyWithImpl(this._self, this._then);

  final _AchievementDto _self;
  final $Res Function(_AchievementDto) _then;

/// Create a copy of AchievementDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? icon = null,Object? progress = null,Object? target = null,Object? unlockedAt = freezed,}) {
  return _then(_AchievementDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as int,unlockedAt: freezed == unlockedAt ? _self.unlockedAt : unlockedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
