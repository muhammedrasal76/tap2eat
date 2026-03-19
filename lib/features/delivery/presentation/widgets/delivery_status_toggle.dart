import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/delivery_provider.dart';

class DeliveryStatusToggle extends StatelessWidget {
  const DeliveryStatusToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, provider, _) {
        final Color statusColor;
        final String statusText;

        if (provider.hasActiveDelivery) {
          statusColor = AppColors.warning;
          statusText = 'Busy';
        } else if (provider.isOnline) {
          statusColor = AppColors.success;
          statusText = 'Online';
        } else {
          statusColor = AppColors.error;
          statusText = 'Offline';
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              statusText,
              style: AppTextStyles.bodySmall.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            if (provider.isTogglingStatus)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Switch(
                value: provider.isOnline,
                onChanged: provider.hasActiveDelivery
                    ? null
                    : (_) {
                        final userId =
                            context.read<AuthProvider>().firebaseUser?.uid ?? '';
                        provider.toggleOnlineStatus(userId);
                      },
                activeColor: AppColors.success,
                inactiveThumbColor: AppColors.error,
                inactiveTrackColor: AppColors.error.withValues(alpha: 0.3),
              ),
          ],
        );
      },
    );
  }
}
