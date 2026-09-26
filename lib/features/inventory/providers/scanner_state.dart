import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chef_ai_mobile/providers/inventory_provider.dart';

class DetectedItem {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final String unit;

  DetectedItem({
    required this.id,
    required this.name,
    required this.category,
    this.quantity = 1,
    this.unit = 'Pcs',
  });

  DetectedItem copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    String? unit,
  }) {
    return DetectedItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}

class ScannerStateNotifier extends StateNotifier<List<DetectedItem>> {
  ScannerStateNotifier() : super([]);

  void addItem(String name, {String category = 'other', int quantity = 1, String unit = 'Pcs'}) {
    final newItem = DetectedItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      quantity: quantity,
      unit: unit,
    );
    state = [...state, newItem];
  }

  void updateQuantity(String id, int newQuantity) {
    if (newQuantity < 1) return;
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(quantity: newQuantity);
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

final scannerQueueProvider = StateNotifierProvider<ScannerStateNotifier, List<DetectedItem>>((ref) {
  return ScannerStateNotifier();
});
