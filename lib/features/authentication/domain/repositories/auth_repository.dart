import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokens>> signup({
    required String phone,
    required String password,
    required String name,
  });

  Future<Either<Failure, AuthTokens>> login({
    required String phone,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, AuthTokens>> refreshToken();

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, bool>> isLoggedIn();

  Future<Either<Failure, void>> saveUserData(User user);

  Future<Either<Failure, User?>> getCachedUser();

  Future<Either<Failure, void>> clearUserData();
}
