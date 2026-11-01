// Backend seed verisini mock fixture'lardan üretir (tek doğruluk kaynağı).
//
// Fixture'lar değiştiğinde çalıştırın:
//   flutter test tool/export_backend_seed_test.dart
//
// `test/` dışında olduğundan normal `flutter test` çalıştırmasına dahil
// değildir. Çıktılar (`../backend/seed/*.json`) sürüm kontrolüne eklenir.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/features/auth/domain/validation/common_passwords.dart';

import '../test/support/mock_api/auth/legal_mock_api.dart';
import '../test/support/mock_api/catalog/catalog_fixtures.dart';
import '../test/support/mock_api/catalog/catalog_mock_api.dart';
import '../test/support/mock_api/memory_corner/memory_fixtures.dart';
import '../test/support/mock_api/mock_api.dart';
import '../test/support/mock_api/route_planner/route_leg_fixtures.dart';

const String _seedDirectory = '../backend/seed';

Map<String, String> _text(MockText text) => {'tr': text.tr, 'en': text.en};

void _write(String name, Object data) {
  File('$_seedDirectory/$name')
    ..createSync(recursive: true)
    ..writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(data)}\n',
    );
}

Map<String, Object?> _legalDocument(String type, String language) {
  final route = LegalMockApi().routes.single;
  final response = route.handler(
    MockRequest(
      method: 'GET',
      path: 'legal/documents/$type',
      pathParameters: {'type': type},
      queryParameters: {'lang': language},
      headers: const {},
      body: null,
    ),
  ) as MockResponse;
  final body = response.body! as Map<String, Object?>;
  return {
    'type': type,
    'language': language,
    'version': body['version'],
    'title': body['title'],
    'body': body['body'],
    'effectiveDate': body['effectiveDate'],
  };
}

void main() {
  test('backend seed dosyalarını üretir', () {
    _write('catalog.json', {
      'version': CatalogMockApi.catalogVersion,
      'monuments': [
        for (final monument in CatalogFixtures.monuments)
          {
            'id': monument.id,
            'name': _text(monument.name),
            'category': monument.category.name,
            'period': monument.period.name,
            'city': monument.city,
            'district': monument.district,
            'address': monument.address,
            'latitude': monument.latitude,
            'longitude': monument.longitude,
            'shortDescription': _text(monument.shortDescription),
            'description': _text(monument.description),
            'history': _text(monument.history),
            'constructionDate': _text(monument.constructionDate),
            'founder': _text(monument.founder),
            'architect': monument.architect == null
                ? null
                : _text(monument.architect!),
            'isUnescoWorldHeritage': monument.isUnescoWorldHeritage,
            'complexId': monument.complexId,
            'complexOrder': monument.complexOrder,
            'images': [
              for (final image in monument.images)
                {
                  'url': image.url,
                  'thumbnailUrl': image.thumbnailUrl,
                  'altText': _text(image.altText),
                  'author': image.author,
                  'license': image.license,
                  'sourceName': MockImage.sourceName,
                  'sourceUrl': image.sourceUrl,
                },
            ],
          },
      ],
    });

    _write('route-legs.json', {
      'source': 'OSRM driving profile, 2026-10-18 / 2026-10-21 (© OpenStreetMap, ODbL)',
      'legs': [
        for (final MapEntry(:key, :value) in RouteLegFixtures.legs.entries)
          {
            'from': key.split('|').first,
            'to': key.split('|').last,
            'distanceMeters': value.distanceMeters,
            'durationSeconds': value.durationSeconds,
            'geometry': value.geometry,
          },
      ],
    });

    _write('memories.json', {'memories': MemoryFixtures.memories});

    _write('legal.json', {
      'documents': [
        for (final type in ['terms-of-use', 'privacy-notice'])
          for (final language in ['tr', 'en']) _legalDocument(type, language),
      ],
    });

    _write('common-passwords.json', {
      'exact': CommonPasswords.exact.toList()..sort(),
      'baseWords': CommonPasswords.baseWords.toList()..sort(),
    });
  });
}
