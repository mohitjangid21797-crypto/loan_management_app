import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/utils/date_utils.dart';
import 'package:loan_management_app/domain/entities/emi_schedule.dart';
import 'package:loan_management_app/presentation/providers/emi_provider.dart';
import 'package:loan_management_app/presentation/widgets/confirm_dialog.dart';

/// Asks for the payment date, asks the user to confirm, then records the
/// payment and shows the result in a snackbar. Does nothing if cancelled.
Future<void> markEmiPaidFlow(
  BuildContext context,
  WidgetRef ref,
  EmiSchedule emi,
) async {
  final l10n = context.l10n;
  final today = AppDateUtils.today();
  final picked = await showDatePicker(
    context: context,
    helpText: l10n.emiPaymentDate,
    initialDate: today,
    firstDate: DateTime(2000),
    lastDate: DateTime(today.year + 1, today.month, today.day),
  );
  if (picked == null || !context.mounted) {
    return;
  }
  final confirmed = await showConfirmDialog(
    context,
    title: l10n.emiMarkPaidTitle,
    message: l10n.emiMarkPaidMessage(
      context.money(emi.emiPaise),
      context.formatDate(picked),
    ),
    confirmLabel: l10n.emiMarkPaid,
  );
  if (!confirmed || !context.mounted) {
    return;
  }
  final result = await ref.read(markEmiPaidProvider)(emi.id, picked);
  if (!context.mounted) {
    return;
  }
  final failure = result.failureOrNull;
  context.showSnack(
    failure == null ? l10n.emiMarkedPaid : failure.message(l10n),
  );
}
