/// Password validation utility
class PasswordValidator {
  static const int minLength = 6;

  /// Validate password
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    return null;
  }

  /// Check if password is strong
  static bool isStrong(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasMinLength = password.length >= 8;

    return hasUppercase && hasLowercase && hasDigit && hasMinLength;
  }
}
