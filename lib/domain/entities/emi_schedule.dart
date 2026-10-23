import 'package:equatable/equatable.dart';
import 'package:loan_management_app/core/utils/date_utils.dart';
import 'package:loan_management_app/domain/enums/emi_status.dart';

/// One installment of a loan.
class EmiSchedule extends Equatable {
  const EmiSchedule({
    required this.id,
    required this.loanId,
    required this.installmentNo,
    required this.dueDate,
    required this.principalPartPaise,
    required this.interestPartPaise,
    required this.emiPaise,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.paidPaise = 0,
    this.paidDate,
  });

  final String id;
  final String loanId;

  /// 1-based; unique within a loan.
  final int installmentNo;
  final DateTime dueDate;
  final int principalPartPaise;
  final int interestPartPaise;
  final int emiPaise;
  final int paidPaise;
  final DateTime? paidDate;

  /// Stored status: only [EmiStatus.pending] or [EmiStatus.paid].
  final EmiStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isPaid => status == EmiStatus.paid;

  /// The one overdue rule: still pending and due before [today].
  bool isOverdueOn(DateTime today) {
    return !isPaid && AppDateUtils.isOverdue(dueDate, today: today);
  }

  /// Status to show: [EmiStatus.overdue] if [isOverdueOn], else the stored one.
  EmiStatus statusOn(DateTime today) {
    return isOverdueOn(today) ? EmiStatus.overdue : status;
  }

  @override
  List<Object?> get props => [
    id,
    loanId,
    installmentNo,
    dueDate,
    principalPartPaise,
    interestPartPaise,
    emiPaise,
    paidPaise,
    paidDate,
    status,
    createdAt,
    updatedAt,
  ];
}
