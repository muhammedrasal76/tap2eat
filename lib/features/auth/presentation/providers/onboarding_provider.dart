import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing onboarding state
class OnboardingProvider extends ChangeNotifier {
  int _currentPage = 0;
  bool _hasCompletedOnboarding = false;

  static const String _onboardingKey = 'has_completed_onboarding';

  int get currentPage => _currentPage;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  /// Check if user has completed onboarding
  Future<void> checkOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _hasCompletedOnboarding = prefs.getBool(_onboardingKey) ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking onboarding status: $e');
      _hasCompletedOnboarding = false;
    }
  }

  /// Update current page index
  void setCurrentPage(int page) {
    if (_currentPage != page) {
      _currentPage = page;
      notifyListeners();
    }
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
      _hasCompletedOnboarding = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error completing onboarding: $e');
    }
  }

  /// Skip onboarding (same as complete)
  Future<void> skipOnboarding() async {
    await completeOnboarding();
  }
}
