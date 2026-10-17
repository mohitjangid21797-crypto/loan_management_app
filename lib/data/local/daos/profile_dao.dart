import 'package:drift/drift.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/data/local/tables/lender_profile_table.dart';

part 'profile_dao.g.dart';

@DriftAccessor(tables: [LenderProfiles])
class ProfileDao extends DatabaseAccessor<AppDatabase>
    with _$ProfileDaoMixin {
  ProfileDao(super.attachedDatabase);

  Stream<LenderProfileRow?> watch() {
    return select(lenderProfiles).watchSingleOrNull();
  }

  Future<LenderProfileRow?> get() {
    return select(lenderProfiles).getSingleOrNull();
  }

  Future<void> upsert(LenderProfilesCompanion companion) {
    return into(lenderProfiles).insertOnConflictUpdate(companion);
  }
}
