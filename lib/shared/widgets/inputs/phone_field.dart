import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const AppPhoneField({
    super.key,
    required this.controller,
    this.label = "Phone Number",
    this.hintText = "+91 9876543210",
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      autofillHints: const [
        AutofillHints.telephoneNumber,
      ],
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'[0-9+\-\s()]'),
        ),
      ],
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: const Icon(Icons.phone_outlined),
      ),
    );
  }
}