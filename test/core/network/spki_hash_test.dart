import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/network/ssl/spki_hash.dart';

/// Beklenen değerler OpenSSL ile bağımsız olarak üretilmiştir:
/// `openssl x509 -pubkey -noout | openssl pkey -pubin -outform der |
///  openssl dgst -sha256 -binary | base64`
void main() {
  const v1Certificate =
      'MIIC2jCCAcICCQDKbJYyeLZ47DANBgkqhkiG9w0BAQsFADAvMRwwGgYDVQQDDBNhcGkudmFraWZhdGxhcy50ZXN0MQ8wDQYDVQQKDAZSb290NDIwHhcNMjYxMDE3MTI0NDExWhcNMzYxMDE0MTI0NDExWjAvMRwwGgYDVQQDDBNhcGkudmFraWZhdGxhcy50ZXN0MQ8wDQYDVQQKDAZSb290NDIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCh2W4JOd9GAL7c6YxABf8eWmThOxOSb0g4NCbib8vSzuUqib+sEGZQkbrYzrs/1DQKmphb/1E6IkL/ROaYbprPVoNEnl2Q3xgafpiiB0GwaEv65olxAwBx5oxgsxofs3LtVWgcKsAH02E+0vru7F7S1lFzi7bRql8A0DC/rbV+jahDodccMeSU9XQRe6OCvbhdoDTqvaZidCKSqYlGXDwiQOXaFKwRiNNzWvAisqgQ2s6SWvVdaFv3yofo1vtWt+XIPlNObSygEqmdipy8IUsArRuMFSNKF1He6igZkCCIvJeblKzyQ7BZ7K43u5ICcVyPmPTHIOgwgpg8U/2FbiX7AgMBAAEwDQYJKoZIhvcNAQELBQADggEBABrBYYvj4o7WKIjC4i5ueyw5yNzjsFD6Pra3lKNwcbxc//8ZBRk3JqdRorIYiRJv2XmiDOKSAwiAMSzSso8hgPfuf39LmwqRhcwsfy8xrPKBY8d3M36UTwFvZimUETGEc+V18OEuoIi4dadeho89flL+C/eqIKemO0oNsnjpWbYTpGJpLOjFOX5G0B4VZztdalPW0fVe/gs/iNAu4vsN8jqWUBemL64NjR7cofXo+9oHxJMUfEWnMAdbhInhFHqSKpPGznw+IGpmGK/Lvd3f0m5MfPplFz00yPxL05kNJ3hZ8LdzkDZMbPXWz3/j9dAyWurV1g1+7QxrbM9+OsDD6ZM=';
  const v1Spki = 'rXj0qAp+w5H+n/1np1XhmkA9BhJgnxRxvAQUKOumSt8=';

  const v3Certificate =
      'MIIDAzCCAeugAwIBAgIJANs8x4GXfnNMMA0GCSqGSIb3DQEBCwUAMC8xHDAaBgNVBAMME2FwaS52YWtpZmF0bGFzLnRlc3QxDzANBgNVBAoMBlJvb3Q0MjAeFw0yNjEwMTcxMjQ0MjFaFw0zNjEwMTQxMjQ0MjFaMC8xHDAaBgNVBAMME2FwaS52YWtpZmF0bGFzLnRlc3QxDzANBgNVBAoMBlJvb3Q0MjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANyGa7aWoJng4RZJTwZqmnxZD3tPFnhvUBeIGTZaQBfbskZUESvquWr3rpiLxAFaYszN+BQwmwQIVuPdokoxB4cAQPyZLvNmOf9MA8yjWocrCvetn5zHPOeEDSGI+i/YXsqRur0QPD6QIQlpP7juAZCGO77SxkmJLBrj52QkV6++WjxKNsalaxBDl5JU8jeat1kMk1mW7M+5JKMvgQsQSdX9Xj48pTCRVec03UuEPsfw1F9PSgqzPTFRNdU+1+I81COLTV0jXKolM3arM0K9Dm9FUk9X7W/Q6KVhFkEX7cqUuY8Fq6mvBRiqsVWsLTCKzP3eOFiGE5CkKKwygh82xa8CAwEAAaMiMCAwHgYDVR0RBBcwFYITYXBpLnZha2lmYXRsYXMudGVzdDANBgkqhkiG9w0BAQsFAAOCAQEAkfcCydGi5oH4b5ZVucPy66D2U2W9ueCjfGrK5XCSfvbCH8QbMp9cGGrhtW1T1JoYcNO4PPRE1SGVy9EbAkEC39lf4eE1WORbmwkE9J5QxCbRffqsT1RkNDwM18HzKD7i3csKr4MvXVYijO7RmH93aO3SQJevSPQ2GyggrT9GPHiwZ5e23ZxCL/ZEDVLTu8GTbUVdL45mmPXrJfkcUI7RoQEuOFU52VS+5Vol7QPYCmrvPGSK5J4hkLtC6fCkZSMguRjy+lLyAlKAOXPPOJY7A7W5RljGBq65ZMVB9IPfBBeotTmSIC3mtshYB4RbcVej5luFVVrRe4U/QXjjy07+BQ==';
  const v3Spki = 'h67UpF0h2InNGzmN74W19i37c8sLmAoP7axDOU4ykGU=';

  Uint8List der(String value) => base64.decode(value);

  test('sürüm alanı olmayan (v1) sertifikada SPKI özeti OpenSSL ile aynı', () {
    expect(SpkiHash.fromCertificateDer(der(v1Certificate)), v1Spki);
  });

  test('sürüm alanı olan (v3) sertifikada SPKI özeti OpenSSL ile aynı', () {
    expect(SpkiHash.fromCertificateDer(der(v3Certificate)), v3Spki);
  });

  test('bozuk veya kesik DER için null döner', () {
    expect(SpkiHash.fromCertificateDer(Uint8List(0)), isNull);
    expect(
      SpkiHash.fromCertificateDer(Uint8List.fromList([0x30, 0x82])),
      isNull,
    );
    final truncated = der(v3Certificate).sublist(0, 200);
    expect(SpkiHash.fromCertificateDer(truncated), isNull);
    expect(
      SpkiHash.fromCertificateDer(
        Uint8List.fromList(utf8.encode('not a cert')),
      ),
      isNull,
    );
  });
}
