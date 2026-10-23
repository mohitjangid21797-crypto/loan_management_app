import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/utils/date_utils.dart';
import 'package:loan_management_app/presentation/providers/emi_provider.dart';
import 'package:loan_management_app/presentation/widgets/emi_list_tile.dart';
import 'package:loan_management_app/presentation/widgets/error_view.dart';
import 'package:loan_management_app/presentation/widgets/mark_paid_flow.dart';

/// Every installment of a loan, with Mark paid on the one that is next.
class EmiScheduleScreen extends ConsumerWidget {
  const EmiScheduleScreen({required this.loanId, super.key});

  final String loanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final schedule = ref.watch(emiScheduleProvider(loanId));
    final today = AppDateUtils.today();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scheduleTitle)),
      body: schedule.when(
        data: (list) {
          final nextId = list.where((emi) => !emi.isPaid).firstOrNull?.id;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final emi = list[index];
              final canPay =
                  AppConstants.allowOutOfOrderPayments || emi.id == nextId;
              return EmiListTile(
                key: ValueKey(emi.id),
                emi: emi,
                today: today,
                onMarkPaid: canPay
                    ? () => markEmiPaidFlow(context, ref, emi)
                    : null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorDatabase,
          onRetry: () => ref.invalidate(emiScheduleProvider(loanId)),
        ),
      ),
    );
  }
}
