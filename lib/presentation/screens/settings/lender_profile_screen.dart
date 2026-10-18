import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';
import 'package:loan_management_app/core/utils/validators.dart';
import 'package:loan_management_app/presentation/providers/profile_provider.dart';
import 'package:loan_management_app/presentation/widgets/photo_avatar.dart';

/// Edit the lender's name and photo.
class LenderProfileScreen extends ConsumerStatefulWidget {
  const LenderProfileScreen({super.key});

  @override
  ConsumerState<LenderProfileScreen> createState() =>
      _LenderProfileScreenState();
}

class _LenderProfileScreenState extends ConsumerState<LenderProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _photoPath;
  bool _loaded = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final result = await ref.read(profileRepositoryProvider).getProfile();
    if (!mounted) {
      return;
    }
    final profile = result.valueOrNull;
    setState(() {
      _nameController.text = profile?.name ?? '';
      _photoPath = profile?.photoPath;
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
    final result = await ref
        .read(profileRepositoryProvider)
        .saveProfile(name: _nameController.text, photoPath: _photoPath);
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    final failure = result.failureOrNull;
    context.showSnack(
      failure == null
          ? context.l10n.profileSaved
          : failure.message(context.l10n),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      PhotoAvatar(
                        path: _photoPath,
                        placeholder: const Icon(Icons.add_a_photo_outlined),
                        semanticLabel: l10n.profileChangePhoto,
                        onTap: _pickPhoto,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: l10n.profileNameLabel,
                        ),
                        validator: (value) =>
                            Validators.name(value)?.message(l10n),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
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
