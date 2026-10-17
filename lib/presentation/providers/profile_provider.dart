import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/data/repositories/profile_repository_impl.dart';
import 'package:loan_management_app/domain/entities/lender_profile.dart';
import 'package:loan_management_app/domain/repositories/profile_repository.dart';
import 'package:loan_management_app/presentation/providers/database_provider.dart';
import 'package:loan_management_app/services/photo_service.dart';

final photoServiceProvider = Provider<PhotoService>((ref) => PhotoService());

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(databaseProvider).profileDao);
});

/// The lender profile; null until the user first saves it.
final profileProvider = StreamProvider<LenderProfile?>((ref) {
  return ref.watch(profileRepositoryProvider).watchProfile();
});
