import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/index.dart';

class PDFGenerator {
  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: 'Rs.',
    decimalDigits: 2,
  );

  static Future<pw.Document> generateLoanAgreement({
    required Lender lender,
    required Customer customer,
    required Loan loan,
    required List<EMI> emis,
  }) async {
    final pdf = pw.Document();
    final paidEMIs = emis.where((e) => e.status == EMIStatus.paid).toList();
    final pendingEMIs = emis.where((e) => e.status == EMIStatus.pending).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(lender),
          pw.SizedBox(height: 24),
          _buildTitle(),
          pw.SizedBox(height: 24),
          _buildPartiesSection(lender, customer),
          pw.SizedBox(height: 24),
          _buildLoanDetails(loan),
          pw.SizedBox(height: 24),
          _buildEMISchedule(emis),
          pw.SizedBox(height: 24),
          _buildPaymentSummary(loan, paidEMIs, pendingEMIs),
          pw.SizedBox(height: 32),
          _buildSignatures(lender, customer),
          pw.SizedBox(height: 24),
          _buildFooter(),
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(Lender lender) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue900,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'LOAN MANAGEMENT SYSTEM',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Loan Agreement & Payment Summary',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey100,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Generated: ${_dateTimeFormat.format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey100),
              ),
              pw.Text(
                'Doc ID: ${lender.licenseNumber}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey100),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTitle() {
    return pw.Center(
      child: pw.Text(
        'LOAN AGREEMENT',
        style: pw.TextStyle(
          fontSize: 24,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  static pw.Widget _buildPartiesSection(Lender lender, Customer customer) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'PARTIES TO THE AGREEMENT',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: _buildPartyCard('LENDER', [
                'Name: ${lender.name}',
                'Mobile: ${lender.mobileNumber}',
                'Email: ${lender.email}',
                'Address: ${lender.address}',
                'License No: ${lender.licenseNumber}',
              ]),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _buildPartyCard('BORROWER', [
                'Name: ${customer.name}',
                'Mobile: ${customer.mobileNumber}',
                'Email: ${customer.email}',
                'Location: ${customer.location}',
              ]),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildPartyCard(String title, List<String> details) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.grey50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 8),
          ...details.map((d) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Text(d, style: const pw.TextStyle(fontSize: 10)),
              )),
        ],
      ),
    );
  }

  static pw.Widget _buildLoanDetails(Loan loan) {
    final interestTypeLabel = loan.interestType == InterestType.simple
        ? 'Simple Interest'
        : 'Compound Interest';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'LOAN DETAILS',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.5),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(1.5),
            3: const pw.FlexColumnWidth(2),
          },
          children: [
            _buildTableRow('Principal Amount', _currencyFormat.format(loan.principalAmount),
                'Interest Rate', '${loan.interestRate}% p.a.'),
            _buildTableRow('Tenure', '${loan.tenureMonths} Months',
                'Interest Type', interestTypeLabel),
            _buildTableRow('Start Date', _dateFormat.format(loan.startDate),
                'Monthly EMI', _currencyFormat.format(loan.monthlyEMI)),
            _buildTableRow('Total Interest', _currencyFormat.format(loan.totalInterest),
                'Total Payable', _currencyFormat.format(loan.totalAmount)),
            _buildTableRow('Loan Status', loan.status.toUpperCase(),
                'Loan ID', loan.id.substring(0, 8).toUpperCase()),
          ],
        ),
      ],
    );
  }

  static pw.TableRow _buildTableRow(String label1, String value1, String label2, String value2) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.white),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(label1, style: const pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value1, style: const pw.TextStyle(fontSize: 9)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(label2, style: const pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value2, style: const pw.TextStyle(fontSize: 9)),
        ),
      ],
    );
  }

  static pw.Widget _buildEMISchedule(List<EMI> emis) {
    // Sort EMIs by installment number
    final sortedEmis = List<EMI>.from(emis)..sort((a, b) => a.installmentNumber.compareTo(b.installmentNumber));
    
    // First page: 10 installments, subsequent pages: 30 installments
    const int firstPageCount = 10;
    const int subsequentPageCount = 30;
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'EMI SCHEDULE',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 12),
        ..._buildEMISchedulePages(sortedEmis, firstPageCount, subsequentPageCount),
      ],
    );
  }

  static List<pw.Widget> _buildEMISchedulePages(List<EMI> emis, int firstPageCount, int subsequentPageCount) {
    final List<pw.Widget> pages = [];
    int index = 0;
    bool isFirstPage = true;
    
    while (index < emis.length) {
      final pageCount = isFirstPage ? firstPageCount : subsequentPageCount;
      final pageEmis = emis.skip(index).take(pageCount).toList();
      
      if (pageEmis.isEmpty) break;
      
      pages.add(
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(1.5),
            2: const pw.FlexColumnWidth(1.5),
            3: const pw.FlexColumnWidth(1.5),
            4: const pw.FlexColumnWidth(1.5),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blue900),
              children: [
                _tableHeaderCell('Inst. #'),
                _tableHeaderCell('Due Date'),
                _tableHeaderCell('EMI Amount'),
                _tableHeaderCell('Status'),
                _tableHeaderCell('Paid Date'),
              ],
            ),
            ...pageEmis.map((emi) => pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: emi.status == EMIStatus.paid
                        ? PdfColors.green50
                        : emi.isOverdue
                            ? PdfColors.red50
                            : PdfColors.white,
                  ),
                  children: [
                    _tableCell(emi.installmentNumber.toString()),
                    _tableCell(_dateFormat.format(emi.dueDate)),
                    _tableCell(_currencyFormat.format(emi.amount)),
                    _tableCell(
                      emi.status.name.toUpperCase(),
                      color: emi.status == EMIStatus.paid
                          ? PdfColors.green800
                          : emi.isOverdue
                              ? PdfColors.red800
                              : PdfColors.orange800,
                    ),
                    _tableCell(emi.paidDate != null
                        ? _dateFormat.format(emi.paidDate!)
                        : '-'),
                  ],
                )),
          ],
        ),
      );
      
      if (!isFirstPage && index + pageCount < emis.length) {
        pages.add(pw.SizedBox(height: 20)); // Space between pages
        pages.add(
          pw.Text(
            'EMI SCHEDULE (Continued)',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
        );
        pages.add(pw.SizedBox(height: 12));
      }
      
      index += pageCount;
      isFirstPage = false;
    }
    
    return pages;
  }

  static pw.Widget _tableHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text,
          style: const pw.TextStyle(
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
          textAlign: pw.TextAlign.center),
    );
  }

  static pw.Widget _tableCell(String text, {PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text,
          style: pw.TextStyle(
            fontSize: 8,
            color: color ?? PdfColors.black,
          ),
          textAlign: pw.TextAlign.center),
    );
  }

  static pw.Widget _buildPaymentSummary(Loan loan, List<EMI> paidEMIs, List<EMI> pendingEMIs) {
    final totalPaid = paidEMIs.fold(0.0, (sum, e) => sum + e.amount);
    final totalPending = pendingEMIs.fold(0.0, (sum, e) => sum + e.amount);

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.grey50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'PAYMENT SUMMARY',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Total EMIs', loan.tenureMonths.toString()),
              _buildSummaryItem('Paid EMIs', paidEMIs.length.toString()),
              _buildSummaryItem('Pending EMIs', pendingEMIs.length.toString()),
            ],
          ),
          pw.Divider(thickness: 1, color: PdfColors.grey300),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Total Paid', _currencyFormat.format(totalPaid), isHighlight: true),
              _buildSummaryItem('Total Pending', _currencyFormat.format(totalPending), isHighlight: true),
              _buildSummaryItem('Total Loan', _currencyFormat.format(loan.totalAmount), isHighlight: true),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(String label, String value, {bool isHighlight = false}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey600,
            )),
        pw.SizedBox(height: 4),
        pw.Text(value,
            style: pw.TextStyle(
              fontSize: isHighlight ? 12 : 11,
              fontWeight: isHighlight ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: isHighlight ? PdfColors.blue900 : PdfColors.black,
            )),
      ],
    );
  }

  static pw.Widget _buildSignatures(Lender lender, Customer customer) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.Container(
                height: 60,
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey400, width: 1),
                  ),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Lender Signature', style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.Text(lender.name, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
              pw.Text('Date: ${_dateFormat.format(DateTime.now())}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
            ],
          ),
        ),
        pw.SizedBox(width: 32),
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.Container(
                height: 60,
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey400, width: 1),
                  ),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Borrower Signature', style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.Text(customer.name, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
              pw.Text('Date: ${_dateFormat.format(DateTime.now())}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300, width: 1)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'This document is computer-generated and does not require physical signature for validation.',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Loan Management System | Confidential Document',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }
}