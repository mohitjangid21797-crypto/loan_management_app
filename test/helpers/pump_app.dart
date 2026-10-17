import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/l10n/generated/app_localizations.dart';
import 'package:loan_management_app/presentation/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Makes the test screen tall enough that the whole keypad is on screen.
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Loads an empty [SharedPreferences] for [sharedPreferencesProvider].
Future<SharedPreferences> emptyPrefs() async {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}

/// Wraps [home] with localization and a [ProviderScope] for widget tests.
Widget testApp({
  required Widget home,
  required SharedPreferences prefs,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      ...overrides,
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

/// Taps the keypad digits of [pin] in order.
Future<void> enterPin(WidgetTester tester, String pin) async {
  for (final digit in pin.split('')) {
    await tester.tap(find.widgetWithText(FilledButton, digit));
    await tester.pump();
  }
}
