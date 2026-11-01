import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/features/settings/domain/entities/accessibility_preferences.dart';

extension AccessibilityFeaturePresentation on AccessibilityFeature {
  IconData get icon => switch (this) {
    AccessibilityFeature.readAloud => Icons.volume_up_outlined,
    AccessibilityFeature.readOnFocus => Icons.headphones_outlined,
    AccessibilityFeature.grayscale => Icons.palette_outlined,
    AccessibilityFeature.contrast => Icons.contrast,
    AccessibilityFeature.zoom => Icons.zoom_in,
    AccessibilityFeature.hideImages => Icons.hide_image_outlined,
    AccessibilityFeature.highlightLinks => Icons.link,
    AccessibilityFeature.colorBlindness => Icons.visibility_outlined,
    AccessibilityFeature.easyReading => Icons.menu_book_outlined,
    AccessibilityFeature.blueLightFilter => Icons.laptop_outlined,
    AccessibilityFeature.stopAnimations => Icons.pause_circle_outline,
    AccessibilityFeature.dyslexiaFriendly => Icons.psychology_outlined,
    AccessibilityFeature.readingGuide => Icons.horizontal_rule,
    AccessibilityFeature.focusHighlight => Icons.center_focus_strong_outlined,
    AccessibilityFeature.bigCursor => Icons.near_me_outlined,
    AccessibilityFeature.lineHeight => Icons.format_line_spacing,
    AccessibilityFeature.alignLeft => Icons.format_align_left,
    AccessibilityFeature.haptics => Icons.vibration,
  };

  String label(AppLocalizations l10n) => switch (this) {
    AccessibilityFeature.readAloud => l10n.a11yFeatureReadAloud,
    AccessibilityFeature.readOnFocus => l10n.a11yFeatureReadOnFocus,
    AccessibilityFeature.grayscale => l10n.a11yFeatureGrayscale,
    AccessibilityFeature.contrast => l10n.a11yFeatureContrast,
    AccessibilityFeature.zoom => l10n.a11yFeatureZoom,
    AccessibilityFeature.hideImages => l10n.a11yFeatureHideImages,
    AccessibilityFeature.highlightLinks => l10n.a11yFeatureHighlightLinks,
    AccessibilityFeature.colorBlindness => l10n.a11yFeatureColorBlindness,
    AccessibilityFeature.easyReading => l10n.a11yFeatureEasyReading,
    AccessibilityFeature.blueLightFilter => l10n.a11yFeatureBlueLightFilter,
    AccessibilityFeature.stopAnimations => l10n.a11yFeatureStopAnimations,
    AccessibilityFeature.dyslexiaFriendly => l10n.a11yFeatureDyslexiaFriendly,
    AccessibilityFeature.readingGuide => l10n.a11yFeatureReadingGuide,
    AccessibilityFeature.focusHighlight => l10n.a11yFeatureFocusHighlight,
    AccessibilityFeature.bigCursor => l10n.a11yFeatureBigCursor,
    AccessibilityFeature.lineHeight => l10n.a11yFeatureLineHeight,
    AccessibilityFeature.alignLeft => l10n.a11yFeatureAlignLeft,
    AccessibilityFeature.haptics => l10n.a11yFeatureHaptics,
  };

  /// [level] seviyesinin adı (ekran okuyucu ve duyuru için).
  String levelLabel(AppLocalizations l10n, int level) {
    if (level == 0) {
      return l10n.a11yLevelOff;
    }
    String pick(List<String> names) => names[level - 1];
    return switch (this) {
      AccessibilityFeature.grayscale => l10n.settingsTextScaleValue(level * 25),
      AccessibilityFeature.contrast => pick([
        l10n.a11yContrastAuto,
        l10n.a11yContrastDark,
        l10n.a11yContrastLight,
        l10n.a11yContrastInvert,
      ]),
      AccessibilityFeature.zoom => l10n.settingsTextScaleValue(
        100 + level * 25,
      ),
      AccessibilityFeature.colorBlindness => pick([
        l10n.colorBlindnessProtanopia,
        l10n.colorBlindnessDeuteranopia,
        l10n.colorBlindnessTritanopia,
      ]),
      AccessibilityFeature.blueLightFilter => pick([
        l10n.a11yBlueLightLow,
        l10n.a11yBlueLightHigh,
      ]),
      AccessibilityFeature.dyslexiaFriendly => pick([
        l10n.a11yDyslexiaFont,
        l10n.a11yDyslexiaSpacing,
        l10n.a11yDyslexiaCream,
      ]),
      AccessibilityFeature.readingGuide => pick([
        l10n.a11yGuideThin,
        l10n.a11yGuideThick,
        l10n.a11yGuideMask,
      ]),
      AccessibilityFeature.focusHighlight => pick([
        l10n.a11yFocusVisible,
        l10n.a11yFocusThick,
        l10n.a11yFocusExtra,
      ]),
      AccessibilityFeature.bigCursor => pick([
        l10n.a11yCursorLarge,
        l10n.a11yCursorExtra,
      ]),
      AccessibilityFeature.lineHeight => l10n.a11yLineHeightValue(
        NumberFormat.decimalPattern(l10n.localeName)
            .format(1.25 + level * 0.25),
      ),
      _ => l10n.a11yLevelOn,
    };
  }
}
