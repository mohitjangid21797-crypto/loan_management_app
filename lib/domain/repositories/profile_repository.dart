import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/domain/entities/lender_profile.dart';

/// Reads and writes the single lender profile.
abstract interface class ProfileRepository {
  /// Emits the profile whenever it changes; null until first saved.
  Stream<LenderProfile?> watchProfile();

  Future<Result<LenderProfile?>> getProfile();

  /// Creates the profile or updates name and photo, keeping other fields.
  Future<Result<void>> saveProfile({required String name, String? photoPath});
}
