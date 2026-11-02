import 'package:flutter/foundation.dart';

/// Erişilebilirlik panelinin temaya yansıyan tercihleri (font, metin
/// aralığı, satır yüksekliği, zemin, bağlantı vurgusu).
///
/// Tema çekirdeği feature'lara bağımlı olmasın diye ilkel değerler taşır;
/// eşlemeyi kök (`app.dart`) yapar.
@immutable
final class AppThemeOptions {
  const AppThemeOptions({
    this.legibleFont = false,
    this.wideTextSpacing = false,
    this.lineHeight,
    this.creamBackground = false,
    this.highlightLinks = false,
    this.reduceMotion = false,
    this.invertColors = false,
  });

  static const AppThemeOptions standard = AppThemeOptions();

  /// Okunaklı (disleksi dostu) font: Atkinson Hyperlegible.
  final bool legibleFont;

  /// WCAG 1.4.12: harf aralığı 0,12 em, kelime aralığı 0,16 em.
  final bool wideTextSpacing;

  /// Satır yüksekliği çarpanı; tasarım değerinden büyükse uygulanır.
  final double? lineHeight;

  /// Açık temada parlak beyaz yerine krem zemin.
  final bool creamBackground;

  /// Butonlar ve bağlantılar alt çizgi + çerçeveyle vurgulanır.
  final bool highlightLinks;

  /// Uygulama içi "Animasyonları durdur": sayfa geçişleri anında olur.
  /// (Alt sayfa, diyalog ve menü açılışları `context.motionAnimationStyle`
  /// ile çağrıldıkları yerde durdurulur.)
  final bool reduceMotion;

  /// Ters renk filtresi açık: koyu temada durum renkleri çevrilmeye uygun
  /// seçilir (`AppColorScheme.forInvertedDisplay`).
  final bool invertColors;

  /// WCAG 1.4.12: satır yüksekliği en az 1,5.
  static const double wideTextLineHeight = 1.5;

  /// Uygulanacak satır yüksekliği: kullanıcının seçimi ile (Kolay Okuma
  /// açıksa) WCAG 1.4.12 alt sınırının büyüğü; ikisi de yoksa `null`.
  double? get effectiveLineHeight {
    final preferred = lineHeight;
    if (!wideTextSpacing) {
      return preferred;
    }
    return preferred != null && preferred > wideTextLineHeight
        ? preferred
        : wideTextLineHeight;
  }

  static const double letterSpacingEm = 0.12;
  static const double wordSpacingEm = 0.16;

  @override
  bool operator ==(Object other) =>
      other is AppThemeOptions &&
      other.legibleFont == legibleFont &&
      other.wideTextSpacing == wideTextSpacing &&
      other.lineHeight == lineHeight &&
      other.creamBackground == creamBackground &&
      other.highlightLinks == highlightLinks &&
      other.reduceMotion == reduceMotion &&
      other.invertColors == invertColors;

  @override
  int get hashCode => Object.hash(
    legibleFont,
    wideTextSpacing,
    lineHeight,
    creamBackground,
    highlightLinks,
    reduceMotion,
    invertColors,
  );
}
