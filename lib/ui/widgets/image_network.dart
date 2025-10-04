import 'package:flutter/material.dart';

class ImageNetwork extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;

  const ImageNetwork({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return (imageUrl != null && imageUrl!.isNotEmpty)
        ? Image.network(
      imageUrl!,
      height: height,
      width: width ?? double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: height,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    )
        : _placeholder();
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: width ?? double.infinity,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 40,
        color: Colors.grey.shade400,
      ),
    );
  }
}
