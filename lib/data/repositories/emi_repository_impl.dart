import 'package:drift/drift.dart';
import 'package:loan_management_app/core/error/exception_handler.dart';
import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/data/mappers/emi_mapper.dart';
import 'package:loan_management_app/domain/entities/emi_schedule.dart';
import 'package:loan_management_app/domain/entities/overdue_emi.dart';
import 'package:loan_management_app/domain/enums/ledger_entry_type.dart';
import 'package:loan_management_app/domain/enums/loan_status.dart';
import 'package:loan_management_app/domain/repositories/emi_repository.dart';
import 'package:uuid/uuid.dart';

class EmiRepositoryImpl implements EmiRepository {
  EmiRepositoryImpl(this._db, {String Function()? newId})
    : _newId = newId ?? (() => const Uuid().v4());

  final AppDatabase _db;
  final String Function() _newId;

  @override
  Stream<List<EmiSchedule>> watchSchedule(String loanId) {
    return _db.emiDao
        .watchByLoan(loanId)
        .map((rows) => [for (final row in rows) row.toEntity()]);
  }

  @override
  Future<Result<void>> markPaid({
    required String emiId,
    required DateTime paidDate,
    required DateTime at,
    bool allowOutOfOrder = false,
  }) {
    return ExceptionHandler.guard(() {
      return _db.transaction(() async {
        final emi = await _db.emiDao.getById(emiId);
        if (emi == null) {
          throw const DataNotFoundException('installment');
        }
        if (emi.status == 'paid') {
          throw const AlreadyPaidException('installment already paid');
        }
        if (!allowOutOfOrder &&
            await _db.emiDao.countEarlierPending(
                  emi.loanId,
                  emi.installmentNo,
                ) >
                0) {
          throw const OutOfOrderPaymentException('earlier installment unpaid');
        }
        final loan = await _db.loanDao.getById(emi.loanId);
        if (loan == null) {
          throw const DataNotFoundException('loan');
        }

        await _db.emiDao.markPaid(emi.id, emi.emiPaise, paidDate, at);

        final before = await _db.ledgerDao.customerBalance(loan.customerId);
        await _db.ledgerDao.insertRow(
          LedgerEntriesCompanion.insert(
            id: _newId(),
            customerId: loan.customerId,
            loanId: loan.id,
            emiId: Value(emi.id),
            type: LedgerEntryType.emiPayment.dbValue,
            creditPaise: Value(emi.emiPaise),
            balanceAfterPaise: before - emi.emiPaise,
            entryDate: paidDate,
            createdAt: at,
            updatedAt: at,
          ),
        );

        if (await _db.emiDao.countPending(emi.loanId) == 0) {
          await _db.loanDao.setStatus(
            emi.loanId,
            LoanStatus.completed.dbValue,
            at,
          );
        }
      });
    });
  }

  @override
  Stream<List<OverdueEmi>> watchOverdue({required DateTime today}) {
    return _db.emiDao
        .watchOverdue(today)
        .map(
          (rows) => [
            for (final row in rows)
              OverdueEmi(
                emi: row.emi.toEntity(),
                customerId: row.customerId,
                customerName: row.customerName,
              ),
          ],
        );
  }
}
