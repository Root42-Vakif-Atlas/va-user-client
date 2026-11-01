import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/tokens/app_colors.dart';

/// Tema başına semantik renk token'ları (Design System §2.1).
///
/// Arayüz kodu renkleri yalnızca bu extension üzerinden okur:
/// `context.colors.primary`.
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.brightness,
    required this.isHighContrast,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceElevated,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.accentText,
    required this.brandAccent,
    required this.onBrandAccent,
    required this.complexAccent,
    required this.onComplexAccent,
    required this.outline,
    required this.outlineVariant,
    required this.error,
    required this.onError,
    required this.success,
    required this.warning,
    required this.info,
  });

  /// Koyu tema: marka Koyu Yeşil zemin, Sıcak Fildişi metin. Birincil
  /// eylemler yeşilin açık tonudur (M3 koyu tema kuralı); Antik Altın
  /// yalnızca marka vurgusudur.
  static const AppColorScheme dark = AppColorScheme(
    brightness: Brightness.dark,
    isHighContrast: false,
    primary: AppColors.green80,
    onPrimary: AppColors.green20,
    primaryContainer: AppColors.green30,
    onPrimaryContainer: AppColors.green90,
    secondaryContainer: AppColors.neutralVariant30,
    onSecondaryContainer: AppColors.neutralVariant90,
    surface: AppColors.darkGreen,
    surfaceVariant: AppColors.darkGreen17,
    surfaceElevated: AppColors.darkGreen22,
    onSurface: AppColors.warmIvory,
    onSurfaceVariant: AppColors.warmIvoryDimmed,
    accentText: AppColors.green80,
    brandAccent: AppColors.antiqueGold,
    onBrandAccent: AppColors.darkGreen,
    complexAccent: AppColors.iznikBlueLight,
    onComplexAccent: AppColors.darkGreen,
    outline: AppColors.neutralVariant60,
    outlineVariant: AppColors.neutralVariant30,
    error: AppColors.errorOnDark,
    onError: AppColors.darkGreen,
    success: AppColors.successOnDark,
    warning: AppColors.warningOnDark,
    info: AppColors.infoOnDark,
  );

  /// Açık tema: nötr (hafif yeşil tonlu) zeminler, beyaz yüzen yüzeyler,
  /// Koyu Yeşil metin ve birincil eylemler.
  static const AppColorScheme light = AppColorScheme(
    brightness: Brightness.light,
    isHighContrast: false,
    primary: AppColors.green30,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.green90,
    onPrimaryContainer: AppColors.green10,
    secondaryContainer: AppColors.neutralVariant90,
    onSecondaryContainer: AppColors.neutralVariant10,
    surface: AppColors.neutral98,
    surfaceVariant: AppColors.neutral94,
    surfaceElevated: AppColors.white,
    onSurface: AppColors.darkGreen,
    onSurfaceVariant: AppColors.neutralVariant30,
    accentText: AppColors.green30,
    brandAccent: AppColors.antiqueGold,
    onBrandAccent: AppColors.darkGreen,
    complexAccent: AppColors.iznikBlue,
    onComplexAccent: AppColors.white,
    outline: AppColors.neutralVariant50,
    outlineVariant: AppColors.neutralVariant80,
    error: AppColors.error,
    onError: AppColors.white,
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
  );

  static const AppColorScheme highContrastDark = AppColorScheme(
    brightness: Brightness.dark,
    isHighContrast: true,
    primary: AppColors.hcAccent,
    onPrimary: AppColors.hcBlack,
    primaryContainer: AppColors.hcAccent,
    onPrimaryContainer: AppColors.hcBlack,
    secondaryContainer: AppColors.hcAccent,
    onSecondaryContainer: AppColors.hcBlack,
    surface: AppColors.hcBlack,
    surfaceVariant: AppColors.hcSurfaceDark,
    surfaceElevated: AppColors.hcSurfaceDarkElevated,
    onSurface: AppColors.hcWhite,
    onSurfaceVariant: AppColors.hcGreyLight,
    accentText: AppColors.hcAccent,
    brandAccent: AppColors.hcAccent,
    onBrandAccent: AppColors.hcBlack,
    complexAccent: AppColors.hcComplexOnDark,
    onComplexAccent: AppColors.hcBlack,
    outline: AppColors.hcWhite,
    outlineVariant: AppColors.hcGreyLight,
    error: AppColors.hcErrorOnDark,
    onError: AppColors.hcBlack,
    success: AppColors.hcSuccessOnDark,
    warning: AppColors.hcWarningOnDark,
    info: AppColors.hcInfoOnDark,
  );

  static const AppColorScheme highContrastLight = AppColorScheme(
    brightness: Brightness.light,
    isHighContrast: true,
    primary: AppColors.hcAccentOnLight,
    onPrimary: AppColors.hcWhite,
    primaryContainer: AppColors.hcAccentOnLight,
    onPrimaryContainer: AppColors.hcWhite,
    secondaryContainer: AppColors.hcAccentOnLight,
    onSecondaryContainer: AppColors.hcWhite,
    surface: AppColors.hcWhite,
    surfaceVariant: AppColors.hcSurfaceLight,
    surfaceElevated: AppColors.hcWhite,
    onSurface: AppColors.hcBlack,
    onSurfaceVariant: AppColors.hcGreyDark,
    accentText: AppColors.hcAccentOnLight,
    brandAccent: AppColors.hcAccentOnLight,
    onBrandAccent: AppColors.hcWhite,
    complexAccent: AppColors.hcComplexOnLight,
    onComplexAccent: AppColors.hcWhite,
    outline: AppColors.hcBlack,
    outlineVariant: AppColors.hcGreyDark,
    error: AppColors.hcError,
    onError: AppColors.hcWhite,
    success: AppColors.hcAccentOnLight,
    warning: AppColors.hcWarning,
    info: AppColors.hcInfo,
  );

  final Brightness brightness;
  final bool isHighContrast;

  /// Birincil aksiyon dolgusu (buton, seçili gösterge).
  final Color primary;

  /// [primary] dolgu üzerindeki metin/ikon.
  final Color onPrimary;

  /// Birincil rengin yumuşak tonu: seçili çip, profil görseli, tonal
  /// vurgu alanları.
  final Color primaryContainer;
  final Color onPrimaryContainer;

  /// Düşük vurgulu seçim zemini: gezinme göstergesi, seçili filtre.
  final Color secondaryContainer;
  final Color onSecondaryContainer;

  /// Sayfa zemini.
  final Color surface;

  /// Kart, alan ve panel zemini.
  final Color surfaceVariant;

  /// Yüzen ve yükseltilmiş yüzeyler: arama çubuğu, harita kontrolleri,
  /// alt sayfa, diyalog.
  final Color surfaceElevated;

  final Color onSurface;

  /// İkincil metin.
  final Color onSurfaceVariant;

  /// Zemin üzerinde birincil renkle yazılan metin/ikon: bölüm başlığı,
  /// bağlantı, vurgulu ikon (≥ 4.5:1 garanti).
  final Color accentText;

  /// Antik Altın marka vurgusu: pusula/karo motifi, harita pinleri. Grafik
  /// öğedir (≥ 3:1); metin rengi olarak kullanılmaz.
  final Color brandAccent;

  /// [brandAccent] dolgu üzerindeki ikon.
  final Color onBrandAccent;

  /// Külliye işaretçisi ve yerleşim alanı (İznik mavisi). Grafik öğedir
  /// (≥ 3:1); metin rengi olarak kullanılmaz.
  final Color complexAccent;

  /// [complexAccent] dolgu üzerindeki ikon ve sayı.
  final Color onComplexAccent;

  /// Etkileşimli bileşen sınırları (WCAG 1.4.11, ≥ 3:1).
  final Color outline;

  /// Dekoratif ayırıcı ve kart kenarlığı (kontrast şartı yok).
  final Color outlineVariant;

  final Color error;
  final Color onError;
  final Color success;
  final Color warning;
  final Color info;

  @override
  AppColorScheme copyWith({
    Brightness? brightness,
    bool? isHighContrast,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? surface,
    Color? surfaceVariant,
    Color? surfaceElevated,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? accentText,
    Color? brandAccent,
    Color? onBrandAccent,
    Color? complexAccent,
    Color? onComplexAccent,
    Color? outline,
    Color? outlineVariant,
    Color? error,
    Color? onError,
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return AppColorScheme(
      brightness: brightness ?? this.brightness,
      isHighContrast: isHighContrast ?? this.isHighContrast,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      accentText: accentText ?? this.accentText,
      brandAccent: brandAccent ?? this.brandAccent,
      onBrandAccent: onBrandAccent ?? this.onBrandAccent,
      complexAccent: complexAccent ?? this.complexAccent,
      onComplexAccent: onComplexAccent ?? this.onComplexAccent,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) {
      return this;
    }
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColorScheme(
      brightness: t < 0.5 ? brightness : other.brightness,
      isHighContrast: t < 0.5 ? isHighContrast : other.isHighContrast,
      primary: mix(primary, other.primary),
      onPrimary: mix(onPrimary, other.onPrimary),
      primaryContainer: mix(primaryContainer, other.primaryContainer),
      onPrimaryContainer: mix(onPrimaryContainer, other.onPrimaryContainer),
      secondaryContainer: mix(secondaryContainer, other.secondaryContainer),
      onSecondaryContainer: mix(
        onSecondaryContainer,
        other.onSecondaryContainer,
      ),
      surface: mix(surface, other.surface),
      surfaceVariant: mix(surfaceVariant, other.surfaceVariant),
      surfaceElevated: mix(surfaceElevated, other.surfaceElevated),
      onSurface: mix(onSurface, other.onSurface),
      onSurfaceVariant: mix(onSurfaceVariant, other.onSurfaceVariant),
      accentText: mix(accentText, other.accentText),
      brandAccent: mix(brandAccent, other.brandAccent),
      onBrandAccent: mix(onBrandAccent, other.onBrandAccent),
      complexAccent: mix(complexAccent, other.complexAccent),
      onComplexAccent: mix(onComplexAccent, other.onComplexAccent),
      outline: mix(outline, other.outline),
      outlineVariant: mix(outlineVariant, other.outlineVariant),
      error: mix(error, other.error),
      onError: mix(onError, other.onError),
      success: mix(success, other.success),
      warning: mix(warning, other.warning),
      info: mix(info, other.info),
    );
  }
}
