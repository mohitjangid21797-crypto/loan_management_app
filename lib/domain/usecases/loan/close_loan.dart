import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/domain/repositories/loan_repository.dart';

/// Marks a loan completed once every installment is paid.
class CloseLoan {
  CloseLoan(this._repository, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final LoanRepository _repository;
  final DateTime Function() _now;

  /// Fails with a loan-not-paid failure while any installment is pending.
  Future<Result<void>> call(String loanId) {
    return _repository.closeLoan(loanId, at: _now());
  }
}
