import 'package:common/common.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const ImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ).center().constrained(
              width: width,
              height: height,
            );
      },
      errorBuilder: (context, error, stackTrace) => Center(
          child: Placeholder(
        fallbackHeight: height,
        fallbackWidth: width,
      )),
    ).center().constrained(
          width: width,
          height: height,
        );
  }
}
