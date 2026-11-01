import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/gamification/data/dtos/gamification_dtos.dart';
import 'package:vakif_atlas/features/gamification/domain/entities/gamification_profile.dart';

import '../../../helpers/gamification_test_utils.dart';
import '../../../support/mock_api/gamification/gamification_mock_api.dart';
import '../../../support/mock_api/gamification/mock_activity_ledger.dart';

MockActivity _activity(
  MockActivityKind kind,
  List<String> monuments,
  DateTime at,
) => MockActivity(
  kind: kind,
  refId: '${kind.name}_${at.microsecondsSinceEpoch}',
  monumentIds: monuments,
  at: at,
);

Map<String, dynamic> _profile(
  List<MockActivity> activities, {
  Set<String>? seen,
}) => GamificationMockApi.profileJson(
  MockLedgerEntry(activities: activities, seen: seen ?? const {}),
  'tr',
);

void main() {
  group('Mock sunucu kuralları', () {
    test('katkı yokken 1. seviye, rozetler kilitli', () {
      final json = _profile(const []);
      expect(json['level'], 1);
      expect(json['levelTitle'], 'Meraklı');
      expect(json['xp'], 0);
      expect(json['nextLevelXp'], 100);
      expect(json['unseen'], isEmpty);
      final achievements = json['achievements'] as List;
      expect(achievements, hasLength(8));
      expect(
        achievements.every((a) => (a as Map)['unlockedAt'] == null),
        isTrue,
      );
    });

    test('rota XP + yeni il XP; ilk rota rozeti ve seviye atlama', () {
      final at = DateTime.utc(2026, 10, 19, 9);
      final json = _profile([
        // İstanbul + Edirne: 50 + 2×20
        _activity(MockActivityKind.routeCreated, [
          'suleymaniye-camii',
          'selimiye-camii',
        ], at),
        // Bursa: 30 + 20
        _activity(MockActivityKind.memoryShared, [
          'bursa-ulu-camii',
        ], at.add(const Duration(minutes: 5))),
      ]);
      expect(json['xp'], 140);
      expect(json['level'], 2);
      expect(json['levelTitle'], 'Gezgin');
      expect(json['levelStartXp'], 100);
      expect(json['nextLevelXp'], 250);
      expect(json['unseen'], [
        'first_route',
        'first_memory',
        'city_explorer',
        'level:2',
      ]);
    });

    test('günlük sınırı aşan katkı XP vermez ama rozet ilerletir; ertesi gün '
        'yeniden kazanılır', () {
      final day = DateTime.utc(2026, 10, 19, 9);
      final json = _profile([
        for (var i = 0; i < 4; i++)
          _activity(MockActivityKind.routeCreated, [
            'suleymaniye-camii',
          ], day.add(Duration(minutes: i))),
        // Türkiye saatiyle ertesi gün (21:30 UTC = 00:30 TSİ).
        _activity(MockActivityKind.routeCreated, [
          'suleymaniye-camii',
        ], DateTime.utc(2026, 10, 19, 21, 30)),
      ]);
      // 3×50 + İstanbul 20 + ertesi gün 50
      expect(json['xp'], 220);
      final routeMaster = (json['achievements'] as List)
          .cast<Map<String, dynamic>>()
          .firstWhere((a) => a['id'] == 'route_master');
      expect(routeMaster['progress'], 5);
      expect(routeMaster['unlockedAt'], isNotNull);
    });

    test('görülen kazanımlar yeniden bildirilmez', () {
      final json = _profile(
        [
          _activity(MockActivityKind.damageReported, [
            'kizlaragasi-hani',
          ], DateTime.utc(2026, 10, 19)),
        ],
        seen: {'heritage_watcher'},
      );
      expect(json['unseen'], isEmpty);
    });
  });

  group('API uçtan uca', () {
    test(
      'misafir 401 alır; oturum açıkken oluşturulan rota XP kazandırır',
      () async {
        final env = GamificationTestEnvironment();

        final guest = await env.getProfile('tr');
        expect(guest.isLeft, isTrue);
        // Misafir rotası deftere yazılmaz.
        await env.createRoute(['suleymaniye-camii', 'selimiye-camii']);

        await env.signIn();
        expect((await env.getProfile('tr')).getOrNull()!.xp, 0);

        await env.createRoute(['suleymaniye-camii', 'selimiye-camii']);
        final profile = (await env.getProfile('tr')).getOrNull()!;
        expect(profile.xp, 90);
        expect(
          profile.unseen.map((unlock) => unlock.id),
          contains('first_route'),
        );

        await env.acknowledge(['first_route']);
        final after = (await env.getProfile('en')).getOrNull()!;
        expect(after.unseen, isEmpty);
        expect(
          after.achievements.firstWhere((a) => a.id == 'first_route').title,
          'First Route',
        );
      },
    );

    test('geçersiz görüldü bildirimi 400 → ServerFailure', () async {
      final env = GamificationTestEnvironment();
      await env.signIn();
      final result = await env.repository.acknowledge(['']);
      expect(result.isLeft, isTrue);
      expect(result.fold((f) => f, (_) => null), isA<ServerFailure>());
    });
  });

  group('DTO', () {
    test(
      'bilinmeyen simge genel rozete düşer; geçersiz sayılar düzeltilir',
      () {
        final achievement = const AchievementDto(
          id: 'x',
          title: ' Yeni ',
          description: 'açıklama',
          icon: 'https://kotu.example/ikon.png',
          progress: 9,
          target: 0,
        ).toDomain();
        expect(achievement.icon, AchievementIcon.generic);
        expect(achievement.title, 'Yeni');
        expect(achievement.target, 1);
        expect(achievement.progress, 1);
      },
    );

    test('görülmemiş kimlikler ayrıştırılır; kilitli rozet ve geçersiz '
        'seviye atlanır', () {
      final profile = GamificationProfileDto.fromJson({
        'level': 3,
        'levelTitle': 'Kâşif',
        'xp': 300,
        'levelStartXp': 250,
        'nextLevelXp': 500,
        'achievements': [
          {
            'id': 'first_route',
            'title': 'İlk Rota',
            'description': 'd',
            'icon': 'route',
            'progress': 1,
            'target': 1,
            'unlockedAt': '2026-10-19T09:00:00Z',
          },
          {
            'id': 'route_master',
            'title': 'Rota Ustası',
            'description': 'd',
            'icon': 'route_master',
            'progress': 1,
            'target': 5,
          },
        ],
        'unseen': [
          'first_route',
          'route_master',
          'level:2',
          'level:3',
          'level:9',
          'bilinmeyen',
        ],
      }).toDomain();
      expect(profile.unseen.map((u) => u.id), [
        'first_route',
        'level:2',
        'level:3',
      ]);
      expect(profile.levelProgress, closeTo(0.2, 0.001));
      expect(profile.xpToNextLevel, 200);
      expect(profile.toString(), 'GamificationProfile(level: 3, xp: 300)');
    });
  });
}
