import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_management_app/l10n/ui_translations.dart';
import 'package:loan_management_app/main.dart';
import 'package:loan_management_app/providers/app_locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('language can be changed from the login screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    GoogleFonts.config.allowRuntimeFetching = false;
    await UiTranslations.load();
    final localeProvider = AppLocaleProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: localeProvider,
        child: Consumer<AppLocaleProvider>(
          builder: (context, provider, _) => MaterialApp(
            locale: provider.locale,
            supportedLocales: AppLocaleProvider.supportedLanguageCodes.map(
              Locale.new,
            ),
            home: const LoginScreen(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Select Language'), findsOneWidget);
    await tester.tap(find.text('Select Language'));
    await tester.pump(const Duration(milliseconds: 400));

    final tamilOption = find.text('தமிழ்');
    await tester.scrollUntilVisible(
      tamilOption,
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(tamilOption);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(localeProvider.locale, const Locale('ta'));
    expect(find.text('மொழியைத் தேர்ந்தெடுக்கவும்'), findsOneWidget);
  });
}
