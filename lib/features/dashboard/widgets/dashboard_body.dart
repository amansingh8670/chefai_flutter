import 'package:flutter/material.dart';

import 'pantry_tracker_section.dart';
import 'meal_tracker_section.dart';
import 'meal_recommendation_section.dart';

import '../../../shared/widgets/content_card.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Column(
        children: [
          // =====================================================
          // PANTRY TRACKER
          // =====================================================

          Expanded(
            flex: 12,

            child: SizedBox(
              width: double.infinity,

              child: const ContentCard(
                child: PantryTrackerSection(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // =====================================================
          // MEAL TRACKER
          // =====================================================

          Expanded(
            flex: 32,

            child: SizedBox(
              width: double.infinity,

              child: const ContentCard(
                child: MealTrackerSection(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // =====================================================
          // MEAL RECOMMENDATION
          // =====================================================

          Expanded(
            flex: 56,

            child: SizedBox(
              width: double.infinity,

              child: const ContentCard(
                child: MealRecommendationSection(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}