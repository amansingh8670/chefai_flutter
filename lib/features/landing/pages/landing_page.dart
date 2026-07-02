import 'package:flutter/material.dart';

import '../widgets/landing_banner_section.dart';
import '../widgets/landing_content_section.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {

    final screenHeight =
        MediaQuery.of(context).size.height;

    return Scaffold(

      backgroundColor: Colors.white,

      body: Stack(

        clipBehavior: Clip.none,

        children: [

          // ORANGE BANNER
          SizedBox(

            height: screenHeight * 0.64,

            width: double.infinity,

            child: const LandingBannerSection(),
          ),

          // WHITE FLOATING SHEET
          Align(

            alignment: Alignment.bottomCenter,

            child: Container(

              height: screenHeight * 0.48,

              width: double.infinity,

              clipBehavior: Clip.antiAlias,

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(42),
                  topRight: Radius.circular(42),
                ),

                boxShadow: [

                  BoxShadow(

                    color: Colors.black.withValues(
                      alpha: 0.12,
                    ),

                    blurRadius: 40,

                    offset: const Offset(0, -10),
                  ),
                ],
              ),

              child: const LandingContentSection(),
            ),
          ),
        ],
      ),
    );
  }
}