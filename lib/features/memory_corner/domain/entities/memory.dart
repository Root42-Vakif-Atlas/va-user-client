import 'package:vakif_atlas/core/utils/list_equality.dart';

/// İçeriğin moderasyon durumu.
///
/// Yapay zekâ moderasyonu devreye girene kadar sunucu anıları doğrudan
/// [approved] olarak yayınlar; herkese açık liste yalnızca onaylı anıları
/// döndürür. Diğer durumlar yalnızca anının sahibine görünür.
enum MemoryModerationStatus {
  approved,

  /// İnceleme sürüyor (AI moderasyon kuyruğu veya kullanıcı bildirimi).
  pending,

  /// Topluluk kurallarına aykırı bulundu.
  rejected,
}

/// Anıyı paylaşan kullanıcının herkese açık kimliği.
///
/// [displayName] sunucuda kısaltılır ("Ayşe Yılmaz" → "Ayşe Y."); tam ad ve
/// e-posta herkese açık yanıtlarda bulunmaz (KVKK veri minimizasyonu).
final class MemoryAuthor {
  const MemoryAuthor({required this.id, required this.displayName});

  final String id;
  final String displayName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryAuthor &&
          other.id == id &&
          other.displayName == displayName;

  @override
  int get hashCode => Object.hash(id, displayName);

  @override
  String toString() => 'MemoryAuthor(id: $id)';
}

/// Anıya eklenmiş fotoğraf. Sunucu yeniden kodlar, küçük resmini üretir.
final class MemoryPhoto {
  const MemoryPhoto({
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

  /// Paylaşanın yazdığı betim (ekran okuyucu için alternatif metin).
  final String? description;

  /// Yerleşimi görsel yüklenmeden ayırmak için en-boy oranı.
  double get aspectRatio => width > 0 && height > 0 ? width / height : 1;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryPhoto &&
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

/// Bir eserin Anı Köşesi'nde paylaşılmış anı.
final class Memory {
  const Memory({
    required this.id,
    required this.monumentId,
    required this.author,
    required this.text,
    required this.photos,
    required this.createdAt,
    this.visitedOn,
    this.status = MemoryModerationStatus.approved,
    DateTime? memoryDate,
    // Özel alan adlandırılmış parametre olamaz; başlatma listesiyle atanır.
    // ignore: prefer_initializing_formals
  }) : _memoryDate = memoryDate;

  final String id;
  final String monumentId;
  final MemoryAuthor author;
  final String text;
  final List<MemoryPhoto> photos;
  final DateTime createdAt;

  /// Paylaşanın belirttiği ziyaret tarihi (gün hassasiyetinde, isteğe bağlı).
  final DateTime? visitedOn;
  final MemoryModerationStatus status;

  final DateTime? _memoryDate;

  /// Zaman çizelgesindeki yeri (takvim günü): ziyaret tarihi, yoksa paylaşım
  /// günü. Sunucu sıralama ve filtrede aynı değeri kullanır ve yanıtta
  /// döndürür; yoksa yerel olarak türetilir.
  DateTime get memoryDate {
    final served = _memoryDate ?? visitedOn;
    if (served != null) {
      return DateTime(served.year, served.month, served.day);
    }
    final local = createdAt.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  bool isAuthoredBy(String? userId) => userId != null && author.id == userId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Memory &&
          other.id == id &&
          other.monumentId == monumentId &&
          other.author == author &&
          other.text == text &&
          elementsEqual(other.photos, photos) &&
          other.createdAt == createdAt &&
          other.visitedOn == visitedOn &&
          other.memoryDate == memoryDate &&
          other.status == status;

  @override
  int get hashCode => Object.hash(
    id,
    monumentId,
    author,
    text,
    Object.hashAll(photos),
    createdAt,
    visitedOn,
    memoryDate,
    status,
  );

  /// Kullanıcı metni loglara yazılmaz.
  @override
  String toString() => 'Memory(id: $id, monumentId: $monumentId)';
}

/// Zaman çizelgesi filtresi: anı tarihi bu takvim günleri arasında
/// (ikisi dahil). Uçlardan biri `null` ise o yön sınırsızdır.
final class MemoryDateRange {
  const MemoryDateRange({this.from, this.to});

  /// [year] yılının tamamı.
  MemoryDateRange.year(int year)
    : from = DateTime(year),
      to = DateTime(year, 12, 31);

  final DateTime? from;
  final DateTime? to;

  /// Aralık tam bir takvim yılıysa o yıl; değilse `null`.
  int? get year {
    final start = from;
    final end = to;
    if (start == null || end == null) {
      return null;
    }
    final isYear =
        start.year == end.year &&
        start.month == 1 &&
        start.day == 1 &&
        end.month == 12 &&
        end.day == 31;
    return isYear ? start.year : null;
  }

  bool contains(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    final start = from;
    final end = to;
    return (start == null || !date.isBefore(start)) &&
        (end == null || !date.isAfter(end));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryDateRange && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);
}

/// Bir yıldaki anı sayısı (filtre çipleri).
final class MemoryYearCount {
  const MemoryYearCount({required this.year, required this.count});

  final int year;
  final int count;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryYearCount && other.year == year && other.count == count;

  @override
  int get hashCode => Object.hash(year, count);
}

/// İmleçle sayfalanmış anı listesi: anı tarihine göre en yeni önce.
final class MemoryPage {
  const MemoryPage({
    required this.items,
    required this.total,
    this.nextCursor,
    this.years,
  });

  static const MemoryPage empty = MemoryPage(items: [], total: 0);

  final List<Memory> items;

  /// Filtreye uyan görünür anıların toplamı (tüm sayfalar).
  final int total;

  /// Yıllara göre anı sayıları, en yeni yıl önce. Tarih filtresinden
  /// bağımsızdır; yalnızca istendiğinde (ilk sayfa) gelir.
  final List<MemoryYearCount>? years;

  /// Sonraki sayfanın opak imleci; son sayfada `null`.
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryPage &&
          elementsEqual(other.items, items) &&
          other.total == total &&
          other.nextCursor == nextCursor &&
          elementsEqual(other.years ?? const [], years ?? const []);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(items),
    total,
    nextCursor,
    Object.hashAll(years ?? const []),
  );
}
