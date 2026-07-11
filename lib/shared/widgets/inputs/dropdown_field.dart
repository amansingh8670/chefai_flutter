import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chef_ai_mobile/core/theme/app_colors.dart';
import 'package:chef_ai_mobile/providers/theme_provider.dart';

class AppDropdownField<T> extends ConsumerStatefulWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<DropdownMenuEntry<T>> entries;
  final ValueChanged<T?>? onSelected;
  final FormFieldValidator<T>? validator;
  final bool enabled;
  final Widget? leadingIcon;
  final double borderRadius;
  final FocusNode? focusNode;
  final double? width;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.entries,
    this.value,
    this.hint,
    this.onSelected,
    this.validator,
    this.enabled = true,
    this.leadingIcon,
    this.borderRadius = 18,
    this.focusNode,
    this.width,
  });

  @override
  ConsumerState<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends ConsumerState<AppDropdownField<T>> {
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
            borderRadius: BorderRadius.circular(widget.borderRadius),
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
          child: DropdownMenu<T>(
            initialSelection: widget.value,
            enabled: widget.enabled,
            focusNode: _focusNode,
            width: widget.width,
            hintText: widget.hint,
            leadingIcon: widget.leadingIcon,
            onSelected: widget.onSelected,
            dropdownMenuEntries: widget.entries,
            inputDecorationTheme: const InputDecorationTheme(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            textStyle: TextStyle(
              color: AppColors.getTextPrimary(themeMode),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(
                AppColors.getSurface(themeMode),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}