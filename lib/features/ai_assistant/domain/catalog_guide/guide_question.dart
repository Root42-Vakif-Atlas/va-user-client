import 'package:vakif_atlas/core/utils/turkish_text.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/catalog_guide/turkish_provinces.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';

/// Soruda istenen eser bilgisi.
enum GuideFacet { founder, architect, date, location, period, unesco, history }

/// Asistan servisinin yanıtladığı uygulama niyetleri.
enum GuideServerIntent {
  emergency,
  damage,
  settings,
  memories,
  route,
  nearby,
  map,
}

/// Rehbere sorulan sorunun çözümlenmiş hali.
///
/// Soru Türkçe katlanır (ç→c, ı→i, …) ve sözcüklere ayrılır; il, yapı türü,
/// dönem, istenen bilgi ([facet]) ve eser adı sözcükleri ([nameTokens])
/// ayrıştırılır. Eser adı, bilinen hiçbir sözlüğe girmeyen sözcüklerdir
/// ("Bursa Ulu Camii ne zaman yapıldı?" → `ulu`).
final class GuideQuestion {
  GuideQuestion._({
    required this.tokens,
    required this.cityCodes,
    required this.categories,
    required this.periods,
    required this.facet,
    required this.isListing,
    required this.serverIntent,
    required this.isSmallTalk,
    required this.nameTokens,
    required this.qualifierTokens,
    required this.searchTexts,
  });

  factory GuideQuestion.parse(String question) {
    final words = _words(question);
    final tokens = [for (final word in words) ...word.folded];
    final lower = _tokenize(TurkishText.toLowerCase(question));
    final query = _Query(tokens);

    final cityCodes = <int>{};
    final cityTokens = <String>{};
    for (final token in tokens) {
      if (TurkishProvinces.codeOf(token) case final int code) {
        cityCodes.add(code);
        cityTokens.add(token);
      }
    }
    final categories = {
      for (final MapEntry(key: category, value: keywords)
          in _Vocabulary.categories.entries)
        if (keywords.matches(query)) category,
    };
    final periods = {
      for (final MapEntry(key: period, value: keywords)
          in _Vocabulary.periods.entries)
        if (keywords.matches(query)) period,
    };

    bool isName(String token) =>
        token.length >= 2 &&
        !cityTokens.contains(token) &&
        !_Vocabulary.stopWords.contains(token) &&
        !_Vocabulary.nonName.any((keywords) => keywords.matchesToken(token)) &&
        !_Vocabulary.categories.values.any((k) => k.matchesToken(token)) &&
        !_Vocabulary.periods.values.any((k) => k.matchesToken(token));
    bool isQualifier(String token) =>
        cityTokens.contains(token) ||
        _Vocabulary.categories.values.any((k) => k.matchesToken(token));

    final nameTokens = [
      for (final token in tokens)
        if (isName(token)) token,
    ];
    final qualifierTokens = [
      for (final token in tokens)
        if (isQualifier(token)) token,
    ];

    return GuideQuestion._(
      tokens: tokens,
      cityCodes: cityCodes,
      categories: categories,
      periods: periods,
      facet: _facetOf(query, lower),
      isListing: _Vocabulary.listing.matches(query),
      serverIntent: _serverIntentOf(query, hasName: nameTokens.isNotEmpty),
      isSmallTalk: _Vocabulary.smallTalk.matches(query),
      nameTokens: nameTokens,
      qualifierTokens: qualifierTokens,
      searchTexts: nameTokens.isEmpty
          ? const []
          : _searchTexts(words, isName: isName, isQualifier: isQualifier),
    );
  }

  /// Katlanmış sözcükler.
  final List<String> tokens;

  /// Soruda geçen illerin plaka kodları (katalogda olmayanlar dahil).
  final Set<int> cityCodes;
  final Set<MonumentCategory> categories;
  final Set<HistoricalPeriod> periods;
  final GuideFacet? facet;

  /// "Hangi", "listele", "kaç" gibi listeleme isteği.
  final bool isListing;

  /// Uygulama işlevine dair niyet (acil durum, hasar, rota, ayarlar,
  /// anılar, yakındaki eserler, harita); Asistan servisinde yanıtlanır.
  /// Hasar ve anı soruları katalogdaki bir eseri adıyla anıyorsa eser
  /// uygulamada çözülüp ilgili eylem önerilir.
  final GuideServerIntent? serverIntent;

  /// Selamlaşma, teşekkür, "neler yapabilirsin".
  final bool isSmallTalk;

  /// Eser adı sözcükleri (katlanmış).
  final List<String> nameTokens;

  /// Adın parçası olabilecek il ve yapı türü sözcükleri ("Bursa Ulu
  /// Camii" → `bursa`, `camii`); eşleşen adayı öne çıkarır.
  final List<String> qualifierTokens;

  /// Soruda yazıldığı biçimiyle eser adı ("Süleymaniye Camii").
  String get nameText => searchTexts.isEmpty ? '' : searchTexts.first;

  /// Katalogda sırayla aranacak ad metinleri: önce [nameText], sonra
  /// onun daha kısa parçaları. Katalog araması tüm sözcükleri birlikte
  /// aradığından adla ilgisiz bir sözcük ("Mevlana Türbesi ziyaret
  /// saatleri") sonucu boşaltır; parçalar en uzundan başlayarak denenir.
  final List<String> searchTexts;

  bool get hasName => nameTokens.isNotEmpty;

  bool get hasFilter =>
      cityCodes.isNotEmpty || categories.isNotEmpty || periods.isNotEmpty;

  /// Katalogla ilgili bir soru olduğuna dair işaret (ad aranıp
  /// bulunamadığında "katalogda yok" demek için gerekir).
  bool get mentionsCatalog => hasFilter || facet != null || isListing;

  static GuideServerIntent? _serverIntentOf(
    _Query query, {
    required bool hasName,
  }) {
    for (final (intent, keywords) in _Vocabulary.serverIntents) {
      if (keywords.matches(query)) {
        return intent;
      }
    }
    // "Haritayı aç" uygulamaya; "Ulu Camii haritada nerede?" katalog
    // sorusudur.
    return !hasName && _Vocabulary.map.matches(query)
        ? GuideServerIntent.map
        : null;
  }

  static GuideFacet? _facetOf(_Query query, List<String> lower) {
    // "mimarı" (mimar) ile "mimarisi" (mimari üslup) katlanınca aynı
    // görünür; ayrım katlanmamış küçük harfle yapılır.
    final architect = lower.any(
      (token) =>
          (token.startsWith('mimar') && !token.startsWith('mimari')) ||
          token.startsWith('architect'),
    );
    if (architect) {
      return GuideFacet.architect;
    }
    for (final (facet, keywords) in _Vocabulary.facets) {
      if (keywords.matches(query)) {
        return facet;
      }
    }
    return null;
  }

  /// Ad sözcüklerinin sorudaki ilk ve son konumu arasındaki sözcükler
  /// (hemen öncesindeki kesme işaretsiz il adı ve yapı türü dahil: "Bursa
  /// Ulu Camii"), ardından bu aralığın ad sözcüğü içeren, ad parçasıyla
  /// başlayıp biten alt aralıkları (uzundan kısaya).
  static List<String> _searchTexts(
    List<_Word> words, {
    required bool Function(String) isName,
    required bool Function(String) isQualifier,
  }) {
    bool hasName(_Word word) => word.folded.any(isName);
    bool partOfName(_Word word) =>
        word.folded.isNotEmpty &&
        (isName(word.folded.first) || isQualifier(word.folded.first));
    var start = words.indexWhere(hasName);
    var end = words.lastIndexWhere(hasName);
    while (start > 0 && partOfName(words[start - 1])) {
      start--;
    }
    while (end < words.length - 1 &&
        !words[end].hadSuffix &&
        partOfName(words[end + 1])) {
      end++;
    }
    final span = words.sublist(start, end + 1);
    String text(Iterable<_Word> part) => part.map((w) => w.text).join(' ');
    final texts = <String>[text(span)];
    for (var length = span.length - 1; length >= 1; length--) {
      for (var from = 0; from + length <= span.length; from++) {
        final part = span.sublist(from, from + length);
        if (partOfName(part.first) &&
            partOfName(part.last) &&
            part.any(hasName)) {
          texts.add(text(part));
        }
      }
    }
    return {
      for (final value in texts)
        if (value.trim().isNotEmpty) value,
    }.toList();
  }

  static List<_Word> _words(String question) => [
    for (final raw in question.split(RegExp(r'\s+')))
      if (_Word.parse(raw) case final _Word word) word,
  ];

  static List<String> _tokenize(String text) => text
      .split(RegExp('[^a-z0-9çğıöşüâîû]+'))
      .where((token) => token.isNotEmpty)
      .toList();
}

/// Sorudaki bir sözcük: yazıldığı hali (kesme işaretinden sonrası atılır)
/// ve katlanmış parçaları.
final class _Word {
  const _Word(this.text, this.folded, {required this.hadSuffix});

  static _Word? parse(String raw) {
    final apostrophe = raw.indexOf(RegExp('[\'’`´]'));
    final head = apostrophe < 0 ? raw : raw.substring(0, apostrophe);
    final text = head.replaceAll(
      RegExp(r'^[^\p{L}\p{N}]+|[^\p{L}\p{N}]+$', unicode: true),
      '',
    );
    final folded = TurkishText.fold(raw)
        .split(RegExp('[^a-z0-9]+'))
        .where((token) => token.isNotEmpty)
        .toList();
    if (folded.isEmpty) {
      return null;
    }
    return _Word(text, folded, hadSuffix: apostrophe >= 0);
  }

  final String text;
  final List<String> folded;
  final bool hadSuffix;
}

final class _Query {
  _Query(this.tokens) : _padded = ' ${tokens.join(' ')} ';

  final List<String> tokens;
  final String _padded;

  bool hasPhrase(String phrase) => _padded.contains(' $phrase');
}

/// Niyet sözlüğü: tam sözcükler, sözcük başları (çekimli halleri için) ve
/// ifadeler (katlanmış).
final class _Keywords {
  const _Keywords({
    this.words = const {},
    this.prefixes = const [],
    this.phrases = const [],
  });

  final Set<String> words;
  final List<String> prefixes;
  final List<String> phrases;

  bool matchesToken(String token) =>
      words.contains(token) || prefixes.any(token.startsWith);

  bool matches(_Query query) =>
      query.tokens.any(matchesToken) || phrases.any(query.hasPhrase);
}

abstract final class _Vocabulary {
  static const _Keywords emergency = _Keywords(
    words: {'acil', 'fire', '112', 'alev'},
    prefixes: [
      'yangin', 'yaniyor', 'yandi', 'yanmis', 'cokuyor', 'coktu', //
      'cokecek', 'yikiliyor', 'yikildi', 'deprem', 'emergenc', 'collaps',
      'earthquake', 'burning',
    ],
  );

  static const _Keywords damage = _Keywords(
    words: {'bildir', 'report', 'ihbar', 'kirik', 'broken'},
    prefixes: [
      'hasar', 'catlak', 'catlam', 'yikik', 'vandal', 'tahrip', 'sikayet', //
      'bildir', 'damage', 'crack', 'graffit', 'stolen', 'calin',
    ],
    phrases: ['sivil koruma', 'civil protection'],
  );

  static const _Keywords settings = _Keywords(
    words: {
      'font', 'dark', 'koyu', 'karanlik', 'dil', 'dili', 'language', //
      'ingilizce', 'english', 'turkish',
    },
    prefixes: [
      'ayar', 'setting', 'erisilebil', 'accessib', 'buyut', 'kucult', //
      'enlarge', 'tema', 'theme', 'kontrast', 'contrast', 'daltoni',
      'colorblind', 'colourblind', 'titresim', 'vibrat', 'animasyon',
      'animation',
    ],
    phrases: [
      'yazi boyut', 'metin boyut', 'text size', 'font size', 'renk kor', //
      'color blind', 'colour blind', 'hareketi azalt', 'reduce motion',
    ],
  );

  static const _Keywords memories = _Keywords(
    words: {
      'ani', 'anilar', 'anilari', 'anisi', 'aniyi', 'anim', 'anilarim', //
      'anilarini', 'aninizi', 'memory', 'memories',
    },
    prefixes: ['hatira', 'memor'],
  );

  static const _Keywords route = _Keywords(
    words: {'plan', 'tur', 'tour', 'trip', 'gezmek', 'gezi'},
    prefixes: [
      'rota',
      'guzergah',
      'itinerar',
      'route',
      'planla',
      'optimiz',
      'optimis',
    ],
  );

  static const _Keywords nearby = _Keywords(
    words: {'near', 'around', 'nearby'},
    prefixes: ['yakin', 'cevrem', 'etrafim', 'konumum'],
  );

  static const _Keywords map = _Keywords(words: {'map'}, prefixes: ['harita']);

  /// Sıra önemlidir: "Camide yangın var, hasar bildir" → acil.
  static const List<(GuideServerIntent, _Keywords)> serverIntents = [
    (GuideServerIntent.emergency, emergency),
    (GuideServerIntent.damage, damage),
    (GuideServerIntent.settings, settings),
    (GuideServerIntent.memories, memories),
    (GuideServerIntent.route, route),
    (GuideServerIntent.nearby, nearby),
  ];

  static const _Keywords smallTalk = _Keywords(
    words: {
      'yardim', 'help', 'kimsin', 'thanks', 'thx', 'eyv', 'sagol', //
      'sagolun', 'merhaba', 'merhabalar', 'selam', 'selamlar', 'hello', 'hi',
      'hey', 'gunaydin', 'mrb', 'slm',
    },
    prefixes: ['tesekkur', 'thank'],
    phrases: [
      'ne yapabilir', 'neler yapabilir', 'what can you', 'who are you', //
      'iyi gunler', 'iyi aksamlar', 'good morning',
    ],
  );

  static const _Keywords listing = _Keywords(
    words: {
      'list', 'listele', 'hangi', 'hangileri', 'neler', 'nereler', 'kac', //
      'tumu', 'hepsi', 'all', 'sites', 'places', 'which',
    },
    prefixes: ['eserler', 'yapilar', 'monuments', 'gezilecek', 'gorulecek'],
    phrases: ['how many'],
  );

  /// Sıra önemlidir: "Kim yaptırdı, ne zaman?" → bani.
  static const List<(GuideFacet, _Keywords)> facets = [
    (
      GuideFacet.founder,
      _Keywords(
        words: {'kim', 'kimin', 'who', 'bani', 'banisi', 'kurucu', 'kurucusu'},
        prefixes: ['yaptir', 'founder', 'founded', 'commission'],
      ),
    ),
    (
      GuideFacet.unesco,
      _Keywords(prefixes: ['unesco'], phrases: ['dunya miras', 'world herit']),
    ),
    (
      GuideFacet.history,
      _Keywords(
        words: {'history', 'story', 'gecmisi', 'about'},
        prefixes: ['tarihce', 'hikaye', 'anlat', 'hakkinda', 'bilgi'],
      ),
    ),
    (
      GuideFacet.location,
      _Keywords(
        words: {
          'nerede', 'nerde', 'neresi', 'nerededir', 'where', 'adres', //
          'adresi', 'address',
        },
        prefixes: ['haritada', 'konumu'],
        phrases: ['nasil gid', 'how do i get', 'how to get'],
      ),
    ),
    (
      GuideFacet.period,
      _Keywords(words: {'era'}, prefixes: ['donem', 'period']),
    ),
    (
      GuideFacet.date,
      _Keywords(
        words: {
          'zaman', 'when', 'year', 'yil', 'yili', 'date', 'tarih', //
          'tarihi', 'tarihinde', 'century', 'yuzyil', 'kacinci',
        },
        prefixes: ['insa', 'yapim', 'yapil', 'built', 'construct'],
      ),
    ),
  ];

  static final List<_Keywords> nonName = [
    for (final (_, keywords) in serverIntents) keywords,
    map,
    smallTalk,
    listing,
    for (final (_, keywords) in facets) keywords,
    const _Keywords(prefixes: ['mimar', 'architect']),
  ];

  static const Map<MonumentCategory, _Keywords> categories = {
    MonumentCategory.mosque: _Keywords(
      words: {'mescit', 'mescid', 'mescidi', 'mescitler', 'mosques'},
      prefixes: ['cami', 'mosque'],
    ),
    MonumentCategory.complex: _Keywords(prefixes: ['kulliye', 'complex']),
    MonumentCategory.madrasa: _Keywords(
      prefixes: ['medrese', 'madrasa', 'madrassa'],
    ),
    MonumentCategory.inn: _Keywords(
      words: {'han', 'hani', 'hanlar', 'hanlari', 'hanlarini', 'inn', 'inns'},
    ),
    MonumentCategory.caravanserai: _Keywords(
      prefixes: ['kervansaray', 'caravanserai', 'caravansar'],
    ),
    MonumentCategory.bath: _Keywords(prefixes: ['hamam', 'bath', 'hammam']),
    MonumentCategory.fountain: _Keywords(
      words: {'sebil'},
      prefixes: ['cesme', 'fountain'],
    ),
    MonumentCategory.tomb: _Keywords(prefixes: ['turbe', 'tomb', 'mausole']),
    MonumentCategory.hospital: _Keywords(
      prefixes: ['darussifa', 'sifahane', 'hospital'],
    ),
    MonumentCategory.imaret: _Keywords(
      prefixes: ['imaret', 'daruzziyafe', 'asevi'],
    ),
  };

  static const Map<HistoricalPeriod, _Keywords> periods = {
    HistoricalPeriod.seljuk: _Keywords(
      prefixes: ['selcuk', 'seljuk', 'seljuq'],
    ),
    HistoricalPeriod.beylik: _Keywords(
      prefixes: ['beylik', 'principalit', 'mengucek'],
    ),
    HistoricalPeriod.ottoman: _Keywords(prefixes: ['osmanli', 'ottoman']),
  };

  /// Ad sayılmayan bağlaç, soru ve dolgu sözcükleri ile kesme işaretinden
  /// sonra ayrılan ekler.
  static const Set<String> stopWords = {
    've', 'ile', 'veya', 'ya', 'da', 'de', 'ki', 'bu', 'su', 'o', 'bir', //
    'mi', 'mu', 'ne', 'nedir', 'neresi', 'nasil', 'icin', 'gibi', 'en',
    'cok', 'tane', 'var', 'varmi', 'yok', 'olan', 'olarak', 'hangisi',
    'bana', 'bize', 'ver', 'verir', 'verin', 'misin', 'misiniz', 'musun',
    'soyle', 'soyler', 'soylermisin', 'lutfen', 'acaba', 'peki', 'simdi',
    'eser', 'eseri', 'eserin', 'eserde', 'eserler', 'eserleri', 'eserlerin',
    'yapi', 'yapisi', 'yapinin', 'yapilar', 'yapilari', 'tarihi', 'tarihli',
    'il', 'ili', 'iller', 'illerde', 'ilde', 'ilinde', 'sehir', 'sehirde',
    'sehirler',
    'sehirlerde',
    'katalog',
    'katalogda',
    'toplam',
    'vakif',
    'vakfi',
    'bura', 'burasi', 'burada', 'orasi', 'orada', 'dir', 'dur', 'tir',
    'ac', 'acar', 'acin', 'acabilir', 'goster', 'gosterir', 'gosterin',
    'gor', 'gorebilir', 'open', 'see', 'view',
    'ait', 'aittir', 'midir', 'mudur', 'kimdir', 'hangisidir', 'mevcut',
    'bulunan', 'bulunur', 'yer', 'alir', 'eseridir', 'yapisidir',
    'nin', 'nun', 'in', 'un', 'ni', 'nu', 'i', 'u', 'yi', 'yu', 'a', 'e',
    'ye', 'na', 'daki', 'deki', 'taki', 'teki', 'dan', 'den', 'tan', 'ten',
    'ta', 'te', 'nda', 'nde', 'ndaki', 'ndeki', 'ndan', 'nden', 'si', 'ler',
    'lar', 'leri', 'lari', 'lerin', 'larin', 'is', 'was', 'are', 'the',
    'an', 'of', 'at', 'on', 'to', 'for', 'me', 'us', 'tell', 'please',
    'show', 'give', 'info', 'information', 'does', 'did', 'do', 'it', 'its',
    'this', 'that', 'there', 'what', 'how', 'by', 'located', 'city',
    'cities', 'province', 'provinces', 'catalogue', 'catalog', 's', 'any',
    'some', 'have', 'has', 'you', 'can', 'my', 'from', 'vakf',
  };
}
