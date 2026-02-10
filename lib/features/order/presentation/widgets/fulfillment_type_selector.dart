import 'package:flutter/material.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';

/// Toggle selector for Pickup / Delivery fulfillment type
class FulfillmentTypeSelector extends StatelessWidget {
  final FulfillmentType selected;
  final ValueChanged<FulfillmentType> onChanged;

  const FulfillmentTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildOption(
            label: 'Pickup',
            icon: Icons.storefront,
            type: FulfillmentType.pickup,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOption(
            label: 'Delivery',
            icon: Icons.delivery_dining,
            type: FulfillmentType.delivery,
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required String label,
    required IconData icon,
    required FulfillmentType type,
  }) {
    final isSelected = selected == type;
    return GestureDetector(
      onTap: () => onChanged(type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
