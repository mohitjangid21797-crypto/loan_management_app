import 'dart:io';

import 'package:flutter/material.dart' hide Text;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../models/index.dart';
import '../providers/app_provider.dart';
import '../utils/pdf_generator.dart';
import '../widgets/common_widgets.dart';
import '../widgets/localized_text.dart';

class AllPDFsScreen extends StatefulWidget {
  final String? loanId;

  const AllPDFsScreen({super.key, this.loanId});

  @override
  State<AllPDFsScreen> createState() => _AllPDFsScreenState();
}

class _AllPDFsScreenState extends State<AllPDFsScreen> {
  bool _isLoading = false;

  Future<void> _generatePDF(LoanDocument document) async {
    final languageCode = await _choosePDFLanguage();
    if (languageCode == null || !mounted) return;

    setState(() => _isLoading = true);

    final provider = context.read<AppProvider>();
    final lender = provider.lender;
    final customer = provider.getCustomerById(document.customerId);
    final loan = provider.getLoanById(document.loanId);
    final emis = provider.getEMIsByLoan(document.loanId);

    if (lender == null || customer == null || loan == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Missing data to generate PDF',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      final pdf = await PDFGenerator.generateLoanAgreement(
        lender: lender,
        customer: customer,
        loan: loan,
        emis: emis,
        languageCode: languageCode,
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/${document.fileName}');
      await file.writeAsBytes(await pdf.save());

      final updatedDocument = document.copyWith(filePath: file.path);
      await provider.addDocument(updatedDocument);

      if (mounted) {
        setState(() => _isLoading = false);
        _showPDFOptions(document, file, pdf);
      }

    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error generating PDF: $e',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<String?> _choosePDFLanguage() {
    final appLanguageCode = Localizations.localeOf(context).languageCode;
    const languageNames = {
      'en': 'English',
      'as': 'Assamese',
      'bn': 'Bengali',
      'gu': 'Gujarati',
      'hi': 'Hindi',
      'kn': 'Kannada',
      'ml': 'Malayalam',
      'mr': 'Marathi',
      'ne': 'Nepali',
      'or': 'Odia',
      'pa': 'Punjabi',
      'ta': 'Tamil',
      'te': 'Telugu',
      'ur': 'Urdu',
    };
    final options = <String, String>{
      'en': 'English',
      'hi': 'Hindi',
    };
    if (appLanguageCode != 'en' && appLanguageCode != 'hi') {
      options[appLanguageCode] =
          'Use selected app language (${languageNames[appLanguageCode] ?? appLanguageCode})';
    }

    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Choose PDF language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.entries
              .map(
                (option) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(option.value),
                  onTap: () => Navigator.pop(dialogContext, option.key),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showPDFOptions(LoanDocument document, File file, pw.Document pdf) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'PDF Generated',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              document.fileName,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.picture_as_pdf_rounded,
                    label: 'View PDF',
                    color: const Color(0xFF1E3A8A),
                    onTap: () {
                      Navigator.pop(context);
                      _viewPDF(pdf);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.share_rounded,
                    label: 'Share',
                    color: const Color(0xFF059669),
                    onTap: () {
                      Navigator.pop(context);
                      _sharePDF(file);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.edit_rounded,
                    label: 'Edit/Regenerate',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pop(context);
                      _generatePDF(document);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.delete_rounded,
                    label: 'Delete',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      _deleteDocument(document);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 88),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.55), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _viewPDF(pw.Document pdf) async {
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Future<void> _sharePDF(File file) async {
    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'Loan Agreement Document');
  }

  Future<void> _deleteDocument(LoanDocument document) async {
    final provider = context.read<AppProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Document',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete this PDF document?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
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

    if (confirmed == true) {
      await provider.deleteDocument(document.id);
      if (mounted) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Document deleted', style: GoogleFonts.inter()),
            backgroundColor: const Color(0xFF059669),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Map<String, List<LoanDocument>> _groupDocumentsByCustomer(
    List<LoanDocument> documents,
  ) {
    final provider = context.read<AppProvider>();
    final Map<String, List<LoanDocument>> grouped = {};

    for (final document in documents) {
      final customer = provider.getCustomerById(document.customerId);
      final key = customer?.mobileNumber ?? 'Unknown Customer';
      grouped.putIfAbsent(key, () => []).add(document);
    }

    for (final group in grouped.values) {
      group.sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        if (a == 'Unknown Customer') return 1;
        if (b == 'Unknown Customer') return -1;
        return a.compareTo(b);
      });

    final sortedMap = <String, List<LoanDocument>>{};
    for (final key in sortedKeys) {
      sortedMap[key] = grouped[key]!;
    }
    return sortedMap;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final documents = widget.loanId == null
        ? List<LoanDocument>.from(provider.documents)
        : provider.documents.where((d) => d.loanId == widget.loanId).toList();
    documents.sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
    final groupedDocuments = _groupDocumentsByCustomer(documents);
    final hasLoanFilter = widget.loanId != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          hasLoanFilter ? 'Loan Documents' : 'All PDFs',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(
          groupedDocuments,
          hasLoanFilter,
          documents.isNotEmpty,
        ),
      ),
    );
  }

  Widget _buildBody(
    Map<String, List<LoanDocument>> groupedDocuments,
    bool hasLoanFilter,
    bool hasDocuments,
  ) {
    if (!hasDocuments) {
      return EmptyState(
        icon: Icons.picture_as_pdf_rounded,
        title: 'No Documents Found',
        subtitle: widget.loanId != null
            ? 'Complete all EMI payments to generate loan agreement PDF'
            : 'Documents will appear here after loan completion',
        action: widget.loanId == null
            ? null
            : AppButton(
                text: 'Back to Loans',
                onPressed: () => Navigator.pop(context),
                backgroundColor: const Color(0xFF1E3A8A),
                width: 200,
              ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(24),
      children: _buildDocumentList(groupedDocuments, hasLoanFilter),
    );
  }

  List<Widget> _buildDocumentList(
    Map<String, List<LoanDocument>> groupedDocuments,
    bool hasLoanFilter,
  ) {
    final List<Widget> widgets = [];
    if (!hasLoanFilter) {
      widgets.add(
        Text(
          'Grouped by Customer',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      );
      widgets.add(const SizedBox(height: 16));
    }
    for (final customerKey in groupedDocuments.keys) {
      final docs = groupedDocuments[customerKey]!;
      widgets.add(_buildCustomerGroup(customerKey, docs));
    }
    return widgets;
  }

  Widget _buildCustomerGroup(String customerKey, List<LoanDocument> docs) {
    final isUnknown = customerKey == 'Unknown Customer';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isUnknown
                      ? Colors.grey[200]
                      : const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isUnknown ? Icons.person_off_rounded : Icons.person_rounded,
                  color: isUnknown ? Colors.grey[500] : const Color(0xFF1E3A8A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isUnknown ? 'Unknown Customer' : customerKey,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                    Text(
                      '${docs.length} ${localizedUiText(context, 'Documents')}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isUnknown) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${docs.length} ${localizedUiText(context, 'Documents')}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        ...docs.asMap().entries.map((entry) {
          final index = entry.key;
          final document = entry.value;
          final provider = context.read<AppProvider>();
          final customer = provider.getCustomerById(document.customerId);
          final loan = provider.getLoanById(document.loanId);
          return _buildDocumentCard(document, customer, loan, index);
        }),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDocumentCard(
    LoanDocument document,
    Customer? customer,
    Loan? loan,
    int index,
  ) {
    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
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
                      color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Color(0xFF1E3A8A),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.fileName.replaceAll('.pdf', ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${localizedUiText(context, 'Customer Details')}: ${customer?.name ?? localizedUiText(context, 'Unknown Customer')} • ${_formatDate(document.generatedAt)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isLoading)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: Colors.grey[500],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) => _handleMenuAction(value, document),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility_rounded, size: 18),
                              SizedBox(width: 8),
                              Text('View PDF'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(Icons.share_rounded, size: 18),
                              SizedBox(width: 8),
                              Text('Share'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_rounded, size: 18),
                              SizedBox(width: 8),
                              Text('Regenerate'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_rounded,
                                size: 18,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              if (loan != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: _buildInfoChip(
                          'Loan Amount',
                          '₹${loan.principalAmount.toStringAsFixed(0)}',
                          Icons.currency_rupee_rounded,
                        ),
                      ),
                      Container(height: 30, width: 1, color: Colors.grey[300]),
                      Flexible(
                        child: _buildInfoChip(
                          'EMIs',
                          '${document.paidEMIs}/${document.totalEMIs} ${localizedUiText(context, 'Paid')}',
                          Icons.receipt_long_rounded,
                        ),
                      ),
                      Container(height: 30, width: 1, color: Colors.grey[300]),
                      Flexible(
                        child: _buildInfoChip(
                          'Total',
                          '₹${document.totalAmount.toStringAsFixed(0)}',
                          Icons.account_balance_wallet_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        )
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: 100 * index),
        )
        .slideX(begin: 0.2);
  }

  Widget _buildInfoChip(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF1E3A8A)),
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
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E3A8A),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _handleMenuAction(String action, LoanDocument document) {
    switch (action) {
      case 'view':
        _viewDocument(document);
        break;
      case 'share':
        _shareDocument(document);
        break;
      case 'edit':
        _generatePDF(document);
        break;
      case 'delete':
        _deleteDocument(document);
        break;
    }
  }

  Future<void> _viewDocument(LoanDocument document) async {
    if (document.filePath.isNotEmpty) {
      await Printing.layoutPdf(
        onLayout: (_) async => File(document.filePath).readAsBytes(),
      );
    } else {
      _generatePDF(document);
    }
  }

  Future<void> _shareDocument(LoanDocument document) async {
    if (document.filePath.isNotEmpty) {
      await Share.shareXFiles([
        XFile(document.filePath),
      ], text: 'Loan Agreement Document');
    } else {
      _generatePDF(document);
    }
  }
}
