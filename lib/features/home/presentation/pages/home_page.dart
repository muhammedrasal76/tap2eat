import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_spinner.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
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
        child: IndexedStack(
          index: _currentIndex,
          children: [
            // Tab 0: Home
            Consumer2<AuthProvider, HomeProvider>(
              builder: (context, authProvider, homeProvider, _) {
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
                      // Header with welcome message and search
                      _buildHeader(authProvider),

                      // Recently Ordered Section
                      if (homeProvider.recentOrders.isNotEmpty)
                        _buildRecentOrdersSection(homeProvider),

                      // Canteens Section
                      _buildCanteensSection(homeProvider),

                      // Bottom padding for FAB
                      const SliverToBoxAdapter(
                          child: SizedBox(height: 100)),
                    ],
                  ),
                );
              },
            ),
            // Tab 1: Orders
            _buildOrdersTab(),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? Consumer2<AuthProvider, HomeProvider>(
              builder: (context, authProvider, homeProvider, _) {
                final shouldShow = homeProvider.shouldShowGoOnlineButton(
                  authProvider.userRole,
                );

                if (!shouldShow) return const SizedBox.shrink();

                return GoOnlineButton(
                  onPressed: () {
                    // TODO: Navigate to delivery student "Go Online" screen
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Going online...')));
                  },
                );
              },
            )
          : null,
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
              '${authProvider.firebaseUser?.displayName ?? "User"} 👋',
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
          if (index == 1) {
            final userId = context.read<AuthProvider>().firebaseUser?.uid;
            if (userId != null) {
              context.read<OrderProvider>().fetchOrderHistory(userId);
            }
          }
        },
      ),
    );
  }
}
