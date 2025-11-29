import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../config/constants/enum_values.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/colors.dart';
import '../providers/auth_provider.dart';
import '../providers/onboarding_provider.dart';

/// Splash screen that checks onboarding status and auth state
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<_InitializationResult>? _initializationFuture;

  @override
  void initState() {
    super.initState();
    // Capture providers synchronously (safe BuildContext usage)
    final onboardingProvider = context.read<OnboardingProvider>();
    final authProvider = context.read<AuthProvider>();
    _initializationFuture = _initializeApp(onboardingProvider, authProvider);
  }

  /// Initialize app by checking onboarding and auth state
  /// Returns a result object containing the navigation decision
  Future<_InitializationResult> _initializeApp(
    OnboardingProvider onboardingProvider,
    AuthProvider authProvider,
  ) async {
    try {
      // 1. Check onboarding status (from SharedPreferences)
      await onboardingProvider.checkOnboardingStatus();

      // 2. Restore auth session if exists (from Firebase)
      await authProvider.initAuthState();

      // 3. Small delay for splash screen effect (UX improvement)
      await Future.delayed(const Duration(milliseconds: 500));

      // 4. Return result based on current state
      return _InitializationResult(
        hasCompletedOnboarding: onboardingProvider.hasCompletedOnboarding,
        isAuthenticated: authProvider.isAuthenticated,
        userRole: authProvider.userRole,
        error: authProvider.errorMessage,
      );
    } catch (e) {
      // Handle unexpected errors
      return _InitializationResult(
        hasCompletedOnboarding: false,
        isAuthenticated: false,
        userRole: null,
        error: 'Failed to initialize: $e',
      );
    }
  }

  /// Handle navigation based on initialization result
  /// This is called AFTER Future completes, so BuildContext is safe
  void _handleNavigation(_InitializationResult result) {
    // Check if widget is still mounted before navigation
    if (!mounted) return;

    // If there's an error, log it
    if (result.error != null) {
      debugPrint('Initialization error: ${result.error}');
    }

    // Navigation decision tree (follows PRD requirements)

    // Case 1: First-time user - show onboarding
    if (!result.hasCompletedOnboarding) {
      context.go(RouteNames.onboarding);
      return;
    }

    // Case 2: Returning user with active session - go to role-based home
    if (result.isAuthenticated && result.userRole != null) {
      _navigateToRoleBasedHome(result.userRole!);
      return;
    }

    // Case 3: Returning user, not logged in - show login
    context.go(RouteNames.login);
  }

  /// Navigate to home page based on user role
  void _navigateToRoleBasedHome(UserRole role) {
    if (!mounted) return;

    switch (role) {
      case UserRole.student:
        context.go(RouteNames.studentHome);
        break;
      case UserRole.teacher:
        context.go(RouteNames.teacherHome);
        break;
      case UserRole.deliveryStudent:
        context.go(RouteNames.deliveryStudentHome);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: FutureBuilder<_InitializationResult>(
        future: _initializationFuture,
        builder: (context, snapshot) {
          // Still loading - show splash screen
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          // Completed with error - navigate to login with error logged
          if (snapshot.hasError) {
            debugPrint('Splash initialization error: ${snapshot.error}');
            // Use addPostFrameCallback to ensure navigation happens after build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                context.go(RouteNames.login);
              }
            });
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          // Completed successfully - navigate based on result
          if (snapshot.hasData) {
            // Use addPostFrameCallback to ensure navigation happens AFTER build completes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _handleNavigation(snapshot.data!);
            });
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          // Fallback (should never reach here)
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        },
      ),
    );
  }
}

/// Result of app initialization containing navigation decision data
class _InitializationResult {
  final bool hasCompletedOnboarding;
  final bool isAuthenticated;
  final UserRole? userRole;
  final String? error;

  const _InitializationResult({
    required this.hasCompletedOnboarding,
    required this.isAuthenticated,
    required this.userRole,
    this.error,
  });
}
