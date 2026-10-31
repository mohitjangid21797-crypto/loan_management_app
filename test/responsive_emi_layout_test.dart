import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/l10n/ui_translations.dart';
import 'package:loan_management_app/models/index.dart';
import 'package:loan_management_app/providers/app_provider.dart';
import 'package:loan_management_app/screens/emi_payment_screen.dart';
import 'package:loan_management_app/screens/loans_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_database_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('loan and EMI screens fit a narrow Assamese layout', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await UiTranslations.load();

    final appProvider = AppProvider(database: await createTestAppDatabase());
    await appProvider.initialize();
    final loan = Loan(
      id: 'narrow-layout-loan',
      customerId: 'test-customer',
      principalAmount: 5000000,
      interestRate: 5,
      tenureMonths: 2,
      interestType: InterestType.simple,
    );
    await appProvider.addLoan(loan);

    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appProvider,
        child: MaterialApp(
          locale: const Locale('as'),
          supportedLocales: const [Locale('as')],
          home: const LoansListScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appProvider,
        child: MaterialApp(
          locale: const Locale('as'),
          supportedLocales: const [Locale('as')],
          home: EMIPaymentScreen(loan: loan),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(tester.takeException(), isNull);
    expect(find.text('EMI #1'), findsOneWidget);
  });
}
