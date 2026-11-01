import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vakif_atlas/features/auth/domain/entities/auth_tokens.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';

part 'auth_dtos.freezed.dart';
part 'auth_dtos.g.dart';

@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String displayName,
    required String email,
  }) = _UserDto;

  const UserDto._();

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  factory UserDto.fromDomain(UserEntity user) =>
      UserDto(id: user.id, displayName: user.displayName, email: user.email);

  UserEntity toDomain() =>
      UserEntity(id: id, displayName: displayName, email: email);
}

/// `auth/login`, `auth/verify-email`, `auth/refresh` ve
/// `auth/password/change` yanıtı. `user` yalnızca oturum açılışında gelir.
@freezed
abstract class AuthResponseDto with _$AuthResponseDto {
  const factory AuthResponseDto({
    required String accessToken,
    required String refreshToken,

    /// Erişim anahtarının saniye cinsinden geçerlilik süresi.
    required int expiresIn,
    UserDto? user,
  }) = _AuthResponseDto;

  const AuthResponseDto._();

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);

  AuthTokens toTokens(DateTime issuedAt) => AuthTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresAt: issuedAt.add(Duration(seconds: expiresIn)),
  );
}

/// `202 Accepted` — kod gönderimi kabul edildi.
@freezed
abstract class VerificationChallengeDto with _$VerificationChallengeDto {
  const factory VerificationChallengeDto({
    /// Yeni kod istenebilmesi için saniye cinsinden bekleme süresi.
    required int resendAfter,
    @Default(VerificationChallenge.defaultCodeLength) int codeLength,
  }) = _VerificationChallengeDto;

  const VerificationChallengeDto._();

  factory VerificationChallengeDto.fromJson(Map<String, dynamic> json) =>
      _$VerificationChallengeDtoFromJson(json);

  VerificationChallenge toDomain(String email) => VerificationChallenge(
    email: email,
    resendAfter: Duration(seconds: resendAfter),
    codeLength: codeLength,
  );
}

@freezed
abstract class LegalDocumentDto with _$LegalDocumentDto {
  const factory LegalDocumentDto({
    required String type,
    required String version,
    required String title,
    required String body,
    required DateTime effectiveDate,
  }) = _LegalDocumentDto;

  const LegalDocumentDto._();

  factory LegalDocumentDto.fromJson(Map<String, dynamic> json) =>
      _$LegalDocumentDtoFromJson(json);

  LegalDocument toDomain(LegalDocumentType documentType) => LegalDocument(
    type: documentType,
    version: version,
    title: title,
    body: body,
    effectiveDate: effectiveDate,
  );
}
