import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/features/gamification/presentation/cubit/gamification_cubit.dart';

import '../../../helpers/gamification_test_utils.dart';

Future<void> _until(bool Function() condition) async {
  for (var i = 0; i < 100 && !condition(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  expect(condition(), isTrue);
}

void main() {
  test('oturum yokken istek yapılmaz', () async {
    final env = GamificationTestEnvironment();
    final cubit = env.cubit();

    await cubit.refresh();

    expect(cubit.state.status, GamificationStatus.inactive);
    await cubit.close();
  });

  test('başlatınca profil yüklenir; katkı sonrası yenilenir ve kazanımlar '
      'bekler', () async {
    final env = GamificationTestEnvironment();
    await env.signIn();
    final cubit = env.cubit();

    await cubit.start(languageCode: 'tr');
    expect(cubit.state.status, GamificationStatus.ready);
    expect(cubit.state.profile!.xp, 0);
    expect(cubit.state.pendingUnlocks, isEmpty);

    await env.createRoute(['suleymaniye-camii', 'selimiye-camii']);
    env.events.notifyContribution();
    await _until(() => cubit.state.profile!.xp == 90);
    expect(
      cubit.state.pendingUnlocks.map((unlock) => unlock.id),
      contains('first_route'),
    );

    await cubit.acknowledge(cubit.state.pendingUnlocks);
    expect(cubit.state.pendingUnlocks, isEmpty);
    await cubit.refresh();
    expect(cubit.state.pendingUnlocks, isEmpty);
    await cubit.close();
  });

  test('dil değişince adlar yeni dilde gelir; durdurunca temizlenir', () async {
    final env = GamificationTestEnvironment();
    await env.signIn();
    final cubit = env.cubit();
    await cubit.start(languageCode: 'tr');
    expect(cubit.state.profile!.levelTitle, 'Meraklı');

    await cubit.setLanguage('en');
    expect(cubit.state.profile!.levelTitle, 'Curious');

    cubit.stop();
    expect(cubit.state.status, GamificationStatus.inactive);
    expect(cubit.state.profile, isNull);
    // Katkı olayı oturum yokken istek tetiklemez.
    env.events.notifyContribution();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(cubit.state.status, GamificationStatus.inactive);
    await cubit.close();
  });

  test('yükleme hatası durumu; son profil korunur', () async {
    final env = GamificationTestEnvironment();
    final cubit = env.cubit();

    // Oturum anahtarı yok → 401.
    await cubit.start(languageCode: 'tr');
    expect(cubit.state.status, GamificationStatus.failure);
    expect(cubit.state.failure, isNotNull);

    await env.signIn();
    await cubit.refresh();
    expect(cubit.state.status, GamificationStatus.ready);
    env.signOut();
    await cubit.refresh();
    expect(cubit.state.status, GamificationStatus.failure);
    expect(cubit.state.profile, isNotNull);
    await cubit.close();
  });
}
