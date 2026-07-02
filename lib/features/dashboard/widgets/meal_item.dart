import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';

class MealItem extends ConsumerWidget {
  final IconData icon;
  final String name;
  final String time;
  final String kcal;

  const MealItem({
    super.key,
    required this.icon,
    required this.name,
    required this.time,
    required this.kcal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Container(
      height: 34,

      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 3,
      ),

      decoration: BoxDecoration(
        color: AppColors.getCardBg(themeMode),

        borderRadius: BorderRadius.circular(8),

        border: Border.all(
          color: AppColors.getDivider(themeMode),
          width: 0.7,
        ),
      ),

      child: Row(
        children: [
          // =====================================================
          // ICON
          // =====================================================

          Container(
            width: 18,
            height: 18,

            decoration: BoxDecoration(
              color: AppColors.getAccentTeal(
                themeMode,
              ).withValues(alpha: 0.12),

              borderRadius: BorderRadius.circular(5),
            ),

            child: Icon(
              icon,
              size: 9,
              color: AppColors.getAccentTeal(themeMode),
            ),
          ),

          const SizedBox(width: 4),

          // =====================================================
          // TEXT
          // =====================================================

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  name,

                  overflow: TextOverflow.ellipsis,

                  maxLines: 1,

                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: AppColors.getTextPrimary(themeMode),
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  time,

                  overflow: TextOverflow.ellipsis,

                  maxLines: 1,

                  style: TextStyle(
                    fontSize: 5.5,
                    height: 1,
                    fontWeight: FontWeight.w500,
                    color: AppColors.getTextSecondary(
                      themeMode,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 2),

          // =====================================================
          // KCAL
          // =====================================================

          Text(
            kcal,

            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w700,
              color: AppColors.getPrimaryOrange(themeMode),
            ),
          ),
        ],
      ),
    );
  }
}