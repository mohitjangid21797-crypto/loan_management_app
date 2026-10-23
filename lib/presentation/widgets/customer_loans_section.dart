import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/router/route_names.dart';
import 'package:loan_management_app/presentation/providers/loan_provider.dart';
import 'package:loan_management_app/presentation/widgets/loan_card.dart';

/// The Loans part of the customer detail page, with a New loan button.
class CustomerLoansSection extends ConsumerWidget {
  const CustomerLoansSection({required this.customerId, super.key});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final loans = ref.watch(customerLoansProvider(customerId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.customerLoansTitle,
                style: context.textStyles.titleMedium,
              ),
            ),
            TextButton.icon(
              onPressed: () =>
                  context.push(RouteNames.loanAddPathFor(customerId)),
              icon: const Icon(Icons.add),
              label: Text(l10n.customerNewLoan),
            ),
          ],
        ),
        loans.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text(l10n.errorDatabase),
          data: (list) {
            if (list.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(l10n.customerNoLoans),
              );
            }
            return Column(
              children: [
                for (final loan in list)
                  LoanCard(
                    key: ValueKey(loan.id),
                    loan: loan,
                    showCustomer: false,
                    onTap: () =>
                        context.push(RouteNames.loanDetailPath(loan.id)),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
