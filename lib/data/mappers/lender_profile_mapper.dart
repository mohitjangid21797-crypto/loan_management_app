import 'package:drift/drift.dart';
import 'package:loan_management_app/data/local/database.dart';
import 'package:loan_management_app/domain/entities/lender_profile.dart';

extension LenderProfileRowMapper on LenderProfileRow {
  LenderProfile toEntity() {
    return LenderProfile(
      id: id,
      name: name,
      photoPath: photoPath,
      currencySymbol: currencySymbol,
      defaultRatePercent: defaultRatePercent,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension LenderProfileEntityMapper on LenderProfile {
  LenderProfilesCompanion toCompanion() {
    return LenderProfilesCompanion(
      id: Value(id),
      name: Value(name),
      photoPath: Value(photoPath),
      currencySymbol: Value(currencySymbol),
      defaultRatePercent: Value(defaultRatePercent),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}
