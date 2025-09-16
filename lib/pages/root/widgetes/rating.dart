import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final List<String> tags;
  final int rating;

  const Rating({
    Key? key,
    required this.title,
    required this.description,
    required this.date,
    required this.tags,
    this.rating = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating stars
          Row(
            children: List.generate(
              5,
                  (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 20.0,
              ),
            ),
          ),
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
          Wrap(
            spacing: 8.0,
            children: tags.map((tag) => Chip(
              label: Text(tag),
              backgroundColor: Colors.grey[300],
            )).toList(),
          ),
        ],
      ),
    );
  }
}
