import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Theme and language choices. A null [locale] follows the device.
class SettingsState extends Equatable {
  const SettingsState({this.themeMode = ThemeMode.system, this.locale});

  final ThemeMode themeMode;
  final Locale? locale;

  @override
  List<Object?> get props => [themeMode, locale];
}

/// In-memory in Phase 0. Phase 1 persists these through prefs storage.
class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void setThemeMode(ThemeMode mode) {
    state = SettingsState(themeMode: mode, locale: state.locale);
  }

  void setLocale(Locale? locale) {
    state = SettingsState(themeMode: state.themeMode, locale: locale);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
