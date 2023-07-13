import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/image_widget.dart';

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
      return ImageWidget(
        imageUrl: items.first.imageUrl,
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
    return items
        .map((e) => ImageWidget(
              imageUrl: e.imageUrl,
              width: scaledImageWidth,
              height: scaledImageHeight,
            )
                .gestures(
                  onTap: () => onTap?.call(e.link),
                )
                .expanded())
        .toList()
        .toRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          separator: SizedBox(
            width: blockConfig.horozontalSpacing,
          ),
        )
        .padding(
          horizontal: scaledPaddingHorizontal,
          vertical: scaledPaddingVertical,
        );
  }
}
