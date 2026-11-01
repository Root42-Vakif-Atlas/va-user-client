import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/features/auth/data/dtos/auth_dtos.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';
import 'package:vakif_atlas/features/auth/domain/entities/registration_data.dart';

/// Kimlik doğrulama uç noktaları (ana API istemcisi üzerinden).
///
/// Hatalar `DioException` (içinde `AppException`) veya bozuk gövdede
/// `CheckedFromJsonException` olarak fırlatılır.
abstract interface class AuthRemoteDataSource {
  Future<AuthResponseDto> login({
    required String email,
    required String password,
  });

  Future<UserDto> fetchCurrentUser();

  Future<void> logout({required String refreshToken});

  Future<VerificationChallengeDto> register(RegistrationData data);

  Future<AuthResponseDto> verifyEmail({
    required String email,
    required String code,
    required String password,
  });

  Future<VerificationChallengeDto> resendVerification({required String email});

  Future<VerificationChallengeDto> requestPasswordReset({
    required String email,
  });

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  /// Yeni anahtar çifti döner; diğer oturumlar sunucuda iptal edilir.
  Future<AuthResponseDto> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> deleteAccount({required String password});
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  /// Oturum gerektirmeyen uç noktalar Bearer anahtarı göndermez.
  static final Options _guest = Options(extra: {RequestExtras.skipAuth: true});

  @override
  Future<AuthResponseDto> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AuthEndpoints.login,
      data: {'email': email, 'password': password},
      options: _guest,
    );
    return AuthResponseDto.fromJson(response.data!);
  }

  @override
  Future<UserDto> fetchCurrentUser() async {
    final response = await _dio.get<Map<String, dynamic>>(AuthEndpoints.me);
    return UserDto.fromJson(response.data!);
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    await _dio.post<void>(
      AuthEndpoints.logout,
      data: {'refreshToken': refreshToken},
      options: _guest,
    );
  }

  @override
  Future<VerificationChallengeDto> register(RegistrationData data) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AuthEndpoints.register,
      data: {
        'displayName': data.displayName,
        'email': data.email,
        'password': data.password,
        'consents': {
          'acceptedTerms': data.acceptedTerms,
          'acknowledgedPrivacyNotice': data.acknowledgedPrivacyNotice,
        },
      },
      options: _guest,
    );
    return VerificationChallengeDto.fromJson(response.data!);
  }

  @override
  Future<AuthResponseDto> verifyEmail({
    required String email,
    required String code,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AuthEndpoints.verifyEmail,
      data: {'email': email, 'code': code, 'password': password},
      options: _guest,
    );
    return AuthResponseDto.fromJson(response.data!);
  }

  @override
  Future<VerificationChallengeDto> resendVerification({
    required String email,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AuthEndpoints.resendVerification,
      data: {'email': email},
      options: _guest,
    );
    return VerificationChallengeDto.fromJson(response.data!);
  }

  @override
  Future<VerificationChallengeDto> requestPasswordReset({
    required String email,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AuthEndpoints.forgotPassword,
      data: {'email': email},
      options: _guest,
    );
    return VerificationChallengeDto.fromJson(response.data!);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _dio.post<void>(
      AuthEndpoints.resetPassword,
      data: {'email': email, 'code': code, 'newPassword': newPassword},
      options: _guest,
    );
  }

  @override
  Future<AuthResponseDto> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AuthEndpoints.changePassword,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
    return AuthResponseDto.fromJson(response.data!);
  }

  @override
  Future<void> deleteAccount({required String password}) async {
    await _dio.delete<void>(
      AuthEndpoints.account,
      data: {'password': password},
    );
  }
}

/// Anahtar yenileme uç noktası.
///
/// Auth interceptor'ı içermeyen istemciyi kullanır; böylece yenileme isteği
/// kendi 401 döngüsüne girmez ve DI grafiğinde döngü oluşmaz.
abstract interface class AuthTokenRemoteDataSource {
  Future<AuthResponseDto> refresh({required String refreshToken});
}

@LazySingleton(as: AuthTokenRemoteDataSource)
class AuthTokenRemoteDataSourceImpl implements AuthTokenRemoteDataSource {
  AuthTokenRemoteDataSourceImpl(@Named(DioNames.bare) this._dio);

  final Dio _dio;

  @override
  Future<AuthResponseDto> refresh({required String refreshToken}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AuthEndpoints.refresh,
      data: {'refreshToken': refreshToken},
    );
    return AuthResponseDto.fromJson(response.data!);
  }
}

/// Sürümlü yasal metinler.
abstract interface class LegalDocumentRemoteDataSource {
  Future<LegalDocumentDto> fetch(
    LegalDocumentType type, {
    required String languageCode,
  });
}

@LazySingleton(as: LegalDocumentRemoteDataSource)
class LegalDocumentRemoteDataSourceImpl
    implements LegalDocumentRemoteDataSource {
  LegalDocumentRemoteDataSourceImpl(@Named(DioNames.api) this._dio);

  final Dio _dio;

  @override
  Future<LegalDocumentDto> fetch(
    LegalDocumentType type, {
    required String languageCode,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${AuthEndpoints.legalDocuments}/${type.slug}',
      queryParameters: {'lang': languageCode},
      options: Options(extra: {RequestExtras.skipAuth: true}),
    );
    return LegalDocumentDto.fromJson(response.data!);
  }
}

abstract final class AuthEndpoints {
  static const String login = 'auth/login';
  static const String refresh = 'auth/refresh';
  static const String me = 'auth/me';
  static const String logout = 'auth/logout';
  static const String register = 'auth/register';
  static const String verifyEmail = 'auth/verify-email';
  static const String resendVerification = 'auth/resend-verification';
  static const String forgotPassword = 'auth/password/forgot';
  static const String resetPassword = 'auth/password/reset';
  static const String changePassword = 'auth/password/change';
  static const String account = 'auth/account';
  static const String legalDocuments = 'legal/documents';
}
