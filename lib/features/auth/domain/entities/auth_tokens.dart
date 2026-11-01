/// Erişim ve yenileme anahtarı çifti.
final class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthTokens &&
          other.accessToken == accessToken &&
          other.refreshToken == refreshToken &&
          other.expiresAt == expiresAt;

  @override
  int get hashCode => Object.hash(accessToken, refreshToken, expiresAt);

  /// Anahtarlar asla loglanmaz.
  @override
  String toString() => 'AuthTokens(expiresAt: $expiresAt)';
}
