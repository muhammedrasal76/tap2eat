/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'Tap2Eat';
  static const String appVersion = '1.0.0';

  // Timing constants (from PRD)
  static const int orderCutoffMinutes = 5; // Orders cannot be placed for slots starting within 5 minutes
  static const int deliveryAssignmentTimeoutMinutes = 5; // Delivery assignment timeout

  // Pagination
  static const int defaultPageSize = 20;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxClassIdLength = 20;

  // API timeouts
  static const int apiTimeoutSeconds = 30;

  // Cache durations
  static const int cacheDurationMinutes = 5;

  // Delivery constants
  static const double defaultDeliveryFee = 10.0;
}
