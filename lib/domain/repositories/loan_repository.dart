import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/domain/entities/dashboard_stats.dart';
import 'package:loan_management_app/domain/entities/emi_schedule.dart';
import 'package:loan_management_app/domain/entities/loan.dart';
import 'package:loan_management_app/domain/enums/loan_status.dart';

/// Stores loans. Implementations make multi-step writes atomic.
abstract interface class LoanRepository {
  /// Loans, newest first, optionally only one [status] and/or one customer.
  Stream<List<Loan>> watchLoans({LoanStatus? status, String? customerId});

  /// Emits the loan whenever it changes; null if it does not exist.
  Stream<Loan?> watchLoan(String id);

  /// Fails with a not-found failure for a missing loan.
  Future<Result<Loan>> getLoan(String id);

  /// Saves [loan], all of [schedule], and the disbursement ledger entry in
  /// ONE transaction. If any step fails, nothing is written. Fails with a
  /// not-found failure if the customer is missing or deleted.
  Future<Result<void>> createLoan(Loan loan, List<EmiSchedule> schedule);

  /// Marks the loan completed. Fails with a loan-not-paid failure while any
  /// installment is still pending. (Paying the last installment completes the
  /// loan automatically; this is for explicit checks.)
  Future<Result<void>> closeLoan(String id, {required DateTime at});

  /// Dashboard numbers as of [today], updated when loans or installments
  /// change.
  Stream<DashboardStats> watchDashboardStats({required DateTime today});
}
