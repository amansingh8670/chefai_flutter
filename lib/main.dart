import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/core/util/app_scroll_behavior.dart';
import 'package:chef_ai_mobile/features/authentication/pages/login_page.dart';
import 'package:chef_ai_mobile/features/authentication/pages/signup_page.dart';
import 'package:chef_ai_mobile/features/authentication/widgets/signup_form.dart';
import 'package:chef_ai_mobile/features/chatbot/pages/chefai_chatbot.dart';
import 'package:chef_ai_mobile/features/checkout/pages/smart_cart.dart';
import 'package:chef_ai_mobile/features/dashboard/pages/dashboard_page.dart';
import 'package:chef_ai_mobile/features/inventory/pages/kitchen.dart';
import 'package:chef_ai_mobile/features/inventory/widgets/item_detail_form.dart';
import 'package:chef_ai_mobile/features/landing/pages/landing_page.dart';
import 'package:chef_ai_mobile/features/meal_tracker/pages/dashboard.dart';
import 'package:chef_ai_mobile/features/meal_tracker/widgets/date_scroller.dart';
import 'package:chef_ai_mobile/features/meal_tracker/widgets/meal_detail_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
// import 'core/theme/app_colors.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: currentTheme,
      home: SignUpScreen()
      // const DateScroller(
      //   days: ["FRI", "SAT", "SUN", "MON", "TUE", "WED", "THU"],
      //   dates: ["12", "13", "14", "15", "16", "17", "18"],
      //   selectedIndex: 3,
      // ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chef AI Mobile')),

      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(themeProvider.notifier).toggleTheme();
          },

          child: const Text('Toggle Theme'),
        ),
      ),
    );
  }
}
