import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/features/landing/widgets/landing_tab_content.dart';
import 'package:chef_ai_mobile/features/landing/pages/onboarding_page.dart';
import 'package:chef_ai_mobile/features/authentication/pages/login_page.dart';
import 'package:flutter/material.dart';

class LandingContentSection extends StatefulWidget {
  const LandingContentSection({super.key});

  @override
  State<LandingContentSection> createState() => _LandingContentSectionState();
}

class _LandingContentSectionState extends State<LandingContentSection> {
  String selectedTab = 'getStarted';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,

      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              // CENTERED TAB GROUP
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),

                    borderRadius: BorderRadius.circular(999),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      _buildTabButton(
                        label: 'Key Features',
                        value: 'keyFeatures',
                      ),

                      _buildTabButton(
                        label: 'Get Started',
                        value: 'getStarted',
                      ),

                      _buildTabButton(
                        label: 'How This Works',
                        value: 'howThisWorks',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // CONTENT AREA
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),

                  child: SingleChildScrollView(
                    key: ValueKey(selectedTab),
                    child: Center(
                      child: LandingTabContent(selectedTab: selectedTab),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              
              // ACTION BUTTONS
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OnboardingPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({required String label, required String value}) {
    final isSelected = selectedTab == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = value;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),

        curve: const Cubic(0.2, 0.8, 0.2, 1),

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange : Colors.transparent,

          borderRadius: BorderRadius.circular(999),
        ),

        child: Text(
          label,

          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF9CA3AF),

            fontSize: 12,

            fontWeight: FontWeight.w800,

            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}
