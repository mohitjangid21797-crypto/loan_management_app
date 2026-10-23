/// Route names and paths.
abstract final class RouteNames {
  static const String splash = 'splash';
  static const String setMpin = 'set-mpin';
  static const String login = 'login';
  static const String dashboard = 'dashboard';
  static const String customers = 'customers';
  static const String loans = 'loans';
  static const String settings = 'settings';

  static const String splashPath = '/splash';
  static const String setMpinPath = '/set-mpin';
  static const String loginPath = '/login';
  static const String dashboardPath = '/dashboard';
  static const String customersPath = '/customers';
  static const String loansPath = '/loans';
  static const String settingsPath = '/settings';

  static const String customerAdd = 'customer-add';
  static const String customerDetail = 'customer-detail';
  static const String customerEdit = 'customer-edit';

  static const String customerAddPath = '/customers/add';

  static String customerDetailPath(String id) => '/customers/$id';
  static String customerEditPath(String id) => '/customers/$id/edit';

  static const String loanAdd = 'loan-add';
  static const String loanDetail = 'loan-detail';
  static const String loanSchedule = 'loan-schedule';

  static const String loanAddPath = '/loans/add';

  /// The new-loan form with [customerId] already chosen.
  static String loanAddPathFor(String customerId) =>
      '/loans/add?customerId=$customerId';

  static String loanDetailPath(String id) => '/loans/$id';
  static String loanSchedulePath(String id) => '/loans/$id/schedule';

  static const String profile = 'profile';
  static const String changeMpin = 'change-mpin';

  static const String profilePath = '/settings/profile';
  static const String changeMpinPath = '/settings/change-mpin';

  /// Bottom-navigation tab paths, in display order.
  static const List<String> tabPaths = [
    dashboardPath,
    customersPath,
    loansPath,
    settingsPath,
  ];
}
