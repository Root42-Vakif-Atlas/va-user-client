/// Vakıf eserinin yapı türü.
///
/// Sunucu yeni bir tür eklediğinde istemci [other] ile çalışmaya devam eder.
enum MonumentCategory {
  mosque,

  /// Cami, medrese, türbe, hamam gibi yapılardan oluşan yapı topluluğu.
  complex,
  madrasa,

  /// Şehir içi ticaret ve konaklama hanı.
  inn,

  /// Yol üzerindeki konaklama yapısı.
  caravanserai,
  bath,
  fountain,

  /// Türbe.
  tomb,

  /// Darüşşifa (hastane).
  hospital,

  /// İmaret / darüzziyafe (aşevi).
  imaret,
  other,
}

/// Eserin inşa edildiği tarihî dönem.
enum HistoricalPeriod {
  /// Büyük Selçuklu ve Anadolu Selçuklu.
  seljuk,

  /// Anadolu beylikleri (ör. Mengücekliler).
  beylik,
  ottoman,
  other,
}
