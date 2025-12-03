import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';

/// Floating "Go Online" button for delivery students (Time Lock Policy enforced)
class GoOnlineButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoOnlineButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      elevation: 8,
      icon: Transform.rotate(
        angle: 0.785398, // 45 degrees in radians
        child: const Icon(
          Icons.add_circle_outline,
          color: AppColors.onPrimary,
          size: 20,
        ),
      ),
      label: Text(
        'Go Online',
        style: AppTextStyles.button.copyWith(fontSize: 14),
      ),
    );
  }
}
