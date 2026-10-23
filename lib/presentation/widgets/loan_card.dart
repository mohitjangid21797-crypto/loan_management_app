import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/extensions/num_extensions.dart';
import 'package:loan_management_app/domain/entities/loan.dart';
import 'package:loan_management_app/domain/enums/loan_status.dart';
import 'package:loan_management_app/domain/enums/loan_type.dart';
import 'package:loan_management_app/presentation/providers/customer_provider.dart';

/// One row in a loan list. [showCustomer] adds the customer's name.
class LoanCard extends ConsumerWidget {
  const LoanCard({
    required this.loan,
    required this.onTap,
    this.showCustomer = true,
    super.key,
  });

  final Loan loan;
  final VoidCallback onTap;
  final bool showCustomer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final name = showCustomer
        ? ref.watch(customerDetailProvider(loan.customerId)).valueOrNull?.name
        : null;
    final typeLabel = loan.type == LoanType.simple
        ? l10n.loanTypeSimple
        : l10n.loanTypeCompound;
    final statusLabel = loan.status == LoanStatus.active
        ? l10n.loanStatusActive
        : l10n.loanStatusCompleted;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        minVerticalPadding: 12,
        onTap: onTap,
        title: Text(
          name ?? context.money(loan.principalPaise),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          [
            if (name != null) context.money(loan.principalPaise),
            '$typeLabel · ${l10n.loanRateValue(loan.annualRatePercent.rateText)}',
            '${l10n.loanEmiLabel}: ${context.money(loan.emiPaise)}',
          ].join('\n'),
        ),
        isThreeLine: true,
        trailing: Text(statusLabel, style: context.textStyles.labelMedium),
      ),
    );
  }
}
