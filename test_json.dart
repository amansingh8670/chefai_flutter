import 'dart:convert';

class MealRecommendation {
  final String id;
  final String recipeName;
  final String description;
  final List<String> ingredients;
  final List<String> missingIngredients;
  final int calories;
  final int prepTime;

  MealRecommendation({
    required this.id,
    required this.recipeName,
    required this.description,
    required this.ingredients,
    required this.missingIngredients,
    required this.calories,
    required this.prepTime,
  });

  factory MealRecommendation.fromJson(Map<String, dynamic> json) {
    return MealRecommendation(
      id: json['id'] ?? '',
      recipeName: json['recipe_name'] ?? 'Unknown Recipe',
      description: json['description'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      missingIngredients: List<String>.from(json['missing_ingredients'] ?? []),
      calories: json['calories'] ?? 0,
      prepTime: json['prep_time'] ?? 25, 
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
    return DailyRecommendations(
      breakfast: json['breakfast'] != null ? MealRecommendation.fromJson(json['breakfast']) : null,
      lunch: json['lunch'] != null ? MealRecommendation.fromJson(json['lunch']) : null,
      snack: json['snack'] != null ? MealRecommendation.fromJson(json['snack']) : null,
      dinner: json['dinner'] != null ? MealRecommendation.fromJson(json['dinner']) : null,
    );
  }
}

void main() {
  String jsonString = '''
  {
    "breakfast": {
      "id": "123",
      "recipe_name": "Test Recipe",
      "description": "Test Description",
      "ingredients": ["Egg"],
      "missing_ingredients": [],
      "nutrition": {"calories": "Varies"}
    }
  }
  ''';
  
  try {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    var recs = DailyRecommendations.fromJson(jsonMap);
    print('Parsed successfully: \${recs.breakfast?.recipeName}');
    print('Calories: \${recs.breakfast?.calories}');
  } catch (e, stack) {
    print('Error: \$e');
    print(stack);
  }
}
