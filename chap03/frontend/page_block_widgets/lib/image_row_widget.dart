import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/image_widget.dart';

/// 图片行组件
/// 用于展示一行图片
/// 一行图片的数量可以是 1、2、3、或更多
/// 当数量为 1 时，图片会铺满整行
/// 当数量为 2 或 3 时，图片会平分整行
/// 当数量大于 3 时，图片会以横向滚动的方式展示
class ImageRowWidget extends StatelessWidget {
  // 图片列表
  final List<ImageData> items;
  // 区块配置
  final BlockConfig blockConfig;
  // 设计稿的屏幕宽度
  final double baselineScreenWidth;
  // 一行最多完整显示几张图
  final int numDisplayed;
  // 需要露出一部分的图的比例
  final double fracDisplayed;
  // 点击事件
  final Function(MyLink)? onTap;

  const ImageRowWidget({
    super.key,
    required this.items,
    required this.blockConfig,
    this.baselineScreenWidth = 375.0,
    this.numDisplayed = 3,
    this.fracDisplayed = 0,
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
    final scaledHorozontalSpacing =
        (blockConfig.horozontalSpacing ?? 0) * scaleFactor;
    // 实际设备上的区块内宽度
    final scaledBlockWidth = screenWidth - (2 * scaledPaddingHorizontal);
    final scaledBlockHeight = (blockConfig.blockHeight ?? 0) * scaleFactor;
    // 间距的数量
    // 如果 fracDisplayed > 0，那么最后一张图会露出一部分，所以需要多一个间距
    final numOfSpacing = fracDisplayed > 0 && items.length > numDisplayed
        ? numDisplayed
        : items.length - 1;
    // 图片的数量
    // 如果 fracDisplayed > 0，那么最后一张图会露出一部分，所以需要使用小数
    final double numOfImages = fracDisplayed > 0 && items.length > numDisplayed
        ? numDisplayed + fracDisplayed
        : items.length.toDouble();
    final scaledImageWidth =
        (scaledBlockWidth - numOfSpacing * scaledHorozontalSpacing) /
            numOfImages;
    final scaledImageHeight = scaledBlockHeight - (2 * scaledPaddingVertical);

    /// 构建外层容器，未来会包含背景色、边框、内边距
    /// 用于控制整个组件的大小
    /// 注意这是一个函数，一般我们构建完内层组件后，会调用它来构建外层组件
    /// 使用上，内层如果是 child，那么可以通过 child.parent(page) 来构建外层
    page({required Widget child}) => child
        .padding(
            horizontal: scaledPaddingHorizontal,
            vertical: scaledPaddingVertical)
        .constrained(width: screenWidth, height: scaledBlockHeight);
    // 构建图片组件，减少重复代码
    Widget buildImageWidget(ImageData imageData) => ImageWidget(
          imageUrl: imageData.imageUrl,
          width: scaledImageWidth,
          height: scaledImageHeight,
        ).gestures(onTap: () => onTap?.call(imageData.link));

    // 一行一张图
    if (items.length == 1) {
      return buildImageWidget(items.first).parent(page);
    }

    // 一行多张可滚动
    if (items.length > numDisplayed) {
      return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) => buildImageWidget(items[index]),
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: scaledHorozontalSpacing),
      ).parent(page);
    }
    // 一行二，三张图
    return items
        .map((e) => buildImageWidget(e))
        .toList()
        .toRow(
          separator: SizedBox(
            width: scaledHorozontalSpacing,
          ),
        )
        .parent(page);
  }
}
