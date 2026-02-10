import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';

/// Banner showing current order load and estimated wait time
class OrderStatusBanner extends StatelessWidget {
  final int currentOrders;
  final int maxOrders;
  final int estimatedWaitMinutes;

  const OrderStatusBanner({
    super.key,
    required this.currentOrders,
    required this.maxOrders,
    required this.estimatedWaitMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final percentFull = (currentOrders / maxOrders * 100).clamp(0, 100).toInt();
    final isNearCapacity = percentFull >= 80;
    final isFull = percentFull >= 95;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getBackgroundColor(isFull, isNearCapacity),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(isFull, isNearCapacity),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Icon(
            isFull
                ? Icons.warning_rounded
                : isNearCapacity
                    ? Icons.hourglass_top_rounded
                    : Icons.check_circle_rounded,
            color: _getIconColor(isFull, isNearCapacity),
            size: 24,
          ),
          const SizedBox(width: 12),

          // Status text
          Expanded(
            child: Text(
              _getStatusText(isFull, isNearCapacity),
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: _getTextColor(isFull, isNearCapacity),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(bool isFull, bool isNearCapacity) {
    if (isFull) {
      return 'At capacity: $currentOrders/$maxOrders orders. Wait time: ~${estimatedWaitMinutes + 5} mins.';
    } else if (isNearCapacity) {
      return 'Current orders: $currentOrders/$maxOrders. Wait time: ~$estimatedWaitMinutes mins.';
    } else {
      return 'Available: $currentOrders/$maxOrders orders. Wait time: ~$estimatedWaitMinutes mins.';
    }
  }

  Color _getBackgroundColor(bool isFull, bool isNearCapacity) {
    if (isFull) {
      return AppColors.error.withOpacity(0.1);
    } else if (isNearCapacity) {
      return AppColors.warning.withOpacity(0.1);
    } else {
      return AppColors.primary.withOpacity(0.1);
    }
  }

  Color _getBorderColor(bool isFull, bool isNearCapacity) {
    if (isFull) {
      return AppColors.error.withOpacity(0.2);
    } else if (isNearCapacity) {
      return AppColors.warning.withOpacity(0.2);
    } else {
      return AppColors.primary.withOpacity(0.2);
    }
  }

  Color _getIconColor(bool isFull, bool isNearCapacity) {
    if (isFull) {
      return AppColors.error;
    } else if (isNearCapacity) {
      return AppColors.warning;
    } else {
      return AppColors.primary;
    }
  }

  Color _getTextColor(bool isFull, bool isNearCapacity) {
    if (isFull) {
      return AppColors.error.withOpacity(0.9);
    } else if (isNearCapacity) {
      return AppColors.warning.withOpacity(0.9);
    } else {
      return AppColors.primary.withOpacity(0.9);
    }
  }
}
