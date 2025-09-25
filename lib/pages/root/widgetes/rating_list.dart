// import 'package:basecam/pages/root/widgetes/tag_widget.dart';
// import 'package:basecam/ui/theme.dart'; // Додано імпорт для ThemeColors
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//
// class RatingList extends StatelessWidget {
//   final String title;
//   final String description;
//   final String date;
//   final List<String> tags;
//   final int rating;
//
//   const RatingList({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.date,
//     required this.tags,
//     this.rating = 5,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Повертаємо Column як кореневий віджет.
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Rating stars
//         RatingBarIndicator(
//           rating: rating.toDouble(), // ВИПРАВЛЕНО: використовуємо 'rating' з цього віджета
//           itemCount: 5,
//           itemSize: 18.0,
//           direction: Axis.horizontal,
//           unratedColor: Colors.transparent,
//           itemBuilder: (context, index) {
//             // ВИПРАВЛЕНО: використовуємо надійний підхід зі Stack
//             return Stack(
//               children: <Widget>[
//                 // 1. Фон для незаповненої частини - БІЛИЙ
//                 const Icon(Icons.star, color: Colors.white, size: 18.0),
//                 // 2. Обводка - ЧОРНА
//                 Icon(
//                   Icons.star_outline,
//                   color: ThemeColors.pureBlackColor,
//                   size: 18.0,
//                 ),
//                 // 3. Заповнення - ЧОРНЕ
//                 Icon(
//                   Icons.star,
//                   color: ThemeColors.pureBlackColor,
//                   size: 18.0,
//                 ),
//               ],
//             );
//           },
//         ),
//         const SizedBox(height: 8.0),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 18.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8.0),
//         Text(
//           description,
//           style: const TextStyle(fontSize: 14.0),
//         ),
//         const SizedBox(height: 8.0),
//         Text(
//           date,
//           style: const TextStyle(fontSize: 12.0, color: Colors.grey),
//         ),
//         const SizedBox(height: 8.0),
//         if (tags.isNotEmpty)
//           Wrap(
//             spacing: 4.0, // Горизонтальний відступ між тегами
//             runSpacing: 4.0, // Вертикальний відступ, якщо теги переносяться
//             children: tags.map((tag) => TagWidget(text: tag)).toList(),
//           ),
//       ],
//     );
//   }
// }


import 'package:basecam/pages/root/widgetes/tag_widget.dart';
import 'package:basecam/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class RatingList extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final List<String> tags;
  final int rating;

  const RatingList({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.tags,
    this.rating = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating stars
        Row(
          children: [
            StarRating(
              rating: rating.toDouble(),
              size: 24,
              color: ThemeColors.blackColor,
              borderColor: ThemeColors.blackColor,
              filledIcon: Icons.star_rounded,
              emptyIcon: Icons.star_border_rounded,
            ),
          ],
        ),
        // RatingBar.builder(
        //   initialRating: rating.toDouble(),
        //   minRating: 1,
        //   direction: Axis.horizontal,
        //   allowHalfRating: true, // Дозволяє дробові рейтинги, якщо потрібно
        //   itemCount: 5,
        //   itemSize: 18.0,
        //   unratedColor: Colors.transparent, // <-- ДОДАЙТЕ ЦЕЙ РЯДОК
        //
        //   ignoreGestures: true, // Робить віджет неінтерактивним (тільки для показу)
        //   itemBuilder: (context, _) => Stack(
        //     children: [
        //       // Шар 1: Обводка (завжди видима)
        //       Icon(
        //         Icons.star_border,
        //         color: ThemeColors.pureBlackColor,
        //       ),
        //       // Шар 2: Заповнення (буде обрізатися бібліотекою)
        //       Icon(
        //         Icons.star,
        //         color: ThemeColors.pureBlackColor,
        //       ),
        //     ],
        //   ),
        //   onRatingUpdate: (rating) {
        //     // Цей колбек не буде викликатися через ignoreGestures: true
        //   },
        // ),
        const SizedBox(height: 8.0),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          description,
          style: const TextStyle(fontSize: 14.0),
        ),
        const SizedBox(height: 8.0),
        Text(
          date,
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
        const SizedBox(height: 8.0),
        if (tags.isNotEmpty)
          Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: tags.map((tag) => TagWidget(text: tag, color: ThemeColors.greyColor,)).toList(),
          ),
      ],
    );
  }
}
