import 'package:chef_ai_mobile/features/inventory/widgets/available_item.dart';
import 'package:chef_ai_mobile/features/inventory/widgets/available_item_category.dart';
import 'package:chef_ai_mobile/features/inventory/widgets/inventory_stats.dart';
import 'package:chef_ai_mobile/shared/mock_data/inventory.dart';
import 'package:chef_ai_mobile/shared/models/inventory_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';

class KitchenInventoryScreen extends ConsumerStatefulWidget {
  const KitchenInventoryScreen({super.key});

  @override
  ConsumerState<KitchenInventoryScreen> createState() =>
      _KitchenInventoryScreenState();
}

class _KitchenInventoryScreenState
    extends ConsumerState<KitchenInventoryScreen> {
  int selectedCategoryIndex = 0;
  final ScrollController _categoryController = ScrollController();
  final ScrollController _productController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: AppColors.getBackground(themeMode),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              _header(),

              const SizedBox(height: 10),

              InventoryStats(
                stats: const [
                  InventoryStatItem(
                    title: "TOTAL ITEMS",
                    value: "23",
                    color: Colors.orange,
                  ),
                  InventoryStatItem(
                    title: "EXPIRING",
                    value: "10",
                    color: Colors.green,
                  ),
                  InventoryStatItem(
                    title: "STOCK HEALTH",
                    value: "Needs Refill",
                    color: Colors.blue,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              _search(),

              const SizedBox(height: 8),

              _filters(),

              const SizedBox(height: 10),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 82,
                      child: AvailableItemCategory(
                        controller: _categoryController,
                        categories: InventoryMockData.categories,
                        selectedIndex: selectedCategoryIndex,
                        onCategoryChanged: (index) {
                          setState(() {
                            selectedCategoryIndex = index;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: GridView.builder(
                        controller: _productController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: InventoryMockData.items.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: .70,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemBuilder: (_, index) {
                          final item = InventoryMockData.items[index];

                          return AvailableItemCard(
                            itemName: item.name,
                            imageUrl: item.imageUrl,
                            expirationStatus: item.expirationStatus,
                            quantity: item.quantity,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white10,
          child: const Icon(Icons.arrow_back_ios_new, size: 14),
        ),

        const SizedBox(width: 10),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kitchen Inventory",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              Text(
                "Manage your stock, track expiry and organize your pantry",
                style: TextStyle(fontSize: 8, color: Colors.grey),
              ),
            ],
          ),
        ),

        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text("+ Add Item", style: TextStyle(fontSize: 10)),
        ),
      ],
    );
  }

  Widget _search() {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search pantry...",
          prefixIcon: Icon(Icons.search, size: 15),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 10),
        ),
      ),
    );
  }

  Widget _filters() {
    return Row(
      children: [
        _chip("All Items", true),
        _chip("Expiring Soon", false),
        _chip("Out of Stock", false),
      ],
    );
  }

  Widget _chip(String text, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: selected ? Colors.orange : Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(fontSize: 8)),
    );
  }

  Widget _products() {
    final List<InventoryItem> products = InventoryMockData.items;

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, index) {
        final item = products[index];

        return AvailableItemCard(
          itemName: item.name,
          imageUrl: item.imageUrl,
          expirationStatus: item.expirationStatus,
          quantity: item.quantity,
        );
      },
    );
  }
}
