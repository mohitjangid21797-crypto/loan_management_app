import 'package:drift/drift.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/data/local/tables/customers_table.dart';
import 'package:loan_management_app/data/local/tables/loans_table.dart';

part 'customer_dao.g.dart';

@DriftAccessor(tables: [Customers, Loans])
class CustomerDao extends DatabaseAccessor<AppDatabase>
    with _$CustomerDaoMixin {
  CustomerDao(super.attachedDatabase);

  /// Non-deleted customers, newest first. [query] matches name or mobile.
  Stream<List<CustomerRow>> watchAll({String query = ''}) {
    final statement = select(customers)
      ..where((c) => c.isDeleted.equals(false));
    final text = query.trim().toLowerCase();
    if (text.isNotEmpty) {
      statement.where(
        (c) => c.name.lower().like('%$text%') | c.mobile.like('%$text%'),
      );
    }
    statement.orderBy([(c) => OrderingTerm.desc(c.createdAt)]);
    return statement.watch();
  }

  Stream<CustomerRow?> watchById(String id) {
    return (select(customers)
          ..where((c) => c.id.equals(id) & c.isDeleted.equals(false)))
        .watchSingleOrNull();
  }

  Future<CustomerRow?> getById(String id) {
    return (select(customers)
          ..where((c) => c.id.equals(id) & c.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  /// The non-deleted customer with this mobile, if any.
  Future<CustomerRow?> findByMobile(String mobile) {
    return (select(customers)
          ..where((c) => c.mobile.equals(mobile) & c.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  Future<void> insertRow(CustomersCompanion companion) {
    return into(customers).insert(companion);
  }

  /// Returns how many rows changed (0 when the id does not exist).
  Future<int> updateRow(String id, CustomersCompanion companion) {
    return (update(customers)..where((c) => c.id.equals(id))).write(companion);
  }

  Future<int> softDelete(String id, DateTime at) {
    return updateRow(
      id,
      CustomersCompanion(isDeleted: const Value(true), updatedAt: Value(at)),
    );
  }

  /// Number of this customer's loans that are still active.
  Future<int> countActiveLoans(String customerId) async {
    final count = loans.id.count();
    final query = selectOnly(loans)
      ..addColumns([count])
      ..where(
        loans.customerId.equals(customerId) & loans.status.equals('active'),
      );
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }
}
