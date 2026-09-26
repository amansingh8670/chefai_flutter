import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';
import 'package:chef_ai_mobile/providers/user_provider.dart';
import 'package:chef_ai_mobile/providers/meals_provider.dart';
import 'package:chef_ai_mobile/shared/widgets/charts/liquid_wave_progress.dart';

import 'meal_item.dart';

class MealTrackerSection extends ConsumerWidget {
  const MealTrackerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final userProfileAsync = ref.watch(userProfileProvider);
    final mealsAsync = ref.watch(mealsProvider);
    
    final total = userProfileAsync.value?.dailyCalories?.toDouble() ?? 2000.0;
    final consumed = ref.watch(todaysCaloriesProvider).toDouble();

    final remaining = (total - consumed).toInt();
    final progress = consumed / total;

    final chartSize = 85.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================
        // LEFT
        // =====================================================

        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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

              const SizedBox(height: 6),

              // CENTERED CHART
              Center(
                child: SizedBox(
                  width: chartSize,
                  height: chartSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: chartSize,
                        height: chartSize,
                        child: LiquidWaveProgress(
                          progress: progress,
                          waveColor: AppColors.getAccentTeal(themeMode),
                          backgroundColor: AppColors.getGraphPrimary(themeMode).withOpacity(0.1),
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            consumed.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColors.getTextPrimary(themeMode),
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "KCAL",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.getTextPrimary(themeMode).withOpacity(0.6),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // BOTTOM LABEL
              Center(
                child: Text(
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
            mainAxisSize: MainAxisSize.min,
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

              const SizedBox(height: 8),

              mealsAsync.when(
                data: (meals) {
                  if (meals.isEmpty) {
                    return const Center(
                      child: Text(
                        "No meals yet",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  
                  final recentMeals = meals.take(3).toList();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: recentMeals.map((meal) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: MealItem(
                          icon: Icons.fastfood,
                          name: meal.name.length > 9 ? "${meal.name.substring(0, 7)}.." : meal.name,
                          time: "${meal.createdAt.hour}:${meal.createdAt.minute.toString().padLeft(2, '0')}",
                          kcal: "${meal.calories}k",
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                error: (_, __) => const Center(child: Text("Error", style: TextStyle(fontSize: 10))),
              ),
            ],
          ),
        ),
      ],
    );
  }
}