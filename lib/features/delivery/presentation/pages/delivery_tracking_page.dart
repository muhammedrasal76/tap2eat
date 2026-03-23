import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/domain/entities/recent_order_entity.dart';
import '../../../order/presentation/widgets/order_status_badge.dart';
import '../../domain/entities/customer_info_entity.dart';
import '../providers/delivery_provider.dart';
import '../widgets/delivery_completion_popup.dart';

class DeliveryTrackingPage extends StatefulWidget {
  final String orderId;
  final RecentOrderEntity? historyOrder;

  const DeliveryTrackingPage({
    super.key,
    required this.orderId,
    this.historyOrder,
  });

  @override
  State<DeliveryTrackingPage> createState() => _DeliveryTrackingPageState();
}

class _DeliveryTrackingPageState extends State<DeliveryTrackingPage> {
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    if (widget.historyOrder == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<DeliveryProvider>().watchActiveOrder(widget.orderId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If a history order was passed directly, render without consuming provider stream
    if (widget.historyOrder != null) {
      return _buildScaffold(context, widget.historyOrder!, isHistory: true);
    }

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

          return _buildBody(context, provider, order, isHistory: false);
        },
      ),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    RecentOrderEntity order, {
    required bool isHistory,
  }) {
    return Scaffold(
      backgroundColor: AppColors.base,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        title: Text('Delivery Tracking', style: AppTextStyles.h4),
      ),
      body: _buildBody(context, null, order, isHistory: isHistory),
    );
  }

  Widget _buildBody(
    BuildContext context,
    DeliveryProvider? provider,
    RecentOrderEntity order, {
    required bool isHistory,
  }) {
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

        // Customer details (active delivery only)
        if (!isHistory && provider?.customerInfo != null) ...[
          _buildCustomerCard(provider!.customerInfo!),
          const SizedBox(height: 16),
        ],

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
              Text(
                'Order Items',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                  Text(
                    'Total',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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

        // Action button (no actions for history view)
        if (!isHistory && provider != null)
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
  }

  Widget _buildCustomerCard(CustomerInfoEntity customer) {
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
          Text(
            'Customer Details',
            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Name', customer.name),
          _buildDetailRow('Phone', customer.phoneNumber),
          _buildDetailRow('Class / Room', customer.classroomNumber),
          _buildDetailRow('Block', customer.blockName),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '—',
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
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
          Text(
            'Delivery Progress',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
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
          onPressed: () => _updateStatus(provider, order, 'delivering'),
        );
      case OrderStatus.delivering:
        return AppButton(
          text: 'Mark as Delivered',
          isLoading: _isUpdating,
          width: double.infinity,
          onPressed: () => _updateStatus(provider, order, 'delivered'),
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
    RecentOrderEntity order,
    String status,
  ) async {
    setState(() => _isUpdating = true);

    // Capture order snapshot before the provider clears it
    final capturedOrder = order;

    final success = await provider.updateDeliveryStatus(order.id, status);

    if (!mounted) return;

    setState(() => _isUpdating = false);

    if (success && status == 'delivered') {
      _showCompletionPopup(capturedOrder);
    }
  }

  void _showCompletionPopup(RecentOrderEntity order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DeliveryCompletionPopup(
        deliveryFee: order.deliveryFee,
        orderId: order.id,
        onDone: () {
          final userId =
              context.read<AuthProvider>().firebaseUser?.uid ?? '';
          if (userId.isNotEmpty) {
            context.read<DeliveryProvider>().fetchDeliveryHistory(userId);
          }
          Navigator.of(context).pop(); // close dialog
          Navigator.of(context).pop(); // pop tracking page
        },
      ),
    );
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
