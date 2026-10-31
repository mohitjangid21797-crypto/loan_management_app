import 'package:flutter/material.dart' hide Text;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/index.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/localized_text.dart';
import 'add_customer_screen.dart';
import 'create_loan_screen.dart';

class CustomersListScreen extends StatefulWidget {
  const CustomersListScreen({super.key});

  @override
  State<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  final _searchController = TextEditingController();
  List<Customer> _filteredCustomers = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _searchController.addListener(_filterCustomers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCustomers() {
    final provider = context.read<AppProvider>();
    setState(() {
      _filteredCustomers = List.from(provider.customers);
      _filteredCustomers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  void _filterCustomers() {
    final query = _searchController.text.toLowerCase();
    final provider = context.read<AppProvider>();
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredCustomers = List.from(provider.customers);
      } else {
        _filteredCustomers = provider.customers.where((c) =>
          c.name.toLowerCase().contains(query) ||
          c.mobileNumber.contains(query) ||
          c.email.toLowerCase().contains(query)
        ).toList();
      }
      _filteredCustomers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF1E3A8A)),
                decoration: InputDecoration(
                  hintText: localizedUiText(context, 'Search customers...'),
                  hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                  border: InputBorder.none,
                ),
                onChanged: (_) => _filterCustomers(),
              )
            : Text('Customers', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  _searchController.clear();
                  _filterCustomers();
                  setState(() => _isSearching = false);
                },
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => setState(() => _isSearching = true),
            ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
            ).then((_) => _loadCustomers()),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (!_isSearching)
              Padding(
                padding: const EdgeInsets.all(24),
                child: SearchField(
                  controller: _searchController,
                  hint: 'Search by name, mobile, or email',
                  onChanged: (_) => _filterCustomers(),
                ),
              ),
            Expanded(
              child: _filteredCustomers.isEmpty
                  ? EmptyState(
                      icon: Icons.people_outline_rounded,
                      title: _isSearching ? 'No Customers Found' : 'No Customers Yet',
                      subtitle: _isSearching
                          ? 'Try a different search term'
                          : 'Add your first customer to get started',
                      action: AppButton(
                        text: 'Add Customer',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
                        ).then((_) => _loadCustomers()),
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        width: 200,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: _filteredCustomers.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final customer = _filteredCustomers[index];
                        return _buildCustomerCard(customer, index);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: !_isSearching && _filteredCustomers.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
              ).then((_) => _loadCustomers()),
              icon: const Icon(Icons.person_add_rounded),
              label: Text('Add Customer', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white)),
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ).animate().scale(duration: 600.ms, delay: 800.ms, curve: Curves.elasticOut)
          : null,
    );
  }

  Widget _buildCustomerCard(Customer customer, int index) {
    final provider = context.read<AppProvider>();
    final loans = provider.getLoansByCustomer(customer.id);
    final activeLoans = loans.where((l) => l.status == 'active').toList();
    final totalLoanAmount = loans.fold(0.0, (sum, l) => sum + l.totalAmount);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    customer.name.isNotEmpty
                        ? customer.name[0].toUpperCase()
                        : '?',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        customer.mobileNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          height: 1.2,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        customer.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          height: 1.2,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                icon: Icon(Icons.more_vert_rounded, color: Colors.grey[500]),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) => _handleMenuAction(value, customer),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('View Details'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'loan',
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Create Loan'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: activeLoans.isNotEmpty
                          ? const Color(0xFF059669).withValues(alpha: 0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      activeLoans.isNotEmpty
                          ? '${activeLoans.length} ${localizedUiText(context, 'Active')}'
                          : localizedUiText(context, 'No Loans Yet'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: activeLoans.isNotEmpty
                            ? const Color(0xFF059669)
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${totalLoanAmount.toStringAsFixed(0)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total Loans',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        height: 1.2,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: Duration(milliseconds: 50 * index)).slideX(begin: 0.2);
  }

  void _handleMenuAction(String action, Customer customer) {
    switch (action) {
      case 'view':
        _showCustomerDetails(customer);
        break;
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddCustomerScreen(customer: customer)),
        ).then((_) => _loadCustomers());
        break;
      case 'loan':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CreateLoanScreen(preSelectedCustomer: customer)),
        ).then((_) => _loadCustomers());
        break;
      case 'delete':
        _deleteCustomer(customer);
        break;
    }
  }

  void _showCustomerDetails(Customer customer) {
    final provider = context.read<AppProvider>();
    final loans = provider.getLoansByCustomer(customer.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                      style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(customer.name, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF1E3A8A))),
                        Text(customer.mobileNumber, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600])),
                        Text(customer.email, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Location', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600])),
              Text(customer.location, style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF1E3A8A))),
              const SizedBox(height: 24),
              Text('${localizedUiText(context, 'Loans')} (${loans.length})', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF1E3A8A))),
              const SizedBox(height: 12),
              Expanded(
                child: loans.isEmpty
                    ? Center(
                        child: Text('No Loans Yet', style: GoogleFonts.inter(color: Colors.grey[500])),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        itemCount: loans.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final loan = loans[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '₹${loan.principalAmount.toStringAsFixed(0)}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF1E3A8A)),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: loan.status == 'active' ? const Color(0xFF059669).withValues(alpha: 0.1) : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        localizedUiText(
                                          context,
                                          loan.status == 'active'
                                              ? 'Active'
                                              : 'Completed',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: loan.status == 'active' ? const Color(0xFF059669) : Colors.grey[600]),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${loan.interestRate}% • ${loan.tenureMonths} ${localizedUiText(context, 'Months')} • ${localizedUiText(context, loan.interestType.name == 'simple' ? 'Simple Interest' : 'Compound Interest')}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${localizedUiText(context, 'Monthly EMI')}: ₹${loan.monthlyEMI.toStringAsFixed(2)}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF1E3A8A)),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${localizedUiText(context, 'Total Amount')}: ₹${loan.totalAmount.toStringAsFixed(2)}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteCustomer(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Customer', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to delete this customer? This will also delete all associated loans and EMIs.', style: GoogleFonts.inter()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey[600]))),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              navigator.pop();
              await context.read<AppProvider>().deleteCustomer(customer.id);
              _loadCustomers();
              if (mounted) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('Customer deleted', style: GoogleFonts.inter()), backgroundColor: const Color(0xFF059669), behavior: SnackBarBehavior.floating),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text('Delete', style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}