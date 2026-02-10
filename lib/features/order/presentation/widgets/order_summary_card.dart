import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';

/// Order summary card showing subtotal, delivery fee, and total
class OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          _buildRow('Subtotal', 'Rs ${subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _buildRow(
            'Delivery Fee',
            deliveryFee > 0
                ? 'Rs ${deliveryFee.toStringAsFixed(0)}'
                : 'Free',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: AppColors.borderColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.h4,
              ),
              Text(
                'Rs ${total.toStringAsFixed(0)}',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        )),
        Text(value, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}
