import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chef_ai_mobile/providers/auth_provider.dart';
import 'package:chef_ai_mobile/providers/api_provider.dart';

class MealLog {
  final String id;
  final String name;
  final int calories;
  final DateTime createdAt;

  MealLog({
    required this.id,
    required this.name,
    required this.calories,
    required this.createdAt,
  });

  factory MealLog.fromJson(Map<String, dynamic> json) {
    return MealLog(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Meal',
      calories: json['calories'] ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }
}

final mealsProvider = FutureProvider<List<MealLog>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  
  final apiClient = ref.read(apiClientProvider);
  try {
    final response = await apiClient.get('/meals/${user.id}');
    if (response != null && response is List) {
      return response.map((m) => MealLog.fromJson(m)).toList();
    }
  } catch (e) {
    print('Failed to fetch meals: $e');
  }
  return [];
});

final todaysCaloriesProvider = Provider<int>((ref) {
  final mealsAsync = ref.watch(mealsProvider);
  
  return mealsAsync.maybeWhen(
    data: (meals) {
      final now = DateTime.now();
      int total = 0;
      for (var meal in meals) {
        // Convert to local just in case, check if it's the same day
        final localDate = meal.createdAt.toLocal();
        if (localDate.year == now.year && localDate.month == now.month && localDate.day == now.day) {
          total += meal.calories;
        }
      }
      return total;
    },
    orElse: () => 0,
  );
});
