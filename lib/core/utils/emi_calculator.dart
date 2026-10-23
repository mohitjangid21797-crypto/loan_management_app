import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:loan_management_app/core/utils/date_utils.dart';
import 'package:loan_management_app/domain/enums/loan_type.dart';

/// One planned installment. All amounts are integer paise.
class Installment extends Equatable {
  const Installment({
    required this.number,
    required this.dueDate,
    required this.principalPart,
    required this.interestPart,
    required this.emi,
    required this.remainingBalance,
  });

  /// 1-based position in the schedule.
  final int number;
  final DateTime dueDate;
  final int principalPart;
  final int interestPart;

  /// Always [principalPart] + [interestPart].
  final int emi;

  /// Principal still owed after this installment is paid.
  final int remainingBalance;

  @override
  List<Object?> get props => [
    number,
    dueDate,
    principalPart,
    interestPart,
    emi,
    remainingBalance,
  ];
}

/// Pure loan math. Money is integer paise; the only floating point is the
/// intermediate maths, which is rounded to the nearest paisa straight away.
///
/// - [LoanType.compound]: reducing balance,
///   `EMI = P x r x (1+r)^n / ((1+r)^n - 1)` with `r = rate / 12 / 100`
///   (`P / n` when the rate is 0). Each row's interest is
///   `remainingBalance x r`.
/// - [LoanType.simple]: `interest = P x rate x (n / 12) / 100` and
///   `EMI = (P + interest) / n`, with interest and principal spread evenly.
///
/// In both cases each EMI is rounded to the nearest paisa and the leftover
/// goes into the last installment, so the schedule adds up exactly.
abstract final class EmiCalculator {
  /// The regular (first) monthly EMI in paise.
  static int calculateEmi({
    required int principalPaise,
    required double annualRatePercent,
    required int tenureMonths,
    required LoanType type,
  }) {
    _check(principalPaise, annualRatePercent, tenureMonths);
    return switch (type) {
      LoanType.simple => _simpleEmi(
        principalPaise,
        annualRatePercent,
        tenureMonths,
      ),
      LoanType.compound => _reducingEmi(
        principalPaise,
        annualRatePercent,
        tenureMonths,
      ),
    };
  }

  /// The full schedule. Installment `i` is due `i` months after [startDate],
  /// on the same day of the month, clamped to the month end.
  static List<Installment> generateSchedule({
    required int principalPaise,
    required double annualRatePercent,
    required int tenureMonths,
    required DateTime startDate,
    required LoanType type,
  }) {
    _check(principalPaise, annualRatePercent, tenureMonths);
    final start = AppDateUtils.utcMidnight(startDate);
    return switch (type) {
      LoanType.simple => _simpleSchedule(
        principalPaise,
        annualRatePercent,
        tenureMonths,
        start,
      ),
      LoanType.compound => _reducingSchedule(
        principalPaise,
        annualRatePercent,
        tenureMonths,
        start,
      ),
    };
  }

  /// Sum of the interest parts.
  static int totalInterest(List<Installment> schedule) {
    return schedule.fold(0, (sum, row) => sum + row.interestPart);
  }

  /// Sum of the EMIs: everything the customer will pay back.
  static int totalPayable(List<Installment> schedule) {
    return schedule.fold(0, (sum, row) => sum + row.emi);
  }

  static void _check(int principal, double rate, int months) {
    if (principal <= 0) {
      throw ArgumentError.value(principal, 'principalPaise', 'Must be > 0');
    }
    if (rate.isNaN || rate < 0) {
      throw ArgumentError.value(rate, 'annualRatePercent', 'Must be >= 0');
    }
    if (months < 1) {
      throw ArgumentError.value(months, 'tenureMonths', 'Must be >= 1');
    }
  }

  static int _simpleInterest(int principal, double rate, int months) {
    return (principal * rate * months / 1200).round();
  }

  static int _simpleEmi(int principal, double rate, int months) {
    final total = principal + _simpleInterest(principal, rate, months);
    return (total / months).round();
  }

  static int _reducingEmi(int principal, double rate, int months) {
    final r = rate / 1200;
    if (r == 0) {
      return (principal / months).round();
    }
    final growth = math.pow(1 + r, months).toDouble();
    return (principal * r * growth / (growth - 1)).round();
  }

  static List<Installment> _simpleSchedule(
    int principal,
    double rate,
    int months,
    DateTime start,
  ) {
    final interest = _simpleInterest(principal, rate, months);
    final emi = _simpleEmi(principal, rate, months);
    final regularInterest = interest ~/ months;
    final rows = <Installment>[];
    var balance = principal;
    var interestLeft = interest;
    for (var i = 1; i <= months; i++) {
      final last = i == months;
      final interestPart = last ? interestLeft : regularInterest;
      final principalPart = last ? balance : emi - interestPart;
      balance -= principalPart;
      interestLeft -= interestPart;
      rows.add(
        Installment(
          number: i,
          dueDate: AppDateUtils.addMonthsClamped(start, i),
          principalPart: principalPart,
          interestPart: interestPart,
          emi: principalPart + interestPart,
          remainingBalance: balance,
        ),
      );
    }
    return rows;
  }

  static List<Installment> _reducingSchedule(
    int principal,
    double rate,
    int months,
    DateTime start,
  ) {
    final r = rate / 1200;
    final emi = _reducingEmi(principal, rate, months);
    final rows = <Installment>[];
    var balance = principal;
    for (var i = 1; i <= months; i++) {
      final interestPart = (balance * r).round();
      final principalPart = i == months ? balance : emi - interestPart;
      balance -= principalPart;
      rows.add(
        Installment(
          number: i,
          dueDate: AppDateUtils.addMonthsClamped(start, i),
          principalPart: principalPart,
          interestPart: interestPart,
          emi: principalPart + interestPart,
          remainingBalance: balance,
        ),
      );
    }
    return rows;
  }
}
