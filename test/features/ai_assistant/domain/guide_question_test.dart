import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/catalog_guide/guide_question.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';

void main() {
  group('GuideQuestion', () {
    test('il, dönem ve listeleme isteği; ad yok', () {
      final q = GuideQuestion.parse("Konya'daki Selçuklu eserleri");

      expect(q.cityCodes, {42});
      expect(q.periods, {HistoricalPeriod.seljuk});
      expect(q.hasName, isFalse);
      expect(q.isListing, isTrue);
      expect(q.serverIntent, isNull);
    });

    test('kesme işaretsiz il ve çoğul yapı türü', () {
      final q = GuideQuestion.parse('Konyadaki hanlar');

      expect(q.cityCodes, {42});
      expect(q.categories, {MonumentCategory.inn});
      expect(q.hasName, isFalse);
    });

    test('kısa il adları başka sözcüklerin başında tanınmaz', () {
      expect(GuideQuestion.parse('Musa Baba Türbesi').cityCodes, isEmpty);
      expect(GuideQuestion.parse('Karşı yakadaki cami').cityCodes, isEmpty);
      expect(GuideQuestion.parse("Muş'taki camiler").cityCodes, {49});
    });

    test('eser adı soruda yazıldığı gibi; çekim eki atılır', () {
      final q = GuideQuestion.parse("Süleymaniye Camii'ni kim yaptırdı?");

      expect(q.nameText, 'Süleymaniye Camii');
      expect(q.nameTokens, ['suleymaniye']);
      expect(q.categories, {MonumentCategory.mosque});
      expect(q.facet, GuideFacet.founder);
    });

    test('ada bitişik il adı adın parçasıdır', () {
      final q = GuideQuestion.parse('Bursa Ulu Camii hangi döneme ait');

      expect(q.nameText, 'Bursa Ulu Camii');
      expect(q.cityCodes, {16});
      expect(q.facet, GuideFacet.period);
    });

    test('adla ilgisiz sözcükler için daha kısa arama metinleri', () {
      final q = GuideQuestion.parse('Mevlana Türbesi ziyaret saatleri');

      expect(q.searchTexts.first, 'Mevlana Türbesi ziyaret saatleri');
      expect(q.searchTexts.take(6), contains('Mevlana Türbesi'));
    });

    test('mimar ile mimari üslup ayrılır', () {
      expect(
        GuideQuestion.parse("Bursa Ulu Camii'nin mimarı kim?").facet,
        GuideFacet.architect,
      );
      expect(
        GuideQuestion.parse('Yeşil Camii mimarisi').facet,
        isNot(GuideFacet.architect),
      );
    });

    test('uygulama niyetleri Asistan servisine', () {
      expect(
        GuideQuestion.parse('Rota nasıl planlarım?').serverIntent,
        GuideServerIntent.route,
      );
      expect(
        GuideQuestion.parse('Hasar nasıl bildiririm?').serverIntent,
        GuideServerIntent.damage,
      );
      expect(
        GuideQuestion.parse('Selimiye Camii yanıyor').serverIntent,
        GuideServerIntent.emergency,
      );
      expect(
        GuideQuestion.parse('Haritayı aç').serverIntent,
        GuideServerIntent.map,
      );
      expect(
        GuideQuestion.parse('Ulu Camii haritada nerede').serverIntent,
        isNull,
      );
    });

    test('selamlaşma', () {
      final q = GuideQuestion.parse('Merhaba');

      expect(q.isSmallTalk, isTrue);
      expect(q.hasName, isFalse);
      expect(q.mentionsCatalog, isFalse);
    });
  });
}
