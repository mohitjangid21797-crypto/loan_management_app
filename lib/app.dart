import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/core/router/app_router.dart';
import 'package:loan_management_app/core/theme/app_theme.dart';
import 'package:loan_management_app/l10n/generated/app_localizations.dart';
import 'package:loan_management_app/presentation/providers/auth_provider.dart';
import 'package:loan_management_app/presentation/providers/settings_provider.dart';

/// Root widget: router, themes, locale, localization and lock-on-resume.
class LoanManagerApp extends ConsumerStatefulWidget {
  const LoanManagerApp({super.key});

  @override
  ConsumerState<LoanManagerApp> createState() => _LoanManagerAppState();
}

class _LoanManagerAppState extends ConsumerState<LoanManagerApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final auth = ref.read(authProvider.notifier);
    switch (state) {
      case AppLifecycleState.paused:
        auth.appPaused();
      case AppLifecycleState.resumed:
        auth.appResumed();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
