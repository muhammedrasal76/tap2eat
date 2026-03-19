import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../core/services/notification_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/delivery_provider.dart';
import '../widgets/delivery_assignment_popup.dart';
import '../widgets/delivery_order_card.dart';
import '../widgets/delivery_status_toggle.dart';

class DeliveryHomePage extends StatefulWidget {
  const DeliveryHomePage({super.key});

  @override
  State<DeliveryHomePage> createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      _setupNotificationHandlers();
      _loadData();
    });
  }

  void _setupNotificationHandlers() {
    final provider = context.read<DeliveryProvider>();

    NotificationService.instance.setDeliveryAssignmentHandler((data) {
      provider.setPendingAssignment(data);
      _showAssignmentPopup();
    });

    NotificationService.instance.setNavigationHandler((route, {orderId}) {
      if (mounted) {
        context.push(route);
      }
    });
  }

  void _loadData() {
    final userId = context.read<AuthProvider>().firebaseUser?.uid ?? '';
    if (userId.isNotEmpty) {
      context.read<DeliveryProvider>().fetchDeliveryHistory(userId);

      // Request notification permission & register token
      NotificationService.instance.requestPermission().then((_) {
        NotificationService.instance.registerCurrentToken(userId);
      });
    }
  }

  void _showAssignmentPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<DeliveryProvider>(),
        child: const DeliveryAssignmentPopup(),
      ),
    ).then((accepted) {
      if (!mounted) return;
      if (accepted == true) {
        final provider = context.read<DeliveryProvider>();
        final orderId = provider.activeOrderId;
        if (orderId != null) {
          context.push('/delivery/$orderId');
        }
      }
    });
  }

  @override
  void dispose() {
    NotificationService.instance.setDeliveryAssignmentHandler(null);
    NotificationService.instance.setNavigationHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        title: Text('Delivery', style: AppTextStyles.h3),
        actions: const [
          DeliveryStatusToggle(),
          SizedBox(width: 16),
        ],
      ),
      body: Consumer<DeliveryProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            onRefresh: () async {
              final userId =
                  context.read<AuthProvider>().firebaseUser?.uid ?? '';
              if (userId.isNotEmpty) {
                await provider.fetchDeliveryHistory(userId);
              }
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Offline banner
                if (!provider.isOnline && !provider.hasActiveDelivery)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.wifi_off, color: AppColors.error),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'You are offline. Toggle online to receive delivery requests.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Active delivery card
                if (provider.hasActiveDelivery &&
                    provider.activeOrder != null) ...[
                  Text('Active Delivery', style: AppTextStyles.h4),
                  const SizedBox(height: 8),
                  DeliveryOrderCard(
                    order: provider.activeOrder!,
                    onTap: () {
                      context.push('/delivery/${provider.activeOrderId}');
                    },
                  ),
                  const SizedBox(height: 24),
                ],

                // Waiting state
                if (provider.isOnline &&
                    !provider.hasActiveDelivery) ...[
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.delivery_dining,
                          size: 64,
                          color: AppColors.primary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Waiting for assignments...',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You will be notified when a delivery is available',
                          style: AppTextStyles.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],

                // Delivery history
                Text('Delivery History', style: AppTextStyles.h4),
                const SizedBox(height: 12),

                if (provider.isLoadingHistory)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (provider.historyError != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        provider.historyError!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  )
                else if (provider.deliveryHistory.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'No delivery history yet',
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  )
                else
                  ...provider.deliveryHistory.map(
                    (order) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: DeliveryOrderCard(
                        order: order,
                        onTap: () {
                          context.push('/delivery/${order.id}');
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
