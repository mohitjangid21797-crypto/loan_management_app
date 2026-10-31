import 'package:flutter/material.dart' hide Text;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/index.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/localized_text.dart';

class AddCustomerScreen extends StatefulWidget {
  final Customer? customer;

  const AddCustomerScreen({super.key, this.customer});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _nameController.text = widget.customer!.name;
      _mobileController.text = widget.customer!.mobileNumber;
      _emailController.text = widget.customer!.email;
      _locationController.text = widget.customer!.location;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = context.read<AppProvider>();
    final customer = Customer(
      id: widget.customer?.id,
      name: _nameController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      email: _emailController.text.trim(),
      location: _locationController.text.trim(),
      createdAt: widget.customer?.createdAt,
    );

    if (widget.customer == null) {
      await provider.addCustomer(customer);
    } else {
      await provider.updateCustomer(customer);
    }

    if (mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.customer == null
                ? 'Customer added successfully!'
                : 'Customer updated successfully!',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.customer != null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Customer' : 'Add Customer',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isEditing
                                ? Icons.edit_rounded
                                : Icons.person_add_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEditing ? 'Edit Customer' : 'Add New Customer',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                isEditing
                                    ? 'Customer Details'
                                    : 'Add your first customer to get started',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),

                  const SizedBox(height: 32),

                  AppTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Enter customer\'s full name',
                    icon: Icons.person_outline_rounded,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter customer name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                    delay: 100,
                  ),

                  const SizedBox(height: 20),

                  AppTextField(
                    controller: _mobileController,
                    label: 'Mobile Number',
                    hint: 'Enter 10-digit mobile number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter mobile number';
                      }
                      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                        return 'Enter a valid 10-digit Indian mobile number';
                      }
                      return null;
                    },
                    delay: 200,
                  ),

                  const SizedBox(height: 20),

                  AppTextField(
                    controller: _emailController,
                    label: 'Email ID',
                    hint: 'Enter customer\'s email address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email address';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    delay: 300,
                  ),

                  const SizedBox(height: 20),

                  AppTextField(
                    controller: _locationController,
                    label: 'Location',
                    hint: 'Enter city, state (e.g., Mumbai, Maharashtra)',
                    icon: Icons.location_on_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter location';
                      }
                      return null;
                    },
                    delay: 400,
                  ),

                  const SizedBox(height: 32),

                  AppButton(
                        text: isEditing ? 'Update Customer' : 'Add Customer',
                        onPressed: _isLoading ? null : _saveCustomer,
                        isLoading: _isLoading,
                        icon: isEditing
                            ? Icons.save_rounded
                            : Icons.person_add_rounded,
                        foregroundColor: Colors.white,
                      )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 500.ms)
                      .slideY(begin: 0.3),

                  if (isEditing) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isLoading
                            ? null
                            : () => _showDeleteConfirmation(
                                context,
                                context.read<AppProvider>(),
                              ),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                        ),
                        label: Text(
                          'Delete Customer',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Customer',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete this customer? This will also delete all associated loans and EMIs.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              navigator.pop();
              await provider.deleteCustomer(widget.customer!.id);
              if (mounted) {
                navigator.pop(true);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Customer deleted successfully!',
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: const Color(0xFF059669),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
