import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ImageRowWidget extends StatelessWidget {
  final ImageData imageData;
  final double paddingHorizontal;
  final double paddingVertical;
  final double height;
  final double baselineScreenWidth;

  final Function(MyLink)? onTap;

  const ImageRowWidget({
    super.key,
    required this.imageData,
    this.paddingHorizontal = 16.0,
    this.paddingVertical = 8.0,
    this.height = 200.0,
    this.baselineScreenWidth = 375.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / baselineScreenWidth;
    final scaledPaddingHorizontal = paddingHorizontal * scaleFactor;
    final scaledPaddingVertical = paddingVertical * scaleFactor;
    final scaledImageWidth = screenWidth - (2 * scaledPaddingHorizontal);
    final scaledImageHeight = height * scaleFactor;
    return GestureDetector(
      onTap: () => onTap?.call(imageData.link),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: scaledPaddingHorizontal,
            vertical: scaledPaddingVertical),
        child: Image.network(
          imageData.imageUrl,
          width: scaledImageWidth,
          height: scaledImageHeight,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
