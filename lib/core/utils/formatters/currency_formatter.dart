import 'package:intl/intl.dart';

/// Currency formatting utilities
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '₹', // Rupee symbol
    decimalDigits: 2,
  );

  /// Format amount as currency (e.g., "₹150.00")
  static String format(double amount) {
    return _currencyFormat.format(amount);
  }

  /// Format amount without decimal (e.g., "₹150")
  static String formatCompact(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  /// Parse currency string to double
  static double? parse(String currencyString) {
    try {
      final cleaned = currencyString.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleaned);
    } catch (e) {
      return null;
    }
  }
}
