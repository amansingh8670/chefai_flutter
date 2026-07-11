import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';

class AppNumberField extends ConsumerStatefulWidget {
  final String label;
  final String hint;

  final TextEditingController controller;
  final FocusNode? focusNode;

  final bool enabled;
  final bool readOnly;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final int? maxLength;

  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  final bool allowDecimal;

  const AppNumberField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.allowDecimal = true,
  });

  @override
  ConsumerState<AppNumberField> createState() => _AppNumberFieldState();
}

class _AppNumberFieldState extends ConsumerState<AppNumberField> {
  late FocusNode _focusNode;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();

    if (widget.focusNode == null) {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    } else {
      _focusNode = widget.focusNode!;
    }

    _focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isFocused = _focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primaryOrange,
            fontWeight: FontWeight.w800,
            fontSize: 11,
            letterSpacing: .6,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: AppColors.getSurface(themeMode),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isFocused
                  ? AppColors.primaryOrange
                  : AppColors.getDivider(themeMode),
              width: isFocused ? 1.2 : .8,
            ),
            boxShadow: isFocused
                ? [
                    BoxShadow(
                      color: AppColors.primaryOrange.withValues(alpha: .12),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            keyboardType: TextInputType.numberWithOptions(
              decimal: widget.allowDecimal,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                widget.allowDecimal
                    ? RegExp(r'^\d*\.?\d*$')
                    : RegExp(r'^\d*$'),
              ),
            ],
            maxLength: widget.maxLength,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            style: TextStyle(
              color: AppColors.getTextPrimary(themeMode),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              counterText: "",
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: AppColors.getTextSecondary(themeMode),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}