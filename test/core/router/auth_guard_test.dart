import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/router/guards/auth_guard.dart';
import 'package:vakif_atlas/core/router/routes.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  const guest = AuthState.guest();
  const unknown = AuthState.unknown();
  const citizen = AuthState.authenticated(
    UserEntity(id: 'usr_1', displayName: 'Ayşe', email: 'ayse@example.org'),
  );

  String? redirect(AuthState auth, String location) =>
      AuthGuard.redirect(auth, Uri.parse(location));

  group('AppRoutes.requiresAuthentication', () {
    test('korumalı rotalar citizen gerektirir', () {
      expect(AppRoutes.requiresAuthentication('/civil-protection/new'), isTrue);
      expect(
        AppRoutes.requiresAuthentication('/civil-protection/reports/rpt_1'),
        isTrue,
      );
      expect(AppRoutes.requiresAuthentication('/profile'), isTrue);
      expect(
        AppRoutes.requiresAuthentication('/monument/42/memory-corner/new'),
        isTrue,
      );
    });

    test('anıları okumak herkese açıktır', () {
      expect(
        AppRoutes.requiresAuthentication('/monument/42/memory-corner'),
        isFalse,
      );
    });

    test('salt okunur rotalar guest için açıktır', () {
      for (final path in [
        '/',
        '/monument/42',
        '/route-planner',
        '/ai-assistant',
        '/settings',
        '/login',
      ]) {
        expect(AppRoutes.requiresAuthentication(path), isFalse, reason: path);
      }
    });
  });

  group('oturum durumu bilinmiyorken', () {
    test('açılış ekranına hedefle birlikte yönlendirir', () {
      expect(redirect(unknown, '/profile'), '/splash?from=%2Fprofile');
    });

    test('ana sayfa hedefi parametresiz taşınır', () {
      expect(redirect(unknown, '/'), '/splash');
    });

    test('açılış ekranında bekler', () {
      expect(redirect(unknown, '/splash?from=%2Fprofile'), isNull);
    });
  });

  group('guest', () {
    test('korumalı rotada hedef hafızaya alınıp girişe yönlendirilir', () {
      expect(
        redirect(guest, '/civil-protection/new'),
        '/login?from=%2Fcivil-protection%2Fnew',
      );
      // Sekme misafire tanıtım gösterir.
      expect(redirect(guest, '/civil-protection'), isNull);
      expect(
        redirect(guest, '/monument/42/memory-corner/new'),
        '/login?from=%2Fmonument%2F42%2Fmemory-corner%2Fnew',
      );
      expect(redirect(guest, '/monument/42/memory-corner'), isNull);
    });

    test('salt okunur rotalara erişebilir', () {
      expect(redirect(guest, '/'), isNull);
      expect(redirect(guest, '/monument/42'), isNull);
      expect(redirect(guest, '/route-planner'), isNull);
    });

    test('giriş ekranında kalır', () {
      expect(redirect(guest, '/login?from=%2Fprofile'), isNull);
    });

    test('açılıştan sonra korumalı hedef için girişe yönlendirilir', () {
      expect(
        redirect(guest, '/splash?from=%2Fprofile'),
        '/login?from=%2Fprofile',
      );
    });

    test('açılıştan sonra açık hedefe gider', () {
      expect(
        redirect(guest, '/splash?from=%2Froute-planner'),
        '/route-planner',
      );
      expect(redirect(guest, '/splash'), '/');
    });
  });

  group('citizen', () {
    test('korumalı rotalara erişebilir', () {
      expect(redirect(citizen, '/profile'), isNull);
      expect(redirect(citizen, '/monument/42/memory-corner/new'), isNull);
    });

    test('giriş sonrası hafızadaki hedefe döner', () {
      expect(
        redirect(citizen, '/login?from=%2Fmonument%2F42%2Fmemory-corner%2Fnew'),
        '/monument/42/memory-corner/new',
      );
    });

    test('hedef yoksa ana sayfaya gider', () {
      expect(redirect(citizen, '/login'), '/');
      expect(redirect(citizen, '/splash'), '/');
    });
  });

  group('yalnızca misafir ekranları', () {
    test('misafir kayıt ve şifre kurtarma ekranlarına erişir', () {
      for (final path in [
        '/register',
        '/verify-email',
        '/forgot-password',
        '/reset-password',
      ]) {
        expect(redirect(guest, path), isNull, reason: path);
      }
    });

    test('oturum açık kullanıcı ana sayfaya yönlendirilir', () {
      for (final path in [
        '/register',
        '/verify-email',
        '/forgot-password',
        '/reset-password',
      ]) {
        expect(redirect(citizen, path), '/', reason: path);
      }
    });

    test('hesap güvenliği ekranları oturum gerektirir', () {
      expect(
        redirect(guest, '/profile/change-password'),
        '/login?from=%2Fprofile%2Fchange-password',
      );
      expect(redirect(citizen, '/profile/delete-account'), isNull);
    });

    test('yasal metinler herkese açıktır', () {
      expect(redirect(guest, '/legal/privacy-notice'), isNull);
      expect(redirect(citizen, '/legal/terms-of-use'), isNull);
    });
  });

  group('açık yönlendirme (open redirect) koruması', () {
    for (final malicious in [
      'https://evil.example/phish',
      '//evil.example/phish',
      'javascript:alert(1)',
      'profile',
      '/login',
      '/splash',
    ]) {
      test('"$malicious" hedefi reddedilir', () {
        final location = Uri(
          path: '/login',
          queryParameters: {'from': malicious},
        ).toString();
        expect(redirect(citizen, location), '/');
      });
    }
  });
}
