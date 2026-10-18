import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/router/route_names.dart';
import 'package:loan_management_app/domain/entities/customer.dart';
import 'package:loan_management_app/presentation/providers/customer_provider.dart';
import 'package:loan_management_app/presentation/widgets/confirm_dialog.dart';
import 'package:loan_management_app/presentation/widgets/customer_card.dart';
import 'package:loan_management_app/presentation/widgets/empty_state.dart';
import 'package:loan_management_app/presentation/widgets/error_view.dart';

/// Searchable list of customers, with add, edit and delete.
class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDebounce, () {
      ref.read(customerQueryProvider.notifier).setQuery(value);
    });
  }

  Future<void> _onAction(Customer customer, CustomerCardAction action) async {
    switch (action) {
      case CustomerCardAction.edit:
        await context.push(RouteNames.customerEditPath(customer.id));
      case CustomerCardAction.delete:
        await _confirmDelete(customer);
    }
  }

  Future<void> _confirmDelete(Customer customer) async {
    final l10n = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.customerDeleteTitle,
      message: l10n.customerDeleteMessage,
      confirmLabel: l10n.actionDelete,
      destructive: true,
    );
    if (!confirmed || !mounted) {
      return;
    }
    final result = await ref.read(deleteCustomerProvider)(customer.id);
    if (!mounted) {
      return;
    }
    final failure = result.failureOrNull;
    context.showSnack(
      failure == null ? l10n.customerDeleted : failure.message(l10n),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final customers = ref.watch(customersProvider);
    final query = ref.watch(customerQueryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navCustomers)),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.customerAdd,
        onPressed: () => context.push(RouteNames.customerAddPath),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: _onQueryChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.customersSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: customers.when(
              data: (list) {
                if (list.isEmpty) {
                  return EmptyState(
                    icon: Icons.people_outline,
                    message: query.isEmpty
                        ? l10n.customersEmpty
                        : l10n.customersNoMatch,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 88),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final customer = list[index];
                    return CustomerCard(
                      key: ValueKey(customer.id),
                      customer: customer,
                      onTap: () => context.push(
                        RouteNames.customerDetailPath(customer.id),
                      ),
                      onAction: (action) => _onAction(customer, action),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorView(
                message: l10n.errorDatabase,
                onRetry: () => ref.invalidate(customersProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
