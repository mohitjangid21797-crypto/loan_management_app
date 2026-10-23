import 'package:flutter/material.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/domain/entities/emi_schedule.dart';
import 'package:loan_management_app/presentation/widgets/emi_status_chip.dart';

/// One installment: number, due (or paid) date, amount, status and, while it
/// is unpaid, a Mark paid button.
class EmiListTile extends StatelessWidget {
  const EmiListTile({
    required this.emi,
    required this.today,
    this.onMarkPaid,
    super.key,
  });

  final EmiSchedule emi;

  /// The date used to decide whether the installment is overdue.
  final DateTime today;

  /// Shown only for unpaid installments.
  final VoidCallback? onMarkPaid;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final paidDate = emi.paidDate;
    final dateText = emi.isPaid && paidDate != null
        ? l10n.emiPaidOn(context.formatDate(paidDate))
        : l10n.emiDueOn(context.formatDate(emi.dueDate));
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.emiInstallment(emi.installmentNo),
                    style: context.textStyles.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(dateText, style: context.textStyles.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    context.money(emi.emiPaise),
                    style: context.textStyles.bodyLarge,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                EmiStatusChip(status: emi.statusOn(today)),
                if (!emi.isPaid && onMarkPaid != null) ...[
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: onMarkPaid,
                    child: Text(l10n.emiMarkPaid),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
