import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_dtos.dart';
import 'package:vakif_atlas/features/catalog/data/dtos/monument_search_dtos.dart';

/// VGM verisinden içe aktarılan eser (ADR 59): konum `null`, bölümler, takma
/// ad; gövdeler `GET catalog/works/{key}` ve `?view=location` yanıtlarıyla
/// aynı biçimdedir (boş metin alanları `null`, `sourceUrl` yazılmaz).
void main() {
  Map<String, Object?> image(String name) => {
    'url': 'https://media/$name.jpg',
    'thumbnailUrl': 'https://media/$name-thumb.jpg',
    'altText': 'Kantara Camii - Görsel 1',
    'author': 'Vakıflar Genel Müdürlüğü',
    'license': 'VGM',
    'sourceName': 'Vakıflar Genel Müdürlüğü',
  };

  test('detay: konumsuz eser bölümleri ve takma adıyla okunur', () {
    final detail = MonumentDetailDto.fromJson({
      'key': 'kantara-camii',
      'slug': 'kantara-camii',
      'slugs': {'tr': 'kantara-camii', 'en': 'kantara-mosque'},
      'title': 'Kantara Camii',
      'nickname': 'Köprübaşı',
      'category': 'mosque',
      'period': 'other',
      'city': {'code': 31, 'name': 'Hatay'},
      'district': 'Antakya',
      'address': 'Hatay - Antakya',
      'location': null,
      'shortDescriptionTitle': null,
      'shortDescription': null,
      'history': null,
      'constructionDate': null,
      'founder': null,
      'architect': null,
      'isUnescoWorldHeritage': false,
      'images': [image('1')],
      'parts': [
        {
          'title': 'Cami',
          'description': 'Metin.',
          'images': [image('bolum-1-1')],
        },
        {'description': 'Başlıksız bölüm.', 'images': <Object>[]},
      ],
    }).toDomain();

    expect(detail.id, 'kantara-camii');
    expect(detail.name, 'Kantara Camii');
    expect(detail.city, 'Hatay');
    expect(detail.location, isNull);
    expect(detail.nickname, 'Köprübaşı');
    expect(detail.shortDescription, isEmpty);
    expect(detail.founder, isEmpty);
    expect(detail.description, 'Metin.\n\nBaşlıksız bölüm.');
    expect(detail.parts, hasLength(2));
    expect(detail.parts.first.title, 'Cami');
    expect(
      detail.parts.first.images.single.thumbnailUrl,
      endsWith('-thumb.jpg'),
    );
    expect(detail.parts.last.title, isNull);
    expect(detail.images, hasLength(1));
    expect(detail.images.single.sourceUrl, isNull);
  });

  test('view=location: konumsuz kayıt atılmaz, haritaya konmaz', () {
    final pin = MonumentPinDto.fromJson({
      'key': 'kantara-camii',
      'slug': 'kantara-camii',
      'title': 'Kantara Camii',
      'category': 'mosque',
      'city': {'code': 31, 'name': 'Hatay'},
      'district': 'Antakya',
      'location': null,
    }).toDomain();

    expect(pin.id, 'kantara-camii');
    expect(pin.city, 'Hatay');
    expect(pin.location, isNull);
    expect(pin.hasLocation, isFalse);
  });
}
