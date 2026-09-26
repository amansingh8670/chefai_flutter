import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/features/checkout/pages/smart_cart.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';
import 'package:chef_ai_mobile/shared/models/detected_meal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeDetailPage extends ConsumerStatefulWidget {
  final DetectedMeal meal;

  const RecipeDetailPage({super.key, required this.meal});

  @override
  ConsumerState<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends ConsumerState<RecipeDetailPage> {
  int _selectedTabIndex = 0; // 0 for Ingredients, 1 for Instructions

  final List<String> mockInstructions = [
    "Season the salmon fillets with salt, pepper, and a drizzle of olive oil.",
    "Preheat the grill or a grill pan over medium-high heat.",
    "Place the salmon skin-side down and cook for 4-5 minutes until the skin is crispy.",
    "Carefully flip and cook for another 3-4 minutes until cooked through.",
    "Serve immediately with a squeeze of fresh lemon juice."
  ];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.getBackground(themeMode),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: size.height * 0.35,
                pinned: true,
                backgroundColor: AppColors.getBackground(themeMode),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity( 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeaderImage(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE
                      Text(
                        widget.meal.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.getTextPrimary(themeMode),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // MACROS / TAGS
                      Row(
                        children: [
                          _buildTag(Icons.local_fire_department, "${widget.meal.calories} kcal", themeMode),
                          const SizedBox(width: 8),
                          _buildTag(Icons.timer, "25m", themeMode),
                          const SizedBox(width: 8),
                          _buildTag(Icons.restaurant_menu, "Easy", themeMode),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // TABS
                      Row(
                        children: [
                          _buildTabButton("Ingredients", 0, themeMode),
                          const SizedBox(width: 16),
                          _buildTabButton("Instructions", 1, themeMode),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // CONTENT
                      _selectedTabIndex == 0
                          ? _buildIngredientsList(themeMode)
                          : _buildInstructionsList(themeMode),
                      
                      const SizedBox(height: 100), // padding for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // BOTTOM ACTION BAR
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.getSurface(themeMode),
                border: Border(
                  top: BorderSide(
                    color: AppColors.getDivider(themeMode),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity( 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SmartCartScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.add_shopping_cart, color: AppColors.primaryOrange, size: 18),
                      label: Text(
                        "Add Missing",
                        style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryOrange),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Start cooking logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Start Cooking",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          widget.meal.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[800],
              child: const Center(
                child: Icon(Icons.restaurant, size: 60, color: Colors.white54),
              ),
            );
          },
        ),
        // Gradient overlay for better text visibility if needed
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity( 0.3),
                Colors.transparent,
                Colors.black.withOpacity( 0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(IconData icon, String label, ThemeMode themeMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.getSurface(themeMode),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.getDivider(themeMode)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryOrange),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextPrimary(themeMode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index, ThemeMode themeMode) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primaryOrange : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected 
                ? AppColors.getTextPrimary(themeMode) 
                : AppColors.getTextSecondary(themeMode),
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientsList(ThemeMode themeMode) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.meal.ingredients.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final ingredient = widget.meal.ingredients[index];
        return Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.getSurface(themeMode),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.eco, size: 20, color: AppColors.primaryOrange),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                ingredient,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.getTextPrimary(themeMode),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInstructionsList(ThemeMode themeMode) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: mockInstructions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  mockInstructions[index],
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppColors.getTextSecondary(themeMode),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
