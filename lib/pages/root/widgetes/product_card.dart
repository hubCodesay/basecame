import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'product_details.dart';

class ProductCard extends StatelessWidget {
  final String? productName;
  final String? price;
  final String? tag;
  final String? location;
  final String? timestamp;
  final String? imageUrl;

  const ProductCard({
    super.key,
    this.productName,
    this.price,
    this.tag,
    this.location,
    this.timestamp,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.width/2 * 0.8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: (imageUrl != null && imageUrl!.isNotEmpty)
              ? Image.network(
            imageUrl!,
            height: _height,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: _height,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          )
              : Container(
            height: _height,
            width: double.infinity,
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            // child: SvgPicture.asset(
            //   'assets/icons/bookmark.svg',
            //   width: 24,
            //   height: 24,
            // ),
            child: Icon(Icons.image_outlined, size: 40, color: Colors.grey.shade400),
          ),
        ),
        const SizedBox(height: 12),
        ProductDetails(
          productName: productName,
          price: price,
          tag: tag,
          location: location,
          timestamp: timestamp,
        ),
      ],
    );
  }
}