import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/media/photo_draft.dart';
import 'package:vakif_atlas/core/media/photo_picker_service.dart';
import 'package:vakif_atlas/core/media/photo_processor.dart';
import 'package:vakif_atlas/core/permissions/permission_service.dart';

/// Fotoğraf eklerken kullanıcıya gösterilecek bilgi.
enum PhotoNoticeKind {
  cameraDenied,
  galleryDenied,
  pickFailed,

  /// Bazı dosyalar çözümlenemedi (desteklenmeyen biçim / bozuk).
  unsupported,

  /// Seçilenler kalan haktan fazlaydı; fazlası eklenmedi.
  limitReached,
}

@immutable
final class PhotoNotice {
  const PhotoNotice(this.kind, {this.count = 0});

  final PhotoNoticeKind kind;
  final int count;

  bool get isPermissionDenied =>
      kind == PhotoNoticeKind.cameraDenied ||
      kind == PhotoNoticeKind.galleryDenied;
}

/// Formlara (Anı Köşesi, Sivil Koruma) fotoğraf ekleme akışı: seçim →
/// cihazda küçültme ve meta veri temizliği → [PhotoDraft].
///
/// Hazırlanan her fotoğraf geldiği anda bildirilir; böylece form
/// "hazırlanıyor" yer tutucularını tek tek gerçek fotoğraflarla değiştirir.
///
/// Kamera izni çekimden önce [PermissionService] ile denetlenir: henüz
/// sorulmadıysa sistem penceresi açılır, kalıcı olarak reddedildiyse kamera
/// hiç açılmadan ayarlara yönlendiren bildirim döner. Galeri sistem
/// seçicisini kullandığından izin istemez.
@injectable
class PhotoAttacher {
  PhotoAttacher(this._picker, this._processor, this._permissions);

  final PhotoPickerService _picker;
  final PhotoProcessor _processor;
  final PermissionService _permissions;

  int _sequence = 0;

  bool get supportsCamera => _picker.supportsCamera;

  /// İzin reddedildiğinde uygulama ayarları açılabilir mi (web'de hayır).
  bool get canOpenAppSettings => _permissions.canOpenAppSettings;

  /// İzin reddedildiğinde uygulama ayarlarını açar.
  Future<bool> openAppSettings() => _permissions.openAppSettings();

  /// En fazla [remaining] fotoğraf ekler.
  ///
  /// - [onProcessing]: hazırlanmaya başlanan fotoğraf sayısı.
  /// - [onProcessed]: her fotoğraf hazır olunca (çözümlenemezse `null`).
  ///
  /// Kullanıcıya gösterilecek bir durum varsa (izin reddi, hata,
  /// desteklenmeyen dosya, sınır) onu döndürür.
  Future<PhotoNotice?> attach(
    PhotoSource source, {
    required int remaining,
    required int maxBytes,
    required void Function(int count) onProcessing,
    required void Function(PhotoDraft? photo) onProcessed,
  }) async {
    if (remaining <= 0) {
      return const PhotoNotice(PhotoNoticeKind.limitReached);
    }
    if (source == PhotoSource.camera && !await _cameraAllowed()) {
      return const PhotoNotice(PhotoNoticeKind.cameraDenied);
    }
    final result = await _picker.pick(source, limit: remaining);
    final List<Uint8List> picked;
    switch (result) {
      case PhotoAccessDenied(:final source):
        return PhotoNotice(
          source == PhotoSource.camera
              ? PhotoNoticeKind.cameraDenied
              : PhotoNoticeKind.galleryDenied,
        );
      case PhotoPickFailed():
        return const PhotoNotice(PhotoNoticeKind.pickFailed);
      case PhotosPicked(:final photos):
        picked = photos;
    }
    if (picked.isEmpty) {
      return null;
    }
    // Bazı platformlar seçim sınırını uygulamaz.
    final accepted = picked.take(remaining).toList();
    final trimmed = picked.length - accepted.length;
    onProcessing(accepted.length);
    var unsupported = 0;
    for (final bytes in accepted) {
      final processed = await _processor.process(bytes);
      if (processed == null || processed.bytes.length > maxBytes) {
        unsupported++;
        onProcessed(null);
        continue;
      }
      onProcessed(
        PhotoDraft(
          localId: 'photo_${++_sequence}',
          bytes: processed.bytes,
          width: processed.width,
          height: processed.height,
        ),
      );
    }
    if (unsupported > 0) {
      return PhotoNotice(PhotoNoticeKind.unsupported, count: unsupported);
    }
    if (trimmed > 0) {
      return PhotoNotice(PhotoNoticeKind.limitReached, count: trimmed);
    }
    return null;
  }

  Future<bool> _cameraAllowed() async {
    final access = switch (await _permissions.check(AppPermission.camera)) {
      PermissionAccess.denied => await _permissions.request(
        AppPermission.camera,
      ),
      final current => current,
    };
    // `unsupported`: durum okunamadı; seçicinin kendi izin akışına bırakılır.
    return access != PermissionAccess.denied &&
        access != PermissionAccess.deniedForever;
  }
}
