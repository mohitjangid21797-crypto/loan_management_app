import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/domain/repositories/customer_repository.dart';

/// Soft-deletes a customer unless they still have an active loan.
class DeleteCustomer {
  DeleteCustomer(this._repository, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final CustomerRepository _repository;
  final DateTime Function() _now;

  /// Fails with [ActiveLoanFailure] while an active loan exists.
  Future<Result<void>> call(String id) {
    return _repository.deleteCustomer(id, at: _now());
  }
}
