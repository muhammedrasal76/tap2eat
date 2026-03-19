import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../home/domain/entities/recent_order_entity.dart';
import '../../../order/presentation/widgets/order_status_badge.dart';
import '../providers/delivery_provider.dart';

class DeliveryTrackingPage extends StatefulWidget {
  final String orderId;

  const DeliveryTrackingPage({super.key, required this.orderId});

  @override
  State<DeliveryTrackingPage> createState() => _DeliveryTrackingPageState();
}

class _DeliveryTrackingPageState extends State<DeliveryTrackingPage> {
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    context.read<DeliveryProvider>().watchActiveOrder(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        title: Text('Delivery Tracking', style: AppTextStyles.h4),
      ),
      body: Consumer<DeliveryProvider>(
        builder: (context, provider, _) {
          final order = provider.activeOrder;

          if (order == null) {
            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text(provider.error!,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.error)),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () =>
                          provider.watchActiveOrder(widget.orderId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Order info header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.canteenName,
                          style: AppTextStyles.h4,
                        ),
                        OrderStatusBadge(status: order.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Order #${order.id.substring(0, 8)}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Status timeline
              _buildStatusTimeline(order),
              const SizedBox(height: 16),

              // Order items
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Items', style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                    const SizedBox(height: 12),
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity}x ${item.name}',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                          Text(
                            'Rs. ${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    )),
                    const Divider(color: AppColors.borderColor),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                        Text(
                          'Rs. ${order.totalAmount.toStringAsFixed(2)}',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    if (order.deliveryFee > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery Fee', style: AppTextStyles.bodySmall),
                          Text(
                            'Rs. ${order.deliveryFee.toStringAsFixed(2)}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action button
              _buildActionButton(context, provider, order),

              // Cancelled state
              if (order.status == OrderStatus.cancelled)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cancel, color: AppColors.error),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'This order has been cancelled.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusTimeline(RecentOrderEntity order) {
    final steps = [
      _TimelineStep(
        label: 'Assigned',
        status: OrderStatus.assigned,
        isActive: _isStatusReached(order.status, OrderStatus.assigned),
        isCurrent: order.status == OrderStatus.assigned,
      ),
      _TimelineStep(
        label: 'Delivering',
        status: OrderStatus.delivering,
        isActive: _isStatusReached(order.status, OrderStatus.delivering),
        isCurrent: order.status == OrderStatus.delivering,
      ),
      _TimelineStep(
        label: 'Delivered',
        status: OrderStatus.delivered,
        isActive: _isStatusReached(order.status, OrderStatus.delivered),
        isCurrent: order.status == OrderStatus.delivered,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delivery Progress', style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          )),
          const SizedBox(height: 16),
          ...List.generate(steps.length, (index) {
            final step = steps[index];
            final isLast = index == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: step.isActive
                            ? AppColors.primary
                            : AppColors.borderColor,
                        border: step.isCurrent
                            ? Border.all(color: AppColors.primary, width: 3)
                            : null,
                      ),
                      child: step.isActive
                          ? const Icon(Icons.check,
                              size: 14, color: AppColors.onPrimary)
                          : null,
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 32,
                        color: step.isActive
                            ? AppColors.primary
                            : AppColors.borderColor,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    step.label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: step.isActive
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight:
                          step.isCurrent ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  bool _isStatusReached(OrderStatus current, OrderStatus target) {
    const order = [
      OrderStatus.assigned,
      OrderStatus.delivering,
      OrderStatus.delivered,
    ];
    final currentIndex = order.indexOf(current);
    final targetIndex = order.indexOf(target);
    if (currentIndex == -1 || targetIndex == -1) return false;
    return currentIndex >= targetIndex;
  }

  Widget _buildActionButton(
    BuildContext context,
    DeliveryProvider provider,
    RecentOrderEntity order,
  ) {
    switch (order.status) {
      case OrderStatus.assigned:
        return AppButton(
          text: 'Start Delivering',
          isLoading: _isUpdating,
          width: double.infinity,
          onPressed: () => _updateStatus(provider, order.id, 'delivering'),
        );
      case OrderStatus.delivering:
        return AppButton(
          text: 'Mark as Delivered',
          isLoading: _isUpdating,
          width: double.infinity,
          onPressed: () => _updateStatus(provider, order.id, 'delivered'),
        );
      case OrderStatus.delivered:
        return AppButton(
          text: 'Back to Home',
          width: double.infinity,
          onPressed: () => Navigator.of(context).pop(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _updateStatus(
    DeliveryProvider provider,
    String orderId,
    String status,
  ) async {
    setState(() => _isUpdating = true);
    await provider.updateDeliveryStatus(orderId, status);
    if (mounted) {
      setState(() => _isUpdating = false);
    }
  }
}

class _TimelineStep {
  final String label;
  final OrderStatus status;
  final bool isActive;
  final bool isCurrent;

  _TimelineStep({
    required this.label,
    required this.status,
    required this.isActive,
    required this.isCurrent,
  });
}
