import 'package:loan_management_app/core/error/exception_handler.dart';
import 'package:loan_management_app/core/error/failures.dart';
import 'package:loan_management_app/core/utils/result.dart';
import 'package:loan_management_app/core/utils/validators.dart';
import 'package:loan_management_app/data/local/daos/profile_dao.dart';
import 'package:loan_management_app/data/mappers/lender_profile_mapper.dart';
import 'package:loan_management_app/domain/entities/lender_profile.dart';
import 'package:loan_management_app/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._dao, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final ProfileDao _dao;
  final DateTime Function() _now;

  @override
  Stream<LenderProfile?> watchProfile() {
    return _dao.watch().map((row) => row?.toEntity());
  }

  @override
  Future<Result<LenderProfile?>> getProfile() {
    return ExceptionHandler.guard(() async => (await _dao.get())?.toEntity());
  }

  @override
  Future<Result<void>> saveProfile({
    required String name,
    String? photoPath,
  }) async {
    final invalid = Validators.name(name);
    if (invalid != null) {
      return Err(ValidationFailure(invalid));
    }
    return ExceptionHandler.guard(() async {
      final now = _now();
      final existing = (await _dao.get())?.toEntity();
      final profile = LenderProfile(
        id: LenderProfile.singleId,
        name: name.trim(),
        photoPath: photoPath,
        currencySymbol: existing?.currencySymbol ?? '₹',
        defaultRatePercent: existing?.defaultRatePercent ?? 0,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      );
      await _dao.upsert(profile.toCompanion());
    });
  }
}
