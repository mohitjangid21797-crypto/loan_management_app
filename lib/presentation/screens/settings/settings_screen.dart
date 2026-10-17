import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/presentation/providers/settings_provider.dart';

/// Phase 0 settings: theme and language only. More arrives in Phase 1.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const List<String> _languageCodes = ['en', 'hi', 'ta'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));
    final notifier = ref.read(settingsProvider.notifier);

    final resolved = Localizations.localeOf(context).languageCode;
    final languageCode = _languageCodes.contains(resolved) ? resolved : 'en';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.settingsTheme),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
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
        ],
      ),
    );
  }
}
