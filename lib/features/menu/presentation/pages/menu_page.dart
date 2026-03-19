import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../home/domain/entities/canteen_entity.dart';
import '../../../home/domain/entities/menu_item_entity.dart';
import '../../../order/presentation/providers/order_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/order_status_banner.dart';
import '../widgets/cart_button.dart';

/// Menu screen for browsing canteen menu and adding items to cart
class MenuPage extends StatefulWidget {
  final CanteenEntity canteen;

  const MenuPage({
    super.key,
    required this.canteen,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    // Initialize cart for this canteen and fetch active order count
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().setCurrentCanteen(widget.canteen);
      context.read<OrderProvider>().fetchActiveOrderCount(
            widget.canteen.id,
            maxOrders: widget.canteen.maxConcurrentOrders,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button, canteen name, and cart icon
            _buildHeader(context),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Order status banner
                    Consumer<OrderProvider>(
                      builder: (context, orderProvider, _) =>
                          OrderStatusBanner(
                        currentOrders: orderProvider.activeOrderCount,
                        maxOrders: widget.canteen.maxConcurrentOrders,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Menu items list
                    if (widget.canteen.menuItems.isEmpty)
                      _buildEmptyMenu()
                    else
                      _buildMenuItemsList(),
                  ],
                ),
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
      decoration: BoxDecoration(
        color: AppColors.base.withOpacity(0.8),
        border: const Border(
          bottom: BorderSide(color: AppColors.borderColor),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
            color: AppColors.textPrimary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),

          // Canteen name
          Expanded(
            child: Text(
              widget.canteen.name,
              style: AppTextStyles.h3,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Cart button with badge
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              return CartButton(
                itemCount: cartProvider.totalItems,
                onPressed: () {
                  if (cartProvider.totalItems > 0) {
                    context.push(RouteNames.checkout);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemsList() {
    // Group items by category
    final Map<String, List<MenuItemEntity>> groupedItems = {};
    for (final item in widget.canteen.menuItems) {
      if (!groupedItems.containsKey(item.category)) {
        groupedItems[item.category] = [];
      }
      groupedItems[item.category]!.add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedItems.entries.map((entry) {
        final category = entry.key;
        final items = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header
            if (groupedItems.length > 1) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  category,
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],

            // Menu items in this category
            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MenuItemCard(
                  item: item,
                  onAdd: () {
                    final orderProvider = context.read<OrderProvider>();
                    if (orderProvider.isAtCapacity) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Canteen is at full capacity. Try again later.'),
                          duration: Duration(seconds: 2),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }
                    context.read<CartProvider>().addItem(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.name} added to cart'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEmptyMenu() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No menu items available',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This canteen hasn\'t added any items yet',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}
