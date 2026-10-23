import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/router/route_names.dart';
import 'package:loan_management_app/domain/enums/loan_status.dart';
import 'package:loan_management_app/presentation/providers/loan_provider.dart';
import 'package:loan_management_app/presentation/widgets/empty_state.dart';
import 'package:loan_management_app/presentation/widgets/error_view.dart';
import 'package:loan_management_app/presentation/widgets/loan_card.dart';

/// All loans, in Active and Completed tabs.
class LoanListScreen extends StatelessWidget {
  const LoanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.navLoans),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.loansTabActive),
              Tab(text: l10n.loansTabCompleted),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: l10n.loanAdd,
          onPressed: () => context.push(RouteNames.loanAddPath),
          child: const Icon(Icons.add),
        ),
        body: const TabBarView(
          children: [
            _LoanTab(status: LoanStatus.active),
            _LoanTab(status: LoanStatus.completed),
          ],
        ),
      ),
    );
  }
}

class _LoanTab extends ConsumerWidget {
  const _LoanTab({required this.status});

  final LoanStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final loans = ref.watch(loansByStatusProvider(status));
    return loans.when(
      data: (list) {
        if (list.isEmpty) {
          return EmptyState(
            icon: Icons.account_balance_wallet_outlined,
            message: status == LoanStatus.active
                ? l10n.loansEmptyActive
                : l10n.loansEmptyCompleted,
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 88),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final loan = list[index];
            return LoanCard(
              key: ValueKey(loan.id),
              loan: loan,
              onTap: () => context.push(RouteNames.loanDetailPath(loan.id)),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorView(
        message: l10n.errorDatabase,
        onRetry: () => ref.invalidate(loansByStatusProvider(status)),
      ),
    );
  }
}
