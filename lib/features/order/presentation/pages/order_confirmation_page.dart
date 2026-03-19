import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../shared/widgets/app_button.dart';

/// Order confirmation page shown after successful order placement
class OrderConfirmationPage extends StatelessWidget {
  final String? orderId;

  const OrderConfirmationPage({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Green checkmark
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 24),

                Text('Order Placed!', style: AppTextStyles.h2),

                const SizedBox(height: 8),

                Text(
                  'Your order has been placed successfully',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),

                if (orderId != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Text(
                      'Order ID: ${orderId!.substring(0, orderId!.length > 8 ? 8 : orderId!.length).toUpperCase()}',
                      style: AppTextStyles.caption.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 40),

                // View Order button
                if (orderId != null)
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: 'View Order',
                      onPressed: () {
                        context.go(RouteNames.studentHome);
                        context.push('/order/$orderId');
                      },
                    ),
                  ),

                const SizedBox(height: 12),

                // Back to Home
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: 'Back to Home',
                    backgroundColor: AppColors.surface,
                    textColor: AppColors.textPrimary,
                    onPressed: () {
                      context.go(RouteNames.studentHome);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
