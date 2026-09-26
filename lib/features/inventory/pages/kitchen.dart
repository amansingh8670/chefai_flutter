import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/features/inventory/widgets/available_item.dart';
import 'package:chef_ai_mobile/features/inventory/widgets/available_item_category.dart';
import 'package:chef_ai_mobile/features/inventory/widgets/inventory_stats.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';
import 'package:chef_ai_mobile/providers/inventory_provider.dart';
import 'package:chef_ai_mobile/shared/mock_data/inventory.dart';
import 'package:chef_ai_mobile/shared/widgets/inputs/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pantry_scanner.dart';

class KitchenInventoryScreen extends ConsumerStatefulWidget {
  const KitchenInventoryScreen({super.key});

  @override
  ConsumerState<KitchenInventoryScreen> createState() =>
      _KitchenInventoryScreenState();
}

class _KitchenInventoryScreenState
    extends ConsumerState<KitchenInventoryScreen> {
  int selectedCategoryIndex = 0;

  final _controller = TextEditingController();
  final ScrollController _categoryController = ScrollController();
  final ScrollController _productController = ScrollController();

  @override
  void dispose() {
    _categoryController.dispose();
    _productController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final inventoryAsync = ref.watch(inventoryProvider);

    return Scaffold(
      backgroundColor: AppColors.getBackground(themeMode),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              _header(themeMode),
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
              _filters(themeMode),
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
                      child: inventoryAsync.when(
                        data: (items) {
                          if (items.isEmpty) {
                            return const Center(
                              child: Text('No items in pantry.'),
                            );
                          }
                          return GridView.builder(
                            controller: _productController,
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            padding: const EdgeInsets.only(bottom: 24),
                            itemCount: items.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.68,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemBuilder: (context, index) {
                              final item = items[index];

                              return AvailableItemCard(
                                itemName: item.name,
                                imageUrl: item.imageUrl ?? 'https://via.placeholder.com/150',
                                expirationStatus: item.expirationStatus,
                                quantity: item.quantity,
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (error, _) => Center(
                          child: Text('Error: $error'),
                        ),
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

  Widget _header(ThemeMode themeMode) {
    final surfaceColor = AppColors.getSurface(themeMode);
    final textColor = AppColors.getTextPrimary(themeMode);
    final textSecColor = AppColors.getTextSecondary(themeMode);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: surfaceColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back_ios_new, size: 16, color: textColor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kitchen Inventory",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor),
                ),
                Text(
                  "Manage your stock, track expiry and organize your pantry",
                  style: TextStyle(fontSize: 9, color: textSecColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PantryScannerScreen()),
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
                  Text('Add Item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _search() {
    return AppTextField(
      label: "Search",
      hint: "Search pantry...",
        controller: _controller,
        textCapitalization: TextCapitalization.none,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        prefixIcon: const Icon(Icons.search, size: 18),
        onSubmitted: (value) {
          // TODO: Perform search
        },
        onChanged: (value) {
          // Optional live search
        },
      );
  }

  Widget _filters(ThemeMode themeMode) {
    return Row(
      children: [
        _chip("All Items", true, themeMode),
        _chip("Expiring Soon", false, themeMode),
        _chip("Out of Stock", false, themeMode),
      ],
    );
  }

  Widget _chip(String text, bool selected, ThemeMode themeMode) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.transparent : AppColors.getSurface(themeMode),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.primaryOrange : AppColors.getDivider(themeMode),
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Text(
        text, 
        style: TextStyle(
          fontSize: 10, 
          fontWeight: FontWeight.w700,
          color: selected ? AppColors.primaryOrange : AppColors.getTextSecondary(themeMode)
        )
      ),
    );
  }
}
