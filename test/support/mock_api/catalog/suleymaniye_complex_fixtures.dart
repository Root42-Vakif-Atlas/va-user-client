import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';

import 'catalog_fixtures.dart';

/// Süleymaniye Külliyesi ve (Süleymaniye Camii dışındaki) yapıları.
///
/// Konumlar OpenStreetMap ve Wikidata'dan (yapı merkezleri), tarih/bani
/// bilgileri Wikipedia (TR/EN) ile doğrulanmıştır. Süleymaniye Camii
/// `CatalogFixtures`'ta durur ve [complexId] ile bu külliyeye bağlıdır.
abstract final class SuleymaniyeComplexFixtures {
  static const String complexId = 'suleymaniye-kulliyesi';

  static const String _commons = 'https://commons.wikimedia.org/wiki/File:';
  static const String _thumb =
      'https://thumb.wikimedia.org/wikipedia/commons/thumb';

  static const MockText _founder = MockText(
    tr: 'Kanuni Sultan Süleyman',
    en: 'Suleiman the Magnificent',
  );
  static const MockText _sinan = MockText.same('Mimar Sinan');
  static const String _address = 'Süleymaniye Mahallesi, 34116 Fatih/İstanbul';

  static const MockMonument complex = MockMonument(
    id: complexId,
    name: MockText(tr: 'Süleymaniye Külliyesi', en: 'Süleymaniye Complex'),
    category: MonumentCategory.complex,
    period: HistoricalPeriod.ottoman,
    city: 'İstanbul',
    district: 'Fatih',
    address: _address,
    latitude: 41.016100,
    longitude: 28.963700,
    shortDescription: MockText(
      tr:
          'Cami, medreseler, darüşşifa, imaret, hamam ve türbelerden oluşan, '
          "Mimar Sinan'ın İstanbul'un Üçüncü Tepesi'ne yerleştirdiği "
          'imparatorluk külliyesi.',
      en:
          'The imperial complex of a mosque, madrasas, a hospital, a public '
          'kitchen, a bathhouse and tombs that Mimar Sinan laid out on '
          "Istanbul's Third Hill.",
    ),
    description: MockText(
      tr:
          'Süleymaniye Külliyesi, merkezdeki caminin çevresine eğimli araziye '
          'göre kademelendirilmiş yapılardan oluşan bir yapı topluluğudur. '
          'Eğitim (medreseler, darülhadis, darülkurra, sıbyan mektebi), sağlık '
          '(darüşşifa, tıp medresesi), sosyal yardım (imaret, tabhane) ve '
          'gündelik yaşam (hamam, arasta) işlevlerini tek bir vakıf düzeninde '
          'bir araya getirir.\n\n'
          "Kanuni Sultan Süleyman ile Hürrem Sultan'ın türbeleri caminin kıble "
          "tarafındaki hazirede, Mimar Sinan'ın kendi türbesi ise külliyenin "
          'kuzey köşesindedir.',
      en:
          'The Süleymaniye Complex is a group of buildings stepped down the '
          'slope around the central mosque. It brings education (madrasas, a '
          "school of hadith, a school of Qur'an recitation, a primary school), "
          'health (a hospital and a medical school), charity (a public kitchen '
          'and a guesthouse) and daily life (a bathhouse and a market street) '
          'together under a single endowment.\n\n'
          'The tombs of Suleiman the Magnificent and Hürrem Sultan stand in the '
          "cemetery on the qibla side of the mosque, and Mimar Sinan's own tomb "
          'at the northern corner of the complex.',
    ),
    history: MockText(
      tr:
          "Külliyenin inşasına 1550'de başlandı; cami 1557'de ibadete açıldı, "
          'diğer yapılar aynı yıllarda tamamlandı. Yapıların bir kısmı bugün '
          'özgün işlevini, bir kısmı kütüphane ve lokanta gibi yeni işlevlerle '
          'sürdürmektedir.\n\n'
          "Külliye, \"İstanbul'un Tarihî Alanları\" kapsamında 1985'ten bu "
          "yana UNESCO Dünya Mirası Listesi'ndedir.",
      en:
          'Construction began in 1550; the mosque opened for worship in 1557 '
          'and the other buildings were completed in the same years. Some '
          'buildings keep their original function today, while others serve '
          'new ones such as a library or a restaurant.\n\n'
          'As part of the "Historic Areas of Istanbul", the complex has been '
          'on the UNESCO World Heritage List since 1985.',
    ),
    constructionDate: MockText.same('1550–1557'),
    founder: _founder,
    architect: _sinan,
    isUnescoWorldHeritage: true,
    images: [
      MockImage(
        url:
            '$_thumb/3/3a/Istanbul_S%C3%BCleymaniye_complex_in_2009_7047.jpg/'
            '1280px-Istanbul_S%C3%BCleymaniye_complex_in_2009_7047.jpg',
        thumbnailUrl:
            '$_thumb/3/3a/Istanbul_S%C3%BCleymaniye_complex_in_2009_7047.jpg/'
            '330px-Istanbul_S%C3%BCleymaniye_complex_in_2009_7047.jpg',
        altText: MockText(
          tr:
              'Külliyenin taş duvarları arasından yükselen Süleymaniye Camii '
              'kubbesi ve minaresi',
          en:
              'The dome and a minaret of the Süleymaniye Mosque rising beyond '
              'the stone walls of the complex',
        ),
        author: 'Dosseman',
        license: 'CC BY-SA 4.0',
        sourceUrl:
            '${_commons}Istanbul_S%C3%BCleymaniye_complex_in_2009_7047.jpg',
      ),
      MockImage(
        url:
            '$_thumb/9/94/Istanbul_Suleymaniye_complex_from_outside_in_2017_3434.jpg/'
            '1280px-Istanbul_Suleymaniye_complex_from_outside_in_2017_3434.jpg',
        thumbnailUrl:
            '$_thumb/9/94/Istanbul_Suleymaniye_complex_from_outside_in_2017_3434.jpg/'
            '330px-Istanbul_Suleymaniye_complex_from_outside_in_2017_3434.jpg',
        altText: MockText(
          tr: 'Külliye yapılarının kubbeli çatıları ve yüksek dış duvarı',
          en: 'The domed roofs and high outer wall of the complex buildings',
        ),
        author: 'Dosseman',
        license: 'CC BY-SA 4.0',
        sourceUrl:
            '${_commons}Istanbul_Suleymaniye_complex_from_outside_in_2017_3434.jpg',
      ),
      MockImage(
        url:
            '$_thumb/b/b9/Istanbul_Suleymaniye_complex_in_2017_3643.jpg/'
            '1280px-Istanbul_Suleymaniye_complex_in_2017_3643.jpg',
        thumbnailUrl:
            '$_thumb/b/b9/Istanbul_Suleymaniye_complex_in_2017_3643.jpg/'
            '330px-Istanbul_Suleymaniye_complex_in_2017_3643.jpg',
        altText: MockText(
          tr: 'Külliyenin iki yapısı arasındaki dar taş geçit',
          en: 'A narrow stone passage between two buildings of the complex',
        ),
        author: 'Dosseman',
        license: 'CC BY-SA 4.0',
        sourceUrl: '${_commons}Istanbul_Suleymaniye_complex_in_2017_3643.jpg',
      ),
    ],
  );

  /// Süleymaniye Camii dışındaki üyeler, külliyedeki sıralarıyla.
  static const List<MockMonument> members = [
    MockMonument(
      id: 'kanuni-sultan-suleyman-turbesi',
      name: MockText(
        tr: 'Kanuni Sultan Süleyman Türbesi',
        en: 'Tomb of Suleiman the Magnificent',
      ),
      category: MonumentCategory.tomb,
      period: HistoricalPeriod.ottoman,
      city: 'İstanbul',
      district: 'Fatih',
      address: _address,
      latitude: 41.015690,
      longitude: 28.964469,
      complexId: complexId,
      complexOrder: 2,
      shortDescription: MockText(
        tr:
            'Kanuni Sultan Süleyman\'ın, revaklarla çevrili sekizgen planlı '
            'türbesi.',
        en:
            'The octagonal tomb of Suleiman the Magnificent, surrounded by a '
            'colonnaded portico.',
      ),
      description: MockText(
        tr:
            'Caminin kıble tarafındaki hazirede yer alan türbe, dışta sütunlu '
            'bir revakla çevrili sekizgen bir gövde ve çift kabuklu bir '
            'kubbeyle örtülüdür. İç mekân İznik çinileri ve kalem işleriyle '
            'bezelidir.\n\n'
            'Türbede Kanuni Sultan Süleyman\'ın yanı sıra II. Süleyman ve '
            'II. Ahmed de yatmaktadır.',
        en:
            'Standing in the cemetery on the qibla side of the mosque, the '
            'tomb is an octagonal body surrounded by a colonnaded portico and '
            'covered by a double-shelled dome. The interior is decorated with '
            'İznik tiles and painted ornament.\n\n'
            'Besides Suleiman the Magnificent, Suleiman II and Ahmed II are '
            'also buried here.',
      ),
      history: MockText(
        tr:
            "Kanuni Sultan Süleyman'ın 1566'da Zigetvar seferinde ölümünün "
            'ardından Mimar Sinan tarafından inşa edildi.',
        en:
            'It was built by Mimar Sinan after Suleiman the Magnificent died '
            'on the Szigetvár campaign in 1566.',
      ),
      constructionDate: MockText.same('1566'),
      founder: MockText(tr: 'Sultan II. Selim', en: 'Sultan Selim II'),
      architect: _sinan,
      isUnescoWorldHeritage: true,
      images: [
        MockImage(
          url:
              '$_thumb/5/50/Sultan_S%C3%BCleyman_T%C3%BCrbesi_01.jpg/'
              '1280px-Sultan_S%C3%BCleyman_T%C3%BCrbesi_01.jpg',
          thumbnailUrl:
              '$_thumb/5/50/Sultan_S%C3%BCleyman_T%C3%BCrbesi_01.jpg/'
              '330px-Sultan_S%C3%BCleyman_T%C3%BCrbesi_01.jpg',
          altText: MockText(
            tr: 'Sütunlu revakla çevrili sekizgen türbe ve kubbesi',
            en: 'The octagonal tomb and its dome, surrounded by a colonnade',
          ),
          author: 'Bernard Gagnon',
          license: 'CC BY-SA 3.0',
          sourceUrl: '${_commons}Sultan_S%C3%BCleyman_T%C3%BCrbesi_01.jpg',
        ),
        MockImage(
          url:
              '$_thumb/0/0f/Sultan_S%C3%BCleyman_T%C3%BCrbesi_02.jpg/'
              '1280px-Sultan_S%C3%BCleyman_T%C3%BCrbesi_02.jpg',
          thumbnailUrl:
              '$_thumb/0/0f/Sultan_S%C3%BCleyman_T%C3%BCrbesi_02.jpg/'
              '330px-Sultan_S%C3%BCleyman_T%C3%BCrbesi_02.jpg',
          altText: MockText(
            tr: 'Türbenin girişi ve revak sütunları',
            en: 'The entrance of the tomb and the portico columns',
          ),
          author: 'Bernard Gagnon',
          license: 'CC BY-SA 3.0',
          sourceUrl: '${_commons}Sultan_S%C3%BCleyman_T%C3%BCrbesi_02.jpg',
        ),
        MockImage(
          url:
              '$_thumb/3/35/Istanbul_Suleyman_Mausoleum_exterior_porch_on_columns_in_2018_5431.jpg/'
              '1280px-Istanbul_Suleyman_Mausoleum_exterior_porch_on_columns_in_2018_5431.jpg',
          thumbnailUrl:
              '$_thumb/3/35/Istanbul_Suleyman_Mausoleum_exterior_porch_on_columns_in_2018_5431.jpg/'
              '330px-Istanbul_Suleyman_Mausoleum_exterior_porch_on_columns_in_2018_5431.jpg',
          altText: MockText(
            tr: 'Türbe revakından hazirenin mezar taşlarına bakış',
            en: 'View from the tomb portico onto the gravestones of the cemetery',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Istanbul_Suleyman_Mausoleum_exterior_porch_on_columns_in_2018_5431.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'hurrem-sultan-turbesi',
      name: MockText(tr: 'Hürrem Sultan Türbesi', en: 'Tomb of Hürrem Sultan'),
      category: MonumentCategory.tomb,
      period: HistoricalPeriod.ottoman,
      city: 'İstanbul',
      district: 'Fatih',
      address: _address,
      latitude: 41.015668,
      longitude: 28.964809,
      complexId: complexId,
      complexOrder: 3,
      shortDescription: MockText(
        tr: "Hürrem Sultan'ın İznik çinileriyle bezeli sekizgen türbesi.",
        en: 'The octagonal tomb of Hürrem Sultan, decorated with İznik tiles.',
      ),
      description: MockText(
        tr:
            'Kanuni türbesinin yanında yer alan sekizgen planlı, tek kubbeli '
            'türbenin iç duvarları klasik dönemin en seçkin İznik çinileriyle '
            'kaplıdır.',
        en:
            'Next to the tomb of Suleiman, this octagonal, single-domed tomb '
            'has interior walls clad in some of the finest İznik tiles of the '
            'classical period.',
      ),
      history: MockText(
        tr:
            "Hürrem Sultan'ın 1558'deki ölümünün ardından Mimar Sinan "
            'tarafından inşa edildi.',
        en: 'It was built by Mimar Sinan after Hürrem Sultan died in 1558.',
      ),
      constructionDate: MockText.same('1558'),
      founder: _founder,
      architect: _sinan,
      isUnescoWorldHeritage: true,
      images: [
        MockImage(
          url:
              '$_thumb/2/2c/H%C3%BCrrem_Sultan_T%C3%BCrbesi_-_panoramio.jpg/'
              '1280px-H%C3%BCrrem_Sultan_T%C3%BCrbesi_-_panoramio.jpg',
          thumbnailUrl:
              '$_thumb/2/2c/H%C3%BCrrem_Sultan_T%C3%BCrbesi_-_panoramio.jpg/'
              '330px-H%C3%BCrrem_Sultan_T%C3%BCrbesi_-_panoramio.jpg',
          altText: MockText(
            tr: 'Sekizgen gövdeli, kubbeli türbenin dış görünümü',
            en: 'Exterior of the octagonal, domed tomb',
          ),
          author: 'Aziz Akbiyik',
          license: 'CC BY-SA 3.0',
          sourceUrl:
              '${_commons}H%C3%BCrrem_Sultan_T%C3%BCrbesi_-_panoramio.jpg',
        ),
        MockImage(
          url:
              '$_thumb/f/fe/Mausoleum_of_Roxelana_02.jpg/'
              '1280px-Mausoleum_of_Roxelana_02.jpg',
          thumbnailUrl:
              '$_thumb/f/fe/Mausoleum_of_Roxelana_02.jpg/'
              '330px-Mausoleum_of_Roxelana_02.jpg',
          altText: MockText(
            tr: 'Çinilerle kaplı iç mekân ve ahşap sandukalar',
            en: 'The tiled interior and the wooden cenotaphs',
          ),
          author: 'Bernard Gagnon',
          license: 'CC BY-SA 3.0',
          sourceUrl: '${_commons}Mausoleum_of_Roxelana_02.jpg',
        ),
        MockImage(
          url:
              '$_thumb/c/c4/Istanbul_Roxelane_Mausoleum_in_2017_3635.jpg/'
              '1280px-Istanbul_Roxelane_Mausoleum_in_2017_3635.jpg',
          thumbnailUrl:
              '$_thumb/c/c4/Istanbul_Roxelane_Mausoleum_in_2017_3635.jpg/'
              '330px-Istanbul_Roxelane_Mausoleum_in_2017_3635.jpg',
          altText: MockText(
            tr: 'Kemerli bir pano içinde mavi zeminli İznik çinileri',
            en: 'Blue-ground İznik tiles within an arched panel',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Istanbul_Roxelane_Mausoleum_in_2017_3635.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'suleymaniye-evvel-ve-sani-medreseleri',
      name: MockText(
        tr: 'Evvel ve Sani Medreseleri',
        en: 'First and Second Madrasas',
      ),
      category: MonumentCategory.madrasa,
      period: HistoricalPeriod.ottoman,
      city: 'İstanbul',
      district: 'Fatih',
      address:
          'Süleymaniye Mahallesi, Ayşekadın Hamamı Sokak No:35, '
          '34116 Fatih/İstanbul',
      latitude: 41.015541,
      longitude: 28.962701,
      complexId: complexId,
      complexOrder: 4,
      shortDescription: MockText(
        tr:
            "Bugün Süleymaniye Yazma Eser Kütüphanesi'ne ev sahipliği yapan "
            'ikiz medreseler.',
        en:
            'Twin madrasas that today house the Süleymaniye Manuscript '
            'Library.',
      ),
      description: MockText(
        tr:
            'Caminin batısında, aralarındaki sokakla birbirine bakan iki '
            'medrese revaklı avlular çevresine dizilmiş kubbeli odalardan '
            'oluşur. Külliyenin yüksek öğretim kurumlarının ilk ikisidir.',
        en:
            'West of the mosque, two madrasas facing each other across a lane '
            'consist of domed rooms arranged around arcaded courtyards. They '
            'were the first two of the higher-education schools of the '
            'complex.',
      ),
      history: MockText(
        tr:
            'Külliyeyle birlikte 1550–1557 yıllarında inşa edildi. 1918\'den '
            "bu yana Türkiye'nin en büyük yazma eser kütüphanelerinden "
            'Süleymaniye Kütüphanesi olarak kullanılmaktadır.',
        en:
            'Built together with the complex in 1550–1557. Since 1918 they '
            "have housed the Süleymaniye Library, one of Türkiye's largest "
            'manuscript collections.',
      ),
      constructionDate: MockText.same('1550–1557'),
      founder: _founder,
      architect: _sinan,
      isUnescoWorldHeritage: true,
      images: [
        MockImage(
          url:
              '$_thumb/f/fd/S%C3%BCleymaniye_Library.jpg/'
              '1280px-S%C3%BCleymaniye_Library.jpg',
          thumbnailUrl:
              '$_thumb/f/fd/S%C3%BCleymaniye_Library.jpg/'
              '330px-S%C3%BCleymaniye_Library.jpg',
          altText: MockText(
            tr: 'Gece aydınlatılmış kubbeli medrese cephesi ve kütüphane girişi',
            en: 'The lit domed madrasa façade and library entrance at night',
          ),
          author: 'Михал Орела',
          license: 'CC BY 2.0',
          sourceUrl: '${_commons}S%C3%BCleymaniye_Library.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'suleymaniye-salis-ve-rabi-medreseleri',
      name: MockText(
        tr: 'Salis ve Rabi Medreseleri',
        en: 'Third and Fourth Madrasas',
      ),
      category: MonumentCategory.madrasa,
      period: HistoricalPeriod.ottoman,
      city: 'İstanbul',
      district: 'Fatih',
      address: _address,
      latitude: 41.016419,
      longitude: 28.965045,
      complexId: complexId,
      complexOrder: 5,
      shortDescription: MockText(
        tr: "Haliç'e doğru inen yamaca kademeli olarak yerleşen ikiz medreseler.",
        en: 'Twin madrasas stepped down the slope towards the Golden Horn.',
      ),
      description: MockText(
        tr:
            'Caminin doğusundaki medreseler, eğime uyacak biçimde basamaklar '
            'halinde yükselen odalar ve kubbelerle tasarlanmıştır; avlularından '
            "Haliç ve Boğaz'a uzanan bir manzara açılır.",
        en:
            'East of the mosque, the madrasas were designed with rooms and '
            'domes rising in steps to follow the slope; their courtyards open '
            'onto views of the Golden Horn and the Bosphorus.',
      ),
      history: MockText(
        tr:
            'Külliyeyle birlikte 1550–1557 yıllarında inşa edildi; uzun yıllar '
            'farklı eğitim kurumlarına ev sahipliği yaptı.',
        en:
            'Built together with the complex in 1550–1557; over the years they '
            'have housed various educational institutions.',
      ),
      constructionDate: MockText.same('1550–1557'),
      founder: _founder,
      architect: _sinan,
      isUnescoWorldHeritage: true,
      images: [
        MockImage(
          url:
              '$_thumb/3/3c/Suleymaniye_kulliyesi_medrese_i_salis.jpeg/'
              '1280px-Suleymaniye_kulliyesi_medrese_i_salis.jpeg',
          thumbnailUrl:
              '$_thumb/3/3c/Suleymaniye_kulliyesi_medrese_i_salis.jpeg/'
              '330px-Suleymaniye_kulliyesi_medrese_i_salis.jpeg',
          altText: MockText(
            tr: 'Revaklarla çevrili avlu ve kubbeli dershane',
            en: 'The arcaded courtyard and the domed lecture hall',
          ),
          author: 'Sp!ros',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Suleymaniye_kulliyesi_medrese_i_salis.jpeg',
        ),
        MockImage(
          url:
              '$_thumb/2/23/Medrese-i-Salis_overlooking_Bosphorus_Strait.jpg/'
              '1280px-Medrese-i-Salis_overlooking_Bosphorus_Strait.jpg',
          thumbnailUrl:
              '$_thumb/2/23/Medrese-i-Salis_overlooking_Bosphorus_Strait.jpg/'
              '330px-Medrese-i-Salis_overlooking_Bosphorus_Strait.jpg',
          altText: MockText(
            tr: 'Kademeli medrese kubbeleri ve ardında İstanbul manzarası',
            en: 'The stepped madrasa domes with the Istanbul skyline beyond',
          ),
          author: 'Husain007',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Medrese-i-Salis_overlooking_Bosphorus_Strait.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'suleymaniye-darulkurrasi',
      name: MockText(
        tr: 'Süleymaniye Darülkurrası',
        en: "Süleymaniye School of Qur'an Recitation",
      ),
      category: MonumentCategory.madrasa,
      period: HistoricalPeriod.ottoman,
      city: 'İstanbul',
      district: 'Fatih',
      address: _address,
      latitude: 41.015434,
      longitude: 28.964800,
      complexId: complexId,
      complexOrder: 6,
      shortDescription: MockText(
        tr: "Kur'an'ın kıraat kurallarıyla okunmasının öğretildiği okul.",
        en: "The school where the rules of Qur'an recitation were taught.",
      ),
      description: MockText(
        tr:
            'Türbelerin güneyindeki küçük, kesme taş yapı tek bir kubbeli '
            'mekândan oluşur ve külliyenin özel eğitim kurumlarından biridir.',
        en:
            'South of the tombs, this small cut-stone building consists of a '
            'single domed space and was one of the specialised schools of the '
            'complex.',
      ),
      history: MockText(
        tr: 'Külliyenin yapım sürecinde, 1550–1557 yıllarında inşa edildi.',
        en: 'Built during the construction of the complex, in 1550–1557.',
      ),
      constructionDate: MockText.same('1550–1557'),
      founder: _founder,
      architect: _sinan,
      isUnescoWorldHeritage: true,
      images: [
        MockImage(
          url:
              '$_thumb/2/2a/S%C3%BCleymaniye_Dar%C3%BClkurras%C4%B1.jpg/'
              '1280px-S%C3%BCleymaniye_Dar%C3%BClkurras%C4%B1.jpg',
          thumbnailUrl:
              '$_thumb/2/2a/S%C3%BCleymaniye_Dar%C3%BClkurras%C4%B1.jpg/'
              '330px-S%C3%BCleymaniye_Dar%C3%BClkurras%C4%B1.jpg',
          altText: MockText(
            tr: 'Ağaçlar arasında kesme taş darülkurra yapısı',
            en: 'The cut-stone recitation school among trees',
          ),
          author: 'Özgür Arda BAYRAM',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}S%C3%BCleymaniye_Dar%C3%BClkurras%C4%B1.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'suleymaniye-darussifasi',
      name: MockText(tr: 'Süleymaniye Darüşşifası', en: 'Süleymaniye Hospital'),
      category: MonumentCategory.hospital,
      period: HistoricalPeriod.ottoman,
      city: 'İstanbul',
      district: 'Fatih',
      address: _address,
      latitude: 41.016272,
      longitude: 28.961790,
      complexId: complexId,
      complexOrder: 7,
      shortDescription: MockText(
        tr: 'Külliyenin hastanesi; hemen yanındaki tıp medresesiyle birlikte.',
        en: 'The hospital of the complex, next to its medical school.',
      ),
      description: MockText(
        tr:
            'Külliyenin kuzeybatı köşesindeki darüşşifa, avlular çevresine '
            'dizilmiş hasta odalarından oluşur. Yanındaki tıp medresesiyle '
            'birlikte tedavi ve tıp eğitimini bir arada sunuyordu.',
        en:
            'At the north-western corner of the complex, the hospital consists '
            'of patient rooms arranged around courtyards. Together with the '
            'medical school next to it, it combined treatment and medical '
            'training.',
      ),
      history: MockText(
        tr:
            'Külliyeyle birlikte 1550–1557 yıllarında inşa edildi; Osmanlı '
            'döneminde hastane olarak hizmet verdi, sonraki dönemlerde farklı '
            'işlevler üstlendi.',
        en:
            'Built together with the complex in 1550–1557; it served as a '
            'hospital in the Ottoman period and took on other uses later.',
      ),
      constructionDate: MockText.same('1550–1557'),
      founder: _founder,
      architect: _sinan,
      isUnescoWorldHeritage: true,
      images: [
        MockImage(
          url:
              '$_thumb/d/de/Suleymaniye_complex_DSCF3474.jpg/'
              '1280px-Suleymaniye_complex_DSCF3474.jpg',
          thumbnailUrl:
              '$_thumb/d/de/Suleymaniye_complex_DSCF3474.jpg/'
              '330px-Suleymaniye_complex_DSCF3474.jpg',
          altText: MockText(
            tr: 'Darüşşifanın kesme taş duvarı, kapısı ve kubbesi',
            en: 'The cut-stone wall, gate and dome of the hospital',
          ),
          author: 'R Prazeres',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Suleymaniye_complex_DSCF3474.jpg',
        ),
        MockImage(
          url:
              '$_thumb/8/82/Suleymaniye_complex_DSCF3475.jpg/'
              '1280px-Suleymaniye_complex_DSCF3475.jpg',
          thumbnailUrl:
              '$_thumb/8/82/Suleymaniye_complex_DSCF3475.jpg/'
              '330px-Suleymaniye_complex_DSCF3475.jpg',
          altText: MockText(
            tr: 'Darüşşifanın sokak boyunca uzanan güneybatı cephesi',
            en: 'The south-western façade of the hospital along the street',
          ),
          author: 'R Prazeres',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}Suleymaniye_complex_DSCF3475.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'suleymaniye-imareti',
      name: MockText(
        tr: 'Süleymaniye İmareti (Darüzziyafe)',
        en: 'Süleymaniye Public Kitchen (Darüzziyafe)',
      ),
      category: MonumentCategory.imaret,
      period: HistoricalPeriod.ottoman,
      city: 'İstanbul',
      district: 'Fatih',
      address:
          'Süleymaniye Mahallesi, Şifahane Sokak No:6, '
          '34116 Fatih/İstanbul',
      latitude: 41.016769,
      longitude: 28.962445,
      complexId: complexId,
      complexOrder: 8,
      shortDescription: MockText(
        tr:
            'Öğrencilere, yolculara ve yoksullara yemek dağıtılan aşevi; bugün '
            'lokanta olarak kullanılıyor.',
        en:
            'The public kitchen that fed students, travellers and the poor; '
            'today it is used as a restaurant.',
      ),
      description: MockText(
        tr:
            'Revaklı bir avlu çevresinde mutfak, fırın, kiler ve yemekhane '
            'bölümlerinden oluşan imaret, vakfın sosyal yardım işlevini '
            'üstlenirdi.',
        en:
            'Arranged around an arcaded courtyard with a kitchen, bakery, '
            'storerooms and dining halls, the public kitchen carried out the '
            "endowment's charitable work.",
      ),
      history: MockText(
        tr:
            'Külliyeyle birlikte 1550–1557 yıllarında inşa edildi; restorasyon '
            'sonrasında Darüzziyafe adıyla lokanta olarak hizmet veriyor.',
        en:
            'Built together with the complex in 1550–1557; after restoration '
            'it serves as a restaurant named Darüzziyafe.',
      ),
      constructionDate: MockText.same('1550–1557'),
      founder: _founder,
      architect: _sinan,
      isUnescoWorldHeritage: true,
      images: [
        MockImage(
          url:
              '$_thumb/e/e8/Istanbul_S%C3%BCleymaniye_complex_Imaret_in_2009_7055.jpg/'
              '1280px-Istanbul_S%C3%BCleymaniye_complex_Imaret_in_2009_7055.jpg',
          thumbnailUrl:
              '$_thumb/e/e8/Istanbul_S%C3%BCleymaniye_complex_Imaret_in_2009_7055.jpg/'
              '330px-Istanbul_S%C3%BCleymaniye_complex_Imaret_in_2009_7055.jpg',
          altText: MockText(
            tr: 'İmaret revakı, taş sandık ve lokanta masaları',
            en: 'The public kitchen portico, a stone chest and restaurant tables',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Istanbul_S%C3%BCleymaniye_complex_Imaret_in_2009_7055.jpg',
        ),
        MockImage(
          url:
              '$_thumb/4/49/Istanbul_S%C3%BCleymaniye_complex_Imaret_in_2009_7050.jpg/'
              '1280px-Istanbul_S%C3%BCleymaniye_complex_Imaret_in_2009_7050.jpg',
          thumbnailUrl:
              '$_thumb/4/49/Istanbul_S%C3%BCleymaniye_complex_Imaret_in_2009_7050.jpg/'
              '330px-Istanbul_S%C3%BCleymaniye_complex_Imaret_in_2009_7050.jpg',
          altText: MockText(
            tr: 'Ağaçlarla gölgelenen imaret avlusu',
            en: 'The tree-shaded courtyard of the public kitchen',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Istanbul_S%C3%BCleymaniye_complex_Imaret_in_2009_7050.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'suleymaniye-sibyan-mektebi',
      name: MockText(
        tr: 'Süleymaniye Sıbyan Mektebi',
        en: 'Süleymaniye Primary School',
      ),
      category: MonumentCategory.other,
      period: HistoricalPeriod.ottoman,
      city: 'İstanbul',
      district: 'Fatih',
      address: _address,
      latitude: 41.015143,
      longitude: 28.963300,
      complexId: complexId,
      complexOrder: 9,
      shortDescription: MockText(
        tr: 'Çocuklara okuma yazma ve Kur\'an öğretilen iki kubbeli mektep.',
        en: "The two-domed school where children learned reading and the Qur'an.",
      ),
      description: MockText(
        tr:
            'Caminin güneyindeki küçük, iki kubbeli yapı, çevresindeki '
            'binalardan ayırt edilmesi zor olsa da külliyenin ilk eğitim '
            'basamağıdır.',
        en:
            'South of the mosque, the small two-domed building is hard to tell '
            'apart from its neighbours, yet it was the first step of education '
            'in the complex.',
      ),
      history: MockText(
        tr: 'Külliyenin yapım sürecinde, 1550–1557 yıllarında inşa edildi.',
        en: 'Built during the construction of the complex, in 1550–1557.',
      ),
      constructionDate: MockText.same('1550–1557'),
      founder: _founder,
      architect: _sinan,
      isUnescoWorldHeritage: true,
      images: [
        MockImage(
          url:
              '$_thumb/8/86/S%C3%BCleymaniye_S%C4%B1byan_Mektebi.jpg/'
              '1280px-S%C3%BCleymaniye_S%C4%B1byan_Mektebi.jpg',
          thumbnailUrl:
              '$_thumb/8/86/S%C3%BCleymaniye_S%C4%B1byan_Mektebi.jpg/'
              '330px-S%C3%BCleymaniye_S%C4%B1byan_Mektebi.jpg',
          altText: MockText(
            tr: 'Mektebin kesme taş cephesi ve kırmızı kapısı',
            en: 'The cut-stone façade and red door of the school',
          ),
          author: 'Özgür Arda BAYRAM',
          license: 'CC BY-SA 4.0',
          sourceUrl: '${_commons}S%C3%BCleymaniye_S%C4%B1byan_Mektebi.jpg',
        ),
        MockImage(
          url:
              '$_thumb/4/43/Mektep_of_the_Suleymaniye_complex_DSCF3416.jpg/'
              '1280px-Mektep_of_the_Suleymaniye_complex_DSCF3416.jpg',
          thumbnailUrl:
              '$_thumb/4/43/Mektep_of_the_Suleymaniye_complex_DSCF3416.jpg/'
              '330px-Mektep_of_the_Suleymaniye_complex_DSCF3416.jpg',
          altText: MockText(
            tr: 'İki kubbeli mektep ve arkasında caminin minaresi',
            en: 'The two-domed school with a minaret of the mosque behind it',
          ),
          author: 'R Prazeres',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Mektep_of_the_Suleymaniye_complex_DSCF3416.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'suleymaniye-hamami',
      name: MockText(tr: 'Süleymaniye Hamamı', en: 'Süleymaniye Hamam'),
      category: MonumentCategory.bath,
      period: HistoricalPeriod.ottoman,
      city: 'İstanbul',
      district: 'Fatih',
      address:
          'Süleymaniye Mahallesi, Mimar Sinan Caddesi No:20, '
          '34116 Fatih/İstanbul',
      latitude: 41.015953,
      longitude: 28.965746,
      complexId: complexId,
      complexOrder: 10,
      shortDescription: MockText(
        tr: 'Külliyenin, bugün de hamam olarak işleyen hamamı.',
        en: 'The bathhouse of the complex, still in use as a hamam today.',
      ),
      description: MockText(
        tr:
            'Medreseler sokağının sonunda, bahçe girişinin yakınındaki hamam; '
            'soğukluk, ılıklık ve büyük kubbeli sıcaklık bölümlerinden oluşur.',
        en:
            'At the end of the street of madrasas, near the garden entrance, '
            'the hamam consists of a changing hall, a warm room and a large '
            'domed hot room.',
      ),
      history: MockText(
        tr:
            'Külliyenin gelir getiren yapılarından biri olarak 1550–1557 '
            'yıllarında inşa edildi.',
        en:
            'Built in 1550–1557 as one of the revenue-producing buildings of '
            'the complex.',
      ),
      constructionDate: MockText.same('1550–1557'),
      founder: _founder,
      architect: _sinan,
      isUnescoWorldHeritage: true,
      images: [
        MockImage(
          url:
              '$_thumb/2/2e/S%C3%BCleymaniye_Hammam_from_outside%2C_2024.jpg/'
              '1280px-S%C3%BCleymaniye_Hammam_from_outside%2C_2024.jpg',
          thumbnailUrl:
              '$_thumb/2/2e/S%C3%BCleymaniye_Hammam_from_outside%2C_2024.jpg/'
              '330px-S%C3%BCleymaniye_Hammam_from_outside%2C_2024.jpg',
          altText: MockText(
            tr: 'Hamamın kubbeli taş yapısı ve sokak cephesi',
            en: 'The domed stone building of the hamam and its street front',
          ),
          author: 'Karakalem',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}S%C3%BCleymaniye_Hammam_from_outside%2C_2024.jpg',
        ),
        MockImage(
          url:
              '$_thumb/8/8f/Istanbul_Suleymaniye_Complex_Hammam_2018_5428.jpg/'
              '1280px-Istanbul_Suleymaniye_Complex_Hammam_2018_5428.jpg',
          thumbnailUrl:
              '$_thumb/8/8f/Istanbul_Suleymaniye_Complex_Hammam_2018_5428.jpg/'
              '330px-Istanbul_Suleymaniye_Complex_Hammam_2018_5428.jpg',
          altText: MockText(
            tr: 'Çatılardan görülen hamam kubbeleri',
            en: 'The hamam domes seen across the rooftops',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Istanbul_Suleymaniye_Complex_Hammam_2018_5428.jpg',
        ),
      ],
    ),
    MockMonument(
      id: 'mimar-sinan-turbesi',
      name: MockText(tr: 'Mimar Sinan Türbesi', en: 'Tomb of Mimar Sinan'),
      category: MonumentCategory.tomb,
      period: HistoricalPeriod.ottoman,
      city: 'İstanbul',
      district: 'Fatih',
      address:
          'Süleymaniye Mahallesi, Mimar Sinan Caddesi, '
          '34116 Fatih/İstanbul',
      latitude: 41.017259,
      longitude: 28.963927,
      complexId: complexId,
      complexOrder: 11,
      shortDescription: MockText(
        tr: "Mimar Sinan'ın kendi tasarladığı, külliyenin köşesindeki türbesi.",
        en: 'The tomb Mimar Sinan designed for himself at the corner of the complex.',
      ),
      description: MockText(
        tr:
            'Külliyenin kuzey köşesinde, iki sokağın birleştiği yerde, '
            'baldaken biçiminde sade bir açık türbe ve önünde bir sebil yer '
            'alır.',
        en:
            'At the northern corner of the complex, where two streets meet, '
            'stands a simple open tomb in the form of a baldachin, with a '
            'drinking fountain in front of it.',
      ),
      history: MockText(
        tr:
            "Mimar Sinan'ın 1588'deki ölümünden sonra külliyenin içinde "
            'kendi evinin bahçesine yerleştirildi; 1933–1934 yıllarında ve '
            'sonrasında onarıldı.',
        en:
            'After his death in 1588, Mimar Sinan was buried in the garden of '
            'his own house within the complex; the tomb was restored in '
            '1933–1934 and later.',
      ),
      constructionDate: MockText(tr: '1588 dolayları', en: 'c. 1588'),
      founder: _sinan,
      architect: _sinan,
      isUnescoWorldHeritage: true,
      images: [
        MockImage(
          url:
              '$_thumb/1/1f/Istanbul_S%C3%BCleymaniye_complex_Sinan%27s_grave_in_2008_2930.jpg/'
              '1280px-Istanbul_S%C3%BCleymaniye_complex_Sinan%27s_grave_in_2008_2930.jpg',
          thumbnailUrl:
              '$_thumb/1/1f/Istanbul_S%C3%BCleymaniye_complex_Sinan%27s_grave_in_2008_2930.jpg/'
              '330px-Istanbul_S%C3%BCleymaniye_complex_Sinan%27s_grave_in_2008_2930.jpg',
          altText: MockText(
            tr: 'Türbenin önündeki sekizgen sebil ve türbe duvarı',
            en: 'The octagonal drinking fountain in front of the tomb wall',
          ),
          author: 'Dosseman',
          license: 'CC BY-SA 4.0',
          sourceUrl:
              '${_commons}Istanbul_S%C3%BCleymaniye_complex_Sinan%27s_grave_in_2008_2930.jpg',
        ),
        MockImage(
          url:
              '$_thumb/2/26/Mimar_Sinan_tomb_February_2013.jpg/'
              '1280px-Mimar_Sinan_tomb_February_2013.jpg',
          thumbnailUrl:
              '$_thumb/2/26/Mimar_Sinan_tomb_February_2013.jpg/'
              '330px-Mimar_Sinan_tomb_February_2013.jpg',
          altText: MockText(
            tr: 'Sokak köşesindeki kubbeli sebil ve türbe',
            en: 'The domed drinking fountain and the tomb at the street corner',
          ),
          author: 'Arild Vågen',
          license: 'CC BY-SA 3.0',
          sourceUrl: '${_commons}Mimar_Sinan_tomb_February_2013.jpg',
        ),
      ],
    ),
  ];
}
