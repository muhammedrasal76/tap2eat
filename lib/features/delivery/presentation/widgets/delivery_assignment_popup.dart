import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/delivery_provider.dart';

class DeliveryAssignmentPopup extends StatefulWidget {
  const DeliveryAssignmentPopup({super.key});

  @override
  State<DeliveryAssignmentPopup> createState() =>
      _DeliveryAssignmentPopupState();
}

class _DeliveryAssignmentPopupState extends State<DeliveryAssignmentPopup> {
  Timer? _countdownTimer;
  int _remainingSeconds = 60;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    final assignment = context.read<DeliveryProvider>().pendingAssignment;
    if (assignment != null) {
      final remaining =
          assignment.expiresAt.difference(DateTime.now()).inSeconds;
      _remainingSeconds = remaining > 0 ? remaining : 60;
    }

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _remainingSeconds--;
      });
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _autoReject();
      }
    });
  }

  void _autoReject() {
    final provider = context.read<DeliveryProvider>();
    final userId = context.read<AuthProvider>().firebaseUser?.uid ?? '';
    provider.rejectAssignment(userId).then((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Consumer<DeliveryProvider>(
        builder: (context, provider, _) {
          final assignment = provider.pendingAssignment;
          if (assignment == null) {
            return const SizedBox.shrink();
          }

          final progress = _remainingSeconds / 60;

          return Dialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'New Delivery Request',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 16),

                  // Countdown progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: AppColors.borderColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _remainingSeconds <= 10
                            ? AppColors.error
                            : AppColors.primary,
                      ),
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_remainingSeconds}s remaining',
                    style: AppTextStyles.caption.copyWith(
                      color: _remainingSeconds <= 10
                          ? AppColors.error
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Assignment details
                  _DetailRow(
                    label: 'Canteen',
                    value: assignment.canteenName,
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    label: 'Items',
                    value: '${assignment.itemCount}',
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    label: 'Order Total',
                    value: 'Rs. ${assignment.totalAmount.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(
                    label: 'Delivery Fee',
                    value: 'Rs. ${assignment.deliveryFee.toStringAsFixed(2)}',
                    valueColor: AppColors.success,
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: AppOutlineButton(
                          text: 'Reject',
                          isLoading: provider.isRejecting,
                          onPressed: provider.isAccepting
                              ? null
                              : () async {
                                  final userId = context
                                          .read<AuthProvider>()
                                          .firebaseUser
                                          ?.uid ??
                                      '';
                                  await provider.rejectAssignment(userId);
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          text: 'Accept',
                          isLoading: provider.isAccepting,
                          onPressed: provider.isRejecting
                              ? null
                              : () async {
                                  final userId = context
                                          .read<AuthProvider>()
                                          .firebaseUser
                                          ?.uid ??
                                      '';
                                  final accepted =
                                      await provider.acceptAssignment(userId);
                                  if (context.mounted) {
                                    Navigator.of(context).pop(accepted);
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
