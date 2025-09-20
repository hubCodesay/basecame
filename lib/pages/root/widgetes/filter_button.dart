import 'package:basecam/ui/theme.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final Widget? label;
  final bool dropIcon;
  final double borderRadius;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double borderWidth;
  final Color? iconColor;
  final FontWeight? fontWeight;

  const FilterButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    required this.dropIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.iconColor,
    this.fontWeight,
    this.borderRadius = 8,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: borderColor != null ? BorderSide(color: borderColor!, width: borderWidth) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          // Icon(, color: iconColor ?? foregroundColor),
          if (label != null) ...[
            SizedBox(width: 4),
            DefaultTextStyle(
              style: TextStyle(
                fontWeight: fontWeight ?? FontWeight.normal,
                color: foregroundColor,
              ),
              child: label!,
            ),
            SizedBox(width: 4),
            // ?label,
          ],
          // if (label != null) SizedBox(width: 4),
          if (dropIcon)
            Icon(
              Icons.keyboard_arrow_down,
              color: ThemeColors.greyColor,
            ),
        ],
      ),
    );
  }
}
