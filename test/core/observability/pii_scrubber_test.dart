import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:vakif_atlas/core/observability/app_logger.dart';
import 'package:vakif_atlas/core/observability/pii_scrubber.dart';

class _CapturingOutput extends LogOutput {
  final List<String> lines = [];

  @override
  void output(OutputEvent event) => lines.addAll(event.lines);
}

void main() {
  group('PiiScrubber', () {
    test(
      'hassas anahtarları büyük/küçük harf ve alt çizgiden bağımsız maskeler',
      () {
        final scrubbed = PiiScrubber.scrub({
          'email': 'ali@example.org',
          'Password': 'gizli',
          'access_token': 'abc',
          'refreshToken': 'def',
          'Authorization': 'Bearer xyz',
          'latitude': 41.0,
          'monumentId': 'm-1',
        });

        expect(scrubbed, {
          'email': PiiScrubber.mask,
          'Password': PiiScrubber.mask,
          'access_token': PiiScrubber.mask,
          'refreshToken': PiiScrubber.mask,
          'Authorization': PiiScrubber.mask,
          'latitude': PiiScrubber.mask,
          'monumentId': 'm-1',
        });
      },
    );

    test('iç içe yapıları özyinelemeli temizler', () {
      final scrubbed = PiiScrubber.scrub({
        'user': {'email': 'a@b.co', 'name': 'Ayşe'},
        'items': [
          {'token': 't'},
        ],
      });

      expect(scrubbed, {
        'user': {'email': PiiScrubber.mask, 'name': 'Ayşe'},
        'items': [
          {'token': PiiScrubber.mask},
        ],
      });
    });

    test('serbest metindeki JWT, Bearer ve e-postayı maskeler', () {
      const jwt = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIn0.c2lnbmF0dXJl';
      final text = PiiScrubber.scrubText(
        'user=ali@example.org header=Bearer abc.def token=$jwt',
      );
      expect(text, isNot(contains('ali@example.org')));
      expect(text, isNot(contains('abc.def')));
      expect(text, isNot(contains(jwt)));
    });
  });

  group('AppLogger', () {
    test('mesaj ve bağlamı PII temizlenmiş olarak yazar', () {
      final output = _CapturingOutput();
      final logger = AppLogger.withLogger(
        Logger(
          filter: ProductionFilter(),
          printer: SimplePrinter(colors: false),
          output: output,
          level: Level.trace,
        ),
      );

      logger.info(
        'Giriş: veli@example.org',
        context: {'password': 'p4ss', 'step': 2},
      );

      final written = output.lines.join('\n');
      expect(written, isNot(contains('veli@example.org')));
      expect(written, isNot(contains('p4ss')));
      expect(written, contains('step'));
    });

    test('prod seviyesi (Level.off) hiçbir şey yazmaz', () {
      final output = _CapturingOutput();
      final logger = AppLogger.withLogger(
        Logger(
          filter: ProductionFilter(),
          printer: SimplePrinter(colors: false),
          output: output,
          level: Level.off,
        ),
      );

      logger.error('hata', error: StateError('x'));

      expect(output.lines, isEmpty);
    });
  });
}
