/// Base exception class for the app
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => message;
}

/// Authentication exceptions
class AuthException extends AppException {
  AuthException(super.message, {super.code});
}

/// Validation exceptions
class ValidationException extends AppException {
  ValidationException(super.message, {super.code});
}

/// Network exceptions
class NetworkException extends AppException {
  NetworkException(super.message, {super.code});
}

/// Firebase exceptions
class FirebaseException extends AppException {
  FirebaseException(super.message, {super.code});
}

/// Order-related exceptions
class OrderException extends AppException {
  OrderException(super.message, {super.code});
}

/// Server exceptions
class ServerException extends AppException {
  ServerException(super.message, {super.code});
}

/// Cache exceptions
class CacheException extends AppException {
  CacheException(super.message, {super.code});
}
