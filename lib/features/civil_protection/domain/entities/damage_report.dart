import 'package:vakif_atlas/core/utils/list_equality.dart';

/// Bildirilen durumun türü.
enum DamageCategory {
  /// Çatlak, ayrışma, yapısal bozulma.
  structuralDamage,

  /// Çökme veya parça düşme tehlikesi.
  collapseRisk,

  /// Yazı, çizim, kırma, tahribat.
  vandalism,

  /// Çalınan veya eksik parça (çini, kitabe, kapı tokmağı vb.).
  theft,

  /// Yangın, su baskını, sızıntı.
  fireOrWater,

  /// İzinsiz yapı, onarım veya kazı.
  unauthorizedWork,

  other,
}

/// Bildirenin değerlendirdiği aciliyet. Sunucu yalnızca önceliklendirme için
/// kullanır; can güvenliği için 112 aranmalıdır.
enum ReportUrgency { low, medium, high, critical }

/// Bildirimin VGM'deki işlem durumu.
enum DamageReportStatus {
  /// Alındı, kayıt numarası verildi.
  received,

  /// Sivil Koruma birimince inceleniyor.
  inReview,

  /// Yetkili bölge müdürlüğüne / birime iletildi.
  forwarded,

  /// Gerekli işlem yapıldı.
  resolved,

  /// İşlem gerektirmeden kapatıldı (mükerrer, kapsam dışı vb.).
  closed;

  bool get isFinal => this == resolved || this == closed;
}

/// Raporun yerinde yapılıp yapılmadığı (sunucunun hesapladığı).
enum LocationVerification {
  /// Bildiren konum paylaşmadı.
  notProvided,

  /// Konum esere [DamageReportRules.onSiteRadiusMeters] içinde.
  onSite,

  /// Konum paylaşıldı ancak esere uzak.
  distant,
}

final class ReportLocationCheck {
  const ReportLocationCheck({required this.verification, this.distanceMeters});

  static const ReportLocationCheck notProvided = ReportLocationCheck(
    verification: LocationVerification.notProvided,
  );

  final LocationVerification verification;

  /// Esere uzaklık (metre); konum paylaşılmadıysa `null`.
  final int? distanceMeters;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportLocationCheck &&
          other.verification == verification &&
          other.distanceMeters == distanceMeters;

  @override
  int get hashCode => Object.hash(verification, distanceMeters);
}

/// Durum geçmişindeki bir adım.
final class DamageReportStatusChange {
  const DamageReportStatusChange({
    required this.status,
    required this.at,
    this.note,
  });

  final DamageReportStatus status;
  final DateTime at;

  /// VGM'nin vatandaşa notu (isteğe bağlı).
  final String? note;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DamageReportStatusChange &&
          other.status == status &&
          other.at == at &&
          other.note == note;

  @override
  int get hashCode => Object.hash(status, at, note);
}

/// Rapora eklenmiş fotoğraf.
final class ReportPhoto {
  const ReportPhoto({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    required this.width,
    required this.height,
    this.description,
  });

  final String id;
  final String url;
  final String thumbnailUrl;
  final int width;
  final int height;
  final String? description;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportPhoto &&
          other.id == id &&
          other.url == url &&
          other.thumbnailUrl == thumbnailUrl &&
          other.width == width &&
          other.height == height &&
          other.description == description;

  @override
  int get hashCode =>
      Object.hash(id, url, thumbnailUrl, width, height, description);
}

/// Raporun ilgili olduğu eser (sunucu istek dilinde doldurur).
final class ReportMonument {
  const ReportMonument({
    required this.id,
    required this.name,
    required this.city,
    required this.district,
  });

  final String id;
  final String name;
  final String city;
  final String district;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportMonument &&
          other.id == id &&
          other.name == name &&
          other.city == city &&
          other.district == district;

  @override
  int get hashCode => Object.hash(id, name, city, district);
}

/// Vatandaşın Sivil Koruma bildirimi. Yalnızca bildiren ve VGM görür.
final class DamageReport {
  const DamageReport({
    required this.id,
    required this.referenceCode,
    required this.monument,
    required this.category,
    required this.urgency,
    required this.description,
    required this.photos,
    required this.locationCheck,
    required this.status,
    required this.history,
    required this.createdAt,
  });

  final String id;

  /// Vatandaşın başvuruyu VGM'ye sorarken kullanacağı numara
  /// (ör. `SK-2026-000123`).
  final String referenceCode;
  final ReportMonument monument;
  final DamageCategory category;
  final ReportUrgency urgency;
  final String description;
  final List<ReportPhoto> photos;
  final ReportLocationCheck locationCheck;
  final DamageReportStatus status;

  /// Eskiden yeniye durum geçmişi (ilk kayıt `received`).
  final List<DamageReportStatusChange> history;
  final DateTime createdAt;

  DateTime get updatedAt => history.isEmpty ? createdAt : history.last.at;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DamageReport &&
          other.id == id &&
          other.referenceCode == referenceCode &&
          other.monument == monument &&
          other.category == category &&
          other.urgency == urgency &&
          other.description == description &&
          elementsEqual(other.photos, photos) &&
          other.locationCheck == locationCheck &&
          other.status == status &&
          elementsEqual(other.history, history) &&
          other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    referenceCode,
    monument,
    category,
    urgency,
    description,
    Object.hashAll(photos),
    locationCheck,
    status,
    Object.hashAll(history),
    createdAt,
  );

  /// Kullanıcı metni ve konum loglara yazılmaz.
  @override
  String toString() => 'DamageReport(id: $id, status: $status)';
}

/// İmleçle sayfalanmış raporlar, en yeni önce.
final class DamageReportPage {
  const DamageReportPage({
    required this.items,
    required this.total,
    this.nextCursor,
  });

  static const DamageReportPage empty = DamageReportPage(items: [], total: 0);

  final List<DamageReport> items;
  final int total;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DamageReportPage &&
          elementsEqual(other.items, items) &&
          other.total == total &&
          other.nextCursor == nextCursor;

  @override
  int get hashCode => Object.hash(Object.hashAll(items), total, nextCursor);
}
