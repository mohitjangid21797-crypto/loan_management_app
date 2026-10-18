import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/domain/entities/auth_attempt.dart';

/// Local MPIN authentication and lockout state.
abstract interface class AuthRepository {
  /// Whether an MPIN has been created on this device.
  Future<Result<bool>> hasMpin();

  /// Length (4 or 6) of the stored MPIN.
  Future<Result<int>> mpinLength();

  /// Stores a new MPIN (4 or 6 digits) as a salted hash.
  Future<Result<void>> setMpin(String mpin);

  /// Checks [mpin], tracking failed attempts and lockout.
  Future<Result<AuthAttempt>> verifyMpin(String mpin);

  /// When the current lockout ends, or null if not locked out.
  Future<Result<DateTime?>> getLockoutUntil();

  Future<bool> isBiometricEnabled();

  Future<Result<void>> setBiometricEnabled({required bool enabled});
}
