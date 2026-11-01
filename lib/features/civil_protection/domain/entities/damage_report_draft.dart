import 'dart:math';

import 'package:vakif_atlas/core/media/photo_draft.dart';
import 'package:vakif_atlas/core/utils/list_equality.dart';
import 'package:vakif_atlas/features/civil_protection/domain/entities/damage_report.dart';

/// Bildirenin onayıyla rapora eklenen cihaz konumu. Yalnızca o rapor için
/// gönderilir; başka hiçbir istekte konum yer almaz.
final class ReportLocation {
  const ReportLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
  });

  final double latitude;
  final double longitude;
  final double accuracyMeters;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportLocation &&
          other.latitude == latitude &&
          other.longitude == longitude &&
          other.accuracyMeters == accuracyMeters;

  @override
  int get hashCode => Object.hash(latitude, longitude, accuracyMeters);

  /// Konum kişisel veridir; loglara koordinat yazılmaz.
  @override
  String toString() => 'ReportLocation(±${accuracyMeters.round()} m)';
}

/// Gönderilecek rapor (`POST civil-protection/reports`).
final class DamageReportDraft {
  const DamageReportDraft({
    required this.monumentId,
    required this.category,
    required this.urgency,
    required this.description,
    this.photos = const [],
    this.location,
  });

  final String? monumentId;
  final DamageCategory? category;
  final ReportUrgency? urgency;
  final String description;
  final List<PhotoDraft> photos;

  /// `null` → bildiren konum paylaşmadı.
  final ReportLocation? location;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DamageReportDraft &&
          other.monumentId == monumentId &&
          other.category == category &&
          other.urgency == urgency &&
          other.description == description &&
          elementsEqual(other.photos, photos) &&
          other.location == location;

  @override
  int get hashCode => Object.hash(
    monumentId,
    category,
    urgency,
    description,
    Object.hashAll(photos),
    location,
  );

  @override
  String toString() =>
      'DamageReportDraft(monumentId: $monumentId, category: $category)';
}

enum DamageReportIssue {
  monumentMissing,
  categoryMissing,
  urgencyMissing,
  descriptionTooShort,
  descriptionTooLong,
  tooManyPhotos,
  photoTooLarge,
  photoDescriptionTooLong,
}

/// Sivil Koruma kuralları. Sunucu da aynı kuralları uygular
/// (`docs/api-contracts.md` → Sivil Koruma).
abstract final class DamageReportRules {
  /// VGM'nin değerlendirebilmesi için anlamlı bir açıklama gerekir.
  static const int minDescriptionLength = 20;
  static const int maxDescriptionLength = 2000;
  static const int maxPhotos = 4;
  static const int maxPhotoDescriptionLength = 250;
  static const int maxPhotoBytes = 5 * 1024 * 1024;

  /// Bu mesafe içindeki konum "yerinde" sayılır (metre).
  static const int onSiteRadiusMeters = 500;

  static const int pageSize = 20;

  static DamageReportIssue? validate(DamageReportDraft draft) {
    final monumentId = draft.monumentId;
    if (monumentId == null || monumentId.isEmpty) {
      return DamageReportIssue.monumentMissing;
    }
    if (draft.category == null) {
      return DamageReportIssue.categoryMissing;
    }
    if (draft.urgency == null) {
      return DamageReportIssue.urgencyMissing;
    }
    return validateDetails(draft);
  }

  /// Açıklama ve fotoğraf adımının kuralları.
  static DamageReportIssue? validateDetails(DamageReportDraft draft) {
    final length = draft.description.trim().runes.length;
    if (length < minDescriptionLength) {
      return DamageReportIssue.descriptionTooShort;
    }
    if (length > maxDescriptionLength) {
      return DamageReportIssue.descriptionTooLong;
    }
    if (draft.photos.length > maxPhotos) {
      return DamageReportIssue.tooManyPhotos;
    }
    for (final photo in draft.photos) {
      if (photo.bytes.length > maxPhotoBytes) {
        return DamageReportIssue.photoTooLarge;
      }
      if (photo.description.trim().runes.length > maxPhotoDescriptionLength) {
        return DamageReportIssue.photoDescriptionTooLong;
      }
    }
    return null;
  }

  /// İki nokta arasındaki büyük daire mesafesi (metre, haversine).
  static double distanceMeters(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  ) {
    const earthRadius = 6371000.0;
    double radians(double degrees) => degrees * pi / 180;
    final dLat = radians(latitude2 - latitude1);
    final dLng = radians(longitude2 - longitude1);
    final a =
        pow(sin(dLat / 2), 2) +
        cos(radians(latitude1)) *
            cos(radians(latitude2)) *
            pow(sin(dLng / 2), 2);
    return 2 * earthRadius * asin(sqrt(a));
  }
}
