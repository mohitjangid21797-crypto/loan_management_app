import 'package:loan_management_app/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Typed wrapper around SharedPreferences, so providers never touch it.
class PrefsStorage {
  const PrefsStorage(this._prefs);

  final SharedPreferences _prefs;

  /// One of `system`, `light`, `dark`.
  String readThemeModeName() {
    return _prefs.getString(StorageKeys.themeMode) ?? 'system';
  }

  Future<void> writeThemeModeName(String name) {
    return _prefs.setString(StorageKeys.themeMode, name);
  }

  /// Language code, or null to follow the device.
  String? readLocaleCode() => _prefs.getString(StorageKeys.localeCode);

  Future<void> writeLocaleCode(String? code) {
    if (code == null) {
      return _prefs.remove(StorageKeys.localeCode);
    }
    return _prefs.setString(StorageKeys.localeCode, code);
  }

  bool readBiometricEnabled() {
    return _prefs.getBool(StorageKeys.biometricEnabled) ?? false;
  }

  Future<void> writeBiometricEnabled({required bool enabled}) {
    return _prefs.setBool(StorageKeys.biometricEnabled, enabled);
  }

  bool readOnboardingDone() {
    return _prefs.getBool(StorageKeys.onboardingDone) ?? false;
  }

  Future<void> writeOnboardingDone({required bool done}) {
    return _prefs.setBool(StorageKeys.onboardingDone, done);
  }
}
