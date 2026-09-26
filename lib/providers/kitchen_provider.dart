import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chef_ai_mobile/providers/auth_provider.dart';
import 'package:chef_ai_mobile/providers/api_provider.dart';

class Kitchen {
  final String id;
  final String name;
  final String role;
  final String? inviteCode;
  final bool isActive;

  Kitchen({
    required this.id,
    required this.name,
    required this.role,
    this.inviteCode,
    required this.isActive,
  });

  factory Kitchen.fromJson(Map<String, dynamic> json) {
    return Kitchen(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Kitchen',
      role: json['role'] ?? 'member',
      inviteCode: json['invite_code'],
      isActive: json['is_active'] ?? false,
    );
  }
}

// 1. Fetch the list of kitchens for the user
final kitchensProvider = FutureProvider<List<Kitchen>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  
  final apiClient = ref.read(apiClientProvider);
  try {
    final response = await apiClient.get('/kitchens/user/${user.id}');
    if (response != null && response is List) {
      final kitchens = response.map((k) => Kitchen.fromJson(k)).toList();
      
      // Auto-select the first kitchen if one isn't selected yet
      final currentSelected = ref.read(activeKitchenIdProvider);
      if (currentSelected == null && kitchens.isNotEmpty) {
        // We defer state update to avoid modifying providers during build
        Future.microtask(() {
          ref.read(activeKitchenIdProvider.notifier).state = kitchens.first.id;
        });
      }
      
      return kitchens;
    }
  } catch (e) {
    print('Failed to fetch kitchens: $e');
  }
  return [];
});

// 2. StateProvider to hold the currently selected kitchen ID globally
final activeKitchenIdProvider = StateProvider<String?>((ref) => null);

// 3. Helper to get the actual Kitchen object for the active ID
final activeKitchenProvider = Provider<Kitchen?>((ref) {
  final activeId = ref.watch(activeKitchenIdProvider);
  final kitchensAsync = ref.watch(kitchensProvider);
  
  return kitchensAsync.maybeWhen(
    data: (kitchens) {
      try {
        return kitchens.firstWhere((k) => k.id == activeId);
      } catch (e) {
        return kitchens.isNotEmpty ? kitchens.first : null;
      }
    },
    orElse: () => null,
  );
});
