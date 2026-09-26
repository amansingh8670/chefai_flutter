import 'package:flutter/material.dart';

import 'pantry_tracker_section.dart';
import 'meal_tracker_section.dart';
import 'meal_recommendation_section.dart';
import 'package:chef_ai_mobile/features/inventory/pages/kitchen.dart';
import 'package:chef_ai_mobile/features/meal_tracker/pages/dashboard.dart';

import '../../../shared/widgets/content_card.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: [
                // =====================================================
                // PANTRY TRACKER
                // =====================================================
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const KitchenInventoryScreen()),
                    );
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    child: ContentCard(
                      child: PantryTrackerSection(),
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),

                // =====================================================
                // MEAL TRACKER
                // =====================================================
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MealTrackerDashboard()),
                    );
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    child: ContentCard(
                      child: MealTrackerSection(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // =====================================================
                // MEAL RECOMMENDATION
                // =====================================================
                const SizedBox(
                  width: double.infinity,
                  child: ContentCard(
                    child: MealRecommendationSection(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}