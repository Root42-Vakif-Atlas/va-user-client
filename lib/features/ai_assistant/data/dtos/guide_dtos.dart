import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vakif_atlas/features/ai_assistant/domain/entities/guide_message.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_classification.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_filter.dart';
import 'package:vakif_atlas/features/catalog/domain/entities/monument_search.dart';

part 'guide_dtos.freezed.dart';
part 'guide_dtos.g.dart';

@freezed
abstract class AskGuideRequestDto with _$AskGuideRequestDto {
  const factory AskGuideRequestDto({
    required String message,
    @JsonKey(includeIfNull: false) String? conversationId,
  }) = _AskGuideRequestDto;

  factory AskGuideRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AskGuideRequestDtoFromJson(json);
}

@freezed
abstract class GuideReplyDto with _$GuideReplyDto {
  const factory GuideReplyDto({
    required String conversationId,
    required GuideMessageDto message,
  }) = _GuideReplyDto;

  const GuideReplyDto._();

  factory GuideReplyDto.fromJson(Map<String, dynamic> json) =>
      _$GuideReplyDtoFromJson(json);

  GuideReply toDomain() =>
      GuideReply(conversationId: conversationId, message: message.toDomain());
}

@freezed
abstract class GuideMessageDto with _$GuideMessageDto {
  const factory GuideMessageDto({
    required String id,
    required String text,
    required DateTime createdAt,
    @Default(<GuideSourceDto>[]) List<GuideSourceDto> sources,
    @Default(<GuideActionDto>[]) List<GuideActionDto> actions,
    @Default(<String>[]) List<String> suggestions,
    String? notice,
  }) = _GuideMessageDto;

  const GuideMessageDto._();

  factory GuideMessageDto.fromJson(Map<String, dynamic> json) =>
      _$GuideMessageDtoFromJson(json);

  /// Tanınmayan eylem ve uyarı türleri atlanır (sunucu yeni tür eklese de
  /// istemci çalışır). Boş öneriler gösterilmez.
  GuideMessage toDomain() => GuideMessage(
    id: id,
    text: text.trim(),
    createdAt: createdAt,
    sources: [for (final source in sources) source.toDomain()],
    actions: [
      for (final action in actions)
        if (action.toDomain() case final GuideAction parsed) parsed,
    ],
    suggestions: [
      for (final suggestion in suggestions)
        if (suggestion.trim().isNotEmpty) suggestion.trim(),
    ],
    notice: GuideNotice.values.where((n) => n.name == notice).firstOrNull,
  );
}

@freezed
abstract class GuideSourceDto with _$GuideSourceDto {
  const factory GuideSourceDto({
    required String monumentId,
    required String name,
    String? city,
  }) = _GuideSourceDto;

  const GuideSourceDto._();

  factory GuideSourceDto.fromJson(Map<String, dynamic> json) =>
      _$GuideSourceDtoFromJson(json);

  GuideMonumentRef toDomain() =>
      GuideMonumentRef(id: monumentId, name: name, city: city);
}

/// Eylem: `type` ile ayırt edilen düz nesne
/// (`docs/api-contracts.md` → Dijital Rehber).
@freezed
abstract class GuideActionDto with _$GuideActionDto {
  const factory GuideActionDto({
    required String type,
    String? monumentId,
    String? monumentName,
    String? destination,
    String? q,
    @Default(<String>[]) List<String> categories,
    @Default(<String>[]) List<String> periods,
    @Default(<String>[]) List<String> cities,
    int? total,
  }) = _GuideActionDto;

  const GuideActionDto._();

  factory GuideActionDto.fromJson(Map<String, dynamic> json) =>
      _$GuideActionDtoFromJson(json);

  static const String openMonument = 'openMonument';
  static const String showOnMap = 'showOnMap';
  static const String openMemories = 'openMemories';
  static const String reportDamage = 'reportDamage';
  static const String searchMonuments = 'searchMonuments';
  static const String openSection = 'openSection';

  /// Bilinmeyen tür veya eksik alan → `null`.
  GuideAction? toDomain() {
    final monument = _monument;
    return switch (type) {
      openMonument when monument != null => GuideOpenMonument(monument),
      showOnMap when monument != null => GuideShowOnMap(monument),
      openMemories when monument != null => GuideOpenMemories(monument),
      reportDamage => GuideReportDamage(monument),
      searchMonuments => GuideSearchMonuments(
        MonumentSearchQuery(
          text: q ?? '',
          filter: MonumentFilter(
            categories: _parse(categories, MonumentCategory.values),
            periods: _parse(periods, HistoricalPeriod.values),
            // Katalog il süzgeci plaka koduyla çalışır; kod olmayan değer
            // (eski sürümün il adı) uygulanamaz ve atlanır.
            cities: {for (final city in cities) ?int.tryParse(city.trim())},
          ),
        ),
        total: total ?? 0,
      ),
      openSection => switch (GuideDestination.values
          .where((value) => value.name == destination)
          .firstOrNull) {
        final GuideDestination value => GuideOpenSection(value),
        null => null,
      },
      _ => null,
    };
  }

  GuideMonumentRef? get _monument {
    final id = monumentId?.trim();
    final name = monumentName?.trim();
    if (id == null || id.isEmpty || name == null || name.isEmpty) {
      return null;
    }
    return GuideMonumentRef(id: id, name: name);
  }

  static Set<T> _parse<T extends Enum>(List<String> names, List<T> values) => {
    for (final name in names)
      if (values.where((value) => value.name == name).firstOrNull
          case final T value)
        value,
  };
}
