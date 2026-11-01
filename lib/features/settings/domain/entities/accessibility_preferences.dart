import 'package:vakif_atlas/core/theme/color_blindness_profile.dart';

/// Erişilebilirlik panelinin özellikleri; sıra paneldeki kutucuk sırasıdır.
///
/// Her özellik `0` (kapalı) ile [levels] arasında bir seviyededir; kutucuğa
/// her dokunuş bir sonraki seviyeye geçer, son seviyeden sonra kapanır.
enum AccessibilityFeature {
  /// Dokunulan öğeyi seslendirir.
  readAloud(levels: 1),

  /// Klavye / fare odağındaki öğeyi seslendirir.
  readOnFocus(levels: 1),

  /// %25 · %50 · %75 · %100 gri tonlama.
  grayscale(levels: 4),

  /// Yüksek kontrast (cihaz teması) · koyu yüksek · açık yüksek · ters renk.
  contrast(levels: 4),

  /// Metin ölçeği %125 · %150 · %175 · %200.
  zoom(levels: 4),

  /// İçerik fotoğrafları yerine alternatif metin.
  hideImages(levels: 1),

  /// Butonlar ve bağlantılar alt çizgi + çerçeveyle vurgulanır.
  highlightLinks(levels: 1),

  /// Protanopi · döteranopi · tritanopi daltonizasyonu.
  colorBlindness(levels: 3),

  /// WCAG 1.4.12 metin aralığı (harf 0,12 em, kelime 0,16 em).
  easyReading(levels: 1),

  /// Mavi ışık (sıcak renk) filtresi: hafif · güçlü.
  blueLightFilter(levels: 2),

  /// Animasyonları durdurur (cihaz ayarına eklenir).
  stopAnimations(levels: 1),

  /// Okunaklı font · + geniş aralık · + krem zemin.
  dyslexiaFriendly(levels: 3),

  /// İnce çizgi · kalın çizgi · okuma maskesi.
  readingGuide(levels: 3),

  /// Odak çerçevesi: belirgin · kalın · çok kalın.
  focusHighlight(levels: 3),

  /// Fare imleci büyük · çok büyük (yalnızca fare olan cihazda).
  bigCursor(levels: 2),

  /// Satır yüksekliği 1,5 · 1,75 · 2 · 2,25.
  lineHeight(levels: 4),

  /// Ortalanmış ve sağa yaslı metin sola (başa) hizalanır.
  alignLeft(levels: 1),

  /// Durum titreşimleri; varsayılan açık.
  haptics(levels: 1, defaultLevel: 1);

  const AccessibilityFeature({required this.levels, this.defaultLevel = 0});

  /// Kapalı dışındaki seviye sayısı.
  final int levels;

  final int defaultLevel;

  bool get isToggle => levels == 1;
}

enum ContrastMode { off, auto, dark, light, invert }

/// Uygulama genelindeki erişilebilirlik tercihleri (değer nesnesi).
final class AccessibilityPreferences {
  AccessibilityPreferences([Map<AccessibilityFeature, int> levels = const {}])
    : _levels = Map.unmodifiable({
        for (final feature in AccessibilityFeature.values)
          feature: (levels[feature] ?? feature.defaultLevel).clamp(
            0,
            feature.levels,
          ),
      });

  static final AccessibilityPreferences defaults = AccessibilityPreferences();

  static const double maxTextScale = 2;

  final Map<AccessibilityFeature, int> _levels;

  Map<AccessibilityFeature, int> get levels => _levels;

  int level(AccessibilityFeature feature) => _levels[feature]!;

  bool isOn(AccessibilityFeature feature) => level(feature) > 0;

  bool get isDefault => AccessibilityFeature.values.every(
    (feature) => level(feature) == feature.defaultLevel,
  );

  /// Bir sonraki seviye; son seviyeden sonra kapalı (0).
  AccessibilityPreferences cycle(AccessibilityFeature feature) =>
      withLevel(feature, (level(feature) + 1) % (feature.levels + 1));

  AccessibilityPreferences withLevel(AccessibilityFeature feature, int level) =>
      AccessibilityPreferences({..._levels, feature: level});

  // ── Türetilmiş değerler ──────────────────────────────────────────────

  bool get readAloud => isOn(AccessibilityFeature.readAloud);

  bool get readOnFocus => isOn(AccessibilityFeature.readOnFocus);

  /// 0 – 1 arası gri tonlama oranı.
  double get grayscale => level(AccessibilityFeature.grayscale) / 4;

  ContrastMode get contrast =>
      ContrastMode.values[level(AccessibilityFeature.contrast)];

  /// Yüksek kontrast teması kullanılır (ters renk hariç).
  bool get highContrast =>
      contrast == ContrastMode.auto ||
      contrast == ContrastMode.dark ||
      contrast == ContrastMode.light;

  bool get invertColors => contrast == ContrastMode.invert;

  /// Uygulama içi metin ölçeği: 1.0 · 1.25 · 1.5 · 1.75 · 2.0.
  double get textScaleFactor => 1 + level(AccessibilityFeature.zoom) * 0.25;

  bool get hideImages => isOn(AccessibilityFeature.hideImages);

  bool get highlightLinks => isOn(AccessibilityFeature.highlightLinks);

  ColorBlindnessProfile get colorBlindnessProfile =>
      ColorBlindnessProfile.values[level(AccessibilityFeature.colorBlindness)];

  /// 0 – 1 arası mavi ışık azaltma (hafif 0,5 · güçlü 1).
  double get blueLightFilter => level(AccessibilityFeature.blueLightFilter) / 2;

  bool get reduceMotion => isOn(AccessibilityFeature.stopAnimations);

  int get dyslexiaLevel => level(AccessibilityFeature.dyslexiaFriendly);

  /// Okunaklı (disleksi dostu) font.
  bool get legibleFont => dyslexiaLevel >= 1;

  /// WCAG 1.4.12 harf / kelime aralığı.
  bool get wideTextSpacing =>
      isOn(AccessibilityFeature.easyReading) || dyslexiaLevel >= 2;

  /// Göz yoran parlak beyaz yerine krem zemin (açık temada).
  bool get creamBackground => dyslexiaLevel >= 3;

  int get readingGuide => level(AccessibilityFeature.readingGuide);

  int get focusHighlight => level(AccessibilityFeature.focusHighlight);

  int get bigCursor => level(AccessibilityFeature.bigCursor);

  /// Satır yüksekliği çarpanı (yazı boyutuna göre); `null` → tasarım değeri.
  double? get lineHeight => switch (level(AccessibilityFeature.lineHeight)) {
    0 => null,
    final step => 1.25 + step * 0.25,
  };

  bool get alignLeft => isOn(AccessibilityFeature.alignLeft);

  bool get hapticFeedback => isOn(AccessibilityFeature.haptics);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilityPreferences &&
          AccessibilityFeature.values.every(
            (feature) => other.level(feature) == level(feature),
          );

  @override
  int get hashCode => Object.hashAll([
    for (final feature in AccessibilityFeature.values) level(feature),
  ]);

  @override
  String toString() =>
      'AccessibilityPreferences(${[for (final feature in AccessibilityFeature.values)
        if (level(feature) != feature.defaultLevel) '${feature.name}: ${level(feature)}'].join(', ')})';
}
