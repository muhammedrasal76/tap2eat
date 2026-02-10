import '../../features/home/domain/entities/break_slot_entity.dart';

/// Helper class for break time validation logic (Time Lock Policy)
/// Used by delivery students to determine when they can go online
class TimeLockHelper {
  TimeLockHelper._();

  /// Check if the current time is within any of the active break time slots
  /// This implements FR 4.2.1: Time Lock Enforcement
  static bool isWithinBreakTime(
    DateTime currentTime,
    List<BreakSlotEntity> breakSlots,
  ) {
    if (breakSlots.isEmpty) return false;

    final currentDayOfWeek = currentTime.weekday; // 1=Mon, 7=Sun

    for (final slot in breakSlots) {
      if (!slot.isActive) continue;
      if (slot.dayOfWeek != currentDayOfWeek) continue;

      // Apply slot's hour:minute to current date
      final breakStart = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        slot.startTime.hour,
        slot.startTime.minute,
      );
      final breakEnd = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        slot.endTime.hour,
        slot.endTime.minute,
      );

      if (!currentTime.isBefore(breakStart) && currentTime.isBefore(breakEnd)) {
        return true;
      }
    }

    return false;
  }

  /// Get the next available break time
  static DateTime? getNextBreakTime(
    DateTime currentTime,
    List<BreakSlotEntity> breakSlots,
  ) {
    if (breakSlots.isEmpty) return null;

    final currentDayOfWeek = currentTime.weekday;

    final upcomingStarts = <DateTime>[];

    for (final slot in breakSlots) {
      if (!slot.isActive) continue;

      // Calculate days ahead (0 = today, 1..6 = future days)
      int daysAhead = (slot.dayOfWeek - currentDayOfWeek) % 7;

      final candidateDate = currentTime.add(Duration(days: daysAhead));
      final breakStart = DateTime(
        candidateDate.year,
        candidateDate.month,
        candidateDate.day,
        slot.startTime.hour,
        slot.startTime.minute,
      );

      if (breakStart.isAfter(currentTime)) {
        upcomingStarts.add(breakStart);
      } else if (daysAhead == 0) {
        // Same day but already passed — push to next week
        final nextWeek = currentTime.add(const Duration(days: 7));
        upcomingStarts.add(DateTime(
          nextWeek.year,
          nextWeek.month,
          nextWeek.day,
          slot.startTime.hour,
          slot.startTime.minute,
        ));
      }
    }

    if (upcomingStarts.isEmpty) return null;
    upcomingStarts.sort((a, b) => a.compareTo(b));
    return upcomingStarts.first;
  }

  /// Check if a time slot is valid for delivery orders (must be a break time)
  /// This implements FR 4.1.3: Policy Check (Delivery)
  static bool isValidDeliverySlot(
    DateTime fulfillmentSlot,
    List<BreakSlotEntity> breakSlots,
  ) {
    return isWithinBreakTime(fulfillmentSlot, breakSlots);
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
