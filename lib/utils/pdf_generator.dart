import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';

import 'indic_pdf_generator.dart';
import '../l10n/ui_translations.dart';
import '../models/index.dart';

class PDFGenerator {
  static NumberFormat _currencyFormat(String languageCode) =>
      NumberFormat.currency(
        locale: 'en_IN',
        symbol: '${_translateKey(languageCode, 'currencySymbol')} ',
        decimalDigits: 2,
      );

  static Future<Uint8List> generateLoanAgreement({
    required Lender lender,
    required Customer customer,
    required Loan loan,
    required List<EMI> emis,
    required String languageCode,
  }) async {
    await initializeDateFormatting(languageCode);
    if (IndicPdfGenerator.supportsLanguage(languageCode)) {
      return IndicPdfGenerator.generateLoanAgreement(
        lender: lender,
        customer: customer,
        loan: loan,
        emis: emis,
        languageCode: languageCode,
      );
    }

    final font = await _loadFont(languageCode);
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: font,
        italic: font,
        boldItalic: font,
        fontFallback: [pw.Font.helvetica()],
      ),
    );
    final paidEMIs = emis.where((e) => e.status == EMIStatus.paid).toList();
    final pendingEMIs = emis
        .where((e) => e.status == EMIStatus.pending)
        .toList();
    final sortedEmis = List<EMI>.from(emis)
      ..sort((a, b) => a.installmentNumber.compareTo(b.installmentNumber));

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Directionality(
          textDirection: _textDirection(languageCode),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(lender, languageCode, compact: true),
              pw.SizedBox(height: 8),
              _buildTitle(languageCode, compact: true),
              pw.SizedBox(height: 8),
              _buildPartiesSection(
                lender,
                customer,
                languageCode,
                compact: true,
              ),
              pw.SizedBox(height: 8),
              _buildLoanDetails(loan, languageCode, compact: true),
              pw.SizedBox(height: 8),
              _buildEMIScheduleHeading(languageCode),
              pw.SizedBox(height: 4),
              _buildEMIScheduleTable(
                sortedEmis.take(30).toList(),
                languageCode,
                compact: true,
              ),
            ],
          ),
        ),
      ),
    );

    for (var index = 30; index < sortedEmis.length; index += 60) {
      final pageEmis = sortedEmis.skip(index).take(60).toList();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => pw.Directionality(
            textDirection: _textDirection(languageCode),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildEMIScheduleHeading(languageCode, continued: true),
                pw.SizedBox(height: 12),
                _buildEMIScheduleTable(pageEmis, languageCode, compact: true),
              ],
            ),
          ),
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Directionality(
          textDirection: _textDirection(languageCode),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildPaymentSummary(loan, paidEMIs, pendingEMIs, languageCode),
              pw.SizedBox(height: 32),
              _buildSignatures(lender, customer, languageCode),
              pw.SizedBox(height: 24),
              _buildFooter(languageCode),
            ],
          ),
        ),
      ),
    );

    return pdf.save();
  }

  static String monthNameFor(String languageCode, int month) =>
      IndicPdfGenerator.monthNameFor(languageCode, month);

  static String _translateKey(String languageCode, String key) =>
      UiTranslations.translateKey(languageCode, key);

  static pw.TextDirection _textDirection(String languageCode) =>
      languageCode == 'ur' ? pw.TextDirection.rtl : pw.TextDirection.ltr;

  static Future<pw.Font> _loadFont(String languageCode) async {
    final family = switch (languageCode) {
      'as' || 'bn' => 'NotoSansBengali',
      'gu' => 'NotoSansGujarati',
      'hi' || 'mr' || 'ne' => 'NotoSansDevanagari',
      'kn' => 'NotoSansKannada',
      'ml' => 'NotoSansMalayalam',
      'or' => 'NotoSansOriya',
      'pa' => 'NotoSansGurmukhi',
      'ta' => 'NotoSansTamil',
      'te' => 'NotoSansTelugu',
      'ur' => 'NotoSansArabic',
      _ => 'NotoSansDevanagari',
    };
    final data = await rootBundle.load('assets/fonts/$family-Regular.ttf');
    return pw.Font.ttf(data);
  }

  static String _formatDate(DateTime date, String languageCode) =>
      IndicPdfGenerator.formatDate(date, languageCode);

  static String _formatDateTime(DateTime date, String languageCode) =>
      IndicPdfGenerator.formatDateTime(date, languageCode);

  static pw.Widget _buildHeader(
    Lender lender,
    String languageCode, {
    bool compact = false,
  }) {
    return pw.Container(
      padding: pw.EdgeInsets.all(compact ? 10 : 16),
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
                _translateKey(languageCode, 'appTitle'),
                style: pw.TextStyle(
                  fontSize: compact ? 14 : 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                _translateKey(languageCode, 'pdfAgreementSubtitle'),
                style: pw.TextStyle(
                  fontSize: compact ? 9 : 12,
                  color: PdfColors.grey100,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                '${_translateKey(languageCode, 'generatedLabel')}: ${_formatDateTime(DateTime.now(), languageCode)}',
                style: pw.TextStyle(
                  fontSize: compact ? 8 : 10,
                  color: PdfColors.grey100,
                ),
              ),
              pw.Text(
                '${_translateKey(languageCode, 'docIdLabel')}: ${lender.licenseNumber}',
                style: pw.TextStyle(
                  fontSize: compact ? 8 : 10,
                  color: PdfColors.grey100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTitle(String languageCode, {bool compact = false}) {
    return pw.Center(
      child: pw.Text(
        _translateKey(languageCode, 'loanAgreementTitle'),
        style: pw.TextStyle(
          fontSize: compact ? 18 : 24,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue900,
          letterSpacing: languageCode == 'en' ? 1.5 : 0,
        ),
      ),
    );
  }

  static pw.Widget _buildPartiesSection(
    Lender lender,
    Customer customer,
    String languageCode, {
    bool compact = false,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          _translateKey(languageCode, 'partiesTitle'),
          style: pw.TextStyle(
            fontSize: compact ? 11 : 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: compact ? 6 : 12),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: _buildPartyCard(
                'lenderLabel',
                [
                  '${_translateKey(languageCode, 'lenderName')}: ${lender.name}',
                  '${_translateKey(languageCode, 'mobileLabelShort')}: ${lender.mobileNumber}',
                  '${_translateKey(languageCode, 'emailLabelShort')}: ${lender.email}',
                  '${_translateKey(languageCode, 'addressLabel')}: ${lender.address}',
                  '${_translateKey(languageCode, 'licenseLabel')}: ${lender.licenseNumber}',
                ],
                languageCode,
                compact: compact,
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _buildPartyCard(
                'borrowerLabel',
                [
                  '${_translateKey(languageCode, 'borrowerName')}: ${customer.name}',
                  '${_translateKey(languageCode, 'mobileLabelShort')}: ${customer.mobileNumber}',
                  '${_translateKey(languageCode, 'emailLabelShort')}: ${customer.email}',
                  '${_translateKey(languageCode, 'locationLabelShort')}: ${customer.location}',
                ],
                languageCode,
                compact: compact,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildPartyCard(
    String title,
    List<String> details,
    String languageCode, {
    bool compact = false,
  }) {
    return pw.Container(
      padding: pw.EdgeInsets.all(compact ? 7 : 12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.grey50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            _translateKey(languageCode, title),
            style: pw.TextStyle(
              fontSize: compact ? 9 : 11,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: compact ? 4 : 8),
          ...details.map(
            (d) => pw.Padding(
              padding: pw.EdgeInsets.only(bottom: compact ? 2 : 4),
              child: pw.Text(
                d,
                style: pw.TextStyle(fontSize: compact ? 8 : 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildLoanDetails(
    Loan loan,
    String languageCode, {
    bool compact = false,
  }) {
    final loanStatus = switch (loan.status.toLowerCase()) {
      'active' => _translateKey(languageCode, 'activeFilter'),
      'completed' => _translateKey(languageCode, 'completedFilter'),
      _ => _titleCase(loan.status),
    };
    final interestTypeLabel = loan.interestType == InterestType.simple
        ? _translateKey(languageCode, 'simpleInterestLabel')
        : _translateKey(languageCode, 'compoundInterestLabel');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          _translateKey(languageCode, 'loanDetailsTitle'),
          style: pw.TextStyle(
            fontSize: compact ? 11 : 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: compact ? 6 : 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.5),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(1.5),
            3: const pw.FlexColumnWidth(2),
          },
          children: [
            _buildTableRow(
              'principalAmountLabel',
              _currencyFormat(languageCode).format(loan.principalAmount),
              'interestRateLabelFull',
              '${loan.interestRate}% ${_translateKey(languageCode, 'annualRateSuffix')}',
              languageCode,
              compact: compact,
            ),
            _buildTableRow(
              'tenureLabelFull',
              '${loan.tenureMonths} ${_translateKey(languageCode, 'monthsCount')}',
              'interestTypeLabel',
              interestTypeLabel,
              languageCode,
              compact: compact,
            ),
            _buildTableRow(
              'startDateLabel',
              _formatDate(loan.startDate, languageCode),
              'monthlyEmiLabel',
              _currencyFormat(languageCode).format(loan.monthlyEMI),
              languageCode,
              compact: compact,
            ),
            _buildTableRow(
              'totalInterestLabel',
              _currencyFormat(languageCode).format(loan.totalInterest),
              'totalPayableLabel',
              _currencyFormat(languageCode).format(loan.totalAmount),
              languageCode,
              compact: compact,
            ),
            _buildTableRow(
              'loanStatusLabel',
              loanStatus,
              'loanIdLabel',
              loan.id.substring(0, 8).toUpperCase(),
              languageCode,
              compact: compact,
            ),
          ],
        ),
      ],
    );
  }

  static pw.TableRow _buildTableRow(
    String label1,
    String value1,
    String label2,
    String value2,
    String languageCode, {
    bool compact = false,
  }) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.white),
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.all(compact ? 4 : 8),
          child: pw.Text(
            _translateKey(languageCode, label1),
            style: pw.TextStyle(
              fontSize: compact ? 7 : 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(compact ? 4 : 8),
          child: pw.Text(
            value1,
            style: pw.TextStyle(fontSize: compact ? 7 : 9),
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(compact ? 4 : 8),
          child: pw.Text(
            _translateKey(languageCode, label2),
            style: pw.TextStyle(
              fontSize: compact ? 7 : 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(compact ? 4 : 8),
          child: pw.Text(
            value2,
            style: pw.TextStyle(fontSize: compact ? 7 : 9),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildEMIScheduleHeading(
    String languageCode, {
    bool continued = false,
  }) {
    return pw.Text(
      _translateKey(languageCode, 'emiScheduleTitle'),
      style: pw.TextStyle(
        fontSize: continued ? 12 : 14,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue900,
      ),
    );
  }

  static pw.Widget _buildEMIScheduleTable(
    List<EMI> emis,
    String languageCode, {
    bool compact = false,
  }) {
    return pw.Table(
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
            _tableHeaderCell(
              'installmentHeader',
              languageCode,
              compact: compact,
            ),
            _tableHeaderCell('dueDateHeader', languageCode, compact: compact),
            _tableHeaderCell('emiAmountHeader', languageCode, compact: compact),
            _tableHeaderCell('statusHeader', languageCode, compact: compact),
            _tableHeaderCell('paidDateHeader', languageCode, compact: compact),
          ],
        ),
        ...emis.map(
          (emi) => pw.TableRow(
            decoration: pw.BoxDecoration(
              color: emi.status == EMIStatus.paid
                  ? PdfColors.green50
                  : emi.isOverdue
                  ? PdfColors.red50
                  : PdfColors.white,
            ),
            children: [
              _tableCell(emi.installmentNumber.toString(), compact: compact),
              _tableCell(
                _formatDate(emi.dueDate, languageCode),
                compact: compact,
              ),
              _tableCell(
                _currencyFormat(languageCode).format(emi.amount),
                compact: compact,
              ),
              _tableCell(
                _translateKey(languageCode, switch (emi.status) {
                  EMIStatus.paid => 'emiPaid',
                  EMIStatus.pending => 'emiPending',
                  EMIStatus.overdue => 'emiOverdue',
                }),
                compact: compact,
                color: emi.status == EMIStatus.paid
                    ? PdfColors.green800
                    : emi.isOverdue
                    ? PdfColors.red800
                    : PdfColors.orange800,
              ),
              _tableCell(
                emi.paidDate != null
                    ? _formatDate(emi.paidDate!, languageCode)
                    : '-',
                compact: compact,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _tableHeaderCell(
    String text,
    String languageCode, {
    bool compact = false,
  }) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(compact ? 2 : 6),
      child: pw.Text(
        _translateKey(languageCode, text),
        style: pw.TextStyle(
          fontSize: compact ? 6 : 8,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _tableCell(
    String text, {
    PdfColor? color,
    bool compact = false,
  }) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(compact ? 2 : 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: compact ? 6 : 8,
          color: color ?? PdfColors.black,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildPaymentSummary(
    Loan loan,
    List<EMI> paidEMIs,
    List<EMI> pendingEMIs,
    String languageCode,
  ) {
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
            _translateKey(languageCode, 'paymentSummaryTitle'),
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
              _buildSummaryItem(
                'totalEmisLabel',
                loan.tenureMonths.toString(),
                languageCode,
              ),
              _buildSummaryItem(
                'paidEmisLabel',
                paidEMIs.length.toString(),
                languageCode,
              ),
              _buildSummaryItem(
                'pendingEmisLabel',
                pendingEMIs.length.toString(),
                languageCode,
              ),
            ],
          ),
          pw.Divider(thickness: 1, color: PdfColors.grey300),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                'totalPaidLabel',
                _currencyFormat(languageCode).format(totalPaid),
                languageCode,
                isHighlight: true,
              ),
              _buildSummaryItem(
                'totalPendingLabel',
                _currencyFormat(languageCode).format(totalPending),
                languageCode,
                isHighlight: true,
              ),
              _buildSummaryItem(
                'totalLoanLabel',
                _currencyFormat(languageCode).format(loan.totalAmount),
                languageCode,
                isHighlight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(
    String label,
    String value,
    String languageCode, {
    bool isHighlight = false,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          _translateKey(languageCode, label),
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: isHighlight ? 12 : 11,
            fontWeight: isHighlight ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: isHighlight ? PdfColors.blue900 : PdfColors.black,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSignatures(
    Lender lender,
    Customer customer,
    String languageCode,
  ) {
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
              pw.Text(
                _translateKey(languageCode, 'lenderSignature'),
                style: const pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                lender.name,
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Text(
                '${_translateKey(languageCode, 'dateLabel')}: ${_formatDate(DateTime.now(), languageCode)}',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey600,
                ),
              ),
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
              pw.Text(
                _translateKey(languageCode, 'borrowerSignature'),
                style: const pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                customer.name,
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Text(
                '${_translateKey(languageCode, 'dateLabel')}: ${_formatDate(DateTime.now(), languageCode)}',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildFooter(String languageCode) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300, width: 1),
        ),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            _translateKey(languageCode, 'footerText'),
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            _translateKey(languageCode, 'confidentialLabel'),
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  static String _titleCase(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}
