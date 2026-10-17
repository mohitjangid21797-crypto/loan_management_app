import 'package:flutter/material.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/presentation/widgets/empty_state.dart';

/// Placeholder; loans are built in Phase 3.
class LoanListScreen extends StatelessWidget {
  const LoanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navLoans)),
      body: EmptyState(
        icon: Icons.account_balance_wallet_outlined,
        message: l10n.comingSoon,
      ),
    );
  }
}
