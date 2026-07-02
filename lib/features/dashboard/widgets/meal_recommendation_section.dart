import 'package:chef_ai_mobile/features/dashboard/widgets/recommended_meal_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';

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
        Expanded(
          child: Container(
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
                    color: Colors.black.withValues(alpha: 0.16),
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
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),

                    child: _buildMealContent(),
                  ),
                ),
              ],
            ),
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
                      color: AppColors.primaryOrange.withValues(alpha: 0.25),
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

  Widget _buildMealContent() {
    switch (selectedTab) {
      case "breakfast":
        return const RecommendedMealItem(
          imagePath: "assets/images/breakfast.jpg",
          isVeg: true,
          title: "Oats Protein Bowl",
          rating: 4.3,
          kcal: 320,
          protein: 18,
          description: "Healthy morning oats bowl with fruits and nuts.",
          ingredientsToBuy: ["Oats", "Milk", "Banana"],
        );

      case "lunch":
        return const RecommendedMealItem(
          imagePath: "assets/images/lunch.jpg",
          isVeg: false,
          title: "Chicken Rice Bowl",
          rating: 4.6,
          kcal: 540,
          protein: 35,
          description: "High protein lunch for sustained energy levels.",
          ingredientsToBuy: ["Chicken", "Rice", "Spices"],
        );

      case "snacks":
        return const RecommendedMealItem(
          imagePath: "assets/images/snacks.jpg",
          isVeg: true,
          title: "Fruit Nut Mix",
          rating: 4.1,
          kcal: 210,
          protein: 8,
          description: "Healthy evening snack with mixed dry fruits.",
          ingredientsToBuy: ["Almonds", "Cashews", "Dates"],
        );

      default:
        return const RecommendedMealItem(
          imagePath: "assets/images/dinner.jpg",
          isVeg: true,
          title: "Whole Wheat Garlic-Parsley Pasta With Sautéed Onions",
          rating: 4.8,
          kcal: 600,
          protein: 45,
          description:
              "Avoids today's tomato/chili ingredients for meal variance. Whole wheat pasta and onions provide healthy carbs, fiber and micronutrients.",
          ingredientsToBuy: ["Garlic", "Parsley", "Fresh Herbs"],
        );
    }
  }
}
