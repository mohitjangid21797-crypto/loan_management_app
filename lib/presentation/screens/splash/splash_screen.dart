import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Phase 0 stub: go straight to the app. Phase 1 resolves the real state
    // (needsSetup, locked or unlocked) from secure storage.
    _timer = Timer(AppConstants.splashDuration, () {
      ref.read(authProvider.notifier).setStatus(AuthStatus.unlocked);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
