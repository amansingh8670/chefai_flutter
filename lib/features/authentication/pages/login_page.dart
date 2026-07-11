import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:chef_ai_mobile/core/theme/app_colors.dart';

import 'package:chef_ai_mobile/shared/widgets/inputs/email_field.dart';
import 'package:chef_ai_mobile/shared/widgets/inputs/password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    // TODO:
    // Login API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  SvgPicture.asset(
                    "assets/icons/chefai_logo.svg",
                    height: 90,
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Welcome Back",
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Log in to sync your kitchen",
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),

                  const SizedBox(height: 40),

                  AppEmailField(
                    controller: _emailController,
                  ),

                  const SizedBox(height: 18),

                  AppPasswordField(
                    controller: _passwordController,
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        activeColor: AppColors.primaryOrange,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                      ),

                      const Text(
                        "Remember me",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const Spacer(),

                      TextButton(
                        onPressed: () {},

                        child: const Text(
                          "Forgot Password?",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 56,

                    child: ElevatedButton(
                      onPressed: _login,

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primaryOrange,

                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),

                      child: const Text(
                        "SIGN IN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    height: 56,

                    child: OutlinedButton.icon(
                      onPressed: () {},

                      icon: const Icon(Icons.g_mobiledata),

                      label: const Text(
                        "SIGN IN WITH GOOGLE",
                      ),

                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            AppColors.textPrimaryLight,

                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      const Text(
                        "Don't have an account?",
                      ),

                      TextButton(
                        onPressed: () {
                          // Navigate to Sign Up
                        },

                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                AppColors.primaryOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}