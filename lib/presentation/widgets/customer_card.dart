import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/domain/entities/customer.dart';

/// What the overflow menu on a [CustomerCard] can ask for.
enum CustomerCardAction { edit, delete }

/// One row in the customer list.
class CustomerCard extends StatelessWidget {
  const CustomerCard({
    required this.customer,
    required this.onTap,
    required this.onAction,
    super.key,
  });

  final Customer customer;
  final VoidCallback onTap;
  final ValueChanged<CustomerCardAction> onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final path = customer.photoPath;
    final photo = path != null && File(path).existsSync() ? File(path) : null;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        minVerticalPadding: 12,
        onTap: onTap,
        leading: CircleAvatar(
          backgroundImage: photo == null ? null : FileImage(photo),
          child: photo == null ? Text(_initial(customer.name)) : null,
        ),
        title: Text(customer.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(customer.mobile),
        trailing: PopupMenuButton<CustomerCardAction>(
          tooltip: l10n.customerMenu,
          onSelected: onAction,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: CustomerCardAction.edit,
              child: Text(l10n.customerEdit),
            ),
            PopupMenuItem(
              value: CustomerCardAction.delete,
              child: Text(l10n.actionDelete),
            ),
          ],
        ),
      ),
    );
  }

  static String _initial(String name) {
    final trimmed = name.trim();
    return trimmed.isEmpty ? '?' : String.fromCharCode(trimmed.runes.first);
  }
}
