import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ImageRowWidget extends StatelessWidget {
  final ImageData imageData;
  final BlockConfig blockConfig;
  final double baselineScreenWidth;

  final Function(MyLink)? onTap;

  const ImageRowWidget({
    super.key,
    required this.imageData,
    required this.blockConfig,
    this.baselineScreenWidth = 375.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / baselineScreenWidth;
    final scaledPaddingHorizontal =
        (blockConfig.horizontalPadding ?? 0) * scaleFactor;
    final scaledPaddingVertical =
        (blockConfig.verticalPadding ?? 0) * scaleFactor;
    final scaledImageWidth = screenWidth - (2 * scaledPaddingHorizontal);
    final scaledImageHeight = (blockConfig.blockHeight ?? 0) * scaleFactor;
    return Image.network(imageData.imageUrl,
            width: scaledImageWidth,
            height: scaledImageHeight,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ).center().constrained(
                    width: scaledImageWidth,
                    height: scaledImageHeight,
                  );
            },
            errorBuilder: (context, error, stackTrace) => Center(
                    child: Placeholder(
                  fallbackHeight: scaledImageHeight,
                  fallbackWidth: scaledImageWidth,
                )))
        .center()
        .constrained(
          width: scaledImageWidth,
          height: scaledImageHeight,
        )
        .padding(
          horizontal: scaledPaddingHorizontal,
          vertical: scaledPaddingVertical,
        )
        .gestures(
          onTap: () => onTap?.call(imageData.link),
        );
  }
}
