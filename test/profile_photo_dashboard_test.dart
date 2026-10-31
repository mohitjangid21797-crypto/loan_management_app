import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_management_app/main.dart';
import 'package:loan_management_app/models/lender.dart';
import 'package:loan_management_app/providers/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_database_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('dashboard displays the lender photo above their name', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    GoogleFonts.config.allowRuntimeFetching = false;
    final provider = AppProvider(database: await createTestAppDatabase());
    await provider.updateLender(
      Lender(
        name: 'Photo Test Lender',
        mobileNumber: '9876543210',
        email: 'lender@example.com',
        address: 'Office',
        licenseNumber: 'LIC-1',
        profileImagePath: '/profile_photos/lender.jpg',
      ),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(
          home: DashboardScreen(onViewAllLoans: _doNothing),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    final photo = find.byWidgetPredicate(
      (widget) => widget is Image && widget.image is FileImage,
    );
    final lenderName = find.text('Photo Test Lender');
    expect(photo, findsOneWidget);
    expect(lenderName, findsOneWidget);
    expect(
      tester.getTopLeft(photo).dy,
      lessThan(tester.getTopLeft(lenderName).dy),
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}

void _doNothing() {}
