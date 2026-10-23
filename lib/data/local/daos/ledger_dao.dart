import 'package:drift/drift.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/data/local/tables/ledger_table.dart';

part 'ledger_dao.g.dart';

/// Append-only ledger access. There is deliberately no update or delete.
@DriftAccessor(tables: [LedgerEntries])
class LedgerDao extends DatabaseAccessor<AppDatabase> with _$LedgerDaoMixin {
  LedgerDao(super.attachedDatabase);

  Future<void> insertRow(LedgerEntriesCompanion companion) {
    return into(ledgerEntries).insert(companion);
  }

  /// What the customer owes right now: total debits minus total credits.
  Future<int> customerBalance(String customerId) async {
    final debit = ledgerEntries.debitPaise.sum();
    final credit = ledgerEntries.creditPaise.sum();
    final query = selectOnly(ledgerEntries)
      ..addColumns([debit, credit])
      ..where(ledgerEntries.customerId.equals(customerId));
    final row = await query.getSingle();
    return (row.read(debit) ?? 0) - (row.read(credit) ?? 0);
  }

  /// All entries of one customer, oldest first (used by tests and Phase 4).
  Future<List<LedgerRow>> entriesForCustomer(String customerId) {
    return (select(ledgerEntries)
          ..where((e) => e.customerId.equals(customerId))
          ..orderBy([(e) => OrderingTerm.asc(e.createdAt)]))
        .get();
  }
}
