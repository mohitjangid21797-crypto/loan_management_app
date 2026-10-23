import 'package:flutter/material.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/domain/enums/emi_status.dart';

/// Small coloured label: Paid, Pending or Overdue. The text always carries
/// the meaning, so colour is never the only signal.
class EmiStatusChip extends StatelessWidget {
  const EmiStatusChip({required this.status, super.key});

  final EmiStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final (label, background, foreground) = switch (status) {
      EmiStatus.paid => (
        l10n.emiStatusPaid,
        colors.primaryContainer,
        colors.onPrimaryContainer,
      ),
      EmiStatus.pending => (
        l10n.emiStatusPending,
        colors.surfaceContainerHighest,
        colors.onSurface,
      ),
      EmiStatus.overdue => (
        l10n.emiStatusOverdue,
        colors.errorContainer,
        colors.onErrorContainer,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: context.textStyles.labelMedium?.copyWith(color: foreground),
      ),
    );
  }
}
