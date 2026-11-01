/// Mock Anı Köşesi'nin başlangıç verisi: kurgusal ziyaretçilerin metin
/// anıları. Fotoğraf eklenmez (gerçek kişilere ait olmayan fotoğrafları
/// ziyaretçi paylaşımı gibi göstermemek için); fotoğraflı anılar
/// uygulamadan paylaşılır. İki eserde (Sultanhanı, Gülbahar Hatun) bilinçli
/// olarak anı yoktur (boş durum).
abstract final class MemoryFixtures {
  static List<Map<String, dynamic>> get memories => [
    _memory(
      id: 'mem_seed_selimiye_1',
      monumentId: 'selimiye-camii',
      author: ('usr_seed_01', 'Mehmet K.'),
      createdAt: '2026-10-12T16:40:00Z',
      visitedOn: '2026-10-11',
      text:
          'Kubbenin altına girdiğim an sustum. Mimar Sinan\'ın "ustalık eserim" '
          'dediği yapıyı fotoğraflardan tanıdığımı sanıyordum ama içerideki '
          'ışık bambaşka. Öğle namazından sonra avlu neredeyse boştu, '
          'şadırvanın sesini dinleyerek uzun süre oturduk.',
    ),
    _memory(
      id: 'mem_seed_selimiye_2',
      monumentId: 'selimiye-camii',
      author: ('usr_seed_02', 'Zeynep A.'),
      createdAt: '2026-09-28T09:15:00Z',
      visitedOn: '2026-09-27',
      text:
          'Babaannemle birlikte gittik; çocukken her bayram buraya '
          'geldiklerini anlattı. Müze kısmındaki el yazması Kur\'anları da '
          'mutlaka görün.',
    ),
    _memory(
      id: 'mem_seed_selimiye_3',
      monumentId: 'selimiye-camii',
      author: ('usr_seed_03', 'Daniel R.'),
      createdAt: '2026-08-19T13:05:00Z',
      text:
          'Visited on a day trip from Istanbul. The four minarets are even '
          'taller than I expected, and the tile work in the sultan\'s lodge '
          'is breathtaking. Take your time, it is worth it.',
    ),
    _memory(
      id: 'mem_seed_selimiye_4',
      monumentId: 'selimiye-camii',
      author: ('usr_seed_04', 'Elif T.'),
      createdAt: '2026-07-02T18:20:00Z',
      visitedOn: '2026-06-30',
      text:
          'Mimarlık öğrencisi olarak yıllardır çizimlerini inceliyordum. '
          'Sekiz fil ayağının kubbeyi nasıl taşıdığını yerinde görmek '
          'bambaşkaymış.',
    ),
    _memory(
      id: 'mem_seed_suleymaniye_1',
      monumentId: 'suleymaniye-camii',
      author: ('usr_seed_05', 'Ahmet Ç.'),
      createdAt: '2026-10-05T11:30:00Z',
      visitedOn: '2026-10-04',
      text:
          'Avludan Haliç manzarası her şeye değer. Külliyenin medreselerini '
          've Mimar Sinan\'ın türbesini de gezmeyi unutmayın; çoğu ziyaretçi '
          'yalnızca camiyi görüp çıkıyor.',
    ),
    _memory(
      id: 'mem_seed_suleymaniye_2',
      monumentId: 'suleymaniye-camii',
      author: ('usr_seed_06', 'Selin Ö.'),
      createdAt: '2026-09-14T15:45:00Z',
      text:
          'İlk İstanbul gezimizde yağmur başlayınca sığındığımız yer burası '
          'oldu. Halıların üzerinde oturup kubbeyi izlerken saatin nasıl '
          'geçtiğini anlamadık.',
    ),
    _memory(
      id: 'mem_seed_suleymaniye_3',
      monumentId: 'suleymaniye-camii',
      author: ('usr_seed_07', 'Hasan B.'),
      createdAt: '2026-05-21T07:50:00Z',
      visitedOn: '2026-05-20',
      text:
          'Sabah namazına yetiştik. Gün doğarken pencerelerden süzülen ışığı '
          'anlatmak zor; mümkünse erken saatte gidin.',
    ),
    _memory(
      id: 'mem_seed_bursa_1',
      monumentId: 'bursa-ulu-camii',
      author: ('usr_seed_08', 'Fatma D.'),
      createdAt: '2026-10-01T12:10:00Z',
      visitedOn: '2026-09-30',
      text:
          'Caminin içindeki şadırvan çok özel; serinliği ve suyun sesi '
          'insanı sakinleştiriyor. Duvarlardaki hat levhaları ayrı bir sergi '
          'gibi.',
    ),
    _memory(
      id: 'mem_seed_bursa_2',
      monumentId: 'bursa-ulu-camii',
      author: ('usr_seed_09', 'Kerem S.'),
      createdAt: '2026-06-11T17:25:00Z',
      text:
          'Çarşı gezisinin ardından uğradık. Yirmi kubbeyi tek tek saymaya '
          'çalışan oğlumun heyecanı hâlâ aklımda.',
    ),
    _memory(
      id: 'mem_seed_kizlaragasi_1',
      monumentId: 'kizlaragasi-hani',
      author: ('usr_seed_10', 'Merve Y.'),
      createdAt: '2026-09-07T14:00:00Z',
      visitedOn: '2026-09-06',
      text:
          'Kemeraltı\'nın kalabalığından çıkıp avluya girince bambaşka bir '
          'dünyaya geçiyorsunuz. Avludaki kahvecide Türk kahvesi içip handaki '
          'zanaatkârları gezdik.',
    ),
    _memory(
      id: 'mem_seed_kizlaragasi_2',
      monumentId: 'kizlaragasi-hani',
      author: ('usr_seed_11', 'Can E.'),
      createdAt: '2026-04-18T10:35:00Z',
      text:
          'İzmir\'de büyüdüm ama hanın üst katına ilk kez çıktım. Taş '
          'işçiliği ve ahşap dokunun restorasyonla korunmuş olması sevindirici.',
    ),
    _memory(
      id: 'mem_seed_hacibayram_1',
      monumentId: 'haci-bayram-veli-camii',
      author: ('usr_seed_12', 'Ayten G.'),
      createdAt: '2026-08-30T08:45:00Z',
      visitedOn: '2026-08-29',
      text:
          'Augustus Tapınağı\'nın hemen yanında olması inanılmaz; iki bin yıllık '
          'tarihi aynı avluda görmek çok etkileyici. Ahşap tavan süslemelerine '
          'mutlaka bakın.',
    ),
    _memory(
      id: 'mem_seed_sahipata_1',
      monumentId: 'sahip-ata-kulliyesi',
      author: ('usr_seed_13', 'Murat İ.'),
      createdAt: '2026-07-16T16:00:00Z',
      text:
          'Taç kapıdaki taş işçiliği Selçuklu sanatının en güzel örneklerinden. '
          'Vakıf Müzesi\'ndeki halı ve kilim koleksiyonu da beklediğimden '
          'zengindi.',
    ),
    _memory(
      id: 'mem_seed_divrigi_1',
      monumentId: 'divrigi-ulu-camii-ve-darussifasi',
      author: ('usr_seed_14', 'Gülsüm P.'),
      createdAt: '2026-06-24T15:20:00Z',
      visitedOn: '2026-06-21',
      text:
          'Öğleden sonra taç kapıda beliren, namaz kılan insanı andıran gölgeyi '
          'görmek için geldik. Kalabalıkla birlikte o anı beklemek '
          'unutulmazdı.',
    ),
    _memory(
      id: 'mem_seed_divrigi_2',
      monumentId: 'divrigi-ulu-camii-ve-darussifasi',
      author: ('usr_seed_15', 'Sophie L.'),
      createdAt: '2026-05-03T11:55:00Z',
      text:
          'A long journey, but the stone portals are unlike anything I have '
          'seen. It is easy to understand why this is a UNESCO World Heritage '
          'site.',
    ),
    _memory(
      id: 'mem_seed_diyarbakir_1',
      monumentId: 'diyarbakir-ulu-camii',
      author: ('usr_seed_16', 'Rıza A.'),
      createdAt: '2026-09-21T13:40:00Z',
      visitedOn: '2026-09-20',
      text:
          'Avludaki iki katlı revaklar ve bazalt taşın rengi çok etkileyici. '
          'Sur içi gezisinin en sakin durağıydı.',
    ),
  ];

  static Map<String, dynamic> _memory({
    required String id,
    required String monumentId,
    required (String, String) author,
    required String createdAt,
    required String text,
    String? visitedOn,
  }) => {
    'id': id,
    'monumentId': monumentId,
    'author': {'id': author.$1, 'displayName': author.$2},
    'text': text,
    'photos': <Map<String, dynamic>>[],
    'createdAt': createdAt,
    'visitedOn': ?visitedOn,
    'status': 'approved',
  };
}
