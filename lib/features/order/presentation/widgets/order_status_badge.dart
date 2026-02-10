import 'package:flutter/material.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';

/// Colored badge for order status
class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = _getStatusColors();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.displayName,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, Color) _getStatusColors() {
    switch (status) {
      case OrderStatus.pending:
        return (AppColors.warning, AppColors.warning.withOpacity(0.15));
      case OrderStatus.preparing:
      case OrderStatus.assigned:
      case OrderStatus.delivering:
        return (AppColors.info, AppColors.info.withOpacity(0.15));
      case OrderStatus.ready:
      case OrderStatus.completed:
      case OrderStatus.delivered:
        return (AppColors.success, AppColors.success.withOpacity(0.15));
      case OrderStatus.cancelled:
        return (AppColors.error, AppColors.error.withOpacity(0.15));
    }
  }
}
