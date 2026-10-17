import 'package:drift/drift.dart';
import 'package:loan_management_app/data/local/tables/customers_table.dart';

/// Loans. Rate and tenure are frozen at creation. Money is integer paise.
@DataClassName('LoanRow')
class Loans extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().references(Customers, #id)();

  /// `simple` or `compound`.
  TextColumn get type => text()();
  IntColumn get principalPaise => integer()();
  RealColumn get annualRatePercent => real()();
  IntColumn get tenureMonths => integer()();
  DateTimeColumn get startDate => dateTime()();
  IntColumn get emiPaise => integer()();
  IntColumn get totalInterestPaise => integer()();

  /// `active` or `completed`.
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
