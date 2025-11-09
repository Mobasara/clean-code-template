import '../../model/user_model.dart';

abstract class AuthLocalDataSource {
  /// Cache user data locally
  Future<void> cacheUser(UserModel user);

  /// Get cached user data
  Future<UserModel> getCachedUser();

  /// Cache authentication token
  Future<void> cacheToken(String token);

  /// Get cached token
  Future<String> getCachedToken();

  /// Cache refresh token
  Future<void> cacheRefreshToken(String refreshToken);

  /// Get cached refresh token
  Future<String> getCachedRefreshToken();

  /// Clear all cached data
  Future<void> clearCache();

  /// Check if user is logged in (has valid token)
  Future<bool> hasToken();
}
