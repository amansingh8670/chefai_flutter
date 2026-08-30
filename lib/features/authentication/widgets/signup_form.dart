import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/shared/widgets/buttons/primary_button.dart';
import 'package:chef_ai_mobile/shared/widgets/buttons/secondary_button.dart';
import 'package:chef_ai_mobile/shared/widgets/enums/button_icon_position.dart';
import 'package:chef_ai_mobile/shared/widgets/inputs/email_field.dart';
import 'package:chef_ai_mobile/shared/widgets/inputs/password_field.dart';
import 'package:chef_ai_mobile/shared/widgets/inputs/text_field.dart';
import 'package:chef_ai_mobile/shared/widgets/separators/text_inline_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (_formKey.currentState!.validate()) {
      // TODO:
      // Call signup API
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // SvgPicture.asset("assets/images/chefai_logo.svg", height: 90),

                
                  const SizedBox(height: 40),

                  AppTextField(
                    controller: _nameController,
                    label: "Full Name",
                    hint: "Chef Ramsay",
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your name";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  AppEmailField(controller: _emailController),

                  const SizedBox(height: 20),

                  AppPasswordField(
                    controller: _passwordController,
                    label: "Create Password",
                    hint: "Minimum 8 characters",
                  ),

                  const SizedBox(height: 28),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (_) {},
                        activeColor: AppColors.primaryOrange,
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                            children: [
                              TextSpan(text: "I agree to ChefAI's "),

                              TextSpan(
                                text: "Terms of Service",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),

                              TextSpan(text: " & "),

                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  PrimaryButton(
                    label: "CREATE ACCOUNT",
                    // icon: Icon(Icons.add),
                    iconPosition: ButtonIconPosition.left,
                    onPressed: _createAccount,
                  ),

                  const SizedBox(height: 18),
                  const TextInlineDivider(text: "OR SYNC USING"),

                  const SizedBox(height: 28),
                  SecondaryButton(
                    label: "SIGN UP WITH GOOGLE",
                    icon: Image.asset(
                      "assets/images/google_logo.png",
                      height: 20,
                    ),
                    iconPosition: ButtonIconPosition.left,
                    onPressed: _createAccount,
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      TextButton(
                        onPressed: () {
                          // Navigate to Login
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.bold,
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
