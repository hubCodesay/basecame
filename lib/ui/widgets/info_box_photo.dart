import 'package:flutter/material.dart';
import 'package:basecam/ui/theme.dart';
import 'package:flutter_svg/svg.dart';
//
// class InfoBoxPhoto extends StatelessWidget {
//   const InfoBoxPhoto({
//     super.key,
//     this.iconWidget,
//     this.asset,
//   });
//
//   final Widget? iconWidget;
//   final String? asset;
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: ThemeColors.silverColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Center(
//         child: iconWidget ??
//             (asset != null
//                 ? SvgPicture.asset(asset!, width: sizeIcon, height: sizeIcon)
//                 : const SizedBox()),
//       ),
//     );
//   }
// }


class InfoBoxPhoto extends StatelessWidget {
  const InfoBoxPhoto({
    super.key,
    this.iconWidget,
    this.asset,
  });

  final Widget? iconWidget;
  final String? asset;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ThemeColors.silverColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: iconWidget ??
            (asset != null
                ? SvgPicture.asset(
              asset!,
              width: sizeIcon,
              height: sizeIcon,
            )
                : Icon(
              Icons.image_not_supported,
              size: sizeIcon,
              color: ThemeColors.greyColor,
            )),
      ),
    );
  }
}
