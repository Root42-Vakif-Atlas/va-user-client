import 'package:flutter/widgets.dart';
import 'package:vakif_atlas/core/theme/color_blindness_profile.dart';

/// Uygulama kök ağacını saran erişilebilirlik renk filtresi: renk körlüğü
/// telafisi, gri tonlama, ters renk ve mavi ışık (sıcak renk) filtresi tek
/// bir [ColorFilter.matrix]'e birleştirilir (GPU'da tek katman).
///
/// Filtre kapalıyken (birim matris) ağaca hiçbir katman eklenmez; böylece
/// `saveLayer` maliyeti oluşmaz. Alt ağaç [GlobalKey] ile taşındığından
/// filtre açılıp kapandığında yeniden kurulmaz (gezinme yığını, açık sayfa
/// ve bildirim katmanlarının durumu korunur).
class AccessibilityColorFilter extends StatefulWidget {
  const AccessibilityColorFilter({
    required this.child,
    this.profile = ColorBlindnessProfile.none,
    this.grayscale = 0,
    this.invert = false,
    this.blueLightFilter = 0,
    super.key,
  });

  final ColorBlindnessProfile profile;

  /// 0 – 1 arası gri tonlama oranı.
  final double grayscale;

  final bool invert;

  /// 0 – 1 arası mavi ışık azaltma.
  final double blueLightFilter;

  final Widget child;

  @override
  State<AccessibilityColorFilter> createState() =>
      _AccessibilityColorFilterState();
}

class _AccessibilityColorFilterState extends State<AccessibilityColorFilter> {
  final GlobalKey _subtree = GlobalKey(debugLabel: 'color_filter_subtree');

  @override
  Widget build(BuildContext context) {
    final child = KeyedSubtree(key: _subtree, child: widget.child);
    final matrix = ColorMatrices.combined(
      profile: widget.profile,
      grayscale: widget.grayscale,
      invert: widget.invert,
      blueLightFilter: widget.blueLightFilter,
    );
    if (matrix == null) {
      return child;
    }
    return ColorFiltered(colorFilter: ColorFilter.matrix(matrix), child: child);
  }
}

/// 4×5 renk matrislerinin birleştirilmesi (satır öncelikli, öteleme sütunu
/// 0 – 255 ölçeğinde).
abstract final class ColorMatrices {
  static const List<double> identity = [
    1, 0, 0, 0, 0, //
    0, 1, 0, 0, 0, //
    0, 0, 1, 0, 0, //
    0, 0, 0, 1, 0,
  ];

  static const List<double> invert = [
    -1, 0, 0, 0, 255, //
    0, -1, 0, 0, 255, //
    0, 0, -1, 0, 255, //
    0, 0, 0, 1, 0,
  ];

  /// [amount] (0 – 1) oranında gri tonlama (Rec. 709 parlaklığı).
  static List<double> grayscale(double amount) {
    const r = 0.2126;
    const g = 0.7152;
    const b = 0.0722;
    double mix(double gray, double own) => own + (gray - own) * amount;
    return [
      mix(r, 1), mix(g, 0), mix(b, 0), 0, 0, //
      mix(r, 0), mix(g, 1), mix(b, 0), 0, 0, //
      mix(r, 0), mix(g, 0), mix(b, 1), 0, 0, //
      0, 0, 0, 1, 0,
    ];
  }

  /// Mavi ışık azaltma: [amount] 1'de mavi %45, yeşil %10 azalır.
  static List<double> blueLight(double amount) => [
    1, 0, 0, 0, 0, //
    0, 1 - 0.10 * amount, 0, 0, 0, //
    0, 0, 1 - 0.45 * amount, 0, 0, //
    0, 0, 0, 1, 0,
  ];

  /// Uygulama sırası: renk körlüğü telafisi → gri tonlama → ters renk →
  /// mavi ışık. Hepsi kapalıysa `null`.
  static List<double>? combined({
    required ColorBlindnessProfile profile,
    required double grayscale,
    required bool invert,
    required double blueLightFilter,
  }) {
    final steps = [
      if (profile != ColorBlindnessProfile.none)
        DaltonizationMatrix.forProfile(profile),
      if (grayscale > 0) ColorMatrices.grayscale(grayscale),
      if (invert) ColorMatrices.invert,
      if (blueLightFilter > 0) blueLight(blueLightFilter),
    ];
    if (steps.isEmpty) {
      return null;
    }
    return List.unmodifiable(
      steps.skip(1).fold<List<double>>(steps.first, then),
    );
  }

  /// Önce [first], sonra [second] uygulanan matris (`second · first`).
  static List<double> then(List<double> first, List<double> second) {
    double at(List<double> m, int row, int col) =>
        col < 5 ? m[row * 5 + col] : 0;
    return [
      for (var row = 0; row < 4; row++)
        for (var col = 0; col < 5; col++)
          at(second, row, 0) * at(first, 0, col) +
              at(second, row, 1) * at(first, 1, col) +
              at(second, row, 2) * at(first, 2, col) +
              at(second, row, 3) * at(first, 3, col) +
              (col == 4 ? at(second, row, 4) : 0),
    ];
  }
}

/// Daltonizasyon (renk körlüğü telafisi) matrisleri.
///
/// Simülasyon matrisi `S`, renk körü bir kullanıcının algısını modeller
/// (Machado, Oliveira & Fernandes 2009, şiddet 1.0). Algılanamayan renk
/// hatası `c − S·c`, hata kaydırma matrisi `E` ile kullanıcının ayırt
/// edebildiği kanallara aktarılır (Fidaner, Lin & Ozguven):
///
/// `c' = c + E·(c − S·c) = (I + E·(I − S))·c`
///
/// İşlem doğrusal olduğundan tek bir 3×3 matrise indirgenir ve GPU'da tek
/// bir `ColorFilter.matrix` ile uygulanır.
///
/// Matris gama kodlu sRGB değerlerine uygulanır (Machado modeli lineer RGB
/// için tanımlıdır). Bu bilinçli bir tercihtir, ölçümle doğrulandı:
/// - Renk körü algısı doğru modelle (lineer uzayda Machado) ölçüldüğünde,
///   karışan renk çiftlerinin ayrımı gama uzayında lineer uzaydaki kadar
///   artar (rastgele karışan çiftlerde ortalama ΔE: protanopi 5 → 29,5 /
///   lineerde 27; döteranopi 5,6 → 26,6 / 26,4; tritanopi 5,5 → 11,4 / 9,2).
/// - Lineer uzay için gereken `srgbToLinearGamma` → matris →
///   `linearToSrgbGamma` zinciri Impeller'da 8 bitlik ara katmandan geçer;
///   koyu tonlar 3 seviyeye kadar kayar (koyu temada bantlanma).
abstract final class DaltonizationMatrix {
  static const List<double> _identity3 = [1, 0, 0, 0, 1, 0, 0, 0, 1];

  static const Map<ColorBlindnessProfile, List<double>> simulation = {
    ColorBlindnessProfile.protanopia: [
      0.152286, 1.052583, -0.204868, //
      0.114503, 0.786281, 0.099216, //
      -0.003882, -0.048116, 1.051998,
    ],
    ColorBlindnessProfile.deuteranopia: [
      0.367322, 0.860646, -0.227968, //
      0.280085, 0.672501, 0.047413, //
      -0.011820, 0.042940, 0.968881,
    ],
    ColorBlindnessProfile.tritanopia: [
      1.255528, -0.076749, -0.178779, //
      -0.078411, 0.930809, 0.147602, //
      0.004733, 0.691367, 0.303900,
    ],
  };

  /// Kırmızı/yeşil hatayı mavi ve yeşil kanallara kaydırır.
  static const List<double> _redGreenShift = [
    0, 0, 0, //
    0.7, 1, 0, //
    0.7, 0, 1,
  ];

  /// Mavi hatayı kırmızı ve yeşil kanallara kaydırır.
  static const List<double> _blueShift = [
    1, 0, 0.7, //
    0, 1, 0.7, //
    0, 0, 0,
  ];

  static final Map<ColorBlindnessProfile, List<double>> _cache = {};

  /// [profile] için 3×3 (satır öncelikli) telafi matrisi.
  static List<double> correction3x3(ColorBlindnessProfile profile) {
    final simulationMatrix = simulation[profile];
    if (simulationMatrix == null) {
      return _identity3;
    }
    final shift = profile == ColorBlindnessProfile.tritanopia
        ? _blueShift
        : _redGreenShift;
    final error = _subtract(_identity3, simulationMatrix);
    return _add(_identity3, _multiply(shift, error));
  }

  /// [ColorFilter.matrix] için 4×5 (20 elemanlı) matris.
  static List<double> forProfile(ColorBlindnessProfile profile) {
    return _cache.putIfAbsent(profile, () {
      final m = correction3x3(profile);
      return List.unmodifiable(<double>[
        m[0], m[1], m[2], 0, 0, //
        m[3], m[4], m[5], 0, 0, //
        m[6], m[7], m[8], 0, 0, //
        0, 0, 0, 1, 0,
      ]);
    });
  }

  static List<double> _multiply(List<double> a, List<double> b) {
    return [
      for (var row = 0; row < 3; row++)
        for (var col = 0; col < 3; col++)
          a[row * 3] * b[col] +
              a[row * 3 + 1] * b[3 + col] +
              a[row * 3 + 2] * b[6 + col],
    ];
  }

  static List<double> _add(List<double> a, List<double> b) => [
    for (var i = 0; i < 9; i++) a[i] + b[i],
  ];

  static List<double> _subtract(List<double> a, List<double> b) => [
    for (var i = 0; i < 9; i++) a[i] - b[i],
  ];
}
