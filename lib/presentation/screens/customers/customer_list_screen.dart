import 'package:flutter/material.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/presentation/widgets/empty_state.dart';

/// Placeholder; customer management is built in Phase 2.
class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navCustomers)),
      body: EmptyState(
        icon: Icons.people_outline,
        message: l10n.comingSoon,
      ),
    );
  }
}
