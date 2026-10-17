import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/core/error/exception_handler.dart';
import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/data/local/secure_storage.dart';
import 'package:loan_management_app/data/repositories/auth_repository_impl.dart';
import 'package:loan_management_app/domain/entities/auth_attempt.dart';
import 'package:loan_management_app/domain/repositories/auth_repository.dart';
import 'package:loan_management_app/presentation/providers/settings_provider.dart';
import 'package:loan_management_app/services/biometric_service.dart';

/// Where the user is in the lock flow.
enum AuthStatus { unknown, needsSetup, locked, unlocked }

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return const SecureStorage();
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    secureStorage: ref.watch(secureStorageProvider),
    prefsStorage: ref.watch(prefsStorageProvider),
  );
});

/// Length (4 or 6) of the stored MPIN, for the login keypad.
final mpinLengthProvider = FutureProvider<int>((ref) async {
  final result = await ref.watch(authRepositoryProvider).mpinLength();
  return result.valueOrNull ?? AppConstants.mpinMinLength;
});

/// Resolves the initial state from storage, then tracks lock and unlock.
/// While loading, the state is treated as [AuthStatus.unknown].
class AuthNotifier extends AsyncNotifier<AuthStatus> {
  DateTime? _backgroundedAt;

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  Future<AuthStatus> build() async {
    final results = await Future.wait<Object?>([
      _repo.hasMpin(),
      Future<void>.delayed(AppConstants.splashDuration),
    ]);
    final hasMpin = results.first! as Result<bool>;
    return switch (hasMpin) {
      Success<bool>(:final value) =>
        value ? AuthStatus.locked : AuthStatus.needsSetup,
      // Never fall back to needsSetup here: it would let a storage glitch
      // overwrite an existing MPIN.
      Err<bool>(:final failure) => throw StorageException(
        failure.debugMessage,
      ),
    };
  }

  /// Saves a first MPIN and unlocks. Returns the failure, or null on success.
  Future<Failure?> completeSetup(String mpin) async {
    final result = await _repo.setMpin(mpin);
    if (result.isSuccess) {
      state = const AsyncData(AuthStatus.unlocked);
    }
    return result.failureOrNull;
  }

  /// Checks [mpin] and unlocks on success. Null means a storage failure.
  Future<AuthAttempt?> unlockWithMpin(String mpin) async {
    final result = await _repo.verifyMpin(mpin);
    final attempt = result.valueOrNull;
    if (attempt != null && attempt.success) {
      state = const AsyncData(AuthStatus.unlocked);
    }
    return attempt;
  }

  /// Unlocks after a successful system biometric prompt.
  Future<bool> unlockWithBiometric({required String reason}) async {
    final service = ref.read(biometricServiceProvider);
    if (!await service.authenticate(reason: reason)) {
      return false;
    }
    state = const AsyncData(AuthStatus.unlocked);
    return true;
  }

  void lock() {
    if (state.valueOrNull == AuthStatus.unlocked) {
      state = const AsyncData(AuthStatus.locked);
    }
  }

  /// Call when the app goes to the background.
  void appPaused({DateTime? now}) {
    _backgroundedAt = now ?? DateTime.now();
  }

  /// Call when the app returns; locks if it was away long enough.
  void appResumed({DateTime? now}) {
    final since = _backgroundedAt;
    _backgroundedAt = null;
    if (since == null) {
      return;
    }
    final away = (now ?? DateTime.now()).difference(since);
    if (away >= AppConstants.relockAfter) {
      lock();
    }
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthStatus>(
  AuthNotifier.new,
);

/// The auth status with loading treated as [AuthStatus.unknown].
AuthStatus authStatusOf(AsyncValue<AuthStatus> value) {
  return value.valueOrNull ?? AuthStatus.unknown;
}
