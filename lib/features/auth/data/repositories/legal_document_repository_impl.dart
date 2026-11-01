import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/error/error_mapper.dart';
import 'package:vakif_atlas/core/utils/either.dart';
import 'package:vakif_atlas/core/utils/typedefs.dart';
import 'package:vakif_atlas/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:vakif_atlas/features/auth/domain/entities/legal_document.dart';
import 'package:vakif_atlas/features/auth/domain/repositories/legal_document_repository.dart';

@LazySingleton(as: LegalDocumentRepository)
class LegalDocumentRepositoryImpl implements LegalDocumentRepository {
  LegalDocumentRepositoryImpl(this._remote);

  final LegalDocumentRemoteDataSource _remote;

  @override
  ResultFuture<LegalDocument> getDocument(
    LegalDocumentType type, {
    required String languageCode,
  }) async {
    try {
      final dto = await _remote.fetch(type, languageCode: languageCode);
      return Right(dto.toDomain(type));
    } on Exception catch (error) {
      return Left(ErrorMapper.toFailure(error));
    }
  }
}
