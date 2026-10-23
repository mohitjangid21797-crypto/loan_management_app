import 'package:loan_management_app/domain/entities/loan.dart';
import 'package:loan_management_app/domain/enums/loan_status.dart';
import 'package:loan_management_app/domain/repositories/loan_repository.dart';

/// Streams loans, newest first, optionally filtered.
class GetLoans {
  const GetLoans(this._repository);

  final LoanRepository _repository;

  Stream<List<Loan>> call({LoanStatus? status, String? customerId}) {
    return _repository.watchLoans(status: status, customerId: customerId);
  }
}
