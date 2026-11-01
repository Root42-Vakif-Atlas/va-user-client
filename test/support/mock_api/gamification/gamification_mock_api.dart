import 'package:vakif_atlas/features/gamification/data/sources/gamification_remote_data_source.dart';

import '../auth/auth_mock_api.dart';
import '../catalog/catalog_fixtures.dart';
import '../mock_api.dart';
import 'mock_activity_ledger.dart';

/// Mock Gamification API: XP, seviye ve rozetler katkı defterinden
/// sunucuda hesaplanır; istemci XP talep edemez (ADR 41).
///
/// | Katkı | XP | Günlük XP sınırı |
/// |:--|:--|:--|
/// | Rota oluşturma | 50 | 3 |
/// | Anı paylaşma | 30 | 5 |
/// | Hasar bildirimi | 40 | 3 |
/// | Bir ilin eserine ilk katkı | 20 | — |
///
/// Sınırı aşan katkı rozet ilerlemesine sayılır ama XP vermez; silme XP'yi
/// geri almaz. Gün Türkiye saatine göredir.
class GamificationMockApi implements MockApi {
  GamificationMockApi(this._ledger, this._auth);

  final MockActivityLedger _ledger;
  final AuthMockApi _auth;

  static const Map<MockActivityKind, ({int xp, int dailyCap})> rules = {
    MockActivityKind.routeCreated: (xp: 50, dailyCap: 3),
    MockActivityKind.memoryShared: (xp: 30, dailyCap: 5),
    MockActivityKind.damageReported: (xp: 40, dailyCap: 3),
  };
  static const int newCityXp = 20;

  /// Seviye başlangıç XP'leri (1. seviye 0).
  static const List<int> levelThresholds = [0, 100, 250, 500, 900, 1400, 2000];

  static const Map<String, List<String>> _levelTitles = {
    'tr': [
      'Meraklı',
      'Gezgin',
      'Kâşif',
      'Miras Dostu',
      'Miras Bekçisi',
      'Vakıf Elçisi',
      'Atlas Ustası',
    ],
    'en': [
      'Curious',
      'Wanderer',
      'Explorer',
      'Heritage Friend',
      'Heritage Keeper',
      'Foundation Ambassador',
      'Atlas Master',
    ],
  };

  static const int _maxAcknowledgements = 50;

  @override
  List<MockRoute> get routes => [
    MockRoute('GET', GamificationEndpoints.me, _me),
    MockRoute('POST', GamificationEndpoints.acknowledgements, _acknowledge),
  ];

  Future<MockResponse> _me(MockRequest request) async {
    final account = await _auth.accountFor(request);
    if (account == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    final entry = await _ledger.entryFor(account.id);
    return MockResponse.ok(profileJson(entry, _language(request)));
  }

  Future<MockResponse> _acknowledge(MockRequest request) async {
    final account = await _auth.accountFor(request);
    if (account == null) {
      return MockResponse.error(401, 'unauthorized');
    }
    final ids = request.field('ids');
    if (ids is! List ||
        ids.isEmpty ||
        ids.length > _maxAcknowledgements ||
        ids.any((id) => id is! String || id.isEmpty || id.length > 64)) {
      return MockResponse.error(400, 'invalid_acknowledgement');
    }
    await _ledger.markSeen(account.id, ids.cast<String>());
    return const MockResponse.noContent();
  }

  /// Defterden profil yanıtı (testlerde de kullanılır).
  static Map<String, dynamic> profileJson(
    MockLedgerEntry entry,
    String language,
  ) {
    final activities = [...entry.activities]
      ..sort((a, b) => a.at.compareTo(b.at));
    var xp = 0;
    final perDay = <(MockActivityKind, String), int>{};
    final cities = <String>{};
    final counts = <MockActivityKind, int>{};
    final unlocked = <String, DateTime>{};

    for (final activity in activities) {
      final rule = rules[activity.kind]!;
      final dayKey = (activity.kind, _turkeyDay(activity.at));
      final today = perDay[dayKey] = (perDay[dayKey] ?? 0) + 1;
      if (today <= rule.dailyCap) {
        xp += rule.xp;
      }
      for (final id in activity.monumentIds) {
        final city = _cityOf(id);
        if (city != null && cities.add(city)) {
          xp += newCityXp;
        }
      }
      counts[activity.kind] = (counts[activity.kind] ?? 0) + 1;
      for (final achievement in _achievements) {
        final progress = achievement.progress(counts, cities.length);
        if (progress >= achievement.target) {
          unlocked.putIfAbsent(achievement.id, () => activity.at);
        }
      }
    }

    final level = levelThresholds.lastIndexWhere((start) => xp >= start) + 1;
    final titles = _levelTitles[language]!;
    final unseen = [
      for (final achievement in _achievements)
        if (unlocked.containsKey(achievement.id) &&
            !entry.seen.contains(achievement.id))
          achievement.id,
      for (var reached = 2; reached <= level; reached++)
        if (!entry.seen.contains('level:$reached')) 'level:$reached',
    ];
    return {
      'level': level,
      'levelTitle': titles[level - 1],
      'xp': xp,
      'levelStartXp': levelThresholds[level - 1],
      'nextLevelXp': level < levelThresholds.length
          ? levelThresholds[level]
          : null,
      'achievements': [
        for (final achievement in _achievements)
          {
            'id': achievement.id,
            'title': achievement.title[language],
            'description': achievement.description[language],
            'icon': achievement.icon,
            'progress': achievement
                .progress(counts, cities.length)
                .clamp(0, achievement.target),
            'target': achievement.target,
            'unlockedAt': unlocked[achievement.id]?.toUtc().toIso8601String(),
          },
      ],
      'unseen': unseen,
    };
  }

  static String _turkeyDay(DateTime at) {
    final local = at.toUtc().add(const Duration(hours: 3));
    return '${local.year}-${local.month}-${local.day}';
  }

  static String? _cityOf(String monumentId) => CatalogFixtures.monuments
      .where((monument) => monument.id == monumentId)
      .firstOrNull
      ?.city;

  static String _language(MockRequest request) =>
      (request.headers['accept-language'] ?? '').startsWith('en') ? 'en' : 'tr';
}

final class _MockAchievement {
  const _MockAchievement({
    required this.id,
    required this.icon,
    required this.target,
    required this.title,
    required this.description,
    this.kind,
  });

  final String id;
  final String icon;
  final int target;
  final Map<String, String> title;
  final Map<String, String> description;

  /// `null` → farklı il sayısı.
  final MockActivityKind? kind;

  int progress(Map<MockActivityKind, int> counts, int cityCount) =>
      kind == null ? cityCount : counts[kind] ?? 0;
}

const List<_MockAchievement> _achievements = [
  _MockAchievement(
    id: 'first_route',
    icon: 'route',
    kind: MockActivityKind.routeCreated,
    target: 1,
    title: {'tr': 'İlk Rota', 'en': 'First Route'},
    description: {
      'tr': 'İlk kültür rotanızı oluşturun.',
      'en': 'Create your first cultural route.',
    },
  ),
  _MockAchievement(
    id: 'route_master',
    icon: 'route_master',
    kind: MockActivityKind.routeCreated,
    target: 5,
    title: {'tr': 'Rota Ustası', 'en': 'Route Master'},
    description: {
      'tr': '5 kültür rotası oluşturun.',
      'en': 'Create 5 cultural routes.',
    },
  ),
  _MockAchievement(
    id: 'first_memory',
    icon: 'memory',
    kind: MockActivityKind.memoryShared,
    target: 1,
    title: {'tr': 'İlk Anı', 'en': 'First Memory'},
    description: {
      'tr': "Anı Köşesi'nde ilk anınızı paylaşın.",
      'en': 'Share your first memory in the Memory Corner.',
    },
  ),
  _MockAchievement(
    id: 'memory_book',
    icon: 'memory_book',
    kind: MockActivityKind.memoryShared,
    target: 10,
    title: {'tr': 'Anı Defteri', 'en': 'Memory Book'},
    description: {'tr': '10 anı paylaşın.', 'en': 'Share 10 memories.'},
  ),
  _MockAchievement(
    id: 'heritage_watcher',
    icon: 'report',
    kind: MockActivityKind.damageReported,
    target: 1,
    title: {'tr': 'Miras Gözcüsü', 'en': 'Heritage Watcher'},
    description: {
      'tr': 'Bir eserdeki hasarı ilk kez bildirin.',
      'en': 'Report damage to a monument for the first time.',
    },
  ),
  _MockAchievement(
    id: 'volunteer_guardian',
    icon: 'guardian',
    kind: MockActivityKind.damageReported,
    target: 5,
    title: {'tr': 'Gönüllü Koruyucu', 'en': 'Volunteer Guardian'},
    description: {
      'tr': '5 hasar bildirimi gönderin.',
      'en': 'Send 5 damage reports.',
    },
  ),
  _MockAchievement(
    id: 'city_explorer',
    icon: 'explorer',
    target: 3,
    title: {'tr': 'Şehir Kâşifi', 'en': 'City Explorer'},
    description: {
      'tr': '3 farklı ildeki eserlere katkıda bulunun.',
      'en': 'Contribute to monuments in 3 different provinces.',
    },
  ),
  _MockAchievement(
    id: 'anatolia_traveler',
    icon: 'traveler',
    target: 7,
    title: {'tr': 'Anadolu Gezgini', 'en': 'Anatolian Traveller'},
    description: {
      'tr': '7 farklı ildeki eserlere katkıda bulunun.',
      'en': 'Contribute to monuments in 7 different provinces.',
    },
  ),
];
