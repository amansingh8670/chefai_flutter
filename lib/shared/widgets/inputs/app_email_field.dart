import 'package:flutter/material.dart';

import 'app_text_field.dart';

class AppEmailField extends StatelessWidget {
  final TextEditingController controller;

  final FocusNode? focusNode;

  final String label;
  final String hint;

  final bool enabled;
  final bool readOnly;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final String? Function(String?)? validator;

  const AppEmailField({
    super.key,
    required this.controller,
    this.focusNode,

    this.label = "Email Address",
    this.hint = "chef@example.com",

    this.enabled = true,
    this.readOnly = false,

    this.onChanged,
    this.onSubmitted,

    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,

      focusNode: focusNode,

      label: label,
      hint: hint,

      enabled: enabled,
      readOnly: readOnly,

      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,

      textCapitalization: TextCapitalization.none,

      autofillHints: const [
        AutofillHints.email,
        AutofillHints.username,
      ],

      prefixIcon: const Icon(
        Icons.email_outlined,
        size: 20,
      ),

      onChanged: onChanged,
      onSubmitted: onSubmitted,

      validator: validator ?? _defaultValidator,
    );
  }

  static String? _defaultValidator(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email address is required';
    }

    final regex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!regex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }
}