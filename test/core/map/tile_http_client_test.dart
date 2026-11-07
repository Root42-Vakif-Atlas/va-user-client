import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vakif_atlas/core/map/tile_http_client.dart';

void main() {
  final tile = Uri.parse('https://tile.example.org/15/1/2.png');
  late List<Duration> waits;

  setUp(() => waits = []);

  TileHttpClient client(
    MockClientHandler handler, {
    Duration timeout = const Duration(seconds: 10),
  }) => TileHttpClient(
    inner: MockClient(handler),
    timeout: timeout,
    sleep: (delay) async => waits.add(delay),
  );

  test('hız sınırı (429) yeniden denenir; Retry-After\'a uyulur', () async {
    var calls = 0;
    final response = await client((request) async {
      calls++;
      return calls == 1
          ? http.Response('', 429, headers: {'retry-after': '2'})
          : http.Response.bytes([1, 2, 3], 200);
    }).get(tile);

    expect(response.statusCode, 200);
    expect(response.bodyBytes, [1, 2, 3]);
    expect(calls, 2);
    expect(waits, [const Duration(seconds: 2)]);
  });

  test('uzun Retry-After üst sınırla kısaltılır', () async {
    var calls = 0;
    await client((request) async {
      calls++;
      return calls == 1
          ? http.Response('', 503, headers: {'retry-after': '120'})
          : http.Response('', 200);
    }).get(tile);

    expect(waits, [const Duration(seconds: 5)]);
  });

  test(
    'geçici hatalar üstel beklemeyle en çok 3 kez yeniden denenir',
    () async {
      var calls = 0;
      final response = await client((request) async {
        calls++;
        return http.Response('', 502);
      }).get(tile);

      expect(response.statusCode, 502);
      expect(calls, 4);
      expect(waits, const [
        Duration(milliseconds: 500),
        Duration(seconds: 1),
        Duration(seconds: 2),
      ]);
    },
  );

  test('kalıcı hata (404) yeniden denenmez', () async {
    var calls = 0;
    final response = await client((request) async {
      calls++;
      return http.Response('', 404);
    }).get(tile);

    expect(response.statusCode, 404);
    expect(calls, 1);
  });

  test('bağlantı hatası yeniden denenir', () async {
    var calls = 0;
    final response = await client((request) async {
      calls++;
      if (calls == 1) {
        throw http.ClientException('Connection reset', request.url);
      }
      return http.Response('', 200);
    }).get(tile);

    expect(response.statusCode, 200);
    expect(calls, 2);
  });

  test('takılan istek zaman aşımına düşer ve yeniden denenir', () async {
    var calls = 0;
    final response = await client((request) async {
      calls++;
      if (calls == 1) {
        await Completer<void>().future; // Hiç yanıt gelmez.
      }
      return http.Response('', 200);
    }, timeout: const Duration(milliseconds: 20)).get(tile);

    expect(response.statusCode, 200);
    expect(calls, 2);
  });

  test('yeniden denemeler de başarısızsa hata iletilir', () async {
    await expectLater(
      client((request) async {
        throw http.ClientException('offline', request.url);
      }).get(tile),
      throwsA(isA<http.ClientException>()),
    );
    expect(waits, hasLength(3));
  });
}
