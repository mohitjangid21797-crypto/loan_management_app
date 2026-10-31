import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

class AppDatabase {
  static const String fileName = 'loan_management.db';
  static const String _tableName = 'app_state';
  static const String _payloadColumn = 'payload';

  static final AppDatabase instance = AppDatabase();

  final Future<String> Function() _directoryProvider;
  final sqflite.DatabaseFactory _databaseFactory;
  sqflite.Database? _database;

  AppDatabase({
    Future<String> Function()? directoryProvider,
    sqflite.DatabaseFactory? databaseFactory,
  }) : _directoryProvider =
           directoryProvider ?? _defaultDatabaseDirectory,
       _databaseFactory = databaseFactory ?? _defaultDatabaseFactory() {
    if (databaseFactory == null &&
        (Platform.isWindows || Platform.isLinux)) {
      ffi.sqfliteFfiInit();
    }
  }

  static Future<String> _defaultDatabaseDirectory() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  static sqflite.DatabaseFactory _defaultDatabaseFactory() {
    if (Platform.isWindows || Platform.isLinux) {
      return ffi.databaseFactoryFfi;
    }
    return sqflite.databaseFactory;
  }

  Future<String> get filePath async =>
      path.join(await _directoryProvider(), fileName);

  Future<sqflite.Database> get _openDatabase async {
    if (_database != null && _database!.isOpen) return _database!;

    final databasePath = await filePath;
    await Directory(path.dirname(databasePath)).create(recursive: true);
    _database = await _databaseFactory.openDatabase(
      databasePath,
      options: sqflite.OpenDatabaseOptions(
        version: 1,
        onCreate: (database, version) async {
          await database.execute(
            'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY CHECK (id = 1), '
            '$_payloadColumn TEXT NOT NULL)',
          );
        },
      ),
    );
    return _database!;
  }

  Future<Map<String, dynamic>?> readState() async {
    final database = await _openDatabase;
    final rows = await database.query(
      _tableName,
      columns: [_payloadColumn],
      where: 'id = ?',
      whereArgs: [1],
    );
    if (rows.isEmpty) return null;
    return _decodeState(rows.single[_payloadColumn]);
  }

  Future<void> writeState(Map<String, dynamic> state) async {
    final database = await _openDatabase;
    await database.insert(
      _tableName,
      {'id': 1, _payloadColumn: jsonEncode(state)},
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
    );
  }

  Future<Uint8List> exportDatabaseFile() async {
    final databasePath = await filePath;
    final database = await _openDatabase;
    await database.rawQuery('PRAGMA wal_checkpoint(FULL)');
    await database.close();
    _database = null;

    try {
      return await File(databasePath).readAsBytes();
    } finally {
      await _openDatabase;
    }
  }

  Future<Map<String, dynamic>> readBackupState(Uint8List bytes) async {
    final tempPath = await _writeTemporaryDatabase(bytes);
    sqflite.Database? database;
    try {
      database = await _databaseFactory.openDatabase(
        tempPath,
        options: sqflite.OpenDatabaseOptions(singleInstance: false),
      );
      final rows = await database.query(
        _tableName,
        columns: [_payloadColumn],
        where: 'id = ?',
        whereArgs: [1],
      );
      if (rows.length != 1) {
        throw const FormatException('Backup database has no app data.');
      }
      return _decodeState(rows.single[_payloadColumn]);
    } finally {
      await database?.close();
      await _deleteFileIfExists(tempPath);
    }
  }

  Future<void> restoreDatabaseFile(Uint8List bytes) async {
    final tempPath = await _writeTemporaryDatabase(bytes);
    sqflite.Database? validationDatabase;
    try {
      validationDatabase = await _databaseFactory.openDatabase(
        tempPath,
        options: sqflite.OpenDatabaseOptions(singleInstance: false),
      );
      final rows = await validationDatabase.query(
        _tableName,
        columns: [_payloadColumn],
        where: 'id = ?',
        whereArgs: [1],
      );
      if (rows.length != 1) {
        throw const FormatException('Backup database has no app data.');
      }
      _decodeState(rows.single[_payloadColumn]);
      await validationDatabase.close();
      validationDatabase = null;

      final databasePath = await filePath;
      await _database?.close();
      _database = null;
      await File(tempPath).copy(databasePath);
    } finally {
      await validationDatabase?.close();
      await _deleteFileIfExists(tempPath);
    }
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }

  Future<String> _writeTemporaryDatabase(Uint8List bytes) async {
    final directory = await _directoryProvider();
    await Directory(directory).create(recursive: true);
    final tempPath = path.join(
      directory,
      'restore_${DateTime.now().microsecondsSinceEpoch}.db',
    );
    await File(tempPath).writeAsBytes(bytes, flush: true);
    return tempPath;
  }

  Future<void> _deleteFileIfExists(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) await file.delete();
  }

  Map<String, dynamic> _decodeState(Object? payload) {
    if (payload is! String) {
      throw const FormatException('Database app data is missing.');
    }
    final decoded = jsonDecode(payload);
    if (decoded is! Map) {
      throw const FormatException('Database app data is invalid.');
    }
    return Map<String, dynamic>.from(decoded);
  }
}