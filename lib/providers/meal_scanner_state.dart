import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetectedMealItem {
  final String id;
  final String name;
  final String category; // e.g., DINNER
  final int calories;
  final int carbs;
  final int protein;
  final int fat;
  final List<String> tags;
  final int quantity;

  DetectedMealItem({
    required this.id,
    required this.name,
    required this.category,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.tags,
    this.quantity = 1,
  });

  DetectedMealItem copyWith({
    String? id,
    String? name,
    String? category,
    int? calories,
    int? carbs,
    int? protein,
    int? fat,
    List<String>? tags,
    int? quantity,
  }) {
    return DetectedMealItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      tags: tags ?? this.tags,
      quantity: quantity ?? this.quantity,
    );
  }
}

class MealScannerQueueNotifier extends StateNotifier<List<DetectedMealItem>> {
  MealScannerQueueNotifier() : super([]);

  void addItem(DetectedMealItem item) {
    state = [...state, item];
  }

  void updateQuantity(String id, int delta) {
    state = state.map((item) {
      if (item.id == id) {
        final newQty = item.quantity + delta;
        return item.copyWith(quantity: newQty > 0 ? newQty : 1);
      }
      return item;
    }).toList();
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void clear() {
    state = [];
  }
}

final mealScannerQueueProvider = StateNotifierProvider<MealScannerQueueNotifier, List<DetectedMealItem>>((ref) {
  return MealScannerQueueNotifier();
});
