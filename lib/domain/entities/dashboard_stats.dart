import 'package:equatable/equatable.dart';

/// The numbers shown on the dashboard. Amounts are integer paise.
class DashboardStats extends Equatable {
  const DashboardStats({
    required this.totalDisbursedPaise,
    required this.interestEarnedPaise,
    required this.activeLoanCount,
    required this.overdueCount,
    required this.monthDuePaise,
  });

  static const DashboardStats zero = DashboardStats(
    totalDisbursedPaise: 0,
    interestEarnedPaise: 0,
    activeLoanCount: 0,
    overdueCount: 0,
    monthDuePaise: 0,
  );

  /// Sum of all loan principals ever given.
  final int totalDisbursedPaise;

  /// Sum of the interest parts of installments that have been paid.
  final int interestEarnedPaise;
  final int activeLoanCount;

  /// Pending installments whose due date is before today.
  final int overdueCount;

  /// Unpaid installments due in the current calendar month.
  final int monthDuePaise;

  @override
  List<Object?> get props => [
    totalDisbursedPaise,
    interestEarnedPaise,
    activeLoanCount,
    overdueCount,
    monthDuePaise,
  ];
}
