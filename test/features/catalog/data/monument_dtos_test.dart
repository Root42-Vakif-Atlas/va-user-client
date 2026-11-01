import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_dtos.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';

Map<String, dynamic> _summaryJson({
  String category = 'mosque',
  String period = 'ottoman',
}) => {
  'key': 'm1',
  'slug': 'm1',
  'title': 'Eser',
  'category': category,
  'period': period,
  'city': {'code': 34, 'name': 'İl'},
  'district': 'İlçe',
  'address': 'Adres',
  'location': {'latitude': 41.0, 'longitude': 29.0},
  'shortDescription': 'Özet',
};

void main() {
  group('MonumentSummaryDto', () {
    test('domain varlığına dönüşür', () {
      final monument = MonumentSummaryDto.fromJson(_summaryJson()).toDomain();

      expect(monument.category, MonumentCategory.mosque);
      expect(monument.period, HistoricalPeriod.ottoman);
      expect(monument.location, const GeoPoint(latitude: 41, longitude: 29));
      expect(monument.thumbnailUrl, isNull);
      expect(monument.id, 'm1');
      expect(monument.name, 'Eser');
      expect(monument.city, 'İl');
      expect(monument.cityCode, 34);
    });

    test('bilinmeyen tür ve dönem `other` olarak okunur', () {
      final monument = MonumentSummaryDto.fromJson(
        _summaryJson(category: 'aqueduct', period: 'byzantine'),
      ).toDomain();

      expect(monument.category, MonumentCategory.other);
      expect(monument.period, HistoricalPeriod.other);
    });

    test('eksik zorunlu alan CheckedFromJsonException fırlatır', () {
      // `location` isteğe bağlıdır (ADR 59: konumu girilmemiş eser).
      final json = _summaryJson()..remove('title');

      expect(
        () => MonumentSummaryDto.fromJson(json),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });
  });

  group('MonumentDetailDto', () {
    test('isteğe bağlı alanlar varsayılan değerlerle okunur', () {
      final detail = MonumentDetailDto.fromJson({
        ..._summaryJson(),
        'history': 'Tarihçe',
        'constructionDate': '1514',
        'founder': 'Bani',
      }).toDomain();

      expect(detail.architect, isNull);
      expect(detail.description, isEmpty);
      expect(detail.parts, isEmpty);
      expect(detail.isUnescoWorldHeritage, isFalse);
      expect(detail.images, isEmpty);
    });

    test('JSON gidiş-dönüşünde değer korunur (önbellek)', () {
      final original = MonumentDetailDto.fromJson({
        ..._summaryJson(),
        'parts': [
          {'title': 'Cami', 'description': 'Açıklama', 'images': <Object>[]},
        ],
        'complex': {'key': 'k', 'name': 'Külliye'},
        'history': 'Tarihçe',
        'constructionDate': '1514',
        'founder': 'Bani',
        'architect': 'Mimar',
        'isUnescoWorldHeritage': true,
        'images': [
          {
            'url': 'https://example.org/a.jpg',
            'thumbnailUrl': 'https://example.org/a_small.jpg',
            'altText': 'Betim',
            'author': 'Yazar',
            'license': 'CC BY-SA 4.0',
            'sourceName': 'Kaynak',
          },
        ],
      });

      expect(MonumentDetailDto.fromJson(original.toJson()), original);
    });
  });

  test('kaynak adresi künye için okunur biçime çevrilir', () {
    MonumentImageDto image(String sourceUrl) => MonumentImageDto(
      url: 'https://example.org/a.jpg',
      thumbnailUrl: 'https://example.org/a_small.jpg',
      altText: 'Betim',
      author: 'Yazar',
      license: 'CC BY-SA 4.0',
      sourceName: 'Kaynak',
      sourceUrl: sourceUrl,
    );

    expect(
      image(
        'https://commons.wikimedia.org/wiki/File:K%C4%B1zlara%C4%9Fas%C4%B1.jpg',
      ).toDomain().sourceUrl,
      'https://commons.wikimedia.org/wiki/File:Kızlarağası.jpg',
    );
    // Bozuk kaçış dizileri olduğu gibi bırakılır.
    expect(
      image('https://x.org/%E0%A4%A').toDomain().sourceUrl,
      'https://x.org/%E0%A4%A',
    );
    expect(
      image('https://x.org/%FF').toDomain().sourceUrl,
      'https://x.org/%FF',
    );
  });

  test('GeoPoint.isValid sonsuz ve aralık dışı değerleri reddeder', () {
    expect(const GeoPoint(latitude: 41, longitude: 29).isValid, isTrue);
    expect(
      const GeoPoint(latitude: double.nan, longitude: 29).isValid,
      isFalse,
    );
    expect(const GeoPoint(latitude: 91, longitude: 29).isValid, isFalse);
    expect(const GeoPoint(latitude: 41, longitude: -181).isValid, isFalse);
  });
}
