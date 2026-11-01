import 'package:vakif_atlas/core/error/failures.dart';
import 'package:vakif_atlas/core/utils/either.dart';

/// Repository ve UseCase'lerin senkron sonuç tipi.
typedef Result<T> = Either<Failure, T>;

/// Repository ve UseCase'lerin asenkron sonuç tipi.
typedef ResultFuture<T> = Future<Either<Failure, T>>;
