import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/colors.dart';
import '../providers/onboarding_provider.dart';
import 'onboarding_page_indicator.dart';
import 'onboarding_skip_button.dart';

/// First onboarding screen: "Skip the Queue, Savor the Moment"
class OnboardingScreenOne extends StatelessWidget {
  final PageController pageController;

  const OnboardingScreenOne({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: const OnboardingSkipButton(),
              ),
            ),

            // Icon Area
            Expanded(
              flex: 3,
              child: Center(
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer circle background
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),

                      // Inner circle background
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),

                      // Main tablet icon
                      Icon(
                        Icons.tablet_android,
                        size: 80,
                        color: AppColors.primary,
                      ),

                      // Timer badge (top-right)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.timer,
                            size: 32,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Text Area
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Skip the Queue, Savor the Moment',
                    style: theme.textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Text(
                      'Pre-order your campus meals in a flash and reclaim your break time.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Bottom controls
            Column(
              children: [
                // Page indicator
                Consumer<OnboardingProvider>(
                  builder: (context, provider, _) {
                    return OnboardingPageIndicator(
                      currentPage: provider.currentPage,
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Next button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Next'),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
