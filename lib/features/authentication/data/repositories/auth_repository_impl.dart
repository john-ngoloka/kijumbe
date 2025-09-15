import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Result<AuthTokens>> login({
    required String phone,
    required String password,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final tokensModel = await _remoteDataSource.login(
          phone: phone,
          password: password,
        );

        // Save tokens locally
        await _localDataSource.saveAuthTokens(tokensModel);
        await _localDataSource.setLoggedIn(true);

        return Right(tokensModel.toEntity());
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message, statusCode: e.statusCode),
        );
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        return Left(
          AuthenticationFailure(message: e.message, statusCode: e.statusCode),
        );
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<ResultVoid> logout() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.logout();
      } catch (e) {
        // Continue with local logout even if remote logout fails
      }
    }

    try {
      await _localDataSource.clearAuthTokens();
      await _localDataSource.clearUserData();
      await _localDataSource.setLoggedIn(false);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<AuthTokens>> refreshToken() async {
    try {
      final tokensModel = await _localDataSource.getAuthTokens();
      if (tokensModel == null) {
        return const Left(
          AuthenticationFailure(message: 'No refresh token found'),
        );
      }

      if (await _networkInfo.isConnected) {
        try {
          final newTokensModel = await _remoteDataSource.refreshToken(
            tokensModel.refreshToken,
          );

          await _localDataSource.saveAuthTokens(newTokensModel);
          return Right(newTokensModel.toEntity());
        } on ServerException catch (e) {
          return Left(
            ServerFailure(message: e.message, statusCode: e.statusCode),
          );
        } on NetworkException catch (e) {
          return Left(NetworkFailure(message: e.message));
        } on AuthenticationException catch (e) {
          return Left(
            AuthenticationFailure(message: e.message, statusCode: e.statusCode),
          );
        }
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final userModel = await _remoteDataSource.getCurrentUser();
        await _localDataSource.saveUserData(userModel);
        return Right(userModel.toEntity());
      } on ServerException catch (e) {
        return Left(
          ServerFailure(message: e.message, statusCode: e.statusCode),
        );
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        return Left(
          AuthenticationFailure(message: e.message, statusCode: e.statusCode),
        );
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      // Return cached user if no network
      try {
        final cachedUserModel = await _localDataSource.getCachedUser();
        if (cachedUserModel != null) {
          return Right(cachedUserModel.toEntity());
        } else {
          return const Left(CacheFailure(message: 'No cached user data'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Result<bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await _localDataSource.isLoggedIn();
      final tokens = await _localDataSource.getAuthTokens();

      if (isLoggedIn && tokens != null) {
        // Check if token is expired
        final tokensEntity = tokens.toEntity();
        if (tokensEntity.isExpired) {
          // Try to refresh token
          final refreshResult = await refreshToken();
          return refreshResult.fold(
            (failure) => const Right(false),
            (newTokens) => const Right(true),
          );
        }
        return const Right(true);
      }
      return const Right(false);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<ResultVoid> saveUserData(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await _localDataSource.saveUserData(userModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<User?>> getCachedUser() async {
    try {
      final cachedUserModel = await _localDataSource.getCachedUser();
      return Right(cachedUserModel?.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<ResultVoid> clearUserData() async {
    try {
      await _localDataSource.clearUserData();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
