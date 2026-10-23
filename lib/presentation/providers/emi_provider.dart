import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/data/repositories/emi_repository_impl.dart';
import 'package:loan_management_app/domain/entities/emi_schedule.dart';
import 'package:loan_management_app/domain/entities/overdue_emi.dart';
import 'package:loan_management_app/domain/repositories/emi_repository.dart';
import 'package:loan_management_app/domain/usecases/emi/get_overdue.dart';
import 'package:loan_management_app/domain/usecases/emi/mark_emi_paid.dart';
import 'package:loan_management_app/presentation/providers/database_provider.dart';

final emiRepositoryProvider = Provider<EmiRepository>((ref) {
  return EmiRepositoryImpl(ref.watch(databaseProvider));
});

final markEmiPaidProvider = Provider<MarkEmiPaid>((ref) {
  return MarkEmiPaid(
    ref.watch(emiRepositoryProvider),
    allowOutOfOrder: AppConstants.allowOutOfOrderPayments,
  );
});

final getOverdueProvider = Provider<GetOverdue>((ref) {
  return GetOverdue(ref.watch(emiRepositoryProvider));
});

/// The installments of one loan, in order.
final emiScheduleProvider = StreamProvider.autoDispose
    .family<List<EmiSchedule>, String>((ref, loanId) {
      return ref.watch(emiRepositoryProvider).watchSchedule(loanId);
    });

/// Pending installments due before today, oldest first.
final overdueProvider = StreamProvider.autoDispose<List<OverdueEmi>>((ref) {
  return ref.watch(getOverdueProvider)();
});
