/// App route paths
class AppRoutes {
  AppRoutes._();

  // Auth routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main routes
  static const String dashboard = '/dashboard';
  static const String inventory = '/inventory';
  static const String orders = '/orders';
  static const String finance = '/finance';

  // Additional routes
  static const String people = '/people';
  static const String profile = '/profile';
  static const String analytics = '/analytics';

  // Order routes
  static const String orderDetail = '/orders/:id';
  static const String orderForm = '/orders/form';
}
