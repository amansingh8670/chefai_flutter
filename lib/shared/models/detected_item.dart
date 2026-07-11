class DetectedItem {
  final String id;
  final String imagePath;

  final String name;
  final String itemType;

  final int calories;
  final int carbs;
  final int protein;
  final int fat;

  final int quantity;
  final String quantityUnit;

  const DetectedItem({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.itemType,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.quantity,
    required this.quantityUnit,
  });

  DetectedItem copyWith({
    String? id,
    String? imagePath,
    String? name,
    String? itemType,
    int? calories,
    int? carbs,
    int? protein,
    int? fat,
    int? quantity,
    String? quantityUnit,
  }) {
    return DetectedItem(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      itemType: itemType ?? this.itemType,
      calories: calories ?? this.calories,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      quantity: quantity ?? this.quantity,
      quantityUnit: quantityUnit ?? this.quantityUnit,
    );
  }
}