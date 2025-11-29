import 'package:intl/intl.dart';

/// DateTime formatting utilities
class DateTimeFormatter {
  DateTimeFormatter._();

  /// Format time slot (e.g., "2:00 PM - 3:00 PM")
  static String formatTimeSlot(DateTime startTime, {int durationHours = 1}) {
    final start = DateFormat('h:mm a').format(startTime);
    final end = DateFormat('h:mm a')
        .format(startTime.add(Duration(hours: durationHours)));
    return '$start - $end';
  }

  /// Format date (e.g., "Jan 15, 2025")
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  /// Format date and time (e.g., "Jan 15, 2025 at 2:30 PM")
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y \'at\' h:mm a').format(dateTime);
  }

  /// Format time only (e.g., "2:30 PM")
  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  /// Format relative time (e.g., "2 hours ago", "in 30 minutes")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays > 0) {
      return 'in ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
    } else if (difference.inDays < 0) {
      final daysPast = -difference.inDays;
      return '$daysPast ${daysPast == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return 'in ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
    } else if (difference.inHours < 0) {
      final hoursPast = -difference.inHours;
      return '$hoursPast ${hoursPast == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return 'in ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
    } else if (difference.inMinutes < 0) {
      final minutesPast = -difference.inMinutes;
      return '$minutesPast ${minutesPast == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
