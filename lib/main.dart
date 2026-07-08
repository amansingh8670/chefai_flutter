import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/core/util/app_scroll_behavior.dart';
import 'package:chef_ai_mobile/features/authentication/pages/login_page.dart';
import 'package:chef_ai_mobile/features/authentication/pages/signup_page.dart';
import 'package:chef_ai_mobile/features/dashboard/pages/dashboard_page.dart';
import 'package:chef_ai_mobile/features/inventory/pages/kitchen.dart';
import 'package:chef_ai_mobile/features/landing/pages/landing_page.dart';
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

  // This widget is the root of your application.
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
      home: const KitchenInventoryScreen(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  // @override
  // State<MyHomePage> createState() => _MyHomePageState();
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
      // bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.business),
      //       label: 'Business',
      //     ),
      //     BottomNavigationBarItem(icon: Icon(Icons.school), label: 'School'),
      //   ],
      //   // currentIndex: _selectedIndex, transform 0.4s cubic-bezier(0.2, 0.8, 0.2, 1)
      //   selectedItemColor: AppColors.primaryLight,
      //   // onTap: _onItemTapped
      //   ),
    );
  }
}
