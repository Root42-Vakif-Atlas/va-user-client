import 'package:flutter/foundation.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';

import 'suleymaniye_complex_fixtures.dart';

/// Mock API için iki dilli metin.
@immutable
final class MockText {
  const MockText({required this.tr, required this.en});

  /// Tüm dillerde aynı olan metin (özel ad, adres).
  const MockText.same(String value) : tr = value, en = value;

  final String tr;
  final String en;

  String resolve(String languageCode) => languageCode == 'en' ? en : tr;
}

/// Wikimedia Commons'tan, özgür lisanslı eser fotoğrafı.
///
/// Gerçek API'de görseller VGM'nin kendi CDN'inden sunulur; Commons yalnızca
/// mock/demo içindir. [url] 1280 px, [thumbnailUrl] 330 px genişliğindedir
/// (Wikimedia'nın standart küçük resim adımları).
@immutable
final class MockImage {
  const MockImage({
    required this.url,
    required this.thumbnailUrl,
    required this.altText,
    required this.author,
    required this.license,
    required this.sourceUrl,
  });

  final String url;
  final String thumbnailUrl;
  final MockText altText;
  final String author;
  final String license;
  final String sourceUrl;

  static const String sourceName = 'Wikimedia Commons';

  Map<String, Object?> toJson(String languageCode) => {
    'url': url,
    'thumbnailUrl': thumbnailUrl,
    'altText': altText.resolve(languageCode),
    'author': author,
    'license': license,
    'sourceName': sourceName,
    'sourceUrl': sourceUrl,
  };
}

/// Mock katalogdaki vakıf eseri.
///
/// Koordinatlar OpenStreetMap'teki yapı geometrisinin merkezinden (Wikidata
/// ile çapraz kontrol edilerek), adresler OSM adres etiketlerinden alınmıştır.
@immutable
final class MockMonument {
  const MockMonument({
    required this.id,
    required this.name,
    required this.category,
    required this.period,
    required this.city,
    required this.district,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.shortDescription,
    required this.description,
    required this.history,
    required this.constructionDate,
    required this.founder,
    required this.images,
    this.architect,
    this.isUnescoWorldHeritage = false,
    this.complexId,
    this.complexOrder,
  });

  final String id;
  final MockText name;
  final MonumentCategory category;
  final HistoricalPeriod period;
  final String city;
  final String district;
  final String address;
  final double latitude;
  final double longitude;
  final MockText shortDescription;
  final MockText description;
  final MockText history;
  final MockText constructionDate;
  final MockText founder;
  final MockText? architect;
  final bool isUnescoWorldHeritage;
  final List<MockImage> images;

  /// Üyesi olduğu külliye (iç içe külliye yok).
  final String? complexId;

  /// Külliyedeki küratörlü sıra (cami önce).
  final int? complexOrder;

  /// Külliye kaydı: `complex` kategorisi ⇔ külliye (`complexes` satırı).
  bool get isComplex => category == MonumentCategory.complex;

  /// İl plaka kodu (sunucuda `city: {code, name}`; süzgeç `city=34`).
  int get cityCode => plateCodes[city]!;

  /// Fikstürlerdeki illerin plaka kodları.
  static const Map<String, int> plateCodes = {
    'Aksaray': 68,
    'Ankara': 6,
    'Bursa': 16,
    'Diyarbakır': 21,
    'Edirne': 22,
    'İstanbul': 34,
    'İzmir': 35,
    'Konya': 42,
    'Sivas': 58,
    'Trabzon': 61,
  };

  Map<String, Object?> toSummaryJson(String languageCode) => {
    'id': id,
    'name': name.resolve(languageCode),
    'category': category.name,
    'period': period.name,
    'city': city,
    'cityCode': cityCode,
    'district': district,
    'address': address,
    'location': {'latitude': latitude, 'longitude': longitude},
    'shortDescription': shortDescription.resolve(languageCode),
    'thumbnailUrl': images.isEmpty ? null : images.first.thumbnailUrl,
  };

  Map<String, Object?> toDetailJson(String languageCode) => {
    ...toSummaryJson(languageCode)..remove('thumbnailUrl'),
    'description': description.resolve(languageCode),
    'history': history.resolve(languageCode),
    'constructionDate': constructionDate.resolve(languageCode),
    'founder': founder.resolve(languageCode),
    'architect': architect?.resolve(languageCode),
    'isUnescoWorldHeritage': isUnescoWorldHeritage,
    'images': [for (final image in images) image.toJson(languageCode)],
  };
}

/// 10 farklı ilden VGM vakıf eserleri ve Süleymaniye Külliyesi'nin yapıları.
///
/// Tarih, bani ve mimar bilgileri Wikipedia (TR/EN) ve Wikidata ile
/// doğrulanmıştır. Metinler demo amaçlıdır; yürürlükteki içerik VGM
/// kataloğundan gelir. Külliye üyeleri [SuleymaniyeComplexFixtures]'tadır;
/// ilk 10 kayıt (illerin temsilcileri) sırası korunarak başta durur.
abstract final class CatalogFixtures {
  static const String _commons = 'https://commons.wikimedia.org/wiki/File:';
  static const String _thumb =
      'https://thumb.wikimedia.org/wikipedia/commons/thumb';
  static const String _upload =
      'https://upload.wikimedia.org/wikipedia/commons';

  static const List<MockMonument> monuments = [
    ..._monuments,
    SuleymaniyeComplexFixtures.complex,
    ...SuleymaniyeComplexFixtures.members,
  ];

  /// İllerin temsilcisi olan 10 eser.
  static const List<MockMonument> _monuments = [
    MockMonument(
      id: 'suleymaniye-camii',
      name: MockText(tr: 'Süleymaniye Camii', en: 'Süleymaniye Mosque'),
      category: MonumentCategory.mosque,
      period: HistoricalPeriod.ottoman,
      city: 'İstanbul',
      district: 'Fatih',
      address:
          'Süleymaniye Mahallesi, Prof. Dr. Sıddık Sami Onar Caddesi No:1, '
          '34116 Fatih/İstanbul',
      latitude: 41.016240,
      longitude: 28.963825,
      shortDescription: MockText(
        tr:
            "Kanuni Sultan Süleyman adına Mimar Sinan'ın inşa ettiği, "
            "İstanbul'un Üçüncü Tepesi'ne hâkim imparatorluk camii ve "
            'külliyesi.',
        en:
            'The imperial mosque and complex built by Mimar Sinan for '
            "Suleiman the Magnificent, crowning Istanbul's Third Hill.",
      ),
      description: MockText(
        tr:
            "Mimar Sinan'ın \"kalfalık eserim\" dediği Süleymaniye, klasik "
            'Osmanlı mimarisinin en olgun örneklerinden biri kabul edilir. '
            'Ana kubbe, iki yarım kubbe ve kademeli küçük kubbelerle örtülen '
            'ibadet mekânı; revaklı avlusu ve dört minaresiyle medreseler, '
            'darüşşifa, imaret, hamam ve kütüphaneden oluşan külliyenin '
            'merkezinde yer alır.\n\n'
            'Kanuni Sultan Süleyman ile Hürrem Sultan\'ın türbeleri caminin '
            'kıble tarafındaki hazirededir.',
        en:
            'Called his "journeyman work" by Mimar Sinan, the Süleymaniye is '
            'regarded as one of the most accomplished examples of classical '
            'Ottoman architecture. Its prayer hall, covered by a main dome, '
            'two semi-domes and cascading smaller domes, stands with its '
            'arcaded courtyard and four minarets at the heart of a complex of '
            'madrasas, a hospital, a public kitchen, a bathhouse and a '
            'library.\n\n'
            'The tombs of Suleiman the Magnificent and Hürrem Sultan lie in '
            'the cemetery on the qibla side of the mosque.',
      ),
      history: MockText(
        tr:
            "Kitabesine göre temeli 1550'de atılan cami 1557'de ibadete "
            'açıldı; külliyenin bazı yapıları sonraki yıllarda tamamlandı. '
            'Yapı yüzyıllar boyunca deprem ve yangınların ardından onarıldı; '
            'en kapsamlı restorasyonlarından biri 2007–2010 yıllarında '
            'Vakıflar Genel Müdürlüğü tarafından gerçekleştirildi.\n\n'
            "Süleymaniye, \"İstanbul'un Tarihî Alanları\" kapsamında 1985'ten "
            "bu yana UNESCO Dünya Mirası Listesi'ndedir.",
        en:
            'According to its inscription, the foundations were laid in 1550 '
            'and the mosque opened for worship in 1557; some buildings of the '
            'complex were completed in the following years. Repaired after '
            'earthquakes and fires over the centuries, it underwent one of '
            'its most extensive restorations between 2007 and 2010 by the '
            'General Directorate of Foundations.\n\n'
            'As part of the "Historic Areas of Istanbul", the Süleymaniye has '
            'been on the UNESCO World Heritage List since 1985.',
      ),
      constructionDate: MockText.same('1550–1557'),
      founder: MockText(
        tr: 'Kanuni Sultan Süleyman',
        en: 'Suleiman the Magnificent',
      ),
      architect: MockText.same('Mimar Sinan'),
      isUnescoWorldHeritage: true,
      complexId: SuleymaniyeComplexFixtures.complexId,
      complexOrder: 1,
      images: [
        MockImage(
          url:
              '$_thumb/7/76/Domes_of_the_S%C3%BCleymaniye_Mosque.jpg/'
              '1280px-Domes_of_the_S%C3%BCleymaniye_Mosque.jpg',
          thumbnailUrl:
              '$_thumb/7/76/Domes_of_the_S%C3%BCleymaniye_Mosque.jpg/'
              '330px-Domes_of_the_S%C3%BCleymaniye_Mosque.jpg',
          altText: MockText(
            tr:
                "Süleymaniye Camii'nin ana kubbesi, yarım kubbeleri ve avlu "
                'revaklarının kubbeleri',
            en:
                'The main dome, semi-domes and courtyard portico domes of the '
                'Süleymaniye Mosque',
          ),
          author: 'Bernard Gagnon',
          license: 'CC BY-SA 3.0',
          sourceUrl: '${_commons}Domes_of_the_S%C3%BCleymaniye_Mosque.jpg',
        ),
        MockImage(
          url:
              '$_thumb/d/de/Mezquita_de_Solim%C3%A1n%2C_Estambul%2C_Turqu%C3%ADa%2C_2024-09-29%2C_DD_42-44_HDR.jpg/'
              '1280px-Mezquita_de_Solim%C3%A1n%2C_Estambul%2C_Turqu%C3%ADa%2C_2024-09-29%2C_DD_42-44_HDR.jpg',
          thumbnailUrl:
              '$_thumb/d/de/Mezquita_de_Solim%C3%A1n%2C_Estambul%2C_Turqu%C3%ADa%2C_2024-09-29%2C_DD_42-44_HDR.jpg/'
              '330px-Mezquita_de_Solim%C3%A1n%2C_Estambul%2C_Turqu%C3%ADa%2C_2024-09-29%2C_DD_42-44_HDR.jpg',
          altText: MockText(
            tr:
                'Gün batımında İstanbul siluetinde yükselen Süleymaniye Camii '
                've minareleri',
            en:
                'The Süleymaniye Mosque and its minarets rising on the '
                'Istanbul skyline at sunset',
          ),
          author: 'Diego Delso',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Mezquita_de_Solim%C3%A1n%2C_Estambul%2C_Turqu%C3%ADa%2C_2024-09-29%2C_DD_42-44_HDR.jpg',
        ),
        MockImage(
          url:
              '$_thumb/8/80/Courtyard_of_the_S%C3%BCleymaniye_Mosque_in_Istanbul%2C_Turkey_001.jpg/'
              '1280px-Courtyard_of_the_S%C3%BCleymaniye_Mosque_in_Istanbul%2C_Turkey_001.jpg',
          thumbnailUrl:
              '$_thumb/8/80/Courtyard_of_the_S%C3%BCleymaniye_Mosque_in_Istanbul%2C_Turkey_001.jpg/'
              '330px-Courtyard_of_the_S%C3%BCleymaniye_Mosque_in_Istanbul%2C_Turkey_001.jpg',
          altText: MockText(
            tr: 'Revaklarla çevrili avlu ve ortasındaki mermer şadırvan',
            en:
                'The arcaded courtyard with the marble ablution fountain at '
                'its centre',
          ),
          author: 'Moonik',
          license: 'CC BY-SA 3.0',
          sourceUrl:
              '${_commons}Courtyard_of_the_S%C3%BCleymaniye_Mosque_in_Istanbul%2C_Turkey_001.jpg',
        ),
        MockImage(
          url:
              '$_thumb/f/fa/Suleiman_mosque_Istanbul_July_2022-5.jpg/'
              '1280px-Suleiman_mosque_Istanbul_July_2022-5.jpg',
          thumbnailUrl:
              '$_thumb/f/fa/Suleiman_mosque_Istanbul_July_2022-5.jpg/'
              '330px-Suleiman_mosque_Istanbul_July_2022-5.jpg',
          altText: MockText(
            tr: 'İç mekândan ana kubbe ve kalem işi bezemeler',
            en: 'The main dome and painted decoration seen from inside',
          ),
          author: 'Alvesgaspar',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Suleiman_mosque_Istanbul_July_2022-5.jpg',
        ),
        MockImage(
          url:
              '$_thumb/9/95/Sadirvan_of_the_S%C3%BCleymaniye_Mosque.jpg/'
              '1280px-Sadirvan_of_the_S%C3%BCleymaniye_Mosque.jpg',
          thumbnailUrl:
              '$_thumb/9/95/Sadirvan_of_the_S%C3%BCleymaniye_Mosque.jpg/'
              '330px-Sadirvan_of_the_S%C3%BCleymaniye_Mosque.jpg',
          altText: MockText(
            tr: 'Avludaki mermer şadırvanın yakından görünümü',
            en: 'Close-up of the marble ablution fountain in the courtyard',
          ),
          author: 'Bernard Gagnon',
          license: 'CC BY-SA 3.0',
          sourceUrl: '${_commons}Sadirvan_of_the_S%C3%BCleymaniye_Mosque.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'selimiye-camii',
      name: MockText(tr: 'Selimiye Camii', en: 'Selimiye Mosque'),
      category: MonumentCategory.mosque,
      period: HistoricalPeriod.ottoman,
      city: 'Edirne',
      district: 'Merkez',
      address: 'Meydan Mahallesi, Taş Odalar Sokak, 22100 Merkez/Edirne',
      latitude: 41.678093,
      longitude: 26.559203,
      shortDescription: MockText(
        tr:
            "Mimar Sinan'ın \"ustalık eserim\" dediği, Sultan II. Selim "
            'adına inşa edilen ve Edirne siluetine hâkim olan cami.',
        en:
            'Commissioned by Sultan Selim II and called his "masterpiece" by '
            'Mimar Sinan, the mosque dominates the skyline of Edirne.',
      ),
      description: MockText(
        tr:
            'Selimiye, sekiz ayak üzerinde yükselen yaklaşık 31 metre çaplı '
            'ana kubbesi ve dört ince, yüksek minaresiyle Osmanlı '
            'mimarisinin doruk noktası kabul edilir. İç mekânda İznik '
            'çinileri, mermer minber ve kubbenin altında yer alan müezzin '
            'mahfili öne çıkar.\n\n'
            'Cami; medreseler, darülhadis ve arastadan oluşan külliyenin '
            'merkezindedir. Külliyenin medrese yapılarından birinde bugün '
            'Vakıflar Genel Müdürlüğü\'ne bağlı Selimiye Vakıf Müzesi '
            'bulunmaktadır.',
        en:
            'With its main dome of about 31 metres in diameter rising on '
            'eight piers and its four slender, lofty minarets, the Selimiye is '
            'considered the pinnacle of Ottoman architecture. Inside, İznik '
            "tiles, the marble minbar and the muezzin's platform beneath the "
            'dome stand out.\n\n'
            'The mosque is at the centre of a complex of madrasas, a hadith '
            'school and a covered bazaar. One of the madrasa buildings now '
            'houses the Selimiye Foundation Museum of the General Directorate '
            'of Foundations.',
      ),
      history: MockText(
        tr:
            "Yapımına 1568'de başlanan cami 1575'te tamamlandı; Mimar Sinan "
            'bu eseri seksen yaşlarındayken inşa etti.\n\n'
            "Selimiye Camii ve Külliyesi 2011'de UNESCO Dünya Mirası "
            "Listesi'ne alındı.",
        en:
            'Construction began in 1568 and was completed in 1575; Mimar '
            'Sinan built it when he was around eighty years old.\n\n'
            'The Selimiye Mosque and its Social Complex were inscribed on the '
            'UNESCO World Heritage List in 2011.',
      ),
      constructionDate: MockText.same('1568–1575'),
      founder: MockText(tr: 'Sultan II. Selim', en: 'Sultan Selim II'),
      architect: MockText.same('Mimar Sinan'),
      isUnescoWorldHeritage: true,
      images: [
        MockImage(
          url:
              '$_thumb/4/40/Selimiye_Camii_-_panoramio_%283%29.jpg/'
              '1280px-Selimiye_Camii_-_panoramio_%283%29.jpg',
          thumbnailUrl:
              '$_thumb/4/40/Selimiye_Camii_-_panoramio_%283%29.jpg/'
              '330px-Selimiye_Camii_-_panoramio_%283%29.jpg',
          altText: MockText(
            tr:
                "Mavi gökyüzü altında Selimiye Camii'nin kubbesi ve dört "
                'minaresi',
            en:
                'The dome and four minarets of the Selimiye Mosque under a '
                'blue sky',
          ),
          author: 'Aziz Akbiyik',
          license: 'CC BY-SA 3.0',
          sourceUrl: '${_commons}Selimiye_Camii_-_panoramio_%283%29.jpg',
        ),
        MockImage(
          url:
              '$_thumb/2/20/Courtyard_of_the_Selimiye_Mosque_042.jpg/'
              '1280px-Courtyard_of_the_Selimiye_Mosque_042.jpg',
          thumbnailUrl:
              '$_thumb/2/20/Courtyard_of_the_Selimiye_Mosque_042.jpg/'
              '330px-Courtyard_of_the_Selimiye_Mosque_042.jpg',
          altText: MockText(
            tr: 'Kemerli revaklarla çevrili avlu',
            en: 'The courtyard framed by arched porticoes',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Courtyard_of_the_Selimiye_Mosque_042.jpg',
        ),
        MockImage(
          url:
              '$_thumb/4/47/Edirne_Selimiye_Mosque_Central_dome_in_2018_0160.jpg/'
              '1280px-Edirne_Selimiye_Mosque_Central_dome_in_2018_0160.jpg',
          thumbnailUrl:
              '$_thumb/4/47/Edirne_Selimiye_Mosque_Central_dome_in_2018_0160.jpg/'
              '330px-Edirne_Selimiye_Mosque_Central_dome_in_2018_0160.jpg',
          altText: MockText(
            tr: 'Sekiz ayak üzerine oturan ana kubbenin içten görünümü',
            en: 'Interior view of the main dome resting on eight piers',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Edirne_Selimiye_Mosque_Central_dome_in_2018_0160.jpg',
        ),
        MockImage(
          url:
              '$_thumb/8/8b/Edirne_Selimiye_Mosque_Tiles_on_arches_in_2006_2412.jpg/'
              '1280px-Edirne_Selimiye_Mosque_Tiles_on_arches_in_2006_2412.jpg',
          thumbnailUrl:
              '$_thumb/8/8b/Edirne_Selimiye_Mosque_Tiles_on_arches_in_2006_2412.jpg/'
              '330px-Edirne_Selimiye_Mosque_Tiles_on_arches_in_2006_2412.jpg',
          altText: MockText(
            tr: 'Kemer alınlığını süsleyen İznik çinileri',
            en: 'İznik tiles decorating an arch tympanum',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Edirne_Selimiye_Mosque_Tiles_on_arches_in_2006_2412.jpg',
        ),
        MockImage(
          url:
              '$_thumb/f/f3/Edirne_Selimiye_Mosque_from_distance_in_2009_6428.jpg/'
              '1280px-Edirne_Selimiye_Mosque_from_distance_in_2009_6428.jpg',
          thumbnailUrl:
              '$_thumb/f/f3/Edirne_Selimiye_Mosque_from_distance_in_2009_6428.jpg/'
              '330px-Edirne_Selimiye_Mosque_from_distance_in_2009_6428.jpg',
          altText: MockText(
            tr:
                "Yeşil alanın ardında yükselen Selimiye Camii'nin uzaktan "
                'görünümü',
            en: 'Distant view of the Selimiye Mosque rising beyond a park',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Edirne_Selimiye_Mosque_from_distance_in_2009_6428.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'bursa-ulu-camii',
      name: MockText(tr: 'Bursa Ulu Camii', en: 'Bursa Grand Mosque'),
      category: MonumentCategory.mosque,
      period: HistoricalPeriod.ottoman,
      city: 'Bursa',
      district: 'Osmangazi',
      address: 'Nalbantoğlu Mahallesi, Atatürk Caddesi, 16010 Osmangazi/Bursa',
      latitude: 40.183923,
      longitude: 29.061882,
      shortDescription: MockText(
        tr:
            "Yıldırım Bayezid'in yaptırdığı; yirmi kubbesi ve ibadet "
            'mekânındaki şadırvanıyla tanınan erken Osmanlı dönemi ulu '
            'camisi.',
        en:
            'The early Ottoman grand mosque commissioned by Bayezid I, known '
            'for its twenty domes and the ablution fountain inside its prayer '
            'hall.',
      ),
      description: MockText(
        tr:
            'Çok ayaklı ulu cami planındaki yapı, on iki ayak üzerine oturan '
            'yirmi kubbeyle örtülüdür. Orta kubbenin altındaki şadırvan, '
            'ibadet mekânının içinde yer almasıyla dikkat çeker.\n\n'
            'Duvarları ve ayakları süsleyen çok sayıda hat levhası ve '
            'yazısıyla cami, adeta bir hat sanatı müzesi olarak anılır.',
        en:
            'Built on the multi-pier plan of grand mosques, the building is '
            'covered by twenty domes resting on twelve piers. The ablution '
            'fountain beneath the central dome is remarkable for being inside '
            'the prayer hall.\n\n'
            'With numerous calligraphic panels and inscriptions adorning its '
            'walls and piers, the mosque is often described as a museum of '
            'calligraphy.',
      ),
      history: MockText(
        tr:
            "Yıldırım Bayezid'in 1396 Niğbolu zaferinin ardından yaptırdığı "
            "cami 1400'de tamamlandı. Rivayete göre sultan zaferin ardından "
            'yirmi cami yaptırmayı adamış, bunun yerine yirmi kubbeli tek bir '
            'cami inşa ettirmiştir.\n\n'
            "Cami, 2014'te \"Bursa ve Cumalıkızık: Osmanlı İmparatorluğu'nun "
            "Doğuşu\" alanı kapsamında UNESCO Dünya Mirası Listesi'ne girdi.",
        en:
            'Commissioned by Bayezid I after the victory at Nicopolis in 1396, '
            'the mosque was completed in 1400. According to legend, the '
            'sultan vowed to build twenty mosques after the victory and '
            'instead built a single mosque with twenty domes.\n\n'
            'In 2014 the mosque was inscribed on the UNESCO World Heritage '
            'List as part of "Bursa and Cumalıkızık: the Birth of the Ottoman '
            'Empire".',
      ),
      constructionDate: MockText.same('1396–1400'),
      founder: MockText(
        tr: 'Sultan I. Bayezid (Yıldırım)',
        en: 'Sultan Bayezid I',
      ),
      architect: MockText.same('Ali Neccar'),
      isUnescoWorldHeritage: true,
      images: [
        MockImage(
          url:
              '$_thumb/8/86/Ulucami-bursa_-_panoramio.jpg/'
              '1280px-Ulucami-bursa_-_panoramio.jpg',
          thumbnailUrl:
              '$_thumb/8/86/Ulucami-bursa_-_panoramio.jpg/'
              '330px-Ulucami-bursa_-_panoramio.jpg',
          altText: MockText(
            tr: "Meydandan görülen Bursa Ulu Camii'nin minareleri",
            en: 'The minarets of the Bursa Grand Mosque seen from the square',
          ),
          author: 'Haluk Comertel',
          license: 'CC BY 3.0',
          sourceUrl: '${_commons}Ulucami-bursa_-_panoramio.jpg',
        ),
        MockImage(
          url:
              '$_thumb/2/23/Grand_Mosque_of_Bursa_at_North_exterior_side_Western_minaret_in_2014_7658.jpg/'
              '1280px-Grand_Mosque_of_Bursa_at_North_exterior_side_Western_minaret_in_2014_7658.jpg',
          thumbnailUrl:
              '$_thumb/2/23/Grand_Mosque_of_Bursa_at_North_exterior_side_Western_minaret_in_2014_7658.jpg/'
              '330px-Grand_Mosque_of_Bursa_at_North_exterior_side_Western_minaret_in_2014_7658.jpg',
          altText: MockText(
            tr: 'Caminin kuzey cephesi ve batı minaresinin kaidesi',
            en: 'The north façade and the base of the western minaret',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Grand_Mosque_of_Bursa_at_North_exterior_side_Western_minaret_in_2014_7658.jpg',
        ),
        MockImage(
          url:
              '$_thumb/5/5d/Bursa%2C_Ulu_Cami%2C_interior_with_%C5%9Fad%C4%B1rvan.jpg/'
              '1280px-Bursa%2C_Ulu_Cami%2C_interior_with_%C5%9Fad%C4%B1rvan.jpg',
          thumbnailUrl:
              '$_thumb/5/5d/Bursa%2C_Ulu_Cami%2C_interior_with_%C5%9Fad%C4%B1rvan.jpg/'
              '330px-Bursa%2C_Ulu_Cami%2C_interior_with_%C5%9Fad%C4%B1rvan.jpg',
          altText: MockText(
            tr:
                'İbadet mekânının ortasındaki şadırvan ve hat levhalarıyla '
                'bezeli ayaklar',
            en:
                'The ablution fountain at the centre of the prayer hall and '
                'piers adorned with calligraphy',
          ),
          author: 'Carl Ha',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Bursa%2C_Ulu_Cami%2C_interior_with_%C5%9Fad%C4%B1rvan.jpg',
        ),
        MockImage(
          url:
              '$_thumb/e/ef/Ulu_Camii_-_Mihrab_%282%29.jpg/'
              '1280px-Ulu_Camii_-_Mihrab_%282%29.jpg',
          thumbnailUrl:
              '$_thumb/e/ef/Ulu_Camii_-_Mihrab_%282%29.jpg/'
              '330px-Ulu_Camii_-_Mihrab_%282%29.jpg',
          altText: MockText(
            tr: 'Yaldızlı bezemelerle çevrili mihrap',
            en: 'The mihrab framed by gilded decoration',
          ),
          author: 'Yahia.Mokhtar',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Ulu_Camii_-_Mihrab_%282%29.jpg',
        ),
        MockImage(
          url:
              '$_thumb/2/2d/ULU_CAM%C4%B0%C4%B0_MOSQUE_BURSA_TURKEY_-_panoramio_%2810%29.jpg/'
              '1280px-ULU_CAM%C4%B0%C4%B0_MOSQUE_BURSA_TURKEY_-_panoramio_%2810%29.jpg',
          thumbnailUrl:
              '$_thumb/2/2d/ULU_CAM%C4%B0%C4%B0_MOSQUE_BURSA_TURKEY_-_panoramio_%2810%29.jpg/'
              '330px-ULU_CAM%C4%B0%C4%B0_MOSQUE_BURSA_TURKEY_-_panoramio_%2810%29.jpg',
          altText: MockText(
            tr: 'Duvardaki büyük hat levhalarından biri',
            en: 'One of the large calligraphy panels on the walls',
          ),
          author: 'Mustafa Duman',
          license: 'CC BY 3.0',
          sourceUrl:
              '${_commons}ULU_CAM%C4%B0%C4%B0_MOSQUE_BURSA_TURKEY_-_panoramio_%2810%29.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'kizlaragasi-hani',
      name: MockText(tr: 'Kızlarağası Hanı', en: 'Kızlarağası Inn'),
      category: MonumentCategory.inn,
      period: HistoricalPeriod.ottoman,
      city: 'İzmir',
      district: 'Konak',
      address:
          'Konak Mahallesi, 871. Sokak, Kemeraltı Çarşısı, 35250 Konak/İzmir',
      latitude: 38.421248,
      longitude: 27.133089,
      shortDescription: MockText(
        tr:
            "Hacı Beşir Ağa'nın 1744'te yaptırdığı, Kemeraltı Çarşısı'nın "
            'kalbindeki iki katlı Osmanlı hanı.',
        en:
            'A two-storey Ottoman inn built by Hacı Beşir Ağa in 1744 at the '
            'heart of the Kemeraltı Bazaar.',
      ),
      description: MockText(
        tr:
            'İç avlulu ve iki katlı hanın alt katı ticarete, üst katı '
            'konaklamaya ayrılmıştı. Taş ve tuğla almaşık duvarları, tonozlu '
            'mekânları ve avluya bakan kemerli revaklarıyla İzmir\'de '
            'günümüze ulaşan ender Osmanlı hanlarındandır.\n\n'
            'Bugün avlusu kafeleri, dükkânları ve el sanatları ustalarıyla '
            "Kemeraltı'nın canlı buluşma noktalarından biridir.",
        en:
            'The two-storey inn arranged around an inner courtyard reserved '
            'its ground floor for trade and its upper floor for lodging. With '
            'its alternating stone and brick walls, vaulted rooms and arcades '
            'facing the courtyard, it is one of the few Ottoman inns in İzmir '
            'that survive today.\n\n'
            'Today its courtyard, filled with cafés, shops and craftspeople, '
            'is one of the liveliest meeting points of Kemeraltı.',
      ),
      history: MockText(
        tr:
            'Han, III. Ahmed ve I. Mahmud dönemlerinde kızlarağası '
            '(Darüssaade ağası) olarak görev yapan Hacı Beşir Ağa tarafından '
            "1744'te yaptırıldı ve 1745'te tamamlandığı kabul edilir. Yapı, "
            'adını banisinin unvanından alır.\n\n'
            "Kemeraltı'nın en eski yapılarından biri olan han, restorasyonun "
            'ardından çarşı olarak kullanılmaya devam etmektedir.',
        en:
            'The inn was commissioned in 1744 by Hacı Beşir Ağa, who served as '
            'the Chief Black Eunuch (kızlarağası) under Ahmed III and '
            'Mahmud I, and is believed to have been completed in 1745. The '
            "building takes its name from its founder's title.\n\n"
            'One of the oldest buildings in Kemeraltı, the inn continues to '
            'serve as a bazaar after its restoration.',
      ),
      constructionDate: MockText.same('1744–1745'),
      founder: MockText.same('Hacı Beşir Ağa'),
      images: [
        MockImage(
          url:
              '$_thumb/e/e7/K%C4%B1zlara%C4%9Fas%C4%B1_han%C4%B1-Hisar_camii-Kemeralt%C4%B1-%C4%B0zmir_-_panoramio.jpg/'
              '1280px-K%C4%B1zlara%C4%9Fas%C4%B1_han%C4%B1-Hisar_camii-Kemeralt%C4%B1-%C4%B0zmir_-_panoramio.jpg',
          thumbnailUrl:
              '$_thumb/e/e7/K%C4%B1zlara%C4%9Fas%C4%B1_han%C4%B1-Hisar_camii-Kemeralt%C4%B1-%C4%B0zmir_-_panoramio.jpg/'
              '330px-K%C4%B1zlara%C4%9Fas%C4%B1_han%C4%B1-Hisar_camii-Kemeralt%C4%B1-%C4%B0zmir_-_panoramio.jpg',
          altText: MockText(
            tr:
                'Hanın kemerlerinden görülen avlu cephesi ve yakındaki Hisar '
                "Camii'nin kubbesi",
            en:
                "The courtyard façade seen through the inn's arches, with the "
                'dome of the nearby Hisar Mosque',
          ),
          author: 'Haluk Comertel',
          license: 'CC BY 3.0',
          sourceUrl:
              '${_commons}K%C4%B1zlara%C4%9Fas%C4%B1_han%C4%B1-Hisar_camii-Kemeralt%C4%B1-%C4%B0zmir_-_panoramio.jpg',
        ),
        MockImage(
          url:
              '$_thumb/0/0c/Kizlaragasi_Han_entrance_Izmir_2024.jpeg/'
              '1280px-Kizlaragasi_Han_entrance_Izmir_2024.jpeg',
          thumbnailUrl:
              '$_thumb/0/0c/Kizlaragasi_Han_entrance_Izmir_2024.jpeg/'
              '330px-Kizlaragasi_Han_entrance_Izmir_2024.jpeg',
          altText: MockText(
            tr: 'Üzerinde hanın adı yazan kemerli giriş kapısı',
            en: 'The arched entrance bearing the name of the inn',
          ),
          author: 'Furkan Akkurt',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Kizlaragasi_Han_entrance_Izmir_2024.jpeg',
        ),
        MockImage(
          url:
              '$_thumb/c/c4/K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_%C4%B0kinci_Kat.jpg/'
              '1280px-K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_%C4%B0kinci_Kat.jpg',
          thumbnailUrl:
              '$_thumb/c/c4/K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_%C4%B0kinci_Kat.jpg/'
              '330px-K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_%C4%B0kinci_Kat.jpg',
          altText: MockText(
            tr: 'Taş ve tuğla almaşık duvarlı üst kat ve bacalar',
            en:
                'The upper floor with alternating stone and brick walls and '
                'chimneys',
          ),
          author: 'Brfnztvl',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_%C4%B0kinci_Kat.jpg',
        ),
        MockImage(
          url:
              '$_thumb/f/f9/Izmir_K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_5918.jpg/'
              '1280px-Izmir_K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_5918.jpg',
          thumbnailUrl:
              '$_thumb/f/f9/Izmir_K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_5918.jpg/'
              '330px-Izmir_K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_5918.jpg',
          altText: MockText(
            tr: 'Tonozlu iç geçitte sıralanan dükkânlar',
            en: 'Shops lining the vaulted interior passage',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Izmir_K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_5918.jpg',
        ),
        MockImage(
          url:
              '$_thumb/3/31/K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_Kap%C4%B1s%C4%B1_2.jpg/'
              '1280px-K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_Kap%C4%B1s%C4%B1_2.jpg',
          thumbnailUrl:
              '$_thumb/3/31/K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_Kap%C4%B1s%C4%B1_2.jpg/'
              '330px-K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_Kap%C4%B1s%C4%B1_2.jpg',
          altText: MockText(
            tr: 'Kesme taş cephedeki ahşap kanatlı giriş kapısı',
            en: 'The wooden-leaved entrance door in the cut-stone façade',
          ),
          author: 'Chansey',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}K%C4%B1zlara%C4%9Fas%C4%B1_Han%C4%B1_Kap%C4%B1s%C4%B1_2.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'haci-bayram-veli-camii',
      name: MockText(
        tr: 'Hacı Bayram-ı Veli Camii',
        en: 'Hacı Bayram-ı Veli Mosque',
      ),
      category: MonumentCategory.mosque,
      period: HistoricalPeriod.ottoman,
      city: 'Ankara',
      district: 'Altındağ',
      address:
          'Hacı Bayram Mahallesi, Şehit Keskin Sokak, Ulus, 06050 '
          'Altındağ/Ankara',
      latitude: 39.944392,
      longitude: 32.857966,
      shortDescription: MockText(
        tr:
            "Hacı Bayram-ı Veli'nin zaviyesi olarak kurulan, Augustus "
            "Tapınağı'nın hemen yanında yükselen tarihî cami.",
        en:
            'A historic mosque founded as the lodge of Hacı Bayram-ı Veli, '
            'rising right next to the Temple of Augustus.',
      ),
      description: MockText(
        tr:
            'Taş kaide üzerinde tuğla duvarlı ve kiremit çatılı, dikdörtgen '
            'planlı yapı bugünkü görünümünü büyük ölçüde 17. ve 18. yüzyıl '
            'onarımlarında kazanmıştır. Tuğla minaresi, cephedeki sırlı hat '
            'yazıları ve iç mekândaki kalem işi ahşap bezemeler öne '
            'çıkar.\n\n'
            "Bayramiye tarikatının kurucusu Hacı Bayram-ı Veli'nin türbesi "
            'caminin kıble duvarının önündedir.',
        en:
            'Rectangular in plan, with brick walls on a stone base and a tiled '
            'roof, the building largely owes its present appearance to repairs '
            'in the 17th and 18th centuries. Its brick minaret, the glazed '
            'calligraphy on the façade and the painted woodwork inside stand '
            'out.\n\n'
            'The tomb of Hacı Bayram-ı Veli, founder of the Bayramiyye order, '
            'stands in front of the qibla wall of the mosque.',
      ),
      history: MockText(
        tr:
            'Yapının ilk inşası hicri 831 (1427–1428) yılına tarihlenir. '
            'Roma dönemine ait Augustus Tapınağı ile aynı alanı paylaşan '
            "cami, yüzyıllar boyunca Ankara'nın en önemli ziyaret "
            'yerlerinden biri olmuştur.\n\n'
            "Caminin çevresi 2010'lu yıllarda yapılan düzenlemeyle meydan "
            'olarak yenilendi.',
        en:
            'The first construction of the building dates to 831 AH '
            '(1427–1428). Sharing its site with the Roman-era Temple of '
            "Augustus, the mosque has been one of Ankara's most visited "
            'places for centuries.\n\n'
            'The surroundings of the mosque were redesigned as a public square '
            'in the 2010s.',
      ),
      constructionDate: MockText.same('1427–1428'),
      founder: MockText(
        tr: 'Hacı Bayram-ı Veli (zaviye olarak)',
        en: 'Hacı Bayram-ı Veli (as a dervish lodge)',
      ),
      images: [
        MockImage(
          url:
              '$_thumb/1/1d/Haci_Bayram_Mosque_01.jpg/'
              '1280px-Haci_Bayram_Mosque_01.jpg',
          thumbnailUrl:
              '$_thumb/1/1d/Haci_Bayram_Mosque_01.jpg/'
              '330px-Haci_Bayram_Mosque_01.jpg',
          altText: MockText(
            tr:
                'Önündeki meydanla Hacı Bayram-ı Veli Camii ve tuğla '
                'minaresi',
            en:
                'The Hacı Bayram-ı Veli Mosque and its brick minaret with the '
                'square in front',
          ),
          author: 'Bernard Gagnon',
          license: 'CC BY-SA 3.0',
          sourceUrl: '${_commons}Haci_Bayram_Mosque_01.jpg',
        ),
        MockImage(
          url:
              '$_thumb/1/16/Haci_Bayram_Mosque_02.jpg/'
              '1280px-Haci_Bayram_Mosque_02.jpg',
          thumbnailUrl:
              '$_thumb/1/16/Haci_Bayram_Mosque_02.jpg/'
              '330px-Haci_Bayram_Mosque_02.jpg',
          altText: MockText(
            tr:
                'Cami ve hemen yanındaki Roma dönemi Augustus Tapınağı '
                'kalıntıları',
            en: 'The mosque beside the ruins of the Roman-era Temple of Augustus',
          ),
          author: 'Bernard Gagnon',
          license: 'CC BY-SA 3.0',
          sourceUrl: '${_commons}Haci_Bayram_Mosque_02.jpg',
        ),
        MockImage(
          url:
              '$_thumb/d/d9/Augustus_Tap%C4%B1na%C4%9F%C4%B1_ve_Hac%C4%B1_Bayram_Camii_%C3%A7evresi%2C_2023_43.jpg/'
              '1280px-Augustus_Tap%C4%B1na%C4%9F%C4%B1_ve_Hac%C4%B1_Bayram_Camii_%C3%A7evresi%2C_2023_43.jpg',
          thumbnailUrl:
              '$_thumb/d/d9/Augustus_Tap%C4%B1na%C4%9F%C4%B1_ve_Hac%C4%B1_Bayram_Camii_%C3%A7evresi%2C_2023_43.jpg/'
              '330px-Augustus_Tap%C4%B1na%C4%9F%C4%B1_ve_Hac%C4%B1_Bayram_Camii_%C3%A7evresi%2C_2023_43.jpg',
          altText: MockText(
            tr: 'Taş kaide üzerinde tuğla duvarlar ve kiremit çatı',
            en: 'Brick walls on a stone base under a tiled roof',
          ),
          author: 'Gargarapalvin',
          license: 'CC BY 4.0',
          sourceUrl:
              '${_commons}Augustus_Tap%C4%B1na%C4%9F%C4%B1_ve_Hac%C4%B1_Bayram_Camii_%C3%A7evresi%2C_2023_43.jpg',
        ),
        MockImage(
          url:
              '$_thumb/4/4b/Hac%C4%B1_Bayram_Camii_%2818315604276%29.jpg/'
              '1280px-Hac%C4%B1_Bayram_Camii_%2818315604276%29.jpg',
          thumbnailUrl:
              '$_thumb/4/4b/Hac%C4%B1_Bayram_Camii_%2818315604276%29.jpg/'
              '330px-Hac%C4%B1_Bayram_Camii_%2818315604276%29.jpg',
          altText: MockText(
            tr: 'Tuğla cephedeki yeşil sırlı hat yazısı',
            en: 'Green glazed calligraphy on the brick façade',
          ),
          author: 'Jorge Franganillo',
          license: 'CC BY 2.0',
          sourceUrl: '${_commons}Hac%C4%B1_Bayram_Camii_%2818315604276%29.jpg',
        ),
        MockImage(
          url:
              '$_thumb/c/cc/Ankara_Hac%C4%B1_Bayram_Mosque_Interior_in_2011_07.jpg/'
              '1280px-Ankara_Hac%C4%B1_Bayram_Mosque_Interior_in_2011_07.jpg',
          thumbnailUrl:
              '$_thumb/c/cc/Ankara_Hac%C4%B1_Bayram_Mosque_Interior_in_2011_07.jpg/'
              '330px-Ankara_Hac%C4%B1_Bayram_Mosque_Interior_in_2011_07.jpg',
          altText: MockText(
            tr: 'İç mekândaki kalem işi bezemeli ahşap detay',
            en: 'A painted wooden detail inside the mosque',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Ankara_Hac%C4%B1_Bayram_Mosque_Interior_in_2011_07.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'sahip-ata-kulliyesi',
      name: MockText(tr: 'Sahip Ata Külliyesi', en: 'Sahip Ata Complex'),
      // Yapıları henüz ayrı kayıt değil: sunucuda tek eser; tür Türkçe
      // addan türetilir ("Külliye" bir yapı türü değil → other).
      category: MonumentCategory.other,
      period: HistoricalPeriod.seljuk,
      city: 'Konya',
      district: 'Meram',
      address:
          'Sahibata Mahallesi, Taş Cami Uzun Hamamlar Caddesi, 42040 '
          'Meram/Konya',
      latitude: 37.867670,
      longitude: 32.494235,
      shortDescription: MockText(
        tr:
            'Anadolu Selçuklu veziri Sâhib Ata Fahreddin Ali\'nin yaptırdığı; '
            'cami, türbe, hanikâh ve hamamdan oluşan külliye.',
        en:
            'A complex of a mosque, tomb, khanqah and bathhouse commissioned '
            'by the Seljuk vizier Sâhib Ata Fahreddin Ali.',
      ),
      description: MockText(
        tr:
            'Külliyenin en dikkat çekici unsuru, mukarnaslarla bezeli '
            'Selçuklu taç kapısıdır. Türbedeki firuze ve lacivert çinilerle '
            'kaplı sandukalar Sâhib Ata ve ailesine aittir.\n\n'
            'Hanikâh bölümü bugün Vakıflar Genel Müdürlüğü\'nün Sahip Ata '
            'Vakıf Müzesi olarak hizmet vermekte; halı, kilim ve ahşap '
            'eserler sergilenmektedir.',
        en:
            'The most striking element of the complex is its Seljuk portal '
            'decorated with muqarnas. The sarcophagi clad in turquoise and '
            'dark blue tiles in the tomb belong to Sâhib Ata and his '
            'family.\n\n'
            'The khanqah now serves as the Sahip Ata Foundation Museum of the '
            'General Directorate of Foundations, displaying carpets, kilims '
            'and woodwork.',
      ),
      history: MockText(
        tr:
            "Külliyenin inşasına 1258'de cami ile başlandı; türbe, hanikâh "
            "ve hamamın eklenmesiyle 1285'e kadar tamamlandı. Mimarı Kölük "
            'bin Abdullah\'tır.\n\n'
            "Bir yangında büyük ölçüde yıkılan cami 1871'de yeniden inşa "
            'edildi; taç kapı ile mihrap özgün hâlleriyle korunmuştur.',
        en:
            'Construction began with the mosque in 1258 and the complex was '
            'completed by 1285 with the addition of the tomb, khanqah and '
            'bathhouse. Its architect was Kölük bin Abdullah.\n\n'
            'Largely destroyed in a fire, the mosque was rebuilt in 1871; the '
            'portal and the mihrab survive in their original form.',
      ),
      constructionDate: MockText.same('1258–1285'),
      founder: MockText.same('Sâhib Ata Fahreddin Ali'),
      architect: MockText.same('Kölük bin Abdullah'),
      images: [
        MockImage(
          url:
              '$_thumb/6/67/Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4509.jpg/'
              '1280px-Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4509.jpg',
          thumbnailUrl:
              '$_thumb/6/67/Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4509.jpg/'
              '330px-Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4509.jpg',
          altText: MockText(
            tr: 'Mukarnaslarla bezeli Selçuklu taç kapısı',
            en: 'The Seljuk portal decorated with muqarnas',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4509.jpg',
        ),
        MockImage(
          url:
              '$_thumb/4/4e/Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4519.jpg/'
              '1280px-Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4519.jpg',
          thumbnailUrl:
              '$_thumb/4/4e/Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4519.jpg/'
              '330px-Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4519.jpg',
          altText: MockText(
            tr: 'Külliyenin ağaçlıklı avlusu ve caminin kiremit çatısı',
            en: "The tree-lined courtyard of the complex and the mosque's tiled roof",
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4519.jpg',
        ),
        MockImage(
          url:
              '$_thumb/5/55/Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_interior_4527.jpg/'
              '1280px-Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_interior_4527.jpg',
          thumbnailUrl:
              '$_thumb/5/55/Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_interior_4527.jpg/'
              '330px-Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_interior_4527.jpg',
          altText: MockText(
            tr: 'Türbede firuze çinilerle kaplı sandukalar',
            en: 'Sarcophagi clad in turquoise tiles in the tomb',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_interior_4527.jpg',
        ),
        MockImage(
          url:
              '$_thumb/c/cc/Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_interior_4536.jpg/'
              '1280px-Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_interior_4536.jpg',
          thumbnailUrl:
              '$_thumb/c/cc/Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_interior_4536.jpg/'
              '330px-Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_interior_4536.jpg',
          altText: MockText(
            tr: 'Türbenin firuze ve lacivert çini bezemeli kubbesi',
            en: "The tomb's dome decorated with turquoise and dark blue tiles",
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_interior_4536.jpg',
        ),
        MockImage(
          url:
              '$_thumb/7/7e/Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4514.jpg/'
              '1280px-Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4514.jpg',
          thumbnailUrl:
              '$_thumb/7/7e/Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4514.jpg/'
              '330px-Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4514.jpg',
          altText: MockText(
            tr: 'Taç kapının mukarnaslı kavsarasının yakından görünümü',
            en: 'Close-up of the muqarnas hood of the portal',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Konya_Sahip_Ata_Vak%C4%B1flar_Eserleri_M%C3%BCzesi_exterior_4514.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'sultanhani-kervansarayi',
      name: MockText(
        tr: 'Sultanhanı Kervansarayı',
        en: 'Sultanhanı Caravanserai',
      ),
      category: MonumentCategory.caravanserai,
      period: HistoricalPeriod.seljuk,
      city: 'Aksaray',
      district: 'Sultanhanı',
      address: 'Zafer Mahallesi, 68802 Sultanhanı/Aksaray',
      latitude: 38.247881,
      longitude: 33.546528,
      shortDescription: MockText(
        tr:
            "Sultan I. Alaeddin Keykubad'ın 1229'da yaptırdığı, Anadolu'nun "
            'en büyük Selçuklu kervansarayı.',
        en:
            'Built in 1229 under Sultan Kayqubad I, the largest Seljuk '
            'caravanserai in Anatolia.',
      ),
      description: MockText(
        tr:
            'Konya–Aksaray kervan yolu üzerindeki yapı, 4.800 metrekareyi '
            'aşan alanıyla klasik Selçuklu kervansaray şemasını temsil eder: '
            'revaklarla çevrili açık avlu (yazlık bölüm) ve beş nefli, kapalı '
            'kışlık bölüm.\n\n'
            'Avlunun ortasındaki köşk mescit ile mukarnaslı ve geometrik '
            'bezemeli taç kapılar, Selçuklu taş işçiliğinin seçkin '
            'örnekleridir.',
        en:
            'Standing on the Konya–Aksaray caravan route and covering more '
            'than 4,800 square metres, the building represents the classic '
            'Seljuk caravanserai layout: an open courtyard surrounded by '
            'arcades (the summer section) and a covered, five-aisled winter '
            'hall.\n\n'
            'The kiosk mosque at the centre of the courtyard and the portals '
            'with muqarnas and geometric ornament are outstanding examples of '
            'Seljuk stonework.',
      ),
      history: MockText(
        tr:
            'Mimarı Şamlı Muhammed bin Havlan olan yapı, kitabesine göre '
            "1229'da tamamlandı.\n\n"
            'Bir yangında kısmen tahrip olan kervansaray, 1278\'de Sultan '
            'III. Gıyaseddin Keyhüsrev döneminde vali Seraceddin Ahmed '
            'Kerimeddin tarafından onarılarak genişletildi.',
        en:
            'Designed by Muhammad ibn Khawlan of Damascus, the building was '
            'completed in 1229 according to its inscription.\n\n'
            'Partially destroyed by a fire, the caravanserai was restored and '
            'extended in 1278 by the governor Seraceddin Ahmed Kerimeddin '
            'during the reign of Sultan Kaykhusraw III.',
      ),
      constructionDate: MockText.same('1229'),
      founder: MockText(
        tr: 'Sultan I. Alaeddin Keykubad',
        en: 'Sultan Kayqubad I',
      ),
      architect: MockText(
        tr: 'Muhammed bin Havlan',
        en: 'Muhammad ibn Khawlan',
      ),
      images: [
        MockImage(
          url:
              '$_thumb/b/b3/Sultanhan%C4%B1_Kervansaray._Sultanhan%C4%B1.jpg/'
              '1280px-Sultanhan%C4%B1_Kervansaray._Sultanhan%C4%B1.jpg',
          thumbnailUrl:
              '$_thumb/b/b3/Sultanhan%C4%B1_Kervansaray._Sultanhan%C4%B1.jpg/'
              '330px-Sultanhan%C4%B1_Kervansaray._Sultanhan%C4%B1.jpg',
          altText: MockText(
            tr: 'Kervansarayın mermer taç kapısı ve ön cephesi',
            en: 'The marble portal and front façade of the caravanserai',
          ),
          author: 'José Luis Filpo Cabana',
          license: 'CC BY 3.0',
          sourceUrl:
              '${_commons}Sultanhan%C4%B1_Kervansaray._Sultanhan%C4%B1.jpg',
        ),
        MockImage(
          url:
              '$_thumb/9/90/Sultan_Han_-_Sultanhan%C4%B1%2C_Aksaray_Province%2C_Turkey_-_October_5%2C_2025_10.jpg/'
              '1280px-Sultan_Han_-_Sultanhan%C4%B1%2C_Aksaray_Province%2C_Turkey_-_October_5%2C_2025_10.jpg',
          thumbnailUrl:
              '$_thumb/9/90/Sultan_Han_-_Sultanhan%C4%B1%2C_Aksaray_Province%2C_Turkey_-_October_5%2C_2025_10.jpg/'
              '330px-Sultan_Han_-_Sultanhan%C4%B1%2C_Aksaray_Province%2C_Turkey_-_October_5%2C_2025_10.jpg',
          altText: MockText(
            tr: 'Payanda kuleleriyle desteklenen kalın beden duvarları',
            en: 'The massive outer walls supported by buttress towers',
          ),
          author: 'Giorgio Galeotti',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Sultan_Han_-_Sultanhan%C4%B1%2C_Aksaray_Province%2C_Turkey_-_October_5%2C_2025_10.jpg',
        ),
        MockImage(
          url: '$_upload/1/1c/Turkey.Aksaray005.jpg',
          thumbnailUrl:
              '$_thumb/1/1c/Turkey.Aksaray005.jpg/330px-Turkey.Aksaray005.jpg',
          altText: MockText(
            tr: 'Revaklarla çevrili avlu (yazlık bölüm)',
            en: 'The arcaded courtyard (summer section)',
          ),
          author: 'Georges Jansoone (JoJan)',
          license: 'CC BY 3.0',
          sourceUrl: '${_commons}Turkey.Aksaray005.jpg',
        ),
        MockImage(
          url:
              '$_thumb/a/a0/20180110_Sultanhani_4511_%2840060274052%29.jpg/'
              '1280px-20180110_Sultanhani_4511_%2840060274052%29.jpg',
          thumbnailUrl:
              '$_thumb/a/a0/20180110_Sultanhani_4511_%2840060274052%29.jpg/'
              '330px-20180110_Sultanhani_4511_%2840060274052%29.jpg',
          altText: MockText(
            tr: 'Avlu cephesindeki kapılar ve taş işçiliği',
            en: 'Doorways and stonework on the courtyard façade',
          ),
          author: 'Ray Swi-hymn',
          license: 'CC BY-SA 2.0',
          sourceUrl:
              '${_commons}20180110_Sultanhani_4511_%2840060274052%29.jpg',
        ),
        MockImage(
          url: '$_upload/6/6f/Turkey.Aksaray010.jpg',
          thumbnailUrl:
              '$_thumb/6/6f/Turkey.Aksaray010.jpg/330px-Turkey.Aksaray010.jpg',
          altText: MockText(
            tr: 'Avlunun beşik tonozlu, kemerli yan revakı',
            en: 'The barrel-vaulted, arched side aisle of the courtyard',
          ),
          author: 'Georges Jansoone (JoJan)',
          license: 'CC BY 3.0',
          sourceUrl: '${_commons}Turkey.Aksaray010.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'divrigi-ulu-camii-ve-darussifasi',
      name: MockText(
        tr: 'Divriği Ulu Camii ve Darüşşifası',
        en: 'Divriği Great Mosque and Hospital',
      ),
      // Sunucuda tek eser; tür addaki son yapı sözcüğünden (Darüşşifa).
      category: MonumentCategory.hospital,
      period: HistoricalPeriod.beylik,
      city: 'Sivas',
      district: 'Divriği',
      address: 'Kemankeş Mahallesi, Ulu Cami Caddesi, 58300 Divriği/Sivas',
      latitude: 39.371309,
      longitude: 38.121892,
      shortDescription: MockText(
        tr:
            'Taç kapılarındaki eşsiz taş işçiliğiyle Türkiye\'den UNESCO Dünya '
            "Mirası Listesi'ne giren ilk mimari eser.",
        en:
            'With the extraordinary stone carving of its portals, the first '
            'architectural monument from Türkiye inscribed on the UNESCO '
            'World Heritage List.',
      ),
      description: MockText(
        tr:
            'Bitişik inşa edilmiş cami ve darüşşifadan oluşan yapı; kuzey ve '
            'batı taç kapıları ile darüşşifa kapısındaki yoğun bitkisel ve '
            'geometrik taş bezemeleriyle dünyada eşi az bulunan bir '
            'eserdir.\n\n'
            'Caminin loş iç mekânı farklı motifli taş tonozlarla örtülüdür. '
            'Darüşşifanın ortasında, aydınlık feneriyle örtülü havuzlu bir '
            'orta mekân ve dört eyvan yer alır.',
        en:
            'Made up of a mosque and a hospital built side by side, the '
            'building is almost unparalleled in the world for the dense '
            'floral and geometric stone carving of its north and west portals '
            'and the hospital gate.\n\n'
            'The dim prayer hall is covered by stone vaults, each with a '
            'different pattern. At the heart of the hospital lies a central '
            'hall with a pool beneath a lantern, surrounded by four iwans.',
      ),
      history: MockText(
        tr:
            "Cami 1228–1229'da Mengücekli beyi Ahmed Şah, darüşşifa ise aynı "
            'yıllarda eşi Turan Melek Sultan tarafından yaptırıldı. Mimarı '
            'Ahlatlı Muğis oğlu Hürrem Şah\'tır.\n\n'
            "1985'te UNESCO Dünya Mirası Listesi'ne alınan yapı, Vakıflar "
            'Genel Müdürlüğü tarafından kapsamlı biçimde restore edilmiştir.',
        en:
            'The mosque was commissioned in 1228–1229 by Ahmed Shah, the '
            'Mengujekid ruler, and the hospital in the same years by his wife '
            'Turan Melek Sultan. Its architect was Hürrem Shah of Ahlat.\n\n'
            'Inscribed on the UNESCO World Heritage List in 1985, the building '
            'has been extensively restored by the General Directorate of '
            'Foundations.',
      ),
      constructionDate: MockText.same('1228–1229'),
      founder: MockText(
        tr: 'Ahmed Şah ve Turan Melek Sultan',
        en: 'Ahmed Shah and Turan Melek Sultan',
      ),
      architect: MockText(tr: 'Hürrem Şah', en: 'Hürrem Shah'),
      isUnescoWorldHeritage: true,
      images: [
        MockImage(
          url:
              '$_thumb/4/42/Divrigi_complex_DSCF3028.jpg/'
              '1280px-Divrigi_complex_DSCF3028.jpg',
          thumbnailUrl:
              '$_thumb/4/42/Divrigi_complex_DSCF3028.jpg/'
              '330px-Divrigi_complex_DSCF3028.jpg',
          altText: MockText(
            tr: 'Yamaçta kente bakan cami ve darüşşifanın genel görünümü',
            en:
                'General view of the mosque and hospital on the hillside above '
                'the town',
          ),
          author: 'R Prazeres',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Divrigi_complex_DSCF3028.jpg',
        ),
        MockImage(
          url:
              '$_thumb/5/55/Divrigi_Hospital_portal_DSCF3213.jpg/'
              '1280px-Divrigi_Hospital_portal_DSCF3213.jpg',
          thumbnailUrl:
              '$_thumb/5/55/Divrigi_Hospital_portal_DSCF3213.jpg/'
              '330px-Divrigi_Hospital_portal_DSCF3213.jpg',
          altText: MockText(
            tr: 'Darüşşifanın yoğun taş bezemeli taç kapısı',
            en: 'The richly carved stone portal of the hospital',
          ),
          author: 'R Prazeres',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Divrigi_Hospital_portal_DSCF3213.jpg',
        ),
        MockImage(
          url:
              '$_thumb/1/1a/Divrigi_Mosque_west_portal_DSCF3171.jpg/'
              '1280px-Divrigi_Mosque_west_portal_DSCF3171.jpg',
          thumbnailUrl:
              '$_thumb/1/1a/Divrigi_Mosque_west_portal_DSCF3171.jpg/'
              '330px-Divrigi_Mosque_west_portal_DSCF3171.jpg',
          altText: MockText(
            tr: 'Caminin batı taç kapısı ve ahşap kapı kanatları',
            en: 'The western portal of the mosque with its wooden door',
          ),
          author: 'R Prazeres',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Divrigi_Mosque_west_portal_DSCF3171.jpg',
        ),
        MockImage(
          url:
              '$_thumb/e/e3/Divrigi_Mosque_interior_DSCF2585.jpg/'
              '1280px-Divrigi_Mosque_interior_DSCF2585.jpg',
          thumbnailUrl:
              '$_thumb/e/e3/Divrigi_Mosque_interior_DSCF2585.jpg/'
              '330px-Divrigi_Mosque_interior_DSCF2585.jpg',
          altText: MockText(
            tr: 'Ayaklar ve kemerlerle bölünen cami iç mekânı',
            en: 'The prayer hall divided by piers and arches',
          ),
          author: 'R Prazeres',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Divrigi_Mosque_interior_DSCF2585.jpg',
        ),
        MockImage(
          url:
              '$_thumb/c/c5/Divrigi_hospital_interior_DSCF2928.jpg/'
              '1280px-Divrigi_hospital_interior_DSCF2928.jpg',
          thumbnailUrl:
              '$_thumb/c/c5/Divrigi_hospital_interior_DSCF2928.jpg/'
              '330px-Divrigi_hospital_interior_DSCF2928.jpg',
          altText: MockText(
            tr: 'Darüşşifanın havuzlu orta mekânı ve eyvanları',
            en: 'The central hall of the hospital with its pool and iwans',
          ),
          author: 'R Prazeres',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Divrigi_hospital_interior_DSCF2928.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'diyarbakir-ulu-camii',
      name: MockText(
        tr: 'Diyarbakır Ulu Camii',
        en: 'Great Mosque of Diyarbakır',
      ),
      category: MonumentCategory.mosque,
      period: HistoricalPeriod.seljuk,
      city: 'Diyarbakır',
      district: 'Sur',
      address:
          'Cami Kebir Mahallesi, Pirinçler Sokak No:10A, 21300 '
          'Sur/Diyarbakır',
      latitude: 37.912487,
      longitude: 40.235794,
      shortDescription: MockText(
        tr:
            "Anadolu'nun en eski camilerinden biri; avlu cepheleri antik "
            'dönemden devşirme sütun ve başlıklarla bezeli.',
        en:
            'One of the oldest mosques in Anatolia, with courtyard façades '
            'adorned with columns and capitals reused from antiquity.',
      ),
      description: MockText(
        tr:
            'Geniş bir avlunun güneyinde yer alan ibadet mekânı, Şam Emevi '
            "Camii'ni hatırlatan planıyla Anadolu'da benzersizdir. Avlunun "
            'doğu ve batı cephelerindeki iki katlı revaklar, devşirme '
            'sütunlar, başlıklar ve kitabe frizleriyle süslüdür.\n\n'
            'Avluda konik çatılı şadırvan yer alır; yapı topluluğunda '
            'Mesudiye Medresesi ve Şafiiler bölümü de bulunur.',
        en:
            'The prayer hall on the south side of a large courtyard is unique '
            'in Anatolia, with a plan recalling the Umayyad Mosque of '
            'Damascus. The two-storey arcades on the east and west sides of '
            'the courtyard are adorned with reused columns, capitals and '
            'inscription friezes.\n\n'
            'The courtyard holds an ablution fountain with a conical roof; '
            'the ensemble also includes the Mesudiye Madrasa and the Shafiite '
            'prayer hall.',
      ),
      history: MockText(
        tr:
            "639'da kentin Müslüman Arapların eline geçmesinin ardından "
            'şehrin en büyük mabedinin camiye çevrilmesiyle oluşturulduğu '
            "kabul edilir. Kitabelerine göre 1091'de Büyük Selçuklu Sultanı "
            'Melikşah döneminde büyük bir onarım gördü.\n\n'
            "1115'teki yangın ve deprem sonrası yeniden yapılan bölümlerle "
            'sonraki yüzyıllarda bugünkü hâlini aldı. Avluda El-Cezerî\'ye '
            'atfedilen bir güneş saati bulunur.',
        en:
            'It is believed to have been created by converting the largest '
            'place of worship in the city into a mosque after the Muslim Arabs '
            'took the city in 639. According to its inscriptions, it was '
            'extensively repaired in 1091 under the Great Seljuk Sultan '
            'Malik-Shah.\n\n'
            'Parts rebuilt after the fire and earthquake of 1115 gave it its '
            'present form over the following centuries. The courtyard holds a '
            'sundial attributed to al-Jazari.',
      ),
      constructionDate: MockText(
        tr: '639 (1091 Selçuklu onarımı)',
        en: '639 (Seljuk restoration in 1091)',
      ),
      founder: MockText(
        tr: 'Büyük Selçuklu Sultanı Melikşah (1091 onarımı)',
        en: 'Great Seljuk Sultan Malik-Shah (1091 restoration)',
      ),
      images: [
        MockImage(
          url:
              '$_thumb/d/d0/Great_Mosque%2C_Diyarbakir.jpg/'
              '1280px-Great_Mosque%2C_Diyarbakir.jpg',
          thumbnailUrl:
              '$_thumb/d/d0/Great_Mosque%2C_Diyarbakir.jpg/'
              '330px-Great_Mosque%2C_Diyarbakir.jpg',
          altText: MockText(
            tr: 'Avludaki konik çatılı şadırvan, revaklı cepheler ve minare',
            en:
                'The conical-roofed ablution fountain, arcaded façades and '
                'minaret in the courtyard',
          ),
          author: 'Cemallamec',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Great_Mosque%2C_Diyarbakir.jpg',
        ),
        MockImage(
          url:
              '$_thumb/a/a4/Diyarbak%C4%B1r_Ulu_Cami_%C4%B0%C3%A73.jpg/'
              '1280px-Diyarbak%C4%B1r_Ulu_Cami_%C4%B0%C3%A73.jpg',
          thumbnailUrl:
              '$_thumb/a/a4/Diyarbak%C4%B1r_Ulu_Cami_%C4%B0%C3%A73.jpg/'
              '330px-Diyarbak%C4%B1r_Ulu_Cami_%C4%B0%C3%A73.jpg',
          altText: MockText(
            tr: 'Avludan görülen iki katlı revaklı cephe',
            en: 'The two-storey arcaded façade seen from the courtyard',
          ),
          author: 'Chansey',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Diyarbak%C4%B1r_Ulu_Cami_%C4%B0%C3%A73.jpg',
        ),
        MockImage(
          url:
              '$_thumb/c/cc/Diyarbak%C4%B1r_Ulu_Camii_Facade_west_of_courtyard_in_2024_7137.jpg/'
              '1280px-Diyarbak%C4%B1r_Ulu_Camii_Facade_west_of_courtyard_in_2024_7137.jpg',
          thumbnailUrl:
              '$_thumb/c/cc/Diyarbak%C4%B1r_Ulu_Camii_Facade_west_of_courtyard_in_2024_7137.jpg/'
              '330px-Diyarbak%C4%B1r_Ulu_Camii_Facade_west_of_courtyard_in_2024_7137.jpg',
          altText: MockText(
            tr: 'Batı cephesindeki devşirme sütunlar ve kitabe frizi',
            en: 'Reused columns and an inscription frieze on the west façade',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Diyarbak%C4%B1r_Ulu_Camii_Facade_west_of_courtyard_in_2024_7137.jpg',
        ),
        MockImage(
          url:
              '$_thumb/a/a0/Diyarbak%C4%B1r_Ulu_Cami_s%C3%BCsleme.jpg/'
              '1280px-Diyarbak%C4%B1r_Ulu_Cami_s%C3%BCsleme.jpg',
          thumbnailUrl:
              '$_thumb/a/a0/Diyarbak%C4%B1r_Ulu_Cami_s%C3%BCsleme.jpg/'
              '330px-Diyarbak%C4%B1r_Ulu_Cami_s%C3%BCsleme.jpg',
          altText: MockText(
            tr: 'Giriş kapısındaki aslan ve boğa kabartması',
            en: 'The lion-and-bull relief at the entrance',
          ),
          author: 'Chansey',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Diyarbak%C4%B1r_Ulu_Cami_s%C3%BCsleme.jpg',
        ),
        MockImage(
          url:
              '$_thumb/2/20/8.30_Diyarbakir_-_Olu_Cami_%2832%29.jpg/'
              '1280px-8.30_Diyarbakir_-_Olu_Cami_%2832%29.jpg',
          thumbnailUrl:
              '$_thumb/2/20/8.30_Diyarbakir_-_Olu_Cami_%2832%29.jpg/'
              '330px-8.30_Diyarbakir_-_Olu_Cami_%2832%29.jpg',
          altText: MockText(
            tr: 'İbadet mekânındaki mihrap ve minber',
            en: 'The mihrab and minbar in the prayer hall',
          ),
          author: 'Giovanni Colpani',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}8.30_Diyarbakir_-_Olu_Cami_%2832%29.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'gulbahar-hatun-camii',
      name: MockText(tr: 'Gülbahar Hatun Camii', en: 'Gülbahar Hatun Mosque'),
      category: MonumentCategory.mosque,
      period: HistoricalPeriod.ottoman,
      city: 'Trabzon',
      district: 'Ortahisar',
      address:
          'Gülbaharhatun Mahallesi, Yavuz Selim Bulvarı, 61030 '
          'Ortahisar/Trabzon',
      latitude: 41.003388,
      longitude: 39.716073,
      shortDescription: MockText(
        tr:
            'Yavuz Sultan Selim\'in annesi Gülbahar Hatun adına 1514\'te '
            "yaptırdığı, Trabzon'un en önemli Osmanlı camilerinden biri.",
        en:
            'Built in 1514 by Sultan Selim I in honour of his mother Gülbahar '
            'Hatun, one of the most important Ottoman mosques in Trabzon.',
      ),
      description: MockText(
        tr:
            'Büyük İmaret Camii ve Hatuniye Camii adlarıyla da bilinen yapı; '
            'beş küçük kubbeyle örtülü beş bölümlü son cemaat yeri, büyük tek '
            'kubbeli harimi ve doğu ile batıdaki kubbeli zaviye odalarından '
            'oluşur.\n\n'
            'Son cemaat yerindeki mermer sütunlar baklava başlıklıdır; mihrap '
            've minber de mermerdendir. Gülbahar Hatun\'un türbesi caminin '
            'doğusundadır.',
        en:
            'Also known as the Great Imaret Mosque and the Hatuniye Mosque, '
            'the building consists of a five-bay portico covered by five small '
            'domes, a prayer hall under a single large dome, and domed lodge '
            'rooms to the east and west.\n\n'
            'The marble columns of the portico have lozenge capitals, and the '
            'mihrab and minbar are also of marble. The tomb of Gülbahar Hatun '
            'stands to the east of the mosque.',
      ),
      history: MockText(
        tr:
            'Cami, Yavuz Sultan Selim tarafından annesi Gülbahar Hatun\'un '
            "anısına 1514'te yaptırıldı. Zamanında medrese, mektep, imaret ve "
            'hamamla birlikte büyük bir külliye oluşturuyordu.\n\n'
            'Külliyenin diğer yapıları günümüze ulaşmamış; yalnızca cami ve '
            'doğusundaki türbe ayakta kalmıştır.',
        en:
            'The mosque was built in 1514 by Sultan Selim I in memory of his '
            'mother Gülbahar Hatun. In its time it formed a large complex '
            'together with a madrasa, a school, a public kitchen and a '
            'bathhouse.\n\n'
            'The other buildings of the complex have not survived; only the '
            'mosque and the tomb to its east still stand.',
      ),
      constructionDate: MockText.same('1514'),
      founder: MockText(tr: 'Yavuz Sultan Selim', en: 'Sultan Selim I'),
      images: [
        MockImage(
          url:
              '$_thumb/c/cc/G%C3%BClbahar_Hatun_Mosque.JPG/'
              '1280px-G%C3%BClbahar_Hatun_Mosque.JPG',
          thumbnailUrl:
              '$_thumb/c/cc/G%C3%BClbahar_Hatun_Mosque.JPG/'
              '330px-G%C3%BClbahar_Hatun_Mosque.JPG',
          altText: MockText(
            tr: 'Revaklı son cemaat yeri ve minaresiyle Gülbahar Hatun Camii',
            en: 'The Gülbahar Hatun Mosque with its arcaded portico and minaret',
          ),
          author: 'Alaexis',
          license: 'CC BY-SA 3.0',
          sourceUrl: '${_commons}G%C3%BClbahar_Hatun_Mosque.JPG',
        ),
        MockImage(
          url:
              '$_thumb/3/34/Trabzon_G%C3%BClbahar_Hatun_Mosque_4931.jpg/'
              '1280px-Trabzon_G%C3%BClbahar_Hatun_Mosque_4931.jpg',
          thumbnailUrl:
              '$_thumb/3/34/Trabzon_G%C3%BClbahar_Hatun_Mosque_4931.jpg/'
              '330px-Trabzon_G%C3%BClbahar_Hatun_Mosque_4931.jpg',
          altText: MockText(
            tr: 'Caminin kubbesi, minaresi ve yanındaki türbe',
            en: "The mosque's dome and minaret beside the tomb",
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Trabzon_G%C3%BClbahar_Hatun_Mosque_4931.jpg',
        ),
        MockImage(
          url:
              '$_thumb/0/07/Trebisonda%2C_moschea_di_G%C3%BClbahar_Hatun%2C_completata_nel_1514_da_selim_in_onore_di_sua_madre%2C_esterno_02.jpg/'
              '1280px-Trebisonda%2C_moschea_di_G%C3%BClbahar_Hatun%2C_completata_nel_1514_da_selim_in_onore_di_sua_madre%2C_esterno_02.jpg',
          thumbnailUrl:
              '$_thumb/0/07/Trebisonda%2C_moschea_di_G%C3%BClbahar_Hatun%2C_completata_nel_1514_da_selim_in_onore_di_sua_madre%2C_esterno_02.jpg/'
              '330px-Trebisonda%2C_moschea_di_G%C3%BClbahar_Hatun%2C_completata_nel_1514_da_selim_in_onore_di_sua_madre%2C_esterno_02.jpg',
          altText: MockText(
            tr: 'Avludaki şadırvan ve caminin cephesi',
            en: "The ablution fountain in the courtyard and the mosque's façade",
          ),
          author: 'Francesco Bini',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Trebisonda%2C_moschea_di_G%C3%BClbahar_Hatun%2C_completata_nel_1514_da_selim_in_onore_di_sua_madre%2C_esterno_02.jpg',
        ),
        MockImage(
          url:
              '$_thumb/b/b3/Trebisonda%2C_moschea_di_G%C3%BClbahar_Hatun%2C_completata_nel_1514_da_selim_in_onore_di_sua_madre%2C_interno_01.jpg/'
              '1280px-Trebisonda%2C_moschea_di_G%C3%BClbahar_Hatun%2C_completata_nel_1514_da_selim_in_onore_di_sua_madre%2C_interno_01.jpg',
          thumbnailUrl:
              '$_thumb/b/b3/Trebisonda%2C_moschea_di_G%C3%BClbahar_Hatun%2C_completata_nel_1514_da_selim_in_onore_di_sua_madre%2C_interno_01.jpg/'
              '330px-Trebisonda%2C_moschea_di_G%C3%BClbahar_Hatun%2C_completata_nel_1514_da_selim_in_onore_di_sua_madre%2C_interno_01.jpg',
          altText: MockText(
            tr: 'Mihrap, minber ve avizelerle iç mekân',
            en: 'The interior with the mihrab, minbar and chandeliers',
          ),
          author: 'Francesco Bini',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Trebisonda%2C_moschea_di_G%C3%BClbahar_Hatun%2C_completata_nel_1514_da_selim_in_onore_di_sua_madre%2C_interno_01.jpg',
        ),
        MockImage(
          url:
              '$_thumb/9/90/Trabzon_G%C3%BClbahar_Hatun_Mosque_and_mausoleum_4930.jpg/'
              '1280px-Trabzon_G%C3%BClbahar_Hatun_Mosque_and_mausoleum_4930.jpg',
          thumbnailUrl:
              '$_thumb/9/90/Trabzon_G%C3%BClbahar_Hatun_Mosque_and_mausoleum_4930.jpg/'
              '330px-Trabzon_G%C3%BClbahar_Hatun_Mosque_and_mausoleum_4930.jpg',
          altText: MockText(
            tr: 'Gülbahar Hatun Türbesi ve caminin yan cephesi',
            en: 'The Tomb of Gülbahar Hatun and the side of the mosque',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Trabzon_G%C3%BClbahar_Hatun_Mosque_and_mausoleum_4930.jpg',
        ),
      ],
    ),
  ];
}
