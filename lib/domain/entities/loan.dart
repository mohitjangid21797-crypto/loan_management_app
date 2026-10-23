import 'package:equatable/equatable.dart';
import 'package:loan_management_app/domain/enums/loan_status.dart';
import 'package:loan_management_app/domain/enums/loan_type.dart';

/// A loan given to a customer. Rate and tenure never change after creation.
class Loan extends Equatable {
  const Loan({
    required this.id,
    required this.customerId,
    required this.type,
    required this.principalPaise,
    required this.annualRatePercent,
    required this.tenureMonths,
    required this.startDate,
    required this.emiPaise,
    required this.totalInterestPaise,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String customerId;
  final LoanType type;
  final int principalPaise;
  final double annualRatePercent;
  final int tenureMonths;
  final DateTime startDate;

  /// The regular monthly EMI. The last installment may differ by a few paise.
  final int emiPaise;
  final int totalInterestPaise;
  final LoanStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Everything the customer will pay back: principal plus interest.
  int get totalPayablePaise => principalPaise + totalInterestPaise;

  @override
  List<Object?> get props => [
    id,
    customerId,
    type,
    principalPaise,
    annualRatePercent,
    tenureMonths,
    startDate,
    emiPaise,
    totalInterestPaise,
    status,
    createdAt,
    updatedAt,
  ];
}
