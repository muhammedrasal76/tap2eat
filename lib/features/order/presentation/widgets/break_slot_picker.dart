import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../home/domain/entities/break_slot_entity.dart';

/// Selectable break slot chips for delivery time selection
class BreakSlotPicker extends StatelessWidget {
  final List<BreakSlotEntity> slots;
  final BreakSlotEntity? selected;
  final ValueChanged<BreakSlotEntity> onSelected;
  final bool showNowSlot;
  final bool isNowSelected;
  final VoidCallback? onNowSelected;

  const BreakSlotPicker({
    super.key,
    required this.slots,
    this.selected,
    required this.onSelected,
    this.showNowSlot = false,
    this.isNowSelected = false,
    this.onNowSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty && !showNowSlot) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline,
                size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'No delivery slots available right now',
                style: AppTextStyles.bodySmall,
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        // "Deliver Now" chip (first item)
        if (showNowSlot)
          GestureDetector(
            onTap: onNowSelected,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: isNowSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isNowSelected
                      ? AppColors.primary
                      : AppColors.borderColor,
                  width: isNowSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bolt,
                    size: 16,
                    color: isNowSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                  const SizedBox(width: 4),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deliver Now',
                        style: AppTextStyles.caption.copyWith(
                          color: isNowSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '~10 min',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isNowSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

        // Regular break slot chips
        ...slots.map((slot) {
          final isSelected = selected == slot && !isNowSelected;
          final startHour = slot.startTime.hour;
          final startMin = slot.startTime.minute.toString().padLeft(2, '0');
          final endHour = slot.endTime.hour;
          final endMin = slot.endTime.minute.toString().padLeft(2, '0');
          final timeRange = '$startHour:$startMin - $endHour:$endMin';

          return GestureDetector(
            onTap: () => onSelected(slot),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.borderColor,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    slot.label,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeRange,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
