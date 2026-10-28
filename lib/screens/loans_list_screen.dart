import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/index.dart';
import '../providers/app_provider.dart';
import '../screens/create_loan_screen.dart';
import '../widgets/common_widgets.dart';
import 'emi_payment_screen.dart';
import 'all_pdfs_screen.dart';

class LoansListScreen extends StatefulWidget {
  const LoansListScreen({super.key});

  @override
  State<LoansListScreen> createState() => _LoansListScreenState();
}

class _LoansListScreenState extends State<LoansListScreen> {
  final _searchController = TextEditingController();
  List<Loan> _filteredLoans = [];
  bool _isSearching = false;
  String _filterStatus = 'all'; // all, active, completed

  @override
  void initState() {
    super.initState();
    _loadLoans();
    _searchController.addListener(_filterLoans);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadLoans() {
    final provider = context.read<AppProvider>();
    setState(() {
      _filteredLoans = List.from(provider.loans);
      _filteredLoans.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  void _filterLoans() {
    final query = _searchController.text.toLowerCase();
    final provider = context.read<AppProvider>();
    setState(() {
      _isSearching = query.isNotEmpty;
      var loans = List<Loan>.from(provider.loans);
      
      if (_filterStatus != 'all') {
        loans = loans.where((l) => l.status == _filterStatus).toList();
      }
      
      if (query.isNotEmpty) {
        loans = loans.where((l) {
          final customer = provider.getCustomerById(l.customerId);
          return l.id.toLowerCase().contains(query) ||
              (customer?.name.toLowerCase().contains(query) ?? false) ||
              (customer?.mobileNumber.contains(query) ?? false);
        }).toList();
      }
      
      _filteredLoans = loans;
      _filteredLoans.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF1E3A8A)),
                decoration: InputDecoration(
                  hintText: 'Search loans...',
                  hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                  border: InputBorder.none,
                ),
                onChanged: (_) => _filterLoans(),
              )
            : Text('Loans', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  _searchController.clear();
                  _filterLoans();
                  setState(() => _isSearching = false);
                },
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [
          if (!_isSearching)
            PopupMenuButton<String>(
              icon: Icon(Icons.filter_list_rounded, color: Colors.grey[700]),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (value) {
                setState(() {
                  _filterStatus = value;
                  _filterLoans();
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'all', child: Text('All Loans')),
                const PopupMenuItem(value: 'active', child: Text('Active Only')),
                const PopupMenuItem(value: 'completed', child: Text('Completed Only')),
              ],
            ),
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => setState(() => _isSearching = true),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (!_isSearching) ...[
              Padding(
                padding: const EdgeInsets.all(24),
                child: SearchField(
                  controller: _searchController,
                  hint: 'Search by loan ID, customer name, or mobile',
                  onChanged: (_) => _filterLoans(),
                ),
              ),
              // Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Active', 'active'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Completed', 'completed'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: _filteredLoans.isEmpty
                  ? EmptyState(
                      icon: Icons.account_balance_wallet_outlined,
                      title: _isSearching ? 'No Loans Found' : 'No Loans Yet',
                      subtitle: _isSearching
                          ? 'Try a different search term or filter'
                          : 'Create your first loan to get started',
                      action: AppButton(
                        text: 'Create Loan',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CreateLoanScreen()),
                        ).then((_) => _loadLoans()),
                        backgroundColor: const Color(0xFF1E3A8A),
                        width: 200,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: _filteredLoans.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final loan = _filteredLoans[index];
                        return _buildLoanCard(loan, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500)),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _filterStatus = value;
          _filterLoans();
        });
      },
      backgroundColor: Colors.grey[100],
      selectedColor: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
      checkmarkColor: const Color(0xFF1E3A8A),
      labelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey[700],
      ),
      side: BorderSide(
        color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey[200]!,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildLoanCard(Loan loan, int index) {
    final provider = context.read<AppProvider>();
    final customer = provider.getCustomerById(loan.customerId);
    final emis = provider.getEMIsByLoan(loan.id);
    final paidEMIs = emis.where((e) => e.status == EMIStatus.paid).length;
    final pendingEMIs = emis.where((e) => e.status == EMIStatus.pending).toList();
    final nextEMI = pendingEMIs.isNotEmpty ? pendingEMIs.first : null;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(loan.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getLoanIcon(loan),
                  color: _getStatusColor(loan.status),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            customer?.name ?? 'Unknown Customer',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1E3A8A)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(loan.status).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              loan.status.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: _getStatusColor(loan.status)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer?.mobileNumber ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '₹${loan.principalAmount.toStringAsFixed(0)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF1E3A8A)),
                    ),
                    Text(
                      'Total: ₹${loan.totalAmount.toStringAsFixed(0)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Flexible(child: _buildInfoItem('Interest', '${loan.interestRate}% ${loan.interestType.name}', Icons.percent_rounded)),
              Container(height: 40, width: 1, color: Colors.grey[200]),
              Flexible(child: _buildInfoItem('Tenure', '${loan.tenureMonths} Months', Icons.calendar_month_rounded)),
              Container(height: 40, width: 1, color: Colors.grey[200]),
              Flexible(child: _buildInfoItem('Monthly EMI', '₹${loan.monthlyEMI.toStringAsFixed(2)}', Icons.currency_rupee_rounded)),
            ],
          ),
          const SizedBox(height: 16),
          // Progress
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 360;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Progress', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600])),
                                Text('$paidEMIs / ${loan.tenureMonths} Paid', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1E3A8A))),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Stack(
                              children: [
                                Container(height: 6, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(3))),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  height: 6,
                                  width: constraints.maxWidth * 0.7 * (paidEMIs / loan.tenureMonths),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)]),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (!isNarrow) const SizedBox(width: 16),
                      if (nextEMI != null)
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: nextEMI.isOverdue ? Colors.red.withValues(alpha: 0.1) : const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: nextEMI.isOverdue ? Colors.red.withValues(alpha: 0.3) : const Color(0xFF1E3A8A).withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Next EMI', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[600])),
                                Text('₹${nextEMI.amount.toStringAsFixed(2)}', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: nextEMI.isOverdue ? Colors.red : const Color(0xFF1E3A8A))),
                                Text('Due: ${DateFormat('dd MMM').format(nextEMI.dueDate)}', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[500])),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
          if (loan.status == 'active') ...[
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 360;
                if (isNarrow) {
                  return Column(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EMIPaymentScreen(loan: loan)),
                        ).then((_) => _loadLoans()),
                        icon: const Icon(Icons.payment_rounded, size: 18),
                        label: Text('Pay EMI', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1E3A8A),
                          side: const BorderSide(color: Color(0xFF1E3A8A)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AllPDFsScreen(loanId: loan.id)),
                        ),
                        icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                        label: Text('View PDF', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EMIPaymentScreen(loan: loan)),
                        ).then((_) => _loadLoans()),
                        icon: const Icon(Icons.payment_rounded, size: 18),
                        label: Text('Pay EMI', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1E3A8A),
                          side: const BorderSide(color: Color(0xFF1E3A8A)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AllPDFsScreen(loanId: loan.id)),
                        ),
                        icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                        label: Text('View PDF', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: Duration(milliseconds: 50 * index)).slideX(begin: 0.2);
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1E3A8A)),
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[600]),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1E3A8A)),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return const Color(0xFF059669);
      case 'completed':
        return const Color(0xFF1E3A8A);
      default:
        return Colors.grey;
    }
  }

  IconData _getLoanIcon(Loan loan) {
    // You could add loan type to the model
    return Icons.account_balance_wallet_rounded;
  }
}