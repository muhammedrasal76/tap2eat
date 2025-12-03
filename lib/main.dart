import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/providers/onboarding_provider.dart';
import 'features/home/data/datasources/home_remote_datasource.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/usecases/get_canteens_usecase.dart';
import 'features/home/domain/usecases/get_recent_orders_usecase.dart';
import 'features/home/domain/usecases/get_settings_usecase.dart';
import 'features/home/domain/usecases/search_canteens_usecase.dart';
import 'features/home/presentation/providers/home_provider.dart';
import 'shared/providers/firebase_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseProvider.initialize();

  // Configure Firestore
  FirebaseProvider.instance.configureFirestore();

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

            // Create provider
            return HomeProvider(
              getCanteensUseCase: getCanteensUseCase,
              getRecentOrdersUseCase: getRecentOrdersUseCase,
              getSettingsUseCase: getSettingsUseCase,
              searchCanteensUseCase: searchCanteensUseCase,
            );
          },
        ),

        // TODO: Add more providers as features are implemented
        // ChangeNotifierProvider(create: (_) => MenuProvider()),
        // ChangeNotifierProvider(create: (_) => OrderProvider()),
        // ChangeNotifierProvider(create: (_) => CartProvider()),
        // ChangeNotifierProvider(create: (_) => OrderTrackingProvider()),
        // ChangeNotifierProvider(create: (_) => DeliveryProvider()),
        // ChangeNotifierProvider(create: (_) => EarningsProvider()),
        // ChangeNotifierProvider(create: (_) => NotificationProvider()),

        // Firebase Auth Stream
        // StreamProvider<User?>(
        //   create: (_) => FirebaseAuth.instance.authStateChanges(),
        //   initialData: null,
        // ),
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
