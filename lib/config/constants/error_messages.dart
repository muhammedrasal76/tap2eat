/// Error and success messages used throughout the app
class ErrorMessages {
  ErrorMessages._();

  // Authentication errors
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPassword = 'Password must be at least 6 characters';
  static const String emailAlreadyInUse = 'This email is already registered';
  static const String userNotFound = 'No user found with this email';
  static const String wrongPassword = 'Incorrect password';
  static const String weakPassword = 'Password is too weak';

  // Validation errors
  static const String emptyField = 'This field cannot be empty';
  static const String invalidClassId = 'Please enter a valid class ID';
  static const String invalidDesignation = 'Please enter your designation';

  // Order errors
  static const String slotFull = 'This time slot is full. Please choose another slot.';
  static const String slotTooSoon = 'Orders must be placed at least 5 minutes in advance';
  static const String deliveryNotAllowed = 'Delivery is only available to teachers during break times';
  static const String emptyCart = 'Your cart is empty';

  // Network errors
  static const String noInternet = 'No internet connection';
  static const String serverError = 'Server error. Please try again later.';
  static const String requestTimeout = 'Request timeout. Please try again.';

  // General errors
  static const String somethingWentWrong = 'Something went wrong. Please try again.';
  static const String permissionDenied = 'Permission denied';

  // Delivery errors
  static const String notBreakTime = 'You can only go online during break times';
  static const String alreadyOnline = 'You are already online';
  static const String notOnline = 'You must be online to accept deliveries';
}

class SuccessMessages {
  SuccessMessages._();

  // Authentication
  static const String loginSuccess = 'Login successful';
  static const String registrationSuccess = 'Registration successful';
  static const String logoutSuccess = 'Logged out successfully';

  // Order
  static const String orderPlaced = 'Order placed successfully';
  static const String orderCancelled = 'Order cancelled';

  // Delivery
  static const String deliveryAccepted = 'Delivery request accepted';
  static const String deliveryCompleted = 'Delivery marked as completed';
  static const String onlineStatusUpdated = 'Online status updated';
}
