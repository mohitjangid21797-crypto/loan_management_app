import 'package:flutter/material.dart' hide Text;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/index.dart';
import '../providers/app_provider.dart';
import '../widgets/localized_text.dart';
import 'all_pdfs_screen.dart';

class EMIPaymentScreen extends StatefulWidget {
  final Loan loan;

  const EMIPaymentScreen({super.key, required this.loan});

  @override
  State<EMIPaymentScreen> createState() => _EMIPaymentScreenState();
}

class _EMIPaymentScreenState extends State<EMIPaymentScreen> {
  late List<EMI> _emis;
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    _emis = provider.getEMIsByLoan(widget.loan.id);
    _emis.sort((a, b) => a.installmentNumber.compareTo(b.installmentNumber));
  }

  void _refreshEMIs() {
    final provider = context.read<AppProvider>();
    setState(() {
      _emis = provider.getEMIsByLoan(widget.loan.id);
      _emis.sort((a, b) => a.installmentNumber.compareTo(b.installmentNumber));
    });
  }

  Future<void> _payEMI(EMI emi) async {
    final provider = context.read<AppProvider>();
    await provider.payEMI(emi.id);
    _refreshEMIs();
    _checkLoanCompletion();
  }

  Future<void> _payAllEMIs() async {
    final provider = context.read<AppProvider>();
    await provider.payAllEMIs(widget.loan.id);
    _refreshEMIs();
    _checkLoanCompletion();
  }

  void _checkLoanCompletion() {
    final allPaid = _emis.every((e) => e.status == EMIStatus.paid);
    if (allPaid) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AllPDFsScreen(loanId: widget.loan.id),
            ),
          );
        }
      });
    }
  }

  void _showPaymentDialog(EMI emi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Confirm Payment',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pay EMI #${emi.installmentNumber}?',
              style: GoogleFonts.inter(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount:',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                Text(
                  _currencyFormat.format(emi.amount),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E3A8A),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Due Date:',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                Text(
                  _dateFormat.format(emi.dueDate),
                  style: GoogleFonts.inter(),
                ),
              ],
            ),
          ],
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
            onPressed: () {
              Navigator.pop(context);
              _payEMI(emi);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Pay Now',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showPayAllDialog() {
    final pendingEMIs = _emis
        .where((e) => e.status == EMIStatus.pending)
        .toList();
    final totalAmount = pendingEMIs.fold(0.0, (sum, e) => sum + e.amount);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Pay All Pending EMIs',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pay ${pendingEMIs.length} pending EMIs at once?',
              style: GoogleFonts.inter(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount:',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _currencyFormat.format(totalAmount),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E3A8A),
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
            onPressed: () {
              Navigator.pop(context);
              _payAllEMIs();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Pay All',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingEMIs = _emis
        .where((e) => e.status == EMIStatus.pending)
        .toList();
    final paidEMIs = _emis.where((e) => e.status == EMIStatus.paid).toList();
    final overdueEMIs = _emis.where((e) => e.isOverdue).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'EMI Payments',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refreshEMIs,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Loan Summary Card
            Container(
              margin: const EdgeInsets.all(24),
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
                  Text(
                    'Loan Summary',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        '₹${_currencyFormat.format(widget.loan.principalAmount)}',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '• ${widget.loan.tenureMonths} ${localizedUiText(context, 'Months')}',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '• ${widget.loan.interestRate}%',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${paidEMIs.length} / ${_emis.length} ${localizedUiText(context, 'Paid')}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Repayment Progress',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_emis.isEmpty ? 0 : (paidEMIs.length / _emis.length * 100).toInt()}%',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOutCubic,
                            height: 8,
                            width:
                                MediaQuery.of(context).size.width *
                                0.75 *
                                (_emis.isEmpty
                                    ? 0
                                    : paidEMIs.length / _emis.length),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 360) {
                        return Column(
                          children: [
                            _buildSummaryStat(
                              'Paid',
                              paidEMIs.length.toString(),
                              const Color(0xFF059669),
                              compact: true,
                            ),
                            const SizedBox(height: 8),
                            _buildSummaryStat(
                              'Pending',
                              pendingEMIs.length.toString(),
                              const Color(0xFFDC2626),
                              compact: true,
                            ),
                            const SizedBox(height: 8),
                            _buildSummaryStat(
                              'Overdue',
                              overdueEMIs.length.toString(),
                              Colors.orange,
                              compact: true,
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          _buildSummaryStat(
                            'Paid',
                            paidEMIs.length.toString(),
                            const Color(0xFF059669),
                          ),
                          const SizedBox(width: 24),
                          _buildSummaryStat(
                            'Pending',
                            pendingEMIs.length.toString(),
                            const Color(0xFFDC2626),
                          ),
                          const SizedBox(width: 24),
                          _buildSummaryStat(
                            'Overdue',
                            overdueEMIs.length.toString(),
                            Colors.orange,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),

            // Pay All Button
            if (pendingEMIs.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _showPayAllDialog,
                    child: Row(
                      children: [
                        const Icon(Icons.payments_rounded),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${localizedUiText(context, 'Pay All Pending EMIs')} (${pendingEMIs.length})',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.3),
              ),

            const SizedBox(height: 16),

            // EMI List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _emis.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final emi = _emis[index];
                  return _buildEMICard(emi, index);
                },
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(
    String label,
    String value,
    Color color, {
    bool compact = false,
  }) {
    if (compact) {
      return Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      );
    }

    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEMICard(EMI emi, int index) {
    final isPaid = emi.status == EMIStatus.paid;
    final isOverdue = emi.isOverdue;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isPaid) {
      statusColor = const Color(0xFF059669);
      statusText = 'Paid';
      statusIcon = Icons.check_circle_rounded;
    } else if (isOverdue) {
      statusColor = Colors.red;
      statusText = 'Overdue';
      statusIcon = Icons.warning_rounded;
    } else {
      statusColor = Colors.orange;
      statusText = 'Pending';
      statusIcon = Icons.schedule_rounded;
    }

    final installmentBadge = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isPaid
            ? const Color(0xFF059669)
            : isOverdue
            ? Colors.red
            : const Color(0xFF1E3A8A).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          '${emi.installmentNumber}',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isPaid ? Colors.white : const Color(0xFF1E3A8A),
          ),
        ),
      ),
    );
    final emiDetails = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'EMI #${emi.installmentNumber}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _currencyFormat.format(emi.amount),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 13,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${localizedUiText(context, 'Due')}: ${_dateFormat.format(emi.dueDate)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        if (isPaid) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 13,
                color: Color(0xFF059669),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${localizedUiText(context, 'Paid')}: ${_dateFormat.format(emi.paidDate!)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
    final statusBadge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14, color: statusColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
    final payButton = ElevatedButton(
      onPressed: () => _showPaymentDialog(emi),
      style: ElevatedButton.styleFrom(
        backgroundColor: isOverdue ? Colors.red : const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        minimumSize: const Size(0, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      child: Text(
        'Pay Now',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );

    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isPaid
                ? const Color(0xFF059669).withValues(alpha: 0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPaid
                  ? const Color(0xFF059669).withValues(alpha: 0.2)
                  : isOverdue
                  ? Colors.red.withValues(alpha: 0.2)
                  : Colors.grey[200]!,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 480;
              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        installmentBadge,
                        const SizedBox(width: 12),
                        Expanded(child: emiDetails),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: statusBadge,
                    ),
                    if (!isPaid) ...[
                      const SizedBox(height: 8),
                      SizedBox(width: double.infinity, child: payButton),
                    ],
                  ],
                );
              }

              return Row(
                children: [
                  installmentBadge,
                  const SizedBox(width: 16),
                  Expanded(child: emiDetails),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      statusBadge,
                      if (!isPaid) ...[
                        const SizedBox(height: 8),
                        SizedBox(width: 100, child: payButton),
                      ],
                    ],
                  ),
                ],
              );
            },
          ),
        )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: 100 * (index % 10)),
        )
        .slideX(begin: 0.2);
  }
}
