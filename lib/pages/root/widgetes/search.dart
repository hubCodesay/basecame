import 'package:basecam/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;

  const SearchBarWidget({
    super.key,
    this.onChanged,
    this.hintText = "Search",
  });

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
              'assets/icons/search.svg',
              width: 24,
              height: 24,
            ),
          ),
          backgroundColor: WidgetStateProperty.all(ThemeColors.silverColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
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
