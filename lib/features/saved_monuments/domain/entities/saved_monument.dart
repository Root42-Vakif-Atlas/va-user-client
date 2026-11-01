/// Kullanıcının kaydettiği eser. Yalnızca kimlik ve kaydetme zamanı
/// saklanır (sunucuda kuruluma bağlı + cihazda kopya); eser bilgisi
/// katalogdan güncel dilde çözülür.
final class SavedMonument {
  const SavedMonument({required this.monumentId, required this.savedAt});

  final String monumentId;
  final DateTime savedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedMonument &&
          other.monumentId == monumentId &&
          other.savedAt == savedAt;

  @override
  int get hashCode => Object.hash(monumentId, savedAt);

  @override
  String toString() => 'SavedMonument($monumentId)';
}

abstract final class SavedMonumentRules {
  /// En fazla kayıt (sunucu da uygular); liste katalogdan 50'lik
  /// parçalarla çözülür.
  static const int maxSaved = 100;
}

/// Kaydetme isteğinin sonucu.
enum SaveMonumentOutcome {
  saved,

  /// Eser zaten kayıtlıydı; değişiklik yapılmadı.
  alreadySaved,

  /// [SavedMonumentRules.maxSaved] dolu.
  limitReached,
}
