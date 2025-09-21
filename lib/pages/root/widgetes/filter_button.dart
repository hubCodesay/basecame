import 'package:basecam/ui/theme.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? icon;
  final Widget? label;
  final bool dropIcon;
  final double borderRadius;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double borderWidth;
  final Color? iconColor;
  final FontWeight? fontWeight;
  final bool showBorder;

  const FilterButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.label,
    required this.dropIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.iconColor,
    this.fontWeight,
    this.borderRadius = 8,
    this.borderWidth = 2,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: showBorder
            ? (borderColor != null
            ? BorderSide(color: borderColor!, width: borderWidth)
            : null)
            : BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          if (label != null) ...[
            SizedBox(width: 4),
            DefaultTextStyle(
              style: TextStyle(
                fontWeight: fontWeight ?? FontWeight.normal,
                color: foregroundColor,
                fontSize: 14,
                // height: 1.4,
              ),
              child: label!,
            ),
            SizedBox(width: 4),
            // ?label,
          ],
          if (dropIcon)
            Icon(
              Icons.keyboard_arrow_down,
              color: ThemeColors.greyColor,
              size: 22,
            ),
        ],
      ),
    );
  }
}

