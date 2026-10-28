// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:loan_management_app/main.dart';
import 'package:loan_management_app/providers/app_provider.dart';

void main() {
  testWidgets('App loads and shows login screen', (WidgetTester tester) async {
    final appProvider = AppProvider();
    await appProvider.initialize();
    
    await tester.pumpWidget(
      LoanManagementApp(appProvider: appProvider),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign in to access your loan dashboard'), findsOneWidget);
  });
}