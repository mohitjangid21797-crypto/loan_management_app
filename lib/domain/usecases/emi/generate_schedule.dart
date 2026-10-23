import 'package:equatable/equatable.dart';
import 'package:loan_management_app/core/utils/date_utils.dart';
import 'package:loan_management_app/core/utils/emi_calculator.dart';
import 'package:loan_management_app/domain/entities/emi_schedule.dart';
import 'package:loan_management_app/domain/entities/loan.dart';
import 'package:loan_management_app/domain/enums/emi_status.dart';
import 'package:loan_management_app/domain/enums/loan_status.dart';
import 'package:loan_management_app/domain/enums/loan_type.dart';
import 'package:uuid/uuid.dart';

/// A new loan and its installments, ready to be saved together.
class LoanPlan extends Equatable {
  const LoanPlan({required this.loan, required this.schedule});

  final Loan loan;
  final List<EmiSchedule> schedule;

  @override
  List<Object?> get props => [loan, schedule];
}

/// Builds a [LoanPlan] from the loan terms. Does not touch storage.
class GenerateSchedule {
  GenerateSchedule({String Function()? newId, DateTime Function()? now})
    : _newId = newId ?? (() => const Uuid().v4()),
      _now = now ?? DateTime.now;

  final String Function() _newId;
  final DateTime Function() _now;

  /// The terms must already be valid (see `Validators`); [startDate] is
  /// reduced to its calendar date.
  LoanPlan call({
    required String customerId,
    required int principalPaise,
    required double annualRatePercent,
    required int tenureMonths,
    required LoanType type,
    required DateTime startDate,
  }) {
    final start = AppDateUtils.utcMidnight(startDate);
    final installments = EmiCalculator.generateSchedule(
      principalPaise: principalPaise,
      annualRatePercent: annualRatePercent,
      tenureMonths: tenureMonths,
      startDate: start,
      type: type,
    );
    final now = _now();
    final loan = Loan(
      id: _newId(),
      customerId: customerId,
      type: type,
      principalPaise: principalPaise,
      annualRatePercent: annualRatePercent,
      tenureMonths: tenureMonths,
      startDate: start,
      emiPaise: installments.first.emi,
      totalInterestPaise: EmiCalculator.totalInterest(installments),
      status: LoanStatus.active,
      createdAt: now,
      updatedAt: now,
    );
    final schedule = [
      for (final row in installments)
        EmiSchedule(
          id: _newId(),
          loanId: loan.id,
          installmentNo: row.number,
          dueDate: row.dueDate,
          principalPartPaise: row.principalPart,
          interestPartPaise: row.interestPart,
          emiPaise: row.emi,
          status: EmiStatus.pending,
          createdAt: now,
          updatedAt: now,
        ),
    ];
    return LoanPlan(loan: loan, schedule: schedule);
  }
}
