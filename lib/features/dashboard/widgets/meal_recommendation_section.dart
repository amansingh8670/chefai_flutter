import 'package:chef_ai_mobile/features/dashboard/widgets/recommended_meal_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';
import 'package:chef_ai_mobile/providers/recommendation_provider.dart';

class MealRecommendationSection extends ConsumerStatefulWidget {
  const MealRecommendationSection({super.key});

  @override
  ConsumerState<MealRecommendationSection> createState() =>
      _MealRecommendationSectionState();
}

class _MealRecommendationSectionState
    extends ConsumerState<MealRecommendationSection> {
  String selectedTab = 'dinner';

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final recommendationsAsync = ref.watch(recommendationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================
        // HEADER
        // =====================================================
        Text(
          "MEAL",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.getAccentTeal(themeMode),
            letterSpacing: 0.5,
            height: 1,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          "Recommendation",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.getTextPrimary(themeMode),
            height: 1,
          ),
        ),

        const SizedBox(height: 10),

        // =====================================================
        // OUTER CARD
        // =====================================================
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.getCardBg(themeMode),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.getDivider(themeMode),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.getShadow(themeMode),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // =====================================================
              // CUSTOM TAB BAR
              // =====================================================
              Container(
                height: 34,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.getDivider(themeMode),
                    width: 0.4,
                  ),
                ),
                child: Row(
                  children: [
                    _tabItem("BREAKFAST", "breakfast", themeMode),
                    _tabItem("LUNCH", "lunch", themeMode),
                    _tabItem("SNACKS", "snacks", themeMode),
                    _tabItem("DINNER", "dinner", themeMode),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // =====================================================
              // CONTENT
              // =====================================================
              recommendationsAsync.when(
                data: (data) => _buildMealContent(data),
                loading: () => _buildLoadingShimmer(themeMode),
                error: (err, _) => Center(child: Text("Error fetching recommendations: $err")),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =====================================================
  // TAB ITEM
  // =====================================================

  Widget _tabItem(String label, String value, ThemeMode themeMode) {
    final isSelected = selectedTab == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = value;
          });
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),

          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryOrange : Colors.transparent,

            borderRadius: BorderRadius.circular(10),

            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryOrange.withOpacity( 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),

          child: FittedBox(
            fit: BoxFit.scaleDown,

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),

              child: Text(
                label,
                maxLines: 1,

                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.15,

                  color: isSelected
                      ? Colors.white
                      : AppColors.getTextSecondary(themeMode),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // CONTENT SWITCH
  // =====================================================

  Widget _buildLoadingShimmer(ThemeMode themeMode) {
    return Shimmer.fromColors(
      baseColor: AppColors.getCardBg(themeMode),
      highlightColor: AppColors.getDivider(themeMode),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 20, width: 150, color: Colors.white),
          const SizedBox(height: 8),
          Container(height: 10, width: double.infinity, color: Colors.white),
          const SizedBox(height: 4),
          Container(height: 10, width: 200, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 120, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
        ],
      ),
    );
  }

  Widget _buildMealContent(DailyRecommendations? data) {
    if (data == null) {
      return const Center(child: Text("No recommendations available for this kitchen."));
    }
    
    MealRecommendation? currentRec;
    switch (selectedTab) {
      case "breakfast": currentRec = data.breakfast; break;
      case "lunch": currentRec = data.lunch; break;
      case "snacks": currentRec = data.snack; break;
      default: currentRec = data.dinner;
    }

    if (currentRec == null) {
      return const Center(child: Text("No recommendation available for this meal time yet."));
    }

    return RecommendedMealItem(
      imagePath: currentRec.imageUrl ?? '', 
      isVeg: true, // Assuming true for now, can be added to backend later
      title: currentRec.recipeName,
      rating: 4.8,
      kcal: currentRec.calories,
      protein: 0, // Placeholder
      description: currentRec.description,
      ingredientsToBuy: currentRec.missingIngredients,
    );
  }
}
