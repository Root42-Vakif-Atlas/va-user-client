import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:vakif_atlas/core/error/exceptions.dart';
import 'package:vakif_atlas/core/storage/preferences_service.dart';

/// Uygulama kurulumunun anonim kimliği (rastgele UUID v4).
///
/// Cihaza bağlı veriler (ör. kayıtlı rotalar) sunucuda bu kimlikle
/// ilişkilendirilir; kişisel veri içermez. Veri minimizasyonu (KVKK) gereği
/// yalnızca bu verileri kullanan isteklerde gönderilir, tüm isteklere
/// eklenmez. Uygulama silinip yeniden kurulduğunda yeni kimlik üretilir.
@lazySingleton
class InstallationIdService {
  InstallationIdService(this._preferences, this._uuid);

  final PreferencesService _preferences;
  final Uuid _uuid;
  String? _cached;

  static final RegExp _uuidV4 = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  );

  static bool isValid(String value) => _uuidV4.hasMatch(value);

  Future<String> resolve() async {
    final existing = _cached ?? _preferences.installationId;
    if (existing != null && isValid(existing)) {
      return _cached = existing;
    }
    final created = _uuid.v4();
    _cached = created;
    try {
      await _preferences.setInstallationId(created);
    } on CacheException {
      // Kalıcı yazılamazsa bu oturum boyunca aynı kimlik kullanılır.
    }
    return created;
  }
}
