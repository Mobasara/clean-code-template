import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/utils/constants.dart';
import '../../model/user_model.dart';
import 'auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      final success = await sharedPreferences.setString(
        AppConstants.userDataKey,
        userJson,
      );
      
      if (!success) {
        throw CacheException(message: 'Failed to cache user data');
      }
    } catch (e) {
      throw CacheException(message: 'Failed to cache user data: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> getCachedUser() async {
    try {
      final userJson = sharedPreferences.getString(AppConstants.userDataKey);
      
      if (userJson == null || userJson.isEmpty) {
        throw CacheException(message: 'No cached user data found');
      }
      
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Failed to get cached user: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      final success = await sharedPreferences.setString(
        AppConstants.accessTokenKey,
        token,
      );
      
      if (!success) {
        throw CacheException(message: 'Failed to cache token');
      }
    } catch (e) {
      throw CacheException(message: 'Failed to cache token: ${e.toString()}');
    }
  }

  @override
  Future<String> getCachedToken() async {
    try {
      final token = sharedPreferences.getString(AppConstants.accessTokenKey);
      
      if (token == null || token.isEmpty) {
        throw CacheException(message: 'No cached token found');
      }
      
      return token;
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Failed to get cached token: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheRefreshToken(String refreshToken) async {
    try {
      final success = await sharedPreferences.setString(
        AppConstants.refreshTokenKey,
        refreshToken,
      );
      
      if (!success) {
        throw CacheException(message: 'Failed to cache refresh token');
      }
    } catch (e) {
      throw CacheException(message: 'Failed to cache refresh token: ${e.toString()}');
    }
  }

  @override
  Future<String> getCachedRefreshToken() async {
    try {
      final refreshToken = sharedPreferences.getString(AppConstants.refreshTokenKey);
      
      if (refreshToken == null || refreshToken.isEmpty) {
        throw CacheException(message: 'No cached refresh token found');
      }
      
      return refreshToken;
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Failed to get cached refresh token: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await Future.wait([
        sharedPreferences.remove(AppConstants.userDataKey),
        sharedPreferences.remove(AppConstants.accessTokenKey),
        sharedPreferences.remove(AppConstants.refreshTokenKey),
      ]);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: ${e.toString()}');
    }
  }

  @override
  Future<bool> hasToken() async {
    try {
      final token = sharedPreferences.getString(AppConstants.accessTokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}