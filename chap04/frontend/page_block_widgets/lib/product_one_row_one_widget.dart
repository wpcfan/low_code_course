import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/image_widget.dart';

class ProductOneRowOneWidget extends StatelessWidget {
  final Product product;
  final BlockConfig config;

  const ProductOneRowOneWidget({
    super.key,
    required this.product,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalSpacing = config.horozontalSpacing ?? 0;
    final verticalSpacing = config.verticalSpacing ?? 0;
    final verticalPadding = config.verticalPadding ?? 0;
    final horizontalPadding = config.horizontalPadding ?? 0;
    final blockWidth = config.blockWidth ?? 0;
    final blockHeight = config.blockHeight ?? 0;
    final innerBlockWidth = blockWidth - 2 * horizontalPadding;
    final innerBlockHeight = blockHeight - 2 * verticalPadding;
    page({required Widget child}) => child
        .padding(horizontal: horizontalPadding, vertical: verticalPadding)
        .constrained(width: blockWidth, height: blockHeight);
    // 左边是图片，图片是正方形，所以边长是 innerBlockHeight
    final left = ImageWidget(
      imageUrl: product.imageUrl ?? '',
      width: innerBlockHeight,
      height: innerBlockHeight,
    ).padding(right: horizontalSpacing);

    final name = Text(
      product.name ?? '',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      softWrap: true,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ).padding(bottom: verticalSpacing);

    final desciption = Text(
      product.description ?? '',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
      softWrap: false,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    // 商品原价：划线价
    final productOriginalPrice = product.originalPrice != null
        ? product.originalPrice!.lineThru().alignment(Alignment.centerRight)
        : null;
    // 商品价格
    final price = (product.price ?? '')
        .toPriceWithDecimalSize()
        .padding(left: horizontalSpacing);
    // 购物车按钮
    const buttonSize = 24.0;
    final cartBtn = const Icon(
      Icons.add_shopping_cart,
      color: Colors.white,
    )
        .rounded(size: buttonSize, color: Colors.red)
        .padding(left: horizontalSpacing);

    final thirdRow = [
      productOriginalPrice,
      price,
      cartBtn,
    ]

        /// 过滤掉null, whereType<T>()返回的是一个Iterable<T>
        /// toList()将Iterable<T>转换为List<T>
        /// toRow()将List<T>转换为Row
        .whereType<Widget>()
        .toList()
        .toRow(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          mainAxisAlignment: MainAxisAlignment.end,
          textBaseline: TextBaseline.alphabetic,
        );

    final nameAndDescColumn = [
      name,
      desciption,
    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
    );

    final right = [
      nameAndDescColumn,
      thirdRow,
    ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        )
        .expanded();

    return [
      left,
      right,
    ].toRow().parent(page);
  }
}
