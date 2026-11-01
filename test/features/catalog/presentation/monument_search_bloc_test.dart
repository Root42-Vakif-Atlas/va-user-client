import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_filter.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/catalog/presentation/bloc/monument_search_bloc.dart';

import '../../../helpers/catalog_test_utils.dart';
import '../../../support/mock_api/catalog/catalog_mock_api.dart';

class _MockSearch extends Mock implements SearchMonumentsUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const SearchMonumentsParams(
        query: MonumentSearchQuery.empty,
        languageCode: 'tr',
      ),
    );
  });

  group('mock sunucuyla', () {
    final large = catalogUseCases(
      CatalogMockApi.withMonuments(syntheticMonuments(45)),
    );

    blocTest<MonumentSearchBloc, MonumentSearchState>(
      'ilk sayfa, ardından kaydırınca sonraki sayfalar eklenir',
      build: () => MonumentSearchBloc(large.search),
      act: (bloc) async {
        bloc.add(const MonumentSearchEvent.started(languageCode: 'tr'));
        await Future<void>.delayed(const Duration(milliseconds: 20));
        bloc.add(const MonumentSearchEvent.nextPageRequested());
        await Future<void>.delayed(const Duration(milliseconds: 20));
        bloc.add(const MonumentSearchEvent.nextPageRequested());
        await Future<void>.delayed(const Duration(milliseconds: 20));
        // Son sayfadan sonra istek yapılmaz.
        bloc.add(const MonumentSearchEvent.nextPageRequested());
      },
      wait: const Duration(milliseconds: 50),
      verify: (bloc) {
        expect(bloc.state.items, hasLength(45));
        expect(bloc.state.total, 45);
        expect(bloc.state.hasMore, isFalse);
        expect(bloc.state.lastPageSize, 5);
        expect(bloc.state.items.map((m) => m.id).toSet(), hasLength(45));
      },
    );

    blocTest<MonumentSearchBloc, MonumentSearchState>(
      'filtre değişince ilk sayfadan başlanır; facet ve öneriler gelir',
      build: () => MonumentSearchBloc(catalogUseCases().search),
      act: (bloc) async {
        bloc.add(const MonumentSearchEvent.started(languageCode: 'tr'));
        await Future<void>.delayed(const Duration(milliseconds: 20));
        bloc.add(
          const MonumentSearchEvent.queryChanged(
            MonumentSearchQuery(
              text: 'konya',
              filter: MonumentFilter(periods: {HistoricalPeriod.seljuk}),
            ),
          ),
        );
      },
      wait: const Duration(milliseconds: 50),
      verify: (bloc) {
        expect(bloc.state.status, MonumentSearchStatus.success);
        expect(bloc.state.items.single.id, 'sahip-ata-kulliyesi');
        expect(bloc.state.places.single.city, 'Konya');
        expect(bloc.state.facets.periods[HistoricalPeriod.seljuk], 1);
      },
    );
  });

  group('eşzamanlılık ve hatalar', () {
    late _MockSearch search;

    MonumentSearchResults page(List<String> ids, {String? next}) =>
        MonumentSearchResults(
          items: [
            for (final monument in fixtureMonuments())
              if (ids.contains(monument.id)) monument,
          ],
          total: 99,
          nextCursor: next,
        );

    setUp(() => search = _MockSearch());

    test('geç gelen eski sorgu yanıtı uygulanmaz', () async {
      final pending = <String, Completer<Result<MonumentSearchResults>>>{};
      when(() => search(any())).thenAnswer((invocation) {
        final params =
            invocation.positionalArguments.single as SearchMonumentsParams;
        return (pending[params.query.normalizedText] = Completer()).future;
      });
      final bloc = MonumentSearchBloc(search)
        ..add(
          const MonumentSearchEvent.started(
            languageCode: 'tr',
            query: MonumentSearchQuery(text: 'eski'),
          ),
        );
      await pumpEventQueue();
      bloc.add(
        const MonumentSearchEvent.queryChanged(
          MonumentSearchQuery(text: 'yeni'),
        ),
      );
      await pumpEventQueue();

      pending['yeni']!.complete(Right(page(['selimiye-camii'])));
      pending['eski']!.complete(Right(page(['bursa-ulu-camii'])));
      await pumpEventQueue();

      expect(bloc.state.items.single.id, 'selimiye-camii');
      expect(bloc.state.query.text, 'yeni');
      await bloc.close();
    });

    blocTest<MonumentSearchBloc, MonumentSearchState>(
      'sonraki sayfa hatasında liste korunur; tekrar dene aynı imleci ister',
      setUp: () {
        when(() => search(any())).thenAnswer((invocation) async {
          final params =
              invocation.positionalArguments.single as SearchMonumentsParams;
          return params.cursor == null
              ? Right(page(['selimiye-camii'], next: 'c2'))
              : const Left(NetworkFailure());
        });
      },
      build: () => MonumentSearchBloc(search),
      act: (bloc) async {
        bloc.add(const MonumentSearchEvent.started(languageCode: 'tr'));
        await pumpEventQueue();
        bloc.add(const MonumentSearchEvent.nextPageRequested());
        await pumpEventQueue();
        // Hata varken kaydırma yeni istek tetiklemez.
        bloc.add(const MonumentSearchEvent.nextPageRequested());
        await pumpEventQueue();
        bloc.add(const MonumentSearchEvent.retryRequested());
      },
      verify: (bloc) {
        expect(bloc.state.items.single.id, 'selimiye-camii');
        expect(bloc.state.loadMoreFailure, const NetworkFailure());
        // İlk sayfa + hata + tekrar dene (aynı imleç).
        final cursors = [
          for (final params in verify(() => search(captureAny())).captured)
            (params as SearchMonumentsParams).cursor,
        ];
        expect(cursors, [null, 'c2', 'c2']);
      },
    );

    blocTest<MonumentSearchBloc, MonumentSearchState>(
      'ilk sayfa hatası failure durumuyla yayınlanır',
      setUp: () =>
          when(() => search(any()))
              .thenAnswer((_) async => const Left(NetworkFailure())),
      build: () => MonumentSearchBloc(search),
      act: (bloc) =>
          bloc.add(const MonumentSearchEvent.started(languageCode: 'tr')),
      expect: () => [
        isA<MonumentSearchState>().having(
          (s) => s.status,
          'status',
          MonumentSearchStatus.loading,
        ),
        isA<MonumentSearchState>()
            .having((s) => s.status, 'status', MonumentSearchStatus.failure)
            .having((s) => s.failure, 'failure', const NetworkFailure()),
      ],
    );
  });
}
