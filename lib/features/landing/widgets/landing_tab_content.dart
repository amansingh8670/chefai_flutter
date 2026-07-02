import 'package:flutter/material.dart';
import 'package:chef_ai_mobile/core/theme/app_colors.dart';

class LandingTabContent extends StatelessWidget {
  final String selectedTab;

  const LandingTabContent({super.key, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case 'keyFeatures':
        return _buildKeyFeatures();

      case 'getStarted':
        return _buildGetStarted();

      case 'howThisWorks':
      default:
        return _buildHowItWorks();
    }
  }

  Widget _buildKeyFeatures() {
    return const Text(
      "Key Features content section",
      textAlign: TextAlign.center,
    );
  }

  Widget _buildGetStarted() {
    return Text.rich(
      TextSpan(
        style: const TextStyle(fontSize: 20, height: 1.2),
        children: [
          const TextSpan(
            text: "Cook Smarter,\n",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 44,
            ),
          ),
          TextSpan(
            text: "Together.\n\n",
            style: TextStyle(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.w800,
              fontSize: 44,
            ),
          ),
          const TextSpan(
            text: "Share your pantry with family, roommates, or partners.\n",
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
          const TextSpan(
            text: "AI Chef tracks your shared stock, nutrition, and ",
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
          TextSpan(
            text: "auto-refills via Swiggy Instamart.",
            style: TextStyle(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildHowItWorks() {
    return const Text(
      "How This Works content section",
      textAlign: TextAlign.center,
    );
  }
}
