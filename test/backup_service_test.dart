import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/models/customer.dart';
import 'package:loan_management_app/providers/app_provider.dart';
import 'package:loan_management_app/services/backup_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_database_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('backup header accepts legacy and current versions only', () {
    final salt = Uint8List(LMBKHeader.saltLength);
    final iv = Uint8List(LMBKHeader.ivLength);
    final legacyHeader = LMBKHeader(
      version: LMBKHeader.legacyFormatVersion,
      salt: salt,
      iv: iv,
    ).toBytes();
    final currentHeader = LMBKHeader(
      version: LMBKHeader.formatVersion,
      salt: salt,
      iv: iv,
    ).toBytes();
    final unsupportedHeader = Uint8List.fromList(currentHeader)
      ..[4] = LMBKHeader.formatVersion + 1;

    expect(
      LMBKHeader.fromBytes(legacyHeader)?.version,
      LMBKHeader.legacyFormatVersion,
    );
    expect(
      LMBKHeader.fromBytes(currentHeader)?.version,
      LMBKHeader.formatVersion,
    );
    expect(LMBKHeader.fromBytes(unsupportedHeader), isNull);
  });

  test('restore replaces existing data without duplicating records', () async {
    SharedPreferences.setMockInitialValues({});
    final provider = AppProvider(database: await createTestAppDatabase());
    await provider.addCustomer(
      Customer(
        name: 'Existing customer',
        mobileNumber: '1111111111',
        email: 'existing@example.com',
        location: 'Old location',
      ),
    );
    final restoredCustomer = Customer(
      id: 'restored-customer',
      name: 'Restored customer',
      mobileNumber: '2222222222',
      email: 'restored@example.com',
      location: 'New location',
      createdAt: DateTime.utc(2025),
    );
    final backup = Uint8List.fromList(
      utf8.encode(
        jsonEncode({
          'version': 1,
          'lender': null,
          'customers': [restoredCustomer.toJson()],
          'loans': [],
          'emis': [],
          'documents': [],
        }),
      ),
    );
    final service = BackupService();

    expect(await service.restoreFromPackage(provider, backup), isTrue);
    expect(await service.restoreFromPackage(provider, backup), isTrue);
    expect(provider.customers, hasLength(1));
    expect(provider.customers.single.id, restoredCustomer.id);
    expect(provider.loans, isEmpty);
    expect(provider.emis, isEmpty);
    expect(provider.documents, isEmpty);
    expect(provider.lender, isNull);
  });

  test('SQLite backup restores app data and replaces existing records', () async {
    SharedPreferences.setMockInitialValues({});
    final sourceProvider = AppProvider(
      database: await createTestAppDatabase(),
    );
    final restoredCustomer = Customer(
      id: 'database-customer',
      name: 'Database customer',
      mobileNumber: '3333333333',
      email: 'database@example.com',
      location: 'Database location',
    );
    await sourceProvider.addCustomer(restoredCustomer);
    final backupFile = await sourceProvider.database.exportDatabaseFile();

    expect(
      String.fromCharCodes(backupFile.take(16)),
      'SQLite format 3\u0000',
    );

    final targetProvider = AppProvider(
      database: await createTestAppDatabase(),
    );
    await targetProvider.addCustomer(
      Customer(
        name: 'Existing customer',
        mobileNumber: '4444444444',
        email: 'target@example.com',
        location: 'Target location',
      ),
    );

    expect(
      await BackupService().restoreBackup(targetProvider, backupFile),
      isTrue,
    );
    expect(targetProvider.customers, hasLength(1));
    expect(targetProvider.customers.single.id, restoredCustomer.id);
    expect(
      await targetProvider.database.readState(),
      containsPair('customers', hasLength(1)),
    );
  });
}
