import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory.dart';
import 'package:vakif_atlas/features/memory_corner/domain/entities/memory_draft.dart';
import 'package:vakif_atlas/features/memory_corner/domain/repositories/memory_repository.dart';

import '../../../helpers/memory_test_utils.dart';
import '../../../support/mock_api/memory_corner/memory_mock_api.dart';

T _right<T>(Either<Failure, T> result) =>
    result.fold((failure) => fail('Beklenmeyen hata: $failure'), (v) => v);

Failure _left<T>(Either<Failure, T> result) =>
    result.fold((failure) => failure, (v) => fail('Hata bekleniyordu: $v'));

void main() {
  group('GET memories', () {
    test('herkese açık: seed anılar en yeni önce, toplam sayıyla', () async {
      final env = MemoryTestEnvironment();
      final page = _right(
        await env.repository.getMemories(
          monumentId: 'selimiye-camii',
          limit: 20,
        ),
      );

      expect(page.total, 4);
      expect(page.hasMore, isFalse);
      expect(page.items.first.id, 'mem_seed_selimiye_1');
      final dates = [for (final m in page.items) m.createdAt];
      expect(dates, [...dates]..sort((a, b) => b.compareTo(a)));
      expect(page.items.first.visitedOn, DateTime(2026, 10, 11));
      expect(page.items.first.author.displayName, 'Mehmet K.');
    });

    test('anısı olmayan eser boş liste döner', () async {
      final env = MemoryTestEnvironment();
      final page = _right(
        await env.repository.getMemories(
          monumentId: 'sultanhani-kervansarayi',
          limit: 20,
        ),
      );
      expect(page, MemoryPage.empty);
    });

    test('imleçle sayfalanır; tekrar veya atlama olmaz', () async {
      final env = MemoryTestEnvironment(initialState: syntheticMemoryState(45));
      final ids = <String>[];
      String? cursor;
      var pages = 0;
      do {
        final page = _right(
          await env.repository.getMemories(
            monumentId: 'selimiye-camii',
            limit: 20,
            cursor: cursor,
          ),
        );
        expect(page.total, 45);
        ids.addAll(page.items.map((m) => m.id));
        cursor = page.nextCursor;
        pages++;
      } while (cursor != null);

      expect(pages, 3);
      expect(ids, hasLength(45));
      expect(ids.toSet(), hasLength(45));
      expect(ids.first, 'mem_test_000');
    });

    test('anı tarihine (ziyaret, yoksa paylaşım günü) göre sıralanır; yıl '
        'sayıları filtreden bağımsızdır', () async {
      final env = MemoryTestEnvironment();
      await env.signIn();
      _right(
        await env.repository.createMemory(
          MemoryDraft(
            monumentId: 'selimiye-camii',
            text: 'Eski ziyaret',
            visitedOn: DateTime(2019, 5, 3),
          ),
        ),
      );

      final all = _right(
        await env.repository.getMemories(
          monumentId: 'selimiye-camii',
          limit: 20,
          includeYears: true,
        ),
      );
      // Bugün paylaşılmış olsa da 2019 ziyareti en sonda yer alır.
      expect(all.items.last.text, 'Eski ziyaret');
      expect(all.items.last.memoryDate, DateTime(2019, 5, 3));
      final days = [for (final m in all.items) m.memoryDate];
      expect(days, [...days]..sort((a, b) => b.compareTo(a)));
      expect(all.years, const [
        MemoryYearCount(year: 2026, count: 4),
        MemoryYearCount(year: 2019, count: 1),
      ]);

      final only2019 = _right(
        await env.repository.getMemories(
          monumentId: 'selimiye-camii',
          limit: 20,
          range: MemoryDateRange.year(2019),
          includeYears: true,
        ),
      );
      expect(only2019.total, 1);
      expect(only2019.items.single.text, 'Eski ziyaret');
      expect(only2019.years, all.years);

      final september = _right(
        await env.repository.getMemories(
          monumentId: 'selimiye-camii',
          limit: 20,
          range: MemoryDateRange(
            from: DateTime(2026, 9),
            to: DateTime(2026, 9, 30),
          ),
        ),
      );
      expect(september.items.map((m) => m.id), ['mem_seed_selimiye_2']);
      expect(september.years, isNull, reason: 'istenmediğinde gelmez');
    });

    test('ziyaret tarihi olmayan anı paylaşım gününe yerleşir', () async {
      final env = MemoryTestEnvironment();
      final page = _right(
        await env.repository.getMemories(
          monumentId: 'selimiye-camii',
          limit: 20,
        ),
      );
      final noVisit = page.items.firstWhere(
        (m) => m.id == 'mem_seed_selimiye_3',
      );
      expect(noVisit.visitedOn, isNull);
      expect(noVisit.memoryDate, DateTime(2026, 8, 19));
    });

    test('ters tarih aralığı 400', () async {
      final env = MemoryTestEnvironment();
      final result = await env.repository.getMemories(
        monumentId: 'selimiye-camii',
        limit: 20,
        range: MemoryDateRange(from: DateTime(2026, 10), to: DateTime(2026, 9)),
      );
      expect(_left(result), isA<ServerFailure>());
    });

    test('geçersiz imleç ve sınır 400 döner', () async {
      final env = MemoryTestEnvironment();
      expect(
        _left(
          await env.repository.getMemories(
            monumentId: 'selimiye-camii',
            limit: 20,
            cursor: '***',
          ),
        ),
        const ServerFailure(
          kind: ServerFailureKind.invalidRequest,
          statusCode: 400,
        ),
      );
      expect(
        _left(
          await env.repository.getMemories(
            monumentId: 'selimiye-camii',
            limit: 51,
          ),
        ),
        isA<ServerFailure>(),
      );
    });
  });

  group('POST memories', () {
    test('misafir paylaşamaz (401)', () async {
      final env = MemoryTestEnvironment();
      final result = await env.repository.createMemory(
        const MemoryDraft(monumentId: 'selimiye-camii', text: 'Merhaba'),
      );
      expect(_left(result), const UnauthorizedFailure());
    });

    test('fotoğraflar ön imzalı adrese yüklenir, anı yayınlanır ve akışa '
        'düşer', () async {
      final env = MemoryTestEnvironment();
      await env.signIn();
      final changes = <MemoryChange>[];
      final subscription = env.repository.changes.listen(changes.add);
      final progress = <double>[];

      final memory = _right(
        await env.repository.createMemory(
          MemoryDraft(
            monumentId: 'selimiye-camii',
            text: 'Avluda şadırvanı dinledik.',
            visitedOn: DateTime(2026, 10, 1),
            photos: [
              testPhotoDraft(description: 'Kubbe içi'),
              testPhotoDraft(localId: 'photo_2', width: 48, height: 64),
            ],
          ),
          onProgress: progress.add,
        ),
      );

      expect(memory.author.id, 'usr_demo_001');
      expect(memory.author.displayName, 'Ayşe Y.');
      expect(memory.visitedOn, DateTime(2026, 10, 1));
      expect(memory.photos, hasLength(2));
      expect(memory.photos.first.description, 'Kubbe içi');
      expect(memory.photos.last.description, isNull);
      expect(memory.photos.last.aspectRatio, closeTo(0.75, 0.001));
      expect(memory.photos.first.url, startsWith('data:image/jpeg;base64,'));
      expect(progress.last, 1);
      expect(progress, orderedEquals([...progress]..sort()));

      await Future<void>.delayed(Duration.zero);
      expect(changes.single, isA<MemoryCreated>());

      final page = _right(
        await env.repository.getMemories(
          monumentId: 'selimiye-camii',
          limit: 20,
        ),
      );
      expect(page.total, 5);
      // 1 Ekim ziyareti, 11 Ekim'deki anının ardına yerleşir.
      expect(page.items[1].id, memory.id);
      await subscription.cancel();
    });

    test('yüklenmemiş, başkasına ait veya tekrar kullanılan yükleme '
        'reddedilir', () async {
      final env = MemoryTestEnvironment();
      await env.signIn();
      final ticket = await env.dio.post<Map<String, dynamic>>(
        'memories/photo-uploads',
        data: {
          'contentType': 'image/jpeg',
          'byteSize': 10,
          'width': 10,
          'height': 10,
        },
      );
      final uploadId = ticket.data!['id'] as String;

      final response = await env.dio.post<Map<String, dynamic>>(
        'memories',
        data: {
          'monumentId': 'selimiye-camii',
          'text': 'Fotoğraflı',
          'photos': [
            {'uploadId': uploadId},
          ],
        },
        options: _noThrow,
      );
      expect(response.statusCode, 400);
    });

    test('JPEG olmayan veya bildirilen boyuttan farklı yükleme 400', () async {
      final env = MemoryTestEnvironment();
      await env.signIn();
      final ticket = await env.dio.post<Map<String, dynamic>>(
        'memories/photo-uploads',
        data: {
          'contentType': 'image/jpeg',
          'byteSize': 4,
          'width': 1,
          'height': 1,
        },
      );
      final upload = await env.dio.put<void>(
        ticket.data!['uploadUrl'] as String,
        data: utf8.encode('abcd'),
        options: _noThrow.copyWith(contentType: 'image/jpeg'),
      );
      expect(upload.statusCode, 400);
    });

    test('5 MB üstü fotoğraf için yükleme adresi verilmez', () async {
      final env = MemoryTestEnvironment();
      await env.signIn();
      final response = await env.dio.post<Map<String, dynamic>>(
        'memories/photo-uploads',
        data: {
          'contentType': 'image/jpeg',
          'byteSize': MemoryRules.maxPhotoBytes + 1,
          'width': 4000,
          'height': 3000,
        },
        options: _noThrow,
      );
      expect(response.statusCode, 400);
      expect(response.data!['code'], 'photo_too_large');
    });

    test('kurallara uymayan gövde ve bilinmeyen eser 400', () async {
      final env = MemoryTestEnvironment();
      await env.signIn();
      for (final body in [
        {'monumentId': 'selimiye-camii', 'text': '   '},
        {'monumentId': 'yok-boyle-eser', 'text': 'Merhaba'},
        {
          'monumentId': 'selimiye-camii',
          'text': 'Merhaba',
          'visitedOn': '2099-01-01',
        },
        {'monumentId': 'selimiye-camii', 'text': 'a' * 1001},
      ]) {
        final response = await env.dio.post<Map<String, dynamic>>(
          'memories',
          data: body,
          options: _noThrow,
        );
        expect(response.statusCode, 400, reason: '$body');
      }
    });

    test('YZ moderasyonu: temiz yayınlanır, ara bant incelemeye düşer, '
        'hakaret yayınlanmaz; yalnızca yayındaki herkese açık', () async {
      final env = MemoryTestEnvironment();
      await env.signIn();
      Future<Memory> share(String text) async => _right(
        await env.repository.createMemory(
          MemoryDraft(monumentId: 'sultanhani-kervansarayi', text: text),
        ),
      );

      final clean = await share('Taç kapı muhteşemdi.');
      final review = await share('Rehber berbattı, hiçbir şey anlatmadı.');
      final removed = await share('Buraya gelen herkes salak.');
      expect(clean.status, MemoryModerationStatus.approved);
      expect(review.status, MemoryModerationStatus.pending);
      expect(removed.status, MemoryModerationStatus.rejected);

      final public = _right(
        await env.repository.getMemories(
          monumentId: 'sultanhani-kervansarayi',
          limit: 20,
        ),
      );
      expect([for (final m in public.items) m.id], [clean.id]);
      final mine = _right(await env.repository.getMyMemories(limit: 20));
      expect({
        for (final m in mine.items) m.id: m.status,
      }, containsPair(review.id, MemoryModerationStatus.pending));
      expect({
        for (final m in mine.items) m.id: m.status,
      }, containsPair(removed.id, MemoryModerationStatus.rejected));
    });

    test('saatte en fazla 10 anı (429 + retryAfter)', () async {
      final env = MemoryTestEnvironment();
      await env.signIn();
      for (var i = 0; i < MemoryMockApi.maxMemoriesPerHour; i++) {
        _right(
          await env.repository.createMemory(
            MemoryDraft(monumentId: 'selimiye-camii', text: 'Anı $i'),
          ),
        );
      }
      final result = await env.repository.createMemory(
        const MemoryDraft(monumentId: 'selimiye-camii', text: 'Bir tane daha'),
      );
      expect(
        _left(result),
        const TooManyRequestsFailure(retryAfter: Duration(hours: 1)),
      );
    });
  });

  group('DELETE memories/{id}', () {
    test('yalnızca sahibi siler; başkasının anısı 404', () async {
      final env = MemoryTestEnvironment();
      await env.signIn();
      final own = _right(
        await env.repository.createMemory(
          const MemoryDraft(monumentId: 'selimiye-camii', text: 'Benim anım'),
        ),
      );
      final seed = testMemory(id: 'mem_seed_selimiye_1');

      expect(
        _left(await env.repository.deleteMemory(seed)),
        const ServerFailure(kind: ServerFailureKind.notFound, statusCode: 404),
      );
      expect(
        await env.repository.deleteMemory(own),
        const Right<Failure, Unit>(unit),
      );

      final page = _right(
        await env.repository.getMemories(
          monumentId: 'selimiye-camii',
          limit: 20,
        ),
      );
      expect(page.items.map((m) => m.id), isNot(contains(own.id)));
      expect(page.total, 4);
    });
  });

  group('POST memories/{id}/reports', () {
    test('bildirilen anı bildirene gizlenir, diğerlerine görünür', () async {
      final env = MemoryTestEnvironment();
      await env.signIn();
      final seed = testMemory(id: 'mem_seed_selimiye_1');

      expect(
        await env.repository.reportMemory(
          seed,
          reason: MemoryReportReason.spam,
          note: 'Reklam',
        ),
        const Right<Failure, Unit>(unit),
      );

      final forReporter = _right(
        await env.repository.getMemories(
          monumentId: 'selimiye-camii',
          limit: 20,
        ),
      );
      expect(forReporter.items.map((m) => m.id), isNot(contains(seed.id)));
      expect(forReporter.total, 3);

      env.signOut();
      final forGuest = _right(
        await env.repository.getMemories(
          monumentId: 'selimiye-camii',
          limit: 20,
        ),
      );
      expect(forGuest.items.map((m) => m.id), contains(seed.id));
    });

    test('${MemoryMockApi.hideAfterReports} farklı kullanıcının bildirdiği '
        'anı herkese gizlenir; aynı kişinin tekrarı sayılmaz', () async {
      final env = MemoryTestEnvironment();
      final seed = testMemory(id: 'mem_seed_selimiye_2');
      await env.signInAs('Bir Kullanıcı', 'bir@example.org');
      await env.repository.reportMemory(seed, reason: MemoryReportReason.spam);
      await env.repository.reportMemory(seed, reason: MemoryReportReason.spam);
      await env.signInAs('İki Kullanıcı', 'iki@example.org');
      await env.repository.reportMemory(
        seed,
        reason: MemoryReportReason.offensive,
      );
      env.signOut();
      var page = _right(
        await env.repository.getMemories(
          monumentId: 'selimiye-camii',
          limit: 20,
        ),
      );
      expect(page.items.map((m) => m.id), contains(seed.id));

      await env.signInAs('Üç Kullanıcı', 'uc@example.org');
      await env.repository.reportMemory(seed, reason: MemoryReportReason.other);
      env.signOut();
      page = _right(
        await env.repository.getMemories(
          monumentId: 'selimiye-camii',
          limit: 20,
        ),
      );
      expect(page.items.map((m) => m.id), isNot(contains(seed.id)));
    });

    test('kendi anısını bildiremez; misafir bildiremez', () async {
      final env = MemoryTestEnvironment();
      final guest = await env.repository.reportMemory(
        testMemory(id: 'mem_seed_selimiye_1'),
        reason: MemoryReportReason.spam,
      );
      expect(_left(guest), const UnauthorizedFailure());

      await env.signIn();
      final own = _right(
        await env.repository.createMemory(
          const MemoryDraft(monumentId: 'selimiye-camii', text: 'Benim'),
        ),
      );
      expect(
        _left(
          await env.repository.reportMemory(
            own,
            reason: MemoryReportReason.spam,
          ),
        ),
        isA<ServerFailure>(),
      );
    });
  });

  test('hesap silinince kullanıcının anıları da silinir', () async {
    final env = MemoryTestEnvironment();
    await env.signInAs('Silinecek Hesap', 'sil@example.org');
    _right(
      await env.repository.createMemory(
        const MemoryDraft(monumentId: 'bursa-ulu-camii', text: 'Geçici'),
      ),
    );
    await env.dio.delete<void>(
      'auth/account',
      data: {'password': 'uzun-ve-guvenli-sifre-2026'},
      options: _withBearerFrom(env),
    );
    env.signOut();
    final page = _right(
      await env.repository.getMemories(
        monumentId: 'bursa-ulu-camii',
        limit: 20,
      ),
    );
    expect(page.items.map((m) => m.text), isNot(contains('Geçici')));
    expect(page.total, 2);
  });

  test('herkese açık ad soyadın baş harfine kısaltılır', () {
    expect(MemoryRules.publicDisplayName('Ayşe Nur Yılmaz'), 'Ayşe Y.');
    expect(MemoryRules.publicDisplayName('  ömer   işık '), 'ömer İ.');
    expect(MemoryRules.publicDisplayName('Mehmet'), 'Mehmet');
    expect(MemoryRules.publicDisplayName(''), '');
  });
}

final _noThrow = Options(validateStatus: (_) => true);

/// `auth/` yolları test ortamında Bearer almadığından elle eklenir.
Options _withBearerFrom(MemoryTestEnvironment env) =>
    Options(headers: {'Authorization': env.lastAuthorization});
