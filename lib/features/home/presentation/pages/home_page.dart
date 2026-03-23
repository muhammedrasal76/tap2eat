import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_spinner.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../delivery/presentation/pages/delivery_home_page.dart';
import '../../../delivery/presentation/providers/delivery_provider.dart';
import '../../../order/presentation/providers/order_provider.dart';
import '../../../order/presentation/widgets/order_history_card.dart';
import '../providers/home_provider.dart';
import '../widgets/canteen_card.dart';
import '../widgets/go_online_button.dart';
import '../widgets/recent_order_card.dart';
import '../widgets/search_bar_widget.dart';

/// Home page with role-based UI and Time Lock Policy enforcement
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Schedule initialization after the first frame to avoid calling
    // notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final authProvider = context.read<AuthProvider>();
    final homeProvider = context.read<HomeProvider>();

    if (authProvider.firebaseUser != null) {
      await homeProvider.initialize(authProvider.firebaseUser!.uid);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            final isDelivery =
                authProvider.userRole == UserRole.deliveryStudent;
            return IndexedStack(
              index: _currentIndex,
              children: [
                // Tab 0: Home (swaps based on role)
                if (isDelivery)
                  const DeliveryHomePage()
                else
                  Consumer<HomeProvider>(
                    builder: (context, homeProvider, _) {
                      if (homeProvider.isLoading) {
                        return const LoadingSpinner();
                      }

                      if (homeProvider.errorMessage != null) {
                        return EmptyStateWidget(
                          icon: Icons.error_outline,
                          title: 'Something went wrong',
                          subtitle: homeProvider.errorMessage,
                          action: ElevatedButton(
                            onPressed: () => _initializeData(),
                            child: const Text('Retry'),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          if (authProvider.firebaseUser != null) {
                            await homeProvider
                                .refresh(authProvider.firebaseUser!.uid);
                          }
                        },
                        child: CustomScrollView(
                          slivers: [
                            _buildHeader(authProvider),
                            if (homeProvider.recentOrders.isNotEmpty)
                              _buildRecentOrdersSection(homeProvider),
                            _buildCanteensSection(homeProvider),
                            const SliverToBoxAdapter(
                                child: SizedBox(height: 100)),
                          ],
                        ),
                      );
                    },
                  ),
                // Tab 1: Orders
                _buildOrdersTab(),
                // Tab 2: Profile
                _buildProfileTab(),
              ],
            );
          },
        ),
      ),
 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader(AuthProvider authProvider) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.base.withOpacity(0.8),
          border: const Border(
            bottom: BorderSide(color: AppColors.borderColor),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text('Welcome back,', style: AppTextStyles.bodySmall),
            const SizedBox(height: 4),
            Text(
              '${authProvider.firebaseUser?.displayName ?? ""}',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),

            // Search bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: (query) {
                context.read<HomeProvider>().searchCanteens(query);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrdersSection(HomeProvider homeProvider) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Recently Ordered', style: AppTextStyles.h4),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: homeProvider.recentOrders.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final order = homeProvider.recentOrders[index];
                  return RecentOrderCard(
                    order: order,
                    onTap: () => context.push('/order/${order.id}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCanteensSection(HomeProvider homeProvider) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == 0) {
            // Section header
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('Canteens', style: AppTextStyles.h4),
            );
          }

          final canteenIndex = index - 1;
          if (canteenIndex >= homeProvider.canteens.length) {
            return null;
          }

          final canteen = homeProvider.canteens[canteenIndex];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CanteenCard(
              canteen: canteen,
              onTap: () {
                // Navigate to menu screen with canteen data
                context.pushNamed('menu', extra: canteen);
              },
            ),
          );
        }, childCount: homeProvider.canteens.length + 1),
      ),
    );
  }

  Widget _buildOrdersTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.base,
            border: Border(
              bottom: BorderSide(color: AppColors.borderColor),
            ),
          ),
          child: Row(
            children: [
              Text('Order History', style: AppTextStyles.h3),
            ],
          ),
        ),
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
                        onPressed: () {
                          final userId =
                              context.read<AuthProvider>().firebaseUser?.uid;
                          if (userId != null) {
                            context
                                .read<OrderProvider>()
                                .fetchOrderHistory(userId);
                          }
                        },
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
                onRefresh: () async {
                  final userId =
                      context.read<AuthProvider>().firebaseUser?.uid;
                  if (userId != null) {
                    context.read<OrderProvider>().fetchOrderHistory(userId);
                  }
                },
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
    );
  }

  Widget _buildProfileTab() {
    return Consumer2<AuthProvider, DeliveryProvider>(
      builder: (context, authProvider, deliveryProvider, _) {
        final user = authProvider.firebaseUser;
        final role = authProvider.userRole;
        final isDelivery = role == UserRole.deliveryStudent;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  (user?.displayName?.isNotEmpty == true ? user!.displayName! : (user?.email?.isNotEmpty == true ? user!.email! : 'U'))[0].toUpperCase(),
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user?.displayName ?? 'User',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
              if (role != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    role.displayName,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Delivery Mode Toggle (students only — teachers can't become delivery persons)
              if (role == UserRole.student || isDelivery) Container(
                decoration: BoxDecoration(
                  color: AppColors.base,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: SwitchListTile(
                  title: Text('Delivery Mode', style: AppTextStyles.bodyLarge),
                  subtitle: Text(
                    'Earn by delivering orders to classmates',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  value: isDelivery,
                  activeColor: AppColors.primary,
                  onChanged: (_) async {
                    await authProvider.toggleDeliveryMode();
                    if (authProvider.userRole == UserRole.deliveryStudent &&
                        user != null) {
                      deliveryProvider.fetchDeliveryHistory(user.uid);
                    }
                  },
                ),
              ),

              // Delivery Stats Section (only when in delivery mode)
              if (isDelivery) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Delivered',
                        '${deliveryProvider.deliveryHistory.length}',
                        Icons.check_circle_outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Earnings',
                        '\u20B9${deliveryProvider.deliveryHistory.fold<double>(0, (sum, o) => sum + o.deliveryFee).toStringAsFixed(0)}',
                        Icons.account_balance_wallet_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.base,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: deliveryProvider.activeOrder != null
                      ? Row(
                          children: [
                            Icon(Icons.delivery_dining,
                                color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Current Order',
                                      style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textSecondary)),
                                  const SizedBox(height: 2),
                                  Text(
                                    deliveryProvider
                                        .activeOrder!.canteenName,
                                    style: AppTextStyles.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                deliveryProvider
                                    .activeOrder!.status.displayName,
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: AppColors.primary),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Icon(Icons.delivery_dining,
                                color: AppColors.textSecondary),
                            const SizedBox(width: 12),
                            Text(
                              'No active delivery',
                              style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                ),
              ],

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await authProvider.signOut();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: Text(
                    'Logout',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.base,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.base,
        border: Border(top: BorderSide(color: AppColors.borderColor)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex: _currentIndex,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
