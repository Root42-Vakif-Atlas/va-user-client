import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';

abstract interface class LegalDocumentRepository {
  /// [languageCode] diliyle güncel sürümü getirir.
  ResultFuture<LegalDocument> getDocument(
    LegalDocumentType type, {
    required String languageCode,
  });
}
