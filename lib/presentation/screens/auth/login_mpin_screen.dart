import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/presentation/providers/auth_provider.dart';
import 'package:loan_management_app/presentation/providers/settings_provider.dart';
import 'package:loan_management_app/presentation/widgets/error_view.dart';
import 'package:loan_management_app/presentation/widgets/mpin_pad.dart';

/// Unlocks the app with the MPIN, or with biometrics when enabled.
class LoginMpinScreen extends ConsumerStatefulWidget {
  const LoginMpinScreen({super.key});

  @override
  ConsumerState<LoginMpinScreen> createState() => _LoginMpinScreenState();
}

class _LoginMpinScreenState extends ConsumerState<LoginMpinScreen> {
  final _padKey = GlobalKey<MpinPadState>();
  Timer? _ticker;
  DateTime? _lockedUntil;
  String? _error;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    final lockout = await ref.read(authRepositoryProvider).getLockoutUntil();
    final available = await ref.read(biometricServiceProvider).isAvailable();
    if (!mounted) {
      return;
    }
    setState(() => _biometricAvailable = available);
    final until = lockout.valueOrNull;
    if (until != null) {
      _startLockout(until);
    }
    if (available && ref.read(settingsProvider).biometricEnabled) {
      await _tryBiometric();
    }
  }

  void _startLockout(DateTime until) {
    _ticker?.cancel();
    setState(() {
      _lockedUntil = until;
      _error = null;
    });
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!DateTime.now().isBefore(until)) {
        _ticker?.cancel();
      }
      if (mounted) {
        setState(() {
          if (!DateTime.now().isBefore(until)) {
            _lockedUntil = null;
          }
        });
      }
    });
  }

  Future<void> _tryBiometric() async {
    await ref
        .read(authProvider.notifier)
        .unlockWithBiometric(reason: context.l10n.biometricReason);
  }

  Future<void> _onCompleted(String mpin) async {
    final attempt = await ref.read(authProvider.notifier).unlockWithMpin(mpin);
    if (!mounted || (attempt?.success ?? false)) {
      return;
    }
    _padKey.currentState?.clear(shake: true);
    if (attempt == null) {
      setState(() => _error = context.l10n.errorGeneric);
    } else if (attempt.lockedUntil != null) {
      _startLockout(attempt.lockedUntil!);
    } else {
      setState(() {
        _error = context.l10n.mpinWrong(attempt.remainingAttempts);
      });
    }
  }

  String _format(Duration remaining) {
    final total = remaining.inSeconds < 0 ? 0 : remaining.inSeconds + 1;
    final minutes = (total ~/ 60).toString();
    final seconds = (total % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final length = ref.watch(mpinLengthProvider);
    final biometricEnabled = ref.watch(
      settingsProvider.select((s) => s.biometricEnabled),
    );
    final remaining = _lockedUntil?.difference(DateTime.now());
    final lockedFor = remaining != null && remaining > Duration.zero
        ? remaining
        : null;
    final locked = lockedFor != null;
    final message = lockedFor != null
        ? l10n.mpinLockedOut(_format(lockedFor))
        : _error;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loginTitle),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: length.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => ErrorView(
            message: l10n.errorDatabase,
            onRetry: () => ref.invalidate(mpinLengthProvider),
          ),
          data: (digits) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 48,
                    color: context.colors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.loginPrompt,
                    style: context.textStyles.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Semantics(
                    liveRegion: true,
                    child: SizedBox(
                      height: 48,
                      child: message == null
                          ? null
                          : Text(
                              message,
                              style: TextStyle(color: context.colors.error),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MpinPad(
                    key: _padKey,
                    length: digits,
                    enabled: !locked,
                    onCompleted: _onCompleted,
                    onBiometric: biometricEnabled && _biometricAvailable
                        ? _tryBiometric
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
