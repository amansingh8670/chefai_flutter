import 'package:chef_ai_mobile/shared/widgets/inputs/checkbox_field.dart';
import 'package:chef_ai_mobile/shared/widgets/inputs/dropdown_field.dart';
import 'package:chef_ai_mobile/shared/widgets/inputs/number_field.dart';
import 'package:chef_ai_mobile/shared/widgets/inputs/text_field.dart';
import 'package:flutter/material.dart';

class ItemDetailsScreen extends StatefulWidget {
  static const routeName = "/item_details";

  const ItemDetailsScreen({super.key});

  @override
  State<ItemDetailsScreen> createState() =>
      _ItemDetailsScreenState();
}

class _ItemDetailsScreenState
    extends State<ItemDetailsScreen> {
  final _itemController = TextEditingController();
  final _expiryController = TextEditingController();
  final _quantityController = TextEditingController();

  String _category = "Dairy & Eggs";
  String _unit = "Pcs";

  bool _isVeg = true;
  bool _recipeAutocomplete = true;

  @override
  void dispose() {
    _itemController.dispose();
    _expiryController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Details"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppTextField(
              label: "Item Name",
              hint: "e.g. Organic Brown Eggs",
              controller: _itemController,
            ),

            const SizedBox(height: 20),

            AppDropdownField<String>(
              label: "Category",
              value: _category,
              onSelected: (value) {
                if (value == null) return;
                setState(() {
                  _category = value;
                });
              },
              entries: const [
                DropdownMenuEntry(
                  value: "Dairy & Eggs",
                  label: "Dairy & Eggs",
                ),
                DropdownMenuEntry(
                  value: "Vegetables",
                  label: "Vegetables",
                ),
                DropdownMenuEntry(
                  value: "Fruits",
                  label: "Fruits",
                ),
                DropdownMenuEntry(
                  value: "Meat",
                  label: "Meat",
                ),
                DropdownMenuEntry(
                  value: "Seafood",
                  label: "Seafood",
                ),
                DropdownMenuEntry(
                  value: "Bakery",
                  label: "Bakery",
                ),
                DropdownMenuEntry(
                  value: "Frozen",
                  label: "Frozen",
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: "Expiry Date",
                    hint: "DD/MM/YYYY",
                    controller: _expiryController,
                    keyboardType: TextInputType.datetime,
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppNumberField(
                    label: "Quantity",
                    controller: _quantityController,
                    hint: "12",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            AppDropdownField<String>(
              label: "Unit",
              value: _unit,
              onSelected: (value) {
                if (value == null) return;
                setState(() {
                  _unit = value;
                });
              },
              entries: const [
                DropdownMenuEntry(
                  value: "Pcs",
                  label: "Pieces",
                ),
                DropdownMenuEntry(
                  value: "Kg",
                  label: "Kilogram",
                ),
                DropdownMenuEntry(
                  value: "g",
                  label: "Gram",
                ),
                DropdownMenuEntry(
                  value: "L",
                  label: "Litre",
                ),
                DropdownMenuEntry(
                  value: "ml",
                  label: "Millilitre",
                ),
                DropdownMenuEntry(
                  value: "Pack",
                  label: "Pack",
                ),
              ],
            ),

            const SizedBox(height: 24),

            AppCheckbox(
              label: "Pure Vegetarian",
              value: _isVeg,
              onChanged: (value) {
                setState(() {
                  _isVeg = value ?? false;
                });
              },
            ),

            const SizedBox(height: 14),

            AppCheckbox(
              label: "Enable AI Recipe Autocomplete",
              value: _recipeAutocomplete,
              onChanged: (value) {
                setState(() {
                  _recipeAutocomplete = value ?? false;
                });
              },
            ),

            const SizedBox(height: 32),

            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.inventory_2_outlined),
                label: const Text(
                  "Add Item to Pantry Queue",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}