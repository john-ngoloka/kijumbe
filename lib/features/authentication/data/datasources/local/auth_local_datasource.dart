import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/database/app_database.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/user_model.dart';
import 'collection/user_collection.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthTokens(AuthTokensModel tokens);
  Future<AuthTokensModel?> getAuthTokens();
  Future<void> clearAuthTokens();

  Future<void> saveUserData(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUserData();

  Future<void> setLoggedIn(bool isLoggedIn);
  Future<bool> isLoggedIn();

  // User storage in Isar
  Future<UserModel> createUser(UserModel user);
  Future<UserModel?> getUserByPhone(String phone);
  Future<UserModel?> getUserById(int userId);
  Future<bool> userExists(String phone);
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl(this._prefs);

  Future<Isar> get _isar async => await AppDatabase.instance;

  @override
  Future<void> saveAuthTokens(AuthTokensModel tokens) async {
    try {
      await _prefs.setString(AppConstants.accessTokenKey, tokens.accessToken);
      await _prefs.setString(AppConstants.refreshTokenKey, tokens.refreshToken);
    } catch (e) {
      throw CacheException(message: 'Failed to save auth tokens');
    }
  }

  @override
  Future<AuthTokensModel?> getAuthTokens() async {
    try {
      final accessToken = _prefs.getString(AppConstants.accessTokenKey);
      final refreshToken = _prefs.getString(AppConstants.refreshTokenKey);

      if (accessToken != null && refreshToken != null) {
        return AuthTokensModel(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresIn: 3600, // Default 1 hour
        );
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Failed to get auth tokens');
    }
  }

  @override
  Future<void> clearAuthTokens() async {
    try {
      await _prefs.remove(AppConstants.accessTokenKey);
      await _prefs.remove(AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear auth tokens');
    }
  }

  @override
  Future<void> saveUserData(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _prefs.setString(AppConstants.userDataKey, userJson);
    } catch (e) {
      throw CacheException(message: 'Failed to save user data');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = _prefs.getString(AppConstants.userDataKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Failed to get cached user');
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      await _prefs.remove(AppConstants.userDataKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear user data');
    }
  }

  @override
  Future<void> setLoggedIn(bool isLoggedIn) async {
    try {
      await _prefs.setBool(AppConstants.isLoggedInKey, isLoggedIn);
    } catch (e) {
      throw CacheException(message: 'Failed to set login status');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return _prefs.getBool(AppConstants.isLoggedInKey) ?? false;
    } catch (e) {
      throw CacheException(message: 'Failed to get login status');
    }
  }

  // User storage operations using Isar database
  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      final isar = await _isar;
      final userCollection = User.fromUserModel(user);

      await isar.writeTxn(() async {
        await isar.users.put(userCollection);
      });

      return userCollection.toUserModel();
    } catch (e) {
      throw CacheException(message: 'Failed to create user: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getUserByPhone(String phone) async {
    try {
      final isar = await _isar;
      final userCollection = await isar.users
          .filter()
          .phoneEqualTo(phone)
          .findFirst();

      return userCollection?.toUserModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get user by phone: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel?> getUserById(int userId) async {
    try {
      final isar = await _isar;
      final userCollection = await isar.users
          .filter()
          .idEqualTo(userId)
          .findFirst();

      return userCollection?.toUserModel();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get user by ID: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> userExists(String phone) async {
    try {
      final isar = await _isar;
      final count = await isar.users.filter().phoneEqualTo(phone).count();

      return count > 0;
    } catch (e) {
      throw CacheException(
        message: 'Failed to check if user exists: ${e.toString()}',
      );
    }
  }
}
