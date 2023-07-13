import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ImageRowWidget extends StatelessWidget {
  final List<ImageData> items;
  final BlockConfig blockConfig;
  final double baselineScreenWidth;

  final Function(MyLink)? onTap;

  const ImageRowWidget({
    super.key,
    required this.items,
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
    // 实际设备上的区块宽度
    final scaledBlockWidth = screenWidth - (2 * scaledPaddingHorizontal);
    final scaledImageWidth = (scaledBlockWidth -
            (items.length - 1) * (blockConfig.horozontalSpacing ?? 0)) /
        items.length;
    final scaledImageHeight = (blockConfig.blockHeight ?? 0) * scaleFactor;
    if (items.length == 1) {
      return Image.network(items.first.imageUrl,
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
            onTap: () => onTap?.call(items.first.link),
          );
    }
    // 一行二，三张图
    return Row(
      children: items
          .map(
            (e) {
              final last = items.last == e;
              return [
                Expanded(
                  child: Image.network(
                    e.imageUrl,
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
                    )),
                  )
                      .center()
                      .constrained(
                        width: scaledImageWidth,
                        height: scaledImageHeight,
                      )
                      .gestures(
                        onTap: () => onTap?.call(e.link),
                      ),
                ),
                if (!last)
                  SizedBox(
                    width: blockConfig.horozontalSpacing,
                  )
              ];
            },
          )
          .expand((element) => element)
          .toList(),
    ).padding(
      horizontal: scaledPaddingHorizontal,
      vertical: scaledPaddingVertical,
    );
  }
}
