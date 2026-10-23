import 'package:flutter/material.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/utils/emi_calculator.dart';

/// Live summary of a loan before it is saved, from its planned schedule.
class EmiPreviewCard extends StatelessWidget {
  const EmiPreviewCard({required this.schedule, super.key});

  final List<Installment> schedule;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final first = schedule.first;
    final last = schedule.last;
    return Card(
      color: context.colors.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.loanPreviewTitle, style: context.textStyles.titleMedium),
            const SizedBox(height: 12),
            _Line(label: l10n.loanEmiLabel, value: context.money(first.emi)),
            _Line(
              label: l10n.loanTotalInterest,
              value: context.money(EmiCalculator.totalInterest(schedule)),
            ),
            _Line(
              label: l10n.loanTotalPayable,
              value: context.money(EmiCalculator.totalPayable(schedule)),
            ),
            if (last.emi != first.emi) ...[
              const SizedBox(height: 8),
              Text(
                l10n.loanLastEmiNote(context.money(last.emi)),
                style: context.textStyles.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label)),
          const SizedBox(width: 12),
          Text(value, style: context.textStyles.titleSmall),
        ],
      ),
    );
  }
}
