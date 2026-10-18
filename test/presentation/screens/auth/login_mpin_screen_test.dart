import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/presentation/providers/auth_provider.dart';
import 'package:loan_management_app/presentation/screens/auth/login_mpin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    prefs = await emptyPrefs();
  });

  Widget screen(FakeAuthRepository repo, {FakeBiometricService? biometric}) {
    return testApp(
      prefs: prefs,
      home: const LoginMpinScreen(),
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        biometricServiceProvider.overrideWithValue(
          biometric ?? FakeBiometricService(),
        ),
        authProvider.overrideWith(() => TestAuthNotifier(AuthStatus.locked)),
      ],
    );
  }

  AuthStatus? statusOf(WidgetTester tester) {
    final container = ProviderScope.containerOf(
      tester.element(find.byType(LoginMpinScreen)),
    );
    return container.read(authProvider).valueOrNull;
  }

  testWidgets('the right MPIN unlocks the app', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(screen(FakeAuthRepository(mpin: '1234')));
    await tester.pumpAndSettle();

    await enterPin(tester, '1234');
    await tester.pumpAndSettle();

    expect(statusOf(tester), AuthStatus.unlocked);
  });

  testWidgets('a wrong MPIN shows the attempts left and stays locked', (
    tester,
  ) async {
    useTallScreen(tester);
    await tester.pumpWidget(screen(FakeAuthRepository(mpin: '1234')));
    await tester.pumpAndSettle();

    await enterPin(tester, '0000');
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Wrong MPIN. 4 attempts left.'), findsOneWidget);
    expect(statusOf(tester), AuthStatus.locked);
  });

  testWidgets('a lockout disables the keypad and shows a countdown', (
    tester,
  ) async {
    useTallScreen(tester);
    await tester.pumpWidget(
      screen(FakeAuthRepository(mpin: '1234', lockAfter: 1)),
    );
    await tester.pumpAndSettle();

    await enterPin(tester, '0000');
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('Too many wrong attempts'), findsOneWidget);
    final key = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '1'),
    );
    expect(key.onPressed, isNull);

    // Dispose the screen so its countdown timer is cancelled.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the biometric key appears only when enabled and available', (
    tester,
  ) async {
    useTallScreen(tester);
    await prefs.setBool('biometric_enabled', true);
    final biometric = FakeBiometricService(available: true);
    await tester.pumpWidget(
      screen(FakeAuthRepository(mpin: '1234'), biometric: biometric),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.fingerprint), findsOneWidget);
  });

  testWidgets('no biometric key when the device has none', (tester) async {
    useTallScreen(tester);
    await prefs.setBool('biometric_enabled', true);
    await tester.pumpWidget(screen(FakeAuthRepository(mpin: '1234')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.fingerprint), findsNothing);
  });

  testWidgets('a successful biometric check unlocks the app', (tester) async {
    useTallScreen(tester);
    await prefs.setBool('biometric_enabled', true);
    final biometric = FakeBiometricService(available: true, succeeds: true);
    await tester.pumpWidget(
      screen(FakeAuthRepository(mpin: '1234'), biometric: biometric),
    );
    await tester.pumpAndSettle();

    expect(statusOf(tester), AuthStatus.unlocked);
  });
}
