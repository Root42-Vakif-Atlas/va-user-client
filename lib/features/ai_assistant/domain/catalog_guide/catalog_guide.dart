import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/turkish_text.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/catalog_guide/guide_question.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/catalog_guide/turkish_provinces.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_filter.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';
import 'package:vakif_atlas/features/catalog/domain/repositories/catalog_repository.dart';

/// Katalogdan kurulan yanıt; [focus] sonraki takip soruları ("Mimarı
/// kim?") için konuşulan eserdir.
final class CatalogGuideAnswer {
  const CatalogGuideAnswer(this.message, {this.focus});

  final GuideMessage message;
  final GuideMonumentRef? focus;
}

/// Eser sorularını doğrudan Catalog API'sinden yanıtlar.
///
/// - Yanıt yalnızca katalog kayıtlarından kurulur; kayıtta olmayan bilgi
///   üretilmez. Bani, mimar veya tarih alanı boşsa kayıttaki açıklamadan
///   ilgili cümle alıntılanır, o da yoksa bilginin kayıtlı olmadığı
///   söylenir.
/// - Katalogda olmayan eser veya il sorulduğunda bu açıkça söylenir ve
///   katalogdaki iller, eser sayılarıyla birlikte bildirilir.
/// - Uygulama işlevlerine dair sorular (rota, hasar, ayarlar…) ve katalogla
///   ilgisi olmayan sorular için `null` döner; bunlar Asistan servisine
///   gider.
class CatalogGuide {
  CatalogGuide(this._catalog) : _clock = DateTime.now;

  CatalogGuide.withClock(this._catalog, this._clock);

  final CatalogRepository _catalog;
  final DateTime Function() _clock;

  /// Ad aramasında incelenen aday sayısı.
  static const int searchLimit = 20;

  /// Listede adıyla sayılan en çok eser.
  static const int maxListed = 5;

  static const int maxSuggestions = 4;

  /// Katalog özeti (il ve tür sayıları) bu süre boyunca yeniden istenmez.
  static const Duration overviewTtl = Duration(minutes: 10);

  final Map<String, (MonumentFacets, int, DateTime)> _overviews = {};
  var _messageCount = 0;

  /// [question] katalogla yanıtlanabiliyorsa yanıtı; değilse `null`.
  /// [focus] aynı sohbette son konuşulan eserdir.
  Future<Result<CatalogGuideAnswer>?> answer(
    String question, {
    required String languageCode,
    GuideMonumentRef? focus,
  }) async {
    final q = GuideQuestion.parse(question);
    final copy = _Copy(languageCode);
    try {
      final intent = q.serverIntent;
      if (intent != null) {
        return switch (intent) {
          GuideServerIntent.damage || GuideServerIntent.memories
              when q.hasName =>
            await _monumentAction(q, intent, copy),
          GuideServerIntent.map when focus != null && !q.hasName =>
            Right<Failure, CatalogGuideAnswer>(
              await _aboutMonument(focus.id, GuideFacet.location, copy),
            ),
          _ => null,
        };
      }
      if (q.hasName) {
        return await _byName(q, copy);
      }
      if (focus != null && q.facet != null && !q.hasFilter && !q.isListing) {
        return Right<Failure, CatalogGuideAnswer>(
          await _aboutMonument(focus.id, q.facet!, copy),
        );
      }
      if (q.hasFilter || q.isListing) {
        return Right<Failure, CatalogGuideAnswer>(await _list(q, copy));
      }
      if (q.facet != null && !q.isSmallTalk) {
        return Right<Failure, CatalogGuideAnswer>(
          CatalogGuideAnswer(_message(copy.whichMonument, copy: copy)),
        );
      }
      return null;
    } on _CatalogError catch (error) {
      return Left<Failure, CatalogGuideAnswer>(error.failure);
    }
  }

  // --- Ad ile soru ---------------------------------------------------------

  Future<Result<CatalogGuideAnswer>?> _byName(
    GuideQuestion q,
    _Copy copy,
  ) async {
    final overview = await _overview(copy.language);
    final missingCities = _missingCities(q, overview.$1);
    if (missingCities.isNotEmpty) {
      return Right<Failure, CatalogGuideAnswer>(
        _notInCatalog(q, overview, copy, cities: missingCities),
      );
    }
    final match = await _resolve(q, copy);
    switch (match) {
      case _Single(:final summary):
        return Right<Failure, CatalogGuideAnswer>(
          await _aboutMonument(summary.id, q.facet ?? GuideFacet.history, copy),
        );
      case _Ambiguous(:final candidates, :final total):
        return Right<Failure, CatalogGuideAnswer>(
          _ambiguous(q, candidates, total, copy),
        );
      case _NoMatch():
        // Katalog işareti olmayan, tanınmayan sözcükler ("hava nasıl")
        // Asistan servisine bırakılır.
        return q.mentionsCatalog
            ? Right<Failure, CatalogGuideAnswer>(
                _notInCatalog(q, overview, copy),
              )
            : null;
    }
  }

  /// Eser adları Türkçe özel addır ve çoğunlukla Türkçe yazılır ("Who
  /// built Bursa Ulu Camii?"; İngilizce adı "Bursa Great Mosque"). Ad önce
  /// Türkçe adlarda, bulunamazsa içerik dilindeki adlarda aranır. Yanıt
  /// yine içerik dilinde kurulur (detay kimlikle istenir).
  Future<_Match> _resolve(GuideQuestion q, _Copy copy) async {
    final match = await _resolveIn(q, 'tr');
    if (match is _NoMatch && copy.language != 'tr') {
      return _resolveIn(q, copy.language);
    }
    return match;
  }

  /// En çok bu kadar arama metni denenir ([GuideQuestion.searchTexts]).
  static const int maxSearchAttempts = 6;

  Future<_Match> _resolveIn(GuideQuestion q, String language) async {
    for (final text in q.searchTexts.take(maxSearchAttempts)) {
      final results = await _search(
        MonumentSearchQuery(
          text: text,
          filter: MonumentFilter(cities: q.cityCodes),
        ),
        language,
        searchLimit,
      );
      if (results.items.isEmpty) {
        continue;
      }
      final match = _NameMatcher(q).pick(results.items, results.total);
      if (match is! _NoMatch) {
        return match;
      }
    }
    return const _NoMatch();
  }

  Future<Result<CatalogGuideAnswer>?> _monumentAction(
    GuideQuestion q,
    GuideServerIntent intent,
    _Copy copy,
  ) async {
    final match = await _resolve(q, copy);
    if (match is! _Single) {
      return null;
    }
    final ref = _ref(match.summary);
    final damage = intent == GuideServerIntent.damage;
    return Right<Failure, CatalogGuideAnswer>(
      CatalogGuideAnswer(
        _message(
          damage ? copy.reportDamageFor(ref.name) : copy.memoriesFor(ref.name),
          sources: [ref],
          actions: [
            if (damage) GuideReportDamage(ref) else GuideOpenMemories(ref),
            GuideOpenMonument(ref),
          ],
          copy: copy,
        ),
        focus: ref,
      ),
    );
  }

  // --- Tek eser ------------------------------------------------------------

  Future<CatalogGuideAnswer> _aboutMonument(
    String id,
    GuideFacet facet,
    _Copy copy,
  ) async {
    final detail = _unwrap(
      await _catalog.getMonumentDetail(id: id, languageCode: copy.language),
    );
    final ref = GuideMonumentRef(
      id: detail.id,
      name: detail.name,
      city: detail.city,
    );
    final record = _Record(detail);
    final place = [
      detail.district,
      detail.city,
    ].where((part) => part.trim().isNotEmpty).join(', ');
    final heading = place.isEmpty ? detail.name : '${detail.name} ($place)';
    final lines = [heading, ...record.linesFor(facet, copy)];
    return CatalogGuideAnswer(
      _message(
        lines.join('\n'),
        sources: [ref],
        actions: [
          GuideOpenMonument(ref),
          if (detail.location?.isValid ?? false) GuideShowOnMap(ref),
        ],
        suggestions: [
          for (final next in _followUps)
            if (next != facet) copy.followUp(next),
        ].take(3).toList(),
        copy: copy,
      ),
      focus: ref,
    );
  }

  static const List<GuideFacet> _followUps = [
    GuideFacet.founder,
    GuideFacet.date,
    GuideFacet.location,
    GuideFacet.history,
  ];

  // --- Listeleme -----------------------------------------------------------

  Future<CatalogGuideAnswer> _list(GuideQuestion q, _Copy copy) async {
    final overview = await _overview(copy.language);
    final facets = overview.$1;
    final missingCities = _missingCities(q, facets);
    if (missingCities.isNotEmpty) {
      return _notInCatalog(q, overview, copy, cities: missingCities);
    }
    // Dönem bilgisi girilmemiş eserler "diğer" sayılır; bu durumda dönem
    // süzgeci uygulanmaz ve kullanıcıya söylenir.
    final unknownPeriods = {
      for (final period in q.periods)
        if ((facets.periods[period] ?? 0) == 0) period,
    };
    final periods = q.periods.difference(unknownPeriods);
    final filter = MonumentFilter(
      categories: q.categories,
      periods: periods,
      cities: q.cityCodes,
    );
    final notes = [
      if (unknownPeriods.isNotEmpty)
        copy.periodUnknown(unknownPeriods.map(copy.period).join(', ')),
    ];
    if (filter.isEmpty) {
      return _overviewAnswer(overview, copy, notes: notes);
    }
    final results = await _search(
      MonumentSearchQuery(filter: filter),
      copy.language,
      maxListed,
    );
    final criteria = _Criteria(filter, facets, copy);
    if (results.total == 0) {
      return CatalogGuideAnswer(
        _message(
          [...notes, copy.noneFor(criteria.describe())].join('\n\n'),
          suggestions: _overviewSuggestions(facets, copy),
          copy: copy,
        ),
      );
    }
    final listed = results.items.take(maxListed).toList();
    final text = [
      ...notes,
      copy.countFor(criteria, results.total),
      _bullets(listed),
    ].join('\n\n');
    return CatalogGuideAnswer(
      _message(
        text,
        sources: [for (final item in listed) _ref(item)],
        actions: [
          GuideSearchMonuments(
            MonumentSearchQuery(filter: filter),
            total: results.total,
          ),
        ],
        suggestions: [
          for (final item in listed.where(_isShortName).take(3))
            copy.followUp(GuideFacet.history, name: item.name),
        ],
        copy: copy,
      ),
    );
  }

  /// Öneri çipinde okunaklı ad: kısa, parsel numarası veya parantezle
  /// başlamayan.
  static bool _isShortName(MonumentSummary item) =>
      item.name.length <= 40 && !RegExp(r'^[\d(]').hasMatch(item.name);

  CatalogGuideAnswer _overviewAnswer(
    (MonumentFacets, int, DateTime) overview,
    _Copy copy, {
    List<String> notes = const [],
  }) {
    final (facets, total, _) = overview;
    final categories =
        facets.categories.entries
            .where((e) => e.key != MonumentCategory.other && e.value > 0)
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    return CatalogGuideAnswer(
      _message(
        [
          ...notes,
          copy.catalogSummary(total, _cityCounts(facets)),
          copy.askBy(categories.take(4).map((e) => copy.noun(e.key)).toList()),
        ].join('\n\n'),
        actions: [
          GuideSearchMonuments(MonumentSearchQuery.empty, total: total),
          const GuideOpenSection(GuideDestination.map),
        ],
        suggestions: _overviewSuggestions(facets, copy),
        copy: copy,
      ),
    );
  }

  // --- Bulunamadı / belirsiz -------------------------------------------------

  CatalogGuideAnswer _notInCatalog(
    GuideQuestion q,
    (MonumentFacets, int, DateTime) overview,
    _Copy copy, {
    Set<int> cities = const {},
  }) {
    final (facets, total, _) = overview;
    final first = cities.isNotEmpty
        ? copy.cityMissing(cities.map(TurkishProvinces.nameOf).toList())
        : copy.monumentMissing(q.nameText);
    return CatalogGuideAnswer(
      _message(
        '$first ${copy.catalogSummary(total, _cityCounts(facets))}',
        actions: [
          GuideSearchMonuments(MonumentSearchQuery.empty, total: total),
        ],
        suggestions: _overviewSuggestions(facets, copy),
        copy: copy,
      ),
    );
  }

  CatalogGuideAnswer _ambiguous(
    GuideQuestion q,
    List<MonumentSummary> candidates,
    int total,
    _Copy copy,
  ) {
    final listed = candidates.take(maxListed).toList();
    final facet = q.facet ?? GuideFacet.history;
    return CatalogGuideAnswer(
      _message(
        [copy.severalMatches(q.nameText), _bullets(listed)].join('\n\n'),
        sources: [for (final item in listed) _ref(item)],
        actions: [
          GuideSearchMonuments(
            MonumentSearchQuery(
              text: q.nameText,
              filter: MonumentFilter(cities: q.cityCodes),
            ),
            total: total,
          ),
        ],
        suggestions: [
          for (final item in listed.take(3))
            copy.followUp(facet, name: _distinctName(item, listed)),
        ],
        copy: copy,
      ),
    );
  }

  // --- Yardımcılar ---------------------------------------------------------

  /// Aynı adı taşıyan eserler ilçeyle ayrılır ("Orhangazi Muradiye
  /// Camii").
  static String _distinctName(MonumentSummary item, List<MonumentSummary> all) {
    final repeated = all.where((other) => other.name == item.name).length > 1;
    return repeated && item.district.trim().isNotEmpty
        ? '${item.district} ${item.name}'
        : item.name;
  }

  Set<int> _missingCities(GuideQuestion q, MonumentFacets facets) => {
    for (final code in q.cityCodes)
      if ((facets.cities[code] ?? 0) == 0) code,
  };

  List<(String, int)> _cityCounts(MonumentFacets facets) {
    final entries = facets.cities.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return [
      for (final MapEntry(key: code, value: count) in entries)
        (facets.cityNames[code] ?? TurkishProvinces.nameOf(code), count),
    ];
  }

  List<String> _overviewSuggestions(MonumentFacets facets, _Copy copy) {
    final cities = _cityCounts(facets);
    final categories =
        facets.categories.entries
            .where((e) => e.key != MonumentCategory.other && e.value > 0)
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    if (cities.isEmpty || categories.isEmpty) {
      return const [];
    }
    // En yaygın türler büyük illerde neredeyse her zaman bulunur: 1. il ×
    // 1. tür, 2. il × 2. tür, 3. il × 1. tür.
    final pairs = [(0, 0), (1, 1), (2, 0)];
    return [
      for (final (city, category) in pairs)
        if (city < cities.length && category < categories.length)
          copy.cityCategory(cities[city].$1, categories[category].key),
    ];
  }

  static String _bullets(List<MonumentSummary> items) => items
      .map((item) {
        final place = [
          item.district,
          item.city,
        ].where((part) => part.trim().isNotEmpty).join(', ');
        return place.isEmpty ? '• ${item.name}' : '• ${item.name} — $place';
      })
      .join('\n');

  static GuideMonumentRef _ref(MonumentSummary summary) =>
      GuideMonumentRef(id: summary.id, name: summary.name, city: summary.city);

  Future<(MonumentFacets, int, DateTime)> _overview(String language) async {
    final cached = _overviews[language];
    if (cached != null && _clock().difference(cached.$3) < overviewTtl) {
      return cached;
    }
    final results = await _search(MonumentSearchQuery.empty, language, 1);
    final overview = (results.facets, results.total, _clock());
    _overviews[language] = overview;
    return overview;
  }

  Future<MonumentSearchResults> _search(
    MonumentSearchQuery query,
    String language,
    int limit,
  ) async => _unwrap(
    await _catalog.searchMonuments(
      query: query,
      languageCode: language,
      limit: limit,
    ),
  );

  static T _unwrap<T>(Result<T> result) => switch (result) {
    Right<Failure, T>(:final value) => value,
    Left<Failure, T>(:final value) => throw _CatalogError(value),
  };

  GuideMessage _message(
    String text, {
    required _Copy copy,
    List<GuideMonumentRef> sources = const [],
    List<GuideAction> actions = const [],
    List<String> suggestions = const [],
  }) => GuideMessage(
    id: 'catalog_${++_messageCount}',
    text: text,
    createdAt: _clock(),
    sources: sources,
    actions: actions,
    suggestions: suggestions.take(maxSuggestions).toList(),
  );
}

final class _CatalogError implements Exception {
  const _CatalogError(this.failure);

  final Failure failure;
}

// --- Ad eşleştirme -----------------------------------------------------------

sealed class _Match {
  const _Match();
}

final class _Single extends _Match {
  const _Single(this.summary);

  final MonumentSummary summary;
}

final class _Ambiguous extends _Match {
  const _Ambiguous(this.candidates, this.total);

  final List<MonumentSummary> candidates;
  final int total;
}

final class _NoMatch extends _Match {
  const _NoMatch();
}

/// Katalog aramasının (bulanık) sonuçlarından soruda adı geçen eseri seçer.
///
/// 1. Ad sözcüklerinden en az biri bir adayın adında geçmelidir; hiçbir
///    adayda geçmeyen sözcükler ("ziyaret saatleri") yok sayılır. Hiçbir
///    sözcük eşleşmezse eser katalogda yoktur ("Süleymaniye").
/// 2. Adı soruda tam yazılan adaylar ("Hz. Mevlâna Türbesi" için "Mevlana
///    Türbesi") öne çıkar; aralarından sorudaki sözcüklerin en çoğunu
///    içeren ("Bursa Ulu Camii" → "Ulu (Hudâvendigâr) Camii" değil) ya da
///    parantez içiyle birlikte adı birebir yazılan ("Yeşil Camii") seçilir.
/// 3. Aksi halde il ve yapı türü sözcüklerinden en çoğunu içeren aday;
///    eşitlik varsa soru belirsizdir ("Ulu Camii" → hangisi?).
final class _NameMatcher {
  _NameMatcher(this.q)
    : _questionTokens = [...q.nameTokens, ...q.qualifierTokens];

  final GuideQuestion q;
  final List<String> _questionTokens;

  /// Adda yok sayılan sözcükler ("Hz.", "ve", "-i").
  static const Set<String> _ignorable = {
    'hz', 'hazreti', 've', 'ile', 'i', 'and', 'the', 'of', //
  };

  _Match pick(List<MonumentSummary> items, int total) {
    final titles = [
      for (final item in items)
        _Title(item.name, place: '${item.district} ${item.city}'),
    ];
    // İlçe adı da eşleşir ("Orhangazi Muradiye Camii"); puanlamada ise
    // yalnızca eser adı sayılır.
    final known = q.nameTokens
        .where((token) => titles.any((title) => title.containsWithPlace(token)))
        .toList();
    if (known.isEmpty) {
      return const _NoMatch();
    }
    final covered = <(MonumentSummary, _Title)>[
      for (var i = 0; i < items.length; i++)
        if (known.every(titles[i].containsWithPlace)) (items[i], titles[i]),
    ];
    if (covered.isEmpty) {
      return const _NoMatch();
    }
    final exact = covered
        .where((candidate) => candidate.$2.isSpelledBy(_questionTokens))
        .toList();
    int score((MonumentSummary, _Title) candidate) =>
        _questionTokens.toSet().where(candidate.$2.contains).length;
    if (exact.isNotEmpty) {
      final best = exact.map(score).reduce(_max);
      final top = exact.where((c) => score(c) == best).toList();
      if (top.length == 1) {
        return _Single(top.single.$1);
      }
      // "Yeşil Camii" ile "Yeşil (İmaret) Camii": adı birebir yazılan seçilir.
      // Üç ve daha fazla eşit aday ("Ulu Camii") gerçekten belirsizdir.
      final verbatim = top
          .where((c) => c.$2.isSpelledVerbatimBy(_questionTokens))
          .toList();
      if (top.length <= 2 && verbatim.length == 1) {
        return _Single(verbatim.single.$1);
      }
      return _Ambiguous([
        for (final c in top) c.$1,
        for (final c in covered)
          if (!top.contains(c)) c.$1,
      ], total);
    }
    final best = covered.map(score).reduce(_max);
    final top = covered.where((c) => score(c) == best).toList();
    if (top.length == 1) {
      return _Single(top.single.$1);
    }
    return _Ambiguous([for (final c in covered) c.$1], total);
  }

  static int _max(int a, int b) => a > b ? a : b;
}

/// Eser adının katlanmış sözcükleri; [core] parantez içi hariç.
final class _Title {
  _Title(String name, {String place = ''})
    : all = _tokens(name),
      _place = _tokens(place),
      core = _tokens(name.replaceAll(RegExp(r'\([^)]*\)'), ' '))
          .where((token) => !_NameMatcher._ignorable.contains(token))
          .toList();

  final List<String> all;
  final List<String> core;
  final List<String> _place;

  bool containsWithPlace(String token) =>
      contains(token) || _place.any((word) => _matches(token, word));

  late final List<String> _joined = [
    for (var i = 0; i + 1 < all.length; i++) '${all[i]}${all[i + 1]}',
  ];

  /// Sorudaki [token] addaki bir sözcükle (çekimli, yarım veya bitişik
  /// yazılmış haliyle: "camiini", "süleymani", "ulucami") eşleşir mi?
  bool contains(String token) =>
      all.any((word) => _matches(token, word)) ||
      _joined.any((word) => word.startsWith(token) && token.length >= 5);

  /// Addaki tüm (asıl) sözcükler soruda geçiyor mu?
  bool isSpelledBy(List<String> tokens) =>
      core.isNotEmpty &&
      core.every((word) => tokens.any((token) => _matches(token, word)));

  /// Parantez içi dahil addaki tüm sözcükler soruda geçiyor mu?
  bool isSpelledVerbatimBy(List<String> tokens) => all
      .where((word) => !_NameMatcher._ignorable.contains(word))
      .every((word) => tokens.any((token) => _matches(token, word)));

  static bool _matches(String token, String word) =>
      token == word ||
      (token.length > word.length &&
          token.startsWith(word) &&
          TurkishSuffixes.isSuffix(token.substring(word.length))) ||
      (token.length >= 5 &&
          token.length < word.length &&
          word.startsWith(token) &&
          token.length * 4 >= word.length * 3);

  static List<String> _tokens(String text) =>
      TurkishText.fold(text)
          .split(RegExp('[^a-z0-9]+'))
          .where((token) => token.isNotEmpty)
          .toList();
}

// --- Kayıttan bilgi çıkarma ---------------------------------------------------

/// Eser kaydının metinleri: yapılandırılmış alan boşsa ilgili bilgi
/// açıklamadaki cümleden alınır.
final class _Record {
  _Record(this.detail)
    : sentences = _sentences(
        [
          detail.shortDescription,
          detail.history,
          detail.description,
        ].where((text) => text.trim().isNotEmpty).join('\n'),
      );

  final MonumentDetail detail;
  final List<String> sentences;

  static const int _maxQuote = 420;
  static const int _maxSummary = 700;

  /// Miladi yıl (1000–1999) veya "H. 802" / "M. 1399" biçimi; "2.639
  /// metrekare" gibi sayılar yıl sayılmaz.
  static final RegExp _year = RegExp(
    r'(?<![0-9.,])(1[0-9]{3})(?![0-9]|[.,][0-9])|\b[hm]\. ?[0-9]{3,4}\b',
  );

  List<String> linesFor(GuideFacet facet, _Copy copy) => switch (facet) {
    GuideFacet.founder => [
      _field(detail.founder, copy.founderLabel) ??
          _quote(
            _first([_namesFounder, _isFounderBy, _isFounder, _isBuiltBy]),
            copy,
          ) ??
          copy.notRecorded(copy.founderLabel),
    ],
    GuideFacet.architect => [
      _field(detail.architect ?? '', copy.architectLabel) ??
          _quote(_first([_namesArchitect, _isArchitect]), copy) ??
          copy.notRecorded(copy.architectLabel),
    ],
    GuideFacet.date => [
      _field(detail.constructionDate, copy.dateLabel) ??
          _quote(_dateSentence(), copy) ??
          copy.notRecorded(copy.dateLabel),
    ],
    GuideFacet.period => [
      if (detail.period != HistoricalPeriod.other)
        '${copy.periodLabel}: ${copy.period(detail.period)}'
      else ...[
        copy.notRecorded(copy.periodLabel),
        ?_quote(_dateSentence(), copy),
      ],
    ],
    GuideFacet.location => [
      if (_firstParagraph(detail.address) case final address?)
        '${copy.addressLabel}: $address',
      if (!(detail.location?.isValid ?? false)) copy.noMapLocation,
    ],
    GuideFacet.unesco => [copy.unesco(isListed: detail.isUnescoWorldHeritage)],
    GuideFacet.history => [_summary()],
  };

  String? _field(String value, String label) =>
      value.trim().isEmpty ? null : '$label: ${value.trim()}';

  String? _quote(String? sentence, _Copy copy) =>
      sentence == null ? null : copy.fromRecord(_clip(sentence, _maxQuote));

  /// Testleri sırayla dener; önce yapının kendisinden ("türbe", "cami",
  /// "bu eser") söz eden cümlelerde, sonra tüm cümlelerde. Onarım, keşif
  /// ve görevlendirme cümleleri sayılmaz: bani sorusuna "2018'de
  /// müdürlükçe yaptırılan restorasyon" veya "Mahmud Paşa'nın yaptırdığı
  /// gümüş kafes" yanıt olmaz.
  String? _first(List<bool Function(String folded, String original)> tests) {
    for (final aboutBuilding in [true, false]) {
      for (final test in tests) {
        final found = _find(
          (folded, original) =>
              !_restoration.hasMatch(folded) &&
              (!aboutBuilding || _building.hasMatch(folded)) &&
              test(folded, original),
        );
        if (found != null) {
          return found;
        }
      }
    }
    return null;
  }

  static final RegExp _building = RegExp(
    r'\b(cami|mescid|mescit|turbe|hani?\b|hamam|medrese|kulliye|cesme|'
    r'imaret|kervansaray|darussifa|yapi|eser|bina|mosque|tomb|building|'
    r'structure|bath|inn\b|madrasa|fountain|complex|caravanserai)',
  );

  /// [test] katlanmış ve özgün cümleyle çağrılır.
  String? _find(bool Function(String folded, String original) test) {
    for (final sentence in sentences) {
      if (test(TurkishText.fold(sentence), sentence)) {
        return sentence;
      }
    }
    return null;
  }

  /// Baniyi adıyla anan cümle ("bânisi", "commissioned by").
  static bool _namesFounder(String folded, String original) =>
      _bani.hasMatch(folded) ||
      folded.contains('commissioned') ||
      folded.contains('founded by');

  /// "X tarafından yaptırılmış / inşa ettirilmiştir".
  static bool _isFounderBy(String folded, String original) =>
      folded.contains('tarafindan') &&
      (folded.contains('yaptir') ||
          folded.contains('insa ettir') ||
          folded.contains('vakf'));

  static bool _isFounder(String folded, String original) =>
      folded.contains('yaptir') ||
      folded.contains('insa ettir') ||
      folded.contains('vakfett') ||
      folded.contains('commissioned') ||
      folded.contains('built by') ||
      folded.contains('founded by');

  /// "X tarafından … inşa edilmiştir".
  static bool _isBuiltBy(String folded, String original) =>
      (folded.contains('tarafindan') || folded.contains(' by ')) &&
      _construction.hasMatch(folded);

  /// "bani", "banisi" (ör. "yabani" değil).
  static final RegExp _bani = RegExp(r'\bbani(si|sinin|leri)?\b');

  /// Mimarı adıyla anan cümle ("Mimar Sinan", "mimarı Hacı İvaz Paşa").
  static bool _namesArchitect(String folded, String sentence) =>
      RegExp(r'([Mm]imar[ıi]?|[Aa]rchitect)\s+(olarak\s+|was\s+)?[A-ZÇĞİÖŞÜ]')
          .hasMatch(sentence);

  static bool _isArchitect(String folded, String original) {
    final lower = TurkishText.toLowerCase(original);
    return RegExp(r'(^|[^a-zçğıöşü])mimar(\s|ı|lar|ın|lığ)').hasMatch(lower) ||
        lower.contains('architect');
  }

  /// Yapım tarihini veren cümle: önce yıl ve yapım sözcüğü geçen
  /// (onarım cümleleri hariç), sonra numaralı yüzyıl ("15. yüzyıl"), en son
  /// yalnızca yıl geçen cümle. "Altı yüzyıl boyunca" tarih sayılmaz.
  String? _dateSentence() =>
      _first([
        (folded, _) => _year.hasMatch(folded) && _construction.hasMatch(folded),
        (folded, _) =>
            _century.hasMatch(folded) && _construction.hasMatch(folded),
      ]) ??
      _find((folded, _) => _year.hasMatch(folded) || _century.hasMatch(folded));

  static final RegExp _construction = RegExp(
    'insa|yaptir|tamamlan|acilis|kurul|yapim|yapilmis|yapildi|built|'
    'construct|completed|erected',
  );

  static final RegExp _restoration = RegExp(
    'onar|tamir|restor|yenilen|ihya|gorevlendir|tevcih|kesif|tetkik|'
    'repair|renovat|survey',
  );

  static final RegExp _century = RegExp(
    r'\b([0-9]{1,2}|[ivx]+)\.? ?(yuzyil|asir|century)',
  );

  String _summary() {
    final buffer = StringBuffer();
    for (final sentence in sentences) {
      if (buffer.length + sentence.length > _maxSummary && buffer.isNotEmpty) {
        break;
      }
      if (buffer.isNotEmpty) {
        buffer.write(' ');
      }
      buffer.write(sentence);
    }
    return buffer.isEmpty
        ? detail.shortDescription.trim()
        : _clip(buffer.toString(), _maxSummary);
  }

  static String? _firstParagraph(String text) {
    final first = text
        .split(RegExp(r'\n\s*\n'))
        .map((part) => part.trim())
        .firstWhere((part) => part.isNotEmpty, orElse: () => '');
    return first.isEmpty ? null : _clip(first, _maxQuote);
  }

  static String _clip(String text, int max) {
    final clean = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (clean.length <= max) {
      return clean;
    }
    final cut = clean.lastIndexOf(' ', max);
    return '${clean.substring(0, cut > 0 ? cut : max)}…';
  }

  /// Cümlelere ayırır: noktadan sonra büyük harf, rakam ("2018 yılında")
  /// veya tırnak gelmelidir;
  /// "H. 802 / M. 1399", "II. Murad", "Hz. Mevlâna" gibi kısaltmalarda
  /// bölünmez.
  static List<String> _sentences(String text) {
    final seen = <String>{};
    final sentences = <String>[];
    for (final paragraph in text.split(RegExp(r'\n+'))) {
      final parts = paragraph.split(
        RegExp('(?<=[.!?…])\\s+(?=[A-ZÇĞİÖŞÜÂÎÛ0-9“"‘\'(])'),
      );
      var pending = '';
      for (final part in parts) {
        pending = pending.isEmpty ? part : '$pending $part';
        if (!_abbreviation.hasMatch(pending)) {
          final sentence = pending.trim();
          if (sentence.length > 1 && seen.add(sentence)) {
            sentences.add(sentence);
          }
          pending = '';
        }
      }
      final rest = pending.trim();
      if (rest.length > 1 && seen.add(rest)) {
        sentences.add(rest);
      }
    }
    return sentences;
  }

  /// Cümle sonu sayılmayan kısaltma: Roma rakamı, tek harf, "Hz.", "Dr."…
  static final RegExp _abbreviation = RegExp(
    r'(^|[\s(])([IVXLC]+|[A-ZÇĞİÖŞÜ]|Hz|Dr|St|Bkz|bkz|vb|vs|Mah|Cad|Sk|No)\.$',
  );
}

// --- Ölçüt açıklaması ---------------------------------------------------------

final class _Criteria {
  const _Criteria(this.filter, this.facets, this.copy);

  final MonumentFilter filter;
  final MonumentFacets facets;
  final _Copy copy;

  List<String> get cities => [
    for (final code in filter.cities)
      facets.cityNames[code] ?? TurkishProvinces.nameOf(code),
  ];

  String describe() => [
    ...cities,
    ...filter.periods.map(copy.period),
    ...filter.categories.map(copy.category),
  ].join(' · ');
}

// --- Metinler ---------------------------------------------------------------

/// Yanıt metinleri (içerik dilinde: `tr` veya `en`).
final class _Copy {
  _Copy(String languageCode) : language = languageCode == 'en' ? 'en' : 'tr';

  final String language;

  bool get _en => language == 'en';

  String t(String tr, String en) => _en ? en : tr;

  String get founderLabel => t('Banisi (yaptıran)', 'Founder');
  String get architectLabel => t('Mimarı', 'Architect');
  String get dateLabel => t('Yapım tarihi', 'Construction date');
  String get periodLabel => t('Dönemi', 'Period');
  String get addressLabel => t('Adres', 'Address');

  String notRecorded(String label) => t(
    'Katalog kaydında bu bilgi (${TurkishText.toLowerCase(label)}) yer almıyor.',
    'The catalogue record does not include this information '
        '(${label.toLowerCase()}).',
  );

  String fromRecord(String sentence) => t(
    'Katalog kaydına göre: “$sentence”',
    'According to the catalogue '
        'record: “$sentence”',
  );

  String get noMapLocation => t(
    'Eserin haritadaki konumu henüz işaretlenmemiş.',
    'Its location has not been marked on the map yet.',
  );

  String unesco({required bool isListed}) => isListed
      ? t(
          'UNESCO Dünya Mirası Listesi’nde yer alıyor.',
          'It is on the UNESCO World Heritage List.',
        )
      : t(
          'Katalog kaydına göre UNESCO Dünya Mirası Listesi’nde yer almıyor.',
          'According to the catalogue it is not on the UNESCO World Heritage '
              'List.',
        );

  String get whichMonument => t(
    'Hangi eseri sorduğunuzu anlayamadım. Eserin adını yazar mısınız? '
        'Örneğin: “Bursa Ulu Camii ne zaman yapıldı?”',
    'I could not tell which monument you mean. Could you write its name? '
        'For example: “When was Bursa Ulu Camii built?”',
  );

  String monumentMissing(String name) => t(
    '“$name” adlı bir eser kataloğumuzda bulunmuyor.',
    '“$name” is not in our catalogue.',
  );

  String cityMissing(List<String> cities) => t(
    'Katalogda henüz ${_join(cities, 've')} ${cities.length > 1 ? 'illerinden' : 'ilinden'} eser yok.',
    'The catalogue has no monuments from ${_join(cities, 'and')} yet.',
  );

  String catalogSummary(int total, List<(String, int)> cities) {
    final list = cities.map((c) => '${c.$1} (${c.$2})').toList();
    return t(
      'Katalogda şu an ${_join(list, 've')} illerinden toplam $total vakıf '
          'eseri var.',
      'The catalogue currently has $total foundation monuments from '
          '${_join(list, 'and')}.',
    );
  }

  String askBy(List<String> nouns) => t(
    'İl, yapı türü (${nouns.join(', ')}…) veya eser adıyla sorabilirsiniz.',
    'You can ask by province, building type (${nouns.join(', ')}…) or name.',
  );

  String periodUnknown(String periods) => t(
    'Katalogdaki eserlerin dönem bilgisi henüz girilmemiş; bu yüzden '
        '$periods dönemine göre süzemiyorum.',
    'Period information has not been entered for catalogue monuments yet, '
        'so I cannot filter by $periods.',
  );

  String noneFor(String criteria) => t(
    'Katalogda bu ölçütlere uyan eser bulunmuyor ($criteria).',
    'No monuments in the catalogue match these criteria ($criteria).',
  );

  String countFor(_Criteria criteria, int total) {
    final cities = criteria.cities;
    final categories = criteria.filter.categories.toList();
    final periods = criteria.filter.periods.map(period).toList();
    if (_en) {
      final what = categories.length == 1
          ? (total == 1
                ? category(categories.single)
                : plural(categories.single))
          : (total == 1 ? 'monument' : 'monuments');
      final extra = [
        ...periods,
        if (categories.length > 1) ...categories.map(category),
      ];
      return 'The catalogue has $total ${what.toLowerCase()}'
          '${extra.isEmpty ? '' : ' (${extra.join(', ')})'}'
          '${cities.isEmpty ? '' : ' in ${_join(cities, 'and')}'}:';
    }
    final where = cities.isEmpty
        ? 'Katalogda'
        : 'Katalogda ${_join(cities, 've')} '
              '${cities.length > 1 ? 'illerinde' : 'ilinde'}';
    final what = categories.length == 1 ? noun(categories.single) : 'eser';
    final extra = [
      ...periods,
      if (categories.length > 1) ...categories.map(category),
    ];
    return '$where${extra.isEmpty ? '' : ' (${extra.join(', ')})'} '
        '$total $what var:';
  }

  String severalMatches(String name) => t(
    '“$name” adıyla eşleşen birden fazla eser var. Hangisini soruyorsunuz?',
    'Several monuments match “$name”. Which one do you mean?',
  );

  String reportDamageFor(String name) => t(
    '$name için hasar bildirimini aşağıdaki butonla başlatabilirsiniz; eser '
        'formda seçili gelir. Can güvenliği tehlikedeyse önce 112’yi arayın.',
    'You can start a damage report for $name with the button below; the '
        'monument will be preselected. If anyone is in danger, call 112 '
        'first.',
  );

  String memoriesFor(String name) => t(
    '$name için paylaşılan anıları görebilir, kendi anınızı '
        'ekleyebilirsiniz.',
    'You can read the memories shared for $name and add your own.',
  );

  /// Takip sorusu; [name] verilmezse konuşulan esere göndermedir.
  String followUp(GuideFacet facet, {String? name}) => switch (facet) {
    GuideFacet.founder =>
      name == null
          ? t('Kim yaptırdı?', 'Who built it?')
          : t('$name banisi kim?', 'Who built $name?'),
    GuideFacet.architect =>
      name == null
          ? t('Mimarı kim?', 'Who was the architect?')
          : t('$name mimarı kim?', 'Who was the architect of $name?'),
    GuideFacet.date =>
      name == null
          ? t('Ne zaman yapıldı?', 'When was it built?')
          : t('$name ne zaman yapıldı?', 'When was $name built?'),
    GuideFacet.location =>
      name == null
          ? t('Nerede?', 'Where is it?')
          : t('$name nerede?', 'Where is $name?'),
    GuideFacet.period =>
      name == null
          ? t('Hangi döneme ait?', 'Which period is it from?')
          : t('$name hangi döneme ait?', 'Which period is $name from?'),
    GuideFacet.unesco =>
      name == null
          ? t('UNESCO listesinde mi?', 'Is it UNESCO-listed?')
          : t('$name UNESCO listesinde mi?', 'Is $name UNESCO-listed?'),
    GuideFacet.history =>
      name == null
          ? t('Tarihçesini anlat', 'Tell me its history')
          : t('$name hakkında bilgi ver', 'Tell me about $name'),
  };

  String cityCategory(String city, MonumentCategory category) => t(
    '$city ${_trPlural[category] ?? 'eserleri'}',
    '${plural(category)} in $city',
  );

  String category(MonumentCategory value) => switch (value) {
    MonumentCategory.mosque => t('Cami', 'Mosque'),
    MonumentCategory.complex => t('Külliye', 'Complex'),
    MonumentCategory.madrasa => t('Medrese', 'Madrasa'),
    MonumentCategory.inn => t('Han', 'Inn'),
    MonumentCategory.caravanserai => t('Kervansaray', 'Caravanserai'),
    MonumentCategory.bath => t('Hamam', 'Bath'),
    MonumentCategory.fountain => t('Çeşme', 'Fountain'),
    MonumentCategory.tomb => t('Türbe', 'Tomb'),
    MonumentCategory.hospital => t('Darüşşifa', 'Hospital'),
    MonumentCategory.imaret => t('İmaret', 'Public kitchen'),
    MonumentCategory.other => t('Diğer', 'Other'),
  };

  /// Sayıdan sonra gelen ad ("34 hamam").
  String noun(MonumentCategory value) => _en
      ? plural(value).toLowerCase()
      : TurkishText.toLowerCase(category(value));

  String plural(MonumentCategory value) => switch (value) {
    MonumentCategory.mosque => 'Mosques',
    MonumentCategory.complex => 'Complexes',
    MonumentCategory.madrasa => 'Madrasas',
    MonumentCategory.inn => 'Inns',
    MonumentCategory.caravanserai => 'Caravanserais',
    MonumentCategory.bath => 'Baths',
    MonumentCategory.fountain => 'Fountains',
    MonumentCategory.tomb => 'Tombs',
    MonumentCategory.hospital => 'Hospitals',
    MonumentCategory.imaret => 'Public kitchens',
    MonumentCategory.other => 'Other buildings',
  };

  static const Map<MonumentCategory, String> _trPlural = {
    MonumentCategory.mosque: 'camileri',
    MonumentCategory.complex: 'külliyeleri',
    MonumentCategory.madrasa: 'medreseleri',
    MonumentCategory.inn: 'hanları',
    MonumentCategory.caravanserai: 'kervansarayları',
    MonumentCategory.bath: 'hamamları',
    MonumentCategory.fountain: 'çeşmeleri',
    MonumentCategory.tomb: 'türbeleri',
    MonumentCategory.hospital: 'darüşşifaları',
    MonumentCategory.imaret: 'imaretleri',
  };

  String period(HistoricalPeriod value) => switch (value) {
    HistoricalPeriod.seljuk => t('Selçuklu', 'Seljuk'),
    HistoricalPeriod.beylik => t('Beylikler', 'Beylik'),
    HistoricalPeriod.ottoman => t('Osmanlı', 'Ottoman'),
    HistoricalPeriod.other => t('Diğer', 'Other'),
  };

  static String _join(List<String> items, String and) => switch (items) {
    [] => '',
    [final only] => only,
    _ => '${items.sublist(0, items.length - 1).join(', ')} $and ${items.last}',
  };
}
