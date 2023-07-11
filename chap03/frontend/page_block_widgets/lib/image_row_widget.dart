import 'package:flutter/material.dart';

class ImageRowWidget extends StatelessWidget {
  final String imageUrl;
  final double paddingHorizontal;
  final double paddingVertical;
  final double height;
  final double baselineScreenWidth;
  final VoidCallback? onTap;

  const ImageRowWidget({
    super.key,
    this.imageUrl = 'https://picsum.photos/200/300',
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
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: scaledPaddingHorizontal,
            vertical: scaledPaddingVertical),
        child: Image.network(
          imageUrl,
          width: scaledImageWidth,
          height: scaledImageHeight,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
