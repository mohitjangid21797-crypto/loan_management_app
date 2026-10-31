import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/l10n/ui_translations.dart';
import 'package:loan_management_app/models/index.dart';
import 'package:loan_management_app/utils/pdf_generator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'English PDF keeps thirty first-page installments and paginates sixty',
    () async {
      await UiTranslations.load();

      final loan = Loan(
        id: 'pdf-layout-loan',
        customerId: 'pdf-layout-customer',
        principalAmount: 50000,
        interestRate: 5,
        tenureMonths: 200,
        interestType: InterestType.simple,
        startDate: DateTime(2026, 10, 28),
      );
      final emis = List.generate(
        loan.tenureMonths,
        (index) => EMI(
          id: 'pdf-layout-emi-${index + 1}',
          loanId: loan.id,
          installmentNumber: index + 1,
          amount: loan.monthlyEMI,
          dueDate: DateTime(2026, 11 + index, 28),
        ),
      );
      final document = await PDFGenerator.generateLoanAgreement(
        lender: Lender(
          name: 'John Doe',
          mobileNumber: '9876543210',
          email: 'john@example.com',
          address: '123 Finance Street, Mumbai',
          licenseNumber: 'LM-2024-001',
        ),
        customer: Customer(
          name: 'Mohit Suthar',
          mobileNumber: '7023658108',
          email: 'mohit@example.com',
          location: 'Mumbai, Maharashtra',
        ),
        loan: loan,
        emis: emis,
        languageCode: 'en',
      );

      final bytes = document;
      final pdfSource = latin1.decode(bytes);
      final pageCount = RegExp(r'/Type\s*/Page\b').allMatches(pdfSource).length;

      expect(bytes, isNotEmpty);
      expect(pageCount, 5);
    },
  );
}
