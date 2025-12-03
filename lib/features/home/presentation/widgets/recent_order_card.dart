import 'package:flutter/material.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../domain/entities/recent_order_entity.dart';

/// Card widget for displaying a recent order
class RecentOrderCard extends StatelessWidget {
  final RecentOrderEntity order;
  final VoidCallback onTap;

  const RecentOrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 128,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                color: AppColors.borderColor,
                image: firstItem?.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(firstItem!.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: firstItem?.imageUrl == null
                  ? const Center(
                      child: Icon(
                        Icons.restaurant,
                        color: AppColors.textSecondary,
                        size: 32,
                      ),
                    )
                  : null,
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.canteenName,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    firstItem?.name ?? 'Order',
                    style: AppTextStyles.caption.copyWith(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _StatusBadge(status: order.status.displayName),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
