import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/colors.dart';
import '../providers/onboarding_provider.dart';
import 'onboarding_page_indicator.dart';
import 'onboarding_skip_button.dart';

/// Second onboarding screen: "Your Food, Your Way"
class OnboardingScreenTwo extends StatelessWidget {
  final PageController pageController;

  const OnboardingScreenTwo({
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Single gradient circle background
                    Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0xFF3EC1F3).withOpacity(0.25), // Blue center
                            AppColors.primary.withOpacity(0.15), // Green (#4ADE80) outer
                            AppColors.primary.withOpacity(0.05),
                             // Very light green edge
                          ],
                          stops: [0.0, 0.6, 1.0],
                          center: Alignment.center,
                        ),
                      ),
                    ),

                    // Main content - Two cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Pickup card
                        _buildGlassmorphicCard(
                          context: context,
                          icon: Icons.shopping_bag_outlined,
                          label: 'Pickup',
                        ),

                        const SizedBox(width: 16),

                        // Delivery card
                        _buildGlassmorphicCard(
                          context: context,
                          icon: Icons.delivery_dining_outlined,
                          label: 'Delivery',
                          iconColor: Color(0xFF3EC1F3),
                        ),
                      ],
                    ),
                  ],
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
                    'Your Food, Your Way',
                    style: theme.textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Text(
                      'Choose between quick pickup or convenient campus delivery, right to your location.',
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

  Widget _buildGlassmorphicCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textSecondary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 60,
            color: iconColor ?? AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
