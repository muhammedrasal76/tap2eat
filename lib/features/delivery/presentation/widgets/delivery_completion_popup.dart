import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../shared/widgets/app_button.dart';

class DeliveryCompletionPopup extends StatelessWidget {
  final double deliveryFee;
  final String orderId;
  final VoidCallback onDone;

  const DeliveryCompletionPopup({
    super.key,
    required this.deliveryFee,
    required this.orderId,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 44,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Delivery Complete!',
                style: AppTextStyles.h3.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              Text(
                'Order #${orderId.length >= 8 ? orderId.substring(0, 8) : orderId}',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery earned',
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      'Rs. ${deliveryFee.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Back to Dashboard',
                width: double.infinity,
                onPressed: onDone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
