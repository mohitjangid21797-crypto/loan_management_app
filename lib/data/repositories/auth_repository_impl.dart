import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/core/error/exception_handler.dart';
import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/utils/pbkdf2.dart';
import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/core/utils/validators.dart';
import 'package:loan_management_app/data/local/prefs_storage.dart';
import 'package:loan_management_app/data/local/secure_storage.dart';
import 'package:loan_management_app/domain/entities/auth_attempt.dart';
import 'package:loan_management_app/domain/repositories/auth_repository.dart';

/// Derives the MPIN key. Injectable so tests can run it synchronously.
typedef MpinDeriver =
    Future<Uint8List> Function(List<int> mpin, List<int> salt, int iterations);

Future<Uint8List> _deriveInIsolate(
  List<int> mpin,
  List<int> salt,
  int iterations,
) {
  return Isolate.run(
    () => pbkdf2HmacSha256(
      password: mpin,
      salt: salt,
      iterations: iterations,
    ),
  );
}

/// MPIN auth backed by secure storage. Only a salted PBKDF2 hash is stored.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required SecureStorage secureStorage,
    required PrefsStorage prefsStorage,
    DateTime Function()? now,
    int iterations = AppConstants.mpinPbkdf2Iterations,
    MpinDeriver? derive,
    Random? random,
  }) : _secure = secureStorage,
       _prefs = prefsStorage,
       _now = now ?? DateTime.now,
       _iterations = iterations,
       _derive = derive ?? _deriveInIsolate,
       _random = random ?? Random.secure();

  /// Longest lockout, however many times it has grown.
  static const Duration _maxLockout = Duration(hours: 1);

  final SecureStorage _secure;
  final PrefsStorage _prefs;
  final DateTime Function() _now;
  final int _iterations;
  final MpinDeriver _derive;
  final Random _random;

  @override
  Future<Result<bool>> hasMpin() {
    return ExceptionHandler.guard(() async {
      return await _secure.readMpinCredentials() != null;
    });
  }

  @override
  Future<Result<int>> mpinLength() {
    return ExceptionHandler.guard(() async {
      return await _secure.readMpinLength() ?? AppConstants.mpinMinLength;
    });
  }

  @override
  Future<Result<void>> setMpin(String mpin) async {
    final invalid = Validators.mpin(mpin);
    if (invalid != null) {
      return Err(ValidationFailure(invalid));
    }
    return ExceptionHandler.guard(() async {
      final salt = Uint8List.fromList(
        List<int>.generate(
          AppConstants.mpinSaltBytes,
          (_) => _random.nextInt(256),
        ),
      );
      final hash = await _derive(mpin.codeUnits, salt, _iterations);
      await _secure.saveMpinCredentials(
        salt: salt,
        hash: hash,
        length: mpin.length,
      );
      await _secure.writeFailedAttempts(0);
      await _secure.writeLockoutUntil(null);
    });
  }

  @override
  Future<Result<AuthAttempt>> verifyMpin(String mpin) {
    return ExceptionHandler.guard(() async {
      final now = _now();
      final failed = await _secure.readFailedAttempts();
      final lockedUntil = await _secure.readLockoutUntil();
      if (lockedUntil != null && lockedUntil.isAfter(now)) {
        return AuthAttempt(
          success: false,
          failedAttempts: failed,
          lockedUntil: lockedUntil,
        );
      }

      final credentials = await _secure.readMpinCredentials();
      if (credentials == null) {
        throw const DataNotFoundException('mpin');
      }
      final derived = await _derive(
        mpin.codeUnits,
        credentials.salt,
        _iterations,
      );
      if (constantTimeEquals(derived, credentials.hash)) {
        await _secure.writeFailedAttempts(0);
        await _secure.writeLockoutUntil(null);
        return const AuthAttempt(success: true);
      }

      final newFailed = failed + 1;
      await _secure.writeFailedAttempts(newFailed);
      const limit = AppConstants.maxMpinAttempts;
      DateTime? newLockout;
      if (newFailed % limit == 0) {
        newLockout = now.add(_lockoutFor(newFailed ~/ limit));
        await _secure.writeLockoutUntil(newLockout);
      }
      return AuthAttempt(
        success: false,
        failedAttempts: newFailed,
        remainingAttempts: limit - (newFailed % limit),
        lockedUntil: newLockout,
      );
    });
  }

  /// 30s for the first lockout, doubling each time, capped at one hour.
  Duration _lockoutFor(int level) {
    final seconds = AppConstants.baseLockout.inSeconds * pow(2, level - 1);
    final lockout = Duration(seconds: seconds.toInt());
    return lockout > _maxLockout ? _maxLockout : lockout;
  }

  @override
  Future<Result<DateTime?>> getLockoutUntil() {
    return ExceptionHandler.guard(() async {
      final until = await _secure.readLockoutUntil();
      return until != null && until.isAfter(_now()) ? until : null;
    });
  }

  @override
  Future<bool> isBiometricEnabled() async => _prefs.readBiometricEnabled();

  @override
  Future<Result<void>> setBiometricEnabled({required bool enabled}) {
    return ExceptionHandler.guard(
      () => _prefs.writeBiometricEnabled(enabled: enabled),
    );
  }
}
