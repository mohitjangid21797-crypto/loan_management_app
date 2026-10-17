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

  /// Bottom-navigation tab paths, in display order.
  static const List<String> tabPaths = [
    dashboardPath,
    customersPath,
    loansPath,
    settingsPath,
  ];
}
