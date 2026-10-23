import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/extensions/num_extensions.dart';
import 'package:loan_management_app/core/router/route_names.dart';
import 'package:loan_management_app/core/utils/date_utils.dart';
import 'package:loan_management_app/domain/entities/emi_schedule.dart';
import 'package:loan_management_app/domain/entities/loan.dart';
import 'package:loan_management_app/domain/enums/loan_status.dart';
import 'package:loan_management_app/domain/enums/loan_type.dart';
import 'package:loan_management_app/presentation/providers/customer_provider.dart';
import 'package:loan_management_app/presentation/providers/emi_provider.dart';
import 'package:loan_management_app/presentation/providers/loan_provider.dart';
import 'package:loan_management_app/presentation/widgets/emi_list_tile.dart';
import 'package:loan_management_app/presentation/widgets/empty_state.dart';
import 'package:loan_management_app/presentation/widgets/error_view.dart';
import 'package:loan_management_app/presentation/widgets/mark_paid_flow.dart';

/// Loan summary, repayment progress and the next installment.
class LoanDetailScreen extends ConsumerWidget {
  const LoanDetailScreen({required this.loanId, super.key});

  final String loanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final loan = ref.watch(loanDetailProvider(loanId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.loanDetailTitle)),
      body: loan.when(
        data: (data) => data == null
            ? EmptyState(
                icon: Icons.account_balance_wallet_outlined,
                message: l10n.loanNotFound,
              )
            : _Body(loan: data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorDatabase,
          onRetry: () => ref.invalidate(loanDetailProvider(loanId)),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.loan});

  final Loan loan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final schedule = ref.watch(emiScheduleProvider(loan.id)).valueOrNull ?? [];
    final paid = schedule.where((emi) => emi.isPaid).length;
    final next = schedule.where((emi) => !emi.isPaid).firstOrNull;
    final customer = ref
        .watch(customerDetailProvider(loan.customerId))
        .valueOrNull;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        _Summary(loan: loan, customerName: customer?.name),
        if (schedule.isNotEmpty) _Progress(paid: paid, total: schedule.length),
        if (next != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              l10n.loanNextInstallment,
              style: context.textStyles.titleMedium,
            ),
          ),
          _NextInstallment(next: next),
        ],
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton(
            onPressed: () =>
                context.push(RouteNames.loanSchedulePath(loan.id)),
            child: Text(l10n.loanViewSchedule),
          ),
        ),
      ],
    );
  }
}

class _NextInstallment extends ConsumerWidget {
  const _NextInstallment({required this.next});

  final EmiSchedule next;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EmiListTile(
      emi: next,
      today: AppDateUtils.today(),
      onMarkPaid: () => markEmiPaidFlow(context, ref, next),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.loan, required this.customerName});

  final Loan loan;
  final String? customerName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = customerName;
    final rows = <(String, String)>[
      (l10n.loanPrincipal, context.money(loan.principalPaise)),
      (
        l10n.loanRate,
        l10n.loanRateValue(loan.annualRatePercent.rateText),
      ),
      (l10n.loanTenure, l10n.loanTenureValue(loan.tenureMonths)),
      (
        l10n.loanTypeLabel,
        loan.type == LoanType.simple
            ? l10n.loanTypeSimple
            : l10n.loanTypeCompound,
      ),
      (l10n.loanStartDateLabel, context.formatDate(loan.startDate)),
      (l10n.loanEmiLabel, context.money(loan.emiPaise)),
      (l10n.loanTotalInterest, context.money(loan.totalInterestPaise)),
      (l10n.loanTotalPayable, context.money(loan.totalPayablePaise)),
    ];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (name != null)
              Text(name, style: context.textStyles.titleLarge),
            Text(
              loan.status == LoanStatus.active
                  ? l10n.loanStatusActive
                  : l10n.loanStatusCompleted,
              style: context.textStyles.labelLarge?.copyWith(
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: 12),
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text(label)),
                    const SizedBox(width: 12),
                    Text(value, style: context.textStyles.titleSmall),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.paid, required this.total});

  final int paid;
  final int total;

  @override
  Widget build(BuildContext context) {
    final text = context.l10n.loanProgress(paid, total);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: context.textStyles.bodyMedium),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: total == 0 ? 0 : paid / total,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            semanticsLabel: text,
          ),
        ],
      ),
    );
  }
}
