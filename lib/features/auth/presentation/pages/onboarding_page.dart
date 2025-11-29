import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/colors.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_screen_one.dart';
import '../widgets/onboarding_screen_two.dart';
import '../widgets/onboarding_screen_three.dart';

/// Main onboarding page with PageView
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Listen to page changes and update provider
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      context.read<OnboardingProvider>().setCurrentPage(page);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disable back button on Android
      child: Scaffold(
        backgroundColor: AppColors.base,
        body: PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          children: [
            OnboardingScreenOne(pageController: _pageController),
            OnboardingScreenTwo(pageController: _pageController),
            const OnboardingScreenThree(),
          ],
        ),
      ),
    );
  }
}
