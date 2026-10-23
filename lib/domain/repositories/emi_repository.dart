import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/domain/entities/emi_schedule.dart';
import 'package:loan_management_app/domain/entities/overdue_emi.dart';

/// Stores installments and records payments.
abstract interface class EmiRepository {
  /// The loan's installments in order.
  Stream<List<EmiSchedule>> watchSchedule(String loanId);

  /// Pays the whole installment in ONE transaction: updates the installment,
  /// adds a ledger credit and, if it was the last one, completes the loan.
  ///
  /// Fails with an already-paid failure if it is paid, with an out-of-order
  /// failure if an earlier installment is unpaid (unless [allowOutOfOrder]),
  /// and with a not-found failure if it does not exist.
  Future<Result<void>> markPaid({
    required String emiId,
    required DateTime paidDate,
    required DateTime at,
    bool allowOutOfOrder = false,
  });

  /// Pending installments due before [today], oldest first.
  Stream<List<OverdueEmi>> watchOverdue({required DateTime today});
}
