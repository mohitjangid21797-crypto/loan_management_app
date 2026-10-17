import 'package:drift/drift.dart';
import 'package:loan_management_app/data/local/tables/loans_table.dart';

/// EMI schedule rows. Overdue is computed from dueDate, never stored.
@DataClassName('EmiRow')
class Emis extends Table {
  @override
  String get tableName => 'emi_schedules';

  TextColumn get id => text()();
  TextColumn get loanId => text().references(Loans, #id)();
  IntColumn get installmentNo => integer()();
  DateTimeColumn get dueDate => dateTime()();
  IntColumn get principalPartPaise => integer()();
  IntColumn get interestPartPaise => integer()();
  IntColumn get emiPaise => integer()();
  IntColumn get paidPaise => integer().withDefault(const Constant(0))();
  DateTimeColumn get paidDate => dateTime().nullable()();

  /// `pending` or `paid`.
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {loanId, installmentNo},
  ];
}
