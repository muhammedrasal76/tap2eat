/// Helper class for break time validation logic (Time Lock Policy)
/// Used by delivery students to determine when they can go online
class TimeLockHelper {
  TimeLockHelper._();

  /// Check if the current time is within any of the break time slots
  /// This implements FR 4.2.1: Time Lock Enforcement
  static bool isWithinBreakTime(
    DateTime currentTime,
    List<DateTime> breakSlots,
  ) {
    if (breakSlots.isEmpty) return false;

    for (final breakSlot in breakSlots) {
      // Assuming each break slot is 1 hour long (can be configured)
      final breakStart = breakSlot;
      final breakEnd = breakSlot.add(const Duration(hours: 1));

      if (currentTime.isAfter(breakStart) && currentTime.isBefore(breakEnd)) {
        return true;
      }
    }

    return false;
  }

  /// Get the next available break time
  static DateTime? getNextBreakTime(
    DateTime currentTime,
    List<DateTime> breakSlots,
  ) {
    if (breakSlots.isEmpty) return null;

    // Sort break slots by time
    final sortedSlots = List<DateTime>.from(breakSlots)
      ..sort((a, b) => a.compareTo(b));

    // Find the next break slot after current time
    for (final slot in sortedSlots) {
      if (slot.isAfter(currentTime)) {
        return slot;
      }
    }

    // If no future slots found, return null (or could return first slot of next day)
    return null;
  }

  /// Check if a time slot is valid for delivery orders (must be a break time)
  /// This implements FR 4.1.3: Policy Check (Delivery)
  static bool isValidDeliverySlot(
    DateTime fulfillmentSlot,
    List<DateTime> breakSlots,
  ) {
    for (final breakSlot in breakSlots) {
      // Check if the fulfillment slot matches any break slot (within same hour)
      if (fulfillmentSlot.year == breakSlot.year &&
          fulfillmentSlot.month == breakSlot.month &&
          fulfillmentSlot.day == breakSlot.day &&
          fulfillmentSlot.hour == breakSlot.hour) {
        return true;
      }
    }

    return false;
  }

  /// Check if an order can be placed for the given time slot
  /// Implements FR 4.1.4: Cutoff Time Rule (5 minutes in advance)
  static bool canPlaceOrderForSlot(
    DateTime fulfillmentSlot,
    DateTime currentTime, {
    int cutoffMinutes = 5,
  }) {
    final timeDifference = fulfillmentSlot.difference(currentTime);
    return timeDifference.inMinutes >= cutoffMinutes;
  }

  /// Format time remaining until next break
  static String formatTimeUntilNextBreak(DateTime nextBreakTime) {
    final now = DateTime.now();
    final difference = nextBreakTime.difference(now);

    if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes.remainder(60)}m';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }
}
