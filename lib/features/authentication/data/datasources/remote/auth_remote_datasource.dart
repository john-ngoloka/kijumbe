import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/network/dio_client.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokensModel> login({
    required String phone,
    required String password,
  });

  Future<void> logout();

  Future<AuthTokensModel> refreshToken(String refreshToken);

  Future<UserModel> getCurrentUser();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthTokensModel> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        AppConstants.loginEndpoint,
        data: {'phone': phone, 'password': password},
      );

      if (response.statusCode == 200) {
        return AuthTokensModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'No internet connection');
      } else if (e.response?.statusCode == 401) {
        throw const AuthenticationException(message: 'Invalid credentials');
      } else {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      }
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.dio.post(AppConstants.logoutEndpoint);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'No internet connection');
      } else {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Logout failed',
          statusCode: e.response?.statusCode,
        );
      }
    }
  }

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.dio.post(
        AppConstants.refreshTokenEndpoint,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        return AuthTokensModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Token refresh failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'No internet connection');
      } else {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Token refresh failed',
          statusCode: e.response?.statusCode,
        );
      }
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dioClient.dio.get('/user/profile');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get user data',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(message: 'Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(message: 'No internet connection');
      } else if (e.response?.statusCode == 401) {
        throw const AuthenticationException(message: 'Unauthorized');
      } else {
        throw ServerException(
          message: e.response?.data['message'] ?? 'Failed to get user data',
          statusCode: e.response?.statusCode,
        );
      }
    }
  }
}
