import 'package:basecam/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Waypoint {
  final IconData icon;
  final String title;
  final String subtitle;

  Waypoint({required this.icon, required this.title, required this.subtitle});
}

class Waypoints extends StatelessWidget {
  final List<Waypoint> waypoints;

  const Waypoints({super.key, required this.waypoints});

  @override
  Widget build(BuildContext context) {
    if (waypoints.isEmpty) return const Text("No waypoints available");

    return Column(
      children: waypoints.map((wp) {
        final isLast = wp == waypoints.last;
        return _WaypointItem(
          icon: wp.icon,
          title: wp.title,
          subtitle: wp.subtitle,
          isLast: isLast,
        );
      }).toList(),
    );
  }
}


class _WaypointItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLast;

  const _WaypointItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: ThemeColors.primaryColor,
                  padding: const EdgeInsets.only(top: 5, left: 7, right: 5, bottom: 5),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: SvgPicture.asset(
                  'assets/icons/play.svg',
                  width: 8,
                  height: 10,
                  colorFilter: ColorFilter.mode(
                    ThemeColors.primaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              if (!isLast)
                Builder(
                  builder: (context) {
                    // обчислюємо висоту під текст
                    final textHeight = _calculateTextHeight(
                      context,
                      title,
                      subtitle,
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    );
                    return SizedBox(
                      height: textHeight > 0 ? textHeight : 0,
                      child: DashedLine(color: Colors.grey.shade400),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTextHeight(
      BuildContext context, String title, String subtitle, TextStyle style) {
    final tpTitle = TextPainter(
      text: TextSpan(text: title, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 16 - 12 - 16);

    final tpSubtitle = TextPainter(
      text: TextSpan(text: subtitle, style: const TextStyle()),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 16 - 12 - 16);

    return tpTitle.height + 4 + tpSubtitle.height;
  }
}


class DashedLine extends StatelessWidget {
  final double dashWidth;
  final double dashSpace;
  final Color color;

  const DashedLine({
    super.key,
    this.dashWidth = 2,
    this.dashSpace = 4,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(dashWidth, constraints.maxHeight),
          painter: _DashedLinePainter(dashWidth, dashSpace, color),
        );
      },
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final Color color;

  _DashedLinePainter(this.dashWidth, this.dashSpace, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = dashWidth;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}