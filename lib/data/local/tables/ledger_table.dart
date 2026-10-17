import 'package:drift/drift.dart';
import 'package:loan_management_app/data/local/tables/customers_table.dart';
import 'package:loan_management_app/data/local/tables/emis_table.dart';
import 'package:loan_management_app/data/local/tables/loans_table.dart';

/// Append-only ledger. Corrections are new entries, never edits.
@DataClassName('LedgerRow')
class LedgerEntries extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().references(Customers, #id)();
  TextColumn get loanId => text().references(Loans, #id)();
  TextColumn get emiId => text().nullable().references(Emis, #id)();

  /// `disbursement`, `emi_payment` or `adjustment`.
  TextColumn get type => text()();
  IntColumn get debitPaise => integer().withDefault(const Constant(0))();
  IntColumn get creditPaise => integer().withDefault(const Constant(0))();
  IntColumn get balanceAfterPaise => integer()();
  DateTimeColumn get entryDate => dateTime()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
