import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/colors.dart';
import '../providers/onboarding_provider.dart';
import 'onboarding_page_indicator.dart';

/// Third onboarding screen: "Earn While You Learn"
class OnboardingScreenThree extends StatelessWidget {
  const OnboardingScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 48),

            // Icon Area
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  width: 192,
                  height: 192,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.payments_outlined,
                    size: 120,
                    color: AppColors.primary,
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
                    'Earn While You Learn',
                    style: theme.textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Text(
                      'Students can go \'Online\' to deliver orders and make extra cash on campus.',
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

                // Get Started button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final provider = context.read<OnboardingProvider>();
                      await provider.completeOnboarding();
                      if (context.mounted) {
                        context.go(RouteNames.login);
                      }
                    },
                    child: const Text('Get Started'),
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
