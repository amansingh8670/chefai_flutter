import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chef_ai_mobile/providers/api_provider.dart';
import 'package:chef_ai_mobile/providers/kitchen_provider.dart';

class MealRecommendation {
  final String id;
  final String recipeName;
  final String description;
  final List<String> ingredients;
  final List<String> missingIngredients;
  final int calories;
  final int prepTime; // in minutes
  final String? imageUrl;

  MealRecommendation({
    required this.id,
    required this.recipeName,
    required this.description,
    required this.ingredients,
    required this.missingIngredients,
    required this.calories,
    required this.prepTime,
    this.imageUrl,
  });

  factory MealRecommendation.fromJson(Map<String, dynamic> json) {
    return MealRecommendation(
      id: json['id'] ?? '',
      recipeName: json['recipe_name'] ?? 'Unknown Recipe',
      description: json['description'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      missingIngredients: List<String>.from(json['missing_ingredients'] ?? []),
      calories: json['calories'] ?? 0,
      // Default to some logic if not provided by backend exactly
      prepTime: json['prep_time'] ?? 25, 
      imageUrl: json['image_url'],
    );
  }
}

class DailyRecommendations {
  final MealRecommendation? breakfast;
  final MealRecommendation? lunch;
  final MealRecommendation? snack;
  final MealRecommendation? dinner;

  DailyRecommendations({
    this.breakfast,
    this.lunch,
    this.snack,
    this.dinner,
  });

  factory DailyRecommendations.fromJson(Map<String, dynamic> json) {
    final mealsJson = json['meals'] != null ? (json['meals'] as Map<String, dynamic>) : json;
    return DailyRecommendations(
      breakfast: mealsJson['breakfast'] != null ? MealRecommendation.fromJson(mealsJson['breakfast']) : null,
      lunch: mealsJson['lunch'] != null ? MealRecommendation.fromJson(mealsJson['lunch']) : null,
      snack: mealsJson['snack'] != null ? MealRecommendation.fromJson(mealsJson['snack']) : null,
      dinner: mealsJson['dinner'] != null ? MealRecommendation.fromJson(mealsJson['dinner']) : null,
    );
  }
}

final recommendationsProvider = FutureProvider<DailyRecommendations?>((ref) async {
  final kitchenId = ref.watch(activeKitchenIdProvider);
  if (kitchenId == null) return null;
  
  final apiClient = ref.read(apiClientProvider);
  try {
    final response = await apiClient.get('/kitchens/$kitchenId/recommendation?all_meals=true');
    print('RAW API RESPONSE: $response');
    if (response != null && response is Map<String, dynamic>) {
      return DailyRecommendations.fromJson(response);
    }
  } catch (e) {
    print('Failed to fetch recommendations: $e');
  }
  return null;
});
