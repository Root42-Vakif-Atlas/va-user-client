import 'package:vakif_atlas/core/utils/list_equality.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';

/// Yanıtın dayandığı veya yönlendirdiği eser (sunucunun kataloğundan).
final class GuideMonumentRef {
  const GuideMonumentRef({required this.id, required this.name, this.city});

  final String id;

  /// İçerik dilindeki eser adı.
  final String name;
  final String? city;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuideMonumentRef &&
          other.id == id &&
          other.name == name &&
          other.city == city;

  @override
  int get hashCode => Object.hash(id, name, city);

  @override
  String toString() => 'GuideMonumentRef($id)';
}

/// Rehberin açabileceği uygulama bölümleri. Rehber yalnızca bu izinli
/// listedeki ekranlara yönlendirir; sunucudan serbest adres kabul edilmez.
enum GuideDestination {
  map,
  routePlanner,
  routeBuilder,
  civilProtection,
  settings,
  accessibility,
}

/// Yanıtın altında gösterilen, kullanıcının dokunarak çalıştırdığı eylem.
///
/// Eylemler kendiliğinden çalışmaz; buton etiketleri istemcide
/// yerelleştirilir (sunucu metni buton olarak gösterilmez).
sealed class GuideAction {
  const GuideAction();
}

/// Eser detayını açar.
final class GuideOpenMonument extends GuideAction {
  const GuideOpenMonument(this.monument);

  final GuideMonumentRef monument;

  @override
  bool operator ==(Object other) =>
      other is GuideOpenMonument && other.monument == monument;

  @override
  int get hashCode => Object.hash(GuideOpenMonument, monument);
}

/// Haritayı eser seçili açar.
final class GuideShowOnMap extends GuideAction {
  const GuideShowOnMap(this.monument);

  final GuideMonumentRef monument;

  @override
  bool operator ==(Object other) =>
      other is GuideShowOnMap && other.monument == monument;

  @override
  int get hashCode => Object.hash(GuideShowOnMap, monument);
}

/// Eserin Anı Köşesi'ni açar.
final class GuideOpenMemories extends GuideAction {
  const GuideOpenMemories(this.monument);

  final GuideMonumentRef monument;

  @override
  bool operator ==(Object other) =>
      other is GuideOpenMemories && other.monument == monument;

  @override
  int get hashCode => Object.hash(GuideOpenMemories, monument);
}

/// Hasar bildirimi formunu açar; [monument] verilirse eser seçilidir.
final class GuideReportDamage extends GuideAction {
  const GuideReportDamage([this.monument]);

  final GuideMonumentRef? monument;

  @override
  bool operator ==(Object other) =>
      other is GuideReportDamage && other.monument == monument;

  @override
  int get hashCode => Object.hash(GuideReportDamage, monument);
}

/// Eser aramasını [query] ile açar.
final class GuideSearchMonuments extends GuideAction {
  const GuideSearchMonuments(this.query, {required this.total});

  final MonumentSearchQuery query;

  /// Sorguya uyan eser sayısı (buton etiketi).
  final int total;

  @override
  bool operator ==(Object other) =>
      other is GuideSearchMonuments &&
      other.query == query &&
      other.total == total;

  @override
  int get hashCode => Object.hash(GuideSearchMonuments, query, total);
}

/// Uygulamanın bir bölümünü açar.
final class GuideOpenSection extends GuideAction {
  const GuideOpenSection(this.destination);

  final GuideDestination destination;

  @override
  bool operator ==(Object other) =>
      other is GuideOpenSection && other.destination == destination;

  @override
  int get hashCode => Object.hash(GuideOpenSection, destination);
}

/// Yanıtla birlikte gösterilen uyarı.
enum GuideNotice {
  /// Can güvenliği: önce 112 aranmalıdır.
  emergency,
}

/// Rehberin bir yanıtı.
final class GuideMessage {
  const GuideMessage({
    required this.id,
    required this.text,
    required this.createdAt,
    this.sources = const [],
    this.actions = const [],
    this.suggestions = const [],
    this.notice,
  });

  final String id;

  /// Düz metin (Markdown yok); içerik dilinde.
  final String text;
  final DateTime createdAt;

  /// Yanıtın dayandığı katalog kayıtları (kaynak gösterimi).
  final List<GuideMonumentRef> sources;
  final List<GuideAction> actions;

  /// Kullanıcının dokunarak sorabileceği devam soruları.
  final List<String> suggestions;
  final GuideNotice? notice;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuideMessage &&
          other.id == id &&
          other.text == text &&
          other.createdAt == createdAt &&
          elementsEqual(other.sources, sources) &&
          elementsEqual(other.actions, actions) &&
          elementsEqual(other.suggestions, suggestions) &&
          other.notice == notice;

  @override
  int get hashCode => Object.hash(
    id,
    text,
    createdAt,
    Object.hashAll(sources),
    Object.hashAll(actions),
    Object.hashAll(suggestions),
    notice,
  );

  /// Yanıt metni kullanıcı içeriği barındırabilir; loglara yazılmaz.
  @override
  String toString() => 'GuideMessage($id, ${text.length} chars)';
}

/// Sunucunun bir soruya yanıtı; [conversationId] sonraki sorularda
/// gönderilir (bağlamı korumak için).
final class GuideReply {
  const GuideReply({required this.conversationId, required this.message});

  final String conversationId;
  final GuideMessage message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuideReply &&
          other.conversationId == conversationId &&
          other.message == message;

  @override
  int get hashCode => Object.hash(conversationId, message);
}

/// Soru doğrulama sonucu.
enum GuideQuestionIssue { empty, tooLong }

abstract final class GuideRules {
  /// Sunucunun kabul ettiği en uzun soru (karakter).
  static const int maxQuestionLength = 500;

  /// Bu uzunluktan sonra kalan karakter sayacı gösterilir.
  static const int counterThreshold = 400;

  static GuideQuestionIssue? validate(String question) {
    final length = question.trim().runes.length;
    if (length == 0) {
      return GuideQuestionIssue.empty;
    }
    if (length > maxQuestionLength) {
      return GuideQuestionIssue.tooLong;
    }
    return null;
  }
}
