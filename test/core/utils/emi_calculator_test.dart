import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/core/utils/emi_calculator.dart';
import 'package:loan_management_app/domain/enums/loan_type.dart';

List<Installment> _schedule(
  int principal,
  double rate,
  int months,
  LoanType type, {
  DateTime? start,
}) {
  return EmiCalculator.generateSchedule(
    principalPaise: principal,
    annualRatePercent: rate,
    tenureMonths: months,
    startDate: start ?? DateTime.utc(2026, 1, 15),
    type: type,
  );
}

/// The schedule must add up exactly and end at zero.
void _expectConsistent(List<Installment> rows, int principal) {
  expect(rows.fold<int>(0, (sum, r) => sum + r.principalPart), principal);
  expect(rows.last.remainingBalance, 0);
  for (final row in rows) {
    expect(row.emi, row.principalPart + row.interestPart);
  }
  expect(
    EmiCalculator.totalPayable(rows),
    principal + EmiCalculator.totalInterest(rows),
  );
}

void main() {
  group('reducing balance (compound)', () {
    test('12 months at 12% on 1,00,000.00', () {
      final rows = _schedule(10000000, 12, 12, LoanType.compound);
      expect(rows, hasLength(12));
      expect(rows.first.emi, 888488);
      expect(rows.first.interestPart, 100000);
      expect(rows.first.principalPart, 788488);
      expect(rows.first.remainingBalance, 9211512);
      expect(rows.last.emi, 888485);
      expect(EmiCalculator.totalInterest(rows), 661853);
      expect(EmiCalculator.totalPayable(rows), 10661853);
      _expectConsistent(rows, 10000000);
    });

    test('calculateEmi matches the first installment', () {
      final emi = EmiCalculator.calculateEmi(
        principalPaise: 10000000,
        annualRatePercent: 12,
        tenureMonths: 12,
        type: LoanType.compound,
      );
      expect(emi, 888488);
    });

    test('zero rate splits the principal and puts the rest in the last', () {
      final rows = _schedule(10000000, 0, 12, LoanType.compound);
      expect(rows.first.emi, 833333);
      expect(rows.last.emi, 833337);
      expect(EmiCalculator.totalInterest(rows), 0);
      _expectConsistent(rows, 10000000);
    });

    test('one month tenure pays principal plus one month of interest', () {
      final rows = _schedule(10000000, 12, 1, LoanType.compound);
      expect(rows, hasLength(1));
      expect(rows.single.emi, 10100000);
      expect(rows.single.interestPart, 100000);
      _expectConsistent(rows, 10000000);
    });

    test('24 months at 18%', () {
      final rows = _schedule(10000000, 18, 24, LoanType.compound);
      expect(rows, hasLength(24));
      expect(rows.first.emi, 499241);
      expect(rows.last.emi, 499240);
      expect(EmiCalculator.totalPayable(rows), 11981783);
      _expectConsistent(rows, 10000000);
    });

    test('60 months at 10.5% on 50,000.00', () {
      final rows = _schedule(5000000, 10.5, 60, LoanType.compound);
      expect(rows, hasLength(60));
      expect(rows.first.emi, 107470);
      expect(rows.last.emi, 107435);
      expect(EmiCalculator.totalPayable(rows), 6448165);
      _expectConsistent(rows, 10000000 ~/ 2);
    });

    test('rounding leftover lands in the last installment', () {
      final rows = _schedule(100000, 12, 3, LoanType.compound);
      expect(rows.map((r) => r.emi), [34002, 34002, 34003]);
      expect(EmiCalculator.totalPayable(rows), 102007);
      _expectConsistent(rows, 100000);
    });

    test('interest falls and principal rises as the balance shrinks', () {
      final rows = _schedule(10000000, 12, 12, LoanType.compound);
      for (var i = 1; i < rows.length - 1; i++) {
        expect(rows[i].interestPart, lessThan(rows[i - 1].interestPart));
        expect(rows[i].principalPart, greaterThan(rows[i - 1].principalPart));
      }
    });
  });

  group('simple interest', () {
    test('12 months at 12% on 1,00,000.00', () {
      final rows = _schedule(10000000, 12, 12, LoanType.simple);
      expect(rows.first.emi, 933333);
      expect(rows.first.interestPart, 100000);
      expect(rows.last.emi, 933337);
      expect(EmiCalculator.totalInterest(rows), 1200000);
      expect(EmiCalculator.totalPayable(rows), 11200000);
      _expectConsistent(rows, 10000000);
    });

    test('whole-rupee result needs no leftover', () {
      final rows = _schedule(10000000, 12, 5, LoanType.simple);
      expect(rows.map((r) => r.emi).toSet(), {2100000});
      expect(EmiCalculator.totalPayable(rows), 10500000);
    });

    test('odd principal keeps the schedule exact', () {
      final rows = _schedule(10000001, 12, 7, LoanType.simple);
      expect(rows.first.emi, 1528572);
      expect(rows.last.emi, 1528569);
      expect(EmiCalculator.totalPayable(rows), 10700001);
      _expectConsistent(rows, 10000001);
    });

    test('zero rate matches the reducing-balance zero-rate schedule', () {
      final simple = _schedule(10000000, 0, 12, LoanType.simple);
      final reducing = _schedule(10000000, 0, 12, LoanType.compound);
      expect(simple, reducing);
    });

    test('simple costs more interest than reducing for the same terms', () {
      final simple = _schedule(10000000, 12, 12, LoanType.simple);
      final reducing = _schedule(10000000, 12, 12, LoanType.compound);
      expect(
        EmiCalculator.totalInterest(simple),
        greaterThan(EmiCalculator.totalInterest(reducing)),
      );
    });
  });

  group('due dates', () {
    test('month-end is clamped without drifting (31 Jan start)', () {
      final rows = _schedule(
        1200000,
        12,
        4,
        LoanType.simple,
        start: DateTime.utc(2025, 1, 31),
      );
      expect(rows.map((r) => r.dueDate), [
        DateTime.utc(2025, 2, 28),
        DateTime.utc(2025, 3, 31),
        DateTime.utc(2025, 4, 30),
        DateTime.utc(2025, 5, 31),
      ]);
    });

    test('leap-year February keeps the 29th', () {
      final rows = _schedule(
        1200000,
        12,
        2,
        LoanType.compound,
        start: DateTime.utc(2024, 1, 31),
      );
      expect(rows.first.dueDate, DateTime.utc(2024, 2, 29));
      expect(rows.last.dueDate, DateTime.utc(2024, 3, 31));
    });

    test('the first due date is one month after the start date', () {
      final rows = _schedule(
        1200000,
        12,
        3,
        LoanType.compound,
        start: DateTime.utc(2026, 11, 20),
      );
      expect(rows.first.dueDate, DateTime.utc(2026, 12, 20));
      expect(rows.last.dueDate, DateTime.utc(2027, 2, 20));
    });

    test('a start time of day is dropped', () {
      final rows = _schedule(
        1200000,
        12,
        1,
        LoanType.compound,
        start: DateTime(2026, 3, 10, 18, 45),
      );
      expect(rows.single.dueDate, DateTime.utc(2026, 4, 10));
    });
  });

  group('invalid input', () {
    test('rejects bad principal, rate and tenure', () {
      expect(
        () => _schedule(0, 12, 12, LoanType.compound),
        throwsArgumentError,
      );
      expect(
        () => _schedule(1000, -1, 12, LoanType.compound),
        throwsArgumentError,
      );
      expect(
        () => _schedule(1000, 12, 0, LoanType.simple),
        throwsArgumentError,
      );
    });
  });
}
