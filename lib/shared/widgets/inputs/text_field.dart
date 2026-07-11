import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';

class AppTextField extends ConsumerStatefulWidget {
  final String label;
  final String hint;

  final TextEditingController controller;
  final FocusNode? focusNode;

final bool showLabel;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  final bool obscureText;
  final bool enabled;
  final bool readOnly;

  final int maxLines;
  final int minLines;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final String? Function(String?)? validator;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  final List<TextInputFormatter>? inputFormatters;

  final Iterable<String>? autofillHints;

  final TextCapitalization textCapitalization;

  const AppTextField({
    super.key,

    required this.label,
    required this.hint,
    required this.controller,

    this.focusNode,

    this.showLabel = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,

    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,

    this.maxLines = 1,
    this.minLines = 1,

    this.prefixIcon,
    this.suffixIcon,

    this.validator,

    this.onChanged,
    this.onSubmitted,
    this.onTap,

    this.inputFormatters,
    this.autofillHints,

    this.textCapitalization = TextCapitalization.words,
  });

  @override
  ConsumerState<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends ConsumerState<AppTextField> {
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
      setState(() {});
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: TextStyle(
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
                      color: AppColors.primaryOrange
                          .withValues(alpha: .12),
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

            obscureText: widget.obscureText,

            keyboardType: widget.keyboardType,

            textInputAction: widget.textInputAction,

            validator: widget.validator,

            onChanged: widget.onChanged,

            onFieldSubmitted: widget.onSubmitted,

            onTap: widget.onTap,

            inputFormatters: widget.inputFormatters,

            autofillHints: widget.autofillHints,

            textCapitalization: widget.textCapitalization,

            maxLines: widget.maxLines,

            minLines: widget.minLines,

            style: TextStyle(
              color: AppColors.getTextPrimary(themeMode),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),

            decoration: InputDecoration(
              border: InputBorder.none,

              isDense: true,

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