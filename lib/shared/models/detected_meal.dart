class DetectedMeal {
  final String id;
  final String imagePath;

  final String name;
  final String mealType;

  final int calories;
  final int carbs;
  final int protein;
  final int fat;

  final int quantity;
  final String quantityUnit;

  final List<String> ingredients;

  final bool isHomeCooked;
  final double confidence;

  const DetectedMeal({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.mealType,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.quantity,
    required this.quantityUnit,
    required this.ingredients,
    this.isHomeCooked = false,
    this.confidence = 1.0,
  });

  DetectedMeal copyWith({
    String? id,
    String? imagePath,
    String? name,
    String? mealType,
    int? calories,
    int? carbs,
    int? protein,
    int? fat,
    int? quantity,
    String? quantityUnit,
    List<String>? ingredients,
    bool? isHomeCooked,
    double? confidence,
  }) {
    return DetectedMeal(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      mealType: mealType ?? this.mealType,
      calories: calories ?? this.calories,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      quantity: quantity ?? this.quantity,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      ingredients: ingredients ?? this.ingredients,
      isHomeCooked: isHomeCooked ?? this.isHomeCooked,
      confidence: confidence ?? this.confidence,
    );
  }
}