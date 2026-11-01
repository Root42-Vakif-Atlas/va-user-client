import 'dart:convert';

import 'package:vakif_atlas/core/map/map_tiles.dart';
import 'package:vakif_atlas/core/utils/turkish_text.dart';
import 'package:vakif_atlas/features/catalog/data/sources/catalog_remote_data_source.dart';

import '../mock_api.dart';
import 'catalog_fixtures.dart';
import 'mock_complex_geometry.dart';
import 'mock_map_tiles.dart';
import 'mock_monument_search.dart';

/// Catalog mikro servisinin mock implementasyonu (`catalog/works`,
/// `catalog/complexes`, `catalog/map/**`; sunucu sözleşmesiyle aynı biçim).
///
/// - İçerik `Accept-Language` başlığına göre `tr` veya `en` döner;
///   desteklenmeyen dillerde `tr` kullanılır.
/// - Liste, gerçek sunucuda olduğu gibi dile duyarlı alfabetik sıradadır.
/// - Eser kimliği `key`, adı `title`, il `{code, name}`'dir; uzun metin
///   bölümlerdedir (`parts`). Bilinmeyen anahtar `404 {"code": "not_found"}`.
/// - Külliyeler eser değildir: `works` listesinde ve detayında yoktur,
///   `complexes/**` altındadır (detay + yapı alt koleksiyonu `…/works`).
///   Yapılar `complex: {key, name}` taşır. Karolarda yapılar uzakta
///   külliyede toplanır (bkz. [MockMapTiles]).
/// - Liste tek koleksiyondur: arama, filtre, temsil (`view`) ve ek bloklar
///   (`include`) sorgu parametresidir; imleçle sayfalanır (mock'ta ofset,
///   istemci için opak). `keys` yalnızca verilen anahtarları döndürür
///   (bilinmeyenler atlanır). Geçersiz `limit`, `view`, `cursor` veya 50'den
///   fazla `keys` → `400 {"code": "invalid_request"}`.
///
/// İç kayıtlar fikstür biçimindedir (`id`, `name`, `city` adı + `cityCode`);
/// yanıtlar `_wire*` ile sözleşme biçimine çevrilir.
class CatalogMockApi implements MockApi, MockMapIndex {
  CatalogMockApi() : this.withMonuments(CatalogFixtures.monuments);

  /// Testlerde farklı veri setiyle çalışmak için.
  CatalogMockApi.withMonuments(this._monuments)
    : _byId = {for (final monument in _monuments) monument.id: monument};

  static const Set<String> _supportedLanguages = {'tr', 'en'};
  static const String _defaultLanguage = 'tr';

  final List<MockMonument> _monuments;
  final Map<String, MockMonument> _byId;

  /// Karo öğeleri isteğin dilinde üretilir.
  String _tileLanguage = _defaultLanguage;

  static const String _cursorPrefix = 'o:';

  /// Temsil başına (varsayılan, en çok) sayfa boyutu.
  static const Map<String, (int, int)> _limits = {
    CatalogQueryParameters.viewSummary: (20, 50),
    CatalogQueryParameters.viewLocation: (1000, 2000),
  };

  /// Katalog sürümü: veri değişince artar; karo URL'leri (`v`) bununla
  /// önbelleklenir.
  static const String catalogVersion = '2026-10-21.1';

  @override
  List<MockRoute> get routes => [
    MockRoute('GET', CatalogEndpoints.monuments, _list),
    MockRoute('GET', '${CatalogEndpoints.monuments}/:id', _detail),
    MockRoute('GET', '${CatalogEndpoints.mapTiles}/:z/:x/:y', _tile),
    MockRoute('GET', CatalogEndpoints.mapExtent, _extent),
    MockRoute('GET', CatalogEndpoints.complexes, _complexes),
    MockRoute('GET', '${CatalogEndpoints.complexes}/:id', _complexDetail),
    MockRoute(
      'GET',
      '${CatalogEndpoints.complexes}/:id/works',
      _complexMembers,
    ),
  ];

  /// Külliye detayına gömülen ilk üye sayfası.
  static const int embeddedMembers = 20;

  // ---------------------------------------------------------------------
  // Külliye
  // ---------------------------------------------------------------------

  MockMonument? _complex(MockRequest request) {
    final monument = _byId[request.pathParameters['id']];
    return monument != null && monument.isComplex ? monument : null;
  }

  /// Üyeler külliyedeki sırasıyla (`complexOrder`, ad, kimlik).
  List<MockMonument> _membersOf(String complexId, String language) =>
      [
        for (final monument in _monuments)
          if (monument.complexId == complexId) monument,
      ]..sort((a, b) {
        final byOrder = (a.complexOrder ?? 1 << 30).compareTo(
          b.complexOrder ?? 1 << 30,
        );
        if (byOrder != 0) {
          return byOrder;
        }
        final byName = TurkishText.compare(
          a.name.resolve(language),
          b.name.resolve(language),
        );
        return byName != 0 ? byName : a.id.compareTo(b.id);
      });

  /// Külliye ve üyelerinin noktaları.
  List<(double, double)> _complexPoints(MockMonument complex) => [
    (complex.latitude, complex.longitude),
    for (final member in _membersOf(complex.id, _defaultLanguage))
      (member.latitude, member.longitude),
  ];

  MockResponse _complexes(MockRequest request) {
    final query = request.queryParameters;
    final offset = _decodeCursor(query[CatalogQueryParameters.cursor]);
    final limit = int.tryParse(query[CatalogQueryParameters.limit] ?? '') ?? 20;
    if (offset == null || limit < 1 || limit > 50) {
      return MockResponse.error(400, 'invalid_request');
    }
    final language = _language(request);
    final items = [
      for (final item in _summaries(language))
        if (item['memberCount'] != null) _wireComplexSummary(item),
    ];
    return MockResponse.ok(_page(items, offset, limit));
  }

  MockResponse _complexDetail(MockRequest request) {
    final complex = _complex(request);
    if (complex == null) {
      return MockResponse.error(404, 'not_found');
    }
    return MockResponse.ok(complexDetailJson(complex, _language(request)));
  }

  /// `GET catalog/complexes/{key}` gövdesi (`ComplexDetail`).
  Map<String, Object?> complexDetailJson(
    MockMonument complex,
    String language,
  ) {
    final members = [
      for (final member in _membersOf(complex.id, language))
        summaryJson(member, language),
    ];
    final summary = summaryJson(complex, language);
    final detail = detailJson(complex, language);
    return {
      ..._wireComplexSummary(summary)..remove('thumbnailUrl'),
      'images': detail['images'],
      'footprint': MockComplexGeometry.footprint(_complexPoints(complex)),
      'bounds': MockMonumentSearch.boundsOf([summary, ...members]),
      'works': _page(
        [for (final member in members) _wireSummary(member)],
        0,
        embeddedMembers,
      ),
    };
  }

  MockResponse _complexMembers(MockRequest request) {
    final complex = _complex(request);
    if (complex == null) {
      return MockResponse.error(404, 'not_found');
    }
    final query = request.queryParameters;
    final view =
        query[CatalogQueryParameters.view] ??
        CatalogQueryParameters.viewSummary;
    final limits = _limits[view];
    final offset = _decodeCursor(query[CatalogQueryParameters.cursor]);
    final limit =
        int.tryParse(query[CatalogQueryParameters.limit] ?? '') ??
        limits?.$1 ??
        0;
    if (limits == null || limit < 1 || limit > limits.$2 || offset == null) {
      return MockResponse.error(400, 'invalid_request');
    }
    final language = _language(request);
    final criteria = MockSearchCriteria.fromQuery(query);
    final members = [
      for (final member in _membersOf(complex.id, language))
        if (criteria.matchesFilters(summaryJson(member, language)))
          _wireSummary(summaryJson(member, language)),
    ];
    return MockResponse.ok(_page(members, offset, limit));
  }

  Map<String, Object?> _page(
    List<Map<String, Object?>> items,
    int offset,
    int limit,
  ) {
    final end = (offset + limit).clamp(0, items.length);
    return {
      'items': offset >= items.length
          ? const <Map<String, Object?>>[]
          : items.sublist(offset, end),
      'total': items.length,
      'nextCursor': end < items.length ? _encodeCursor(end) : null,
    };
  }

  /// Üyede `complex` referansı, külliyede `memberCount` (sunucu yanıtıyla aynı).
  Map<String, Object?> _membership(MockMonument monument, String language) {
    final complexId = monument.complexId;
    final complex = complexId == null ? null : _byId[complexId];
    return {
      if (complex != null)
        'complex': {'id': complex.id, 'name': complex.name.resolve(language)},
      if (monument.isComplex)
        'memberCount': _monuments
            .where((m) => m.complexId == monument.id)
            .length,
    };
  }

  Map<String, Object?> summaryJson(MockMonument monument, String language) => {
    ...monument.toSummaryJson(language),
    ..._membership(monument, language),
  };

  Map<String, Object?> detailJson(MockMonument monument, String language) => {
    ...monument.toDetailJson(language),
    ..._membership(monument, language),
  };

  /// [summaryJson]'ın yanıt biçimi (`WorkSummary`).
  Map<String, Object?> wireSummaryJson(
    MockMonument monument,
    String language,
  ) => _wireSummary(summaryJson(monument, language));

  /// [detailJson]'ın yanıt biçimi (`WorkDetail`).
  Map<String, Object?> wireDetailJson(MockMonument monument, String language) =>
      _wireDetail(detailJson(monument, language));

  // ---------------------------------------------------------------------
  // Harita dizini (MockMapIndex)
  // ---------------------------------------------------------------------

  @override
  String mapKeyOf(Map<String, Object?> summary) {
    final complex = summary['complex'];
    return complex is Map ? complex['id']! as String : summary['id']! as String;
  }

  @override
  bool isComplex(String id) => _byId[id]?.isComplex ?? false;

  @override
  (double, double) locationOf(String id) {
    final monument = _byId[id]!;
    return (monument.latitude, monument.longitude);
  }

  @override
  Map<String, Object?> itemOf(String id, {bool withFootprint = false}) {
    final monument = _byId[id]!;
    final summary = summaryJson(monument, _tileLanguage);
    if (monument.isComplex) {
      return {
        'type': 'complex',
        'key': monument.id,
        'name': summary['name'],
        'city': _wireCity(summary),
        'district': monument.district,
        'lat': monument.latitude,
        'lng': monument.longitude,
        'workCount': summary['memberCount'],
        if (withFootprint)
          'footprint': MockComplexGeometry.footprint(_complexPoints(monument)),
      };
    }
    return {
      'type': 'work',
      'key': monument.id,
      'slug': monument.id,
      'title': summary['name'],
      'category': monument.category.name,
      'city': _wireCity(summary),
      'district': monument.district,
      'lat': monument.latitude,
      'lng': monument.longitude,
      'complex': ?_wireComplexRef(summary),
    };
  }

  MockResponse _tile(MockRequest request) {
    final z = int.tryParse(request.pathParameters['z'] ?? '');
    final x = int.tryParse(request.pathParameters['x'] ?? '');
    final y = int.tryParse(request.pathParameters['y'] ?? '');
    if (z == null ||
        x == null ||
        y == null ||
        z < MapTiles.minZoom ||
        z > MapTiles.maxZoom ||
        x < 0 ||
        y < 0 ||
        x >= 1 << z ||
        y >= 1 << z) {
      return MockResponse.error(400, 'invalid_request');
    }
    _tileLanguage = _language(request);
    final matches = MockMonumentSearch.search(
      _summaries(_tileLanguage),
      MockSearchCriteria.fromQuery(request.queryParameters),
    );
    return MockResponse.ok({
      'items': MockMapTiles.tile(matches, TileId(z, x, y), index: this),
    });
  }

  MockResponse _extent(MockRequest request) {
    final matches = MockMonumentSearch.search(
      _summaries(_language(request)),
      MockSearchCriteria.fromQuery(request.queryParameters),
    );
    return MockResponse.ok(MockMapTiles.extent(matches, catalogVersion));
  }

  /// Dile duyarlı alfabetik sıradaki özet JSON'ları.
  List<Map<String, Object?>> _summaries(String language) {
    final monuments = [..._monuments]
      ..sort(
        (a, b) => TurkishText.compare(
          a.name.resolve(language),
          b.name.resolve(language),
        ),
      );
    return [for (final monument in monuments) summaryJson(monument, language)];
  }

  MockResponse _list(MockRequest request) {
    final query = request.queryParameters;
    final view =
        query[CatalogQueryParameters.view] ??
        CatalogQueryParameters.viewSummary;
    final limits = _limits[view];
    final offset = _decodeCursor(query[CatalogQueryParameters.cursor]);
    final limit =
        int.tryParse(query[CatalogQueryParameters.limit] ?? '') ??
        limits?.$1 ??
        0;
    final idCount = (query[CatalogQueryParameters.keys] ?? '')
        .split(',')
        .where((id) => id.trim().isNotEmpty)
        .length;
    if (limits == null ||
        limit < 1 ||
        limit > limits.$2 ||
        offset == null ||
        idCount > CatalogQueryParameters.maxIds) {
      return MockResponse.error(400, 'invalid_request');
    }
    final include = {
      for (final value in (query[CatalogQueryParameters.include] ?? '').split(
        ',',
      ))
        value.trim(),
    };
    final criteria = MockSearchCriteria.fromQuery(query);
    final items = [
      for (final item in _summaries(_language(request)))
        if (item['memberCount'] == null) item,
    ];
    final matches = MockMonumentSearch.search(items, criteria);
    final end = (offset + limit).clamp(0, matches.length);
    final page = offset >= matches.length
        ? const <Map<String, Object?>>[]
        : matches.sublist(offset, end);
    final firstPage = offset == 0;
    return MockResponse.ok({
      'items': view == CatalogQueryParameters.viewLocation
          ? [for (final item in page) _location(item)]
          : [for (final item in page) _wireSummary(item)],
      'total': matches.length,
      'nextCursor': end < matches.length ? _encodeCursor(end) : null,
      if (firstPage && include.contains('places'))
        'places': MockMonumentSearch.places(items, criteria),
      if (firstPage && include.contains('facets'))
        'facets': MockMonumentSearch.facets(items, criteria),
    });
  }

  // ---------------------------------------------------------------------
  // Sözleşme biçimi (iç kayıt → yanıt)
  // ---------------------------------------------------------------------

  static Map<String, Object?> _wireCity(Map<String, Object?> item) => {
    'code': item['cityCode'],
    'name': item['city'],
  };

  static Map<String, Object?>? _wireComplexRef(Map<String, Object?> item) =>
      switch (item['complex']) {
        final Map<String, Object?> complex => {
          'key': complex['id'],
          'name': complex['name'],
        },
        _ => null,
      };

  /// `WorkSummary`.
  static Map<String, Object?> _wireSummary(Map<String, Object?> item) => {
    'key': item['id'],
    'slug': item['id'],
    'title': item['name'],
    'category': item['category'],
    'period': item['period'],
    'city': _wireCity(item),
    'district': item['district'],
    'address': item['address'],
    'location': item['location'],
    'shortDescription': item['shortDescription'],
    'thumbnailUrl': item['thumbnailUrl'],
    'complex': ?_wireComplexRef(item),
  };

  /// `ComplexSummary`.
  static Map<String, Object?> _wireComplexSummary(Map<String, Object?> item) =>
      {
        'key': item['id'],
        'name': item['name'],
        'city': _wireCity(item),
        'district': item['district'],
        'address': item['address'],
        'location': item['location'],
        'thumbnailUrl': item['thumbnailUrl'],
        'workCount': item['memberCount'],
      };

  /// `WorkDetail`: fikstürün açıklaması tek bölüm olarak (`parts`) döner.
  static Map<String, Object?> _wireDetail(Map<String, Object?> item) {
    final description = item['description'] as String? ?? '';
    return {
      ..._wireSummary(item)..remove('thumbnailUrl'),
      'slugs': {'tr': item['id'], 'en': item['id']},
      'history': item['history'],
      'constructionDate': item['constructionDate'],
      'founder': item['founder'],
      'architect': item['architect'],
      'isUnescoWorldHeritage': item['isUnescoWorldHeritage'],
      'images': item['images'],
      'parts': [
        if (description.isNotEmpty)
          {'description': description, 'images': const <Object>[]},
      ],
    };
  }

  /// `WorkLocation` (`view=location`).
  static Map<String, Object?> _location(Map<String, Object?> item) => {
    'key': item['id'],
    'slug': item['id'],
    'title': item['name'],
    'category': item['category'],
    'city': _wireCity(item),
    'district': item['district'],
    'location': item['location'],
    'complex': ?_wireComplexRef(item),
  };

  static String _encodeCursor(int offset) =>
      base64Url.encode(utf8.encode('$_cursorPrefix$offset'));

  /// `null` imleç → 0; çözülemeyen imleç → `null`.
  static int? _decodeCursor(String? cursor) {
    if (cursor == null || cursor.isEmpty) {
      return 0;
    }
    try {
      final raw = utf8.decode(base64Url.decode(cursor));
      if (!raw.startsWith(_cursorPrefix)) {
        return null;
      }
      final offset = int.tryParse(raw.substring(_cursorPrefix.length));
      return offset == null || offset < 0 ? null : offset;
    } on FormatException {
      return null;
    }
  }

  MockResponse _detail(MockRequest request) {
    final monument = _byId[request.pathParameters['id']];
    if (monument == null || monument.isComplex) {
      return MockResponse.error(404, 'not_found');
    }
    return MockResponse.ok(
      _wireDetail(detailJson(monument, _language(request))),
    );
  }

  /// `Accept-Language: en-US,en;q=0.9` → `en`.
  static String _language(MockRequest request) {
    final header = request.headers['accept-language'] ?? '';
    final primary = header
        .split(',')
        .first
        .split(';')
        .first
        .split('-')
        .first
        .trim()
        .toLowerCase();
    return _supportedLanguages.contains(primary) ? primary : _defaultLanguage;
  }
}
