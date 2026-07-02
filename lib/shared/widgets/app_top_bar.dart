import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/theme_provider.dart';

class AppTopBar extends ConsumerWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final isDarkMode = currentTheme == ThemeMode.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      color: AppColors.getBackground(currentTheme),

      child: Row(
        children: [
          // =====================================================
          // LEFT SECTION
          // =====================================================

          Icon(
            Icons.location_on,
            color: AppColors.getAccentOrange(currentTheme),
            size: 18,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LOCATION ALIAS
                Text(
                  "Home",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.getTextPrimary(currentTheme),
                  ),
                ),

                const SizedBox(height: 1),

                // FULL ADDRESS
                Text(
                  "123, Whitefield Main Road, Bangalore",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,

                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.getTextSecondary(currentTheme),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // =====================================================
          // RIGHT SECTION
          // =====================================================

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // THEME TOGGLE
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,

                onPressed: () {
                  ref.read(themeProvider.notifier).toggleTheme();
                },

                icon: Icon(
                  isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,

                  size: 20,

                  color: AppColors.getTextSecondary(currentTheme),
                ),
              ),

              const SizedBox(width: 12),

              // NOTIFICATION
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,

                onPressed: () {},

                icon: Icon(
                  Icons.notifications_none,

                  size: 20,

                  color: AppColors.getTextSecondary(currentTheme),
                ),
              ),

              const SizedBox(width: 12),

              // PROFILE
              Container(
                width: 32,
                height: 32,

                decoration: BoxDecoration(
                  color: AppColors.getAccentOrange(currentTheme),
                  shape: BoxShape.circle,
                ),

                child: const Center(
                  child: Text(
                    "AS",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}