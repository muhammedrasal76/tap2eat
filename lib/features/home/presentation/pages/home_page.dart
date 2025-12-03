import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_spinner.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
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
        child: Consumer2<AuthProvider, HomeProvider>(
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
                  await homeProvider.refresh(authProvider.firebaseUser!.uid);
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
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Consumer2<AuthProvider, HomeProvider>(
        builder: (context, authProvider, homeProvider, _) {
          final shouldShow = homeProvider.shouldShowGoOnlineButton(
            authProvider.userRole,
          );

          if (!shouldShow) return const SizedBox.shrink();

          return GoOnlineButton(
            onPressed: () {
              // TODO: Navigate to delivery student "Go Online" screen
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Going online...')));
            },
          );
        },
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
              height: 160,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: homeProvider.recentOrders.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final order = homeProvider.recentOrders[index];
                  return RecentOrderCard(
                    order: order,
                    onTap: () {
                      // TODO: Navigate to order details
                    },
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
                // TODO: Navigate to canteen menu
              },
            ),
          );
        }, childCount: homeProvider.canteens.length + 1),
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
        currentIndex: 0,
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
          // TODO: Handle navigation
        },
      ),
    );
  }
}
