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
  /// Koyu Yeşil — logonun zemini (HCT hue 190, ton 10). Açılış ekranı,
  /// amblem ve marka anlarında kullanılır; uygulama yüzeyleri nötrdür.
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

  // ── Marka yeşilinin tonal kapları ───────────────────────────
  /// Açık temada yumuşak birincil zemin ve seçim göstergesi.
  static const Color tealContainerLight = Color(0xFFD3EBE7);
  static const Color tealSelectedLight = Color(0xFFDDEBE9);

  /// Koyu temada birincil eylem rengi: ton 80'in daha doygun kardeşi.
  static const Color tealOnDark = Color(0xFF7FC4BB);
  static const Color tealSelectedDark = Color(0xFF213A38);

  // ── Koyu zemin: nötr mürekkep (hue 210, chroma ≈ 5) ─────────
  // Marka yeşili yüzeylere değil yalnızca eylemlere taşınır; yüzeyler
  // soğuk nötr basamaklardır (ton ≈ 7 / 10 / 14 / 18).
  static const Color ink = Color(0xFF0F1316);
  static const Color inkVariant = Color(0xFF171C20);
  static const Color inkElevated = Color(0xFF1E242A);
  static const Color inkOutlineVariant = Color(0xFF343D45);
  static const Color inkText = Color(0xFFE8ECEF);
  static const Color inkTextVariant = Color(0xFFA9B3BC);

  // ── Nötr palet (hue 210, chroma ≈ 3) — açık zeminler ────────
  static const Color neutral90 = Color(0xFFE0E4E8);
  static const Color neutral92 = Color(0xFFE6E9ED);
  static const Color neutral94 = Color(0xFFEEF0F3);
  static const Color neutral96 = Color(0xFFF2F4F6);
  static const Color neutral98 = Color(0xFFF7F8FA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color slateText = Color(0xFF14181C);

  // ── Harita: soğuk nötr koyu altlık ve işaretçi tonal kapları ─
  static const Color mapShadowDark = Color(0xFF12171C);
  static const Color mapHighlightDark = Color(0xFFC5CCD6);
  static const Color goldContainerLight = Color(0xFFF1E7D4);
  static const Color onGoldContainerLight = Color(0xFF5A4620);
  static const Color goldContainerDark = Color(0xFF3A3020);
  static const Color onGoldContainerDark = Color(0xFFE3CBA0);
  static const Color blueContainerLight = Color(0xFFDCE6F5);
  static const Color blueContainerDark = Color(0xFF1F2F4A);

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

  // ── Nötr varyant palet (hue 210, chroma ≈ 6) — ikincil metin, çizgi ─
  static const Color neutralVariant10 = Color(0xFF141D1C);
  static const Color neutralVariant30 = Color(0xFF444C55);
  static const Color neutralVariant50 = Color(0xFF6B7480);
  static const Color neutralVariant60 = Color(0xFF7C8791);
  static const Color neutralVariant80 = Color(0xFFD5DAE0);
  static const Color neutralVariant90 = Color(0xFFDAE5E2);

  // ── Semantic Status (Light) ─────────────────────────────────
  static const Color success = Color(0xFF1F6B3F);
  static const Color warning = Color(0xFF7A5408);
  static const Color error = Color(0xFFB03024);
  static const Color info = Color(0xFF155A75);

  // ── Semantic Status (Dark) ──────────────────────────────────
  static const Color successOnDark = Color(0xFF5FBF87);
  static const Color warningOnDark = Color(0xFFE0A93A);
  static const Color errorOnDark = Color(0xFFFF8A80);
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
