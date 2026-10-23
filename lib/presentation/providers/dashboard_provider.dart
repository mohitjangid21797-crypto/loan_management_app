import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/utils/date_utils.dart';
import 'package:loan_management_app/domain/entities/dashboard_stats.dart';
import 'package:loan_management_app/presentation/providers/loan_provider.dart';

/// The dashboard numbers as of today.
final dashboardStatsProvider = StreamProvider.autoDispose<DashboardStats>((
  ref,
) {
  return ref
      .watch(loanRepositoryProvider)
      .watchDashboardStats(today: AppDateUtils.today());
});
