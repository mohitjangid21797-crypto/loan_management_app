import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/data/local/daos/customer_dao.dart';
import 'package:loan_management_app/data/local/daos/profile_dao.dart';
import 'package:loan_management_app/data/local/tables/customers_table.dart';
import 'package:loan_management_app/data/local/tables/emis_table.dart';
import 'package:loan_management_app/data/local/tables/lender_profile_table.dart';
import 'package:loan_management_app/data/local/tables/ledger_table.dart';
import 'package:loan_management_app/data/local/tables/loans_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// The app database. Generated code: run
/// `dart run build_runner build --delete-conflicting-outputs`.
@DriftDatabase(
  tables: [Customers, Loans, Emis, LedgerEntries, LenderProfiles],
  daos: [ProfileDao, CustomerDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For tests: pass `NativeDatabase.memory()`.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      // No upgrades yet. Index migration to version 2 arrives in Phase 6.
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, AppConstants.dbFileName));
    return NativeDatabase.createInBackground(file);
  });
}
