import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/storage/secure_storage_service.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockFlutterSecureStorage storage;
  late SecureStorageService service;

  setUp(() {
    storage = _MockFlutterSecureStorage();
    service = SecureStorageService(storage);
    when(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
    when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});
  });

  test('saveTokens iki anahtarı da yazar', () async {
    await service.saveTokens(accessToken: 'access', refreshToken: 'refresh');

    verify(() => storage.write(key: 'auth.access_token', value: 'access'))
        .called(1);
    verify(() => storage.write(key: 'auth.refresh_token', value: 'refresh'))
        .called(1);
  });

  test('erişim anahtarı bellekte tutulur, depoya bir kez gidilir', () async {
    when(() => storage.read(key: 'auth.access_token'))
        .thenAnswer((_) async => 'stored');

    expect(await service.getAccessToken(), 'stored');
    expect(await service.getAccessToken(), 'stored');

    verify(() => storage.read(key: 'auth.access_token')).called(1);
  });

  test('kaydedilen erişim anahtarı depoya gitmeden okunur', () async {
    await service.saveAccessToken('fresh');

    expect(await service.getAccessToken(), 'fresh');
    verifyNever(() => storage.read(key: any(named: 'key')));
  });

  test('deleteTokens anahtarları siler ve bellek kopyasını temizler', () async {
    await service.saveAccessToken('fresh');
    await service.deleteTokens();

    expect(await service.getAccessToken(), isNull);
    verify(() => storage.delete(key: 'auth.access_token')).called(1);
    verify(() => storage.delete(key: 'auth.refresh_token')).called(1);
  });

  test('kalıcı olarak okunamayan kayıt silinir ve yokmuş gibi döner '
      '(macOS: başka derlemenin kaydı, -128)', () async {
    when(() => storage.read(key: any(named: 'key'))).thenThrow(
      PlatformException(
        code: 'Unexpected security result code',
        message: 'Code: -128, Message: User canceled the operation.',
        details: -128,
      ),
    );

    expect(await service.getRefreshToken(), isNull);
    expect(await service.getAccessToken(), isNull);
    verify(() => storage.delete(key: 'auth.refresh_token')).called(1);
    verify(() => storage.delete(key: 'auth.access_token')).called(1);

    // Erişim anahtarı yeniden okunmaz (macOS her okumada izin sorardı).
    await service.getAccessToken();
    verify(() => storage.read(key: 'auth.access_token')).called(1);
  });

  test('cihaz kilitliyken (geçici) kayıt silinmez, CacheException '
      'fırlatılır', () async {
    when(() => storage.read(key: any(named: 'key'))).thenThrow(
      PlatformException(
        code: 'Unexpected security result code',
        message: 'Code: -25308, Message: User interaction is not allowed.',
        details: SecureStorageService.interactionNotAllowed,
      ),
    );

    await expectLater(service.getRefreshToken, throwsA(isA<CacheException>()));
    verifyNever(() => storage.delete(key: any(named: 'key')));
  });

  test('clearAll tüm depoyu siler', () async {
    when(storage.deleteAll).thenAnswer((_) async {});
    when(() => storage.read(key: 'auth.access_token'))
        .thenAnswer((_) async => null);

    await service.saveAccessToken('fresh');
    await service.clearAll();

    verify(storage.deleteAll).called(1);
    expect(await service.getAccessToken(), isNull);
  });
}
