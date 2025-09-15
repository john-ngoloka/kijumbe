import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/repositories/base_repository.dart';
import '../../../../core/services/jwt_service.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthLocalDataSource _localDataSource;
  final JWTService _jwtService;

  AuthRepositoryImpl(this._localDataSource, this._jwtService);

  @override
  Future<Either<Failure, AuthTokens>> signup({
    required String phone,
    required String password,
    required String name,
  }) async {
    final result = await handleException(() async {
      // Check if user already exists
      final userExists = await _localDataSource.userExists(phone);
      if (userExists) {
        throw AuthenticationException(
          message: 'User with this phone number already exists',
          statusCode: 409,
        );
      }

      // Create new user
      final userId = _jwtService.generateUserId();
      final userModel = UserModel(
        id: userId.toString(),
        phone: phone,
        email: null,
        firstName: name.split(' ').first,
        lastName: name.split(' ').length > 1
            ? name.split(' ').skip(1).join(' ')
            : '',
        profileImage: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );

      // Save user to Isar database
      final createdUser = await _localDataSource.createUser(userModel);

      // Generate JWT tokens
      final accessToken = _jwtService.generateAccessToken(
        userId: userId,
        phone: phone,
        name: name,
      );
      final refreshToken = _jwtService.generateRefreshToken(
        userId: userId,
        phone: phone,
      );

      final tokensModel = AuthTokensModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: 3600, // 1 hour
      );

      // Save tokens and user data locally
      await _localDataSource.saveAuthTokens(tokensModel);
      await _localDataSource.saveUserData(createdUser);
      await _localDataSource.setLoggedIn(true);

      return tokensModel.toEntity();
    }, operationName: 'signup');

    return result.fold((failure) => Left(failure), (tokens) => Right(tokens));
  }

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String phone,
    required String password,
  }) async {
    final result = await handleException(() async {
      // Get user from local database
      final userModel = await _localDataSource.getUserByPhone(phone);
      if (userModel == null) {
        throw AuthenticationException(
          message: 'User not found. Please signup first.',
          statusCode: 404,
        );
      }

      // In a real app, you would verify the password hash here
      // For simulation, we'll just check if password is not empty
      if (password.isEmpty) {
        throw AuthenticationException(
          message: 'Invalid password',
          statusCode: 401,
        );
      }

      // Generate JWT tokens
      final accessToken = _jwtService.generateAccessToken(
        userId: int.parse(userModel.id),
        phone: userModel.phone,
        name: '${userModel.firstName} ${userModel.lastName}',
      );
      final refreshToken = _jwtService.generateRefreshToken(
        userId: int.parse(userModel.id),
        phone: userModel.phone,
      );

      final tokensModel = AuthTokensModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: 3600, // 1 hour
      );

      // Save tokens and user data locally
      await _localDataSource.saveAuthTokens(tokensModel);
      await _localDataSource.saveUserData(userModel);
      await _localDataSource.setLoggedIn(true);

      return tokensModel.toEntity();
    }, operationName: 'login');

    return result.fold((failure) => Left(failure), (tokens) => Right(tokens));
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final result = await handleVoidException(() async {
      await _localDataSource.clearAuthTokens();
      await _localDataSource.clearUserData();
      await _localDataSource.setLoggedIn(false);
    }, operationName: 'logout');

    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, AuthTokens>> refreshToken() async {
    final result = await handleException(() async {
      final tokensModel = await _localDataSource.getAuthTokens();
      if (tokensModel == null) {
        throw AuthenticationException(
          message: 'No refresh token found',
          statusCode: 401,
        );
      }

      // Check if refresh token is expired
      if (_jwtService.isTokenExpired(tokensModel.refreshToken)) {
        throw AuthenticationException(
          message: 'Refresh token expired',
          statusCode: 401,
        );
      }

      // Generate new access token using refresh token
      final newAccessToken = _jwtService.refreshAccessToken(
        tokensModel.refreshToken,
      );
      if (newAccessToken == null) {
        throw AuthenticationException(
          message: 'Failed to refresh access token',
          statusCode: 401,
        );
      }

      final newTokensModel = AuthTokensModel(
        accessToken: newAccessToken,
        refreshToken: tokensModel.refreshToken,
        expiresIn: 3600, // 1 hour
      );

      await _localDataSource.saveAuthTokens(newTokensModel);
      return newTokensModel.toEntity();
    }, operationName: 'refresh token');

    return result.fold((failure) => Left(failure), (tokens) => Right(tokens));
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    final result = await handleException(() async {
      final cachedUserModel = await _localDataSource.getCachedUser();
      if (cachedUserModel != null) {
        return cachedUserModel.toEntity();
      } else {
        throw CacheException(message: 'No cached user data');
      }
    }, operationName: 'get current user');

    return result.fold((failure) => Left(failure), (user) => Right(user));
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    final result = await handleException(() async {
      final isLoggedIn = await _localDataSource.isLoggedIn();
      final tokens = await _localDataSource.getAuthTokens();

      if (isLoggedIn && tokens != null) {
        // Check if token is expired
        if (_jwtService.isTokenExpired(tokens.accessToken)) {
          // Try to refresh token
          final refreshResult = await refreshToken();
          return refreshResult.fold((failure) => false, (newTokens) => true);
        }
        return true;
      }
      return false;
    }, operationName: 'check login status');

    return result.fold(
      (failure) => Left(failure),
      (isLoggedIn) => Right(isLoggedIn),
    );
  }

  @override
  Future<Either<Failure, void>> saveUserData(User user) async {
    final result = await handleVoidException(() async {
      final userModel = UserModel.fromEntity(user);
      await _localDataSource.saveUserData(userModel);
    }, operationName: 'save user data');

    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, User?>> getCachedUser() async {
    final result = await handleException(() async {
      final cachedUserModel = await _localDataSource.getCachedUser();
      return cachedUserModel?.toEntity();
    }, operationName: 'get cached user');

    return result.fold((failure) => Left(failure), (user) => Right(user));
  }

  @override
  Future<Either<Failure, void>> clearUserData() async {
    final result = await handleVoidException(() async {
      await _localDataSource.clearUserData();
    }, operationName: 'clear user data');

    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }
}
