import 'package:vakif_atlas/core/utils/list_equality.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/geo_point.dart';

/// Dışa aktarılacak rota belgesinin içeriği.
///
/// Metinler arayüz dilinde önceden biçimlendirilmiştir; böylece belge
/// oluşturucu (PDF) yerelleştirmeden bağımsızdır ve ileride sunucu tarafı
/// üretime aynı içerik gönderilebilir.
final class RouteDocument {
  RouteDocument({
    required this.routeId,
    required this.title,
    required this.subtitle,
    required this.languageCode,
    required this.fileName,
    required List<RouteDocumentFact> facts,
    required List<RouteDocumentStop> stops,
    required List<GeoPoint> path,
    required this.labels,
  }) : facts = List.unmodifiable(facts),
       stops = List.unmodifiable(stops),
       path = List.unmodifiable(path);

  final String routeId;

  /// Rota adı (belge başlığı ve meta verisi).
  final String title;

  /// Ör. "Edirne → Bursa · 3 durak".
  final String subtitle;
  final String languageCode;

  /// Paylaşımda kullanılan dosya adı (`.pdf` uzantılı).
  final String fileName;

  /// Süre ve mesafe özeti.
  final List<RouteDocumentFact> facts;
  final List<RouteDocumentStop> stops;

  /// Karayolu çizgisi (şematik rota çizimi); boşsa duraklar birleştirilir.
  final List<GeoPoint> path;
  final RouteDocumentLabels labels;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteDocument &&
          other.routeId == routeId &&
          other.title == title &&
          other.subtitle == subtitle &&
          other.languageCode == languageCode &&
          other.fileName == fileName &&
          elementsEqual(other.facts, facts) &&
          elementsEqual(other.stops, stops) &&
          elementsEqual(other.path, path) &&
          other.labels == labels;

  @override
  int get hashCode => Object.hash(
    routeId,
    title,
    subtitle,
    languageCode,
    fileName,
    Object.hashAll(facts),
    Object.hashAll(stops),
    Object.hashAll(path),
    labels,
  );
}

/// Özet satırı: "Toplam süre — 7 sa 30 dk".
final class RouteDocumentFact {
  const RouteDocumentFact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  bool operator ==(Object other) =>
      other is RouteDocumentFact &&
      other.label == label &&
      other.value == value;

  @override
  int get hashCode => Object.hash(label, value);
}

final class RouteDocumentStop {
  RouteDocumentStop({
    required this.name,
    required this.place,
    required this.location,
    required this.mapUrl,
    required List<String> details,
    this.nextLeg,
  }) : details = List.unmodifiable(details);

  final String name;

  /// İlçe, il · yapı türü.
  final String place;
  final GeoPoint location;

  /// Konumun haritada açılacağı bağlantı.
  final String mapUrl;

  /// Ziyaret süresi ve molalar.
  final List<String> details;

  /// Sonraki durağa yolculuk; son durakta `null`.
  final String? nextLeg;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteDocumentStop &&
          other.name == name &&
          other.place == place &&
          other.location == location &&
          other.mapUrl == mapUrl &&
          elementsEqual(other.details, details) &&
          other.nextLeg == nextLeg;

  @override
  int get hashCode => Object.hash(
    name,
    place,
    location,
    mapUrl,
    Object.hashAll(details),
    nextLeg,
  );
}

/// Belgenin sabit metinleri (arayüz dilinde).
final class RouteDocumentLabels {
  const RouteDocumentLabels({
    required this.brand,
    required this.summaryHeading,
    required this.sketchHeading,
    required this.sketchCaption,
    required this.stopsHeading,
    required this.mapLink,
    required this.disclaimer,
    required this.attribution,
    required this.generatedOn,
    required this.pageOf,
  });

  final String brand;
  final String summaryHeading;
  final String sketchHeading;
  final String sketchCaption;
  final String stopsHeading;
  final String mapLink;
  final String disclaimer;

  /// Yol verisi atfı (ODbL).
  final String attribution;

  /// Ör. "Oluşturulma: 18 Ekim 2026 20:15".
  final String generatedOn;

  /// `{page}` ve `{total}` yer tutuculu sayfa etiketi.
  final String pageOf;

  static const String pagePlaceholder = '{page}';
  static const String totalPlaceholder = '{total}';

  String page(int page, int total) => pageOf
      .replaceAll(pagePlaceholder, '$page')
      .replaceAll(totalPlaceholder, '$total');

  @override
  bool operator ==(Object other) =>
      other is RouteDocumentLabels &&
      other.brand == brand &&
      other.summaryHeading == summaryHeading &&
      other.sketchHeading == sketchHeading &&
      other.sketchCaption == sketchCaption &&
      other.stopsHeading == stopsHeading &&
      other.mapLink == mapLink &&
      other.disclaimer == disclaimer &&
      other.attribution == attribution &&
      other.generatedOn == generatedOn &&
      other.pageOf == pageOf;

  @override
  int get hashCode => Object.hash(
    brand,
    summaryHeading,
    sketchHeading,
    sketchCaption,
    stopsHeading,
    mapLink,
    disclaimer,
    attribution,
    generatedOn,
    pageOf,
  );
}
