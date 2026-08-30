import 'package:chef_ai_mobile/shared/widgets/enums/button_icon_position.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool isLoading;
  final Widget? icon;
  final ButtonIconPosition iconPosition;

  final double? width;
  final double height;
  final EdgeInsetsGeometry padding;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.disabled = false,
    this.icon,
    this.iconPosition = ButtonIconPosition.left,
    this.width,
    this.height = 52,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  });

  bool get _isDisabled {
    return disabled || isLoading || onPressed == null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: _isDisabled ? null : onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onSurface,
          elevation: 3,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.onSurface,
                ),
              )
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final labelWidget = Flexible(
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );

    if (icon == null) {
      return labelWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconPosition == ButtonIconPosition.left) ...[
          icon!,
          const SizedBox(width: 8),
        ],

        labelWidget,

        if (iconPosition == ButtonIconPosition.right) ...[
          const SizedBox(width: 8),
          icon!,
        ],
      ],
    );
  }
}
