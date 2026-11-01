// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_UserDto', json, ($checkedConvert) {
      final val = _UserDto(
        id: $checkedConvert('id', (v) => v as String),
        displayName: $checkedConvert('displayName', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'displayName': instance.displayName,
  'email': instance.email,
};

_AuthResponseDto _$AuthResponseDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_AuthResponseDto', json, ($checkedConvert) {
      final val = _AuthResponseDto(
        accessToken: $checkedConvert('accessToken', (v) => v as String),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String),
        expiresIn: $checkedConvert('expiresIn', (v) => (v as num).toInt()),
        user: $checkedConvert(
          'user',
          (v) => v == null ? null : UserDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AuthResponseDtoToJson(_AuthResponseDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
      'user': instance.user?.toJson(),
    };

_VerificationChallengeDto _$VerificationChallengeDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_VerificationChallengeDto', json, ($checkedConvert) {
  final val = _VerificationChallengeDto(
    resendAfter: $checkedConvert('resendAfter', (v) => (v as num).toInt()),
    codeLength: $checkedConvert(
      'codeLength',
      (v) => (v as num?)?.toInt() ?? VerificationChallenge.defaultCodeLength,
    ),
  );
  return val;
});

Map<String, dynamic> _$VerificationChallengeDtoToJson(
  _VerificationChallengeDto instance,
) => <String, dynamic>{
  'resendAfter': instance.resendAfter,
  'codeLength': instance.codeLength,
};

_LegalDocumentDto _$LegalDocumentDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LegalDocumentDto', json, ($checkedConvert) {
      final val = _LegalDocumentDto(
        type: $checkedConvert('type', (v) => v as String),
        version: $checkedConvert('version', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        body: $checkedConvert('body', (v) => v as String),
        effectiveDate: $checkedConvert(
          'effectiveDate',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LegalDocumentDtoToJson(_LegalDocumentDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'version': instance.version,
      'title': instance.title,
      'body': instance.body,
      'effectiveDate': instance.effectiveDate.toIso8601String(),
    };
