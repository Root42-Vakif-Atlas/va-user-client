import 'dart:async';

import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/network/session_events.dart';
import 'package:vakif_atlas/features/saved_monuments/data/dtos/saved_monument_dtos.dart';
import 'package:vakif_atlas/features/saved_monuments/data/repositories/saved_monuments_repository_impl.dart';
import 'package:vakif_atlas/features/saved_monuments/data/sources/saved_monuments_local_data_source.dart';
import 'package:vakif_atlas/features/saved_monuments/data/sources/saved_monuments_remote_data_source.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/entities/saved_monument.dart';
import 'package:vakif_atlas/features/saved_monuments/domain/usecases/saved_monuments_usecases.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_cubit.dart';
import 'package:vakif_atlas/features/saved_monuments/presentation/cubit/saved_monuments_list_cubit.dart';

import 'catalog_test_utils.dart';

/// Bellekte tutulan kaydedilenler; [failWrites] yazma hatası üretir.
class InMemorySavedMonumentsLocalDataSource
    implements SavedMonumentsLocalDataSource {
  InMemorySavedMonumentsLocalDataSource([Iterable<SavedMonument>? initial])
    : _items = {
        for (final item in initial ?? <SavedMonument>[]) item.monumentId: item,
      };

  final Map<String, SavedMonument> _items;
  bool failWrites = false;
  SavedMonumentsSyncState syncState = SavedMonumentsSyncState.neverSynced;

  @override
  Future<List<SavedMonument>> readAll() async => _items.values.toList();

  @override
  Future<void> put(SavedMonument monument) async {
    _check();
    _items[monument.monumentId] = monument;
  }

  @override
  Future<void> remove(String monumentId) async {
    _check();
    _items.remove(monumentId);
  }

  @override
  Future<void> replaceAll(List<SavedMonument> monuments) async {
    _check();
    _items
      ..clear()
      ..addAll({for (final item in monuments) item.monumentId: item});
  }

  @override
  Future<SavedMonumentsSyncState> readSyncState() async => syncState;

  @override
  Future<void> writeSyncState(SavedMonumentsSyncState state) async {
    _check();
    syncState = state;
  }

  void _check() {
    if (failWrites) {
      throw const CacheException('test.write');
    }
  }
}

/// Sunucudaki küme (bellekte); [offline] iken her istek ağ hatası verir.
class FakeSavedMonumentsRemoteDataSource
    implements SavedMonumentsRemoteDataSource {
  FakeSavedMonumentsRemoteDataSource([Iterable<SavedMonument>? initial])
    : items = [
        for (final item in initial ?? <SavedMonument>[])
          SavedMonumentDto.fromDomain(item),
      ];

  List<SavedMonumentDto> items;
  bool offline = false;
  int fetches = 0;
  int replaces = 0;

  /// Verilirse sunucu yanıtı bu tamamlanana kadar bekletilir.
  Completer<void>? gate;

  @override
  Future<List<SavedMonumentDto>> fetch() async {
    await _respond();
    fetches++;
    return _newestFirst(items);
  }

  @override
  Future<List<SavedMonumentDto>> replace(List<SavedMonumentDto> next) async {
    await _respond();
    replaces++;
    items = [...next];
    return _newestFirst(items);
  }

  Future<void> _respond() async {
    await gate?.future;
    if (offline) {
      throw const NetworkException(NetworkExceptionType.noConnection);
    }
  }

  static List<SavedMonumentDto> _newestFirst(List<SavedMonumentDto> items) =>
      [...items]..sort((a, b) => b.savedAt.compareTo(a.savedAt));
}

/// Kaydedilenler test ortamı: depo, use case'ler ve cubit fabrikaları.
final class SavedMonumentsTestEnvironment {
  SavedMonumentsTestEnvironment({
    Iterable<SavedMonument>? initial,
    Iterable<SavedMonument>? server,
  }) : local = InMemorySavedMonumentsLocalDataSource(initial),
       remote = FakeSavedMonumentsRemoteDataSource(server ?? initial) {
    if (server == null) {
      local.syncState = SavedMonumentsSyncState.synced;
    }
    repository = SavedMonumentsRepositoryImpl(local, remote, session);
  }

  final InMemorySavedMonumentsLocalDataSource local;

  /// Oturum açma / kapatma bildirimi (`notifyAccountChanged`).
  final SessionEvents session = SessionEvents();
  final FakeSavedMonumentsRemoteDataSource remote;
  late final SavedMonumentsRepositoryImpl repository;

  DateTime now = DateTime.utc(2026, 10, 19, 12);

  SavedMonumentsCubit cubit() => SavedMonumentsCubit.withClock(
    GetSavedMonumentsUseCase(repository),
    SaveMonumentUseCase(repository),
    RemoveSavedMonumentUseCase(repository),
    WatchSavedMonumentsUseCase(repository),
    () => now,
  );

  SavedMonumentsListCubit listCubit() => SavedMonumentsListCubit(
    GetSavedMonumentsUseCase(repository),
    catalogUseCases().pins,
    WatchSavedMonumentsUseCase(repository),
  );
}
