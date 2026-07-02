import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LandingBannerSection extends StatelessWidget {
  const LandingBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      // NAVY BLUE BACKGROUND (unchanged)
      color: const Color(0xFF0B1B3A),

      child: SafeArea(
        bottom: false,

        child: Center(
          child: Transform.translate(
            offset: const Offset(0, -20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                // LOGO (REPLACED WITH SVG)
                SvgPicture.asset(
                  'assets/icons/chefai_logo.svg', // <- change manually
                  height: 90,
                  width: 90,
                  
                ),

                const SizedBox(height: 14),

                // APP NAME SPLIT STYLING
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "CHEF",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryOrange,
                          letterSpacing: 0.3,
                        ),
                      ),
                      TextSpan(
                        text: "AI",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // GRADIENT SUBTITLE (unchanged)
                const _GradientSubtitle(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Gradient subtitle widget
class _GradientSubtitle extends StatelessWidget {
  const _GradientSubtitle();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFfdba74)],
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },

      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          "Get your master chef at your fingertips",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}