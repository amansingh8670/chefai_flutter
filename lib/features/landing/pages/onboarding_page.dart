import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/features/landing/widgets/onboarding_carousel.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return Scaffold(
      backgroundColor: AppColors.getBackground(themeMode),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.getTextPrimary(themeMode)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const SafeArea(
        child: OnboardingCarousel(),
      ),
    );
  }
}
