import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/network/session_events.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/saved_monuments/data/dtos/saved_monument_dtos.dart';
import 'package:vakif_atlas/features/saved_monuments/data/sources/saved_monuments_local_data_source.dart';
import 'package:vakif_atlas/features/saved_monuments/data/sources/saved_monuments_remote_data_source.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/repositories/saved_monuments_repository.dart';

/// Sunucu (`saved-monuments`) asıl kaynaktır: oturum açıksa küme hesaba,
/// misafirde kuruluma aittir. Cihazdaki kopya arayüzü anında günceller ve
/// çevrimdışı çalışır.
///
/// Oturum açılınca cihazdaki (misafir) kopya hesabın kümesiyle birleştirilir;
/// kapanınca hesabın kayıtları bu cihazdan kaldırılır ve kurulumun kümesi
/// alınır (ortak cihaz gizliliği).
///
/// Değişiklik önce yerele yazılır, "bekliyor" işaretlenir ve arka planda
/// tüm küme sunucuya gönderilir (`PUT`, idempotent). Okumada bekleyen
/// değişiklik yoksa sunucudaki küme yerele alınır. Eşitleme hatası
/// kullanıcıya yansımaz; bağlantı gelince sonraki okuma/değişiklik yeniden
/// dener. Eşitlemeler sıraya alınır; eşitleme sürerken yapılan değişiklik
/// sunucu yanıtıyla ezilmez.
@LazySingleton(as: SavedMonumentsRepository)
class SavedMonumentsRepositoryImpl implements SavedMonumentsRepository {
  SavedMonumentsRepositoryImpl(
    this._local,
    this._remote,
    SessionEvents sessionEvents,
  ) {
    sessionEvents.onAccountChanged.listen(
      (userId) => unawaited(_onAccountChanged(signedIn: userId != null)),
    );
  }

  final SavedMonumentsLocalDataSource _local;
  final SavedMonumentsRemoteDataSource _remote;
  final StreamController<List<SavedMonument>> _changes =
      StreamController<List<SavedMonument>>.broadcast();

  /// Her yerel değişiklikte artar; eşitleme başladığından beri değişiklik
  /// olduysa sunucu yanıtı yerel kopyanın üzerine yazılmaz.
  int _revision = 0;
  Future<void>? _sync;
  bool _syncAgain = false;

  /// Yerel yazımlar ile eşitlemenin sonucu uygulaması birbirini kesmez.
  /// `null` → kilit boş; işlem beklemeden başlar (önceden tamamlanmış bir
  /// future'a zincirlenmez — farklı zone'da oluşturulmuş olabilir).
  Future<void>? _lock;
  int _pending = 0;

  @override
  Stream<List<SavedMonument>> get changes => _changes.stream;

  @override
  ResultFuture<List<SavedMonument>> getSaved() async {
    try {
      // Kilit içinde: eşitlemenin `replaceAll`'ı yarıdayken okunmaz.
      final saved = await _exclusive(_readSorted);
      unawaited(synchronize());
      return Right(saved);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  ResultFuture<SaveMonumentOutcome> save(SavedMonument monument) async {
    var outcome = SaveMonumentOutcome.saved;
    final result = await _write(() async {
      final saved = await _local.readAll();
      if (saved.any((item) => item.monumentId == monument.monumentId)) {
        outcome = SaveMonumentOutcome.alreadySaved;
        return false;
      }
      if (saved.length >= SavedMonumentRules.maxSaved) {
        outcome = SaveMonumentOutcome.limitReached;
        return false;
      }
      await _local.put(monument);
      return true;
    });
    return result.map((_) => outcome);
  }

  @override
  ResultFuture<Unit> remove(String monumentId) => _write(() async {
    await _local.remove(monumentId);
    return true;
  });

  /// Cihazdaki kopyayı sunucuyla eşitler; tamamlanınca (başarılı ya da
  /// değil) biter, hata fırlatmaz.
  Future<void> synchronize() {
    final running = _sync;
    if (running != null) {
      _syncAgain = true;
      return running;
    }
    return _sync = _runSync().whenComplete(() => _sync = null);
  }

  Future<void> _onAccountChanged({required bool signedIn}) async {
    try {
      await _exclusive(() async {
        // Süren eşitlemenin yanıtı eski sahibin kümesidir; uygulanmaz.
        _revision++;
        if (signedIn) {
          await _local.writeSyncState(SavedMonumentsSyncState.neverSynced);
        } else {
          await _local.replaceAll(const []);
          await _local.writeSyncState(SavedMonumentsSyncState.synced);
          _emit(const []);
        }
      });
    } on CacheException {
      // Yerel kopya güncellenemedi; sonraki eşitleme sunucudan düzeltir.
    }
    unawaited(synchronize());
  }

  /// [write] değişiklik yapmadıysa `false` döner; o durumda eşitleme
  /// tetiklenmez.
  ResultFuture<Unit> _write(Future<bool> Function() write) async {
    var changed = false;
    try {
      await _exclusive(() async {
        changed = await write();
        if (!changed) {
          return;
        }
        _revision++;
        await _local.writeSyncState(SavedMonumentsSyncState.pending);
        _emit(await _readSorted());
      });
    } on CacheException {
      return const Left(CacheFailure());
    }
    if (changed) {
      unawaited(synchronize());
    }
    return const Right(unit);
  }

  Future<void> _runSync() async {
    do {
      _syncAgain = false;
      await _syncOnce();
    } while (_syncAgain);
  }

  Future<void> _syncOnce() async {
    final revision = _revision;
    try {
      final state = await _local.readSyncState();
      final List<SavedMonument> server;
      switch (state) {
        case SavedMonumentsSyncState.synced:
          server = _toDomain(await _remote.fetch());
        case SavedMonumentsSyncState.pending:
          server = _toDomain(await _remote.replace(_toDto(await _readAll())));
        case SavedMonumentsSyncState.neverSynced:
          final merged = _merge(_toDomain(await _remote.fetch()), [
            ...await _readAll(),
          ]);
          server = _toDomain(await _remote.replace(_toDto(merged)));
      }
      await _exclusive(() async {
        if (revision != _revision) {
          // Eşitleme sürerken değişiklik oldu: o da gönderilecek.
          _syncAgain = true;
          return;
        }
        final current = await _readSorted();
        await _local.replaceAll(server);
        await _local.writeSyncState(SavedMonumentsSyncState.synced);
        final updated = await _readSorted();
        if (!_sameItems(current, updated)) {
          _emit(updated);
        }
      });
    } on Exception {
      // Ağ / sunucu / önbellek hatası: yerel kopya korunur, sonra denenir.
    }
  }

  Future<T> _exclusive<T>(Future<T> Function() action) {
    final previous = _lock;
    final result = previous == null ? action() : previous.then((_) => action());
    _pending++;
    _lock = result.then<void>((_) {}, onError: (Object _) {}).whenComplete(() {
      if (--_pending == 0) {
        _lock = null;
      }
    });
    return result;
  }

  void _emit(List<SavedMonument> saved) {
    if (!_changes.isClosed) {
      _changes.add(saved);
    }
  }

  Future<List<SavedMonument>> _readAll() => _local.readAll();

  Future<List<SavedMonument>> _readSorted() async =>
      List.unmodifiable(_sorted(await _local.readAll()));

  static List<SavedMonument> _sorted(List<SavedMonument> saved) =>
      saved..sort((a, b) {
        final byDate = b.savedAt.compareTo(a.savedAt);
        return byDate != 0 ? byDate : a.monumentId.compareTo(b.monumentId);
      });

  /// İlk eşitleme: iki taraftaki kayıtların birleşimi (aynı eserde erken
  /// kaydetme zamanı), sınırı aşarsa en yeniler.
  static List<SavedMonument> _merge(
    List<SavedMonument> server,
    List<SavedMonument> device,
  ) {
    final byId = <String, SavedMonument>{};
    for (final item in [...server, ...device]) {
      final existing = byId[item.monumentId];
      if (existing == null || item.savedAt.isBefore(existing.savedAt)) {
        byId[item.monumentId] = item;
      }
    }
    return _sorted(byId.values.toList())
        .take(SavedMonumentRules.maxSaved)
        .toList();
  }

  static bool _sameItems(List<SavedMonument> a, List<SavedMonument> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  static List<SavedMonument> _toDomain(List<SavedMonumentDto> items) => [
    for (final item in items) item.toDomain(),
  ];

  static List<SavedMonumentDto> _toDto(List<SavedMonument> items) => [
    for (final item in items) SavedMonumentDto.fromDomain(item),
  ];
}
