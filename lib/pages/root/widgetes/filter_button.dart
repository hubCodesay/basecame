import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Widget? label;
  final bool dropIcon;

  const FilterButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    required this.dropIcon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 4),
          ?label,
          if (label != null) SizedBox(width: 4),
          if (dropIcon) Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}