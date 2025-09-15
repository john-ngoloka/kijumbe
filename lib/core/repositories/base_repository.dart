import 'package:dartz/dartz.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';
import '../utils/result.dart';

/// Base repository class that provides common error handling functionality
/// to avoid code duplication across repository implementations
abstract class BaseRepository {
  /// Handles common exceptions and converts them to appropriate failures
  Future<Result<T>> handleException<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    try {
      final result = await operation();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on AuthenticationException catch (e) {
      return Left(
        AuthenticationFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      final message = operationName != null
          ? 'Failed to $operationName: ${e.toString()}'
          : e.toString();
      return Left(UnknownFailure(message: message));
    }
  }

  /// Handles void operations with common exception handling
  Future<ResultVoid> handleVoidException(
    Future<void> Function() operation, {
    String? operationName,
  }) async {
    try {
      await operation();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on AuthenticationException catch (e) {
      return Left(
        AuthenticationFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      final message = operationName != null
          ? 'Failed to $operationName: ${e.toString()}'
          : e.toString();
      return Left(UnknownFailure(message: message));
    }
  }
}
