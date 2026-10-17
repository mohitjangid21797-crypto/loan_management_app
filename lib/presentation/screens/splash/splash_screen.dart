import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/presentation/providers/auth_provider.dart';
import 'package:loan_management_app/presentation/widgets/error_view.dart';

/// Shown while the app reads whether an MPIN exists. The router moves on as
/// soon as [authProvider] resolves; this screen only handles the failure case.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final auth = ref.watch(authProvider);

    if (auth.hasError) {
      return Scaffold(
        body: ErrorView(
          message: l10n.errorDatabase,
          onRetry: () => ref.invalidate(authProvider),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.account_balance,
                  size: 72,
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.appName,
                style: context.textStyles.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.splashTagline,
                style: context.textStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CircularProgressIndicator(semanticsLabel: l10n.splashLoading),
            ],
          ),
        ),
      ),
    );
  }
}
