import 'package:drift/drift.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/data/local/tables/customers_table.dart';
import 'package:loan_management_app/data/local/tables/emis_table.dart';
import 'package:loan_management_app/data/local/tables/loans_table.dart';

part 'emi_dao.g.dart';

/// An overdue installment row joined with its customer.
typedef OverdueRow = ({EmiRow emi, String customerId, String customerName});

@DriftAccessor(tables: [Emis, Loans, Customers])
class EmiDao extends DatabaseAccessor<AppDatabase> with _$EmiDaoMixin {
  EmiDao(super.attachedDatabase);

  Stream<List<EmiRow>> watchByLoan(String loanId) {
    return (select(emis)
          ..where((e) => e.loanId.equals(loanId))
          ..orderBy([(e) => OrderingTerm.asc(e.installmentNo)]))
        .watch();
  }

  Future<List<EmiRow>> getByLoan(String loanId) {
    return (select(emis)
          ..where((e) => e.loanId.equals(loanId))
          ..orderBy([(e) => OrderingTerm.asc(e.installmentNo)]))
        .get();
  }

  Future<EmiRow?> getById(String id) {
    return (select(emis)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  /// Inserts all rows. Call inside a transaction so a failure rolls back.
  Future<void> insertAll(List<EmisCompanion> rows) {
    return batch((b) => b.insertAll(emis, rows));
  }

  /// Unpaid installments of the loan numbered below [installmentNo].
  Future<int> countEarlierPending(String loanId, int installmentNo) {
    return _countPending(
      emis.loanId.equals(loanId) &
          emis.installmentNo.isSmallerThanValue(installmentNo),
    );
  }

  /// Unpaid installments of the loan.
  Future<int> countPending(String loanId) {
    return _countPending(emis.loanId.equals(loanId));
  }

  Future<int> _countPending(Expression<bool> where) async {
    final count = emis.id.count();
    final query = selectOnly(emis)
      ..addColumns([count])
      ..where(where & emis.status.equals('pending'));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  /// Returns how many rows changed (0 when the id does not exist).
  Future<int> markPaid(String id, int paidPaise, DateTime date, DateTime at) {
    return (update(emis)..where((e) => e.id.equals(id))).write(
      EmisCompanion(
        status: const Value('paid'),
        paidPaise: Value(paidPaise),
        paidDate: Value(date),
        updatedAt: Value(at),
      ),
    );
  }

  /// Pending installments due before [today], oldest first.
  Stream<List<OverdueRow>> watchOverdue(DateTime today) {
    final query =
        select(emis).join([
            innerJoin(loans, loans.id.equalsExp(emis.loanId)),
            innerJoin(customers, customers.id.equalsExp(loans.customerId)),
          ])
          ..where(
            emis.status.equals('pending') & emis.dueDate.isSmallerThanValue(today),
          )
          ..orderBy([
            OrderingTerm.asc(emis.dueDate),
            OrderingTerm.asc(emis.installmentNo),
          ]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          (
            emi: row.readTable(emis),
            customerId: row.readTable(customers).id,
            customerName: row.readTable(customers).name,
          ),
      ],
    );
  }
}
