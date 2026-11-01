import 'dart:math';

import 'package:vakif_atlas/core/utils/turkish_text.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';

import '../catalog/catalog_fixtures.dart';

/// Mock rehberin bir yanıtı (sunucu yanıtındaki `message` + sohbet bağlamı).
final class MockGuideAnswer {
  const MockGuideAnswer({
    required this.text,
    this.sources = const [],
    this.actions = const [],
    this.suggestions = const [],
    this.notice,
    this.focusMonumentId,
  });

  final String text;
  final List<MockMonument> sources;
  final List<Map<String, Object?>> actions;
  final List<String> suggestions;
  final String? notice;

  /// Sonraki sorularda ("Kim yaptırdı?") başvurulacak eser.
  final String? focusMonumentId;
}

/// Gerçek RAG servisinin yerini tutan, kural tabanlı ve katalog üzerinde
/// arama yapan yanıtlayıcı (yalnızca mock/demo).
///
/// 1. Soru Türkçe harf/aksan katlanarak sözcüklere ayrılır.
/// 2. Niyet anahtar sözcüklerle bulunur (acil durum, hasar, ayarlar, anı,
///    rota, eser bilgisi, listeleme, harita, yardım, selam).
/// 3. Eser, il, tür, dönem ve kişi (bani/mimar) katalogda aranır
///    ("retrieval"); yanıt yalnızca bulunan kayıtların alanlarından kurulur
///    ve kayıtlar kaynak olarak döner.
/// 4. Eser bağlamı sohbette tutulur: "Süleymaniye Camii" sonrası
///    "Mimarı kim?" aynı eseri yanıtlar.
///
/// Gerçek serviste aynı sözleşmeyle LLM + vektör arama çalışır; istemci
/// değişmez.
final class MockGuideEngine {
  MockGuideEngine(this._monuments) {
    final cities = {for (final m in _monuments) TurkishText.fold(m.city)};
    for (final monument in _monuments) {
      _nameTerms[monument.id] = {
        for (final text in [monument.name.tr, monument.name.en])
          for (final token in _tokenize(text))
            if (token.length >= 3 &&
                !_genericNameTokens.contains(token) &&
                !cities.contains(token))
              token,
      };
      _typeTerms[monument.id] = {
        for (final text in [monument.name.tr, monument.name.en])
          for (final token in _tokenize(text))
            if (_genericNameTokens.contains(token)) token,
      };
      _personTerms[monument.id] = [
        for (final person in [monument.founder, ?monument.architect])
          (
            person,
            {
              for (final text in [person.tr, person.en])
                for (final token in _tokenize(text))
                  if (token.length >= 4 &&
                      !_genericPersonTokens.contains(token))
                    token,
            },
          ),
      ];
    }
    _personVocabulary = {
      ..._genericPersonTokens,
      for (final people in _personTerms.values)
        for (final (_, terms) in people) ...terms,
    };
  }

  final List<MockMonument> _monuments;
  final Map<String, Set<String>> _nameTerms = {};

  /// Adın yapı türü sözcükleri ("camii", "mosque", "külliyesi"): eşit
  /// puanlı adaylarda soruda geçen tür öne çıkar.
  final Map<String, Set<String>> _typeTerms = {};

  /// Tüm bani/mimar sözcükleri: adı yalnızca kişi sözcükleriyle eşleşen eser
  /// ("Mimar Sinan Türbesi" ← "Mimar Sinan'ın eserleri") aday sayılmaz.
  late final Set<String> _personVocabulary;

  /// Eser başına bani ve mimar: (ad, ayırt edici sözcükler).
  final Map<String, List<(MockText, Set<String>)>> _personTerms = {};

  /// Listelemede gösterilen en çok eser (kalanı aramada).
  static const int maxListed = 5;
  static const int maxSuggestions = 4;

  MockGuideAnswer answer(
    String question, {
    required String language,
    String? contextMonumentId,
  }) {
    final q = _Query(question);
    final copy = _Copy(language);
    final named = _matchNames(q);
    final context = _monuments
        .where((m) => m.id == contextMonumentId)
        .firstOrNull;
    final deictic = _deictic.matches(q);
    final monument = named.length == 1
        ? named.single
        : (named.isEmpty && deictic ? context : null);

    if (_emergency.matches(q)) {
      return _emergencyAnswer(copy, monument);
    }
    if (_damage.matches(q)) {
      return _damageAnswer(copy, monument);
    }
    if (_settings.matches(q)) {
      return _settingsAnswer(copy, q);
    }
    if (_memories.matches(q)) {
      return _memoriesAnswer(copy, monument ?? context);
    }
    final filter = _Filter.of(q, _monuments);
    if (_route.matches(q)) {
      return _routeAnswer(copy, q, monument, filter);
    }
    if (named.length > 1) {
      return _ambiguousAnswer(copy, named);
    }
    final facet = _Facet.of(q);
    if (monument != null) {
      return _monumentAnswer(copy, monument, facet);
    }
    final people = _matchPeople(q, copy.language);
    if (!filter.isEmpty || people.monuments.isNotEmpty) {
      // "İstanbul'daki diğer eserler": konuşulan eser listeden çıkarılır.
      return _listAnswer(
        copy,
        filter,
        people,
        excludeId: _others.matches(q) ? context?.id : null,
      );
    }
    if (facet != null && context != null) {
      return _monumentAnswer(copy, context, facet);
    }
    if (_map.matches(q)) {
      return _mapAnswer(copy);
    }
    if (_listing.matches(q)) {
      return _overviewAnswer(copy);
    }
    if (_help.matches(q)) {
      return _helpAnswer(copy);
    }
    if (_thanks.matches(q)) {
      return MockGuideAnswer(
        text: copy.t(
          'Rica ederim! Başka bir sorunuz olursa buradayım.',
          "You're welcome! I'm here if you have another question.",
        ),
        suggestions: copy.starters,
      );
    }
    if (_greeting.matches(q)) {
      return MockGuideAnswer(
        text: copy.t(
          "Merhaba! Ben Vakıf Atlas'ın Dijital Rehberiyim. Vakıf eserleri "
              'hakkındaki sorularınızı VGM kataloğuna dayanarak yanıtlar, '
              'sizi rota planlama, Anı Köşesi, hasar bildirimi ve ayarlar '
              'gibi bölümlere yönlendiririm.',
          "Hello! I'm the Vakıf Atlas Digital Guide. I answer your questions "
              'about foundation monuments from the VGM catalogue and take you '
              'to route planning, the Memory Corner, damage reporting and '
              'settings.',
        ),
        suggestions: copy.starters,
      );
    }
    return _fallbackAnswer(copy);
  }

  // ---------------------------------------------------------------------
  // Yanıtlar
  // ---------------------------------------------------------------------

  MockGuideAnswer _emergencyAnswer(_Copy copy, MockMonument? monument) =>
      MockGuideAnswer(
        notice: 'emergency',
        text: copy.t(
          "Can güvenliği tehdit ediliyorsa hemen 112 Acil Çağrı Merkezi'ni "
              'arayın ve bölgeden uzaklaşın. Güvende olduğunuzda durumu '
              "Sivil Koruma'ya bildirerek VGM'nin esere müdahale etmesine "
              'yardımcı olabilirsiniz.',
          'If anyone is in danger, call 112 Emergency right away and move '
              'away from the area. Once you are safe, you can report the '
              'situation to Civil Protection so that VGM can act on the '
              'monument.',
        ),
        sources: [?monument],
        actions: [_reportDamage(copy, monument), _section('civilProtection')],
        focusMonumentId: monument?.id,
      );

  MockGuideAnswer _damageAnswer(_Copy copy, MockMonument? monument) {
    final name = monument?.name.resolve(copy.language);
    return MockGuideAnswer(
      text: [
        copy.t(
          'Bir vakıf eserinde hasar, vandalizm veya tehlike gördüyseniz '
              "Sivil Koruma'ya bildirebilirsiniz. Bildirim altı adımdır: "
              'eser, hasar türü, aciliyet, açıklama ve fotoğraf, isteğe bağlı '
              'konum ve gözden geçirme. Giriş yapmanız gerekir; size bir '
              'kayıt numarası verilir ve süreci "Bildirimlerim"den '
              'izleyebilirsiniz.',
          'If you see damage, vandalism or a hazard at a foundation '
              'monument, report it to Civil Protection. The report has six '
              'steps: monument, damage type, urgency, description and photos, '
              'optional location and review. You need to sign in; you get a '
              'reference number and can follow progress under "My reports".',
        ),
        if (name != null)
          copy.t(
            'Form, $name seçili olarak açılır.',
            'The form opens with $name selected.',
          ),
      ].join('\n\n'),
      sources: [?monument],
      actions: [_reportDamage(copy, monument), _section('civilProtection')],
      suggestions: [
        copy.t(
          'Acil durumda ne yapmalıyım?',
          'What should I do in an emergency?',
        ),
      ],
      focusMonumentId: monument?.id,
    );
  }

  MockGuideAnswer _settingsAnswer(_Copy copy, _Query q) {
    final specific = <String>[
      if (_textSize.matches(q))
        copy.t(
          "Metin boyutunu Erişilebilirlik sayfasından %200'e kadar "
              'büyütebilirsiniz; ekranlar büyük metinde de taşmadan okunur.',
          'You can enlarge text up to 200% on the Accessibility page; '
              'screens stay readable at large sizes.',
        ),
      if (_theme.matches(q))
        copy.t(
          'Açık, koyu veya cihazınızı izleyen temayı Ayarlar\'dan '
              'seçebilirsiniz.',
          'You can choose a light, dark or device-matching theme in '
              'Settings.',
        ),
      if (_contrast.matches(q))
        copy.t(
          'Yüksek kontrast metin ve kenarlıkları en az 7:1 kontrastla '
              'gösterir; Erişilebilirlik sayfasından açabilirsiniz.',
          'High contrast shows text and borders with at least 7:1 '
              'contrast; turn it on from the Accessibility page.',
        ),
      if (_colorVision.matches(q))
        copy.t(
          'Renk görme desteği protanopi, döteranopi ve tritanopi için '
              'renkleri ayırt edilebilir hale getirir; haritaya da uygulanır.',
          'Colour vision support makes colours distinguishable for '
              'protanopia, deuteranopia and tritanopia, including the map.',
        ),
      if (_motion.matches(q))
        copy.t(
          'Hareketi azalt animasyonları kapatır; titreşimi de ayrıca '
              'kapatabilirsiniz.',
          'Reduce motion turns off animations; you can also turn off '
              'vibration separately.',
        ),
      if (_language.matches(q))
        copy.t(
          'Uygulama dilini Türkçe veya İngilizce olarak değiştirebilirsiniz; '
              'eser bilgileri de seçtiğiniz dilde gelir.',
          'You can switch the app language between Turkish and English; '
              'monument information follows your choice.',
        ),
    ];
    // Erişilebilirlik tercihlerinin tek yapılandırma noktası Erişilebilirlik
    // sayfasıdır; tema ve dil Ayarlar'dadır (sunucu `GuideEngine` ile aynı).
    final accessibility = _accessibility.matches(q);
    final settings =
        _theme.matches(q) || _language.matches(q) || !accessibility;
    return MockGuideAnswer(
      text: [
        ...specific,
        copy.t(
          "Ayarlar'a ve Erişilebilirlik'e haritadaki hesap görselinden veya "
              'diğer sekmelerin başlığındaki hesap düğmesinden '
              'ulaşabilirsiniz.',
          'You can reach Settings and Accessibility from the account '
              'picture on the map or the account button in other tabs.',
        ),
      ].join('\n\n'),
      actions: [
        if (accessibility) _section('accessibility'),
        if (settings) _section('settings'),
      ],
      suggestions: [
        if (!_textSize.matches(q))
          copy.t('Yazıları nasıl büyütürüm?', 'How do I make text larger?'),
        if (!_theme.matches(q))
          copy.t('Koyu tema var mı?', 'Is there a dark theme?'),
        if (!_colorVision.matches(q))
          copy.t('Renk körlüğü desteği', 'Colour blindness support'),
      ].take(2).toList(),
    );
  }

  MockGuideAnswer _memoriesAnswer(_Copy copy, MockMonument? monument) {
    if (monument == null) {
      final examples = _monuments.take(2).toList();
      return MockGuideAnswer(
        text: copy.t(
          'Anı Köşesi her eserin sayfasındadır: ziyaretçiler fotoğraf ve '
              'notlarını paylaşır, anılar ziyaret tarihine göre bir zaman '
              'çizelgesinde sıralanır. Okumak herkese açıktır; paylaşmak '
              'için giriş yapmanız gerekir. Hangi eserin anılarını görmek '
              'istersiniz?',
          'Every monument page has a Memory Corner where visitors share '
              'photos and notes, ordered on a timeline by visit date. '
              'Anyone can read them; you need to sign in to share. Which '
              "monument's memories would you like to see?",
        ),
        actions: [_search(total: _monuments.length)],
        suggestions: [
          for (final example in examples)
            copy.t(
              '${example.name.tr} anıları',
              'Memories of ${example.name.en}',
            ),
        ],
      );
    }
    final name = monument.name.resolve(copy.language);
    return MockGuideAnswer(
      text: copy.t(
        '$name için paylaşılan anıları Anı Köşesi\'nde, ziyaret tarihine '
            'göre sıralı bir zaman çizelgesinde görebilirsiniz. Kendi '
            'anınızı paylaşmak için giriş yapmanız gerekir.',
        'Memories shared for $name are in its Memory Corner, on a timeline '
            'ordered by visit date. Sign in to share your own.',
      ),
      sources: [monument],
      actions: [_monumentAction('openMemories', copy, monument)],
      suggestions: [
        copy.t('Kim yaptırdı?', 'Who built it?'),
        copy.t('Nerede?', 'Where is it?'),
      ],
      focusMonumentId: monument.id,
    );
  }

  MockGuideAnswer _routeAnswer(
    _Copy copy,
    _Query q,
    MockMonument? monument,
    _Filter filter,
  ) {
    if (_optimize.matches(q)) {
      return MockGuideAnswer(
        text: copy.t(
          '"Sırayı optimize et" ilk durağı başlangıç olarak sabit tutar ve '
              'diğer durakları toplam kuş uçuşu mesafe en kısa olacak '
              'şekilde yeniden sıralar. Kaydetmeden önce sonucu görür, '
              'durakları sürükleyerek yine değiştirebilirsiniz.',
          '"Optimise order" keeps the first stop as the start and reorders '
              'the others for the shortest straight-line distance. You see '
              'the result before saving and can still drag stops around.',
        ),
        actions: [_section('routeBuilder')],
        suggestions: [
          copy.t(
            'Rota süresi nasıl hesaplanır?',
            'How is the route duration calculated?',
          ),
        ],
      );
    }
    final intro = copy.t(
      'Rota planlayıcıyla 2–10 eserlik bir gezi rotası oluşturabilirsiniz. '
          'Eserleri seçip sırayı optimize edebilirsiniz; süre karayolu '
          'yolculuğu, ziyaret ve mola süreleri dahil hesaplanır. Rotalarınız '
          'giriş yapmadan da cihazınızda saklanır ve PDF olarak '
          'paylaşılabilir.',
      'The route planner builds a trip of 2–10 monuments. Pick monuments '
          'and optimise the order; the duration includes road travel, visit '
          'and break times. Routes are kept on your device without signing '
          'in and can be shared as PDF.',
    );
    if (monument != null) {
      final name = monument.name.resolve(copy.language);
      return MockGuideAnswer(
        text: [
          intro,
          copy.t(
            '$name eserini eklemek için eser sayfasındaki "Rotaya ekle" '
                'butonunu kullanın.',
            'To add $name, use "Add to route" on its page.',
          ),
        ].join('\n\n'),
        sources: [monument],
        actions: [
          _monumentAction('openMonument', copy, monument),
          _section('routeBuilder'),
        ],
        focusMonumentId: monument.id,
      );
    }
    final matches = filter.isEmpty
        ? <MockMonument>[]
        : filter.apply(_monuments);
    return MockGuideAnswer(
      text: [
        intro,
        if (!filter.isEmpty)
          matches.isEmpty
              ? copy.t(
                  'Katalogda bu ölçütlere uyan eser bulamadım '
                      '(${filter.describe(copy)}).',
                  'I found no monuments matching these criteria '
                      '(${filter.describe(copy)}).',
                )
              : '${copy.t('Rotanız için seçebileceğiniz eserler', 'Monuments you could add')} '
                    '(${filter.describe(copy)}):\n'
                    '${_bullets(copy, matches)}',
      ].join('\n\n'),
      sources: matches.take(maxListed).toList(),
      actions: [
        _section('routeBuilder'),
        if (matches.isNotEmpty)
          _search(filter: filter, total: matches.length)
        else
          _section('routePlanner'),
      ],
      suggestions: [
        copy.t('Sırayı optimize et ne yapar?', 'What does optimise order do?'),
        copy.t("Konya'daki Selçuklu eserleri", 'Seljuk monuments in Konya'),
      ],
    );
  }

  MockGuideAnswer _ambiguousAnswer(_Copy copy, List<MockMonument> matches) =>
      MockGuideAnswer(
        text: copy.t(
          'Birden fazla eser buldum. Hangisini kastettiniz?\n'
              '${_bullets(copy, matches)}',
          'I found more than one monument. Which one do you mean?\n'
              '${_bullets(copy, matches)}',
        ),
        sources: matches.take(maxListed).toList(),
        actions: [
          for (final monument in matches.take(3))
            _monumentAction('openMonument', copy, monument),
        ],
        suggestions: [
          for (final monument in matches.take(maxSuggestions))
            monument.name.resolve(copy.language),
        ],
      );

  MockGuideAnswer _monumentAnswer(
    _Copy copy,
    MockMonument monument,
    _Facet? facet,
  ) {
    final language = copy.language;
    final name = monument.name.resolve(language);
    final place = '${monument.district}, ${monument.city}';
    final date = monument.constructionDate.resolve(language);
    final founder = monument.founder.resolve(language);
    final architect = monument.architect?.resolve(language);
    final founderLine = '${copy.t('Banisi (yaptıran)', 'Founder')}: $founder';
    final dateLine = '${copy.t('Yapım tarihi', 'Built')}: $date';
    final architectLine = architect == null
        ? copy.t(
            'Katalogda mimar bilgisi bulunmuyor.',
            'The catalogue has no architect on record.',
          )
        : '${copy.t('Mimarı', 'Architect')}: $architect';
    final body = switch (facet) {
      _Facet.founder => [founderLine, dateLine],
      _Facet.architect => [architectLine, founderLine],
      _Facet.date => [dateLine, founderLine],
      _Facet.location => [
        '${copy.t('Konum', 'Location')}: $place',
        '${copy.t('Adres', 'Address')}: ${monument.address}',
      ],
      _Facet.period => [
        '${copy.t('Dönem', 'Period')}: ${copy.period(monument.period)}',
        dateLine,
      ],
      _Facet.unesco => [
        if (monument.isUnescoWorldHeritage)
          copy.t(
            "$name, UNESCO Dünya Mirası Listesi'nde yer alır.",
            '$name is on the UNESCO World Heritage List.',
          )
        else
          copy.t(
            "$name, UNESCO Dünya Mirası Listesi'nde yer almıyor.",
            '$name is not on the UNESCO World Heritage List.',
          ),
      ],
      _Facet.history => [_firstSentences(monument.history.resolve(language))],
      null => [
        monument.shortDescription.resolve(language),
        dateLine,
        founderLine,
        if (architect != null) architectLine,
      ],
    };
    final others = _monuments
        .where((m) => m.city == monument.city && m.id != monument.id)
        .length;
    return MockGuideAnswer(
      text: ['$name ($place)', ...body].join('\n'),
      sources: [monument],
      actions: [
        if (facet == _Facet.location) ...[
          _monumentAction('showOnMap', copy, monument),
          _monumentAction('openMonument', copy, monument),
        ] else ...[
          _monumentAction('openMonument', copy, monument),
          _monumentAction('showOnMap', copy, monument),
        ],
        _monumentAction('openMemories', copy, monument),
      ],
      suggestions: [
        if (facet != _Facet.founder) copy.t('Kim yaptırdı?', 'Who built it?'),
        if (facet != _Facet.architect)
          copy.t('Mimarı kim?', 'Who was the architect?'),
        if (facet != _Facet.date && facet != null)
          copy.t('Ne zaman yapıldı?', 'When was it built?'),
        if (facet != _Facet.history)
          copy.t('Tarihçesini anlat', 'Tell me its history'),
        if (others > 0)
          copy.t(
            '${monument.city} ilindeki diğer eserler',
            'Other monuments in ${monument.city}',
          ),
      ].take(3).toList(),
      focusMonumentId: monument.id,
    );
  }

  MockGuideAnswer _listAnswer(
    _Copy copy,
    _Filter filter,
    _PeopleMatch people, {
    String? excludeId,
  }) {
    final byPerson = {for (final m in people.monuments) m.id};
    final matches = [
      for (final m in filter.apply(_monuments))
        if (m.id != excludeId && (byPerson.isEmpty || byPerson.contains(m.id)))
          m,
    ];
    final criteria = [
      ...people.names,
      if (!filter.isEmpty) filter.describe(copy),
    ].join(' · ');
    if (matches.isEmpty) {
      return MockGuideAnswer(
        text: copy.t(
          'Katalogda bu ölçütlere uyan eser bulamadım ($criteria). Farklı '
              'bir il, yapı türü veya dönem deneyebilirsiniz.',
          'I found no monuments in the catalogue matching these criteria '
              '($criteria). Try another province, type or period.',
        ),
        actions: [_search(total: _monuments.length)],
        suggestions: [
          for (final city in _cities.take(2))
            copy.t('$city ilindeki eserler', 'Monuments in $city'),
        ],
      );
    }
    final single = matches.length == 1 ? matches.single : null;
    // Kişi ölçütü arama filtresinde yoktur; o durumda eserler tek tek açılır.
    final searchable = people.monuments.isEmpty && !filter.unesco;
    return MockGuideAnswer(
      text: copy.t(
        '$criteria için katalogda ${matches.length} eser buldum:\n'
            '${_bullets(copy, matches)}',
        'I found ${matches.length} monuments in the catalogue for '
            '$criteria:\n${_bullets(copy, matches)}',
      ),
      sources: matches.take(maxListed).toList(),
      actions: [
        if (single != null) ...[
          _monumentAction('openMonument', copy, single),
          _monumentAction('showOnMap', copy, single),
        ] else if (searchable)
          _search(filter: filter, total: matches.length)
        else
          for (final monument in matches.take(3))
            _monumentAction('openMonument', copy, monument),
        _section('routeBuilder'),
      ],
      suggestions: [
        for (final monument in matches.take(2))
          copy.t(
            '${monument.name.tr} hakkında bilgi',
            'About ${monument.name.en}',
          ),
      ],
      focusMonumentId: single?.id,
    );
  }

  MockGuideAnswer _overviewAnswer(_Copy copy) {
    final cities = _cities.join(', ');
    return MockGuideAnswer(
      text: copy.t(
        'Katalogda şu anda ${_monuments.length} vakıf eseri var. İller: '
            '$cities. İl, yapı türü (cami, han, külliye…) veya döneme '
            '(Selçuklu, Beylikler, Osmanlı) göre sorabilirsiniz.',
        'The catalogue currently has ${_monuments.length} foundation '
            'monuments. Provinces: $cities. You can ask by province, type '
            '(mosque, inn, complex…) or period (Seljuk, Beylik, Ottoman).',
      ),
      actions: [
        _search(total: _monuments.length),
        _section('map'),
      ],
      suggestions: [
        copy.t("İstanbul'daki camiler", 'Mosques in İstanbul'),
        copy.t('UNESCO listesindeki eserler', 'UNESCO-listed monuments'),
      ],
    );
  }

  MockGuideAnswer _mapAnswer(_Copy copy) => MockGuideAnswer(
    text: copy.t(
      'Haritada tüm vakıf eserlerini görebilirsiniz. Yakınınızdaki eserler '
          'için haritadaki konum butonuna dokunun; konumunuz yalnızca '
          "cihazınızda kullanılır, Rehber'e veya sunucuya gönderilmez.",
      'The map shows all foundation monuments. For monuments near you, tap '
          'the location button on the map; your location is used only on '
          'your device and is never sent to the Guide or the server.',
    ),
    actions: [_section('map')],
    suggestions: [copy.t('Eserleri listele', 'List the monuments')],
  );

  MockGuideAnswer _helpAnswer(_Copy copy) => MockGuideAnswer(
    text: copy.t(
      'Size şu konularda yardımcı olabilirim:\n'
          '• Bir eser hakkında bilgi (bani, mimar, tarih, konum)\n'
          '• İle, yapı türüne veya döneme göre eser bulma\n'
          '• Rota planlama\n'
          '• Anıları görme ve paylaşma\n'
          '• Hasar bildirme\n'
          '• Tema, metin boyutu ve erişilebilirlik ayarları',
      'I can help you with:\n'
          '• Information about a monument (founder, architect, date, '
          'location)\n'
          '• Finding monuments by province, type or period\n'
          '• Planning a route\n'
          '• Reading and sharing memories\n'
          '• Reporting damage\n'
          '• Theme, text size and accessibility settings',
    ),
    suggestions: copy.starters,
  );

  MockGuideAnswer _fallbackAnswer(_Copy copy) => MockGuideAnswer(
    text: copy.t(
      'Bu soruyu yanıtlayamadım. Vakıf eserleri, rota planlama, Anı Köşesi, '
          'hasar bildirimi ve uygulama ayarları hakkında yardımcı '
          'olabilirim. Sorunuzu bir eser, il veya yapı türüyle yeniden '
          'yazabilirsiniz.',
      "I couldn't answer that. I can help with foundation monuments, route "
          'planning, the Memory Corner, damage reports and app settings. '
          'Try rephrasing with a monument, province or building type.',
    ),
    actions: [_search(total: _monuments.length)],
    suggestions: copy.starters,
  );

  // ---------------------------------------------------------------------
  // Eylemler
  // ---------------------------------------------------------------------

  Map<String, Object?> _monumentAction(
    String type,
    _Copy copy,
    MockMonument monument,
  ) => {
    'type': type,
    'monumentId': monument.id,
    'monumentName': monument.name.resolve(copy.language),
  };

  Map<String, Object?> _reportDamage(_Copy copy, MockMonument? monument) =>
      monument == null
      ? {'type': 'reportDamage'}
      : _monumentAction('reportDamage', copy, monument);

  static Map<String, Object?> _section(String destination) => {
    'type': 'openSection',
    'destination': destination,
  };

  static Map<String, Object?> _search({
    required int total,
    _Filter filter = const _Filter(),
  }) => {
    'type': 'searchMonuments',
    'categories': [for (final c in filter.categories) c.name],
    'periods': [for (final p in filter.periods) p.name],
    'cities': filter.cities.toList(),
    'total': total,
  };

  // ---------------------------------------------------------------------
  // Arama (retrieval)
  // ---------------------------------------------------------------------

  /// Adı soruda geçen eserler; eşit puanlılarda il/ilçe, sonra yapı türü
  /// eşleşmesi öne geçer ("Süleymaniye Camii" külliyeyi değil camiyi bulur).
  /// Eşleşen sözcüklerinin tümü kişi adı olan eser aday değildir. Tek
  /// kazanan yoksa tüm adaylar döner.
  List<MockMonument> _matchNames(_Query q) {
    final scores = <MockMonument, double>{};
    for (final monument in _monuments) {
      final terms = _nameTerms[monument.id]!;
      final matched = [
        for (final term in terms)
          if (q.matchesTerm(term)) term,
      ];
      if (matched.isEmpty || matched.every(_personVocabulary.contains)) {
        continue;
      }
      final place =
          q.matchesTerm(TurkishText.fold(monument.city)) ||
          q.matchesTerm(TurkishText.fold(monument.district));
      final type = _typeTerms[monument.id]!.any(q.matchesTerm);
      scores[monument] =
          matched.length + (place ? 0.5 : 0) + (type ? 0.125 : 0);
    }
    if (scores.isEmpty) {
      return const [];
    }
    final best = scores.values.reduce((a, b) => a > b ? a : b);
    return [
      for (final MapEntry(:key, :value) in scores.entries)
        if (value == best) key,
    ];
  }

  /// Banisi veya mimarı soruda geçen eserler ("Mimar Sinan'ın eserleri")
  /// ve eşleşen kişilerin adları.
  _PeopleMatch _matchPeople(_Query q, String language) {
    // En çok sözcüğü eşleşen kişiler: "Yavuz Sultan Selim" II. Selim'i
    // değil Yavuz'u bulur.
    final scored = <(MockMonument, MockText, int)>[];
    for (final monument in _monuments) {
      for (final (person, terms) in _personTerms[monument.id]!) {
        final score = terms.where(q.matchesTerm).length;
        if (score > 0) {
          scored.add((monument, person, score));
        }
      }
    }
    if (scored.isEmpty) {
      return const _PeopleMatch([], []);
    }
    final best = scored.map((entry) => entry.$3).reduce(max);
    final monuments = <MockMonument>[];
    final names = <String>{};
    for (final (monument, person, score) in scored) {
      if (score == best) {
        names.add(person.resolve(language));
        if (monuments.lastOrNull != monument) {
          monuments.add(monument);
        }
      }
    }
    return _PeopleMatch(monuments, names.toList());
  }

  List<String> get _cities =>
      ({for (final m in _monuments) m.city}.toList()
        ..sort(TurkishText.compare));

  String _bullets(_Copy copy, List<MockMonument> monuments) {
    final lines = [
      for (final monument in monuments.take(maxListed))
        '• ${monument.name.resolve(copy.language)} (${monument.city})',
    ];
    final rest = monuments.length - maxListed;
    if (rest > 0) {
      lines.add(copy.t('…ve $rest eser daha', '…and $rest more'));
    }
    return lines.join('\n');
  }

  static String _firstSentences(String text, {int count = 2}) {
    final sentences = RegExp(r'[^.!?]+[.!?]+').allMatches(text).toList();
    if (sentences.length <= count) {
      return text.trim();
    }
    return sentences.take(count).map((m) => m.group(0)!.trim()).join(' ');
  }

  static List<String> _tokenize(String text) =>
      TurkishText.fold(text)
          .replaceAll(RegExp('[^a-z0-9]+'), ' ')
          .split(' ')
          .where((token) => token.isNotEmpty)
          .toList();

  /// Ad eşleşmesinde ayırt edici olmayan sözcükler (yapı türü, bağlaç).
  static const Set<String> _genericNameTokens = {
    'cami',
    'camii',
    'mosque',
    'han',
    'hani',
    'inn',
    'kulliyesi',
    'complex',
    'kervansarayi',
    'caravanserai',
    'and',
    'the',
    'great',
    'grand',
    'hospital',
  };

  static const Set<String> _genericPersonTokens = {
    'sultan',
    'sultani',
    'mimar',
    'buyuk',
    'great',
    'onarimi',
    'restoration',
    'olarak',
    'zaviye',
    'dervish',
    'lodge',
    'the',
    'and',
    'magnificent',
    // Dönem adları kişi adı değildir ("Büyük Selçuklu Sultanı").
    'selcuklu',
    'seljuk',
    'osmanli',
    'ottoman',
  };

  // ---------------------------------------------------------------------
  // Niyet sözlükleri (katlanmış: ç→c, ğ→g, ı→i, ö→o, ş→s, ü→u)
  // ---------------------------------------------------------------------

  static const _Keywords _emergency = _Keywords(
    words: {'acil', 'fire', '112', 'alev'},
    prefixes: {
      'yangin',
      'yaniyor',
      'yandi',
      'yanmis',
      'cokuyor',
      'coktu',
      'cokecek',
      'yikiliyor',
      'yikildi',
      'deprem',
      'emergenc',
      'collaps',
      'earthquake',
      'burning',
    },
  );

  static const _Keywords _damage = _Keywords(
    words: {'bildir', 'report', 'ihbar', 'kirik', 'broken'},
    prefixes: {
      'hasar',
      'catlak',
      'catlam',
      'yikik',
      'vandal',
      'tahrip',
      'sikayet',
      'bildir',
      'damage',
      'crack',
      'graffit',
      'stolen',
      'calin',
    },
    phrases: {'sivil koruma', 'civil protection'},
  );

  static const _Keywords _textSize = _Keywords(
    words: {'font'},
    prefixes: {'buyut', 'kucult', 'enlarge'},
    phrases: {
      'yazi boyut',
      'metin boyut',
      'yazilari buyut',
      'yazi buyut',
      'text size',
      'font size',
      'larger text',
      'text larger',
    },
  );

  static const _Keywords _theme = _Keywords(
    words: {'dark', 'koyu', 'karanlik'},
    prefixes: {'tema', 'theme'},
  );

  static const _Keywords _contrast = _Keywords(
    prefixes: {'kontrast', 'contrast'},
  );

  static const _Keywords _colorVision = _Keywords(
    prefixes: {
      'daltoni',
      'colorblind',
      'colourblind',
      'protanop',
      'deuteranop',
    },
    phrases: {
      'renk kor',
      'renk gorme',
      'color blind',
      'colour blind',
      'color vision',
      'colour vision',
    },
  );

  static const _Keywords _motion = _Keywords(
    prefixes: {'titresim', 'vibrat', 'animasyon', 'animation'},
    phrases: {'hareketi azalt', 'reduce motion'},
  );

  static const _Keywords _language = _Keywords(
    words: {'dil', 'dili', 'language', 'ingilizce', 'english', 'turkish'},
  );

  /// Erişilebilirlik sayfasının konuları.
  static final _Keywords _accessibility = _Keywords.union([
    const _Keywords(prefixes: {'erisilebil', 'accessib'}),
    _textSize,
    _contrast,
    _colorVision,
    _motion,
  ]);

  static final _Keywords _settings = _Keywords.union([
    const _Keywords(prefixes: {'ayar', 'setting'}),
    _accessibility,
    _theme,
    _language,
  ]);

  static const _Keywords _memories = _Keywords(
    words: {
      'ani',
      'anilar',
      'anilari',
      'anisi',
      'aniyi',
      'anim',
      'anilarim',
      'anilarini',
      'aninizi',
      'memory',
      'memories',
    },
    prefixes: {'hatira', 'memor'},
  );

  static const _Keywords _route = _Keywords(
    words: {'plan', 'tur', 'tour', 'trip', 'gezmek', 'gezi'},
    prefixes: {
      'rota',
      'guzergah',
      'itinerar',
      'route',
      'planla',
      'optimiz',
      'optimis',
    },
  );

  static const _Keywords _optimize = _Keywords(
    prefixes: {'optimiz', 'optimis', 'sirala'},
    phrases: {'en kisa', 'shortest'},
  );

  /// "Diğer eserler": konuşulan eser hariç.
  static const _Keywords _others = _Keywords(
    words: {'diger', 'baska', 'other', 'another', 'more'},
  );

  static const _Keywords _listing = _Keywords(
    words: {
      'list',
      'listele',
      'hangi',
      'neler',
      'nereler',
      'kac',
      'tumu',
      'hepsi',
      'all',
      'sites',
      'places',
    },
    prefixes: {'eser', 'yapilar', 'monument', 'gezilecek', 'gorulecek'},
    phrases: {'how many'},
  );

  static const _Keywords _map = _Keywords(
    words: {'near', 'around', 'map', 'konum', 'location', 'nearby'},
    prefixes: {'yakin', 'cevrem', 'etrafim', 'harita', 'konumum'},
  );

  static const _Keywords _help = _Keywords(
    words: {'yardim', 'help', 'kimsin'},
    phrases: {'ne yapabilir', 'neler yapabilir', 'what can you', 'who are you'},
  );

  static const _Keywords _thanks = _Keywords(
    words: {'thanks', 'thx', 'eyv', 'sagol', 'sagolun'},
    prefixes: {'tesekkur', 'thank'},
  );

  static const _Keywords _greeting = _Keywords(
    words: {
      'merhaba',
      'merhabalar',
      'selam',
      'selamlar',
      'hello',
      'hi',
      'hey',
      'gunaydin',
      'mrb',
      'slm',
    },
    phrases: {'iyi gunler', 'iyi aksamlar', 'good morning'},
  );

  /// Önceki esere gönderme ("bu eserde", "burası").
  static const _Keywords _deictic = _Keywords(
    words: {'bu', 'bura', 'burasi', 'burada', 'orada', 'this', 'here', 'it'},
  );
}

final class _PeopleMatch {
  const _PeopleMatch(this.monuments, this.names);

  final List<MockMonument> monuments;

  /// Eşleşen bani / mimar adları (içerik dilinde).
  final List<String> names;
}

/// Eser hakkında sorulan bilgi.
enum _Facet {
  founder,
  architect,
  date,
  location,
  period,
  unesco,
  history;

  static _Facet? of(_Query q) {
    if (_architectKeys.matches(q)) {
      return architect;
    }
    if (_founderKeys.matches(q)) {
      return founder;
    }
    if (_unescoKeys.matches(q)) {
      return unesco;
    }
    if (_historyKeys.matches(q)) {
      return history;
    }
    if (_locationKeys.matches(q)) {
      return location;
    }
    if (_periodKeys.matches(q)) {
      return period;
    }
    if (_dateKeys.matches(q)) {
      return date;
    }
    return null;
  }

  static const _Keywords _architectKeys = _Keywords(
    prefixes: {'mimar', 'architect'},
  );
  static const _Keywords _founderKeys = _Keywords(
    words: {'kim', 'kimin', 'who', 'bani', 'banisi', 'kurucu', 'kurucusu'},
    prefixes: {'yaptir', 'founder', 'commission'},
  );
  static const _Keywords _unescoKeys = _Keywords(
    prefixes: {'unesco'},
    phrases: {'dunya miras', 'world herit'},
  );
  static const _Keywords _historyKeys = _Keywords(
    words: {'history', 'story', 'gecmisi'},
    prefixes: {'tarihce', 'hikaye', 'anlat'},
  );
  static const _Keywords _locationKeys = _Keywords(
    words: {'nerede', 'nerde', 'where', 'adres', 'adresi', 'address'},
    prefixes: {'haritada'},
    phrases: {'nasil gid', 'how do i get', 'how to get'},
  );
  static const _Keywords _periodKeys = _Keywords(
    words: {'era'},
    prefixes: {'donem', 'period'},
  );
  static const _Keywords _dateKeys = _Keywords(
    words: {
      'zaman',
      'when',
      'year',
      'yil',
      'yili',
      'date',
      'tarih',
      'tarihinde',
      'century',
      'yuzyil',
    },
    prefixes: {'insa', 'yapim', 'yapil', 'built', 'construct'},
  );
}

/// Soruda geçen il, yapı türü, dönem ve UNESCO ölçütleri.
final class _Filter {
  const _Filter({
    this.categories = const {},
    this.periods = const {},
    this.cities = const {},
    this.unesco = false,
  });

  factory _Filter.of(_Query q, List<MockMonument> monuments) => _Filter(
    categories: {
      for (final MapEntry(:key, :value) in _categoryKeys.entries)
        if (value.matches(q)) key,
    },
    periods: {
      for (final MapEntry(:key, :value) in _periodKeys.entries)
        if (value.matches(q)) key,
    },
    cities: {
      for (final city in {for (final m in monuments) m.city})
        if (q.matchesTerm(TurkishText.fold(city))) city,
    },
    unesco: _Facet._unescoKeys.matches(q),
  );

  final Set<MonumentCategory> categories;
  final Set<HistoricalPeriod> periods;
  final Set<String> cities;
  final bool unesco;

  bool get isEmpty =>
      categories.isEmpty && periods.isEmpty && cities.isEmpty && !unesco;

  List<MockMonument> apply(List<MockMonument> monuments) => [
    for (final m in monuments)
      if ((categories.isEmpty || categories.contains(m.category)) &&
          (periods.isEmpty || periods.contains(m.period)) &&
          (cities.isEmpty || cities.contains(m.city)) &&
          (!unesco || m.isUnescoWorldHeritage))
        m,
  ]..sort((a, b) => TurkishText.compare(a.name.tr, b.name.tr));

  String describe(_Copy copy) => [
    ...cities,
    for (final period in periods) copy.period(period),
    for (final category in categories) copy.category(category),
    if (unesco) 'UNESCO',
  ].join(' · ');

  static const Map<MonumentCategory, _Keywords> _categoryKeys = {
    MonumentCategory.mosque: _Keywords(
      words: {'mescit'},
      prefixes: {'cami', 'mosque'},
    ),
    MonumentCategory.complex: _Keywords(prefixes: {'kulliye', 'complex'}),
    MonumentCategory.madrasa: _Keywords(
      prefixes: {'medrese', 'madrasa', 'madrassa'},
    ),
    MonumentCategory.inn: _Keywords(
      words: {'han', 'hani', 'hanlar', 'hanlari', 'inn', 'inns'},
    ),
    MonumentCategory.caravanserai: _Keywords(
      prefixes: {'kervansaray', 'caravanserai', 'caravansar'},
    ),
    MonumentCategory.bath: _Keywords(prefixes: {'hamam', 'bath', 'hammam'}),
    MonumentCategory.tomb: _Keywords(prefixes: {'turbe', 'tomb', 'mausole'}),
    MonumentCategory.hospital: _Keywords(
      prefixes: {'darussifa', 'sifahane', 'hospital'},
    ),
    MonumentCategory.imaret: _Keywords(
      prefixes: {'imaret', 'daruzziyafe', 'asevi'},
    ),
    MonumentCategory.fountain: _Keywords(
      words: {'sebil'},
      prefixes: {'cesme', 'fountain'},
    ),
  };

  static const Map<HistoricalPeriod, _Keywords> _periodKeys = {
    HistoricalPeriod.seljuk: _Keywords(
      prefixes: {'selcuk', 'seljuk', 'seljuq'},
    ),
    HistoricalPeriod.beylik: _Keywords(
      prefixes: {'beylik', 'principalit', 'mengucek'},
    ),
    HistoricalPeriod.ottoman: _Keywords(prefixes: {'osmanli', 'ottoman'}),
  };
}

/// Katlanmış, sözcüklere ayrılmış soru.
final class _Query {
  _Query(String question) : this._(MockGuideEngine._tokenize(question));

  _Query._(this.tokens) : _padded = ' ${tokens.join(' ')} ';

  final List<String> tokens;
  final String _padded;

  /// Sözcük [term] ile aynı, [term]'ün çekimli hali ("süleymaniye'yi") veya
  /// yarım yazılmış hali ("süleymani"; en az 5 harf ve sözcüğün dörtte
  /// üçü — "Sultan" "Sultanhanı" ile eşleşmez).
  bool matchesTerm(String term) => tokens.any(
    (token) =>
        token == term ||
        (term.length >= 4 && token.startsWith(term)) ||
        (token.length >= 5 &&
            token.length * 4 >= term.length * 3 &&
            term.startsWith(token)),
  );

  bool hasPhrase(String phrase) => _padded.contains(' $phrase');
}

final class _Keywords {
  const _Keywords({
    this.words = const {},
    this.prefixes = const {},
    this.phrases = const {},
  });

  _Keywords.union(List<_Keywords> parts)
    : words = {for (final part in parts) ...part.words},
      prefixes = {for (final part in parts) ...part.prefixes},
      phrases = {for (final part in parts) ...part.phrases};

  /// Tam eşleşmesi gereken kısa sözcükler.
  final Set<String> words;

  /// Çekim eklerini de kapsayan sözcük başları.
  final Set<String> prefixes;

  /// Birden çok sözcükten oluşan ifadeler.
  final Set<String> phrases;

  bool matches(_Query q) =>
      q.tokens.any(
        (token) => words.contains(token) || prefixes.any(token.startsWith),
      ) ||
      phrases.any(q.hasPhrase);
}

/// Yanıt metinleri (sunucu içerik dilinde üretir).
final class _Copy {
  _Copy(String language) : language = language == 'en' ? 'en' : 'tr';

  final String language;

  String t(String tr, String en) => language == 'en' ? en : tr;

  List<String> get starters => [
    t(
      "Süleymaniye Camii'ni kim yaptırdı?",
      'Who built the Süleymaniye Mosque?',
    ),
    t("Konya'daki Selçuklu eserleri", 'Seljuk monuments in Konya'),
    t('Rota nasıl planlarım?', 'How do I plan a route?'),
    t('Hasar nasıl bildiririm?', 'How do I report damage?'),
  ];

  String category(MonumentCategory category) => switch (category) {
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

  String period(HistoricalPeriod period) => switch (period) {
    HistoricalPeriod.seljuk => t('Selçuklu', 'Seljuk'),
    HistoricalPeriod.beylik => t('Beylikler', 'Beylik'),
    HistoricalPeriod.ottoman => t('Osmanlı', 'Ottoman'),
    HistoricalPeriod.other => t('Diğer', 'Other'),
  };
}
