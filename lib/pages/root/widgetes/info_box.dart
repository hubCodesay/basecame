import 'package:flutter/material.dart';
import 'package:basecam/ui/theme.dart';
import 'package:flutter_svg/svg.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({super.key, this.iconWidget, required this.text, this.asset});

  final Widget? iconWidget;
  final String text;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ThemeColors.silverColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ?iconWidget,
          if (asset is String) SvgPicture.asset(asset!, width: 24, height: 24),
          const SizedBox(height: 6),
          Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: ThemeColors.bodyTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
