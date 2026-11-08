import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/catalog_guide/catalog_guide.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';

import 'fake_guide_catalog.dart';

void main() {
  late FakeGuideCatalog catalog;
  late CatalogGuide guide;

  setUp(() {
    catalog = FakeGuideCatalog();
    guide = CatalogGuide.withClock(catalog, () => DateTime.utc(2026, 11, 8));
  });

  Future<CatalogGuideAnswer?> ask(
    String question, {
    String language = 'tr',
    GuideMonumentRef? focus,
  }) async {
    final result = await guide.answer(
      question,
      languageCode: language,
      focus: focus,
    );
    return switch (result) {
      null => null,
      Right(:final value) => value,
      Left(:final value) => fail('Beklenmeyen hata: $value'),
    };
  }

  group('katalogda olmayan', () {
    test('eser: açıkça söylenir, katalog kapsamı verilir', () async {
      final answer = await ask("Süleymaniye Camii'ni kim yaptırdı?");

      expect(
        answer!.message.text,
        startsWith(
          '“Süleymaniye Camii” adlı bir eser kataloğumuzda '
          'bulunmuyor.',
        ),
      );
      expect(answer.message.text, contains('Bursa (5)'));
      expect(answer.message.text, contains('İstanbul (1)'));
      expect(answer.message.text, contains('toplam 10 vakıf eseri'));
      expect(answer.message.sources, isEmpty);
      expect(answer.focus, isNull);
    });

    test('il: katalogda eseri olmayan il söylenir', () async {
      final answer = await ask("Ankara'daki camiler");

      expect(
        answer!.message.text,
        startsWith('Katalogda henüz Ankara ilinden eser yok.'),
      );
    });

    test('dönem: dönem bilgisi girilmediği söylenir, süzgeç '
        'uygulanmaz', () async {
      final answer = await ask("Konya'daki Selçuklu eserleri");
      final text = answer!.message.text;

      expect(text, contains('dönem bilgisi henüz girilmemiş'));
      expect(text, contains('Katalogda Konya ilinde 3 eser var:'));
      expect(text, contains('• Ulu Camii — Doğanhisar, Konya'));
      final search = answer.message.actions.single as GuideSearchMonuments;
      expect(search.query.filter.cities, {42});
      expect(search.query.filter.periods, isEmpty);
      expect(search.total, 3);
    });
  });

  group('tek eser', () {
    test('yapım tarihi kayıttaki cümleden; "altı yüzyıl boyunca" tarih '
        'sayılmaz', () async {
      final answer = await ask('Bursa Ulu Camii ne zaman yapıldı?');
      final message = answer!.message;

      expect(message.text, startsWith('Bursa Ulu Camii (Osmangazi, Bursa)\n'));
      expect(message.text, contains('Katalog kaydına göre: “'));
      expect(message.text, contains('açılışı 1399 yılında'));
      expect(message.text, isNot(contains('altı yüzyıl')));
      expect(message.sources.single.id, 'bursa-ulu-camii');
      expect(message.actions, [
        isA<GuideOpenMonument>(),
        isA<GuideShowOnMap>(),
      ]);
      expect(message.suggestions, contains('Kim yaptırdı?'));
      expect(answer.focus?.id, 'bursa-ulu-camii');
    });

    test('takip sorusu konuşulan esere; "yabani" bani sayılmaz', () async {
      final first = await ask('Bursa Ulu Camii ne zaman yapıldı?');

      final answer = await ask('Kim yaptırdı?', focus: first!.focus);

      expect(answer!.message.text, contains('Sultan Yıldırım Bayezid'));
      expect(answer.message.text, isNot(contains('yabani')));
    });

    test('bani: yapının kendisinden söz eden cümle; restorasyon ve eklenti '
        'cümleleri sayılmaz', () async {
      final answer = await ask('Mevlana Türbesi kim yaptırdı');
      final text = answer!.message.text;

      expect(text, startsWith('Hz. Mevlâna Türbesi'));
      expect(text, contains('1274'));
      expect(text, isNot(contains('restorasyon')));
      expect(text, isNot(contains('gümüş kafes')));
    });

    test('"II. Murad" cümleyi bölmez', () async {
      final answer = await ask('Osmangazi Muradiye Camii banisi kim?');

      expect(answer!.message.text, contains('“Cami, II. Murad tarafından'));
    });

    test(
      'bilgi kayıtta yoksa söylenir; "2.639 metrekare" yıl değildir',
      () async {
        final answer = await ask('Şekerhan ne zaman yapıldı');

        expect(
          answer!.message.text,
          'Şekerhan (Fatih, İstanbul)\n'
          'Katalog kaydında bu bilgi (yapım tarihi) yer almıyor.',
        );
      },
    );

    test('konum: adres; haritada işaretlenmemişse söylenir', () async {
      final answer = await ask('Şekerhan nerede');

      expect(
        answer!.message.text,
        contains('Adres: Hobyar Mah. Hoca Kasım Köprüsü Sk. No:4'),
      );
      expect(answer.message.text, contains('henüz işaretlenmemiş'));
      expect(answer.message.actions, [isA<GuideOpenMonument>()]);
    });

    test('adla ilgisiz sözcükler aramayı boşaltmaz', () async {
      final answer = await ask('Mevlana Türbesi ziyaret saatleri');

      expect(answer!.focus?.id, 'hz-mevlana-turbesi');
    });

    test('İngilizce soruda Türkçe ad; yanıt İngilizce', () async {
      final answer = await ask('Who built Bursa Ulu Camii?', language: 'en');

      expect(answer!.focus?.id, 'bursa-ulu-camii');
      expect(
        answer.message.text,
        contains('According to the catalogue record: “'),
      );
      expect(answer.message.suggestions, contains('When was it built?'));
    });
  });

  group('belirsiz ad', () {
    test('aynı adı taşıyan birden çok eser listelenir', () async {
      final answer = await ask('Ulu Camii');

      expect(answer!.message.text, startsWith('“Ulu Camii” adıyla eşleşen '));
      expect(answer.message.sources.length, greaterThanOrEqualTo(3));
      expect(answer.focus, isNull);
    });

    test('il ile belirsizlik kalkar', () async {
      final answer = await ask('Bursa Ulu Camii');

      expect(answer!.focus?.id, 'bursa-ulu-camii');
    });

    test('aynı adlı eserlerin önerileri ilçeyle ayrılır ve '
        'çözülür', () async {
      final answer = await ask('Muradiye Camii kimin eseri');

      expect(answer!.message.suggestions, [
        'Osmangazi Muradiye Camii banisi kim?',
        'Orhangazi Muradiye Camii banisi kim?',
      ]);
      final picked = await ask(answer.message.suggestions.last);
      expect(picked!.focus?.id, 'muradiye-camii-orhangazi');
    });
  });

  group('listeleme', () {
    test('il ve yapı türü', () async {
      final answer = await ask("Bursa'daki hamamlar");

      expect(
        answer!.message.text,
        'Katalogda Bursa ilinde 1 hamam var:\n\n'
        '• Aksu Köyü Hamamı — Kestel, Bursa',
      );
      final search = answer.message.actions.single as GuideSearchMonuments;
      expect(search.query.filter.cities, {16});
      expect(search.query.filter.categories, {MonumentCategory.bath});
    });

    test('genel özet', () async {
      final answer = await ask('Hangi illerde eser var?');

      expect(
        answer!.message.text,
        startsWith(
          'Katalogda şu an Bursa (5), Konya (3), Hatay (1) ve İstanbul (1) '
          'illerinden toplam 10 vakıf eseri var.',
        ),
      );
      expect(answer.message.suggestions.first, 'Bursa camileri');
    });

    test('özet sonraki istekte önbellekten', () async {
      await ask('Hangi illerde eser var?');
      await ask('Kaç eser var');

      expect(catalog.searches, hasLength(1));
    });
  });

  group('eserle ilgili uygulama işlemleri', () {
    test('hasar: eser seçili form önerilir', () async {
      final answer = await ask('Antakya Ulu Camii hasar bildir');

      final action = answer!.message.actions.first as GuideReportDamage;
      expect(action.monument?.id, 'antakya-ulu-camii');
      expect(answer.message.text, contains('112'));
    });

    test('harita: konuşulan eser varsa konumu', () async {
      final first = await ask('Bursa Ulu Camii');

      final answer = await ask('Haritada göster', focus: first!.focus);

      expect(answer!.message.text, contains('Adres:'));
    });
  });

  group('Asistan servisine bırakılan', () {
    for (final question in [
      'Rota nasıl planlarım?',
      'Hasar nasıl bildiririm?',
      'Selimiye Camii yanıyor',
      'Merhaba',
      'Teşekkürler',
      'Haritayı aç',
      'Yazıları büyüt',
      'hava nasıl',
    ]) {
      test(question, () async {
        expect(await ask(question), isNull);
      });
    }
  });

  test('katalog hatası iletilir', () async {
    catalog.failure = const NetworkFailure();

    final result = await guide.answer('Bursa camileri', languageCode: 'tr');

    expect(result, const Left<Failure, CatalogGuideAnswer>(NetworkFailure()));
  });
}
