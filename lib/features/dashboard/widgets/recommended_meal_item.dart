import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';

class RecommendedMealItem extends ConsumerWidget {
  final String imagePath;
  final bool isVeg;
  final String title;
  final double rating;
  final int kcal;
  final int protein;
  final String description;
  final List<String> ingredientsToBuy;
  final VoidCallback? onRecipeTap;

  const RecommendedMealItem({
    super.key,
    required this.imagePath,
    required this.isVeg,
    required this.title,
    required this.rating,
    required this.kcal,
    required this.protein,
    required this.description,
    required this.ingredientsToBuy,
    this.onRecipeTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primaryOrange.withValues(alpha: 0.25),
          width: 0.6,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.getSurface(themeMode),
            AppColors.getCardBg(themeMode),
          ],
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // =====================================================
          // TOP SECTION
          // =====================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =====================================================
              // SMALL PLACEHOLDER IMAGE
              // =====================================================

              Container(
                width: 54,
                height: 54,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.getSurface(themeMode),
                  border: Border.all(
                    color: AppColors.getDivider(themeMode),
                    width: 0.5,
                  ),
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),

                  child: Image.network(
                    "https://placehold.co/120x120/png?text=Meal",
                    fit: BoxFit.cover,

                    errorBuilder:
                        (context, error, stackTrace) {
                      return Icon(
                        Icons.restaurant_menu_rounded,
                        size: 24,
                        color:
                            AppColors.primaryOrange,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // =====================================================
              // CONTENT
              // =====================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // VEG TAG

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 9,
                          height: 9,

                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isVeg
                                  ? Colors.green
                                  : Colors.red,
                              width: 1,
                            ),
                          ),

                          child: Center(
                            child: Container(
                              width: 4,
                              height: 4,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isVeg
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 4),

                        Flexible(
                          child: Text(
                            isVeg
                                ? "PURE VEG"
                                : "NON VEG",

                            overflow:
                                TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 6.5,
                              fontWeight:
                                  FontWeight.w800,
                              letterSpacing: 0.15,
                              color: isVeg
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // TITLE

                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 9,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        color: AppColors.getTextPrimary(
                          themeMode,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // META

                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children: [
                        Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 10,
                              color: Colors.amber,
                            ),

                            const SizedBox(width: 2),

                            Text(
                              rating.toString(),
                              style: TextStyle(
                                fontSize: 7,
                                fontWeight:
                                    FontWeight.w700,
                                color:
                                    AppColors.getTextPrimary(
                                  themeMode,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Text(
                          "$kcal kcal",
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight:
                                FontWeight.w600,
                            color:
                                AppColors.getTextSecondary(
                              themeMode,
                            ),
                          ),
                        ),

                        Text(
                          "${protein}g pro",
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight:
                                FontWeight.w600,
                            color:
                                AppColors.getTextSecondary(
                              themeMode,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    GestureDetector(
                      onTap: onRecipeTap,

                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              "Get Recipe",
                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style: TextStyle(
                                fontSize: 8,
                                fontWeight:
                                    FontWeight.w800,
                                color:
                                    AppColors
                                        .primaryOrange,
                              ),
                            ),
                          ),

                          const SizedBox(width: 2),

                          Icon(
                            Icons
                                .arrow_forward_rounded,
                            size: 11,
                            color:
                                AppColors
                                    .primaryOrange,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // =====================================================
              // MENU ICON
              // =====================================================

              const SizedBox(width: 4),

              Icon(
                Icons.more_vert_rounded,
                size: 14,
                color: AppColors.getTextSecondary(
                  themeMode,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =====================================================
          // DESCRIPTION
          // =====================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: AppColors.getSurface(themeMode),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.getDivider(themeMode),
                width: 0.5,
              ),
            ),

            child: Text(
              description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                fontSize: 8,
                height: 1.4,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                color: AppColors.getTextSecondary(
                  themeMode,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // =====================================================
          // BUY SECTION
          // =====================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),

              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.getAccentTeal(themeMode)
                      .withValues(alpha: 0.10),

                  AppColors.getAccentTeal(themeMode)
                      .withValues(alpha: 0.04),
                ],
              ),

              border: Border.all(
                color: AppColors.getAccentTeal(
                  themeMode,
                ).withValues(alpha: 0.16),
              ),
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 12,
                      color:
                          AppColors.getAccentTeal(
                        themeMode,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        "YOU NEED TO BUY:",
                        overflow:
                            TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 8,
                          fontWeight:
                              FontWeight.w800,
                          letterSpacing: 0.2,
                          color:
                              AppColors.getAccentTeal(
                            themeMode,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 6,
                  runSpacing: 6,

                  children: ingredientsToBuy.map(
                    (ingredient) {
                      return ConstrainedBox(
                        constraints:
                            const BoxConstraints(
                          maxWidth: 95,
                        ),

                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color:
                                AppColors.getSurface(
                              themeMode,
                            ),

                            borderRadius:
                                BorderRadius.circular(
                              999,
                            ),

                            border: Border.all(
                              color:
                                  AppColors.getDivider(
                                themeMode,
                              ),
                              width: 0.5,
                            ),
                          ),

                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  ingredient,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,

                                  style: TextStyle(
                                    fontSize: 7,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                    color: AppColors
                                        .getTextPrimary(
                                      themeMode,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 3),

                              Icon(
                                Icons.add,
                                size: 10,
                                color: AppColors
                                    .primaryOrange,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}