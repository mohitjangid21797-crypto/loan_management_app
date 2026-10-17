import 'dart:typed_data';

import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/data/local/secure_storage.dart';
import 'package:loan_management_app/domain/entities/auth_attempt.dart';
import 'package:loan_management_app/domain/repositories/auth_repository.dart';
import 'package:loan_management_app/presentation/providers/auth_provider.dart';
import 'package:loan_management_app/services/biometric_service.dart';

/// In-memory [SecureStorage] for tests.
class FakeSecureStorage implements SecureStorage {
  MpinCredentials? credentials;
  int? length;
  int failedAttempts = 0;
  DateTime? lockoutUntil;

  @override
  Future<void> saveMpinCredentials({
    required List<int> salt,
    required List<int> hash,
    required int length,
  }) async {
    credentials = (
      salt: Uint8List.fromList(salt),
      hash: Uint8List.fromList(hash),
    );
    this.length = length;
  }

  @override
  Future<MpinCredentials?> readMpinCredentials() async => credentials;

  @override
  Future<int?> readMpinLength() async => length;

  @override
  Future<int> readFailedAttempts() async => failedAttempts;

  @override
  Future<void> writeFailedAttempts(int count) async {
    failedAttempts = count;
  }

  @override
  Future<DateTime?> readLockoutUntil() async => lockoutUntil;

  @override
  Future<void> writeLockoutUntil(DateTime? until) async {
    lockoutUntil = until;
  }
}

/// A scriptable [AuthRepository]. Locks out after [lockAfter] wrong tries.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.mpin, this.lockAfter = 5});

  String? mpin;
  final int lockAfter;
  int failed = 0;
  DateTime? lockedUntil;
  bool biometric = false;

  @override
  Future<Result<bool>> hasMpin() async => Success(mpin != null);

  @override
  Future<Result<int>> mpinLength() async => Success(mpin?.length ?? 4);

  @override
  Future<Result<void>> setMpin(String mpin) async {
    this.mpin = mpin;
    return const Success<void>(null);
  }

  @override
  Future<Result<AuthAttempt>> verifyMpin(String attempt) async {
    if (attempt == mpin) {
      failed = 0;
      return const Success(AuthAttempt(success: true));
    }
    failed++;
    if (failed >= lockAfter) {
      lockedUntil = DateTime.now().add(const Duration(seconds: 30));
    }
    return Success(
      AuthAttempt(
        success: false,
        failedAttempts: failed,
        remainingAttempts: lockAfter - failed,
        lockedUntil: lockedUntil,
      ),
    );
  }

  @override
  Future<Result<DateTime?>> getLockoutUntil() async => Success(lockedUntil);

  @override
  Future<bool> isBiometricEnabled() async => biometric;

  @override
  Future<Result<void>> setBiometricEnabled({required bool enabled}) async {
    biometric = enabled;
    return const Success<void>(null);
  }
}

/// A [BiometricService] with scripted answers.
class FakeBiometricService implements BiometricService {
  FakeBiometricService({this.available = false, this.succeeds = false});

  bool available;
  bool succeeds;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate({required String reason}) async => succeeds;
}

/// An [AuthNotifier] that starts in a fixed state, with no splash delay.
class TestAuthNotifier extends AuthNotifier {
  TestAuthNotifier(this.initial);

  final AuthStatus initial;

  @override
  Future<AuthStatus> build() async => initial;
}
