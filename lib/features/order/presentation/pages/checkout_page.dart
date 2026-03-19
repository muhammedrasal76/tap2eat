import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../../menu/presentation/providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/break_slot_picker.dart';
import '../widgets/checkout_cart_item.dart';
import '../widgets/fulfillment_type_selector.dart';
import '../widgets/order_summary_card.dart';

/// Checkout page for reviewing cart and placing an order
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Consumer2<CartProvider, OrderProvider>(
                builder: (context, cart, order, _) {
                  if (cart.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart_outlined,
                              size: 64, color: AppColors.textSecondary),
                          const SizedBox(height: 16),
                          Text('Your cart is empty',
                              style: AppTextStyles.h4
                                  .copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Canteen name
                        if (cart.currentCanteen != null) ...[
                          Text(
                            cart.currentCanteen!.name,
                            style: AppTextStyles.h4,
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Cart items
                        Text('Items', style: AppTextStyles.label.copyWith(
                          color: AppColors.textSecondary,
                        )),
                        const SizedBox(height: 8),
                        ...cart.cartItems.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: CheckoutCartItem(
                                cartItem: item,
                                onIncrement: () =>
                                    cart.addItem(item.menuItem),
                                onDecrement: () =>
                                    cart.removeItem(item.menuItem.id),
                                onDelete: () =>
                                    cart.deleteItem(item.menuItem.id),
                              ),
                            )),

                        const SizedBox(height: 20),

                        // Fulfillment type (teachers only — students always pickup)
                        if (context.read<AuthProvider>().userRole == UserRole.teacher) ...[
                          Text('Fulfillment', style: AppTextStyles.label.copyWith(
                            color: AppColors.textSecondary,
                          )),
                          const SizedBox(height: 8),
                          FulfillmentTypeSelector(
                            selected: order.fulfillmentType,
                            onChanged: (type) =>
                                order.setFulfillmentType(type),
                          ),
                        ],

                        // Break slot picker (delivery only)
                        if (order.fulfillmentType ==
                            FulfillmentType.delivery) ...[
                          const SizedBox(height: 16),
                          Text('Delivery Time',
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.textSecondary,
                              )),
                          const SizedBox(height: 8),
                          Consumer<HomeProvider>(
                            builder: (context, home, _) {
                              final slots = order
                                  .getAvailableBreakSlots(home.settings);
                              return BreakSlotPicker(
                                slots: slots,
                                selected: order.selectedBreakSlot,
                                onSelected: (slot) =>
                                    order.selectBreakSlot(slot),
                                showNowSlot: order.isDeliveryNowAvailable,
                                isNowSelected: order.isNowSlotSelected,
                                onNowSelected: () => order.selectNowSlot(),
                              );
                            },
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Order summary
                        Text('Order Summary',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.textSecondary,
                            )),
                        const SizedBox(height: 8),
                        OrderSummaryCard(
                          subtotal: cart.subtotal,
                          deliveryFee: order.deliveryFee,
                          total: cart.subtotal + order.deliveryFee,
                        ),

                        // Error message
                        if (order.checkoutError != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            order.checkoutError!,
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.error),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Place order button
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            text: 'Place Order',
                            isLoading: order.isPlacingOrder,
                            onPressed: () => _placeOrder(context),
                          ),
                        ),

                        const SizedBox(height: 16),
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
          Text('Checkout', style: AppTextStyles.h3),
        ],
      ),
    );
  }

  void _placeOrder(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final order = context.read<OrderProvider>();
    final auth = context.read<AuthProvider>();
    final settings = context.read<HomeProvider>().settings;

    // Validate
    final error = order.validateOrder(cart, settings);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
      return;
    }

    final userId = auth.firebaseUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to place an order'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final success = await order.placeOrder(cart, userId);
    if (success && context.mounted) {
      context.go(
        RouteNames.orderConfirmation,
        extra: order.lastCreatedOrderId,
      );
    }
  }
}
