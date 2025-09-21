import 'package:basecam/ui/theme.dart';
import 'package:flutter/material.dart';

class ArrowButtonBack extends StatelessWidget {
  const ArrowButtonBack({super.key, required this.onPressed});

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: BackButtonIcon(),
      color: ThemeColors.blackColor,
    );
  }
}
