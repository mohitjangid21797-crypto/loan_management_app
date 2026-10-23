import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/router/route_names.dart';
import 'package:loan_management_app/domain/entities/customer.dart';
import 'package:loan_management_app/presentation/providers/customer_provider.dart';
import 'package:loan_management_app/presentation/widgets/customer_loans_section.dart';
import 'package:loan_management_app/presentation/widgets/empty_state.dart';
import 'package:loan_management_app/presentation/widgets/error_view.dart';
import 'package:loan_management_app/presentation/widgets/photo_avatar.dart';
import 'package:url_launcher/url_launcher.dart';

/// One customer's details, with call and (if consented) SMS buttons.
class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({required this.customerId, super.key});

  final String customerId;

  Future<void> _launch(BuildContext context, String scheme, String mobile) async {
    final message = context.l10n.customerCannotLaunch;
    final opened = await launchUrl(Uri(scheme: scheme, path: mobile));
    if (!opened && context.mounted) {
      context.showSnack(message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final customer = ref.watch(customerDetailProvider(customerId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customerDetailTitle),
        actions: [
          if (customer.valueOrNull != null)
            IconButton(
              tooltip: l10n.customerEdit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () =>
                  context.push(RouteNames.customerEditPath(customerId)),
            ),
        ],
      ),
      body: customer.when(
        data: (data) => data == null
            ? EmptyState(
                icon: Icons.person_off_outlined,
                message: l10n.customerNotFound,
              )
            : _Details(
                customer: data,
                onCall: () => _launch(context, 'tel', data.mobile),
                onSms: () => _launch(context, 'sms', data.mobile),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorDatabase,
          onRetry: () => ref.invalidate(customerDetailProvider(customerId)),
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({
    required this.customer,
    required this.onCall,
    required this.onSms,
  });

  final Customer customer;
  final VoidCallback onCall;
  final VoidCallback onSms;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: PhotoAvatar(
            path: customer.photoPath,
            placeholder: const Icon(Icons.person, size: 48),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          customer.name,
          textAlign: TextAlign.center,
          style: context.textStyles.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          customer.mobile,
          textAlign: TextAlign.center,
          style: context.textStyles.bodyLarge,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: onCall,
              icon: const Icon(Icons.call),
              label: Text(l10n.customerCall),
            ),
            if (customer.smsConsent) ...[
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: onSms,
                icon: const Icon(Icons.sms_outlined),
                label: Text(l10n.customerSms),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        if (customer.address.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text(l10n.customerAddressLabel),
            subtitle: Text(customer.address),
          ),
        if (customer.notes.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.notes_outlined),
            title: Text(l10n.customerNotesLabel),
            subtitle: Text(customer.notes),
          ),
        const SizedBox(height: 16),
        CustomerLoansSection(customerId: customer.id),
      ],
    );
  }
}
