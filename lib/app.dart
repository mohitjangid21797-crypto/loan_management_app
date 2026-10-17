import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/core/router/app_router.dart';
import 'package:loan_management_app/core/theme/app_theme.dart';
import 'package:loan_management_app/l10n/generated/app_localizations.dart';
import 'package:loan_management_app/presentation/providers/settings_provider.dart';

/// Root widget: router, themes, locale and localization delegates.
class LoanManagerApp extends ConsumerWidget {
  const LoanManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));
    final locale = ref.watch(settingsProvider.select((s) => s.locale));

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      routerConfig: router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (deviceLocale, supported) {
        if (deviceLocale == null) {
          return AppConstants.defaultLocale;
        }
        for (final candidate in supported) {
          if (candidate.languageCode == deviceLocale.languageCode) {
            return candidate;
          }
        }
        return AppConstants.defaultLocale;
      },
    );
  }
}
