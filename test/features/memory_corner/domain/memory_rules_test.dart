import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/media/photo_draft.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/domain/repositories/memory_repository.dart';
import 'package:vakif_atlas/features/memory_corner/domain/usecases/memory_usecases.dart';

import '../../../helpers/memory_test_utils.dart';

class _MockRepository extends Mock implements MemoryRepository {}

void main() {
  final today = DateTime(2026, 10, 18, 9);

  setUpAll(() {
    registerFallbackValue(
      const MemoryDraft(monumentId: 'selimiye-camii', text: 'x'),
    );
    registerFallbackValue(testMemory());
    registerFallbackValue(MemoryReportReason.other);
  });

  MemoryDraft draft({
    String text = 'Güzel bir gün',
    DateTime? visitedOn,
    List<PhotoDraft> photos = const [],
  }) => MemoryDraft(
    monumentId: 'selimiye-camii',
    text: text,
    visitedOn: visitedOn,
    photos: photos,
  );

  group('MemoryRules.validate', () {
    test('geçerli taslak', () {
      expect(MemoryRules.validate(draft(), today: today), isNull);
      expect(
        MemoryRules.validate(
          draft(visitedOn: DateTime(2026, 10, 18, 23)),
          today: today,
        ),
        isNull,
        reason: 'Bugünün herhangi bir saati geçerlidir',
      );
    });

    test('metin zorunlu ve en fazla 1000 karakter', () {
      expect(
        MemoryRules.validate(draft(text: '  \n '), today: today),
        MemoryDraftIssue.textEmpty,
      );
      expect(
        MemoryRules.validate(draft(text: 'a' * 1000), today: today),
        isNull,
      );
      expect(
        MemoryRules.validate(draft(text: 'a' * 1001), today: today),
        MemoryDraftIssue.textTooLong,
      );
    });

    test('en fazla 4 fotoğraf, betim en fazla 250 karakter, 5 MB', () {
      expect(
        MemoryRules.validate(
          draft(
            photos: [
              for (var i = 0; i < 5; i++) testPhotoDraft(localId: 'p$i'),
            ],
          ),
          today: today,
        ),
        MemoryDraftIssue.tooManyPhotos,
      );
      expect(
        MemoryRules.validate(
          draft(photos: [testPhotoDraft(description: 'a' * 251)]),
          today: today,
        ),
        MemoryDraftIssue.descriptionTooLong,
      );
      expect(
        MemoryRules.validate(
          draft(
            photos: [
              PhotoDraft(
                localId: 'big',
                bytes: Uint8List(MemoryRules.maxPhotoBytes + 1),
                width: 1,
                height: 1,
              ),
            ],
          ),
          today: today,
        ),
        MemoryDraftIssue.photoTooLarge,
      );
    });

    test('ziyaret tarihi gelecekte veya 1900 öncesinde olamaz', () {
      expect(
        MemoryRules.validate(
          draft(visitedOn: DateTime(2026, 10, 19)),
          today: today,
        ),
        MemoryDraftIssue.visitDateInFuture,
      );
      expect(
        MemoryRules.validate(
          draft(visitedOn: DateTime(1899, 12, 31)),
          today: today,
        ),
        MemoryDraftIssue.visitDateTooEarly,
      );
    });
  });

  group('CreateMemoryUseCase', () {
    late _MockRepository repository;

    setUp(() {
      repository = _MockRepository();
      when(
        () => repository.createMemory(
          any(),
          onProgress: any(named: 'onProgress'),
        ),
      ).thenAnswer((_) async => Right(testMemory()));
    });

    test('geçersiz taslak sunucuya gönderilmez', () async {
      final useCase = CreateMemoryUseCase(repository, clock: () => today);
      final result = await useCase(CreateMemoryParams(draft: draft(text: '')));

      expect(
        result.fold<Failure?>((failure) => failure, (_) => null),
        const ServerFailure(
          kind: ServerFailureKind.invalidRequest,
          statusCode: 400,
        ),
      );
      verifyNever(
        () => repository.createMemory(
          any(),
          onProgress: any(named: 'onProgress'),
        ),
      );
    });

    test('metin ve betimler kırpılarak gönderilir', () async {
      final useCase = CreateMemoryUseCase(repository, clock: () => today);
      await useCase(
        CreateMemoryParams(
          draft: draft(
            text: '  Anı  ',
            photos: [testPhotoDraft(description: '  kubbe  ')],
          ),
        ),
      );
      final sent =
          verify(
                () => repository.createMemory(
                  captureAny(),
                  onProgress: any(named: 'onProgress'),
                ),
              ).captured.single
              as MemoryDraft;
      expect(sent.text, 'Anı');
      expect(sent.photos.single.description, 'kubbe');
    });
  });

  test('ReportMemoryUseCase uzun notu reddeder, boş notu göndermez', () async {
    final repository = _MockRepository();
    when(
      () => repository.reportMemory(
        any(),
        reason: any(named: 'reason'),
        note: any(named: 'note'),
      ),
    ).thenAnswer((_) async => const Right(unit));
    final useCase = ReportMemoryUseCase(repository);

    final tooLong = await useCase(
      ReportMemoryParams(
        memory: testMemory(),
        reason: MemoryReportReason.other,
        note: 'a' * 501,
      ),
    );
    expect(tooLong.isLeft, isTrue);

    await useCase(
      ReportMemoryParams(
        memory: testMemory(),
        reason: MemoryReportReason.spam,
        note: '   ',
      ),
    );
    verify(
      () => repository.reportMemory(
        any(),
        reason: MemoryReportReason.spam,
        note: null,
      ),
    ).called(1);
  });
}
