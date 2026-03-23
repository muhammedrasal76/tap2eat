import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../shared/widgets/loading_spinner.dart';
import '../providers/order_provider.dart';
import '../widgets/order_status_badge.dart';
import '../widgets/order_summary_card.dart';

/// Order detail page showing full order information
class OrderDetailPage extends StatefulWidget {
  final String orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrderDetail(widget.orderId);
    });
  }

  @override
  void dispose() {
    context.read<OrderProvider>().cancelOrderDetailSubscription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Consumer<OrderProvider>(
                builder: (context, order, _) {
                  if (order.isLoadingDetail) {
                    return const LoadingSpinner(
                        message: 'Loading order details...');
                  }

                  if (order.detailError != null) {
                    return Center(
                      child: Text(
                        order.detailError!,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.error),
                      ),
                    );
                  }

                  final detail = order.orderDetail;
                  if (detail == null) {
                    return Center(
                      child: Text('Order not found',
                          style: AppTextStyles.bodyMedium),
                    );
                  }

                  final dateStr = DateFormat('MMM d, yyyy - h:mm a')
                      .format(detail.createdAt);
                  final slotStr = DateFormat('h:mm a')
                      .format(detail.fulfillmentSlot);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status + Order ID
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OrderStatusBadge(status: detail.status),
                            Text(
                              '#${detail.id.substring(0, detail.id.length > 8 ? 8 : detail.id.length).toUpperCase()}',
                              style: AppTextStyles.caption.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),
                        Text(dateStr, style: AppTextStyles.caption),

                        const SizedBox(height: 20),

                        // Canteen name
                        _buildInfoSection(
                          'Canteen',
                          detail.canteenName,
                          Icons.storefront,
                        ),

                        const SizedBox(height: 12),

                        // Fulfillment info
                        _buildInfoSection(
                          detail.fulfillmentType == FulfillmentType.delivery
                              ? 'Delivery at'
                              : 'Pickup at',
                          slotStr,
                          detail.fulfillmentType == FulfillmentType.delivery
                              ? Icons.delivery_dining
                              : Icons.storefront,
                        ),

                        const SizedBox(height: 20),

                        // Items
                        Text('Items',
                            style: AppTextStyles.label
                                .copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: AppColors.borderColor),
                          ),
                          child: Column(
                            children: detail.items.map((item) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${item.name} x${item.quantity}',
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ),
                                    Text(
                                      'Rs ${(item.price * item.quantity).toStringAsFixed(0)}',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Summary
                        Text('Summary',
                            style: AppTextStyles.label
                                .copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        OrderSummaryCard(
                          subtotal: detail.totalAmount - detail.deliveryFee,
                          deliveryFee: detail.deliveryFee,
                          total: detail.totalAmount,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.base,
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
            color: AppColors.textPrimary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Text('Order Details', style: AppTextStyles.h3),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.label),
            ],
          ),
        ],
      ),
    );
  }
}
