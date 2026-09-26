import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/theme_provider.dart';
import '../../providers/kitchen_provider.dart';
import '../../providers/user_provider.dart';
import '../../features/dashboard/widgets/kitchen_management_sheet.dart';
import '../../features/profile/widgets/profile_sheet.dart' as chefai_profile;

class AppTopBar extends ConsumerWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final isDarkMode = currentTheme == ThemeMode.dark;
    
    final activeKitchen = ref.watch(activeKitchenProvider);

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
            Icons.kitchen,
            color: AppColors.getAccentOrange(currentTheme),
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const KitchenManagementSheet(),
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          activeKitchen?.name ?? "Loading...",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.getTextPrimary(currentTheme),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: AppColors.getTextSecondary(currentTheme),
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activeKitchen?.role == 'admin' ? "Owner" : "Member",
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
          ),

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
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const FractionallySizedBox(
                      heightFactor: 0.9,
                      child: chefai_profile.ProfileSheet(),
                    ),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 32,
                  height: 32,

                  decoration: BoxDecoration(
                    color: AppColors.getAccentOrange(currentTheme),
                    shape: BoxShape.circle,
                  ),

                  child: Center(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final profileState = ref.watch(userProfileProvider);
                        final name = profileState.value?.name ?? "AS";
                        final initials = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "A";
                        
                        return Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }
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