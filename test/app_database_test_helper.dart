import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/services/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

Future<AppDatabase> createTestAppDatabase() async {
  ffi.sqfliteFfiInit();
  final directory = await Directory.systemTemp.createTemp(
    'loan_management_test_',
  );
  final database = AppDatabase(
    directoryProvider: () async => directory.path,
    databaseFactory: ffi.databaseFactoryFfi,
  );
  addTearDown(() async {
    await database.close();
    await directory.delete(recursive: true);
  });
  return database;
}
