import 'package:flutter/painting.dart';

/// Uygulamada paketlenmiş font aileleri.
abstract final class AppFonts {
  static const String cinzel = 'Cinzel';
  static const String inter = 'Inter';

  /// Erişilebilirlik → Disleksi Dostu.
  static const String atkinsonHyperlegible = 'AtkinsonHyperlegible';
}

/// Tipografi token'ları (Design System §2.2).
///
/// Cinzel yalnızca marka anlarında (`display*`: açılış, giriş, gizlilik
/// perdesi) kullanılır. Ekran ve bölüm başlıkları dahil tüm arayüz metni
/// Inter'dir: Cinzel'in küçük-büyük harf (small caps) biçimi uzun Türkçe
/// başlıklarda okunabilirliği düşürür.
///
/// Renk içermez; renk tema tarafından `AppTextTheme` ile uygulanır.
/// Fontlar değişken (variable) olduğundan ağırlık hem [FontWeight] hem de
/// `wght` ekseniyle belirtilir. Satır yüksekliği `lineHeight / fontSize`.
abstract final class AppTypography {
  static const TextStyle displayLarge = TextStyle(
    fontFamily: AppFonts.cinzel,
    fontSize: 48,
    height: 56 / 48,
    fontWeight: FontWeight.w700,
    fontVariations: [FontVariation('wght', 700)],
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: AppFonts.cinzel,
    fontSize: 36,
    height: 44 / 36,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
  );

  /// Üst çubuk (AppBar) sayfa başlığı: `titleLarge`'dan büyük ve kalın.
  static const double appBarTitleSize = 22;
  static const double appBarTitleHeight = 28 / 22;

  static const TextStyle titleLarge = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation('wght', 500)],
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 10,
    height: 14 / 10,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation('wght', 500)],
  );
}
