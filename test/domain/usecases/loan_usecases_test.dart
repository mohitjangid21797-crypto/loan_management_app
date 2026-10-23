import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/utils/validators.dart';
import 'package:loan_management_app/domain/enums/emi_status.dart';
import 'package:loan_management_app/domain/enums/loan_status.dart';
import 'package:loan_management_app/domain/enums/loan_type.dart';
import 'package:loan_management_app/domain/usecases/emi/mark_emi_paid.dart';

import '../../helpers/loan_fixture.dart';

void main() {
  late LoanFixture f;

  setUp(() async => f = await LoanFixture.create());
  tearDown(() => f.close());

  Future<String> newLoan({
    int principal = 10000000,
    double rate = 12,
    int months = 12,
    LoanType type = LoanType.simple,
  }) async {
    final result = await f.createLoan(
      customerId: LoanFixture.customerId,
      principalPaise: principal,
      annualRatePercent: rate,
      tenureMonths: months,
      type: type,
      startDate: DateTime.utc(2026, 1, 15),
    );
    return result.valueOrNull!.id;
  }

  group('CreateLoan', () {
    test('a 12-month loan stores 12 rows summing to the total payable', () async {
      final id = await newLoan();
      final loan = (await f.loans.getLoan(id)).valueOrNull!;
      final rows = await f.db.emiDao.getByLoan(id);

      expect(rows, hasLength(12));
      expect(rows.map((r) => r.installmentNo), List.generate(12, (i) => i + 1));
      expect(
        rows.fold<int>(0, (sum, r) => sum + r.emiPaise),
        loan.totalPayablePaise,
      );
      expect(loan.totalPayablePaise, 11200000);
      expect(loan.status, LoanStatus.active);
      expect(rows.every((r) => r.status == 'pending'), isTrue);
    });

    test('writes one disbursement ledger entry for the amount owed', () async {
      await newLoan();
      final entries = await f.db.ledgerDao.entriesForCustomer(
        LoanFixture.customerId,
      );
      expect(entries, hasLength(1));
      expect(entries.single.type, 'disbursement');
      expect(entries.single.debitPaise, 11200000);
      expect(entries.single.balanceAfterPaise, 11200000);
    });

    test('rejects invalid terms without writing anything', () async {
      final result = await f.createLoan(
        customerId: LoanFixture.customerId,
        principalPaise: 0,
        annualRatePercent: 12,
        tenureMonths: 12,
        type: LoanType.simple,
        startDate: DateTime.utc(2026, 1, 15),
      );
      expect(
        result.failureOrNull,
        const ValidationFailure(ValidationError.amountInvalid),
      );
      expect(await f.db.select(f.db.loans).get(), isEmpty);
    });

    test('rejects a rate above 100 and a tenure above 600', () async {
      final rate = await f.createLoan(
        customerId: LoanFixture.customerId,
        principalPaise: 100000,
        annualRatePercent: 101,
        tenureMonths: 12,
        type: LoanType.compound,
        startDate: DateTime.utc(2026, 1, 15),
      );
      expect(
        rate.failureOrNull,
        const ValidationFailure(ValidationError.rateInvalid),
      );
      final tenure = await f.createLoan(
        customerId: LoanFixture.customerId,
        principalPaise: 100000,
        annualRatePercent: 12,
        tenureMonths: 601,
        type: LoanType.compound,
        startDate: DateTime.utc(2026, 1, 15),
      );
      expect(
        tenure.failureOrNull,
        const ValidationFailure(ValidationError.tenureInvalid),
      );
    });

    test('an unknown customer is not found and nothing is written', () async {
      final result = await f.createLoan(
        customerId: 'ghost',
        principalPaise: 100000,
        annualRatePercent: 12,
        tenureMonths: 3,
        type: LoanType.simple,
        startDate: DateTime.utc(2026, 1, 15),
      );
      expect(result.failureOrNull, isA<NotFoundFailure>());
      expect(await f.db.select(f.db.loans).get(), isEmpty);
      expect(await f.db.select(f.db.ledgerEntries).get(), isEmpty);
    });

    test('a failure part-way through rolls back loan, schedule and ledger',
        () async {
      final plan = f.generate(
        customerId: LoanFixture.customerId,
        principalPaise: 10000000,
        annualRatePercent: 12,
        tenureMonths: 12,
        type: LoanType.simple,
        startDate: DateTime.utc(2026, 1, 15),
      );
      // A second row with the same (loanId, installmentNo) breaks the unique
      // key after the loan and the other rows were already inserted.
      final broken = [
        ...plan.schedule,
        plan.schedule.first.copyWithId('dup-row'),
      ];

      final result = await f.loans.createLoan(plan.loan, broken);

      expect(result.isSuccess, isFalse);
      expect(await f.db.select(f.db.loans).get(), isEmpty);
      expect(await f.db.select(f.db.emis).get(), isEmpty);
      expect(await f.db.select(f.db.ledgerEntries).get(), isEmpty);
    });
  });

  group('MarkEmiPaid', () {
    test('pays an installment and credits the ledger', () async {
      final id = await newLoan();
      final first = (await f.db.emiDao.getByLoan(id)).first;

      final result = await f.markPaid(first.id, DateTime(2026, 2, 15, 17));
      expect(result.isSuccess, isTrue);

      final paid = (await f.db.emiDao.getById(first.id))!;
      expect(paid.status, 'paid');
      expect(paid.paidPaise, paid.emiPaise);
      expect(paid.paidDate, DateTime.utc(2026, 2, 15));

      final balance = await f.db.ledgerDao.customerBalance(
        LoanFixture.customerId,
      );
      expect(balance, 11200000 - first.emiPaise);
      expect((await f.loans.getLoan(id)).valueOrNull?.status, LoanStatus.active);
    });

    test('rejects paying out of order by default', () async {
      final id = await newLoan();
      final second = (await f.db.emiDao.getByLoan(id))[1];

      final result = await f.markPaid(second.id, DateTime.utc(2026, 3, 15));

      expect(result.failureOrNull, isA<OutOfOrderPaymentFailure>());
      expect((await f.db.emiDao.getById(second.id))!.status, 'pending');
      expect(await f.db.ledgerDao.entriesForCustomer(LoanFixture.customerId),
          hasLength(1));
    });

    test('allows out-of-order payment when the flag is on', () async {
      final id = await newLoan();
      final second = (await f.db.emiDao.getByLoan(id))[1];
      final lenient = MarkEmiPaid(
        f.emis,
        allowOutOfOrder: true,
        now: () => f.clock,
      );

      final result = await lenient(second.id, DateTime.utc(2026, 3, 15));
      expect(result.isSuccess, isTrue);
    });

    test('paying the same installment twice fails', () async {
      final id = await newLoan();
      final first = (await f.db.emiDao.getByLoan(id)).first;
      await f.markPaid(first.id, DateTime.utc(2026, 2, 15));

      final again = await f.markPaid(first.id, DateTime.utc(2026, 2, 16));
      expect(again.failureOrNull, isA<AlreadyPaidFailure>());
      expect(await f.db.ledgerDao.entriesForCustomer(LoanFixture.customerId),
          hasLength(2));
    });

    test('an unknown installment is not found', () async {
      final result = await f.markPaid('nope', DateTime.utc(2026, 2, 15));
      expect(result.failureOrNull, isA<NotFoundFailure>());
    });

    test('paying the 12th completes the loan and zeroes the balance', () async {
      final id = await newLoan();
      final rows = await f.db.emiDao.getByLoan(id);

      for (final row in rows.take(11)) {
        await f.markPaid(row.id, DateTime.utc(2026, 12, 1));
      }
      expect((await f.loans.getLoan(id)).valueOrNull?.status, LoanStatus.active);

      final last = await f.markPaid(rows.last.id, DateTime.utc(2027, 1, 15));
      expect(last.isSuccess, isTrue);
      expect(
        (await f.loans.getLoan(id)).valueOrNull?.status,
        LoanStatus.completed,
      );
      expect(
        await f.db.ledgerDao.customerBalance(LoanFixture.customerId),
        0,
      );
    });

    test('the customer can be deleted only after the loan completes',
        () async {
      final id = await newLoan(months: 2);
      final blocked = await f.customers.deleteCustomer(
        LoanFixture.customerId,
        at: f.clock,
      );
      expect(blocked.failureOrNull, isA<ActiveLoanFailure>());

      for (final row in await f.db.emiDao.getByLoan(id)) {
        await f.markPaid(row.id, DateTime.utc(2026, 4, 1));
      }
      final allowed = await f.customers.deleteCustomer(
        LoanFixture.customerId,
        at: f.clock,
      );
      expect(allowed.isSuccess, isTrue);
    });
  });

  group('closeLoan', () {
    test('refuses while installments are unpaid', () async {
      final id = await newLoan();
      final result = await f.loans.closeLoan(id, at: f.clock);
      expect(result.failureOrNull, isA<LoanNotPaidFailure>());
    });
  });

  test('EmiSchedule reports overdue from the due date, not storage', () async {
    final id = await newLoan(months: 2);
    final rows = await f.db.emiDao.getByLoan(id);
    final first = (await f.emis.watchSchedule(id).first).first;

    expect(rows.first.status, 'pending');
    expect(first.statusOn(DateTime.utc(2026, 2, 15)), EmiStatus.pending);
    expect(first.statusOn(DateTime.utc(2026, 2, 16)), EmiStatus.overdue);
  });
}
