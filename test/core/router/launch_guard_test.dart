import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/router/guards/launch_guard.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  const user = UserEntity(
    id: 'usr_1',
    displayName: 'Ayşe Yılmaz',
    email: 'ayse@example.org',
  );

  String? redirect(
    String location, {
    AuthState auth = const AuthState.guest(),
    bool completed = false,
  }) => LaunchGuard.redirect(
    auth: auth,
    onboardingCompleted: completed,
    location: Uri.parse(location),
  );

  test('oturum çözülürken önce açılış ekranı beklenir', () {
    expect(redirect('/', auth: const AuthState.unknown()), '/splash');
    expect(
      redirect('/monument/m1', auth: const AuthState.unknown()),
      '/splash?from=%2Fmonument%2Fm1',
    );
  });

  test('tanıtım tamamlanmadıysa her rota tanıtıma yönlendirilir', () {
    expect(redirect('/'), '/onboarding');
    expect(redirect('/route-planner'), '/onboarding?from=%2Froute-planner');
    expect(redirect('/login'), '/onboarding');
    expect(
      redirect('/settings', auth: const AuthState.authenticated(user)),
      '/onboarding?from=%2Fsettings',
    );
  });

  test('açılış ekranındaki derin bağlantı hedefi tanıtıma taşınır', () {
    expect(
      redirect('/splash?from=%2Fmonument%2Fm1'),
      '/onboarding?from=%2Fmonument%2Fm1',
    );
    // Dış adresler hedef olarak kabul edilmez (açık yönlendirme).
    expect(redirect('/splash?from=https%3A%2F%2Fevil.example'), '/onboarding');
  });

  test('tanıtım, yasal metinler ve Erişilebilirlik tanıtımdan önce de '
      'açılır', () {
    expect(redirect('/onboarding'), isNull);
    expect(redirect('/accessibility'), isNull);
    expect(redirect('/onboarding?from=%2Froute-planner'), isNull);
    expect(redirect('/legal/privacy-notice'), isNull);
  });

  test('tanıtım tamamlandıktan sonra AuthGuard kuralları geçerlidir', () {
    expect(redirect('/', completed: true), isNull);
    expect(redirect('/profile', completed: true), '/login?from=%2Fprofile');
    expect(redirect('/splash', completed: true), '/');
    // Ayarlardan yeniden açılabilir.
    expect(redirect('/onboarding', completed: true), isNull);
  });
}
