import 'package:flutter/material.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/presentation/widgets/empty_state.dart';

/// Placeholder; the dashboard is built in Phase 3.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDashboard)),
      body: EmptyState(
        icon: Icons.dashboard_outlined,
        message: l10n.comingSoon,
      ),
    );
  }
}
