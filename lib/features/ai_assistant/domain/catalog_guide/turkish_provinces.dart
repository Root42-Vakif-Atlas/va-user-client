import 'package:vakif_atlas/core/utils/turkish_text.dart';

/// Türkiye'nin 81 ili (plaka kodu → ad). Rehber, soruda geçen ili katalog
/// süzgecine (plaka kodu) çevirir; katalogda eseri olmayan bir il
/// sorulduğunda bunu açıkça söyleyebilmek için tüm iller tanınır.
abstract final class TurkishProvinces {
  static const Map<int, String> names = {
    1: 'Adana',
    2: 'Adıyaman',
    3: 'Afyonkarahisar',
    4: 'Ağrı',
    5: 'Amasya',
    6: 'Ankara',
    7: 'Antalya',
    8: 'Artvin',
    9: 'Aydın',
    10: 'Balıkesir',
    11: 'Bilecik',
    12: 'Bingöl',
    13: 'Bitlis',
    14: 'Bolu',
    15: 'Burdur',
    16: 'Bursa',
    17: 'Çanakkale',
    18: 'Çankırı',
    19: 'Çorum',
    20: 'Denizli',
    21: 'Diyarbakır',
    22: 'Edirne',
    23: 'Elazığ',
    24: 'Erzincan',
    25: 'Erzurum',
    26: 'Eskişehir',
    27: 'Gaziantep',
    28: 'Giresun',
    29: 'Gümüşhane',
    30: 'Hakkari',
    31: 'Hatay',
    32: 'Isparta',
    33: 'Mersin',
    34: 'İstanbul',
    35: 'İzmir',
    36: 'Kars',
    37: 'Kastamonu',
    38: 'Kayseri',
    39: 'Kırklareli',
    40: 'Kırşehir',
    41: 'Kocaeli',
    42: 'Konya',
    43: 'Kütahya',
    44: 'Malatya',
    45: 'Manisa',
    46: 'Kahramanmaraş',
    47: 'Mardin',
    48: 'Muğla',
    49: 'Muş',
    50: 'Nevşehir',
    51: 'Niğde',
    52: 'Ordu',
    53: 'Rize',
    54: 'Sakarya',
    55: 'Samsun',
    56: 'Siirt',
    57: 'Sinop',
    58: 'Sivas',
    59: 'Tekirdağ',
    60: 'Tokat',
    61: 'Trabzon',
    62: 'Tunceli',
    63: 'Şanlıurfa',
    64: 'Uşak',
    65: 'Van',
    66: 'Yozgat',
    67: 'Zonguldak',
    68: 'Aksaray',
    69: 'Bayburt',
    70: 'Karaman',
    71: 'Kırıkkale',
    72: 'Batman',
    73: 'Şırnak',
    74: 'Bartın',
    75: 'Ardahan',
    76: 'Iğdır',
    77: 'Yalova',
    78: 'Karabük',
    79: 'Kilis',
    80: 'Osmaniye',
    81: 'Düzce',
  };

  /// Halk arasındaki adlar ve il merkezi olan ilçeler (katlanmış).
  static const Map<String, int> _aliases = {
    'afyon': 3,
    'antep': 27,
    'icel': 33,
    'izmit': 41,
    'maras': 46,
    'urfa': 63,
    'adapazari': 54,
    'antakya': 31,
    'iskenderun': 31,
  };

  /// Katlanmış ad → plaka kodu.
  static final Map<String, int> _byFoldedName = {
    for (final entry in names.entries) TurkishText.fold(entry.value): entry.key,
    ..._aliases,
  };

  /// Katlanmış [token] bir il adı mı? Kesme işaretsiz yazılan çekimli hali
  /// ("konyadaki") yalnızca 5+ harfli adlarda tanınır; kısa adlar ("muş",
  /// "van", "kars") başka sözcüklerin başı olabildiğinden ("musa", "karşı")
  /// tam eşleşme ister.
  static int? codeOf(String token) {
    final exact = _byFoldedName[token];
    if (exact != null) {
      return exact;
    }
    for (final MapEntry(key: name, value: code) in _byFoldedName.entries) {
      if (name.length >= 5 &&
          token.length > name.length &&
          token.startsWith(name) &&
          TurkishSuffixes.isSuffix(token.substring(name.length))) {
        return code;
      }
    }
    return null;
  }

  static String nameOf(int code) => names[code] ?? '$code';
}

/// Özel adlara kesme işaretsiz eklenen yaygın çekim ekleri (katlanmış).
abstract final class TurkishSuffixes {
  static const Set<String> _suffixes = {
    'a', 'e', 'i', 'u', 'ya', 'ye', 'yi', 'yu', 'na', 'ne', 'ni', 'nu', //
    'da', 'de', 'ta', 'te', 'dan', 'den', 'tan', 'ten', //
    'daki', 'deki', 'taki', 'teki', 'nda', 'nde', 'ndaki', 'ndeki', //
    'ndan', 'nden', 'in', 'un', 'nin', 'nun', 'yla', 'yle', 'la', 'le', //
    'li', 'lu', 'si', 'su', 'sini', 'sinin', 'sunu', 'sunun', 'sine', //
    'suna', 'sinde', 'sunda', 'inin', 'unun', 'ini', 'unu', 'ine', 'una', //
    'inde', 'unda', 'ler', 'lar', 'leri', 'lari', 'lerin', 'larin',
  };

  static bool isSuffix(String value) => _suffixes.contains(value);
}
