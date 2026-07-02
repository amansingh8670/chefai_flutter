import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';

import 'meal_item.dart';

class MealTrackerSection extends ConsumerWidget {
  const MealTrackerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    const consumed = 1450.0;
    const total = 2000.0;

    final remaining = (total - consumed).toInt();
    final progress = consumed / total;

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartSize = constraints.maxHeight * 0.52;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // =====================================================
            // LEFT
            // =====================================================

            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOP LABELS
                  Column(
                    children: [
                      Text(
                        "TODAY'S",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.getAccentTeal(themeMode),
                          height: 1,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        "Calories",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.getTextPrimary(themeMode),
                          height: 1,
                        ),
                      ),
                    ],
                  ),

                  // CENTERED CHART
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: chartSize,
                        height: chartSize,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: chartSize,
                              height: chartSize,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 6,
                                backgroundColor:
                                    AppColors.getDivider(themeMode),
                                valueColor: AlwaysStoppedAnimation(
                                  AppColors.getGraphPrimary(themeMode),
                                ),
                              ),
                            ),

                            Container(
                              width: chartSize * 0.72,
                              height: chartSize * 0.72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.getGraphPrimary(
                                  themeMode,
                                ).withValues(alpha: 0.14),
                              ),
                            ),

                            Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  consumed.toInt().toString(),
                                  style: TextStyle(
                                    fontSize: chartSize * 0.18,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                    color:
                                        AppColors.getTextPrimary(
                                      themeMode,
                                    ),
                                  ),
                                ),

                                Text(
                                  "KCAL",
                                  style: TextStyle(
                                    fontSize: chartSize * 0.07,
                                    fontWeight: FontWeight.w700,
                                    height: 1,
                                    color:
                                        AppColors.getTextPrimary(
                                      themeMode,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // BOTTOM LABEL
                  Text(
                    "$remaining kcal remaining",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextSecondary(
                        themeMode,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            // =====================================================
            // RIGHT
            // =====================================================

            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "RECENT",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.getAccentTeal(themeMode),
                      height: 1,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    "Meals",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.getTextPrimary(themeMode),
                      height: 1,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                      children: const [
                        MealItem(
                          icon: Icons.eco,
                          name: "Avocado T.",
                          time: "8:30 AM",
                          kcal: "350k",
                        ),

                        SizedBox(height: 2),

                        MealItem(
                          icon: Icons.icecream,
                          name: "Yogurt",
                          time: "11:15 AM",
                          kcal: "180k",
                        ),

                        SizedBox(height: 2),

                        MealItem(
                          icon: Icons.set_meal,
                          name: "Salmon L.",
                          time: "1:45 PM",
                          kcal: "420k",
                        ),
                      ],
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