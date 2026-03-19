import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../home/domain/entities/recent_order_entity.dart';
import '../../../order/presentation/widgets/order_status_badge.dart';

class DeliveryOrderCard extends StatelessWidget {
  final RecentOrderEntity order;
  final VoidCallback? onTap;

  const DeliveryOrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.canteenName,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                OrderStatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${order.items.length} item${order.items.length != 1 ? 's' : ''}',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rs. ${order.totalAmount.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, hh:mm a').format(order.createdAt),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            if (order.deliveryFee > 0) ...[
              const SizedBox(height: 4),
              Text(
                'Delivery fee: Rs. ${order.deliveryFee.toStringAsFixed(2)}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
