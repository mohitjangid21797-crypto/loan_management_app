import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocaleProvider extends ChangeNotifier {
  static const preferenceKey = 'selected_language';

  static const supportedLanguageCodes = [
    'en',
    'as',
    'bn',
    'gu',
    'hi',
    'kn',
    'ml',
    'mr',
    'ne',
    'or',
    'pa',
    'ta',
    'te',
    'ur',
  ];

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> loadSavedLocale() async {
    final preferences = await SharedPreferences.getInstance();
    final code = preferences.getString(preferenceKey) ?? 'en';
    _locale = Locale(
      supportedLanguageCodes.contains(code) ? code : 'en',
    );
  }

  Future<void> setLanguage(String code) async {
    if (!supportedLanguageCodes.contains(code)) {
      throw ArgumentError.value(code, 'code', 'Unsupported language code');
    }

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(preferenceKey, code);
    _locale = Locale(code);
    notifyListeners();
  }
}
