import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/chefai_logo.svg'),
              const Text(
                'Log in to sync your kitchen',
                style: TextStyle(color: AppColors.textPrimaryLight),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'chef@chefai.com',
                ),
              ),
              const SizedBox(height: 16),
              PasswordField(label: 'Password', secureTextEntry: true),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text('Remember me'),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                ),
                child: const Text('Sign In'),
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              TextButton(onPressed: () {}, child: const Text('Forgot?')),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentTeal,
                ),
                child: const Text('Sync with Google'),
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordField extends TextField {
  final String label;
  final bool secureTextEntry;

  const PasswordField({
    super.key,
    required this.label,
    this.secureTextEntry = true,
  }) : super(
         // decoration: InputDecoration(
         //    labelText : "password"
         // ),
         obscureText: secureTextEntry,
       );
}
