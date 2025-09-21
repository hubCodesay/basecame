import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductDetails extends StatelessWidget {
  final String? productName;
  final String? price;
  final String? tag;
  final String? location;
  final String? timestamp;

  const ProductDetails({
    super.key,
    this.productName,
    this.price,
    this.tag,
    this.location,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  productName ?? "Long Item name",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SvgPicture.asset(
                'assets/icons/bookmark.svg',
                width: 24,
                height: 24,
              ),
              // const Icon(Icons.bookmark_outline, size: 24),
            ],
          ),
          const SizedBox(height: 4),
          if (tag != null) 
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFA09CAB),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                tag!,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          if (tag != null) const SizedBox(height: 4),
          Text(
            price ?? "\$0/hr",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4), 
          if (location != null)
            Text(
              location!,
              style: const TextStyle(color: Colors.black45, fontSize: 12),
            ),
          if (timestamp != null)
            Text(
              timestamp!,
              style: const TextStyle(color: Colors.black45, fontSize: 12),
            ),
        ],
      ),
    );
  }
}