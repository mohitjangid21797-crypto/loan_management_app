import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeProvider extends ChangeNotifier {
  static const preferenceKey = 'selected_theme_mode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadSavedTheme() async {
    final preferences = await SharedPreferences.getInstance();
    _themeMode = preferences.getString(preferenceKey) == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode != ThemeMode.light && mode != ThemeMode.dark) {
      throw ArgumentError.value(
        mode,
        'mode',
        'Only light and dark themes are supported',
      );
    }

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      preferenceKey,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
    _themeMode = mode;
    notifyListeners();
  }
}
