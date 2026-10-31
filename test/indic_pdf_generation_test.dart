import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/l10n/ui_translations.dart';
import 'package:loan_management_app/models/index.dart';
import 'package:loan_management_app/providers/app_locale_provider.dart';
import 'package:loan_management_app/utils/indic_pdf_generator.dart';
import 'package:loan_management_app/utils/pdf_generator.dart';
import 'package:pdf/pdf.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Lender lender;
  late Customer customer;
  late Loan loan;
  late List<EMI> emis;

  setUpAll(() async {
    await UiTranslations.load();
  });

  setUp(() {
    lender = Lender(
      name: 'Lender <script>alert("name")</script>',
      mobileNumber: '9876543210',
      email: 'lender@example.com',
      address: 'A & B Street',
      licenseNumber: 'LIC-123456',
    );
    customer = Customer(
      name: 'Borrower',
      mobileNumber: '0123456789',
      email: 'borrower@example.com',
      location: 'Mumbai',
    );
    loan = Loan(
      id: 'pdf-test-loan',
      customerId: 'pdf-test-customer',
      principalAmount: 123456,
      interestRate: 5,
      tenureMonths: 240,
      interestType: InterestType.simple,
      startDate: DateTime(2026, 2, 1),
    );
    emis = List.generate(
      240,
      (index) => EMI(
        id: 'pdf-test-emi-$index',
        loanId: loan.id,
        installmentNumber: index + 1,
        amount: loan.monthlyEMI,
        dueDate: DateTime(2026, 3 + index, 1),
      ),
    );
    IndicPdfGenerator.htmlCapabilityForTesting = () async => true;
    IndicPdfGenerator.htmlConverterForTesting = (html, format) async {
      expect(format, PdfPageFormat.a4);
      expect(html, contains('page-break-inside:avoid'));
      expect(html, contains('display:table-header-group'));
      expect(html, contains('240'));
      expect(html, contains('&lt;script&gt;'));
      expect(html, contains('A &amp; B Street'));
      expect(html, isNot(contains('<script>alert')));
      return Uint8List.fromList('%PDF-test'.codeUnits);
    };
  });

  tearDown(() {
    IndicPdfGenerator.htmlConverterForTesting = null;
    IndicPdfGenerator.htmlCapabilityForTesting = null;
  });

  test('returns a non-empty PDF for every supported language', () async {
    for (final languageCode in AppLocaleProvider.supportedLanguageCodes) {
      final bytes = await PDFGenerator.generateLoanAgreement(
        lender: lender,
        customer: customer,
        loan: loan,
        emis: emis,
        languageCode: languageCode,
      );
      expect(bytes, isNotEmpty, reason: languageCode);
    }
  });

  test('uses the exact full Hindi month names', () {
    const months = [
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

    for (var month = 1; month <= months.length; month++) {
      expect(PDFGenerator.monthNameFor('hi', month), months[month - 1]);
    }
  });

  test('preserves Indian rupee formatting in the Hindi PDF', () async {
    final html = await IndicPdfGenerator.buildHtml(
      lender: lender,
      customer: customer,
      loan: loan,
      emis: emis.take(1).toList(),
      languageCode: 'hi',
    );

    expect(html, contains('₹ 1,23,456.00'));
  });

  test('escapes user data and applies Urdu text direction in HTML', () async {
    final html = await IndicPdfGenerator.buildHtml(
      lender: lender,
      customer: customer,
      loan: loan,
      emis: emis.take(1).toList(),
      languageCode: 'ur',
    );

    expect(html, contains('lang="ur" dir="rtl"'));
    expect(html, contains('&lt;script&gt;'));
    expect(html, contains('A &amp; B Street'));
    expect(html, isNot(contains('<script>alert')));
  });

  test(
    'falls back to Flutter raster pages when HTML conversion fails',
    () async {
      IndicPdfGenerator.htmlConverterForTesting = (_, _) async {
        throw StateError('HTML conversion is unavailable');
      };

      final bytes = await PDFGenerator.generateLoanAgreement(
        lender: lender,
        customer: customer,
        loan: loan,
        emis: emis.take(1).toList(),
        languageCode: 'hi',
      );

      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    },
  );

  test('skips HTML conversion when the platform does not support it', () async {
    IndicPdfGenerator.htmlCapabilityForTesting = () async => false;
    IndicPdfGenerator.htmlConverterForTesting = (_, _) async {
      fail('HTML conversion must not run when platform support is false');
    };

    final bytes = await PDFGenerator.generateLoanAgreement(
      lender: lender,
      customer: customer,
      loan: loan,
      emis: emis.take(1).toList(),
      languageCode: 'hi',
    );

    expect(bytes, isNotEmpty);
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}
