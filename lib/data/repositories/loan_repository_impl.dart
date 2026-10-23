import 'package:drift/drift.dart';
import 'package:loan_management_app/core/error/exception_handler.dart';
import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/data/mappers/emi_mapper.dart';
import 'package:loan_management_app/data/mappers/loan_mapper.dart';
import 'package:loan_management_app/domain/entities/dashboard_stats.dart';
import 'package:loan_management_app/domain/entities/emi_schedule.dart';
import 'package:loan_management_app/domain/entities/loan.dart';
import 'package:loan_management_app/domain/enums/ledger_entry_type.dart';
import 'package:loan_management_app/domain/enums/loan_status.dart';
import 'package:loan_management_app/domain/repositories/loan_repository.dart';
import 'package:uuid/uuid.dart';

class LoanRepositoryImpl implements LoanRepository {
  LoanRepositoryImpl(this._db, {String Function()? newId})
    : _newId = newId ?? (() => const Uuid().v4());

  final AppDatabase _db;
  final String Function() _newId;

  @override
  Stream<List<Loan>> watchLoans({LoanStatus? status, String? customerId}) {
    return _db.loanDao
        .watchAll(status: status?.dbValue, customerId: customerId)
        .map((rows) => [for (final row in rows) row.toEntity()]);
  }

  @override
  Stream<Loan?> watchLoan(String id) {
    return _db.loanDao.watchById(id).map((row) => row?.toEntity());
  }

  @override
  Future<Result<Loan>> getLoan(String id) {
    return ExceptionHandler.guard(() async {
      final row = await _db.loanDao.getById(id);
      if (row == null) {
        throw const DataNotFoundException('loan');
      }
      return row.toEntity();
    });
  }

  @override
  Future<Result<void>> createLoan(Loan loan, List<EmiSchedule> schedule) {
    return ExceptionHandler.guard(() {
      return _db.transaction(() async {
        final customer = await _db.customerDao.getById(loan.customerId);
        if (customer == null) {
          throw const DataNotFoundException('customer');
        }
        await _db.loanDao.insertRow(loan.toCompanion());
        await _db.emiDao.insertAll([
          for (final emi in schedule) emi.toCompanion(),
        ]);
        // The customer now owes everything they will pay back: principal
        // plus interest. Each paid installment then credits this balance, so
        // it reaches zero exactly when the loan is fully paid.
        final owed = loan.totalPayablePaise;
        final before = await _db.ledgerDao.customerBalance(loan.customerId);
        await _db.ledgerDao.insertRow(
          LedgerEntriesCompanion.insert(
            id: _newId(),
            customerId: loan.customerId,
            loanId: loan.id,
            type: LedgerEntryType.disbursement.dbValue,
            debitPaise: Value(owed),
            balanceAfterPaise: before + owed,
            entryDate: loan.startDate,
            createdAt: loan.createdAt,
            updatedAt: loan.createdAt,
          ),
        );
      });
    });
  }

  @override
  Future<Result<void>> closeLoan(String id, {required DateTime at}) {
    return ExceptionHandler.guard(() {
      return _db.transaction(() async {
        if (await _db.loanDao.getById(id) == null) {
          throw const DataNotFoundException('loan');
        }
        if (await _db.emiDao.countPending(id) > 0) {
          throw const LoanNotPaidException('unpaid installments remain');
        }
        await _db.loanDao.setStatus(id, LoanStatus.completed.dbValue, at);
      });
    });
  }

  @override
  Stream<DashboardStats> watchDashboardStats({required DateTime today}) {
    return _db.loanDao.watchStats(today).map(
      (row) => DashboardStats(
        totalDisbursedPaise: row.disbursed,
        interestEarnedPaise: row.interestEarned,
        activeLoanCount: row.activeLoans,
        overdueCount: row.overdue,
        monthDuePaise: row.monthDue,
      ),
    );
  }
}
