/// 4pt / 8pt grid boşluk token'ları (Design System §2.3).
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double x3l = 64;
  static const double x4l = 80;
}

/// Köşe yarıçapı token'ları.
///
/// `circular(30+)` / `StadiumBorder` marka diliyle uyumsuzdur, kullanılmaz.
abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
}

/// Bileşen boyut token'ları.
abstract final class AppSizes {
  /// WCAG 2.5.8 / Material: minimum dokunma hedefi (dp).
  static const double minTouchTarget = 48;

  static const double iconSm = 16;

  /// Buton ve satır içi metinle birlikte kullanılan ikon.
  static const double iconInline = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  static const double borderThin = 1;
  static const double borderThick = 2;

  /// Seçili harita pini gibi güçlü vurgu kenarlığı.
  static const double borderHeavy = 3;

  static const double spinner = 20;
  static const double spinnerStroke = 2;

  /// Pusula/karo motifinin kenar uzunluğu.
  static const double diamond = 8;

  static const double badgeMinSize = 20;

  /// Okunabilir satır uzunluğu için içerik sütununun maksimum genişliği.
  static const double maxContentWidth = 560;

  /// Ayarlar → Hakkında'daki uygulama simgesi.
  static const double aboutIcon = 72;

  /// Boş durum / hata metninin en geniş satırı (kısa, ortalı metin).
  static const double statusTextWidth = 400;

  /// Harita üzerindeki kontrol butonları (tek dokunuşlu, büyük hedef).
  static const double mapControl = 56;

  /// Harita üzerindeki arama çubuğunun yüksekliği.
  static const double mapSearchBar = 56;

  /// Haritadaki "konumunuz" noktası (beyaz halka dahil).
  static const double userLocationDot = 22;

  /// Hesap menüsü başlığındaki büyük profil görseli.
  static const double avatarLarge = 64;

  /// Pusula/karo biçimli harita pininin kenarı (dokunma alanı 48 dp).
  static const double mapPinSide = 30;
  static const double mapPinSelectedSide = 40;

  /// Harita kümesi işaretçisinin kutusu (dokunma alanı dahil), eser sayısına
  /// göre: < 10, < 100, ≥ 100.
  static const double mapClusterSmall = 52;
  static const double mapClusterMedium = 60;
  static const double mapClusterLarge = 68;

  /// Külliye işaretçisinin dairesi ve (rozet dahil) kutusu; seçili halde
  /// büyür.
  static const double mapComplexSide = 40;
  static const double mapComplexSelectedSide = 48;
  static const double mapComplexExtent = 60;
  static const double mapComplexSelectedExtent = 68;

  /// Yakın zum'daki külliye yerleşim alanının konturu.
  static const double mapComplexOutline = 2;

  /// Haritadaki rota çizgisinin kalınlığı (kontur hariç).
  static const double routeLine = 5;

  /// Seçili pinin dokunma ve çizim alanı.
  static const double mapPinSelectedExtent = 64;

  /// Liste ve önizleme kartlarındaki eser küçük görseli.
  static const double thumbnail = 72;

  /// Galeri küçük resim şeridi öğesi.
  static const double galleryThumbnail = 64;

  /// Açılış ekranındaki amblem kutusu. Native açılış görselleri
  /// (`tool/generate_brand_assets_test.dart`) aynı boyutta üretilir; Android
  /// 12+ simge alanının 192 dp'lik görünür dairesine sığar.
  static const double splashEmblem = 160;

  /// Android 12+ açılış simgesinin tuvali (dp).
  static const double splashIconCanvas = 288;

  /// Tanıtım karşılama adımındaki amblem.
  static const double onboardingEmblem = 96;

  /// Tanıtım adımlarının başlık ikonu kutusu.
  static const double onboardingIcon = 56;

  /// Tanıtım ilerleme çubuğu bölümlerinin kalınlığı.
  static const double stepIndicator = 4;
}

/// Duyarlı (responsive) kırılım noktaları (Design System §4.1).
abstract final class AppBreakpoints {
  /// Bu genişliğin altı `Compact` (telefon).
  static const double medium = 600;

  /// Bu genişlik ve üzeri `Expanded` (büyük tablet / masaüstü).
  static const double expanded = 840;
}
