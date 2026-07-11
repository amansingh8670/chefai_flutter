import 'package:chef_ai_mobile/shared/widgets/inputs/dropdown_field.dart';
import 'package:chef_ai_mobile/shared/widgets/inputs/number_field.dart';
import 'package:chef_ai_mobile/shared/widgets/inputs/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealDetailForm extends ConsumerStatefulWidget {
  const MealDetailForm({super.key});

  @override
  ConsumerState<MealDetailForm> createState() => _MealDetailFormState();
}

class _MealDetailFormState extends ConsumerState<MealDetailForm> {
  final _mealNameController = TextEditingController();
  final _caloriesController = TextEditingController(text: "450");
  final _proteinController = TextEditingController(text: "22");
  final _carbsController = TextEditingController(text: "48");
  final _fatController = TextEditingController(text: "14");
  final _ingredientController = TextEditingController();

  String mealType = "Lunch";
  String mealSource = "Home Cooked";

  @override
  void dispose() {
    _mealNameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Details"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppTextField(
              label: "Meal Name",
              hint: "e.g. Chicken Biryani Platter",
              controller: _mealNameController,
              prefixIcon: const Icon(Icons.restaurant_menu_rounded),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppDropdownField<String>(
                    label: "Meal Type",
                    value: mealType,
                    entries: const [
                      DropdownMenuEntry(
                        value: "Breakfast",
                        label: "Breakfast",
                      ),
                      DropdownMenuEntry(
                        value: "Lunch",
                        label: "Lunch",
                      ),
                      DropdownMenuEntry(
                        value: "Dinner",
                        label: "Dinner",
                      ),
                      DropdownMenuEntry(
                        value: "Snack",
                        label: "Snack",
                      ),
                    ],
                    onSelected: (value) {
                      if (value != null) {
                        setState(() {
                          mealType = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppDropdownField<String>(
                    label: "Source",
                    value: mealSource,
                    entries: const [
                      DropdownMenuEntry(
                        value: "Home Cooked",
                        label: "Home Cooked",
                      ),
                      DropdownMenuEntry(
                        value: "Takeaway",
                        label: "Takeaway",
                      ),
                      DropdownMenuEntry(
                        value: "Delivery",
                        label: "Delivery",
                      ),
                      DropdownMenuEntry(
                        value: "Restaurant",
                        label: "Restaurant",
                      ),
                    ],
                    onSelected: (value) {
                      if (value != null) {
                        setState(() {
                          mealSource = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppNumberField(
                    label: "Calories (KCAL)",
                    controller: _caloriesController,
                    prefixIcon: const Icon(Icons.local_fire_department_outlined),
                    hint: "500",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppNumberField(
                    label: "Protein (G)",
                    controller: _proteinController,
                    prefixIcon: const Icon(Icons.fitness_center_outlined),
                    hint: "20",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: AppNumberField(
                    label: "Carbohydrates (G)",
                    controller: _carbsController,
                    prefixIcon: const Icon(Icons.grain_outlined),
                    hint: "40",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppNumberField(
                    label: "Fat (G)",
                    controller: _fatController,
                    prefixIcon: const Icon(Icons.opacity_outlined),
                    hint: "10g",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.auto_fix_high),
              label: const Text("Auto Calculate Nutrition"),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: "Ingredient",
              hint: "e.g. Basmati Rice",
              controller: _ingredientController,
              prefixIcon: const Icon(Icons.shopping_basket_outlined),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("Add Ingredient"),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text("Add Meal to Scan Queue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}