part of 'route_builder_bloc.dart';

@freezed
sealed class RouteBuilderEvent with _$RouteBuilderEvent {
  /// Oluşturucu açıldı veya arayüz dili değişti: durak eserlerinin bilgisi
  /// bu dilde çözülür (taslak korunur).
  const factory RouteBuilderEvent.started({required String languageCode}) =
      RouteBuilderStarted;

  /// Mevcut rotayı düzenlemek için yükler (durak eserleri rota yanıtındadır).
  const factory RouteBuilderEvent.editRequested({
    required String routeId,
    required String languageCode,
  }) = RouteBuilderEditRequested;

  /// Eser rotada değilse sona ekler, varsa çıkarır. [monument] arama
  /// sonucundan gelir; verilmezse (ör. eser detayından) bilgisi sunucudan
  /// çözülür.
  const factory RouteBuilderEvent.monumentToggled(
    String monumentId, {
    MonumentPin? monument,
  }) = RouteBuilderMonumentToggled;

  /// Bilgisi eksik durak eserlerini çözer (iç olay).
  const factory RouteBuilderEvent.monumentsResolveRequested() =
      RouteBuilderMonumentsResolveRequested;

  const factory RouteBuilderEvent.stopMoved({
    required int from,
    required int to,
  }) = RouteBuilderStopMoved;

  const factory RouteBuilderEvent.stopRemoved(int index) =
      RouteBuilderStopRemoved;

  const factory RouteBuilderEvent.visitChanged({
    required int index,
    required Duration visit,
  }) = RouteBuilderVisitChanged;

  const factory RouteBuilderEvent.breakAdded({
    required int stopIndex,
    required RouteBreakKind kind,
  }) = RouteBuilderBreakAdded;

  const factory RouteBuilderEvent.breakChanged({
    required int stopIndex,
    required int breakIndex,
    required Duration duration,
  }) = RouteBuilderBreakChanged;

  const factory RouteBuilderEvent.breakRemoved({
    required int stopIndex,
    required int breakIndex,
  }) = RouteBuilderBreakRemoved;

  const factory RouteBuilderEvent.nameChanged(String name) =
      RouteBuilderNameChanged;

  /// İlk durak sabitken kuş uçuşu en kısa sıra.
  const factory RouteBuilderEvent.orderOptimized() = RouteBuilderOrderOptimized;

  /// [fallbackName]: ad boşsa kullanılacak önerilen ad.
  const factory RouteBuilderEvent.submitted({
    required String languageCode,
    required String fallbackName,
  }) = RouteBuilderSubmitted;

  /// Kaydedilen taslağı temizler.
  const factory RouteBuilderEvent.reset() = RouteBuilderReset;
}
