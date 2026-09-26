import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chef_ai_mobile/providers/auth_provider.dart';
import 'package:chef_ai_mobile/providers/api_provider.dart';
import 'package:chef_ai_mobile/core/network/api_constants.dart';

class UserProfile {
  final String userId;
  final String name;
  final int? height;
  final int? weight;
  final int? age;
  final String activityLevel;
  final String dietaryPreferences;
  final String allergies;
  final String regionalPreferences;
  final int? dailyCalories;
  final int? dailyProtein;
  final int? dailyCarbs;
  final int? dailyFat;
  
  UserProfile({
    required this.userId,
    required this.name,
    this.height,
    this.weight,
    this.age,
    this.activityLevel = 'Moderate',
    this.dietaryPreferences = 'Standard',
    this.allergies = '',
    this.regionalPreferences = '',
    this.dailyCalories,
    this.dailyProtein,
    this.dailyCarbs,
    this.dailyFat,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? 'Chef',
      height: json['height'],
      weight: json['weight'],
      age: json['age'],
      activityLevel: json['activity_level'] ?? 'Moderate',
      dietaryPreferences: json['dietary_preferences'] ?? 'Standard',
      allergies: json['allergies'] ?? '',
      regionalPreferences: json['regional_preferences'] ?? '',
      dailyCalories: json['daily_calories'],
      dailyProtein: json['daily_protein'],
      dailyCarbs: json['daily_carbs'],
      dailyFat: json['daily_fat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'height': height,
      'weight': weight,
      'age': age,
      'activity_level': activityLevel,
      'dietary_preferences': dietaryPreferences,
      'allergies': allergies,
      'regional_preferences': regionalPreferences,
      'daily_calories': dailyCalories,
      'daily_protein': dailyProtein,
      'daily_carbs': dailyCarbs,
      'daily_fat': dailyFat,
    };
  }
}

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final Ref ref;

  UserProfileNotifier(this.ref) : super(const AsyncValue.loading()) {
    refresh();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = const AsyncValue.data(null);
      return;
    }
    
    final apiClient = ref.read(apiClientProvider);
    try {
      final response = await apiClient.get('/users/${user.id}');
      if (response != null) {
        state = AsyncValue.data(UserProfile.fromJson(response));
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> updateProfile(UserProfile newProfile) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return false;

    final apiClient = ref.read(apiClientProvider);
    try {
      final response = await apiClient.put(
        '/users/${user.id}',
        body: newProfile.toJson(),
      );
      if (response != null) {
        state = AsyncValue.data(UserProfile.fromJson(response));
        return true;
      }
    } catch (e) {
      print('Failed to update profile: $e');
    }
    return false;
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  return UserProfileNotifier(ref);
});
