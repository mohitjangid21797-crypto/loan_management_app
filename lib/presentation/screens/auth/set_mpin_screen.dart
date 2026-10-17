import 'package:flutter/material.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/presentation/widgets/empty_state.dart';

/// Placeholder; the real MPIN setup is built in Phase 1.
class SetMpinScreen extends StatelessWidget {
  const SetMpinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.setMpinTitle)),
      body: EmptyState(
        icon: Icons.lock_outline,
        message: l10n.setMpinPlaceholder,
      ),
    );
  }
}
