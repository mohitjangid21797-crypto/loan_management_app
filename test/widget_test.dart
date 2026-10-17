import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/app.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/core/router/app_router.dart';
import 'package:loan_management_app/presentation/providers/auth_provider.dart';
import 'package:loan_management_app/presentation/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fakes.dart';
import 'helpers/pump_app.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    prefs = await emptyPrefs();
  });

  Widget app(FakeAuthRepository repo) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authRepositoryProvider.overrideWithValue(repo),
        biometricServiceProvider.overrideWithValue(FakeBiometricService()),
      ],
      child: const LoanManagerApp(),
    );
  }

  Future<void> pastSplash(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(
      AppConstants.splashDuration + const Duration(milliseconds: 100),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the splash screen first', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app(FakeAuthRepository()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await pastSplash(tester);
  });

  testWidgets('a fresh install is forced to create an MPIN', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app(FakeAuthRepository()));
    await pastSplash(tester);

    expect(find.text('Create your MPIN'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('creating an MPIN needs a matching confirmation', (tester) async {
    useTallScreen(tester);
    final repo = FakeAuthRepository();
    await tester.pumpWidget(app(repo));
    await pastSplash(tester);

    await enterPin(tester, '1234');
    expect(find.text('Enter the same MPIN again to confirm'), findsOneWidget);

    await enterPin(tester, '4321');
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      find.text('The two MPINs did not match. Please start again.'),
      findsOneWidget,
    );
    expect(repo.mpin, isNull);

    await enterPin(tester, '1234');
    await enterPin(tester, '1234');
    await tester.pumpAndSettle();

    expect(repo.mpin, '1234');
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('with an MPIN set, the app starts locked', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(app(FakeAuthRepository(mpin: '1234')));
    await pastSplash(tester);

    expect(find.text('Enter your MPIN'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await enterPin(tester, '1234');
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
  });

  test('redirectFor sends each auth state to the right place', () {
    expect(redirectFor(AuthStatus.unknown, '/dashboard'), '/splash');
    expect(redirectFor(AuthStatus.unknown, '/splash'), isNull);
    expect(redirectFor(AuthStatus.needsSetup, '/splash'), '/set-mpin');
    expect(redirectFor(AuthStatus.needsSetup, '/set-mpin'), isNull);
    expect(redirectFor(AuthStatus.locked, '/dashboard'), '/login');
    expect(redirectFor(AuthStatus.locked, '/login'), isNull);
    expect(redirectFor(AuthStatus.unlocked, '/splash'), '/dashboard');
    expect(redirectFor(AuthStatus.unlocked, '/login'), '/dashboard');
    expect(redirectFor(AuthStatus.unlocked, '/customers'), isNull);
    expect(redirectFor(AuthStatus.unlocked, '/settings/profile'), isNull);
  });
}
