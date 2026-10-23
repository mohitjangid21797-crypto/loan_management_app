import 'package:drift/native.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/data/repositories/customer_repository_impl.dart';
import 'package:loan_management_app/data/repositories/emi_repository_impl.dart';
import 'package:loan_management_app/data/repositories/loan_repository_impl.dart';
import 'package:loan_management_app/domain/entities/customer.dart';
import 'package:loan_management_app/domain/usecases/emi/generate_schedule.dart';
import 'package:loan_management_app/domain/usecases/emi/mark_emi_paid.dart';
import 'package:loan_management_app/domain/usecases/loan/create_loan.dart';

/// An in-memory database with the Phase 3 repositories and use cases wired
/// up, plus one customer ('cust1').
class LoanFixture {
  LoanFixture._(this.db) {
    customers = CustomerRepositoryImpl(db.customerDao);
    loans = LoanRepositoryImpl(db, newId: () => 'led${_ledgerCounter++}');
    emis = EmiRepositoryImpl(db, newId: () => 'led${_ledgerCounter++}');
    generate = GenerateSchedule(
      newId: () => 'gen${_genCounter++}',
      now: () => clock,
    );
    createLoan = CreateLoan(loans, generate);
    markPaid = MarkEmiPaid(emis, now: () => clock);
  }

  static Future<LoanFixture> create() async {
    final fixture = LoanFixture._(AppDatabase.forTesting(NativeDatabase.memory()));
    await fixture.customers.addCustomer(
      Customer(
        id: customerId,
        name: 'Ramesh',
        mobile: '9876543210',
        createdAt: fixture.clock,
        updatedAt: fixture.clock,
      ),
    );
    return fixture;
  }

  static const String customerId = 'cust1';

  final AppDatabase db;
  final DateTime clock = DateTime.utc(2026, 10, 17, 9);
  int _ledgerCounter = 0;
  int _genCounter = 0;

  late final CustomerRepositoryImpl customers;
  late final LoanRepositoryImpl loans;
  late final EmiRepositoryImpl emis;
  late final GenerateSchedule generate;
  late final CreateLoan createLoan;
  late final MarkEmiPaid markPaid;

  Future<void> close() => db.close();
}
