import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:printing/printing.dart';

/// Belgeyi işletim sisteminin paylaşım ve yazdırma pencerelerine verir.
///
/// Dosya, uygulamanın özel deposundan çıkıp yalnızca kullanıcının seçtiği
/// hedefe (e-posta, mesaj, "Dosyalara kaydet", yazıcı) gider. Hatalar
/// fırlatılmaz; işlem açılamazsa `false` döner.
abstract interface class DocumentShareService {
  Future<bool> sharePdf({required Uint8List bytes, required String fileName});

  Future<bool> printPdf({required Uint8List bytes, required String name});
}

@LazySingleton(as: DocumentShareService)
class PrintingDocumentShareService implements DocumentShareService {
  @override
  Future<bool> sharePdf({
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      return await Printing.sharePdf(bytes: bytes, filename: fileName);
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<bool> printPdf({
    required Uint8List bytes,
    required String name,
  }) async {
    try {
      return await Printing.layoutPdf(onLayout: (_) async => bytes, name: name);
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
