import 'package:flutter/material.dart';

import 'app_text_field.dart';

class AppPasswordField extends StatefulWidget {
  final TextEditingController controller;

  final FocusNode? focusNode;

  final String label;
  final String hint;

  final bool enabled;
  final bool readOnly;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final String? Function(String?)? validator;

  const AppPasswordField({
    super.key,
    required this.controller,
    this.focusNode,
    this.label = "Password",
    this.hint = "Enter password",
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
    this.validator,
  });

  @override
  State<AppPasswordField> createState() =>
      _AppPasswordFieldState();
}

class _AppPasswordFieldState
    extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,

      focusNode: widget.focusNode,

      label: widget.label,
      hint: widget.hint,

      enabled: widget.enabled,
      readOnly: widget.readOnly,

      obscureText: _obscure,

      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,

      textCapitalization: TextCapitalization.none,

      autofillHints: const [
        AutofillHints.password,
      ],

      prefixIcon: const Icon(
        Icons.lock_outline_rounded,
        size: 20,
      ),

      suffixIcon: IconButton(
        splashRadius: 18,
        tooltip:
            _obscure ? "Show password" : "Hide password",
        icon: Icon(
          _obscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscure = !_obscure;
          });
        },
      ),

      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,

      validator:
          widget.validator ?? _defaultValidator,
    );
  }

  String? _defaultValidator(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }
}