import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/media/in_app_camera_launcher.dart';

enum PhotoSource { camera, gallery }

/// Fotoğraf seçiminin sonucu. Servis istisna fırlatmaz.
sealed class PhotoPickResult {
  const PhotoPickResult();
}

/// Seçilen fotoğrafların ham baytları; kullanıcı vazgeçtiyse boş.
final class PhotosPicked extends PhotoPickResult {
  const PhotosPicked(this.photos);

  final List<Uint8List> photos;
}

/// Kamera veya fotoğraf arşivi izni reddedildi.
final class PhotoAccessDenied extends PhotoPickResult {
  const PhotoAccessDenied(this.source);

  final PhotoSource source;
}

final class PhotoPickFailed extends PhotoPickResult {
  const PhotoPickFailed();
}

/// Kamera / galeriden fotoğraf seçimi.
///
/// Kamera izni `PhotoAttacher` tarafından çekimden önce denetlenir; galeri
/// sistem seçicisini kullanır ve izin istemez (bağlamsal izin,
/// MASVS-PRIVACY).
abstract interface class PhotoPickerService {
  /// Bu platformda kamerayla çekim yapılabilir mi (masaüstünde hayır).
  bool get supportsCamera;

  /// Galeriden en fazla [limit] fotoğraf; kamerada tek fotoğraf.
  Future<PhotoPickResult> pick(PhotoSource source, {required int limit});
}

/// Mobilde kamera sistemin kamera uygulamasıyla açılır. Web'de
/// `image_picker` kamerayı `<input capture>` ile ister; masaüstü tarayıcılar
/// bunu yok sayıp dosya seçicisi açtığından web'de kamera uygulama içi
/// kamera ekranıyla ([InAppCameraLauncher], `getUserMedia`) açılır.
@LazySingleton(as: PhotoPickerService)
class ImagePickerPhotoService implements PhotoPickerService {
  ImagePickerPhotoService(this._inAppCamera) : _picker = ImagePicker();

  final ImagePicker _picker;
  final InAppCameraLauncher _inAppCamera;

  /// Platform seçicisi bu boyuta indirir (asıl küçültme `PhotoProcessor`'da);
  /// iOS'ta kalite verilmesi HEIC'i JPEG'e dönüştürür.
  static const double _maxDimension = 2048;
  static const int _quality = 90;

  @override
  bool get supportsCamera => _picker.supportsImageSource(ImageSource.camera);

  @override
  Future<PhotoPickResult> pick(PhotoSource source, {required int limit}) async {
    if (kIsWeb && source == PhotoSource.camera) {
      final photo = await _inAppCamera.capture();
      return PhotosPicked([?photo]);
    }
    try {
      final files = switch (source) {
        PhotoSource.camera => [
          ?await _picker.pickImage(
            source: ImageSource.camera,
            maxWidth: _maxDimension,
            maxHeight: _maxDimension,
            imageQuality: _quality,
            requestFullMetadata: false,
          ),
        ],
        // Tek fotoğraf hakkı kaldığında çoklu seçici `limit: 1` kabul etmez.
        PhotoSource.gallery when limit == 1 => [
          ?await _picker.pickImage(
            source: ImageSource.gallery,
            maxWidth: _maxDimension,
            maxHeight: _maxDimension,
            imageQuality: _quality,
            requestFullMetadata: false,
          ),
        ],
        PhotoSource.gallery => await _picker.pickMultiImage(
          maxWidth: _maxDimension,
          maxHeight: _maxDimension,
          imageQuality: _quality,
          limit: limit,
          requestFullMetadata: false,
        ),
      };
      return PhotosPicked([
        for (final file in files.take(limit)) await file.readAsBytes(),
      ]);
    } on PlatformException catch (error) {
      return switch (error.code) {
        'camera_access_denied' => const PhotoAccessDenied(PhotoSource.camera),
        'photo_access_denied' => const PhotoAccessDenied(PhotoSource.gallery),
        _ => const PhotoPickFailed(),
      };
    } on Exception {
      return const PhotoPickFailed();
    }
  }
}
