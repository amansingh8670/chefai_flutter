import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/features/meal_tracker/pages/recipe_detail_page.dart';
import 'package:chef_ai_mobile/shared/mock_data/meals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';
import 'package:chef_ai_mobile/providers/meals_provider.dart';
import 'package:chef_ai_mobile/providers/user_provider.dart';
import 'package:chef_ai_mobile/providers/recommendation_provider.dart';
import 'package:chef_ai_mobile/features/meal_tracker/pages/log_meal.dart';

class MealTrackerDashboard extends ConsumerStatefulWidget {
  const MealTrackerDashboard({super.key});

  @override
  ConsumerState<MealTrackerDashboard> createState() => _MealTrackerDashboardState();
}

class _MealTrackerDashboardState extends ConsumerState<MealTrackerDashboard> {
  String selectedFilter = 'All Meals';
  final List<String> _filters = ['Today', 'All Meals', 'Veg Only', 'High Protein \u{1F4AA}'];
  
  List<Map<String, dynamic>> _generateDays() {
    final now = DateTime.now();
    final todayStr = now.day.toString();
    
    return List.generate(7, (index) {
      final d = now.subtract(Duration(days: 3 - index));
      final dayName = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][d.weekday - 1];
      final isToday = index == 3; // Center element is today
      return {
        'day': dayName,
        'date': d.day.toString(),
        'active': isToday,
        'dot': null,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final mealsAsync = ref.watch(mealsProvider);
    final userProfileAsync = ref.watch(userProfileProvider);
    
    final consumed = ref.watch(todaysCaloriesProvider).toDouble();
    final totalRaw = userProfileAsync.value?.dailyCalories?.toDouble() ?? 2000.0;
    final total = totalRaw > 0 ? totalRaw : 2000.0; // avoid div by 0 and NaN
    final remaining = (total - consumed).toInt();
    final progress = (consumed / total).clamp(0.0, 1.0);

    // Use app colors gracefully for both themes, leaning on the nice surface backgrounds
    final bgColor = AppColors.getBackground(themeMode);
    final surfaceColor = AppColors.getSurface(themeMode);
    final textColor = AppColors.getTextPrimary(themeMode);
    final textSecColor = AppColors.getTextSecondary(themeMode);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // HEADER
              // ==========================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_back_ios_new, size: 16, color: textColor),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Smart Meals',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LogMealScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryOrange.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text('Log Meal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ==========================================
              // CALENDAR STRIP
              // ==========================================
              SizedBox(
                height: 70,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _generateDays().length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final day = _generateDays()[index];
                    final isActive = day['active'] as bool;
                    
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 42,
                          height: 52,
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.primaryOrange : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isActive ? [
                              BoxShadow(color: AppColors.primaryOrange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                            ] : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                day['day'],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isActive ? Colors.white : textSecColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                day['date'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isActive ? Colors.white : textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (day['dot'] != null)
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: day['dot'] as Color,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          const SizedBox(height: 4),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ==========================================
              // MACROS CARD
              // ==========================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.getDivider(themeMode)),
                  ),
                  child: Row(
                    children: [
                      // Circular chart
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 6,
                              color: AppColors.primaryOrange,
                              backgroundColor: AppColors.getDivider(themeMode),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  remaining > 0 ? remaining.toString() : '0',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  'kcal left',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: textSecColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      
                      // Progress bars
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMacroBar('CARBS', '0', '120', 0.0, textColor, textSecColor, themeMode),
                            const SizedBox(height: 12),
                            _buildMacroBar('PROTEIN', '0', '70', 0.0, textColor, textSecColor, themeMode),
                            const SizedBox(height: 12),
                            _buildMacroBar('FAT', '0', '55', 0.0, textColor, textSecColor, themeMode),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ==========================================
              // FILTER CHIPS
              // ==========================================
              SizedBox(
                height: 36,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = selectedFilter == filter;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.transparent : surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryOrange : AppColors.getDivider(themeMode),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            filter,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? AppColors.primaryOrange : textSecColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ==========================================
              // TOP PICKS
              // ==========================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('TOP PICKS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textColor)),
              ),
              const SizedBox(height: 12),
              
              SizedBox(
                height: 180,
                child: mealsAsync.when(
                  data: (meals) {
                    if (meals.isEmpty) {
                      return Center(child: Text('No top picks yet', style: TextStyle(color: textSecColor, fontSize: 12)));
                    }
                    
                    // Count frequency of each meal by name
                    final mealCounts = <String, int>{};
                    final mealMap = <String, MealLog>{}; // to keep a reference to the meal object
                    
                    for (var meal in meals) {
                      mealCounts[meal.name] = (mealCounts[meal.name] ?? 0) + 1;
                      if (!mealMap.containsKey(meal.name)) {
                        mealMap[meal.name] = meal;
                      }
                    }
                    
                    // Sort by frequency descending
                    final sortedNames = mealCounts.keys.toList()
                      ..sort((a, b) => mealCounts[b]!.compareTo(mealCounts[a]!));
                      
                    final topMeals = sortedNames.take(5).map((name) => mealMap[name]!).toList();
                    
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: topMeals.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final meal = topMeals[index];
                        // Using a placeholder image and price since MealLog doesn't have them
                        return _buildTopPickCard(
                          meal.name, 
                          '150', // Mock price for UI consistency
                          meal.calories.toString(), 
                          'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800', 
                          true
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.primaryOrange, fontSize: 12))),
                ),
              ),

              const SizedBox(height: 24),

              // ==========================================
              // RECENT
              // ==========================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('RECENT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textColor)),
              ),
              const SizedBox(height: 12),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: mealsAsync.when(
                  data: (meals) {
                    if (meals.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No meals logged yet', 
                          style: TextStyle(color: textSecColor, fontSize: 12),
                        ),
                      );
                    }
                    
                    // Show up to 5 recent meals
                    final recentMeals = meals.take(5).toList();
                    
                    return Column(
                      children: recentMeals.map((meal) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildRecentCard(
                            meal.name,
                            meal.calories.toString(),
                            '5', // Prep time placeholder
                            ['Ingredients from logs'], // Ingredients placeholder
                            'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800',
                            surfaceColor, textColor, textSecColor, themeMode
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, _) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Error loading meals', 
                      style: TextStyle(color: AppColors.primaryOrange, fontSize: 12),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroBar(String label, String current, String total, double progress, Color textColor, Color textSecColor, ThemeMode themeMode) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: textColor)),
            Row(
              children: [
                Text(current, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: textColor)),
                Text('/$total', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: textSecColor)),
              ],
            )
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.getDivider(themeMode),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            children: [
              Container(
                width: 0, // 0 for now since current is 0
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTopPickCard(String title, String price, String kcal, String imageUrl, bool isVeg) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Gradient for text visibility
          Positioned(
            bottom: 0, left: 0, right: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                ),
              ),
            ),
          ),
          // ADD button
          Positioned(
            top: 10, right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('ADD', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w900, fontSize: 10)),
            ),
          ),
          // Text content
          Positioned(
            bottom: 12, left: 12, right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹$price / $kcal kcal',
                  style: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.w700, fontSize: 10),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRecentCard(String title, String kcal, String protein, List<String> tags, String imageUrl, Color surfaceColor, Color textColor, Color textSecColor, ThemeMode themeMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.getDivider(themeMode)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
          
          // Details
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags row
                Row(
                  children: [
                    Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 1.5),
                        borderRadius: BorderRadius.circular(2)
                      ),
                      child: Center(
                        child: Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.primaryOrange.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                      child: const Text('TOP PICKS', style: TextStyle(color: AppColors.primaryOrange, fontSize: 7, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.teal.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                      child: const Text('OFFER', style: TextStyle(color: Colors.teal, fontSize: 7, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                
                // Title
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor)),
                
                const SizedBox(height: 4),
                
                // Macros
                Row(
                  children: [
                    Text('$kcal kcal', style: const TextStyle(color: AppColors.primaryOrange, fontSize: 10, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 8),
                    Text('${protein}g Protein', style: const TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.w800)),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Ingredient Pills
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: tags.map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.getDivider(themeMode).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: Text(t, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: textColor)),
                  )).toList(),
                )
              ],
            ),
          ),
          
          // Edit Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('EDIT', style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.w900, fontSize: 10)),
          ),
        ],
      ),
    );
  }
}
