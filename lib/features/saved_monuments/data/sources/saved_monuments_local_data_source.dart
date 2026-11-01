import 'package:hive_ce/hive_ce.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/storage/local_db_service.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';

/// Cihazdaki kopyanın sunucuyla eşitlenme durumu.
enum SavedMonumentsSyncState {
  /// Bu kurulumda hiç eşitlenmedi (ör. sunucu öncesi sürümden kalan
  /// kayıtlar): ilk eşitlemede iki taraf birleştirilir.
  neverSynced,

  /// Yerel değişiklik sunucuya gönderilmeyi bekliyor.
  pending,

  synced,
}

/// Kaydedilen eserlerin cihazdaki kopyası (çevrimdışı kullanım ve anında
/// arayüz): anahtar eser kimliği, değer kaydetme zamanı (UTC, ISO 8601).
/// Hatalar `CacheException` olarak fırlatılır.
abstract interface class SavedMonumentsLocalDataSource {
  Future<List<SavedMonument>> readAll();

  Future<void> put(SavedMonument monument);

  Future<void> remove(String monumentId);

  /// Kopyayı sunucudaki kümeyle değiştirir.
  Future<void> replaceAll(List<SavedMonument> monuments);

  Future<SavedMonumentsSyncState> readSyncState();

  Future<void> writeSyncState(SavedMonumentsSyncState state);
}

@LazySingleton(as: SavedMonumentsLocalDataSource)
class SavedMonumentsLocalDataSourceImpl
    implements SavedMonumentsLocalDataSource {
  SavedMonumentsLocalDataSourceImpl(this._db);

  static const String boxName = 'saved_monuments.v1';
  static const String syncBoxName = 'saved_monuments.sync.v1';
  static const String _syncStateKey = 'state';

  final LocalDbService _db;

  @override
  Future<List<SavedMonument>> readAll() async {
    final box = await _db.openBox<String>(boxName);
    final saved = <SavedMonument>[];
    for (final key in box.keys.whereType<String>().toList()) {
      final String? raw;
      try {
        raw = box.get(key);
      } on HiveError {
        throw const CacheException('saved_monuments.read');
      }
      final savedAt = DateTime.tryParse(raw ?? '');
      if (savedAt == null) {
        // Bozuk kayıt sessizce temizlenir.
        await _guard(() => box.delete(key));
        continue;
      }
      saved.add(SavedMonument(monumentId: key, savedAt: savedAt.toUtc()));
    }
    return saved;
  }

  @override
  Future<void> put(SavedMonument monument) async {
    final box = await _db.openBox<String>(boxName);
    await _guard(
      () => box.put(
        monument.monumentId,
        monument.savedAt.toUtc().toIso8601String(),
      ),
    );
  }

  @override
  Future<void> remove(String monumentId) async {
    final box = await _db.openBox<String>(boxName);
    await _guard(() => box.delete(monumentId));
  }

  @override
  Future<void> replaceAll(List<SavedMonument> monuments) async {
    final box = await _db.openBox<String>(boxName);
    final next = {
      for (final monument in monuments)
        monument.monumentId: monument.savedAt.toUtc().toIso8601String(),
    };
    // Önce yeni küme yazılır, sonra fazlalar silinir: arada okuyan boş liste
    // görmez.
    await _guard(() async {
      await box.putAll(next);
      await box.deleteAll(
        box.keys.whereType<String>().where((key) => !next.containsKey(key)),
      );
    });
  }

  @override
  Future<SavedMonumentsSyncState> readSyncState() async {
    final box = await _db.openBox<String>(syncBoxName);
    final raw = box.get(_syncStateKey);
    return SavedMonumentsSyncState.values
            .where((state) => state.name == raw)
            .firstOrNull ??
        SavedMonumentsSyncState.neverSynced;
  }

  @override
  Future<void> writeSyncState(SavedMonumentsSyncState state) async {
    final box = await _db.openBox<String>(syncBoxName);
    await _guard(() => box.put(_syncStateKey, state.name));
  }

  static Future<void> _guard(Future<void> Function() write) async {
    try {
      await write();
    } on Exception {
      throw const CacheException('saved_monuments.write');
    } on HiveError {
      // Hive hataları `Error`'dır; eşitleme ve arayüz yalnızca
      // `CacheException` bekler.
      throw const CacheException('saved_monuments.write');
    }
  }
}
