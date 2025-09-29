import 'package:basecam/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SendWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;

  const SendWidget({super.key, this.onChanged, this.hintText = "Search"});

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          hintText: hintText,
          constraints: const BoxConstraints.tightFor(height: 44),
          leading: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              'assets/icons/violine.svg',
              width: 24,
              height: 24,
            ),
          ),
          trailing: [
            IconButton(
              // icon: const Icon(Icons.arrow_upward),
              icon: SvgPicture.asset(
                'assets/icons/arrowUp.svg',
                width: 10,
                height: 13,
              ),
              onPressed: () {
                // тут можна викликати потрібну дію
                debugPrint("Up arrow pressed");
              },
            ),
          ],
          backgroundColor: WidgetStateProperty.all(ThemeColors.silverColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          elevation: WidgetStateProperty.all(0),
          onChanged: onChanged,
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        // Поки що заглушка
        return const Iterable<Widget>.empty();
      },
    );
  }
}
