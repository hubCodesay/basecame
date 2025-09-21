import 'package:basecam/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SaveNavBottomBar extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onNavigate;

  const SaveNavBottomBar({
    super.key,
    required this.onSave,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: paddingHorizontal,
          vertical: vertSpaceDefault,
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                style: silverButtonStyle,
                icon: SvgPicture.asset(
                  'assets/icons/bookmark.svg',
                  width: sizeIcon,
                  height: sizeIcon,
                ),
                label: const Text("Save"),
                onPressed: () {
                  onSave();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Save action triggered (not implemented)"),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: horizontalSpace),
            Expanded(
              child: FilledButton.icon(
                icon: SvgPicture.asset(
                  'assets/icons/cursor_navigate.svg',
                  width: sizeIcon,
                  height: sizeIcon,
                ),
                label: const Text("Navigate"),
                onPressed: () {
                  onNavigate();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Navigate action triggered (not implemented)",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
