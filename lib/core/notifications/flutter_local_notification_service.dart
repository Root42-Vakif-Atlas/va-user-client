import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vakif_atlas/core/network/network_constants.dart';
import 'package:vakif_atlas/core/notifications/local_notification_service.dart';
import 'package:vakif_atlas/core/observability/app_logger.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';
import 'package:vakif_atlas/core/theme/tokens/app_colors.dart';

/// `flutter_local_notifications` ile yerel bildirimler (Android, iOS,
/// macOS).
///
/// Görsel nesne deposundan indirilir, küçültülür ve JPEG'e çevrilir: iOS
/// eklentileri yalnızca JPEG/PNG/GIF kabul eder, Android'e küçük bir bit
/// eşlem gönderilir. Görsel alınamazsa bildirim görselsiz gösterilir.
@LazySingleton(as: LocalNotificationService)
class FlutterLocalNotificationService implements LocalNotificationService {
  FlutterLocalNotificationService(
    @Named(DioNames.storage) this._storage,
    this._logger,
  ) : _plugin = FlutterLocalNotificationsPlugin();

  final Dio _storage;
  final AppLogger _logger;
  final FlutterLocalNotificationsPlugin _plugin;
  final StreamController<String> _taps = StreamController<String>.broadcast();

  Future<bool>? _initialization;

  /// Android durum çubuğu simgesi (tek renkli; `res/drawable`).
  static const String smallIcon = 'ic_stat_vakif_atlas';

  /// Görselin uzun kenarı (piksel). Android büyük simgesi ve iOS küçük
  /// resmi için fazlasıyla yeterli.
  static const int imageMaxDimension = 512;

  /// Bu boyuttan büyük görsel indirilmez.
  static const int imageMaxBytes = 3 * 1024 * 1024;
  static const Duration imageTimeout = Duration(seconds: 8);

  @override
  bool get isSupported =>
      !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || _isDarwin);

  /// iOS ve macOS aynı (`UserNotifications`) ayarları ve ayrıntıları
  /// kullanır.
  static bool get _isDarwin =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  @override
  Future<void> initialize() => _ensureInitialized();

  Future<bool> _ensureInitialized() {
    if (!isSupported) {
      return Future.value(false);
    }
    return _initialization ??= _initialize();
  }

  Future<bool> _initialize() async {
    try {
      // İzin burada istenmez; ilgili ayar açılırken istenir.
      const darwin = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings(smallIcon),
          iOS: darwin,
          macOS: darwin,
        ),
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload;
          if (payload != null && payload.isNotEmpty) {
            _taps.add(payload);
          }
        },
      );
      return true;
    } on Object catch (error) {
      _logger.warning(
        'notifications.initialize',
        context: {'error': error.runtimeType.toString()},
      );
      return false;
    }
  }

  @override
  Future<PermissionAccess> checkPermission() => _permission(request: false);

  @override
  Future<PermissionAccess> requestPermission() => _permission(request: true);

  Future<PermissionAccess> _permission({required bool request}) async {
    if (!await _ensureInitialized()) {
      return PermissionAccess.unsupported;
    }
    try {
      final bool? enabled;
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        enabled = request
            ? await android?.requestNotificationsPermission()
            : await android?.areNotificationsEnabled();
      } else if (defaultTargetPlatform == TargetPlatform.macOS) {
        final macOS = _plugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >();
        enabled = request
            ? await macOS?.requestPermissions(alert: true, sound: true)
            : (await macOS?.checkPermissions())?.isEnabled;
      } else {
        final ios = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        enabled = request
            ? await ios?.requestPermissions(alert: true, sound: true)
            : (await ios?.checkPermissions())?.isEnabled;
      }
      return switch (enabled) {
        true => PermissionAccess.granted,
        false => PermissionAccess.denied,
        null => PermissionAccess.unsupported,
      };
    } on Object catch (error) {
      _logger.warning(
        'notifications.permission',
        context: {'error': error.runtimeType.toString()},
      );
      return PermissionAccess.unsupported;
    }
  }

  @override
  Future<bool> openSettings() async {
    if (!await _ensureInitialized()) {
      return false;
    }
    try {
      return await _plugin.openAppNotificationSettings() ?? false;
    } on Object {
      return false;
    }
  }

  @override
  Stream<String> get taps => _taps.stream;

  bool _launchPayloadTaken = false;

  @override
  Future<String?> takeLaunchPayload() async {
    if (_launchPayloadTaken || !await _ensureInitialized()) {
      return null;
    }
    _launchPayloadTaken = true;
    try {
      final details = await _plugin.getNotificationAppLaunchDetails();
      if (details == null || !details.didNotificationLaunchApp) {
        return null;
      }
      final payload = details.notificationResponse?.payload;
      return payload == null || payload.isEmpty ? null : payload;
    } on Object {
      return null;
    }
  }

  @override
  Future<void> show(AppNotification notification) async {
    if (!await _ensureInitialized()) {
      return;
    }
    try {
      final image = await _loadImage(notification.imageUrl);
      // Ek dosyası sisteme taşındığından iOS ve macOS için ayrı üretilmez;
      // yalnızca çalışılan platformunki kurulur.
      final darwin = _isDarwin ? await _darwin(notification, image) : null;
      final details = NotificationDetails(
        android: _android(notification, image),
        iOS: darwin,
        macOS: darwin,
      );
      await _plugin.show(
        id: notification.id,
        title: notification.title,
        // iOS / macOS daraltılmış görünümde birkaç satır gösterir; Android
        // tek satır gösterir, uzun metin genişletilmiş görünümdedir.
        body: _isDarwin
            ? notification.expandedBody ?? notification.body
            : notification.body,
        notificationDetails: details,
        payload: notification.payload,
      );
    } on Object catch (error) {
      _logger.warning(
        'notifications.show',
        context: {'error': error.runtimeType.toString()},
      );
    }
  }

  AndroidNotificationDetails _android(
    AppNotification notification,
    Uint8List? image,
  ) {
    final expanded = notification.expandedBody ?? notification.body;
    return AndroidNotificationDetails(
      _channelId(notification.channel),
      notification.channelName,
      channelDescription: notification.channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.recommendation,
      // Kilit ekranında içerik gizlenir: eser adı kullanıcının nerede
      // olduğunu açığa çıkarır (KVKK).
      visibility: NotificationVisibility.private,
      groupKey: _channelId(notification.channel),
      subText: notification.subtitle,
      color: AppColors.darkGreen,
      largeIcon: image == null ? null : ByteArrayAndroidBitmap(image),
      styleInformation: BigTextStyleInformation(
        expanded,
        contentTitle: notification.title,
      ),
      timeoutAfter: notification.timeout?.inMilliseconds,
      ticker: notification.title,
    );
  }

  Future<DarwinNotificationDetails> _darwin(
    AppNotification notification,
    Uint8List? image,
  ) async {
    final attachment = image == null
        ? null
        : await _attachmentFile(notification.id, image);
    return DarwinNotificationDetails(
      subtitle: notification.subtitle,
      threadIdentifier: _channelId(notification.channel),
      interruptionLevel: InterruptionLevel.active,
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentSound: true,
      attachments: [
        if (attachment != null) DarwinNotificationAttachment(attachment),
      ],
    );
  }

  static String _channelId(AppNotificationChannel channel) => switch (channel) {
    AppNotificationChannel.nearbyMonuments => 'nearby_monuments',
  };

  /// iOS eki sisteme taşır (dosya silinir); her bildirim için yeni dosya.
  Future<String?> _attachmentFile(int id, Uint8List bytes) async {
    try {
      final directory = await getTemporaryDirectory();
      final stamp = DateTime.now().microsecondsSinceEpoch;
      final file = File('${directory.path}/notification_${id}_$stamp.jpg');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } on Object {
      return null;
    }
  }

  Future<Uint8List?> _loadImage(String? url) async {
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri == null || !(uri.isScheme('https') || uri.isScheme('http'))) {
      return null;
    }
    try {
      final response = await _storage.getUri<List<int>>(
        uri,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: imageTimeout,
          sendTimeout: imageTimeout,
        ),
      );
      final data = response.data;
      if (data == null || data.isEmpty || data.length > imageMaxBytes) {
        return null;
      }
      return await compute(
        normalizeNotificationImage,
        Uint8List.fromList(data),
      );
    } on Object catch (error) {
      _logger.debug('notifications.image: ${error.runtimeType}');
      return null;
    }
  }
}

/// Görseli en çok [FlutterLocalNotificationService.imageMaxDimension]
/// piksele küçültüp JPEG'e çevirir; çözülemezse `null`. Ayrı isolate'te
/// çalışır.
Uint8List? normalizeNotificationImage(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    return null;
  }
  const maxDimension = FlutterLocalNotificationService.imageMaxDimension;
  final resized = decoded.width > maxDimension || decoded.height > maxDimension
      ? img.copyResize(
          decoded,
          width: decoded.width >= decoded.height ? maxDimension : null,
          height: decoded.height > decoded.width ? maxDimension : null,
          interpolation: img.Interpolation.average,
        )
      : decoded;
  return img.encodeJpg(resized, quality: 82);
}
