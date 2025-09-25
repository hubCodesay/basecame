import 'dart:math';

import 'package:basecam/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class Ratings extends StatelessWidget {
  const Ratings({super.key, required this.votes});

  final List<int> votes;

  @override
  Widget build(BuildContext context) {
    final maxDigits = _calcMaxDigits();
    return Column(
      spacing: 8,
      children: [
        Row(
          children: [
            Text("Ratings (${votes.length})", style: Theme.of(context).textTheme.titleMedium),
            if (votes.isNotEmpty) StarRating(
              rating: (_sum() / votes.length).clamp(0.0, 5.0),
              size: 24,
              color: ThemeColors.blackColor,
              borderColor: ThemeColors.blackColor,
              filledIcon: Icons.star_rounded,
              emptyIcon: Icons.star_border_rounded,
            ),
          ],
        ),

        ...List<Widget>.generate(5, (rowIndex) {
          final stars = 5 - rowIndex;
          return RateRowWidget(
            stars: stars,
            progress: votes.isEmpty ? 0 : _calcRateCount(stars) / votes.length,
            votes: _calcRateCount(stars),
            maxDigits: maxDigits,
          );
        }),
      ],
    );
  }

  int _calcRateCount(int rate) {
    return votes.where((v) => v == rate).length;
  }

  int _calcMaxDigits() {
    int maxDigits = 1;
    for (int i = 1; i <= 5; i++) {
      maxDigits = max(maxDigits, _calcRateCount(i).toString().length);
    }
    return maxDigits;
  }

  int _sum() {
    return votes.reduce((value, element) => value + element);
  }
}

class RateRowWidget extends StatelessWidget {
  const RateRowWidget({
    super.key,
    required this.stars,
    required this.progress,
    required this.votes,
    this.height = 16.0,
    this.backgroundColor = Colors.white,
    this.progressColor = ThemeColors.greyColor,
    this.maxDigits = 1,
  });

  final double progress; // від 0.0 до 1.0
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final int stars;
  final int votes;
  final int maxDigits;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium!;
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StarRating(
          rating: stars.toDouble(),
          size: 24,
          color: ThemeColors.blackColor,
          borderColor: ThemeColors.blackColor,
          filledIcon: Icons.star_rounded,
          emptyIcon: Icons.star_border_rounded,
        ),
        Expanded(
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: BoxBorder.all(color: progressColor, width: 1),
              borderRadius: BorderRadius.circular(height / 2),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                    height: height,
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Stack(
            alignment: AlignmentGeometry.centerRight,
            children: [
              // Потрібен для автоматичного підбору максимально-потрібної ширини для всіх
              Text(''.padRight(maxDigits, '8'), style: textStyle.copyWith(
                  color: Colors.transparent
              )),
              Text('$votes', style: textStyle),
            ]),
      ],
    );
  }
}
