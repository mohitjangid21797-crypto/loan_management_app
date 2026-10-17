import 'package:flutter/widgets.dart';

/// App-wide constants. Nothing user-facing lives here; all visible text
/// comes from the ARB files.
abstract final class AppConstants {
  /// File name of the SQLite database in the app documents directory.
  static const String dbFileName = 'loan_manager.sqlite';

  /// How long the splash screen is shown.
  static const Duration splashDuration = Duration(milliseconds: 1200);

  /// Re-lock the app after it has been in the background this long.
  static const Duration relockAfter = Duration(seconds: 60);

  /// Debounce applied to search fields.
  static const Duration searchDebounce = Duration(milliseconds: 300);

  /// Allowed MPIN lengths.
  static const int mpinMinLength = 4;
  static const int mpinMaxLength = 6;

  /// Wrong attempts allowed before the first lockout.
  static const int maxMpinAttempts = 5;

  /// Base lockout; it grows with repeated lockouts.
  static const Duration baseLockout = Duration(seconds: 30);

  /// MPIN hashing parameters (PBKDF2-HMAC-SHA256).
  static const int mpinSaltBytes = 16;
  static const int mpinPbkdf2Iterations = 100000;

  /// Lists with more rows than this are paginated.
  static const int pageSize = 200;

  /// Locale used when the device locale is not supported.
  static const Locale defaultLocale = Locale('en');
}
