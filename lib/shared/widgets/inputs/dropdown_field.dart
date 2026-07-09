import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final String? hintText;
  final T? value;
  final List<DropdownMenuEntry<T>> entries;
  final ValueChanged<T?>? onSelected;
  final FormFieldValidator<T>? validator;
  final bool enabled;
  final Widget? leadingIcon;
  final double borderRadius;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.entries,
    this.value,
    this.hintText,
    this.onSelected,
    this.validator,
    this.enabled = true,
    this.leadingIcon,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xffFF8A24),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        DropdownMenu<T>(
          initialSelection: value,
          enabled: enabled,
          hintText: hintText,
          leadingIcon: leadingIcon,
          width: double.infinity,
          dropdownMenuEntries: entries,
          onSelected: onSelected,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xff23252B),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: .06),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: .06),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(
                color: Color(0xffFF8A24),
              ),
            ),
          ),
        ),
      ],
    );
  }
}