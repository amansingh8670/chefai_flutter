import 'package:chef_ai_mobile/core/theme/app_theme.dart';
import 'package:chef_ai_mobile/features/dashboard/widgets/recommended_meal_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealTrackerDashboard extends ConsumerStatefulWidget {
  const MealTrackerDashboard({super.key});

  @override
  ConsumerState<MealTrackerDashboard> createState() => _MealTrackerDashboardState();
}

class _MealTrackerDashboardState extends ConsumerState<MealTrackerDashboard> {
  String selectedTab = 'dinner';

  @override
  Widget build(BuildContext context) {
    // final themeMode = Provider.of<ThemeProvider>(context, listen: true).theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Smart Meals', style: AppTheme.darkTheme.textTheme.headlineSmall),
        ),

        // Recommended meals
        ListView.builder(
          shrinkWrap: true,
          itemCount: 5, // Placeholder data
          itemBuilder: (context, index) {
            return RecommendedMealItem(
              imagePath: 'assets/images/meal_placeholder.png', // Placeholder data
              isVeg: true, // Placeholder data
              title: 'Egg Noodles Maggi Bowl', // Placeholder data
              rating: 4.5, // Placeholder data
              kcal: 380, // Placeholder data
              protein: 12, // Placeholder data
              description: 'A delicious bowl of egg noodles with maggi', // Placeholder data
              ingredientsToBuy: ['Egg Noodles', 'Maggi'], // Placeholder data
            );
          },
        ),
      ],
    );
  }
}
