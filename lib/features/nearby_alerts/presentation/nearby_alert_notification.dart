import 'dart:math' as math;

import 'package:vakif_atlas/core/l10n/l10n.dart';
import 'package:vakif_atlas/core/l10n/measure_format.dart';
import 'package:vakif_atlas/core/location/location_service.dart';
import 'package:vakif_atlas/core/notifications/local_notification_service.dart';
import 'package:vakif_atlas/core/router/routes.dart';
import 'package:vakif_atlas/features/catalog/presentation/catalog_presentation.dart';
import 'package:vakif_atlas/features/nearby_alerts/domain/entities/nearby_alert.dart';

/// Yakınlık bildiriminin içeriği.
///
/// Bildirim tek bakışta okunur: başlık eserin adını ve "yakınındasınız"
/// bağlamını, alt başlık mesafe ve türü, gövde eserin kısa tanıtımını
/// taşır; görsel eserin küçük resmidir. Dokunulunca eser detayı açılır.
abstract final class NearbyAlertNotification {
  /// Kullanıcı uzaklaştıktan sonra bildirim anlamını yitirir (Android'de
  /// kendiliğinden kaldırılır).
  static const Duration timeout = Duration(hours: 2);

  /// Gövde metninin en uzun hali; genişletilmiş görünümde ~4–5 satır.
  static const int maxDescriptionLength = 220;

  static AppNotification build(
    NearbyAlert alert,
    AppLocalizations l10n, {
    required bool includeImage,
  }) {
    final monument = alert.monument;
    final description = _shorten(monument.shortDescription.trim());
    final body = description.isEmpty
        ? l10n.monumentLocation(monument.district, monument.city)
        : description;
    return AppNotification(
      id: notificationId(monument.id),
      channel: AppNotificationChannel.nearbyMonuments,
      channelName: l10n.nearbyAlertsChannelName,
      channelDescription: l10n.nearbyAlertsChannelDescription,
      title: l10n.nearbyAlertTitle(monument.name),
      subtitle: isDistancePrecise(alert)
          ? l10n.nearbyAlertSubtitle(
              l10n.distance(displayDistance(alert.distanceMeters)),
              monument.category.label(l10n),
            )
          : l10n.nearbyAlertSubtitleApproximate(monument.category.label(l10n)),
      body: body,
      expandedBody: '$body\n${l10n.nearbyAlertCallToAction}',
      imageUrl: includeImage ? monument.thumbnailUrl : null,
      payload: AppRoutes.monumentDetailPath(monument.id),
      timeout: timeout,
    );
  }

  /// Arka planda takip sürerken görünen bildirim (Android) metinleri.
  static BackgroundTracking tracking(AppLocalizations l10n) =>
      BackgroundTracking(
        title: l10n.nearbyAlertsTrackingTitle,
        text: l10n.nearbyAlertsTrackingText,
        channelName: l10n.nearbyAlertsTrackingChannel,
      );

  /// Bildirim yükünden açılacak rota; yalnızca eser detayı kabul edilir.
  static String? routeOf(String payload) {
    final uri = Uri.tryParse(payload);
    if (uri == null ||
        uri.hasScheme ||
        uri.hasAuthority ||
        uri.hasQuery ||
        uri.hasFragment ||
        uri.pathSegments.length != 2 ||
        uri.pathSegments.first != 'monument' ||
        uri.pathSegments.last.isEmpty ||
        !payload.startsWith('/monument/')) {
      return null;
    }
    return payload;
  }

  /// Bu doğruluktan kötüyse ("120 m uzakta" yanıltıcı olur) mesafe yerine
  /// "Yakınınızda" yazılır.
  static const double preciseAccuracyMeters = 100;

  static bool isDistancePrecise(NearbyAlert alert) =>
      alert.accuracyMeters <= preciseAccuracyMeters;

  /// GPS doğruluğundan daha kesin görünmesin diye 10 m'ye yuvarlanır.
  static int displayDistance(double meters) =>
      math.max(10, (meters / 10).round() * 10);

  /// Aynı eserin bildirimi öncekinin yerini alır. Oturumlar arasında aynı
  /// kalsın diye `String.hashCode` değil FNV-1a (31 bit) kullanılır.
  static int notificationId(String monumentId) {
    var hash = 0x811c9dc5;
    for (final unit in monumentId.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash & 0x7fffffff;
  }

  static String _shorten(String text) {
    if (text.length <= maxDescriptionLength) {
      return text;
    }
    final cut = text.substring(0, maxDescriptionLength);
    final lastSpace = cut.lastIndexOf(' ');
    final trimmed = lastSpace > maxDescriptionLength ~/ 2
        ? cut.substring(0, lastSpace)
        : cut;
    return '${trimmed.trimRight().replaceAll(RegExp(r'[,;:.\-–]+$'), '')}…';
  }
}
