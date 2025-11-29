/// Route names used in the app navigation
class RouteNames {
  RouteNames._();

  // Auth routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  // Home routes
  static const String studentHome = '/student-home';
  static const String teacherHome = '/teacher-home';
  static const String deliveryStudentHome = '/delivery-student-home';

  // Menu routes
  static const String menu = '/menu';
  static const String canteenDetail = '/canteen/:canteenId';

  // Order routes
  static const String checkout = '/checkout';
  static const String orderHistory = '/order-history';
  static const String orderDetail = '/order/:orderId';
  static const String orderTracking = '/order/:orderId/tracking';

  // Delivery routes (delivery students only)
  static const String deliveryDashboard = '/delivery-dashboard';
  static const String deliveryRequests = '/delivery-requests';
  static const String deliveryHistory = '/delivery-history';

  // Earnings routes (delivery students only)
  static const String earnings = '/earnings';

  // Settings
  static const String settings = '/settings';
  static const String profile = '/profile';
}
