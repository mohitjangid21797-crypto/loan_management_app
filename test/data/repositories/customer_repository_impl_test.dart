import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/data/repositories/customer_repository_impl.dart';
import 'package:loan_management_app/domain/entities/customer.dart';

Customer _customer(String id, String name, String mobile, {DateTime? at}) {
  final time = at ?? DateTime.utc(2026, 10, 17);
  return Customer(
    id: id,
    name: name,
    mobile: mobile,
    createdAt: time,
    updatedAt: time,
  );
}

void main() {
  late AppDatabase db;
  late CustomerRepositoryImpl repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = CustomerRepositoryImpl(db.customerDao);
  });

  tearDown(() => db.close());

  test('adds a customer and reads it back', () async {
    final customer = _customer('1', 'Ramesh', '9876543210');
    expect((await repo.addCustomer(customer)).isSuccess, isTrue);

    final loaded = await repo.getCustomer('1');
    expect(loaded.valueOrNull, customer);
  });

  test('rejects a second customer with the same mobile', () async {
    await repo.addCustomer(_customer('1', 'Ramesh', '9876543210'));
    final result = await repo.addCustomer(_customer('2', 'Suresh', '9876543210'));
    expect(result.failureOrNull, isA<DuplicateMobileFailure>());
  });

  test('allows an update that keeps the customer\'s own mobile', () async {
    await repo.addCustomer(_customer('1', 'Ramesh', '9876543210'));
    final result = await repo.updateCustomer(
      _customer('1', 'Ramesh K', '9876543210'),
    );
    expect(result.isSuccess, isTrue);
    expect((await repo.getCustomer('1')).valueOrNull?.name, 'Ramesh K');
  });

  test('update of a missing customer is not found', () async {
    final result = await repo.updateCustomer(
      _customer('nope', 'Ghost', '9000000000'),
    );
    expect(result.failureOrNull, isA<NotFoundFailure>());
  });

  test('soft delete hides the customer and frees the mobile', () async {
    await repo.addCustomer(_customer('1', 'Ramesh', '9876543210'));
    final deleted = await repo.deleteCustomer(
      '1',
      at: DateTime.utc(2026, 10, 18),
    );
    expect(deleted.isSuccess, isTrue);
    expect((await repo.getCustomer('1')).failureOrNull, isA<NotFoundFailure>());

    final again = await repo.addCustomer(_customer('2', 'New', '9876543210'));
    expect(again.isSuccess, isTrue);
  });

  test('cannot delete a customer with an active loan', () async {
    await repo.addCustomer(_customer('1', 'Ramesh', '9876543210'));
    final now = DateTime.utc(2026, 10, 17);
    await db
        .into(db.loans)
        .insert(
          LoansCompanion.insert(
            id: 'L1',
            customerId: '1',
            type: 'simple',
            principalPaise: 100000,
            annualRatePercent: 12,
            tenureMonths: 12,
            startDate: now,
            emiPaise: 8885,
            totalInterestPaise: 6620,
            createdAt: now,
            updatedAt: now,
            status: const Value('active'),
          ),
        );

    final result = await repo.deleteCustomer('1', at: now);
    expect(result.failureOrNull, isA<ActiveLoanFailure>());
    expect((await repo.getCustomer('1')).isSuccess, isTrue);
  });

  test('search matches name or mobile ignoring case, newest first', () async {
    await repo.addCustomer(
      _customer('1', 'Ramesh Kumar', '9111111111', at: DateTime.utc(2026, 1, 1)),
    );
    await repo.addCustomer(
      _customer('2', 'Suresh', '9222222222', at: DateTime.utc(2026, 2, 1)),
    );

    final all = await repo.watchCustomers().first;
    expect(all.map((c) => c.id), ['2', '1']);

    final byName = await repo.watchCustomers(query: 'RAMESH').first;
    expect(byName.map((c) => c.id), ['1']);

    final byMobile = await repo.watchCustomers(query: '9222').first;
    expect(byMobile.map((c) => c.id), ['2']);
  });
}
