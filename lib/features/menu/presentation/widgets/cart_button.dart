import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';

/// Cart button with item count badge
class CartButton extends StatelessWidget {
  final int itemCount;
  final VoidCallback onPressed;

  const CartButton({
    super.key,
    required this.itemCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cart icon button
        IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.shopping_cart),
          color: AppColors.textPrimary,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),

        // Badge showing item count
        if (itemCount > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  itemCount > 99 ? '99+' : itemCount.toString(),
                  style: const TextStyle(
                    color: AppColors.base,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
