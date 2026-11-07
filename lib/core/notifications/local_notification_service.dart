import 'package:flutter/foundation.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';

/// Uygulamanın bildirim kanalları. Her kanal sistem ayarlarında ayrı
/// açılıp kapatılabilir (Android) ve ayrı bir iş parçacığında toplanır
/// (iOS).
enum AppNotificationChannel {
  /// Kullanıcı bir vakıf eserinin yakınındayken.
  nearbyMonuments,
}

/// Cihazda üretilen (yerel) zengin bildirim.
@immutable
final class AppNotification {
  const AppNotification({
    required this.id,
    required this.channel,
    required this.channelName,
    required this.channelDescription,
    required this.title,
    required this.body,
    required this.payload,
    this.subtitle,
    this.expandedBody,
    this.imageUrl,
    this.timeout,
  });

  /// Aynı kimlikle gösterilen bildirim öncekinin yerini alır.
  final int id;
  final AppNotificationChannel channel;

  /// Sistem ayarlarında görünen kanal adı ve açıklaması (Android).
  final String channelName;
  final String channelDescription;

  final String title;

  /// Daraltılmış görünümdeki tek satır.
  final String body;

  /// Başlığın altındaki kısa bağlam (iOS alt başlık, Android üst bilgi).
  final String? subtitle;

  /// Genişletilmiş görünümdeki uzun metin; `null` → [body].
  final String? expandedBody;

  /// Küçük görsel (Android büyük simge, iOS ek). İndirilemezse bildirim
  /// görselsiz gösterilir.
  final String? imageUrl;

  /// Bildirime dokunulunca uygulamaya iletilen değer (ör. rota yolu).
  final String payload;

  /// Bilgi bu süreden sonra güncelliğini yitirir; bildirim kendiliğinden
  /// kaldırılır (Android).
  final Duration? timeout;

  @override
  String toString() => 'AppNotification($id, ${channel.name})';
}

/// Yerel bildirimlerin gösterimi, izni ve dokunma olayları.
///
/// İzin yalnızca kullanıcının açık bir eylemiyle istenir (ilgili ayarı
/// açması); uygulama açılışında sorulmaz. Implementasyonlar istisna
/// fırlatmaz.
abstract interface class LocalNotificationService {
  /// `false` → platformda yerel bildirim yoktur; ilgili ayarlar gizlenir.
  bool get isSupported;

  /// Eklentiyi hazırlar; izin istemez. Birden çok kez çağrılabilir.
  Future<void> initialize();

  /// İzin istemeden mevcut durumu okur.
  Future<PermissionAccess> checkPermission();

  /// Gerekirse sistem izin penceresini açar.
  Future<PermissionAccess> requestPermission();

  /// Uygulamanın sistem bildirim ayarlarını açar.
  Future<bool> openSettings();

  Future<void> show(AppNotification notification);

  /// Uygulama çalışırken dokunulan bildirimlerin [AppNotification.payload]
  /// değerleri.
  Stream<String> get taps;

  /// Uygulama bir bildirime dokunularak açıldıysa o bildirimin
  /// [AppNotification.payload] değeri; bir kez döner.
  Future<String?> takeLaunchPayload();
}
