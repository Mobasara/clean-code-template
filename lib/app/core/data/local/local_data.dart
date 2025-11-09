import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';

class LocalData {
  final SharedPreferences _pref;
  LocalData(this._pref);

  String getAccessToken() => _pref.getString(AppConstants.accessTokenKey) ?? '';
  Future<void> setAccessToken(String token) async => _pref.setString(AppConstants.accessTokenKey, token);

  // Login status
  Future<void> setLoginStatus(bool loginStatus) async =>
      await _pref.setBool(AppConstants.isLoggedInKey, loginStatus);
  bool getLoginStatus() => _pref.getBool(AppConstants.isLoggedInKey) ?? false;


  // Refresh token
  Future<void> setRefreshToken(String token) async =>
      await _pref.setString(AppConstants.refreshTokenKey, token);
  String getRefreshToken() =>
      _pref.getString(AppConstants.refreshTokenKey) ?? '';

  // Theme mode
  Future<void> setThemeMode(String themeMode) async =>
      await _pref.setString(AppConstants.themeKey, themeMode);
  String getThemeMode() => _pref.getString(AppConstants.themeKey) ?? 'system';

  // Language
  Future<void> setLanguage(String language) async =>
      await _pref.setString(AppConstants.languageKey, language);
  String getLanguage() => _pref.getString(AppConstants.languageKey) ?? 'en';

  // Onboarding
  Future<void> setOnboardingComplete(bool isComplete) async =>
      await _pref.setBool(AppConstants.onboardingKey, isComplete);
  bool getOnboardingComplete() =>
      _pref.getBool(AppConstants.onboardingKey) ?? false;
}
