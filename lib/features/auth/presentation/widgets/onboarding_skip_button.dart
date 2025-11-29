import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/colors.dart';
import '../providers/onboarding_provider.dart';

/// Skip button for onboarding screens
class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final provider = context.read<OnboardingProvider>();
        await provider.skipOnboarding();
        if (context.mounted) {
          context.go(RouteNames.login);
        }
      },
      child: Text(
        'Skip',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
