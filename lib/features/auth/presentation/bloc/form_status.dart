/// Kimlik doğrulama formlarının ortak gönderim durumu.
enum FormStatus {
  editing,

  /// Gönderim denendi ancak alan hataları var.
  invalid,
  submitting,
  success,
  failure,
}
