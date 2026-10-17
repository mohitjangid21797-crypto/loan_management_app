import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/data/local/database.dart';

/// The single [AppDatabase]. Invalidate it to reopen after a restore.
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
