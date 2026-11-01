import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';
import 'package:vakif_atlas/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';

class _MockCatalogRepository extends Mock implements CatalogRepository {}

MonumentPin _monument(String id, GeoPoint location) => MonumentPin(
  id: id,
  name: id,
  category: MonumentCategory.mosque,
  city: 'İl',
  district: 'İlçe',
  location: location,
);

void main() {
  late _MockCatalogRepository repository;

  setUp(() => repository = _MockCatalogRepository());

  group('GetMonumentPinsUseCase', () {
    test('konumu geçersiz kayıtları eler, sunucu sırasını korur', () async {
      when(
        () => repository.getMonumentPins(
          ids: ['b', 'nan', 'a'],
          languageCode: 'tr',
        ),
      ).thenAnswer(
        (_) async => Right([
          _monument('b', const GeoPoint(latitude: 40, longitude: 29)),
          _monument('nan', const GeoPoint(latitude: double.nan, longitude: 29)),
          _monument('a', const GeoPoint(latitude: 39, longitude: 32)),
        ]),
      );

      final result = await GetMonumentPinsUseCase(repository)(
        const GetMonumentPinsParams(ids: ['b', 'nan', 'a'], languageCode: 'tr'),
      );

      expect(result.getOrNull()!.map((m) => m.id), ['b', 'a']);
    });

    test(
      'boş ve tekrarlı kimlikler ayıklanır; kimlik yoksa istek yok',
      () async {
        when(() => repository.getMonumentPins(ids: ['a'], languageCode: 'tr'))
            .thenAnswer((_) async => const Right([]));

        await GetMonumentPinsUseCase(repository)(
          const GetMonumentPinsParams(
            ids: [' a ', 'a', ''],
            languageCode: 'tr',
          ),
        );
        final empty = await GetMonumentPinsUseCase(repository)(
          const GetMonumentPinsParams(ids: ['  '], languageCode: 'tr'),
        );

        expect(empty.getOrNull(), isEmpty);
        verify(() => repository.getMonumentPins(ids: ['a'], languageCode: 'tr'))
            .called(1);
        verifyNoMoreInteractions(repository);
      },
    );

    test('hata olduğu gibi iletilir', () async {
      when(() => repository.getMonumentPins(ids: ['a'], languageCode: 'tr'))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await GetMonumentPinsUseCase(repository)(
        const GetMonumentPinsParams(ids: ['a'], languageCode: 'tr'),
      );

      expect(result, const Left<Failure, List<MonumentPin>>(NetworkFailure()));
    });
  });

  group('GetMonumentDetailUseCase', () {
    test('boş kimlik sunucuya gönderilmeden notFound döner', () async {
      final result = await GetMonumentDetailUseCase(repository)(
        const GetMonumentDetailParams(id: '  ', languageCode: 'tr'),
      );

      expect(
        result,
        const Left<Failure, MonumentDetail>(
          ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
        ),
      );
      verifyZeroInteractions(repository);
    });

    test('kimlik kırpılarak dil ile birlikte iletilir', () async {
      when(
        () => repository.getMonumentDetail(
          id: 'selimiye-camii',
          languageCode: 'en',
        ),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      await GetMonumentDetailUseCase(repository)(
        const GetMonumentDetailParams(
          id: ' selimiye-camii ',
          languageCode: 'en',
        ),
      );

      verify(
        () => repository.getMonumentDetail(
          id: 'selimiye-camii',
          languageCode: 'en',
        ),
      ).called(1);
    });
  });
}
