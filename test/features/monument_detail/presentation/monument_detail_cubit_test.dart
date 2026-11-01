import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_detail.dart';
import 'package:vakif_atlas/features/catalog/domain/usecases/catalog_usecases.dart';
import 'package:vakif_atlas/features/monument_detail/presentation/cubit/monument_detail_cubit.dart';

import '../../../helpers/catalog_test_utils.dart';

class _MockGetMonumentDetail extends Mock implements GetMonumentDetailUseCase {}

class _MockGetComplexMembers extends Mock implements GetComplexMembersUseCase {}

void main() {
  late _MockGetMonumentDetail getDetail;
  final selimiye = fixtureDetail('selimiye-camii');
  const notFound = ServerFailure(
    kind: ServerFailureKind.notFound,
    statusCode: 404,
  );

  setUpAll(() {
    registerFallbackValue(
      const GetMonumentDetailParams(id: 'id', languageCode: 'tr'),
    );
  });

  setUp(() {
    getDetail = _MockGetMonumentDetail();
    when(() => getDetail(any())).thenAnswer((_) async => Right(selimiye));
  });

  blocTest<MonumentDetailCubit, MonumentDetailState>(
    'yükleme → loading, loaded',
    build: () => MonumentDetailCubit(getDetail, _MockGetComplexMembers()),
    act: (cubit) => cubit.load(id: 'selimiye-camii', languageCode: 'tr'),
    expect: () => [
      const MonumentDetailState.loading(),
      MonumentDetailState.loaded(selimiye),
    ],
  );

  blocTest<MonumentDetailCubit, MonumentDetailState>(
    '404 → bulunamadı durumu',
    build: () => MonumentDetailCubit(getDetail, _MockGetComplexMembers()),
    setUp: () =>
        when(() => getDetail(any()))
            .thenAnswer((_) async => const Left(notFound)),
    act: (cubit) => cubit.load(id: 'yok', languageCode: 'tr'),
    expect: () => [
      const MonumentDetailState.loading(),
      isA<MonumentDetailFailure>().having(
        (state) => state.isNotFound,
        'isNotFound',
        isTrue,
      ),
    ],
  );

  blocTest<MonumentDetailCubit, MonumentDetailState>(
    'ağ hatası tekrar denemeyle aynı parametrelerle yeniden istenir',
    build: () => MonumentDetailCubit(getDetail, _MockGetComplexMembers()),
    setUp: () =>
        when(() => getDetail(any()))
            .thenAnswer((_) async => const Left(NetworkFailure())),
    act: (cubit) async {
      await cubit.load(id: 'selimiye-camii', languageCode: 'en');
      await cubit.retry();
    },
    verify: (cubit) {
      expect(cubit.state.isNotFound, isFalse);
      verify(
        () => getDetail(
          const GetMonumentDetailParams(
            id: 'selimiye-camii',
            languageCode: 'en',
          ),
        ),
      ).called(2);
    },
  );

  test('eski isteğin geç gelen sonucu yeni sonucu ezmez', () async {
    final pending = <String, Completer<Result<MonumentDetail>>>{};
    when(() => getDetail(any())).thenAnswer((invocation) {
      final params =
          invocation.positionalArguments.single as GetMonumentDetailParams;
      return (pending[params.languageCode] = Completer()).future;
    });
    final cubit = MonumentDetailCubit(getDetail, _MockGetComplexMembers());
    final english = fixtureDetail('selimiye-camii', languageCode: 'en');

    unawaited(cubit.load(id: 'selimiye-camii', languageCode: 'tr'));
    unawaited(cubit.load(id: 'selimiye-camii', languageCode: 'en'));
    pending['en']!.complete(Right(english));
    await pumpEventQueue();
    pending['tr']!.complete(Right(selimiye));
    await pumpEventQueue();

    expect(cubit.state, MonumentDetailState.loaded(english));
    await cubit.close();
  });
}
