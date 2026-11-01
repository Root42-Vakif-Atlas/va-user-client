import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/domain/usecases/memory_usecases.dart';
import 'package:vakif_atlas/features/memory_corner/presentation/bloc/memory_list_bloc.dart';

import '../../../helpers/memory_test_utils.dart';

void main() {
  MemoryListBloc bloc(MemoryTestEnvironment env) {
    final cases = env.useCases;
    return MemoryListBloc(cases.get, cases.delete, cases.report, cases.watch);
  }

  Future<MemoryListState> settle(
    MemoryListBloc bloc,
    bool Function(MemoryListState state) test,
  ) async {
    if (test(bloc.state)) {
      return bloc.state;
    }
    return bloc.stream.firstWhere(test);
  }

  test('ilk sayfa ve sonraki sayfa; kaydırma tekrarları tek istek', () async {
    final env = MemoryTestEnvironment(initialState: syntheticMemoryState(45));
    final list = bloc(env)
      ..add(
        const MemoryListEvent.started(
          monumentId: 'selimiye-camii',
          pageSize: 20,
        ),
      );
    var state = await settle(list, (s) => s.status == MemoryListStatus.success);
    expect(state.items, hasLength(20));
    expect(state.total, 45);
    expect(state.hasMore, isTrue);

    list
      ..add(const MemoryListEvent.nextPageRequested())
      ..add(const MemoryListEvent.nextPageRequested())
      ..add(const MemoryListEvent.nextPageRequested());
    state = await settle(list, (s) => s.items.length == 40 && !s.isLoadingMore);
    await Future<void>.delayed(Duration.zero);
    expect(list.state.items, hasLength(40), reason: 'droppable');

    list.add(const MemoryListEvent.nextPageRequested());
    state = await settle(list, (s) => s.items.length == 45);
    expect(state.hasMore, isFalse);
    expect(state.items.map((m) => m.id).toSet(), hasLength(45));
    await list.close();
  });

  test('başka ekranda paylaşılan anı başa eklenir, toplam artar', () async {
    final env = MemoryTestEnvironment();
    await env.signIn();
    final list = bloc(env)
      ..add(
        const MemoryListEvent.started(
          monumentId: 'selimiye-camii',
          pageSize: MemoryRules.previewSize,
        ),
      );
    await settle(list, (s) => s.status == MemoryListStatus.success);

    final created = await env.useCases.create(
      const CreateMemoryParams(
        draft: MemoryDraft(monumentId: 'selimiye-camii', text: 'Yeni anı'),
      ),
    );
    final memory = created.fold((_) => fail('paylaşılamadı'), (m) => m);
    final state = await settle(list, (s) => s.total == 5);

    expect(state.items.first, memory);
    await list.close();
  });

  test('incelemedeki veya yayınlanmayan kendi anısı Anı Köşesi\'nde '
      'görünmez (yalnızca Anılarım)', () async {
    final env = MemoryTestEnvironment();
    await env.signIn();
    final list = bloc(env)
      ..add(
        const MemoryListEvent.started(
          monumentId: 'selimiye-camii',
          pageSize: 20,
        ),
      );
    final before = await settle(
      list,
      (s) => s.status == MemoryListStatus.success,
    );

    for (final text in ['Rehber berbattı.', 'Buraya gelen herkes salak.']) {
      final created = await env.useCases.create(
        CreateMemoryParams(
          draft: MemoryDraft(monumentId: 'selimiye-camii', text: text),
        ),
      );
      final memory = created.fold((_) => fail('paylaşılamadı'), (m) => m);
      expect(memory.status, isNot(MemoryModerationStatus.approved));
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(list.state.total, before.total);
    expect(list.state.items, before.items);
    expect(list.state.years, before.years);

    // Yeniden yükleme de (sunucu listesi) göstermez.
    list.add(
      const MemoryListEvent.started(monumentId: 'selimiye-camii', pageSize: 20),
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));
    final reloaded = await settle(
      list,
      (s) => s.status == MemoryListStatus.success,
    );
    expect(reloaded.total, before.total);
    await list.close();
  });

  test('silinen anı önizlemeden kalkar ve sonraki kayıtla doldurulur; '
      'bildirim yayınlanır', () async {
    final env = MemoryTestEnvironment();
    await env.signIn();
    final own = (await env.useCases.create(
      const CreateMemoryParams(
        draft: MemoryDraft(monumentId: 'selimiye-camii', text: 'Silinecek'),
      ),
    )).fold((_) => fail('paylaşılamadı'), (m) => m);
    final list = bloc(env)
      ..add(
        const MemoryListEvent.started(
          monumentId: 'selimiye-camii',
          pageSize: MemoryRules.previewSize,
        ),
      );
    var state = await settle(list, (s) => s.status == MemoryListStatus.success);
    expect(state.items.first.id, own.id);
    expect(state.items, hasLength(3));

    list.add(MemoryListEvent.deleteRequested(own));
    state = await settle(
      list,
      (s) =>
          s.notice?.kind == MemoryNoticeKind.deleted &&
          s.items.length == 4 &&
          !s.isLoadingMore,
    );

    expect(state.items.map((m) => m.id), isNot(contains(own.id)));
    expect(state.total, 4);
    expect(state.busyIds, isEmpty);
    await list.close();
  });

  test('bildirilen anı listeden kalkar; hata bildirimi yayınlanır', () async {
    final env = MemoryTestEnvironment();
    final list = bloc(env)
      ..add(
        const MemoryListEvent.started(
          monumentId: 'selimiye-camii',
          pageSize: 20,
        ),
      );
    var state = await settle(list, (s) => s.status == MemoryListStatus.success);
    final target = state.items.first;

    // Misafir: sunucu 401 → işlem hatası bildirimi, liste değişmez.
    list.add(
      MemoryListEvent.reportRequested(
        memory: target,
        reason: MemoryReportReason.spam,
      ),
    );
    state = await settle(list, (s) => s.noticeCount == 1);
    expect(state.notice?.kind, MemoryNoticeKind.actionFailed);
    expect(state.notice?.failure, const UnauthorizedFailure());
    expect(state.items, contains(target));

    await env.signIn();
    list.add(
      MemoryListEvent.reportRequested(
        memory: target,
        reason: MemoryReportReason.spam,
      ),
    );
    state = await settle(
      list,
      (s) => s.noticeCount == 2 && !s.items.contains(target),
    );
    expect(state.notice?.kind, MemoryNoticeKind.reported);
    expect(state.total, 3);
    await list.close();
  });

  test('tarih filtresi uygulanır; paylaşılan anı tarihine göre yerleşir ve '
      'yıl sayıları güncellenir', () async {
    final env = MemoryTestEnvironment();
    await env.signIn();
    final list = bloc(env)
      ..add(
        const MemoryListEvent.started(
          monumentId: 'selimiye-camii',
          pageSize: 20,
        ),
      );
    var state = await settle(list, (s) => s.status == MemoryListStatus.success);
    expect(state.years, const [MemoryYearCount(year: 2026, count: 4)]);

    // Eylül 2026 ziyareti: Ekim anısının ardına, Eylül anısının önüne.
    await env.useCases.create(
      CreateMemoryParams(
        draft: MemoryDraft(
          monumentId: 'selimiye-camii',
          text: 'Eylül sonu',
          visitedOn: DateTime(2026, 9, 29),
        ),
      ),
    );
    state = await settle(list, (s) => s.total == 5);
    expect(state.items[1].text, 'Eylül sonu');
    expect(state.years, const [MemoryYearCount(year: 2026, count: 5)]);

    // Filtre dışındaki yeni anı listeye girmez, yalnızca sayılır.
    list.add(MemoryListEvent.rangeChanged(MemoryDateRange.year(2026)));
    state = await settle(
      list,
      (s) => s.status == MemoryListStatus.success && s.range != null,
    );
    expect(state.total, 5);
    await env.useCases.create(
      CreateMemoryParams(
        draft: MemoryDraft(
          monumentId: 'selimiye-camii',
          text: 'Çok eski',
          visitedOn: DateTime(2018, 6),
        ),
      ),
    );
    state = await settle(list, (s) => s.years.length == 2);
    expect(state.items.map((m) => m.text), isNot(contains('Çok eski')));
    expect(state.total, 5);
    expect(state.allTimeTotal, 6);
    await list.close();
  });

  test('sunucu hatasında hata durumu yayınlanır', () async {
    final env = MemoryTestEnvironment();
    final list = bloc(env)
      ..add(const MemoryListEvent.started(monumentId: 'x', pageSize: 999));
    final failed = await settle(
      list,
      (s) => s.status == MemoryListStatus.failure,
    );
    expect(failed.failure, isA<ServerFailure>());
    await list.close();
  });
}
