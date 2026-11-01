import 'package:vakif_atlas/core/router/guards/auth_guard.dart';
import 'package:vakif_atlas/core/router/routes.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';

/// Açılış sırası: açılış ekranı (oturum çözülürken) → ilk açılış tanıtımı
/// (tamamlanana kadar) → [AuthGuard] kuralları.
///
/// İlk açılışta derin bağlantıyla istenen hedef `from` ile korunur ve
/// tanıtım "misafir olarak devam et" ile bitince açılır.
abstract final class LaunchGuard {
  static String? redirect({
    required AuthState auth,
    required bool onboardingCompleted,
    required Uri location,
  }) {
    final path = location.path;
    if (auth is AuthUnknown ||
        onboardingCompleted ||
        AppRoutes.isAvailableBeforeOnboarding(path)) {
      return AuthGuard.redirect(auth, location);
    }
    final requested = path == AppRoutes.splash || path == AppRoutes.login
        ? AuthGuard.safeTarget(
            location.queryParameters[AppRoutes.fromParameter],
          )
        : AuthGuard.safeTarget(location.toString());
    return AuthGuard.withFrom(AppRoutes.onboarding, requested);
  }
}
