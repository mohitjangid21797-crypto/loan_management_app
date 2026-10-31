import 'package:flutter/material.dart' hide Text;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/index.dart';
import '../providers/app_provider.dart';
import '../screens/add_customer_screen.dart';
import '../widgets/common_widgets.dart';
import '../widgets/localized_text.dart';

class CreateLoanScreen extends StatefulWidget {
  final Customer? preSelectedCustomer;

  const CreateLoanScreen({super.key, this.preSelectedCustomer});

  @override
  State<CreateLoanScreen> createState() => _CreateLoanScreenState();
}

class _CreateLoanScreenState extends State<CreateLoanScreen> {
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _tenureController = TextEditingController();

  Customer? _selectedCustomer;
  InterestType _interestType = InterestType.simple;
  bool _isLoading = false;
  bool _showLoanForm = false;

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedCustomer != null) {
      _selectedCustomer = widget.preSelectedCustomer;
      _showLoanForm = true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  void _searchCustomer(String query) {
    final digits = query.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) {
      setState(() {
        _selectedCustomer = null;
        _showLoanForm = false;
      });
      return;
    }

    final provider = context.read<AppProvider>();
    final customer = provider.getCustomerByMobile(query);

    setState(() {
      _selectedCustomer = customer;
      _showLoanForm = customer != null;
      if (customer != null) {
        _amountController.clear();
        _interestRateController.clear();
        _tenureController.clear();
      }
    });
  }

  Future<void> _createLoan() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomer == null) return;

    setState(() => _isLoading = true);

    final provider = context.read<AppProvider>();
    final loan = Loan(
      customerId: _selectedCustomer!.id,
      principalAmount: double.parse(_amountController.text),
      interestRate: double.parse(_interestRateController.text),
      tenureMonths: int.parse(_tenureController.text),
      interestType: _interestType,
    );

    await provider.addLoan(loan);

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Loan created successfully! EMIs generated.',
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
    final showSearch =
        widget.preSelectedCustomer == null && _selectedCustomer == null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Create Loan',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Section (only show when no pre-selected customer)
                if (showSearch) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.search_rounded,
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
                                    'Find Customer',
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Search by mobile number to create loan',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SearchField(
                          controller: _searchController,
                          hint: 'Enter 10-digit mobile number',
                          onChanged: _searchCustomer,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),

                  const SizedBox(height: 32),
                ],

                // Customer Found Card
                if (_selectedCustomer != null) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF059669).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Customer Found',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF059669),
                                ),
                              ),
                              Text(
                                _selectedCustomer!.name,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_selectedCustomer!.mobileNumber} • ${_selectedCustomer!.email}',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.grey[500],
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedCustomer = null;
                              _showLoanForm = false;
                              _searchController.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

                  const SizedBox(height: 24),
                ],

                // Loan Form
                if (_showLoanForm) ...[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                              'Loan Details',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E3A8A),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideX(begin: -0.3),

                        const SizedBox(height: 20),

                        AppTextField(
                          controller: _amountController,
                          label: 'Loan Amount (₹)',
                          hint: 'Enter principal amount',
                          icon: Icons.currency_rupee_rounded,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter loan amount';
                            }
                            final amount = double.tryParse(value);
                            if (amount == null || amount <= 0) {
                              return 'Enter a valid amount';
                            }
                            return null;
                          },
                          delay: 100,
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: _interestRateController,
                                label: 'Interest Rate (% p.a.)',
                                hint: 'e.g., 10.5',
                                icon: Icons.percent_rounded,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  final rate = double.tryParse(value);
                                  if (rate == null || rate <= 0 || rate > 50) {
                                    return 'Enter valid rate (1-50%)';
                                  }
                                  return null;
                                },
                                delay: 200,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AppTextField(
                                controller: _tenureController,
                                label: 'Tenure (Months)',
                                hint: 'e.g., 24',
                                icon: Icons.calendar_month_rounded,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  final tenure = int.tryParse(value);
                                  if (tenure == null ||
                                      tenure <= 0 ||
                                      tenure > 360) {
                                    return 'Enter valid tenure (1-360)';
                                  }
                                  return null;
                                },
                                delay: 300,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Interest Type Selection
                        Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Interest Type',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF1E3A8A),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInterestTypeCard(
                                        title: 'Simple Interest',
                                        subtitle: 'Interest calculated on principal only',
                                        icon: Icons.calculate_rounded,
                                        type: InterestType.simple,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildInterestTypeCard(
                                        title: 'Compound Interest',
                                        subtitle: 'Interest calculated on principal + accumulated interest',
                                        icon: Icons.account_tree_rounded,
                                        type: InterestType.compound,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 400.ms)
                            .slideX(begin: -0.3),

                        const SizedBox(height: 24),

                        // EMI Preview
                        if (_amountController.text.isNotEmpty &&
                            _interestRateController.text.isNotEmpty &&
                            _tenureController.text.isNotEmpty)
                          _buildEMIPreview(),

                        const SizedBox(height: 32),

                        AppButton(
                              text: 'Create Loan',
                              onPressed: _isLoading ? null : _createLoan,
                              isLoading: _isLoading,
                              icon: Icons.add_circle_rounded,
                            )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 500.ms)
                            .slideY(begin: 0.3),
                      ],
                    ),
                  ),
                ] else if (_searchController.text.length >= 10 &&
                    _selectedCustomer == null) ...[
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_off_rounded,
                            size: 48,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Customer Not Found',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No customer registered with this mobile number.\nPlease add the customer first.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          text: 'Add New Customer',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddCustomerScreen(),
                            ),
                          ),
                          backgroundColor: const Color(0xFF059669),
                          icon: Icons.person_add_rounded,
                          width: 250,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInterestTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required InterestType type,
  }) {
    final isSelected = _interestType == type;
    return InkWell(
      onTap: () => setState(() => _interestType = type),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1E3A8A).withValues(alpha: 0.1)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEMIPreview() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final rate = double.tryParse(_interestRateController.text) ?? 0;
    final tenure = int.tryParse(_tenureController.text) ?? 0;

    if (amount == 0 || rate == 0 || tenure == 0) return const SizedBox.shrink();

    final monthlyRate = rate / 100 / 12;
    double emi;
    double totalInterest;

    if (_interestType == InterestType.simple) {
      totalInterest = (amount * rate * tenure) / (100 * 12);
      emi = (amount + totalInterest) / tenure;
    } else {
      totalInterest = amount * (pow(1 + monthlyRate, tenure) - 1);
      emi =
          (amount * monthlyRate * pow(1 + monthlyRate, tenure)) /
          (pow(1 + monthlyRate, tenure) - 1);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1E3A8A).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EMI Preview',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _previewItem(
                  'Monthly EMI',
                  '₹${emi.toStringAsFixed(2)}',
                  Icons.currency_rupee_rounded,
                ),
              ),
              Container(height: 50, width: 1, color: Colors.grey[300]),
              Expanded(
                child: _previewItem(
                  'Total Interest',
                  '₹${totalInterest.toStringAsFixed(2)}',
                  Icons.percent_rounded,
                ),
              ),
              Container(height: 50, width: 1, color: Colors.grey[300]),
              Expanded(
                child: _previewItem(
                  'Total Payable',
                  '₹${(amount + totalInterest).toStringAsFixed(2)}',
                  Icons.account_balance_wallet_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2);
  }

  Widget _previewItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E3A8A),
          ),
        ),
      ],
    );
  }

  double pow(double base, int exponent) {
    double result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}
