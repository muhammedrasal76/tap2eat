import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_router.dart';
import 'core/services/notification_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/providers/onboarding_provider.dart';
import 'features/delivery/data/datasources/delivery_remote_datasource.dart';
import 'features/delivery/data/repositories/delivery_repository_impl.dart';
import 'features/delivery/domain/usecases/accept_assignment_usecase.dart';
import 'features/delivery/domain/usecases/check_delivery_availability_usecase.dart';
import 'features/delivery/domain/usecases/get_delivery_history_usecase.dart';
import 'features/delivery/domain/usecases/reject_assignment_usecase.dart';
import 'features/delivery/domain/usecases/update_delivery_status_usecase.dart';
import 'features/delivery/domain/usecases/update_online_status_usecase.dart';
import 'features/delivery/presentation/providers/delivery_provider.dart';
import 'features/home/data/datasources/home_remote_datasource.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/usecases/get_canteens_usecase.dart';
import 'features/home/domain/usecases/get_recent_orders_usecase.dart';
import 'features/home/domain/usecases/get_settings_usecase.dart';
import 'features/home/domain/usecases/search_canteens_usecase.dart';
import 'features/home/domain/usecases/watch_recent_orders_usecase.dart';
import 'features/home/presentation/providers/home_provider.dart';
import 'features/menu/presentation/providers/cart_provider.dart';
import 'features/order/data/datasources/order_remote_datasource.dart';
import 'features/order/data/repositories/order_repository_impl.dart';
import 'features/order/domain/usecases/create_order_usecase.dart';
import 'features/order/domain/usecases/get_active_order_count_usecase.dart';
import 'features/order/domain/usecases/get_order_detail_usecase.dart';
import 'features/order/domain/usecases/get_order_history_usecase.dart';
import 'features/order/domain/usecases/watch_order_history_usecase.dart';
import 'features/order/domain/usecases/watch_order_detail_usecase.dart';
import 'features/order/presentation/providers/order_provider.dart';
import 'shared/providers/firebase_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseProvider.initialize();

  // Configure Firestore
  FirebaseProvider.instance.configureFirestore();

  // Set up FCM background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize notification service
  await NotificationService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Onboarding Provider
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),

        // Home Provider
        ChangeNotifierProvider(
          create: (context) {
            // Initialize data source
            final homeDataSource = HomeRemoteDataSourceImpl(
              firestore: FirebaseFirestore.instance,
            );

            // Initialize repository
            final homeRepository = HomeRepositoryImpl(
              remoteDataSource: homeDataSource,
            );

            // Initialize use cases
            final getCanteensUseCase = GetCanteensUseCase(homeRepository);
            final getRecentOrdersUseCase =
                GetRecentOrdersUseCase(homeRepository);
            final getSettingsUseCase = GetSettingsUseCase(homeRepository);
            final searchCanteensUseCase = SearchCanteensUseCase(homeRepository);
            final watchRecentOrdersUseCase =
                WatchRecentOrdersUseCase(homeRepository);

            // Create provider
            return HomeProvider(
              getCanteensUseCase: getCanteensUseCase,
              getRecentOrdersUseCase: getRecentOrdersUseCase,
              getSettingsUseCase: getSettingsUseCase,
              searchCanteensUseCase: searchCanteensUseCase,
              watchRecentOrdersUseCase: watchRecentOrdersUseCase,
            );
          },
        ),

        // Cart Provider
        ChangeNotifierProvider(create: (_) => CartProvider()),

        // Order Provider
        ChangeNotifierProvider(
          create: (context) {
            final orderDataSource = OrderRemoteDataSourceImpl(
              firestore: FirebaseFirestore.instance,
            );
            final orderRepository = OrderRepositoryImpl(
              remoteDataSource: orderDataSource,
            );
            final deliveryDataSource = DeliveryRemoteDataSourceImpl(
              firestore: FirebaseFirestore.instance,
              functions: FirebaseFunctions.instance,
            );
            final deliveryRepository = DeliveryRepositoryImpl(
              remoteDataSource: deliveryDataSource,
            );
            return OrderProvider(
              createOrderUseCase: CreateOrderUseCase(orderRepository),
              getOrderHistoryUseCase: GetOrderHistoryUseCase(orderRepository),
              getOrderDetailUseCase: GetOrderDetailUseCase(orderRepository),
              getActiveOrderCountUseCase:
                  GetActiveOrderCountUseCase(orderRepository),
              checkDeliveryAvailabilityUseCase:
                  CheckDeliveryAvailabilityUseCase(deliveryRepository),
              watchOrderHistoryUseCase:
                  WatchOrderHistoryUseCase(orderRepository),
              watchOrderDetailUseCase: WatchOrderDetailUseCase(orderRepository),
              repository: orderRepository,
            );
          },
        ),

        // Delivery Provider
        ChangeNotifierProvider(
          create: (context) {
            final deliveryDataSource = DeliveryRemoteDataSourceImpl(
              firestore: FirebaseFirestore.instance,
              functions: FirebaseFunctions.instance,
            );
            final deliveryRepository = DeliveryRepositoryImpl(
              remoteDataSource: deliveryDataSource,
            );
            return DeliveryProvider(
              updateOnlineStatusUseCase:
                  UpdateOnlineStatusUseCase(deliveryRepository),
              acceptAssignmentUseCase:
                  AcceptAssignmentUseCase(deliveryRepository),
              rejectAssignmentUseCase:
                  RejectAssignmentUseCase(deliveryRepository),
              updateDeliveryStatusUseCase:
                  UpdateDeliveryStatusUseCase(deliveryRepository),
              getDeliveryHistoryUseCase:
                  GetDeliveryHistoryUseCase(deliveryRepository),
              repository: deliveryRepository,
            );
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Tap2Eat',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        
      ),
    );
  }
}
