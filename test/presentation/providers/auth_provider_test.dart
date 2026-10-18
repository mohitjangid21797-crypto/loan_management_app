import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/presentation/providers/auth_provider.dart';

import '../../helpers/fakes.dart';

void main() {
  late ProviderContainer container;
  final start = DateTime.utc(2026, 10, 17, 12);

  Future<AuthNotifier> unlockedNotifier() async {
    container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(() => TestAuthNotifier(AuthStatus.unlocked)),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authProvider.future);
    return container.read(authProvider.notifier);
  }

  AuthStatus? status() => container.read(authProvider).valueOrNull;

  group('lock on resume', () {
    test('stays unlocked after a short trip to the background', () async {
      final auth = await unlockedNotifier();

      auth.appPaused(now: start);
      auth.appResumed(
        now: start + AppConstants.relockAfter - const Duration(seconds: 1),
      );

      expect(status(), AuthStatus.unlocked);
    });

    test('locks once the app was away for the full period', () async {
      final auth = await unlockedNotifier();

      auth.appPaused(now: start);
      auth.appResumed(now: start + AppConstants.relockAfter);

      expect(status(), AuthStatus.locked);
    });

    test('a resume without a pause does nothing', () async {
      final auth = await unlockedNotifier();

      auth.appResumed(now: start + const Duration(hours: 1));

      expect(status(), AuthStatus.unlocked);
    });

    test('lock() does not move other states', () async {
      container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(
            () => TestAuthNotifier(AuthStatus.needsSetup),
          ),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authProvider.future);

      container.read(authProvider.notifier).lock();

      expect(status(), AuthStatus.needsSetup);
    });
  });

  group('unlockWithBiometric', () {
    test('unlocks only when the system check succeeds', () async {
      final biometric = FakeBiometricService(available: true);
      container = ProviderContainer(
        overrides: [
          biometricServiceProvider.overrideWithValue(biometric),
          authProvider.overrideWith(() => TestAuthNotifier(AuthStatus.locked)),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authProvider.future);
      final auth = container.read(authProvider.notifier);

      expect(await auth.unlockWithBiometric(reason: 'test'), isFalse);
      expect(status(), AuthStatus.locked);

      biometric.succeeds = true;
      expect(await auth.unlockWithBiometric(reason: 'test'), isTrue);
      expect(status(), AuthStatus.unlocked);
    });
  });
}
