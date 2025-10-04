import 'package:flutter/material.dart';
import 'package:basecam/ui/theme.dart';
import 'package:flutter_svg/svg.dart';

class InfoBoxHoriz extends StatelessWidget {
  const InfoBoxHoriz({
    super.key,
    this.iconWidget,
    required this.text,
    this.asset,
    required this.subText,
  });

  final Widget? iconWidget;
  final String text;
  final String subText;
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
      child: Row(
        children: [
          ?iconWidget,
          if (asset is String) SvgPicture.asset(asset!, width: sizeIcon, height: sizeIcon),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: textTheme.bodySmall?.copyWith(
                  color: ThemeColors.bodyTextColor,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subText,
                style: textTheme.bodySmall?.copyWith(
                  color: ThemeColors.bodyTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
