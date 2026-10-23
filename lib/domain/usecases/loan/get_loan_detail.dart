import 'package:loan_management_app/domain/entities/loan.dart';
import 'package:loan_management_app/domain/repositories/loan_repository.dart';

/// Streams one loan; emits null if it does not exist.
class GetLoanDetail {
  const GetLoanDetail(this._repository);

  final LoanRepository _repository;

  Stream<Loan?> call(String loanId) => _repository.watchLoan(loanId);
}
