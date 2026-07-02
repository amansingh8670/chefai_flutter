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
        final iconSize = constraints.maxHeight * 0.42;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // =====================================================
            // LEFT ICON
            // =====================================================

            Container(
              width: constraints.maxWidth * 0.22,
              height: double.infinity,

              margin: const EdgeInsets.only(right: 10),

              decoration: BoxDecoration(
                color: AppColors.getAccentTeal(
                  themeMode,
                ).withValues(alpha: 0.12),

                borderRadius: BorderRadius.circular(14),

                border: Border.all(
                  color: AppColors.getAccentTeal(
                    themeMode,
                  ).withValues(alpha: 0.15),
                ),
              ),

              child: Center(
                child: Icon(
                  Icons.kitchen_rounded,
                  size: iconSize.clamp(18, 28),
                  color: AppColors.getAccentTeal(themeMode),
                ),
              ),
            ),

            // =====================================================
            // RIGHT CONTENT
            // =====================================================

            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),

                        children: [
                          TextSpan(
                            text: "Pantry ",
                            style: TextStyle(
                              color: AppColors.getAccentTeal(
                                themeMode,
                              ),
                            ),
                          ),

                          TextSpan(
                            text: "Tracker",
                            style: TextStyle(
                              color: AppColors.getTextPrimary(
                                themeMode,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 2),

                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),

                        children: [
                          TextSpan(
                            text: "Capacity good • ",
                            style: TextStyle(
                              color: AppColors.getTextPrimary(
                                themeMode,
                              ),
                            ),
                          ),

                          TextSpan(
                            text: "Eggs & Milk Low",
                            style: TextStyle(
                              color: AppColors.getPrimaryOrange(
                                themeMode,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 2),

                    SizedBox(
                      width: constraints.maxWidth * 0.52,
                      child: Text(
                        "16 out of 20 ingredients stocked",

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        textAlign: TextAlign.end,

                        style: TextStyle(
                          fontSize: 7,
                          height: 1,
                          fontWeight: FontWeight.w500,
                          color: AppColors.getTextSecondary(
                            themeMode,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}