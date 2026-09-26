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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      title: 'Flutter Demo',
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: currentTheme,
      home: session != null ? const DashboardPage() : const LandingPage(),
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
