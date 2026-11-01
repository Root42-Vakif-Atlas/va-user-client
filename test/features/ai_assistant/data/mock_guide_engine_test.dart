import 'package:flutter_test/flutter_test.dart';

import '../../../support/mock_api/ai_assistant/mock_guide_engine.dart';
import '../../../support/mock_api/catalog/catalog_fixtures.dart';

void main() {
  final engine = MockGuideEngine(CatalogFixtures.monuments);

  MockGuideAnswer ask(
    String question, {
    String language = 'tr',
    String? context,
  }) => engine.answer(question, language: language, contextMonumentId: context);

  List<String?> types(MockGuideAnswer answer) => [
    for (final action in answer.actions) action['type'] as String?,
  ];

  List<String> sourceIds(MockGuideAnswer answer) => [
    for (final monument in answer.sources) monument.id,
  ];

  group('eser bilgisi (katalogdan)', () {
    test('bani sorusu katalogdaki baniyi ve kaynağı döndürür', () {
      final answer = ask("Süleymaniye Camii'ni kim yaptırdı?");

      expect(answer.text, contains('Kanuni Sultan Süleyman'));
      expect(sourceIds(answer), ['suleymaniye-camii']);
      expect(answer.focusMonumentId, 'suleymaniye-camii');
      expect(types(answer), ['openMonument', 'showOnMap', 'openMemories']);
    });

    test('Türkçe karakter olmadan ve büyük harfle de bulur', () {
      expect(sourceIds(ask('SULEYMANIYE CAMII MIMARI KIM')), [
        'suleymaniye-camii',
      ]);
      expect(ask('SULEYMANIYE CAMII MIMARI KIM').text, contains('Mimar Sinan'));
    });

    test('yapı türü külliye ile camiyi ayırır; tür yoksa hangisi sorulur', () {
      expect(sourceIds(ask("Süleymaniye Külliyesi'ni kim yaptırdı?")), [
        'suleymaniye-kulliyesi',
      ]);
      final answer = ask('Süleymaniye mimarı kim?');
      expect(answer.text, contains('Birden fazla eser'));
      expect(
        sourceIds(answer),
        containsAll(['suleymaniye-camii', 'suleymaniye-kulliyesi']),
      );
    });

    test('İngilizce soruya İngilizce yanıt verir', () {
      final answer = ask('Who built the Süleymaniye Mosque?', language: 'en');

      expect(answer.text, contains('Suleiman the Magnificent'));
      expect(answer.text, contains('Founder'));
    });

    test('konum sorusunda "Haritada göster" ilk eylemdir', () {
      final answer = ask('Selimiye Camii nerede?');

      expect(answer.text, contains('Edirne'));
      expect(types(answer).first, 'showOnMap');
    });

    test('mimar kaydı yoksa uydurmaz', () {
      final answer = ask('Kızlarağası Hanı mimarı kim?');

      expect(answer.text, contains('mimar bilgisi bulunmuyor'));
    });

    test('devam sorusu sohbetteki eseri yanıtlar', () {
      final answer = ask('Mimarı kim?', context: 'selimiye-camii');

      expect(answer.text, contains('Mimar Sinan'));
      expect(sourceIds(answer), ['selimiye-camii']);
    });

    test('aynı ada sahip eserlerde hangisi olduğunu sorar', () {
      final answer = ask('Ulu Cami nerede?');

      expect(answer.text, contains('Birden fazla eser'));
      expect(answer.sources, hasLength(3));
      expect(answer.focusMonumentId, isNull);
    });

    test('il adı belirsizliği çözer', () {
      expect(sourceIds(ask('Bursa Ulu Camii ne zaman yapıldı?')), [
        'bursa-ulu-camii',
      ]);
    });

    test('"Sultan" sözcüğü Sultanhanı ile eşleşmez', () {
      final answer = ask('Yavuz Sultan Selim hangi camiyi yaptırdı?');

      expect(sourceIds(answer), ['gulbahar-hatun-camii']);
    });
  });

  group('listeleme', () {
    test('il ve dönem filtresiyle arama eylemi döner', () {
      final answer = ask("Konya'daki Selçuklu eserleri");

      expect(sourceIds(answer), ['sahip-ata-kulliyesi']);
      expect(answer.text, contains('Sahip Ata'));
    });

    test('tür + il filtresi aramaya aynı filtreyle aktarılır', () {
      final answer = ask("İstanbul'daki camiler");
      final search = answer.actions.firstWhere(
        (action) =>
            action['type'] == 'searchMonuments' ||
            action['type'] == 'openMonument',
      );

      expect(sourceIds(answer), ['suleymaniye-camii']);
      expect(search['type'], 'openMonument');
    });

    test('birden çok sonuçta arama eylemi filtre ve toplamı taşır', () {
      final answer = ask('Osmanlı camileri');
      final search = answer.actions.firstWhere(
        (action) => action['type'] == 'searchMonuments',
      );

      expect(search['categories'], ['mosque']);
      expect(search['periods'], ['ottoman']);
      expect(search['total'], answer.sources.length);
    });

    test('kişiye göre (Mimar Sinan) eserleri bulur', () {
      final answer = ask("Mimar Sinan'ın eserleri");

      // Süleymaniye Külliyesi'nin yapıları da Sinan'ındır; "Mimar Sinan
      // Türbesi" adı kişi sözcükleriyle eşleştiği için eser sorusu sayılmaz.
      final sinan = [
        for (final m in CatalogFixtures.monuments)
          if (m.architect?.tr == 'Mimar Sinan') m.id,
      ];
      expect(sinan, containsAll(['selimiye-camii', 'suleymaniye-camii']));
      expect(answer.text, contains('${sinan.length} eser'));
      expect(answer.sources, hasLength(MockGuideEngine.maxListed));
      expect(sourceIds(answer).every(sinan.contains), isTrue);
      expect(answer.text, contains('Mimar Sinan'));
    });

    test('"diğer eserler" konuşulan eseri listeden çıkarır', () {
      final answer = ask(
        'Sivas ilindeki diğer eserler',
        context: 'divrigi-ulu-camii-ve-darussifasi',
      );

      expect(answer.sources, isEmpty);
      expect(answer.text, contains('bulamadım'));
    });

    test('UNESCO listesindeki eserler', () {
      final answer = ask('UNESCO listesindeki eserler');

      expect(answer.sources, everyElement(isA<MockMonument>()));
      expect(
        answer.sources.every((monument) => monument.isUnescoWorldHeritage),
        isTrue,
      );
      expect(answer.sources, isNotEmpty);
    });
  });

  group('yönlendirme', () {
    test('acil durumda 112 uyarısı ve hasar bildirimi', () {
      final answer = ask('Selimiye Camii yanıyor, yangın var!');

      expect(answer.notice, 'emergency');
      expect(answer.text, contains('112'));
      expect(answer.actions.first, {
        'type': 'reportDamage',
        'monumentId': 'selimiye-camii',
        'monumentName': 'Selimiye Camii',
      });
    });

    test('hasar bildirimi Sivil Koruma formuna yönlendirir', () {
      final answer = ask('Hasar nasıl bildiririm?');

      expect(answer.notice, isNull);
      expect(types(answer), ['reportDamage', 'openSection']);
      expect(answer.actions.last['destination'], 'civilProtection');
    });

    test('"bu eser" önceki eseri hasar formunda seçer', () {
      final answer = ask(
        'Bu eserde çatlak gördüm',
        context: 'sahip-ata-kulliyesi',
      );

      expect(answer.actions.first['monumentId'], 'sahip-ata-kulliyesi');
    });

    test('rota sorusu oluşturucuya yönlendirir', () {
      final answer = ask('Rota nasıl planlarım?');

      expect(answer.actions.first, {
        'type': 'openSection',
        'destination': 'routeBuilder',
      });
    });

    test('sıra optimizasyonunu açıklar', () {
      expect(
        ask('Sırayı optimize et ne yapar?').text,
        contains('ilk durağı başlangıç olarak sabit tutar'),
      );
    });

    test('erişilebilirlik sorusu Erişilebilirlik sayfasına yönlendirir', () {
      final answer = ask('Yazıları nasıl büyütürüm?');

      expect(answer.text, contains('%200'));
      expect(answer.actions.single, {
        'type': 'openSection',
        'destination': 'accessibility',
      });
    });

    test('tema sorusu Ayarlar\'a, karma soru ikisine yönlendirir', () {
      expect(ask('Koyu tema var mı?').actions.single, {
        'type': 'openSection',
        'destination': 'settings',
      });
      expect(
        ask('Koyu tema ve yazı boyutu').actions.map((a) => a['destination']),
        ['accessibility', 'settings'],
      );
    });

    test('anı sorusu eserin Anı Köşesi’ni açar', () {
      final answer = ask('Selimiye Camii anıları');

      expect(types(answer), ['openMemories']);
    });

    test('yakındaki eserler için konumu sunucuya göndermeden haritaya', () {
      final answer = ask('Yakınımdaki eserler');

      expect(answer.actions.single['destination'], 'map');
      expect(answer.text, contains('gönderilmez'));
    });
  });

  test('selamlaşmaya tanıtım ve örnek sorular', () {
    final answer = ask('Merhaba');

    expect(answer.text, contains('Dijital Rehber'));
    expect(answer.suggestions, hasLength(MockGuideEngine.maxSuggestions));
  });

  test('anlaşılamayan soruda uydurmaz, yardım önerir', () {
    final answer = ask('Bugün hava nasıl olacak?');

    expect(answer.text, contains('yanıtlayamadım'));
    expect(answer.sources, isEmpty);
  });

  test('her önerilen soru yanıtlanabilir (geri dönüş yanıtı değildir)', () {
    final pending = [
      for (final question in ask('Merhaba').suggestions) (question, 'tr'),
      for (final question in ask('Hello', language: 'en').suggestions)
        (question, 'en'),
    ];
    final asked = <(String, String)>{};
    while (pending.isNotEmpty && asked.length < 80) {
      final item = pending.removeLast();
      if (!asked.add(item)) {
        continue;
      }
      final (question, language) = item;
      final answer = ask(
        question,
        language: language,
        context: 'selimiye-camii',
      );
      expect(
        answer.text,
        isNot(anyOf(contains('yanıtlayamadım'), contains("couldn't answer"))),
        reason: question,
      );
      pending.addAll([
        for (final suggestion in answer.suggestions) (suggestion, language),
      ]);
    }
    expect(asked.length, greaterThan(10));
  });
}
