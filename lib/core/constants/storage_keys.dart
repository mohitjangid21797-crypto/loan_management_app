/// Keys for secure storage and shared preferences.
abstract final class StorageKeys {
  // Secure storage.
  static const String mpinHash = 'mpin_hash';
  static const String mpinSalt = 'mpin_salt';
  static const String failedAttempts = 'failed_attempts';
  static const String lockoutUntil = 'lockout_until';

  // Shared preferences.
  static const String themeMode = 'theme_mode';
  static const String localeCode = 'locale_code';
  static const String biometricEnabled = 'biometric_enabled';
  static const String onboardingDone = 'onboarding_done';
}
