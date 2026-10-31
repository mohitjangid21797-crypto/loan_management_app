import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart' as material;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../l10n/ui_translations.dart';
import '../models/index.dart';

class IndicPdfGenerator {
  IndicPdfGenerator._();

  static const _fontAssets = {
    'as': ('Noto Sans Bengali', 'assets/fonts/NotoSansBengali-Regular.ttf'),
    'bn': ('Noto Sans Bengali', 'assets/fonts/NotoSansBengali-Regular.ttf'),
    'gu': ('Noto Sans Gujarati', 'assets/fonts/NotoSansGujarati-Regular.ttf'),
    'hi': (
      'Noto Sans Devanagari',
      'assets/fonts/NotoSansDevanagari-Regular.ttf',
    ),
    'kn': ('Noto Sans Kannada', 'assets/fonts/NotoSansKannada-Regular.ttf'),
    'ml': ('Noto Sans Malayalam', 'assets/fonts/NotoSansMalayalam-Regular.ttf'),
    'mr': (
      'Noto Sans Devanagari',
      'assets/fonts/NotoSansDevanagari-Regular.ttf',
    ),
    'ne': (
      'Noto Sans Devanagari',
      'assets/fonts/NotoSansDevanagari-Regular.ttf',
    ),
    'or': ('Noto Sans Oriya', 'assets/fonts/NotoSansOriya-Regular.ttf'),
    'pa': ('Noto Sans Gurmukhi', 'assets/fonts/NotoSansGurmukhi-Regular.ttf'),
    'ta': ('Noto Sans Tamil', 'assets/fonts/NotoSansTamil-Regular.ttf'),
    'te': ('Noto Sans Telugu', 'assets/fonts/NotoSansTelugu-Regular.ttf'),
    'ur': ('Noto Sans Arabic', 'assets/fonts/NotoSansArabic-Regular.ttf'),
  };

  static const _hindiMonths = [
    'जनवरी',
    'फ़रवरी',
    'मार्च',
    'अप्रैल',
    'मई',
    'जून',
    'जुलाई',
    'अगस्त',
    'सितंबर',
    'अक्टूबर',
    'नवंबर',
    'दिसंबर',
  ];

  @visibleForTesting
  static Future<Uint8List> Function(String html, PdfPageFormat format)?
  htmlConverterForTesting;

  static bool supportsLanguage(String languageCode) =>
      _fontAssets.containsKey(languageCode);

  static String monthNameFor(String languageCode, int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'Must be between 1 and 12');
    }
    if (languageCode == 'hi') return _hindiMonths[month - 1];
    return DateFormat('MMMM', languageCode).format(DateTime(2000, month, 1));
  }

  static String formatDate(DateTime date, String languageCode) {
    final day = DateFormat('dd', languageCode).format(date);
    final year = DateFormat('yyyy', languageCode).format(date);
    return '$day ${monthNameFor(languageCode, date.month)} $year';
  }

  static String formatDateTime(DateTime date, String languageCode) =>
      '${formatDate(date, languageCode)}, '
      '${DateFormat('hh:mm a', languageCode).format(date)}';

  static Future<Uint8List> generateLoanAgreement({
    required Lender lender,
    required Customer customer,
    required Loan loan,
    required List<EMI> emis,
    required String languageCode,
  }) async {
    await initializeDateFormatting(languageCode);
    final sortedEmis = List<EMI>.of(emis)
      ..sort((a, b) => a.installmentNumber.compareTo(b.installmentNumber));
    final html = await buildHtml(
      lender: lender,
      customer: customer,
      loan: loan,
      emis: sortedEmis,
      languageCode: languageCode,
    );

    try {
      final bytes = await _convertHtml(html);
      if (bytes.isEmpty) {
        throw StateError('HTML PDF conversion returned an empty document');
      }
      return bytes;
    } on Object catch (conversionError) {
      try {
        return await _generateRasterFallback(
          lender: lender,
          customer: customer,
          loan: loan,
          emis: sortedEmis,
          languageCode: languageCode,
        );
      } on Object catch (fallbackError, fallbackStackTrace) {
        Error.throwWithStackTrace(
          StateError(
            'HTML PDF conversion failed ($conversionError), and the '
            'Flutter-rendered fallback failed ($fallbackError).',
          ),
          fallbackStackTrace,
        );
      }
    }
  }

  @visibleForTesting
  static Future<String> buildHtml({
    required Lender lender,
    required Customer customer,
    required Loan loan,
    required List<EMI> emis,
    required String languageCode,
  }) async {
    await initializeDateFormatting(languageCode);
    final font = _fontAssets[languageCode];
    if (font == null) {
      throw ArgumentError.value(
        languageCode,
        'languageCode',
        'No complex-script PDF font is configured',
      );
    }
    final fontData = await rootBundle.load(font.$2);
    final fontBase64 = base64Encode(
      fontData.buffer.asUint8List(
        fontData.offsetInBytes,
        fontData.lengthInBytes,
      ),
    );
    final isRtl = languageCode == 'ur';
    final direction = isRtl ? 'rtl' : 'ltr';
    final t = (String key) =>
        _escapeHtml(UiTranslations.translateKey(languageCode, key));
    final currency = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '${UiTranslations.translateKey(languageCode, 'currencySymbol')} ',
      decimalDigits: 2,
    );
    final date = (DateTime value) =>
        _escapeHtml(formatDate(value, languageCode));
    final now = _escapeHtml(formatDateTime(DateTime.now(), languageCode));
    final status = switch (loan.status.toLowerCase()) {
      'active' => t('activeFilter'),
      'completed' => t('completedFilter'),
      _ => _escapeHtml(_titleCase(loan.status)),
    };
    final interestType = loan.interestType == InterestType.simple
        ? t('simpleInterestLabel')
        : t('compoundInterestLabel');

    String detailRow(
      String label1,
      String value1,
      String label2,
      String value2,
    ) =>
        '<tr><th>${t(label1)}</th><td>${_escapeHtml(value1)}</td>'
        '<th>${t(label2)}</th><td>${_escapeHtml(value2)}</td></tr>';

    final html = StringBuffer()
      ..write(
        '<!doctype html><html lang="${_escapeHtml(languageCode)}" '
        'dir="$direction"><head><meta charset="utf-8"><meta '
        'name="viewport" content="width=device-width, initial-scale=1">',
      )
      ..write('<style>')
      ..write(
        '@font-face{font-family:"${font.$1}";src:url(data:font/ttf;base64,'
        '$fontBase64) format("truetype");font-weight:400;}',
      )
      ..write('''
@page{size:A4;margin:16mm 14mm;}
*{box-sizing:border-box;}
body{font-family:"${font.$1}","Noto Sans",sans-serif;font-size:10pt;color:#172033;line-height:1.35;direction:$direction;}
h1,h2,h3,p{margin:0;}
.header{background:#1e3a8a;color:#fff;padding:16px 18px;border-radius:8px;display:flex;justify-content:space-between;align-items:flex-start;gap:16px;}
.header-title{font-size:17pt;font-weight:bold;}
.subtitle{margin-top:5px;font-size:10pt;color:#e5e7eb;}
.meta{text-align:end;font-size:8pt;line-height:1.7;color:#f3f4f6;}
.title{text-align:center;color:#1e3a8a;font-size:18pt;margin:12px 0;}
.section-title{font-size:12pt;color:#1e3a8a;margin:12px 0 7px;font-weight:bold;}
.cards{display:flex;gap:12px;margin-bottom:10px;}
.card{width:50%;border:1px solid #d1d5db;border-radius:7px;background:#f9fafb;padding:9px;overflow-wrap:anywhere;}
.card h3{font-size:10pt;color:#1e3a8a;margin-bottom:5px;}
.card p{font-size:8.5pt;margin:2px 0;}
table{width:100%;border-collapse:collapse;table-layout:fixed;margin:0 0 10px;}
th,td{border:1px solid #cbd5e1;padding:5px 6px;text-align:start;overflow-wrap:anywhere;}
.details th{background:#eff6ff;font-size:8pt;width:17%;}.details td{font-size:8.5pt;width:33%;}
.schedule th{background:#1e3a8a;color:white;font-size:8pt;}
.schedule td{font-size:8pt;text-align:center;}
.schedule thead{display:table-header-group;}
.schedule tr{break-inside:avoid;page-break-inside:avoid;}
.money{direction:ltr;unicode-bidi:plaintext;text-align:start;}
.summary{break-before:page;page-break-before:always;}
.summary-grid{display:flex;justify-content:space-between;gap:10px;margin:12px 0;}
.summary-item{width:33%;font-size:9pt;color:#4b5563;}
.summary-item strong{display:block;color:#1e3a8a;font-size:11pt;margin-top:3px;}
.signatures{display:flex;gap:28px;margin:34px 0 20px;}
.signature{width:50%;text-align:center;padding-top:58px;border-bottom:1px solid #9ca3af;}
.signature-label{font-weight:bold;margin-top:7px;}
.signature-date{color:#6b7280;font-size:8pt;margin-top:3px;}
.footer{border-top:1px solid #d1d5db;padding-top:10px;text-align:center;color:#6b7280;font-size:8pt;margin-top:16px;}
''')
      ..write('</style></head><body>')
      ..write(
        '<header class="header"><div><div class="header-title">'
        '${t('appTitle')}</div><div class="subtitle">'
        '${t('pdfAgreementSubtitle')}</div></div><div class="meta">'
        '${t('generatedLabel')}: $now<br>${t('docIdLabel')}: '
        '${_escapeHtml(lender.licenseNumber)}</div></header>',
      )
      ..write('<h1 class="title">${t('loanAgreementTitle')}</h1>')
      ..write('<h2 class="section-title">${t('partiesTitle')}</h2>')
      ..write('<section class="cards">')
      ..write(
        '<article class="card"><h3>${t('lenderLabel')}</h3>'
        '<p>${t('lenderName')}: ${_escapeHtml(lender.name)}</p>'
        '<p>${t('mobileLabelShort')}: ${_escapeHtml(lender.mobileNumber)}</p>'
        '<p>${t('emailLabelShort')}: ${_escapeHtml(lender.email)}</p>'
        '<p>${t('addressLabel')}: ${_escapeHtml(lender.address)}</p>'
        '<p>${t('licenseLabel')}: ${_escapeHtml(lender.licenseNumber)}</p>'
        '</article>',
      )
      ..write(
        '<article class="card"><h3>${t('borrowerLabel')}</h3>'
        '<p>${t('borrowerName')}: ${_escapeHtml(customer.name)}</p>'
        '<p>${t('mobileLabelShort')}: ${_escapeHtml(customer.mobileNumber)}</p>'
        '<p>${t('emailLabelShort')}: ${_escapeHtml(customer.email)}</p>'
        '<p>${t('locationLabelShort')}: ${_escapeHtml(customer.location)}</p>'
        '</article></section>',
      )
      ..write('<h2 class="section-title">${t('loanDetailsTitle')}</h2>')
      ..write('<table class="details"><tbody>')
      ..write(
        detailRow(
          'principalAmountLabel',
          currency.format(loan.principalAmount),
          'interestRateLabelFull',
          '${loan.interestRate}% ${UiTranslations.translateKey(languageCode, 'annualRateSuffix')}',
        ),
      )
      ..write(
        detailRow(
          'tenureLabelFull',
          '${loan.tenureMonths} ${UiTranslations.translateKey(languageCode, 'monthsCount')}',
          'interestTypeLabel',
          interestType,
        ),
      )
      ..write(
        detailRow(
          'startDateLabel',
          formatDate(loan.startDate, languageCode),
          'monthlyEmiLabel',
          currency.format(loan.monthlyEMI),
        ),
      )
      ..write(
        detailRow(
          'totalInterestLabel',
          currency.format(loan.totalInterest),
          'totalPayableLabel',
          currency.format(loan.totalAmount),
        ),
      )
      ..write(
        detailRow('loanStatusLabel', status, 'loanIdLabel', _loanId(loan.id)),
      )
      ..write('</tbody></table>')
      ..write('<h2 class="section-title">${t('emiScheduleTitle')}</h2>')
      ..write(
        '<table class="schedule"><thead><tr>'
        '<th>${t('installmentHeader')}</th><th>${t('dueDateHeader')}</th>'
        '<th>${t('emiAmountHeader')}</th><th>${t('statusHeader')}</th>'
        '<th>${t('paidDateHeader')}</th></tr></thead><tbody>',
      );

    for (final emi in emis) {
      final paymentStatus = switch (emi.status) {
        EMIStatus.paid => 'emiPaid',
        EMIStatus.pending => 'emiPending',
        EMIStatus.overdue => 'emiOverdue',
      };
      html.write(
        '<tr><td>${emi.installmentNumber}</td>'
        '<td>${date(emi.dueDate)}</td>'
        '<td class="money">${_escapeHtml(currency.format(emi.amount))}</td>'
        '<td>${t(paymentStatus)}</td>'
        '<td>${emi.paidDate == null ? '-' : date(emi.paidDate!)}</td></tr>',
      );
    }

    final paidEmis = emis.where((emi) => emi.status == EMIStatus.paid).toList();
    final pendingEmis = emis
        .where((emi) => emi.status == EMIStatus.pending)
        .toList();
    final totalPaid = paidEmis.fold(0.0, (sum, emi) => sum + emi.amount);
    final totalPending = pendingEmis.fold(0.0, (sum, emi) => sum + emi.amount);
    html
      ..write('</tbody></table><section class="summary">')
      ..write('<h2 class="section-title">${t('paymentSummaryTitle')}</h2>')
      ..write('<div class="summary-grid">')
      ..write(_htmlSummaryItem(t('totalEmisLabel'), '${loan.tenureMonths}'))
      ..write(_htmlSummaryItem(t('paidEmisLabel'), '${paidEmis.length}'))
      ..write(_htmlSummaryItem(t('pendingEmisLabel'), '${pendingEmis.length}'))
      ..write('</div><div class="summary-grid">')
      ..write(_htmlSummaryItem(t('totalPaidLabel'), currency.format(totalPaid)))
      ..write(
        _htmlSummaryItem(t('totalPendingLabel'), currency.format(totalPending)),
      )
      ..write(
        _htmlSummaryItem(
          t('totalLoanLabel'),
          currency.format(loan.totalAmount),
        ),
      )
      ..write('</div><div class="signatures">')
      ..write(
        '<div class="signature"><div class="signature-label">'
        '${t('lenderSignature')}</div><div>${_escapeHtml(lender.name)}</div>'
        '<div class="signature-date">${t('dateLabel')}: '
        '${_escapeHtml(formatDate(DateTime.now(), languageCode))}</div></div>',
      )
      ..write(
        '<div class="signature"><div class="signature-label">'
        '${t('borrowerSignature')}</div><div>'
        '${_escapeHtml(customer.name)}</div><div class="signature-date">'
        '${t('dateLabel')}: ${_escapeHtml(formatDate(DateTime.now(), languageCode))}'
        '</div></div></div><footer class="footer">'
        '${t('footerText')}<br>${t('confidentialLabel')}</footer>'
        '</section></body></html>',
      );
    return html.toString();
  }

  static String _htmlSummaryItem(String label, String value) =>
      '<div class="summary-item">$label<strong>${_escapeHtml(value)}</strong></div>';

  static Future<Uint8List> _convertHtml(String html) {
    final testConverter = htmlConverterForTesting;
    if (testConverter != null) {
      return testConverter(html, PdfPageFormat.a4);
    }
    // The requested HTML renderer is deprecated upstream but is needed here
    // for Chromium shaping of Indic scripts.
    // ignore: deprecated_member_use
    return Printing.convertHtml(html: html, format: PdfPageFormat.a4);
  }

  static Future<Uint8List> _generateRasterFallback({
    required Lender lender,
    required Customer customer,
    required Loan loan,
    required List<EMI> emis,
    required String languageCode,
  }) async {
    const firstPageRows = 14;
    const followingPageRows = 30;
    final document = pw.Document();
    final firstRows = emis.take(firstPageRows).toList();
    final remainingRows = emis.skip(firstRows.length).toList();
    final rowPages = <List<EMI>>[firstRows];
    for (
      var index = 0;
      index < remainingRows.length;
      index += followingPageRows
    ) {
      rowPages.add(remainingRows.skip(index).take(followingPageRows).toList());
    }

    for (var index = 0; index < rowPages.length; index++) {
      final imageBytes = await _rasterizeWidget(
        _fallbackPage(
          lender: lender,
          customer: customer,
          loan: loan,
          emis: rowPages[index],
          languageCode: languageCode,
          includeIntro: index == 0,
          includeScheduleTitle: true,
        ),
      );
      document.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (_) => pw.Image(
            pw.MemoryImage(imageBytes),
            width: PdfPageFormat.a4.width,
            height: PdfPageFormat.a4.height,
          ),
        ),
      );
    }

    final summaryImage = await _rasterizeWidget(
      _fallbackSummaryPage(lender, customer, loan, emis, languageCode),
    );
    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (_) => pw.Image(
          pw.MemoryImage(summaryImage),
          width: PdfPageFormat.a4.width,
          height: PdfPageFormat.a4.height,
        ),
      ),
    );
    return document.save();
  }

  static Future<Uint8List> _rasterizeWidget(Widget child) async {
    const pageSize = Size(794, 1123);
    const pixelRatio = 3.0;
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final boundary = RenderRepaintBoundary();
    final renderView = RenderView(
      view: view,
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(pageSize),
        physicalConstraints: BoxConstraints.tight(
          Size(pageSize.width * pixelRatio, pageSize.height * pixelRatio),
        ),
        devicePixelRatio: pixelRatio,
      ),
      child: RenderPositionedBox(alignment: Alignment.topLeft, child: boundary),
    );
    final pipelineOwner = PipelineOwner()..rootNode = renderView;
    renderView.prepareInitialFrame();
    final buildOwner = BuildOwner(focusManager: FocusManager());
    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: boundary,
      child: Directionality(
        textDirection: material.TextDirection.ltr,
        child: child,
      ),
    ).attachToRenderTree(buildOwner);
    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();
    pipelineOwner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) throw StateError('Could not encode the PDF page image');
      return data.buffer.asUint8List();
    } finally {
      image.dispose();
      rootElement.update(
        RenderObjectToWidgetAdapter<RenderBox>(container: boundary),
      );
      buildOwner.buildScope(rootElement);
      buildOwner.finalizeTree();
      pipelineOwner.rootNode = null;
      buildOwner.focusManager.dispose();
    }
  }

  static Widget _fallbackPage({
    required Lender lender,
    required Customer customer,
    required Loan loan,
    required List<EMI> emis,
    required String languageCode,
    required bool includeIntro,
    required bool includeScheduleTitle,
  }) {
    final isRtl = languageCode == 'ur';
    final currency = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '${UiTranslations.translateKey(languageCode, 'currencySymbol')} ',
      decimalDigits: 2,
    );
    final t = (String key) => UiTranslations.translateKey(languageCode, key);
    final white = material.Colors.white;
    final navy = const material.Color(0xFF1E3A8A);

    Widget text(String value, {double size = 10, bool bold = false}) =>
        material.Text(
          value,
          style: material.TextStyle(
            fontSize: size,
            fontWeight: bold
                ? material.FontWeight.bold
                : material.FontWeight.normal,
          ),
        );

    Widget section(String title) => Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: text(title, size: 15, bold: true),
    );

    Widget scheduleTable() {
      final rows = <TableRow>[
        TableRow(
          decoration: BoxDecoration(color: navy),
          children: [
            for (final key in [
              'installmentHeader',
              'dueDateHeader',
              'emiAmountHeader',
              'statusHeader',
              'paidDateHeader',
            ])
              Padding(
                padding: const EdgeInsets.all(5),
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: material.Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(t(key)),
                ),
              ),
          ],
        ),
        ...emis.map(
          (emi) => TableRow(
            children: [
              _fallbackCell('${emi.installmentNumber}'),
              _fallbackCell(formatDate(emi.dueDate, languageCode)),
              _fallbackCell(currency.format(emi.amount)),
              _fallbackCell(
                t(switch (emi.status) {
                  EMIStatus.paid => 'emiPaid',
                  EMIStatus.pending => 'emiPending',
                  EMIStatus.overdue => 'emiOverdue',
                }),
              ),
              _fallbackCell(
                emi.paidDate == null
                    ? '-'
                    : formatDate(emi.paidDate!, languageCode),
              ),
            ],
          ),
        ),
      ];
      return Table(
        border: TableBorder.all(color: const Color(0xFFCBD5E1)),
        columnWidths: const {
          0: FlexColumnWidth(0.8),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(1.6),
          3: FlexColumnWidth(1.3),
          4: FlexColumnWidth(1.5),
        },
        children: rows,
      );
    }

    return Directionality(
      textDirection: isRtl
          ? material.TextDirection.rtl
          : material.TextDirection.ltr,
      child: Container(
        width: 794,
        height: 1123,
        color: white,
        padding: const EdgeInsets.all(45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (includeIntro) ...[
              Container(
                color: navy,
                padding: const EdgeInsets.all(16),
                child: DefaultTextStyle(
                  style: const TextStyle(color: material.Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(t('appTitle'), size: 19, bold: true),
                            text(t('pdfAgreementSubtitle'), size: 11),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          text(
                            '${t('generatedLabel')}: ${formatDateTime(DateTime.now(), languageCode)}',
                            size: 8,
                          ),
                          text(
                            '${t('docIdLabel')}: ${lender.licenseNumber}',
                            size: 8,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: text(t('loanAgreementTitle'), size: 21, bold: true),
                ),
              ),
              section(t('partiesTitle')),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _fallbackCard(t('lenderLabel'), [
                      '${t('lenderName')}: ${lender.name}',
                      '${t('mobileLabelShort')}: ${lender.mobileNumber}',
                      '${t('emailLabelShort')}: ${lender.email}',
                      '${t('addressLabel')}: ${lender.address}',
                      '${t('licenseLabel')}: ${lender.licenseNumber}',
                    ]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _fallbackCard(t('borrowerLabel'), [
                      '${t('borrowerName')}: ${customer.name}',
                      '${t('mobileLabelShort')}: ${customer.mobileNumber}',
                      '${t('emailLabelShort')}: ${customer.email}',
                      '${t('locationLabelShort')}: ${customer.location}',
                    ]),
                  ),
                ],
              ),
              section(t('loanDetailsTitle')),
              _fallbackLoanDetails(loan, languageCode, currency),
            ],
            if (includeScheduleTitle) section(t('emiScheduleTitle')),
            if (!includeIntro && !includeScheduleTitle)
              section(t('emiScheduleTitle')),
            scheduleTable(),
          ],
        ),
      ),
    );
  }

  static Widget _fallbackSummaryPage(
    Lender lender,
    Customer customer,
    Loan loan,
    List<EMI> emis,
    String languageCode,
  ) {
    final t = (String key) => UiTranslations.translateKey(languageCode, key);
    final currency = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '${t('currencySymbol')} ',
      decimalDigits: 2,
    );
    final paid = emis.where((emi) => emi.status == EMIStatus.paid).toList();
    final pending = emis
        .where((emi) => emi.status == EMIStatus.pending)
        .toList();
    final totalPaid = paid.fold(0.0, (sum, emi) => sum + emi.amount);
    final totalPending = pending.fold(0.0, (sum, emi) => sum + emi.amount);

    Widget summary(String label, String value) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF6B7280))),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );

    return Directionality(
      textDirection: languageCode == 'ur'
          ? material.TextDirection.rtl
          : material.TextDirection.ltr,
      child: Container(
        width: 794,
        height: 1123,
        color: material.Colors.white,
        padding: const EdgeInsets.all(55),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              t('paymentSummaryTitle'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                summary(t('totalEmisLabel'), '${loan.tenureMonths}'),
                summary(t('paidEmisLabel'), '${paid.length}'),
                summary(t('pendingEmisLabel'), '${pending.length}'),
              ],
            ),
            const material.Divider(height: 30),
            Row(
              children: [
                summary(t('totalPaidLabel'), currency.format(totalPaid)),
                summary(t('totalPendingLabel'), currency.format(totalPending)),
                summary(t('totalLoanLabel'), currency.format(loan.totalAmount)),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: _fallbackSignature(
                    t('lenderSignature'),
                    lender.name,
                    languageCode,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: _fallbackSignature(
                    t('borrowerSignature'),
                    customer.name,
                    languageCode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            Text(t('footerText'), textAlign: TextAlign.center),
            const SizedBox(height: 5),
            Text(t('confidentialLabel'), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  static Widget _fallbackCell(String value) => Padding(
    padding: const EdgeInsets.all(5),
    child: Text(value, style: const TextStyle(fontSize: 8)),
  );

  static Widget _fallbackCard(String title, List<String> details) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFCBD5E1)),
      borderRadius: BorderRadius.circular(7),
      color: const Color(0xFFF9FAFB),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        ...details.map(
          (detail) => Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(detail, style: const TextStyle(fontSize: 9)),
          ),
        ),
      ],
    ),
  );

  static Widget _fallbackLoanDetails(
    Loan loan,
    String languageCode,
    NumberFormat currency,
  ) {
    final t = (String key) => UiTranslations.translateKey(languageCode, key);
    final status = switch (loan.status.toLowerCase()) {
      'active' => t('activeFilter'),
      'completed' => t('completedFilter'),
      _ => _titleCase(loan.status),
    };
    final interestType = loan.interestType == InterestType.simple
        ? t('simpleInterestLabel')
        : t('compoundInterestLabel');
    final pairs = [
      (t('principalAmountLabel'), currency.format(loan.principalAmount)),
      (
        t('interestRateLabelFull'),
        '${loan.interestRate}% ${t('annualRateSuffix')}',
      ),
      (t('tenureLabelFull'), '${loan.tenureMonths} ${t('monthsCount')}'),
      (t('interestTypeLabel'), interestType),
      (t('startDateLabel'), formatDate(loan.startDate, languageCode)),
      (t('monthlyEmiLabel'), currency.format(loan.monthlyEMI)),
      (t('totalInterestLabel'), currency.format(loan.totalInterest)),
      (t('totalPayableLabel'), currency.format(loan.totalAmount)),
      (t('loanStatusLabel'), status),
      (t('loanIdLabel'), _loanId(loan.id)),
    ];
    return Table(
      border: TableBorder.all(color: const Color(0xFFCBD5E1)),
      children: [
        for (var index = 0; index < pairs.length; index += 2)
          TableRow(
            children: [
              _fallbackDetailCell(pairs[index].$1, pairs[index].$2),
              _fallbackDetailCell(pairs[index + 1].$1, pairs[index + 1].$2),
            ],
          ),
      ],
    );
  }

  static Widget _fallbackDetailCell(String label, String value) => Padding(
    padding: const EdgeInsets.all(5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
        ),
        Text(value, style: const TextStyle(fontSize: 9)),
      ],
    ),
  );

  static Widget _fallbackSignature(
    String title,
    String name,
    String languageCode,
  ) => Column(
    children: [
      const SizedBox(height: 65),
      Container(height: 1, color: const Color(0xFF9CA3AF)),
      const SizedBox(height: 8),
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(name),
      Text(
        '${UiTranslations.translateKey(languageCode, 'dateLabel')}: '
        '${formatDate(DateTime.now(), languageCode)}',
      ),
    ],
  );

  static String _escapeHtml(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');

  static String _loanId(String id) =>
      (id.length > 8 ? id.substring(0, 8) : id).toUpperCase();

  static String _titleCase(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
}
