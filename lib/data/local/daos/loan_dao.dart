import 'package:drift/drift.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/data/local/tables/emis_table.dart';
import 'package:loan_management_app/data/local/tables/loans_table.dart';

part 'loan_dao.g.dart';

/// The dashboard aggregates, straight from SQL.
typedef StatsRow = ({
  int disbursed,
  int interestEarned,
  int activeLoans,
  int overdue,
  int monthDue,
});

@DriftAccessor(tables: [Loans, Emis])
class LoanDao extends DatabaseAccessor<AppDatabase> with _$LoanDaoMixin {
  LoanDao(super.attachedDatabase);

  /// Newest first, optionally filtered by [status] text and/or customer.
  Stream<List<LoanRow>> watchAll({String? status, String? customerId}) {
    final statement = select(loans);
    if (status != null) {
      statement.where((l) => l.status.equals(status));
    }
    if (customerId != null) {
      statement.where((l) => l.customerId.equals(customerId));
    }
    statement.orderBy([(l) => OrderingTerm.desc(l.createdAt)]);
    return statement.watch();
  }

  Stream<LoanRow?> watchById(String id) {
    return (select(loans)..where((l) => l.id.equals(id))).watchSingleOrNull();
  }

  Future<LoanRow?> getById(String id) {
    return (select(loans)..where((l) => l.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(LoansCompanion companion) {
    return into(loans).insert(companion);
  }

  /// Returns how many rows changed (0 when the id does not exist).
  Future<int> setStatus(String id, String status, DateTime at) {
    return (update(loans)..where((l) => l.id.equals(id))).write(
      LoansCompanion(status: Value(status), updatedAt: Value(at)),
    );
  }

  /// Dashboard numbers as of [today] (UTC midnight). Re-emits whenever the
  /// loans or installments tables change.
  Stream<StatsRow> watchStats(DateTime today) {
    final monthStart = DateTime.utc(today.year, today.month);
    final monthEnd = DateTime.utc(today.year, today.month + 1);
    return customSelect(
      '''
SELECT
  (SELECT COALESCE(SUM(principal_paise), 0) FROM loans) AS disbursed,
  (SELECT COALESCE(SUM(interest_part_paise), 0) FROM emi_schedules
     WHERE status = 'paid') AS interest_earned,
  (SELECT COUNT(*) FROM loans WHERE status = 'active') AS active_loans,
  (SELECT COUNT(*) FROM emi_schedules
     WHERE status = 'pending' AND due_date < ?) AS overdue,
  (SELECT COALESCE(SUM(emi_paise), 0) FROM emi_schedules
     WHERE status = 'pending' AND due_date >= ? AND due_date < ?)
     AS month_due
''',
      variables: [
        Variable.withDateTime(today),
        Variable.withDateTime(monthStart),
        Variable.withDateTime(monthEnd),
      ],
      readsFrom: {loans, emis},
    ).watchSingle().map(
      (row) => (
        disbursed: row.read<int>('disbursed'),
        interestEarned: row.read<int>('interest_earned'),
        activeLoans: row.read<int>('active_loans'),
        overdue: row.read<int>('overdue'),
        monthDue: row.read<int>('month_due'),
      ),
    );
  }
}
