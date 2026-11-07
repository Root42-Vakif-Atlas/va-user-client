import 'package:vakif_atlas/features/catalog/domain/entities/monument_summary.dart';

/// Kullanıcının yakınında olduğu ve bildirilecek eser.
final class NearbyAlert {
  const NearbyAlert({
    required this.monument,
    required this.distanceMeters,
    this.accuracyMeters = 0,
  });

  final MonumentSummary monument;

  /// Kullanıcının konumuna kuş uçuşu mesafe (metre).
  final double distanceMeters;

  /// Konumun doğruluk yarıçapı (metre). Mesafeden büyükse mesafe kesin
  /// değildir (masaüstünde Wi-Fi konumu: ~65 – 250 m).
  final double accuracyMeters;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NearbyAlert &&
          other.monument == monument &&
          other.distanceMeters == distanceMeters &&
          other.accuracyMeters == accuracyMeters;

  @override
  int get hashCode => Object.hash(monument, distanceMeters, accuracyMeters);

  @override
  String toString() =>
      'NearbyAlert(${monument.id}, ${distanceMeters.round()} m)';
}
