import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/app.dart';
import 'package:loan_management_app/core/constants/app_constants.dart';
import 'package:loan_management_app/core/router/app_router.dart';
import 'package:loan_management_app/presentation/providers/auth_provider.dart';

void main() {
  testWidgets('launches to splash, then the main shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LoanManagerApp()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await tester.pump(
      AppConstants.splashDuration + const Duration(milliseconds: 100),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Dashboard'), findsWidgets);
  });

  test('redirectFor sends each auth state to the right place', () {
    expect(redirectFor(AuthStatus.unknown, '/dashboard'), '/splash');
    expect(redirectFor(AuthStatus.unknown, '/splash'), isNull);
    expect(redirectFor(AuthStatus.needsSetup, '/splash'), '/set-mpin');
    expect(redirectFor(AuthStatus.locked, '/dashboard'), '/login');
    expect(redirectFor(AuthStatus.unlocked, '/splash'), '/dashboard');
    expect(redirectFor(AuthStatus.unlocked, '/customers'), isNull);
  });
}
