import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final String rating;
  const Rating({super.key, this.rating = '0.0'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, size: 16, color: Colors.orangeAccent),
        const SizedBox(width: 6),
        Text(rating),
      ],
    );
  }
}
