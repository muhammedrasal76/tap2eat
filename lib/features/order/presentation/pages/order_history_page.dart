import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_spinner.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/order_history_card.dart';

/// Order history page showing all user orders
class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  void _loadOrders() {
    final userId = context.read<AuthProvider>().firebaseUser?.uid;
    if (userId != null) {
      context.read<OrderProvider>().fetchOrderHistory(userId);
    }
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
                  if (order.isLoadingHistory) {
                    return const LoadingSpinner(message: 'Loading orders...');
                  }

                  if (order.historyError != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            order.historyError!,
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.error),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _loadOrders,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (order.orders.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.receipt_long,
                      title: 'No orders yet',
                      subtitle:
                          'Your order history will appear here once you place an order',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _loadOrders(),
                    color: AppColors.primary,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: order.orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final o = order.orders[index];
                        return OrderHistoryCard(
                          order: o,
                          onTap: () => context.push('/order/${o.id}'),
                        );
                      },
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
          Text('Order History', style: AppTextStyles.h3),
        ],
      ),
    );
  }
}
