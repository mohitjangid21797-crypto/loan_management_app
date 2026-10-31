import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/providers/app_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads and persists the selected theme mode', () async {
    SharedPreferences.setMockInitialValues({
      AppThemeProvider.preferenceKey: 'dark',
    });
    final provider = AppThemeProvider();

    await provider.loadSavedTheme();
    expect(provider.themeMode, ThemeMode.dark);

    await provider.setThemeMode(ThemeMode.light);
    expect(provider.themeMode, ThemeMode.light);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString(AppThemeProvider.preferenceKey), 'light');
  });

  testWidgets('changing theme mode updates MaterialApp immediately', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final themeProvider = AppThemeProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: themeProvider,
        child: Consumer<AppThemeProvider>(
          builder: (context, provider, _) => MaterialApp(
            themeMode: provider.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
          ),
        ),
      ),
    );
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );

    await themeProvider.setThemeMode(ThemeMode.dark);
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
    expect(app.darkTheme?.brightness, Brightness.dark);
  });
}
