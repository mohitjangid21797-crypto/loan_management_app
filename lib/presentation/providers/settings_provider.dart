import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/data/local/prefs_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Must be overridden in `main` with the loaded instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider was not overridden');
});

final prefsStorageProvider = Provider<PrefsStorage>((ref) {
  return PrefsStorage(ref.watch(sharedPreferencesProvider));
});

/// Theme, language and biometric choices. A null [locale] follows the device.
class SettingsState extends Equatable {
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale,
    this.biometricEnabled = false,
  });

  final ThemeMode themeMode;
  final Locale? locale;
  final bool biometricEnabled;

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? biometricEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, biometricEnabled];
}

/// Settings persisted through [PrefsStorage].
class SettingsNotifier extends Notifier<SettingsState> {
  PrefsStorage get _prefs => ref.read(prefsStorageProvider);

  @override
  SettingsState build() {
    final prefs = ref.watch(prefsStorageProvider);
    final code = prefs.readLocaleCode();
    return SettingsState(
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == prefs.readThemeModeName(),
        orElse: () => ThemeMode.system,
      ),
      locale: code == null ? null : Locale(code),
      biometricEnabled: prefs.readBiometricEnabled(),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs.writeThemeModeName(mode.name);
  }

  Future<void> setLocale(Locale? locale) async {
    state = SettingsState(
      themeMode: state.themeMode,
      locale: locale,
      biometricEnabled: state.biometricEnabled,
    );
    await _prefs.writeLocaleCode(locale?.languageCode);
  }

  Future<void> setBiometricEnabled({required bool enabled}) async {
    state = state.copyWith(biometricEnabled: enabled);
    await _prefs.writeBiometricEnabled(enabled: enabled);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
