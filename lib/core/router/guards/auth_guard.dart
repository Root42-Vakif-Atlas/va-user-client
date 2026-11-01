import 'package:vakif_atlas/core/router/routes.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';

/// Rol tabanlı rota koruması (TRD §5).
///
/// - Oturum durumu bilinmiyorsa açılış ekranında beklenir.
/// - `guest` korumalı rotaya giderse hedef hafızaya alınır ve `/login`'e
///   yönlendirilir; giriş sonrası hedefe otomatik dönülür.
/// - Hedef yalnızca uygulama içi bir yol olabilir (açık yönlendirme
///   — open redirect — engellenir).
abstract final class AuthGuard {
  /// [location] için yönlendirme adresi; yönlendirme gerekmiyorsa `null`.
  static String? redirect(AuthState auth, Uri location) {
    final path = location.path;
    final isSplash = path == AppRoutes.splash;
    final isLogin = path == AppRoutes.login;
    final requested = isSplash || isLogin
        ? safeTarget(location.queryParameters[AppRoutes.fromParameter])
        : location.toString();

    switch (auth) {
      case AuthUnknown():
        return isSplash ? null : withFrom(AppRoutes.splash, requested);

      case AuthAuthenticated():
        if (isSplash || isLogin) {
          return requested ?? AppRoutes.mapDiscovery;
        }
        // Kayıt, doğrulama ve şifre kurtarma ekranları oturum açıkken
        // anlamsızdır (ör. e-posta doğrulandıktan sonra ana sayfaya geçilir).
        return AppRoutes.isGuestOnly(path) ? AppRoutes.mapDiscovery : null;

      case AuthGuest():
        if (AppRoutes.isGuestOnly(path)) {
          return null;
        }
        final target = requested ?? AppRoutes.mapDiscovery;
        final targetPath = Uri.parse(target).path;
        if (AppRoutes.requiresAuthentication(targetPath)) {
          return withFrom(AppRoutes.login, target);
        }
        return isSplash ? target : null;
    }
  }

  /// [path]'e, ana sayfa dışındaki dönüş hedefini `from` olarak ekler.
  static String withFrom(String path, String? from) {
    if (from == null || from == AppRoutes.mapDiscovery) {
      return path;
    }
    return Uri(
      path: path,
      queryParameters: {AppRoutes.fromParameter: from},
    ).toString();
  }

  /// Yalnızca `/` ile başlayan, şema/host içermeyen uygulama içi yolları
  /// kabul eder; giriş, açılış ve tanıtım ekranlarına dönüş döngüsünü
  /// engeller.
  static String? safeTarget(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(raw);
    if (uri == null ||
        uri.hasScheme ||
        uri.hasAuthority ||
        !raw.startsWith('/') ||
        raw.startsWith('//')) {
      return null;
    }
    if (uri.path == AppRoutes.login ||
        uri.path == AppRoutes.splash ||
        uri.path == AppRoutes.onboarding) {
      return null;
    }
    return raw;
  }
}
