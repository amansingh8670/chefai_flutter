import 'package:flutter/material.dart';
import 'package:chef_ai_mobile/shared/models/inventory_category.dart';

class AvailableItemCategory extends StatelessWidget {
  final List<InventoryCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategoryChanged;
  final ScrollController? controller;

  const AvailableItemCategory({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategoryChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14171C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(.05),
        ),
      ),
      child: Scrollbar(
        controller: controller,
        thumbVisibility: false,
        child: ListView.builder(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 6,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => onCategoryChanged(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    height: 82,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1F242D)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white.withOpacity(.06)
                            : Colors.transparent,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(.28),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 220),
                          width: 4,
                          margin: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFF8A24)
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(100),
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 6,
                            ),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                AnimatedScale(
                                  duration:
                                      const Duration(
                                    milliseconds: 220,
                                  ),
                                  scale:
                                      isSelected ? 1.08 : 1,
                                  child: Text(
                                    category.icon,
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                AnimatedDefaultTextStyle(
                                  duration:
                                      const Duration(
                                    milliseconds: 220,
                                  ),
                                  style: TextStyle(
                                    fontSize: 9,
                                    height: 1.2,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white60,
                                  ),
                                  child: Text(
                                    category.name,
                                    textAlign:
                                        TextAlign.center,
                                    maxLines: 2,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}