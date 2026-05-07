import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  throw StateError('preferencesServiceProvider must be overridden in main');
});

class PreferencesService {
  PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  static const _themeMode = 'theme_mode';
  static const _languageCode = 'language_code';
  static const _biometric = 'biometric_enabled';
  static const _firstLaunch = 'first_launch';
  static const _userDisplayName = 'user_display_name';

  String getThemeMode() => _prefs.getString(_themeMode) ?? 'system';

  Future<void> setThemeMode(String mode) => _prefs.setString(_themeMode, mode);

  String? getLanguageCode() => _prefs.getString(_languageCode);

  Future<void> setLanguageCode(String code) =>
      _prefs.setString(_languageCode, code);

  bool isBiometricEnabled() => _prefs.getBool(_biometric) ?? false;

  Future<void> setBiometricEnabled(bool value) =>
      _prefs.setBool(_biometric, value);

  bool isFirstLaunch() => _prefs.getBool(_firstLaunch) ?? true;

  Future<void> setFirstLaunch(bool value) =>
      _prefs.setBool(_firstLaunch, value);

  String getUserDisplayName() => _prefs.getString(_userDisplayName) ?? '';

  Future<void> setUserDisplayName(String name) =>
      _prefs.setString(_userDisplayName, name);
}
