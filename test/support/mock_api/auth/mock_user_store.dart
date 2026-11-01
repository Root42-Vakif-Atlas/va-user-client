/// Mock sunucunun kullanıcı kaydı.
///
/// Şifre düz metin olarak değil, kullanıcıya özgü tuzla PBKDF2 özetiyle
/// saklanır (gerçek sunucuda Argon2id önerilir).
final class MockUserRecord {
  MockUserRecord({
    required this.id,
    required this.displayName,
    required this.email,
    required this.passwordSalt,
    required this.passwordHash,
    required this.emailVerified,
    required this.tokenVersion,
    required this.createdAt,
    this.consentRecordedAt,
    this.failedLoginAttempts = 0,
    this.lockedUntil,
  });

  factory MockUserRecord.fromJson(Map<String, dynamic> json) {
    return MockUserRecord(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      passwordSalt: json['passwordSalt'] as String,
      passwordHash: json['passwordHash'] as String,
      emailVerified: json['emailVerified'] as bool,
      tokenVersion: json['tokenVersion'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      consentRecordedAt: json['consentRecordedAt'] == null
          ? null
          : DateTime.parse(json['consentRecordedAt'] as String),
      failedLoginAttempts: json['failedLoginAttempts'] as int? ?? 0,
      lockedUntil: json['lockedUntil'] == null
          ? null
          : DateTime.parse(json['lockedUntil'] as String),
    );
  }

  final String id;

  /// Doğrulanmamış hesaba yeniden kayıtta son kaydın adı geçerli olur.
  String displayName;
  final String email;
  String passwordSalt;
  String passwordHash;
  bool emailVerified;

  /// Şifre değiştiğinde artırılır; eski sürümlü tüm anahtarlar geçersizleşir.
  int tokenVersion;
  final DateTime createdAt;

  /// Kullanım Koşulları ve Aydınlatma Metni onayının kaydedildiği an.
  DateTime? consentRecordedAt;
  int failedLoginAttempts;
  DateTime? lockedUntil;

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'email': email,
    'passwordSalt': passwordSalt,
    'passwordHash': passwordHash,
    'emailVerified': emailVerified,
    'tokenVersion': tokenVersion,
    'createdAt': createdAt.toIso8601String(),
    'consentRecordedAt': consentRecordedAt?.toIso8601String(),
    'failedLoginAttempts': failedLoginAttempts,
    'lockedUntil': lockedUntil?.toIso8601String(),
  };
}

/// Mock kullanıcılarının kalıcı deposu (anahtar: normalize e-posta).
abstract interface class MockUserStore {
  Future<Map<String, MockUserRecord>> loadAll();

  Future<void> saveAll(Map<String, MockUserRecord> users);
}

/// Testler için bellek içi depo.
class InMemoryMockUserStore implements MockUserStore {
  Map<String, MockUserRecord> _users = {};

  @override
  Future<Map<String, MockUserRecord>> loadAll() async => {..._users};

  @override
  Future<void> saveAll(Map<String, MockUserRecord> users) async {
    _users = {...users};
  }
}
