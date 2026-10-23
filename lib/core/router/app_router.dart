import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_management_app/core/router/route_names.dart';
import 'package:loan_management_app/presentation/providers/auth_provider.dart';
import 'package:loan_management_app/presentation/screens/auth/login_mpin_screen.dart';
import 'package:loan_management_app/presentation/screens/auth/set_mpin_screen.dart';
import 'package:loan_management_app/presentation/screens/customers/customer_detail_screen.dart';
import 'package:loan_management_app/presentation/screens/customers/customer_form_screen.dart';
import 'package:loan_management_app/presentation/screens/customers/customer_list_screen.dart';
import 'package:loan_management_app/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:loan_management_app/presentation/screens/emi/emi_schedule_screen.dart';
import 'package:loan_management_app/presentation/screens/loans/loan_detail_screen.dart';
import 'package:loan_management_app/presentation/screens/loans/loan_form_screen.dart';
import 'package:loan_management_app/presentation/screens/loans/loan_list_screen.dart';
import 'package:loan_management_app/presentation/screens/settings/change_mpin_screen.dart';
import 'package:loan_management_app/presentation/screens/settings/lender_profile_screen.dart';
import 'package:loan_management_app/presentation/screens/settings/settings_screen.dart';
import 'package:loan_management_app/presentation/screens/shell/main_shell.dart';
import 'package:loan_management_app/presentation/screens/splash/splash_screen.dart';

/// Lets go_router re-run its redirect when the auth state changes.
class _AuthRefresh extends ChangeNotifier {
  void notify() => notifyListeners();
}

/// Decides where the user must be for a given auth state.
/// Returns null when [location] is already correct.
String? redirectFor(AuthStatus status, String location) {
  const authPaths = {
    RouteNames.splashPath,
    RouteNames.setMpinPath,
    RouteNames.loginPath,
  };
  switch (status) {
    case AuthStatus.unknown:
      return location == RouteNames.splashPath ? null : RouteNames.splashPath;
    case AuthStatus.needsSetup:
      return location == RouteNames.setMpinPath
          ? null
          : RouteNames.setMpinPath;
    case AuthStatus.locked:
      return location == RouteNames.loginPath ? null : RouteNames.loginPath;
    case AuthStatus.unlocked:
      return authPaths.contains(location) ? RouteNames.dashboardPath : null;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefresh();
  ref.listen<AsyncValue<AuthStatus>>(authProvider, (_, _) => refresh.notify());

  final router = GoRouter(
    initialLocation: RouteNames.splashPath,
    refreshListenable: refresh,
    redirect: (context, state) {
      final status = authStatusOf(ref.read(authProvider));
      return redirectFor(status, state.matchedLocation);
    },
    routes: [
      GoRoute(
        path: RouteNames.splashPath,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.setMpinPath,
        name: RouteNames.setMpin,
        builder: (context, state) => const SetMpinScreen(),
      ),
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        builder: (context, state) => const LoginMpinScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.dashboardPath,
            name: RouteNames.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: RouteNames.customersPath,
            name: RouteNames.customers,
            builder: (context, state) => const CustomerListScreen(),
            routes: [
              // 'add' must come before ':id' so it is not read as an id.
              GoRoute(
                path: 'add',
                name: RouteNames.customerAdd,
                builder: (context, state) => const CustomerFormScreen(),
              ),
              GoRoute(
                path: ':id',
                name: RouteNames.customerDetail,
                builder: (context, state) => CustomerDetailScreen(
                  customerId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: RouteNames.customerEdit,
                    builder: (context, state) => CustomerFormScreen(
                      customerId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.loansPath,
            name: RouteNames.loans,
            builder: (context, state) => const LoanListScreen(),
            routes: [
              // 'add' must come before ':id' so it is not read as an id.
              GoRoute(
                path: 'add',
                name: RouteNames.loanAdd,
                builder: (context, state) => LoanFormScreen(
                  customerId: state.uri.queryParameters['customerId'],
                ),
              ),
              GoRoute(
                path: ':id',
                name: RouteNames.loanDetail,
                builder: (context, state) =>
                    LoanDetailScreen(loanId: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'schedule',
                    name: RouteNames.loanSchedule,
                    builder: (context, state) => EmiScheduleScreen(
                      loanId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.settingsPath,
            name: RouteNames.settings,
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'profile',
                name: RouteNames.profile,
                builder: (context, state) => const LenderProfileScreen(),
              ),
              GoRoute(
                path: 'change-mpin',
                name: RouteNames.changeMpin,
                builder: (context, state) => const ChangeMpinScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
