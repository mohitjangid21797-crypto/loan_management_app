import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/presentation/providers/auth_provider.dart';
import 'package:loan_management_app/presentation/widgets/mpin_pad.dart';
import 'package:loan_management_app/presentation/widgets/new_mpin_form.dart';

/// Change the MPIN: confirm the current one, then choose a new one.
class ChangeMpinScreen extends ConsumerStatefulWidget {
  const ChangeMpinScreen({super.key});

  @override
  ConsumerState<ChangeMpinScreen> createState() => _ChangeMpinScreenState();
}

class _ChangeMpinScreenState extends ConsumerState<ChangeMpinScreen> {
  final _padKey = GlobalKey<MpinPadState>();
  bool _verified = false;
  String? _error;

  Future<void> _verifyOld(String mpin) async {
    final result = await ref.read(authRepositoryProvider).verifyMpin(mpin);
    if (!mounted) {
      return;
    }
    final attempt = result.valueOrNull;
    if (attempt != null && attempt.success) {
      setState(() => _verified = true);
      return;
    }
    _padKey.currentState?.clear(shake: true);
    setState(() {
      _error = attempt == null
          ? context.l10n.errorGeneric
          : attempt.lockedUntil != null
          ? context.l10n.mpinTooManyAttempts
          : context.l10n.mpinWrong(attempt.remainingAttempts);
    });
  }

  Future<Failure?> _saveNew(String mpin) async {
    final result = await ref.read(authRepositoryProvider).setMpin(mpin);
    final failure = result.failureOrNull;
    if (failure == null && mounted) {
      context.showSnack(context.l10n.mpinChanged);
      context.pop();
    }
    return failure;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final length = ref.watch(mpinLengthProvider).valueOrNull ?? 4;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.changeMpinTitle)),
      body: SafeArea(
        child: _verified
            ? NewMpinForm(onSubmit: _saveNew)
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        l10n.mpinCurrentPrompt,
                        style: context.textStyles.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Semantics(
                        liveRegion: true,
                        child: SizedBox(
                          height: 48,
                          child: _error == null
                              ? null
                              : Text(
                                  _error!,
                                  style: TextStyle(color: context.colors.error),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      MpinPad(
                        key: _padKey,
                        length: length,
                        onCompleted: _verifyOld,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
