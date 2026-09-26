import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';

class PantryTrackerSection extends ConsumerWidget {
  const PantryTrackerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // =====================================================
            // LEFT CONTENT (TEXT)
            // =====================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                      children: [
                        TextSpan(
                          text: "PANTRY ",
                          style: TextStyle(
                            color: AppColors.getAccentTeal(themeMode),
                          ),
                        ),
                        TextSpan(
                          text: "Tracker",
                          style: TextStyle(
                            color: AppColors.getTextPrimary(themeMode),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      children: [
                        TextSpan(
                          text: "Capacity Good ",
                          style: TextStyle(
                            color: AppColors.getTextPrimary(themeMode),
                          ),
                        ),
                        TextSpan(
                          text: "• ",
                          style: TextStyle(
                            color: AppColors.getPrimaryOrange(themeMode),
                          ),
                        ),
                        TextSpan(
                          text: "Eggs & Milk low",
                          style: TextStyle(
                            color: AppColors.getPrimaryOrange(themeMode),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "16 of 20 ingredients stocked in your kitchen.",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.getTextSecondary(themeMode),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // =====================================================
            // MIDDLE CIRCLE INDICATOR
            // =====================================================
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.getAccentTeal(themeMode),
                    AppColors.getPrimaryOrange(themeMode),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.getCardBg(themeMode),
                  ),
                  child: Center(
                    child: Text(
                      "80%",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.getAccentTeal(themeMode),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // =====================================================
            // RIGHT ICON (STACKED IMAGES)
            // =====================================================
            SizedBox(
              width: 65,
              height: 65,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Outline image
                  Image.asset(
                    'assets/images/pantry_bag_outline.png',
                    color: AppColors.getTextSecondary(themeMode).withOpacity(0.5),
                    fit: BoxFit.contain,
                  ),
                  // Colored image filled from bottom
                  ClipRect(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      heightFactor: 16 / 20, // 80% filled
                      child: Image.asset(
                        'assets/images/pantry_bag_colored.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}