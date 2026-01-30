import 'package:dartz/dartz.dart';
import 'package:bisnisku/core/errors/failure.dart';

/// Type definition for async operations that can fail
typedef FutureResult<T> = Future<Either<Failure, T>>;

/// Type definition for sync operations that can fail
typedef Result<T> = Either<Failure, T>;

/// Type definition for JSON objects
typedef Json = Map<String, dynamic>;

/// Type definition for JSON lists
typedef JsonList = List<Json>;
