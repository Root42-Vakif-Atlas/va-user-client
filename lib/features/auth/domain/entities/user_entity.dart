/// Kimliği doğrulanmış vatandaş (`citizen` rolü).
final class UserEntity {
  const UserEntity({
    required this.id,
    required this.displayName,
    required this.email,
  });

  final String id;
  final String displayName;
  final String email;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          other.id == id &&
          other.displayName == displayName &&
          other.email == email;

  @override
  int get hashCode => Object.hash(id, displayName, email);

  /// Loglarda PII sızmaması için yalnızca kimlik yazılır.
  @override
  String toString() => 'UserEntity(id: $id)';
}
