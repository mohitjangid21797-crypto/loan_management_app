import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/router/route_names.dart';
import 'package:loan_management_app/domain/entities/dashboard_stats.dart';
import 'package:loan_management_app/domain/entities/overdue_emi.dart';
import 'package:loan_management_app/presentation/providers/dashboard_provider.dart';
import 'package:loan_management_app/presentation/providers/emi_provider.dart';
import 'package:loan_management_app/presentation/widgets/error_view.dart';
import 'package:loan_management_app/presentation/widgets/stat_card.dart';

/// Totals for the whole business, and the list of overdue installments.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final stats = ref.watch(dashboardStatsProvider);
    final overdue = ref.watch(overdueProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDashboard)),
      body: stats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorDatabase,
          onRetry: () {
            ref
              ..invalidate(dashboardStatsProvider)
              ..invalidate(overdueProvider);
          },
        ),
        data: (data) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _StatGrid(stats: data)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  l10n.dashboardOverdueTitle,
                  style: context.textStyles.titleMedium,
                ),
              ),
            ),
            ..._overdueSlivers(context, overdue),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  List<Widget> _overdueSlivers(
    BuildContext context,
    AsyncValue<List<OverdueEmi>> overdue,
  ) {
    final l10n = context.l10n;
    return overdue.when(
      loading: () => [
        const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
      error: (error, _) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.errorDatabase),
          ),
        ),
      ],
      data: (list) {
        if (list.isEmpty) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.dashboardNoOverdue),
              ),
            ),
          ];
        }
        return [
          SliverList.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  minVerticalPadding: 12,
                  onTap: () => context.push(
                    RouteNames.loanDetailPath(item.emi.loanId),
                  ),
                  title: Text(
                    item.customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${l10n.emiInstallment(item.emi.installmentNo)} · '
                    '${l10n.emiDueOn(context.formatDate(item.emi.dueDate))}',
                  ),
                  trailing: Text(
                    context.money(item.emi.emiPaise),
                    style: context.textStyles.titleSmall?.copyWith(
                      color: context.colors.error,
                    ),
                  ),
                ),
              );
            },
          ),
        ];
      },
    );
  }
}

/// Two cards per row, wrapping so large text never overflows.
class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.stats});

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cards = [
      StatCard(
        icon: Icons.payments_outlined,
        label: l10n.dashboardTotalDisbursed,
        value: context.money(stats.totalDisbursedPaise),
      ),
      StatCard(
        icon: Icons.trending_up,
        label: l10n.dashboardInterestEarned,
        value: context.money(stats.interestEarnedPaise),
      ),
      StatCard(
        icon: Icons.account_balance_wallet_outlined,
        label: l10n.dashboardActiveLoans,
        value: '${stats.activeLoanCount}',
      ),
      StatCard(
        icon: Icons.warning_amber_outlined,
        label: l10n.dashboardOverdueCount,
        value: '${stats.overdueCount}',
        highlight: stats.overdueCount > 0,
      ),
      StatCard(
        icon: Icons.event_outlined,
        label: l10n.dashboardMonthDue,
        value: context.money(stats.monthDuePaise),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = (constraints.maxWidth - 8) / 2;
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final card in cards) SizedBox(width: width, child: card),
            ],
          );
        },
      ),
    );
  }
}
