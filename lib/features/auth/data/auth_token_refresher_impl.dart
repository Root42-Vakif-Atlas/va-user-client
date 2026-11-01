import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/network/session_events.dart';
import 'package:vakif_atlas/features/auth/data/sources/auth_local_data_source.dart';
import 'package:vakif_atlas/features/auth/data/sources/auth_remote_data_source.dart';

/// Ağ çekirdeğinin `AuthTokenRefresher` sözleşmesini uygular.
///
/// Yenileme anahtarı yoksa veya sunucu reddederse (4xx) `null` döner;
/// oturumun sonlandırılması `AuthInterceptor` → `SessionEvents` üzerinden
/// yapılır. Ağ hatası ve 5xx oturumu sonlandırmaz: istisna iletilir, anahtarlar
/// korunur ve bir sonraki istekte yenileme yeniden denenir.
@LazySingleton(as: AuthTokenRefresher)
class AuthTokenRefresherImpl implements AuthTokenRefresher {
  AuthTokenRefresherImpl(this._remote, this._local);

  final AuthTokenRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<String?> refreshAccessToken() async {
    final epoch = _local.sessionEpoch;
    final String? refreshToken;
    try {
      refreshToken = await _local.readRefreshToken();
    } on Exception {
      return null;
    }
    if (refreshToken == null) {
      return null;
    }
    try {
      final response = await _remote.refresh(refreshToken: refreshToken);
      final saved = await _local.saveRefreshedTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        epoch: epoch,
      );
      return saved ? response.accessToken : null;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status != null && status >= 400 && status < 500) {
        return null;
      }
      rethrow;
    }
  }
}
