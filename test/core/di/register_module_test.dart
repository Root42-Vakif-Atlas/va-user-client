import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vakif_atlas/core/di/register_module.dart';

class _Module extends RegisterModule {}

void main() {
  test('macOS güvenli depolaması yetki gerektirmeyen anahtar zincirini '
      'kullanır (aksi halde giriş -34018 ile başarısız olur)', () {
    // Yerel tarafa iletilen seçenekler.
    final options = _Module().secureStorage.mOptions.toMap();

    expect(options['usesDataProtectionKeychain'], 'false');
    expect(
      options['accessibility'],
      KeychainAccessibility.first_unlock_this_device.name,
    );
  });
}
