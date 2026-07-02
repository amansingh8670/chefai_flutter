import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/theme_provider.dart';

import 'package:flutter_svg/flutter_svg.dart';

class AppBottomNav extends ConsumerWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return SafeArea(
      top: false,
      child: SizedBox(
        height: 78,

        // allows orange AI button to overflow outside navbar
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,

          children: [
            // =====================================================
            // NAVBAR
            // =====================================================
            Positioned(
              left: 16,
              right: 16,
              bottom: 0,

              child: Container(
                height: 54,

                decoration: BoxDecoration(
                  color: AppColors.getSurface(themeMode),

                  borderRadius: BorderRadius.circular(24),

                  border: Border.all(
                    color: AppColors.getDivider(themeMode),
                    width: 1,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: AppColors.getShadow(themeMode),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    _navItem(
                      icon: Icons.home_rounded,
                      label: "Home",
                      index: 0,
                      themeMode: themeMode,
                    ),

                    _navItem(
                      icon: Icons.shopping_cart_outlined,
                      label: "Cart",
                      index: 1,
                      themeMode: themeMode,
                    ),

                    // empty center spacing
                    const SizedBox(width: 56),

                    _navItem(
                      icon: Icons.restaurant_menu_rounded,
                      label: "Meals",
                      index: 3,
                      themeMode: themeMode,
                    ),

                    _navItem(
                      icon: Icons.kitchen_outlined,
                      label: "Pantry",
                      index: 4,
                      themeMode: themeMode,
                    ),
                  ],
                ),
              ),
            ),

            // =====================================================
            // FLOATING AI BUTTON
            // =====================================================
            Positioned(
              top: -2,

              child: GestureDetector(
                onTap: () => onTap(2),

                child: Container(
                  width: 58,
                  height: 58,

                  decoration: BoxDecoration(
                    color: AppColors.getPrimaryOrange(themeMode),

                    shape: BoxShape.circle,

                    border: Border.all(
                      color: AppColors.getSurface(themeMode),
                      width: 3,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: AppColors.getPrimaryOrange(
                          themeMode,
                        ).withValues(alpha: 0.30),

                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/chefai_logo.svg',

                      height: 45,
                      width: 45,

                      // colorFilter: const ColorFilter.mode(
                      //   Colors.white,
                      //   BlendMode.srcIn,
                      // ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
    required ThemeMode themeMode,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),

      child: SizedBox(
        width: 52,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              icon,
              size: 18,

              color: isSelected
                  ? AppColors.getPrimaryOrange(themeMode)
                  : AppColors.getTextSecondary(themeMode),
            ),

            const SizedBox(height: 2),

            Text(
              label,

              style: TextStyle(
                fontSize: 9,
                height: 1,

                fontWeight: FontWeight.w700,

                color: isSelected
                    ? AppColors.getPrimaryOrange(themeMode)
                    : AppColors.getTextSecondary(themeMode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
