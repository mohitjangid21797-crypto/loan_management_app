import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/core/utils/validators.dart';
import 'package:loan_management_app/domain/entities/loan.dart';
import 'package:loan_management_app/domain/enums/loan_type.dart';
import 'package:loan_management_app/domain/repositories/loan_repository.dart';
import 'package:loan_management_app/domain/usecases/emi/generate_schedule.dart';

/// Validates the terms, builds the schedule and saves everything at once.
class CreateLoan {
  CreateLoan(this._repository, this._generate);

  final LoanRepository _repository;
  final GenerateSchedule _generate;

  /// Returns the saved loan, or a [ValidationFailure], a not-found failure
  /// (unknown customer) or a storage failure.
  Future<Result<Loan>> call({
    required String customerId,
    required int principalPaise,
    required double annualRatePercent,
    required int tenureMonths,
    required LoanType type,
    required DateTime startDate,
  }) async {
    final invalid =
        Validators.amountPaise(principalPaise) ??
        Validators.ratePercent(annualRatePercent) ??
        Validators.tenureMonths(tenureMonths);
    if (invalid != null) {
      return Err(ValidationFailure(invalid));
    }
    final plan = _generate(
      customerId: customerId,
      principalPaise: principalPaise,
      annualRatePercent: annualRatePercent,
      tenureMonths: tenureMonths,
      type: type,
      startDate: startDate,
    );
    final failure = (await _repository.createLoan(
      plan.loan,
      plan.schedule,
    )).failureOrNull;
    return failure == null ? Success(plan.loan) : Err(failure);
  }
}
