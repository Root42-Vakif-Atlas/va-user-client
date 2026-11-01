/// Uygulama içinden seçilebilen renk görme profili.
enum ColorBlindnessProfile {
  /// Filtre uygulanmaz.
  none,

  /// Kırmızı (L-koni) renk körlüğü.
  protanopia,

  /// Yeşil (M-koni) renk körlüğü.
  deuteranopia,

  /// Mavi (S-koni) renk körlüğü.
  tritanopia,
}
