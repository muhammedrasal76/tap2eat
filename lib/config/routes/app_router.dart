import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import 'route_names.dart';

/// App router configuration using GoRouter
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.login,
    routes: [
      // Auth routes
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Registration Page - To be implemented')),
        ),
      ),

      // Home routes (role-based)
      GoRoute(
        path: RouteNames.studentHome,
        name: 'student-home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.teacherHome,
        name: 'teacher-home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.deliveryStudentHome,
        name: 'delivery-student-home',
        builder: (context, state) => const HomePage(),
      ),

      // Menu routes
      GoRoute(
        path: RouteNames.menu,
        name: 'menu',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Menu Page - To be implemented')),
        ),
      ),

      // Order routes
      GoRoute(
        path: RouteNames.checkout,
        name: 'checkout',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Checkout Page - To be implemented')),
        ),
      ),
      GoRoute(
        path: RouteNames.orderHistory,
        name: 'order-history',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Order History - To be implemented')),
        ),
      ),

      // Delivery routes
      GoRoute(
        path: RouteNames.deliveryDashboard,
        name: 'delivery-dashboard',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Delivery Dashboard - To be implemented')),
        ),
      ),

      // Earnings routes
      GoRoute(
        path: RouteNames.earnings,
        name: 'earnings',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Earnings Page - To be implemented')),
        ),
      ),

      // Settings
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Settings - To be implemented')),
        ),
      ),
    ],

    // TODO: Implement role-based redirect logic
    // redirect: (context, state) {
    //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
    //   final isAuthenticated = authProvider.isAuthenticated;
    //   final userRole = authProvider.user?.role;
    //
    //   // Add navigation guards based on user role and authentication status
    //   return null;
    // },
  );
}
