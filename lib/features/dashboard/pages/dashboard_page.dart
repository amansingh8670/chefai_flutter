import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/dashboard_body.dart';
import '../../../shared/widgets/app_top_bar.dart';
import '../../../shared/widgets/app_bottom_nav.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/theme_provider.dart';
import '../../checkout/pages/smart_cart.dart';
import '../../meal_tracker/pages/log_meal.dart';
import '../../chatbot/pages/chefai_chatbot.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    
    return Scaffold(
      backgroundColor: AppColors.getBackground(themeMode),
      body: Column(
        children: [
          // Top Bar
          if (_selectedIndex != 2)
            SafeArea(
              bottom: false,
              child: const AppTopBar(),
            ),
          
          // Content
          Expanded(
            child: SafeArea(
              top: false,
              child: _selectedIndex == 2 
                ? ChatScreen(onBack: () => setState(() => _selectedIndex = 0)) 
                : const DashboardBody(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            // Already on home
            return;
          }
          
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LogMealScreen()));
          } else if (index == 4) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SmartCartScreen()));
          } else {
             // For Quick (index 3) and Center Button (index 2)
             setState(() { _selectedIndex = index; });
          }
        },
      ),
    );
  }
}