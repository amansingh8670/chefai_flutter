import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chef_ai_mobile/providers/api_provider.dart';
import 'package:chef_ai_mobile/providers/kitchen_provider.dart';
import 'package:chef_ai_mobile/providers/auth_provider.dart';

class InventoryItem {
  final String id;
  final String name;
  final String quantity;
  final String category;
  final String? expiryDate;
  final String? imageUrl;
  final String source;

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.expiryDate,
    this.imageUrl,
    required this.source,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['stock_id'] ?? '',
      name: json['item_name'] ?? 'Unknown Item',
      quantity: json['quantity'] ?? '1 unit',
      category: json['category'] ?? 'other',
      expiryDate: json['expiry_date'],
      imageUrl: json['image_url'],
      source: json['source'] ?? 'manual',
    );
  }
  
  String get expirationStatus {
    if (expiryDate == null) return 'Fresh';
    
    try {
      final expiry = DateTime.parse(expiryDate!);
      final now = DateTime.now();
      final difference = expiry.difference(now).inDays;
      
      if (difference < 0) return 'Expired';
      if (difference <= 3) return 'Expiring Soon';
      return 'Fresh';
    } catch (e) {
      return 'Fresh';
    }
  }
}

final inventoryProvider = FutureProvider<List<InventoryItem>>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  
  final kitchenId = ref.watch(activeKitchenIdProvider);
  final user = ref.watch(currentUserProvider);
  
  final targetId = kitchenId ?? user?.id;
  if (targetId == null) return [];
  
  try {
    final response = await apiClient.get('/stock/$targetId');
    if (response != null && response is List) {
      return response.map((item) => InventoryItem.fromJson(item)).toList();
    }
  } catch (e) {
    print('Failed to fetch inventory: $e');
  }
  return [];
});
