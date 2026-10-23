import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/data/repositories/loan_repository_impl.dart';
import 'package:loan_management_app/domain/entities/customer.dart';
import 'package:loan_management_app/domain/entities/loan.dart';
import 'package:loan_management_app/domain/enums/loan_status.dart';
import 'package:loan_management_app/domain/repositories/loan_repository.dart';
import 'package:loan_management_app/domain/usecases/emi/generate_schedule.dart';
import 'package:loan_management_app/domain/usecases/loan/close_loan.dart';
import 'package:loan_management_app/domain/usecases/loan/create_loan.dart';
import 'package:loan_management_app/domain/usecases/loan/get_loan_detail.dart';
import 'package:loan_management_app/domain/usecases/loan/get_loans.dart';
import 'package:loan_management_app/presentation/providers/customer_provider.dart';
import 'package:loan_management_app/presentation/providers/database_provider.dart';

final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  return LoanRepositoryImpl(ref.watch(databaseProvider));
});

final createLoanProvider = Provider<CreateLoan>((ref) {
  return CreateLoan(ref.watch(loanRepositoryProvider), GenerateSchedule());
});

final getLoansProvider = Provider<GetLoans>((ref) {
  return GetLoans(ref.watch(loanRepositoryProvider));
});

final getLoanDetailProvider = Provider<GetLoanDetail>((ref) {
  return GetLoanDetail(ref.watch(loanRepositoryProvider));
});

final closeLoanProvider = Provider<CloseLoan>((ref) {
  return CloseLoan(ref.watch(loanRepositoryProvider));
});

/// Loans with one status, newest first (the Active / Completed tabs).
final loansByStatusProvider = StreamProvider.autoDispose
    .family<List<Loan>, LoanStatus>((ref, status) {
      return ref.watch(getLoansProvider)(status: status);
    });

/// All loans of one customer, newest first.
final customerLoansProvider = StreamProvider.autoDispose
    .family<List<Loan>, String>((ref, customerId) {
      return ref.watch(getLoansProvider)(customerId: customerId);
    });

/// One loan by id; emits null if it does not exist.
final loanDetailProvider = StreamProvider.autoDispose.family<Loan?, String>((
  ref,
  loanId,
) {
  return ref.watch(getLoanDetailProvider)(loanId);
});

/// Every customer, for the customer picker on the loan form.
final customerPickerProvider = StreamProvider.autoDispose<List<Customer>>((
  ref,
) {
  return ref.watch(getCustomersProvider)();
});
