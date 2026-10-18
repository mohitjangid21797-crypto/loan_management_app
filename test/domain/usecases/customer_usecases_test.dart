import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/utils/validators.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/data/repositories/customer_repository_impl.dart';
import 'package:loan_management_app/domain/usecases/customer/add_customer.dart';
import 'package:loan_management_app/domain/usecases/customer/update_customer.dart';

void main() {
  late AppDatabase db;
  late CustomerRepositoryImpl repo;
  late AddCustomer add;
  late UpdateCustomer update;
  final clock = DateTime.utc(2026, 10, 17, 9);
  var counter = 0;

  setUp(() {
    counter = 0;
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = CustomerRepositoryImpl(db.customerDao);
    add = AddCustomer(repo, newId: () => 'id${counter++}', now: () => clock);
    update = UpdateCustomer(repo, now: () => clock.add(const Duration(days: 1)));
  });

  tearDown(() => db.close());

  test('AddCustomer rejects an empty name before touching storage', () async {
    final result = await add(name: '  ', mobile: '9876543210');
    expect(
      result.failureOrNull,
      const ValidationFailure(ValidationError.nameRequired),
    );
    expect(await repo.watchCustomers().first, isEmpty);
  });

  test('AddCustomer rejects a bad mobile', () async {
    final result = await add(name: 'Ramesh', mobile: '12345');
    expect(
      result.failureOrNull,
      const ValidationFailure(ValidationError.mobileInvalid),
    );
  });

  test('AddCustomer trims input and stores the customer', () async {
    final result = await add(
      name: '  Ramesh  ',
      mobile: ' 9876543210 ',
      address: ' Udaipur ',
    );
    final saved = result.valueOrNull!;
    expect(saved.id, 'id0');
    expect(saved.name, 'Ramesh');
    expect(saved.mobile, '9876543210');
    expect(saved.address, 'Udaipur');
    expect(saved.createdAt, clock);
    expect((await repo.getCustomer('id0')).valueOrNull, saved);
  });

  test('UpdateCustomer keeps id and createdAt, bumps updatedAt', () async {
    final created = (await add(name: 'Ramesh', mobile: '9876543210')).valueOrNull!;
    final updated = (await update(
      created,
      name: 'Ramesh Kumar',
      mobile: '9876543210',
      smsConsent: true,
    )).valueOrNull!;

    expect(updated.id, created.id);
    expect(updated.createdAt, created.createdAt);
    expect(updated.updatedAt, clock.add(const Duration(days: 1)));
    expect(updated.name, 'Ramesh Kumar');
    expect(updated.smsConsent, isTrue);
  });

  test('UpdateCustomer reports a duplicate mobile', () async {
    await add(name: 'A', mobile: '9111111111');
    final b = (await add(name: 'B', mobile: '9222222222')).valueOrNull!;
    final result = await update(b, name: 'B', mobile: '9111111111');
    expect(result.failureOrNull, isA<DuplicateMobileFailure>());
  });
}
