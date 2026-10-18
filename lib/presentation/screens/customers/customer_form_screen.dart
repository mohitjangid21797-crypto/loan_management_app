import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/utils/validators.dart';
import 'package:loan_management_app/domain/entities/customer.dart';
import 'package:loan_management_app/presentation/providers/customer_provider.dart';
import 'package:loan_management_app/presentation/providers/profile_provider.dart';
import 'package:loan_management_app/presentation/widgets/loading_overlay.dart';
import 'package:loan_management_app/presentation/widgets/photo_avatar.dart';

/// Add a customer, or edit one when [customerId] is given.
class CustomerFormScreen extends ConsumerStatefulWidget {
  const CustomerFormScreen({this.customerId, super.key});

  final String? customerId;

  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _address = TextEditingController();
  final _notes = TextEditingController();
  bool _smsConsent = false;
  String? _photoPath;
  Customer? _existing;
  bool _loaded = false;
  bool _saving = false;

  bool get _isEdit => widget.customerId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      unawaited(_load());
    } else {
      _loaded = true;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    _address.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final result = await ref
        .read(customerRepositoryProvider)
        .getCustomer(widget.customerId!);
    if (!mounted) {
      return;
    }
    final customer = result.valueOrNull;
    if (customer == null) {
      context.showSnack(context.l10n.customerNotFound);
      context.pop();
      return;
    }
    setState(() {
      _existing = customer;
      _name.text = customer.name;
      _mobile.text = customer.mobile;
      _address.text = customer.address;
      _notes.text = customer.notes;
      _smsConsent = customer.smsConsent;
      _photoPath = customer.photoPath;
      _loaded = true;
    });
  }

  Future<void> _pickPhoto() async {
    final path = await ref.read(photoServiceProvider).pickAndStore();
    if (path != null && mounted) {
      setState(() => _photoPath = path);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    final existing = _existing;
    final result = existing == null
        ? await ref.read(addCustomerProvider)(
            name: _name.text,
            mobile: _mobile.text,
            address: _address.text,
            notes: _notes.text,
            smsConsent: _smsConsent,
            photoPath: _photoPath,
          )
        : await ref.read(updateCustomerProvider)(
            existing,
            name: _name.text,
            mobile: _mobile.text,
            address: _address.text,
            notes: _notes.text,
            smsConsent: _smsConsent,
            photoPath: _photoPath,
          );
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    final failure = result.failureOrNull;
    if (failure != null) {
      context.showSnack(failure.message(context.l10n));
      return;
    }
    context.showSnack(context.l10n.customerSaved);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.customerEditTitle : l10n.customerAddTitle),
      ),
      body: LoadingOverlay(
        loading: !_loaded || _saving,
        child: !_loaded
            ? const SizedBox.expand()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      PhotoAvatar(
                        path: _photoPath,
                        placeholder: const Icon(Icons.add_a_photo_outlined),
                        onTap: _pickPhoto,
                        semanticLabel: l10n.customerChangePhoto,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.customerNameLabel,
                        ),
                        validator: (value) =>
                            Validators.name(value)?.message(l10n),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _mobile,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          labelText: l10n.customerMobileLabel,
                        ),
                        validator: (value) =>
                            Validators.mobile(value)?.message(l10n),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _address,
                        minLines: 1,
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.customerAddressLabel,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notes,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: l10n.customerNotesLabel,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.customerSmsConsent),
                        value: _smsConsent,
                        onChanged: (value) =>
                            setState(() => _smsConsent = value),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _saving ? null : _save,
                          child: Text(l10n.actionSave),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
