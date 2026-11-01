import 'package:flutter/material.dart';
import 'package:vakif_atlas/core/theme/app_theme_options.dart';
import 'package:vakif_atlas/core/theme/extensions/app_color_scheme.dart';
import 'package:vakif_atlas/core/theme/extensions/app_text_theme.dart';
import 'package:vakif_atlas/core/theme/tokens/app_colors.dart';
import 'package:vakif_atlas/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas/core/theme/tokens/app_typography.dart';

/// Dört tema varyantının fabrikası (Design System §3.1).
///
/// Material 3 rolleri marka renklerinden üretilir: birincil = Koyu Yeşil
/// ailesi, üçüncül (tertiary) = Antik Altın vurgusu, yüzeyler nötr tonal
/// basamaklar. Yüzen yüzeyler (alt sayfa, diyalog, menü, gezinme çubuğu)
/// `surfaceElevated` kullanır; yüzey tonlaması (surface tint) kapalıdır.
abstract final class AppTheme {
  static ThemeData dark() => fromColors(AppColorScheme.dark);

  static ThemeData light() => fromColors(AppColorScheme.light);

  /// WCAG 2.2 — metin için minimum 7:1 kontrast.
  static ThemeData highContrastDark() =>
      fromColors(AppColorScheme.highContrastDark);

  /// WCAG 2.2 — metin için minimum 7:1 kontrast.
  static ThemeData highContrastLight() =>
      fromColors(AppColorScheme.highContrastLight);

  /// [options]: erişilebilirlik panelinin temaya yansıyan tercihleri.
  static ThemeData fromColors(
    AppColorScheme base, {
    AppThemeOptions options = AppThemeOptions.standard,
  }) {
    final cream =
        options.creamBackground &&
        base.brightness == Brightness.light &&
        !base.isHighContrast;
    final colors = cream
        ? base.copyWith(
            surface: AppColors.warmIvory,
            surfaceElevated: AppColors.warmIvory,
          )
        : base;
    final textTheme = AppTextTheme.fromColors(colors, options: options);
    final materialTextTheme = textTheme.toMaterialTextTheme();
    final borderWidth = colors.isHighContrast
        ? AppSizes.borderThick
        : AppSizes.borderThin;
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
    );
    const buttonMinimumSize = Size(
      AppSizes.minTouchTarget,
      AppSizes.minTouchTarget,
    );
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.sm,
    );

    // Ters yüzeydeki (snackbar) eylem rengi: zıt temanın birincil tonu.
    final inversePrimary = colors.isHighContrast
        ? colors.surface
        : (colors.brightness == Brightness.light
              ? AppColors.green80
              : AppColors.green30);

    // "Bağlantıları vurgula": metin butonları alt çizgili ve çerçeveli,
    // ikon butonları çerçeveli (yalnızca renge dayanmayan ayırt edicilik).
    final linkSide = options.highlightLinks
        ? BorderSide(color: colors.accentText, width: AppSizes.borderThick)
        : null;
    final linkTextStyle = options.highlightLinks
        ? textTheme.labelLarge.copyWith(decoration: TextDecoration.underline)
        : textTheme.labelLarge;

    final colorScheme = ColorScheme(
      brightness: colors.brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      primaryContainer: colors.primaryContainer,
      onPrimaryContainer: colors.onPrimaryContainer,
      secondary: colors.accentText,
      onSecondary: colors.surface,
      secondaryContainer: colors.secondaryContainer,
      onSecondaryContainer: colors.onSecondaryContainer,
      tertiary: colors.brandAccent,
      onTertiary: colors.onBrandAccent,
      error: colors.error,
      onError: colors.onError,
      surface: colors.surface,
      onSurface: colors.onSurface,
      onSurfaceVariant: colors.onSurfaceVariant,
      surfaceContainerLowest: colors.surface,
      surfaceContainerLow: colors.surfaceElevated,
      surfaceContainer: colors.surfaceVariant,
      surfaceContainerHigh: colors.surfaceElevated,
      surfaceContainerHighest: colors.surfaceVariant,
      outline: colors.outline,
      outlineVariant: colors.outlineVariant,
      inverseSurface: colors.onSurface,
      onInverseSurface: colors.surface,
      inversePrimary: inversePrimary,
      surfaceTint: Colors.transparent,
    );
    final sheetShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    );

    OutlineInputBorder inputBorder(Color color, double width) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      useMaterial3: true,
      brightness: colors.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.surface,
      canvasColor: colors.surface,
      fontFamily: options.legibleFont
          ? AppFonts.atkinsonHyperlegible
          : AppFonts.inter,
      textTheme: materialTextTheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      extensions: [colors, textTheme],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        // İçerik altına kaydığında renk değil ince çizgiyle ayrışır.
        scrolledUnderElevation: 0,
        shape: Border(
          bottom: BorderSide(
            color: colors.outlineVariant,
            width: AppSizes.borderThin,
          ),
        ),
        centerTitle: false,
        // Sayfa başlığı: büyük ve kalın, başa hizalı (yaygın mobil uygulama
        // başlığı). Font ailesi (ör. Disleksi Dostu) başlık stilinden gelir.
        titleTextStyle: textTheme.titleLarge.copyWith(
          fontSize: AppTypography.appBarTitleSize,
          height: AppTypography.appBarTitleHeight,
          fontWeight: FontWeight.w700,
          fontVariations: const [FontVariation('wght', 700)],
          letterSpacing: -0.2,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant,
        thickness: AppSizes.borderThin,
        space: AppSpacing.md,
      ),
      iconTheme: IconThemeData(color: colors.onSurface, size: AppSizes.iconMd),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          minimumSize: buttonMinimumSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: linkTextStyle,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.accentText,
          minimumSize: buttonMinimumSize,
          padding: buttonPadding,
          shape: buttonShape,
          side: BorderSide(color: colors.outline, width: borderWidth),
          textStyle: linkTextStyle,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.accentText,
          minimumSize: buttonMinimumSize,
          padding: buttonPadding,
          shape: buttonShape,
          side: linkSide,
          textStyle: linkTextStyle,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colors.onSurface,
          minimumSize: buttonMinimumSize,
          side: linkSide,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceVariant,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: textTheme.bodyLarge.copyWith(
          color: colors.onSurfaceVariant,
        ),
        floatingLabelStyle: textTheme.bodyLarge.copyWith(
          color: colors.accentText,
        ),
        hintStyle: textTheme.bodyMedium.copyWith(
          color: colors.onSurfaceVariant,
        ),
        helperStyle: textTheme.bodySmall,
        errorStyle: textTheme.bodySmall.copyWith(color: colors.error),
        errorMaxLines: 3,
        helperMaxLines: 3,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: inputBorder(colors.outline, borderWidth),
        enabledBorder: inputBorder(colors.outline, borderWidth),
        focusedBorder: inputBorder(colors.accentText, AppSizes.borderThick),
        errorBorder: inputBorder(colors.error, borderWidth),
        focusedErrorBorder: inputBorder(colors.error, AppSizes.borderThick),
        disabledBorder: inputBorder(colors.outlineVariant, borderWidth),
      ),
      // Seçili sekme: düşük vurgulu gösterge + dolu ikon + kalın etiket
      // (yalnızca renge dayanmaz, WCAG 1.4.1).
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surfaceElevated,
        indicatorColor: colors.secondaryContainer,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colors.onSecondaryContainer
                : colors.onSurfaceVariant,
            size: AppSizes.iconMd,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? textTheme.labelMedium.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontVariations: const [FontVariation('wght', 700)],
                )
              : textTheme.labelMedium.copyWith(color: colors.onSurfaceVariant),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colors.surfaceElevated,
        indicatorColor: colors.secondaryContainer,
        labelType: NavigationRailLabelType.all,
        selectedIconTheme: IconThemeData(
          color: colors.onSecondaryContainer,
          size: AppSizes.iconMd,
        ),
        unselectedIconTheme: IconThemeData(
          color: colors.onSurfaceVariant,
          size: AppSizes.iconMd,
        ),
        selectedLabelTextStyle: textTheme.labelMedium,
        unselectedLabelTextStyle: textTheme.labelMedium.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.onSurfaceVariant,
        textColor: colors.onSurface,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium.copyWith(
          color: colors.onSurfaceVariant,
        ),
        minVerticalPadding: AppSpacing.sm,
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.accentText
              : colors.outline,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.onPrimary
              : colors.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.primary
              : colors.surfaceVariant,
        ),
        trackOutlineColor: WidgetStatePropertyAll(colors.outline),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colors.accentText,
        inactiveTrackColor: colors.outline,
        thumbColor: colors.accentText,
        valueIndicatorColor: colors.primary,
        valueIndicatorTextStyle: textTheme.labelLarge.copyWith(
          color: colors.onPrimary,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.accentText,
        circularTrackColor: colors.outlineVariant,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.onSurface,
        contentTextStyle: textTheme.bodyMedium.copyWith(color: colors.surface),
        actionTextColor: inversePrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      bannerTheme: MaterialBannerThemeData(
        backgroundColor: colors.surfaceVariant,
        contentTextStyle: textTheme.bodyMedium,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyLarge,
        shape: sheetShape,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceElevated,
        modalBackgroundColor: colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        dragHandleColor: colors.onSurfaceVariant,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        textStyle: textTheme.bodyLarge,
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: colors.outlineVariant,
            width: AppSizes.borderThin,
          ),
        ),
      ),
      // Seçili çip: düşük vurgulu dolgu + onay işareti; seçili olmayan:
      // ≥ 3:1 kontur (WCAG 1.4.11).
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceElevated,
        selectedColor: colors.secondaryContainer,
        checkmarkColor: colors.onSecondaryContainer,
        labelStyle: textTheme.labelLarge.copyWith(
          color: colors.onSurfaceVariant,
        ),
        secondaryLabelStyle: textTheme.labelLarge.copyWith(
          color: colors.onSecondaryContainer,
        ),
        iconTheme: IconThemeData(
          color: colors.onSurfaceVariant,
          size: AppSizes.iconInline,
        ),
        side: WidgetStateBorderSide.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) && !colors.isHighContrast
              ? BorderSide.none
              : BorderSide(color: colors.outline, width: borderWidth),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      ),
      // Ana eylem: birincil dolgu, marka köşe yarıçapı (stadium değil).
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: AppSizes.borderThick,
        focusElevation: AppSizes.borderThick,
        hoverElevation: AppSizes.borderThick,
        highlightElevation: AppSizes.borderThick,
        extendedTextStyle: textTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: colors.primary,
        textColor: colors.onPrimary,
      ),
    );
  }
}
