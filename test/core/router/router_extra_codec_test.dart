import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/router/router_extra_codec.dart';
import 'package:vakif_atlas/features/auth/domain/entities/verification_challenge.dart';

void main() {
  const codec = RouterExtraCodec();

  test('doğrulama bilgisi ve metin gidiş-dönüşte korunur', () {
    const challenge = VerificationChallenge(
      email: 'zeynep@example.org',
      resendAfter: Duration(seconds: 60),
      codeLength: 8,
    );
    expect(codec.decode(codec.encode(challenge)), challenge);
    expect(codec.decode(codec.encode('Selimiye Camii')), 'Selimiye Camii');
  });

  test('bilinmeyen değerler null olur', () {
    expect(codec.encode(Object()), isNull);
    expect(codec.decode(null), isNull);
    expect(codec.decode({'type': 'unknown'}), isNull);
  });
}
