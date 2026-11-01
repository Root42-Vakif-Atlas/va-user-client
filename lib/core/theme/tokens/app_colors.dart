import 'package:flutter/painting.dart';

/// Primitif renk token'ları.
///
/// Arayüz kodunda doğrudan KULLANILMAZ; yalnızca tema fabrikaları
/// (`AppColorScheme`) bu değerlerden semantik renkleri üretir.
/// Her tema eşlemesi `test/core/theme/contrast_test.dart` ile WCAG 2.2
/// kontrast eşiklerine karşı doğrulanır.
///
/// Tonal paletler Material 3 HCT renk uzayında marka renklerinin tonundan
/// (hue) üretilmiştir (`material_color_utilities`, `TonalPalette`); ad
/// sonundaki sayı HCT tonudur (0 siyah – 100 beyaz). Böylece açık ve koyu
/// temalarda aynı yeşilin algısal olarak tutarlı açık/koyu tonları kullanılır.
abstract final class AppColors {
  // ── Brand Core (docs/brand-reference.md) ────────────────────
  /// Koyu Yeşil — birincil kurumsal renk (HCT hue 190, ton 10).
  static const Color darkGreen = Color(0xFF081F1D);
  static const Color darkGreenDarker = Color(0xFF04100E);

  /// Sıcak Fildişi — koyu zeminde ana metin.
  static const Color warmIvory = Color(0xFFFFF4E4);
  static const Color warmIvoryDimmed = Color(0xFFEBE0D0);

  /// Antik Altın — vurgu (marka motifleri, harita pinleri). Geniş dolgu
  /// alanlarında ve metinde kullanılmaz.
  static const Color antiqueGold = Color(0xFFA18556);
  static const Color antiqueGoldLight = Color(0xFFC4A97A);

  /// İznik çini mavisi — külliye işaretçisi ve yerleşim alanı. Altın eser
  /// pinlerinden (sarı–mavi ekseni) renk körlüğünde de ayrışır; ayrım ayrıca
  /// şekil ve etiketle yapılır.
  static const Color iznikBlue = Color(0xFF1D4E89);
  static const Color iznikBlueLight = Color(0xFF9DBDF0);

  // ── Yeşil tonal palet (hue 190, chroma 24) — birincil ───────
  static const Color green10 = Color(0xFF00201E);
  static const Color green20 = Color(0xFF003733);
  static const Color green30 = Color(0xFF1F4E4A);
  static const Color green80 = Color(0xFFA0D0CA);
  static const Color green90 = Color(0xFFBCECE6);

  // ── Koyu zemin tonları (hue 190, chroma 15 — marka yeşili) ──
  static const Color darkGreen12 = Color(0xFF0D2321);
  static const Color darkGreen17 = Color(0xFF182E2C);
  static const Color darkGreen22 = Color(0xFF233936);
  static const Color darkGreen25 = Color(0xFF293F3D);

  // ── Nötr palet (hue 190, chroma 4) — açık zeminler ──────────
  static const Color neutral90 = Color(0xFFE0E3E1);
  static const Color neutral92 = Color(0xFFE6E9E7);
  static const Color neutral94 = Color(0xFFECEEED);
  static const Color neutral96 = Color(0xFFF2F4F3);
  static const Color neutral98 = Color(0xFFF7FAF8);
  static const Color white = Color(0xFFFFFFFF);

  /// Kamera vizörünün zemini: önizleme dışı alan temadan bağımsız siyahtır
  /// (görüntü renkleri çevreden etkilenmesin).
  static const Color cameraBackdrop = Color(0xFF000000);

  // ── Erişilebilirlik katmanları (temadan bağımsız, her zeminde görünür) ──
  /// Odak çerçevesi: sarı iç + siyah dış halka (WCAG 1.4.11, ≥ 3:1).
  static const Color focusRingInner = Color(0xFFFFD600);
  static const Color focusRingOuter = Color(0xFF000000);

  /// Okuma maskesinin karartması.
  static const Color readingMaskScrim = Color(0x99000000);

  /// Büyük imleç: siyah dolgu + beyaz kontur.
  static const Color cursorFill = Color(0xFF000000);
  static const Color cursorOutline = Color(0xFFFFFFFF);

  // ── Nötr varyant palet (hue 190, chroma 8) — ikincil metin, çizgi ─
  static const Color neutralVariant30 = Color(0xFF3F4947);
  static const Color neutralVariant50 = Color(0xFF6F7977);
  static const Color neutralVariant60 = Color(0xFF899391);
  static const Color neutralVariant80 = Color(0xFFBEC9C6);
  static const Color neutralVariant90 = Color(0xFFDAE5E2);
  static const Color neutralVariant10 = Color(0xFF141D1C);

  // ── Semantic Status (Light) ─────────────────────────────────
  static const Color success = Color(0xFF1F6B3F);
  static const Color warning = Color(0xFF7A5408);
  static const Color error = Color(0xFFB03024);
  static const Color info = Color(0xFF155A75);

  // ── Semantic Status (Dark) ──────────────────────────────────
  static const Color successOnDark = Color(0xFF5FBF87);
  static const Color warningOnDark = Color(0xFFE0A93A);
  static const Color errorOnDark = Color(0xFFFF6B6B);
  static const Color infoOnDark = Color(0xFF6CB8D6);

  // ── High Contrast Dark ──────────────────────────────────────
  static const Color hcBlack = Color(0xFF000000);
  static const Color hcSurfaceDark = Color(0xFF111111);
  static const Color hcSurfaceDarkElevated = Color(0xFF1C1C1C);
  static const Color hcWhite = Color(0xFFFFFFFF);
  static const Color hcGreyLight = Color(0xFFDDDDDD);
  static const Color hcAccent = Color(0xFFFFD700);
  static const Color hcErrorOnDark = Color(0xFFFF8A8A);
  static const Color hcSuccessOnDark = Color(0xFF5CE08A);
  static const Color hcWarningOnDark = Color(0xFFFFC24D);
  static const Color hcInfoOnDark = Color(0xFF7FD4FF);
  static const Color hcComplexOnDark = Color(0xFF66CCFF);

  // ── High Contrast Light ─────────────────────────────────────
  static const Color hcSurfaceLight = Color(0xFFF0F0F0);
  static const Color hcGreyDark = Color(0xFF222222);
  static const Color hcAccentOnLight = Color(0xFF005800);
  static const Color hcComplexOnLight = Color(0xFF0033AA);
  static const Color hcError = Color(0xFFA00000);
  static const Color hcWarning = Color(0xFF5C3D00);
  static const Color hcInfo = Color(0xFF00466B);
}
