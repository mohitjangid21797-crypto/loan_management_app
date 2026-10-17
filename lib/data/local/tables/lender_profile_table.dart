import 'package:drift/drift.dart';

/// Single-row lender profile (one lender per device in v1).
@DataClassName('LenderProfileRow')
class LenderProfiles extends Table {
  @override
  String get tableName => 'lender_profile';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get currencySymbol => text().withDefault(const Constant('₹'))();
  RealColumn get defaultRatePercent =>
      real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
