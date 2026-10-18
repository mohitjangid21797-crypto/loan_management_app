import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/presentation/providers/auth_provider.dart';
import 'package:loan_management_app/presentation/widgets/new_mpin_form.dart';

/// First-run screen: the user creates an MPIN before anything else.
class SetMpinScreen extends ConsumerWidget {
  const SetMpinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setMpinTitle),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: NewMpinForm(
          onSubmit: ref.read(authProvider.notifier).completeSetup,
        ),
      ),
    );
  }
}
