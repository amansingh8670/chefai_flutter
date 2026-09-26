import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/features/authentication/pages/login_page.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreferencesSetupPage extends ConsumerStatefulWidget {
  const PreferencesSetupPage({super.key});

  @override
  ConsumerState<PreferencesSetupPage> createState() => _PreferencesSetupPageState();
}

class _PreferencesSetupPageState extends ConsumerState<PreferencesSetupPage> {
  final List<String> _dietaryOptions = ['Vegan', 'Vegetarian', 'Keto', 'Paleo', 'Gluten-Free', 'None'];
  final List<String> _timeOptions = ['15 mins', '30 mins', '45 mins', '1 hour+'];
  
  final Set<String> _selectedDietary = {};
  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: AppColors.getBackground(themeMode),
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(themeMode),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.getTextPrimary(themeMode)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What Can I Cook Tonight?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.getTextPrimary(themeMode),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Tell us your preferences so we can tailor recipes for you.",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.getTextSecondary(themeMode),
                ),
              ),
              const SizedBox(height: 40),
              
              // DIETARY PREFERENCES
              Text(
                "Dietary Preferences",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextPrimary(themeMode),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _dietaryOptions.map((option) {
                  final isSelected = _selectedDietary.contains(option);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedDietary.remove(option);
                        } else {
                          if (option == 'None') {
                            _selectedDietary.clear();
                          } else {
                            _selectedDietary.remove('None');
                          }
                          _selectedDietary.add(option);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryOrange.withOpacity(0.15) : AppColors.getSurface(themeMode),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryOrange : AppColors.getDivider(themeMode),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.primaryOrange : AppColors.getTextPrimary(themeMode),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 40),
              
              // TIME AVAILABLE
              Text(
                "Time Available",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextPrimary(themeMode),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _timeOptions.map((option) {
                  final isSelected = _selectedTime == option;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTime = option;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryOrange.withOpacity(0.15) : AppColors.getSurface(themeMode),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryOrange : AppColors.getDivider(themeMode),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.primaryOrange : AppColors.getTextPrimary(themeMode),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const Spacer(),
              
              // GET STARTED BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to sign up page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
