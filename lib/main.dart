import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
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
