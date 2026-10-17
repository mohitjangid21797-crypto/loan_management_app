import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/router/route_names.dart';
import 'package:loan_management_app/presentation/providers/auth_provider.dart';
import 'package:loan_management_app/presentation/providers/settings_provider.dart';

/// Theme, language, biometric unlock, MPIN, profile and manual lock.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const List<String> _languageCodes = ['en', 'hi', 'ta'];

  Future<void> _toggleBiometric(
    BuildContext context,
    WidgetRef ref, {
    required bool enable,
  }) async {
    final notifier = ref.read(settingsProvider.notifier);
    if (!enable) {
      await notifier.setBiometricEnabled(enabled: false);
      return;
    }
    final l10n = context.l10n;
    final service = ref.read(biometricServiceProvider);
    if (!await service.isAvailable()) {
      if (context.mounted) {
        context.showSnack(l10n.biometricUnavailable);
      }
      return;
    }
    // Enabling needs one successful check, so it is known to work.
    if (await service.authenticate(reason: l10n.biometricReason)) {
      await notifier.setBiometricEnabled(enabled: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    final resolved = Localizations.localeOf(context).languageCode;
    final languageCode = _languageCodes.contains(resolved) ? resolved : 'en';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n.profileTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RouteNames.profilePath),
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.settingsTheme),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              onChanged: (mode) {
                if (mode != null) {
                  notifier.setThemeMode(mode);
                }
              },
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(l10n.themeSystem),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(l10n.themeLight),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(l10n.themeDark),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(l10n.settingsLanguage),
            trailing: DropdownButton<String>(
              value: languageCode,
              onChanged: (code) {
                if (code != null) {
                  notifier.setLocale(Locale(code));
                }
              },
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(l10n.languageEnglish),
                ),
                DropdownMenuItem(
                  value: 'hi',
                  child: Text(l10n.languageHindi),
                ),
                DropdownMenuItem(
                  value: 'ta',
                  child: Text(l10n.languageTamil),
                ),
              ],
            ),
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: Text(l10n.settingsBiometric),
            subtitle: Text(l10n.settingsBiometricHint),
            value: settings.biometricEnabled,
            onChanged: (value) =>
                _toggleBiometric(context, ref, enable: value),
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: Text(l10n.changeMpinTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RouteNames.changeMpinPath),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l10n.settingsLockNow),
            onTap: () => ref.read(authProvider.notifier).lock(),
          ),
        ],
      ),
    );
  }
}
