import 'package:basecam/ui/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductCardNav extends StatelessWidget {
  final String? productName;
  final String? price;
  final String? tag;
  final String? location;
  final String? timestamp;
  final String? imageUrl;
  final GestureTapCallback onTap;

  const ProductCardNav({
    super.key,
    this.productName,
    this.price,
    this.tag,
    this.location,
    this.timestamp,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ProductCard(
        productName: productName,
        price: price,
        tag: tag,
        location: location,
        timestamp: timestamp,
        imageUrl: imageUrl,
      ),
    );
  }
}
